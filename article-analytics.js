/**
 * Visit recording for the search articles.
 *
 * Uses the same browser ids as the directory (mh_session_id, mh_user_pseudo_id)
 * so a person who continues into the directory stays one visitor.
 * Sends the referrer host and path only — never the query string — and never sets a cookie.
 * Failures are ignored. A person reading the page should not wait on this.
 */
(function () {
  var ENDPOINT = '/api/analytics';

  function uuid() {
    if (window.crypto && window.crypto.randomUUID) return window.crypto.randomUUID();
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
      var r = (Math.random() * 16) | 0;
      var v = c === 'x' ? r : (r & 0x3) | 0x8;
      return v.toString(16);
    });
  }

  function storedId(store, key) {
    try {
      var id = store.getItem(key);
      if (!id) {
        id = uuid();
        store.setItem(key, id);
      }
      return id;
    } catch (e) {
      return uuid();
    }
  }

  function referrerParts() {
    if (!document.referrer) return { domain: null, path: null };
    try {
      var u = new URL(document.referrer);
      return {
        domain: u.hostname || null,
        path: (u.pathname || '/').slice(0, 500)
      };
    } catch (e) {
      return { domain: null, path: null };
    }
  }

  function utm() {
    try {
      var params = new URLSearchParams(window.location.search);
      return {
        utm_source: params.get('utm_source') || null,
        utm_medium: params.get('utm_medium') || null,
        utm_campaign: params.get('utm_campaign') || null
      };
    } catch (e) {
      return { utm_source: null, utm_medium: null, utm_campaign: null };
    }
  }

  function send(eventType, props) {
    try {
      var ref = referrerParts();
      var tags = utm();
      var lang = document.documentElement.lang === 'en' ? 'en' : 'he';
      var payload = {
        event_id: uuid(),
        event_type: eventType,
        occurred_at: new Date().toISOString(),
        page_url: window.location.href,
        page_title: document.title || null,
        referrer_domain: ref.domain,
        referrer_path: ref.path,
        utm_source: tags.utm_source,
        utm_medium: tags.utm_medium,
        utm_campaign: tags.utm_campaign,
        session_id: storedId(sessionStorage, 'mh_session_id'),
        user_pseudo_id: storedId(localStorage, 'mh_user_pseudo_id'),
        user_agent: navigator.userAgent,
        viewport_width: window.innerWidth,
        viewport_height: window.innerHeight,
        section: 'guide',
        element_id: props.element_id || null,
        element_type: props.element_type || null,
        element_text_short: props.element_text_short || null,
        ui_lang: lang
      };
      var body = JSON.stringify(payload);
      var queued = false;
      if (navigator.sendBeacon) {
        try {
          queued = navigator.sendBeacon(ENDPOINT, new Blob([body], { type: 'application/json' }));
        } catch (e) {
          queued = false;
        }
      }
      if (!queued) {
        fetch(ENDPOINT, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: body,
          keepalive: true
        }).catch(function () {});
      }
    } catch (e) {}
  }

  function destination(href) {
    try {
      var u = new URL(href, window.location.href);
      if (u.protocol !== 'http:' && u.protocol !== 'https:') return null;
      if (u.hostname === window.location.hostname) return (u.pathname || '/').slice(0, 500);
      return u.hostname.slice(0, 255);
    } catch (e) {
      return null;
    }
  }

  send('page_view', {});

  document.addEventListener('click', function (ev) {
    var node = ev.target;
    var link = node && node.closest ? node.closest('a[href]') : null;
    if (!link) return;
    var href = link.getAttribute('href');
    if (!href || href.charAt(0) === '#') return;
    var dest = destination(href);
    if (!dest) return;
    var text = (link.textContent || '').replace(/\s+/g, ' ').trim().slice(0, 120);
    send('click', {
      element_id: dest,
      element_type: 'guide_nav',
      element_text_short: text || null
    });
  }, true);
})();
