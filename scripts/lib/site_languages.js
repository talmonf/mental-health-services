/**
 * Decides whether a link is the same page in another language, or only a language menu.
 * A generic English homepage is not the translation of a deeper Hebrew page.
 */

const SITE_LANGUAGE_CODES = ['he', 'en', 'ar', 'ru', 'fr', 'am'];
const SITE_URL_KEYS = ['web', 'web2', 'add', 'add2', 'add3'];

const SOCIAL = /(?:^|\.)(?:facebook|fb|instagram|linkedin|youtube|youtu\.be|wa\.me|whatsapp|t\.me|twitter|x|tiktok)\./i;

const LANG_NAMES = {
  english: 'en', אנגלית: 'en',
  hebrew: 'he', עברית: 'he',
  arabic: 'ar', العربية: 'ar', عربي: 'ar', ערבית: 'ar',
  russian: 'ru', русский: 'ru', רוסית: 'ru',
  amharic: 'am', አማርኛ: 'am', אמהרית: 'am',
  french: 'fr', français: 'fr', francais: 'fr', צרפתית: 'fr',
  spanish: 'es', español: 'es', espanol: 'es', ספרדית: 'es',
  german: 'de', deutsch: 'de', גרמנית: 'de',
};

function nameToLang(text) {
  const t = String(text || '').replace(/\s+/g, ' ').trim().toLowerCase();
  if (!t || t.length > 40) return '';
  if (LANG_NAMES[t]) return LANG_NAMES[t];
  if (/^[a-z]{2,3}$/.test(t)) return t;
  return '';
}

function isHttp(url) {
  return /^https?:\/\//i.test(String(url || '').trim());
}

function isSocial(url) {
  try {
    const host = new URL(url).hostname;
    return SOCIAL.test(host) || SOCIAL.test(url);
  } catch {
    return false;
  }
}

function siteHost(hostname) {
  return String(hostname || '')
    .toLowerCase()
    .replace(/^www\./, '')
    .replace(/^(en|english|ar|ru|fr|he|iw)\./, '');
}

function parsed(url) {
  const u = new URL(url);
  const path = decodeURIComponent(u.pathname).replace(/\/+$/, '');
  return {
    href: u.href,
    host: u.hostname.toLowerCase(),
    site: siteHost(u.hostname),
    path: path.toLowerCase(),
    parts: path.split('/').filter(Boolean),
  };
}

/** A language root or a language-menu homepage, not an article. A query such as CategoryID keeps the page specific. */
function isGenericLanguageHome(url) {
  let u;
  try { u = new URL(url); } catch { return false; }
  const meaningful = [...u.searchParams.keys()].some((key) => !/^(lang|language|locale)$/i.test(key));
  if (meaningful) return false;
  let info;
  try { info = parsed(url); } catch { return false; }
  const parts = info.path.split('/').filter(Boolean);
  if (parts.length === 0) return true;
  const joined = parts.join('/');
  if (/homepage/.test(joined) || /home-page/.test(joined) || /home\s*page/.test(joined) || /main_(english|arabic|russian|hebrew|french)/.test(joined) || joined.endsWith('home.aspx')) return true;
  if (parts.length <= 2 && /index\.aspx$/.test(joined)) return true;
  if (parts.length === 1 && /^(en|he|iw|ar|ru|fr|am|eng|english|hebrew|arabic)$/i.test(parts[0])) return true;
  if (parts.length === 2 && /^(en|he|iw|ar|ru|fr|am|eng|english|hebrew)$/i.test(parts[0])
    && /^(home|index|default\.aspx|homepage)$/i.test(parts[1])) return true;
  if (/^pages\/default\.aspx$/i.test(joined) && /english/.test(info.path)) return true;
  return false;
}

function strippedPath(url) {
  try {
    const info = parsed(url);
    return info.path.split('/').filter(Boolean)
      .filter((part) => !/^(en|he|iw|ar|ru|fr|am|eng|english|hebrew|arabic)$/i.test(part))
      .join('/');
  } catch {
    return '';
  }
}

/** The same page with only a language segment added, removed, or swapped. */
function pathsCorrespond(a, b) {
  if (isGenericLanguageHome(a) && isGenericLanguageHome(b)) return true;
  const left = strippedPath(a);
  const right = strippedPath(b);
  return !!(left && right && left === right);
}

/** An English "about" or hospital front page, not a translated article. */
function isShallowLanding(url) {
  const path = strippedPath(url);
  if (!path) return true;
  if (/^(about|about-us|home|index|default\.aspx|pages\/default\.aspx)$/i.test(path)) return true;
  if (/pages\/default\.aspx$/i.test(path) && path.split('/').length <= 3) return true;
  if (/\/about(\/|$)/i.test(`/${path}`) && path.split('/').length <= 4) return true;
  return false;
}

function titleLooksHebrew(title) {
  const he = (String(title || '').match(/[\u0590-\u05FF]/g) || []).length;
  const lat = (String(title || '').match(/[A-Za-z]/g) || []).length;
  return he >= 2 && lat < 2;
}

function sameSite(a, b) {
  try { return parsed(a).site === parsed(b).site; } catch { return false; }
}

function urlKey(url) {
  try {
    const info = parsed(url);
    return `${info.site}${info.path}`;
  } catch {
    return String(url || '');
  }
}

/** Host and path, keeping a language subdomain such as en.example. */
function exactKey(url) {
  try {
    const u = new URL(url);
    const host = u.hostname.replace(/^www\./i, '').toLowerCase();
    const path = decodeURIComponent(u.pathname).replace(/\/+$/, '').toLowerCase();
    return `${host}${path}`;
  } catch {
    return String(url || '');
  }
}

/**
 * Path and host swaps worth fetching. en. subdomain is only proposed for a language home,
 * because probing it on every deep page mostly hits dead hosts.
 */
function swapCandidates(url) {
  let info;
  try { info = parsed(url); } catch { return []; }
  const u = new URL(url);
  const out = [];
  const seen = new Set([exactKey(url)]);
  const add = (next) => {
    const key = exactKey(next);
    if (!next || !key || seen.has(key)) return;
    seen.add(key);
    out.push(next);
  };
  if (/\/he(?=\/|$)/i.test(u.pathname)) {
    const n = new URL(u.href);
    n.pathname = u.pathname.replace(/\/he(?=\/|$)/gi, '/en');
    add(n.href);
  }
  if (/\/iw(?=\/|$)/i.test(u.pathname)) {
    const n = new URL(u.href);
    n.pathname = u.pathname.replace(/\/iw(?=\/|$)/gi, '/en');
    add(n.href);
  }
  if (isGenericLanguageHome(url)) {
    const bare = u.hostname.replace(/^www\./i, '');
    if (!/^(en|english)\./i.test(bare)) {
      const n = new URL(u.href);
      n.hostname = `en.${bare}`;
      if (/^\/(he|iw)(?=\/|$)/i.test(n.pathname)) n.pathname = n.pathname.replace(/^\/(he|iw)(?=\/|$)/i, '') || '/';
      add(n.href);
    }
    const root = new URL(u.origin + '/en/');
    add(root.href);
  }
  return [...new Set(out)];
}

function looksEnglish(url) {
  try {
    const info = parsed(url);
    if (/^(en|english)\./.test(info.host)) return true;
    if (/(^|\/)(en|english)(\/|$)/.test(info.path)) return true;
    if (/english[\s_-]*home/.test(info.path) || /main_english/.test(info.path)) return true;
    return false;
  } catch {
    return false;
  }
}

/**
 * The fetched page is an English document and did not bounce back to the Hebrew URL
 * or to a generic home when the Hebrew page was a specific one.
 */
function englishPageOk(hebrewUrl, candidateUrl, fetched) {
  if (!fetched || fetched.fetch !== 'ok') return { ok: false, reason: fetched && fetched.fetch ? fetched.fetch : 'unfetched' };
  const finalUrl = fetched.finalUrl || candidateUrl;
  const lang = fetched.pageLang || '';
  if (exactKey(finalUrl) === exactKey(hebrewUrl)) {
    if (titleLooksHebrew(fetched.title)) return { ok: false, finalUrl, reason: 'hebrew-title' };
    if (lang === 'en' || looksEnglish(finalUrl)) return { ok: true, finalUrl, reason: 'verified' };
    return { ok: false, reason: 'bounced-to-hebrew' };
  }
  if (isGenericLanguageHome(finalUrl) && !isGenericLanguageHome(hebrewUrl)) {
    return { ok: false, reason: 'generic-home' };
  }
  if (!sameSite(finalUrl, hebrewUrl)) return { ok: false, reason: 'other-site' };
  if (titleLooksHebrew(fetched.title)) return { ok: false, reason: 'hebrew-title' };
  if (lang === 'he' && !looksEnglish(finalUrl)) return { ok: false, reason: 'still-hebrew' };
  if (lang && lang !== 'en' && lang !== 'he') return { ok: false, reason: `page-${lang}` };
  if (lang === 'en' || looksEnglish(finalUrl)) return { ok: true, finalUrl, reason: 'verified' };
  return { ok: false, reason: 'not-english' };
}

/**
 * Structural class before the fetch. generic-home is never the translation of a deeper page.
 * same-page is a candidate, still confirmed by englishPageOk.
 */
function classifyAlternate(hebrewUrl, englishUrl, source) {
  if (!isHttp(englishUrl) || isSocial(englishUrl)) return 'skip';
  if (!sameSite(hebrewUrl, englishUrl) && source !== 'hreflang') return 'other-site';
  if (isGenericLanguageHome(englishUrl) && !isGenericLanguageHome(hebrewUrl)) return 'generic-home';
  if (source === 'hreflang' && !isGenericLanguageHome(englishUrl)) return 'same-page';
  if (source === 'swap') return 'same-page';
  if (source === 'card-label' && !isGenericLanguageHome(englishUrl)) return 'same-page';
  if (isGenericLanguageHome(hebrewUrl) && isGenericLanguageHome(englishUrl)) return 'same-page';
  if (urlKey(hebrewUrl) === urlKey(englishUrl)) return 'same-page';
  if (source === 'link-text' && !isGenericLanguageHome(englishUrl)) return 'same-page';
  return 'generic-home';
}

module.exports = {
  SITE_LANGUAGE_CODES,
  SITE_URL_KEYS,
  nameToLang,
  isHttp,
  isSocial,
  isGenericLanguageHome,
  strippedPath,
  pathsCorrespond,
  isShallowLanding,
  titleLooksHebrew,
  sameSite,
  urlKey,
  exactKey,
  swapCandidates,
  looksEnglish,
  englishPageOk,
  classifyAlternate,
};
