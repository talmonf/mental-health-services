#!/usr/bin/env node
/**
 * Pre-renders the directory as static HTML.
 *
 * Why this exists: index.html transpiles its JSX in the browser with Babel standalone, so
 * anything that does not execute JavaScript sees an empty <div id="root">. That is every
 * AI crawler. These pages put the content in the HTML source.
 *
 *   node scripts/build_pages.js            build
 *   node scripts/build_pages.js --check    build into a temp dir and diff (CI / pre-commit)
 *   node scripts/build_pages.js --clean    remove generated output
 *
 * Output (all generated, all gitignored):
 *   /s/<row>            one per entry
 *   /c/<category>       one per category, /c/<category>/<subsection> for treatments
 *   /term/<slug>        one per glossary term, /terms index
 *   /directory          hub linking everything, so nothing is more than two hops from the root
 *   /emergency, /treatment, /rights, /support, /information
 *                       the app itself (a copy of index.html) with that group's own title,
 *                       description and canonical, plus a static article — h1, intro and the
 *                       services — so the text is in the HTML source without JavaScript.
 *                       Slugs come from MH_GROUP_SLUGS. The intro text lives on CATEGORY_GROUPS.
 *   /g/<group>          not generated. vercel.json permanently redirects each one to the
 *                       group page above (/g/rightsGov -> /rights). Those redirects are the
 *                       only remaining use of the old crawlable twins, so an indexed /g/ URL
 *                       lands on the app. scripts/build_pages.js asserts the map stays in sync.
 *   /sitemap.xml
 */

const fs = require('fs');
const path = require('path');
const { load, phonesOf, emailsOf, referralLabel, vocabLabel, cardIndicators, fundingLabel } = require('./lib/extract_data');
const { overlayDirectoryCards } = require('./lib/overlay_directory_cards');
const T = require('./lib/page_template');
const LD = require('./lib/jsonld');
const PRIVACY = require('./lib/privacy_page');

const ROOT = path.join(__dirname, '..');
const GENERATED_DIRS = ['s', 'c', 'g', 'term', 'terms', 'directory', 'privacy', 'emergency', 'treatment', 'rights', 'support', 'information'];
const GENERATED_FILES = ['sitemap.xml'];

// ---------------------------------------------------------------- phone parsing

// Phone fields in DATA are free text: "*6690", "כללי: 1599-510-550", "מוקד 'קשובים' 9518*",
// "*2700 | חירום: 1-700-50-70-50", even "יוסי שמעונוביץ\n054-4749809". The source string is
// always displayed verbatim; tel: links are derived from it and then asserted against it.
const PHONE_TOKEN = /(\*\s*\d{3,5})|(\d{3,5}\s*\*)|(\d[\d\-\s]{5,}\d)|(\b\d{3,4}\b)/g;

function telFromToken(token) {
  const digits = token.replace(/\D/g, '');
  if (!digits) return null;
  return /\*/.test(token) ? `*${digits}` : digits;
}

function parsePhoneField(raw) {
  const text = String(raw || '').replace(/[\u200e\u200f]/g, '').trim();
  if (!text) return { text: '', tokens: [] };
  const tokens = [];
  for (const m of text.matchAll(PHONE_TOKEN)) {
    const tel = telFromToken(m[0]);
    if (tel && !tokens.some((t) => t.tel === tel)) tokens.push({ display: m[0].trim(), tel });
  }
  return { text, tokens };
}

/** Digits-and-star signature, used to prove an emitted tel: came from the source string. */
const signature = (s) => String(s || '').replace(/[^\d*]/g, '');

// ---------------------------------------------------------------- text helpers

const { escapeHtml: esc, starCodesHtml, linkifyNotes, paragraphs, startsWithLatin, truncate } = T;

function isoDate(ddmmyyyy) {
  const m = String(ddmmyyyy || '').match(/^(\d{2})\.(\d{2})\.(\d{4})$/);
  return m ? `${m[3]}-${m[2]}-${m[1]}` : '';
}

function firstSentence(text) {
  const t = String(text || '')
    .replace(/\[([^\]]+)\]\((https?:\/\/[^)\s]+)\)/g, '$1')
    .replace(/([^\s]+)[ \t]+https?:\/\/\S+/g, '$1')
    .replace(/\s+/g, ' ')
    .trim();
  const m = t.match(/^(.{20,}?[.!?])\s/);
  return m ? m[1] : t;
}

/** Public path of a group: /rights, not /g/rightsGov. vercel.json redirects the old path. */
function groupPath(ctx, groupId) {
  const slug = (ctx.MH_GROUP_SLUGS || {})[groupId];
  return slug ? `/${slug}` : '';
}

/**
 * Meta description, generated from the structured fields rather than hand-written.
 * Coverage is uneven — target is present on 45/197 entries, cost on 57 — so this walks a
 * fallback ladder and degrades to name-plus-service rather than inventing anything.
 */
function entryDescription(entry, categoryTitle) {
  const svc = entry.svc.replace(/\s+/g, ' ').trim();
  const parts = [];
  parts.push(svc ? `${entry.org} — ${svc}` : entry.org);

  const r = entry.raw;
  const facets = [];
  if (r.target && r.target.trim()) facets.push(`מיועד ל: ${r.target.trim()}`);
  if (r.region && r.region.trim()) facets.push(r.region.trim());
  if (r.cost && r.cost.trim()) facets.push(`עלות: ${r.cost.trim()}`);
  if (facets.length) parts.push(facets.join(' · '));

  let out = parts.join('. ');
  if (out.length < 70 && r.notes && r.notes.trim()) out += `. ${firstSentence(r.notes)}`;
  if (out.length < 40 && categoryTitle) out += `. ${categoryTitle} — מדריך נפש`;
  return truncate(out, 155);
}

/**
 * Title rule from the plan: never lead a Hebrew title with Latin text or a digit, because
 * <title> carries no markup and bidi reordering makes the result unreadable in a SERP.
 * Fully English entries (dir: 'ltr' in DATA) get an English title and lead with Latin,
 * which is correct for them.
 */
function entryTitle(entry) {
  const svc = truncate(entry.svc.replace(/\s+/g, ' '), 60);
  const org = entry.org.replace(/\s+/g, ' ').trim();
  if (entry.raw.dir === 'ltr') return `${org} — ${svc} | Nefesh Israel Mental Health Directory`;
  if (startsWithLatin(org)) return `נפש · ${org} — ${svc}`;
  return svc ? `${org} — ${svc} | מדריך נפש` : `${org} | מדריך נפש`;
}

// ---------------------------------------------------------------- entry page

// Same rule as mhRegionCoveredByAddress in index.html: one address that already
// names every place in אזור means the line is not shown.
function normPlace(s) {
  return String(s || '').replace(/\s+/g, ' ').trim();
}

function regionPlaces(region) {
  return normPlace(region).replace(/[()]/g, ' ').split(/[,;]| ו-|\sו/).map((t) => t.trim()).filter((t) => t.length > 1);
}

function containsPlace(haystack, place) {
  const text = normPlace(haystack);
  const needle = normPlace(place);
  if (!text || !needle) return false;
  if (text === needle) return true;
  const escaped = needle.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  return new RegExp(`(^|[^א-תA-Za-z0-9])${escaped}($|[^א-תA-Za-z0-9])`).test(text);
}

function regionCoveredByAddress(region, address) {
  const place = normPlace(region);
  const street = normPlace(address);
  if (!place || !street) return false;
  const parts = regionPlaces(region);
  return parts.length > 0 && parts.every((p) => street.includes(p));
}

function regionCoveredByBranches(region, locs) {
  if (!Array.isArray(locs) || locs.length < 2) return false;
  const places = regionPlaces(region);
  if (places.length < 2) return false;
  const labels = locs.map((loc) => normPlace(loc && loc.label)).filter(Boolean);
  if (labels.length !== locs.length) return false;
  const covered = new Set();
  for (const label of labels) {
    const hits = places.filter((place) => containsPlace(label, place));
    if (hits.length !== 1) return false;
    covered.add(hits[0]);
  }
  return places.every((place) => covered.has(place));
}

function sitesFor(entry, ctx) {
  const raw = (entry && entry.raw) || {};
  if (Array.isArray(raw.cardSites) && raw.cardSites.length) return raw.cardSites;
  const table = (ctx && ctx.ENTRY_LOCATIONS) || {};
  return table[String(entry.row)] || table[entry.row] || [];
}

function phoneDigits(s) {
  return String(s || '').replace(/\D/g, '');
}

function phoneRole(label) {
  return /מוקד|כללי|הנהלה|קו סיוע/.test(String(label || ''));
}

function placeHead(label) {
  return normPlace(label).split(/[·•—–\-|:]/)[0].trim();
}

function cardPhoneHiddenByBranch(label, number, locs) {
  if (!label || phoneRole(label)) return false;
  const head = placeHead(label);
  const digits = phoneDigits(number);
  if (head.length < 2 || !digits) return false;
  return (locs || []).some((loc) => phoneDigits(loc && loc.phone) === digits && (containsPlace(loc.label, head) || containsPlace(head, loc.label)));
}

function branchEmailGroups(locs) {
  const groups = [];
  const index = new Map();
  (locs || []).forEach((loc) => {
    const address = String((loc && loc.email) || '').trim();
    if (!address) return;
    const key = address.toLowerCase();
    if (!index.has(key)) {
      const row = { address, labels: [] };
      index.set(key, row);
      groups.push(row);
    }
    const label = normPlace(loc.label);
    if (label) index.get(key).labels.push(label);
  });
  return groups;
}

function branchPhones(locs) {
  return (locs || [])
    .map((loc) => ({ label: normPlace(loc && loc.label), phone: String((loc && loc.phone) || '').trim() }))
    .filter((row) => row.phone);
}

function cardHasEmail(raw, address) {
  const want = String(address || '').trim().toLowerCase();
  if (!want) return false;
  return ['', '2', '3'].some((suffix) => String(raw[`email${suffix}`] || '').trim().toLowerCase() === want);
}

const FIELD_LABELS = [
  ['target', 'קהל יעד'],
  ['region', 'אזור'],
  ['cost', 'עלות'],
  ['specialty', 'התמחות'],
  ['diseases', 'מצבים'],
  ['languages', 'שפות'],
];

function mapsUrl(loc) {
  const lat = Number(loc && loc.lat);
  const lng = Number(loc && loc.lng);
  const name = String((loc && (loc.address || loc.label)) || '').trim();
  const hasCoords = Number.isFinite(lat) && Number.isFinite(lng);
  if (hasCoords && name) return `https://www.google.com/maps?q=${encodeURIComponent(`${lat},${lng} (${name})`)}`;
  if (hasCoords) return `https://www.google.com/maps?q=${lat},${lng}`;
  if (!name) return '';
  return `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(name)}`;
}

const PHONE_ICON = '<svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true"><path fill="currentColor" d="M6.6 10.8c1.4 2.8 3.8 5.1 6.6 6.6l2.2-2.2c.3-.3.7-.4 1-.2 1.1.4 2.3.6 3.6.6.6 0 1 .4 1 1V20c0 .6-.4 1-1 1C10.6 21 3 13.4 3 4c0-.6.4-1 1-1h3.5c.6 0 1 .4 1 1 0 1.3.2 2.5.6 3.6.1.4 0 .7-.3 1L6.6 10.8z"/></svg>';
const MAP_ICON = '<svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true"><path fill="currentColor" d="M12 2C8.1 2 5 5.1 5 9c0 5.2 7 13 7 13s7-7.8 7-13c0-3.9-3.1-7-7-7zm0 9.5c-1.4 0-2.5-1.1-2.5-2.5S10.6 6.5 12 6.5s2.5 1.1 2.5 2.5S13.4 11.5 12 11.5z"/></svg>';

function copyButton(value, aria) {
  return `<button type="button" class="copy-email" data-copy-text="${esc(value)}" data-copy-idle="העתקה" data-copy-done="הועתק" aria-label="${esc(aria)}">העתקה</button>`;
}

function renderContact(entry, emitted, sites) {
  const r = entry.raw;
  const locs = sites || [];
  const items = [];

  for (const p of phonesOf(entry.raw)) {
    if (cardPhoneHiddenByBranch(p.label, p.number, locs)) continue;
    const parsed = parsePhoneField(p.number);
    // Record every tel: we emit, so the build can prove it came from DATA and so the
    // JSON-LD can only ever claim numbers the visible page actually renders.
    for (const tok of parsed.tokens) emitted.push({ entry, slot: p.slot, source: p.number, tel: tok.tel });
    const links = parsed.tokens.map((t) => `<a href="tel:${esc(t.tel)}">${starCodesHtml(t.display)}</a>`).join(' · ');
    const label = p.label ? `<span class="label">${esc(p.label)}: </span>` : '';
    // The published wording stays. A short code is shown with the star first so Hebrew
    // does not move it. Only when the field is nothing but the number itself is the bare
    // link enough; anything else keeps the wording and gets the links appended.
    const isBareNumber = parsed.tokens.length === 1 && parsed.text === parsed.tokens[0].display;
    const body = isBareNumber
      ? links
      : `${starCodesHtml(parsed.text)}${links ? ` <span class="label">(${links})</span>` : ''}`;
    items.push(`<li>${label}${body}</li>`);
  }

  if (r.whatsapp) {
    const digits = String(r.whatsapp).replace(/\D/g, '');
    const label = r.whatsappLabel ? esc(r.whatsappLabel) : 'WhatsApp';
    items.push(`<li><span class="label">WhatsApp: </span><a href="https://wa.me/${esc(digits)}" rel="nofollow">${label}</a></li>`);
  }
  const emailGroups = branchEmailGroups(locs);
  for (const mail of emailsOf(r)) {
    if (emailGroups.length > 1 && emailGroups.some((g) => g.address.toLowerCase() === mail.address.toLowerCase())) continue;
    const linkText = mail.label || mail.address;
    const prefix = mail.label ? '' : '<span class="label">דוא"ל: </span>';
    items.push(`<li>${prefix}<a href="mailto:${esc(mail.address)}">${esc(linkText)}</a></li>`);
  }
  if (emailGroups.length === 1 && !cardHasEmail(r, emailGroups[0].address)) {
    items.push(`<li><span class="label">דוא"ל: </span><a href="mailto:${esc(emailGroups[0].address)}">${esc(emailGroups[0].address)}</a></li>`);
  }
  if (emailGroups.length > 1) {
    const rows = emailGroups.map((g) => {
      const address = esc(g.address);
      return `<li class="email-option"><span class="email-text"><span>${esc(g.labels.join(', '))}</span><span class="email-address" dir="ltr">${address}</span></span><span class="email-actions"><a class="send-email" href="mailto:${address}" aria-label="שליחת דוא״ל אל ${address}"><svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true"><path fill="currentColor" d="M20 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4-8 5L4 8V6l8 5 8-5v2z"/></svg></a>${copyButton(g.address, `העתקת ${g.address}`)}</span></li>`;
    }).join('');
    items.push(`<li><details><summary>דוא״ל</summary><ul>${rows}</ul></details></li>`);
  }
  const sitePhones = branchPhones(locs);
  if (sitePhones.length > 1) {
    const rows = sitePhones.map((row) => {
      const parsed = parsePhoneField(row.phone);
      for (const tok of parsed.tokens) emitted.push({ entry, slot: 'site', source: row.phone, tel: tok.tel });
      const shown = parsed.tokens[0] ? parsed.tokens[0].display : row.phone;
      const tel = parsed.tokens[0] ? parsed.tokens[0].tel : '';
      const dial = tel ? `<a class="send-phone" href="tel:${esc(tel)}" aria-label="חיוג אל ${esc(shown)}">${PHONE_ICON}</a>` : '';
      return `<li class="email-option"><span class="email-text"><span>${esc(row.label)}</span><span class="email-address" dir="ltr">${starCodesHtml(shown)}</span></span><span class="email-actions">${dial}${copyButton(shown, `העתקת ${shown}`)}</span></li>`;
    }).join('');
    items.push(`<li><details><summary>טלפון</summary><ul>${rows}</ul></details></li>`);
  }
  for (const [urlKey, labelKey, fallback] of [['web', 'webLabel', 'אתר הארגון'], ['web2', 'webLabel2', 'קישור נוסף'], ['add', 'addLabel', 'מידע נוסף']]) {
    const url = r[urlKey];
    if (!url || !/^https?:\/\//.test(url)) continue;
    const label = r[labelKey] ? esc(r[labelKey]) : fallback;
    items.push(`<li><span class="label">${fallback === 'אתר הארגון' ? 'אתר' : 'קישור'}: </span><a href="${esc(url)}" rel="nofollow noopener">${label}</a></li>`);
  }

  return items.length ? `<h2>יצירת קשר</h2><ul class="contact">${items.join('')}</ul>` : '';
}

function renderIndicatorBadges(entry) {
  const ind = cardIndicators(entry.raw);
  if (!ind || (!ind.offers.length && !ind.wholeOrg)) return '';
  const lang = entry.raw.dir === 'ltr' ? 'en' : 'he';
  const badges = [];
  if (ind.wholeOrg) badges.push(lang === 'en' ? 'Organization overview' : 'כרטיס כללי של הארגון');
  if (ind.infoOnly) badges.push(lang === 'en' ? 'Information only' : 'מידע בלבד');
  else ind.offers.forEach((code) => badges.push(vocabLabel('card_offer', code, lang)));
  return `<p class="badges">${badges.map((b) => `<span class="badge">${esc(b)}</span>`).join('')}</p>`;
}

function renderReferralBadge(entry) {
  const codes = (entry.raw.referralCodes || []).filter((c) => c && c !== 'unknown');
  const isLtr = entry.raw.dir === 'ltr';
  const ind = cardIndicators(entry.raw);
  const fundingParts = ind ? ind.funding.map((f) => fundingLabel(f, isLtr ? 'en' : 'he')) : [];
  const referralParts = codes.includes('self_referral')
    ? [isLtr ? 'You can contact directly' : 'אפשר לפנות ישירות']
    : codes.map((c) => referralLabel(c, isLtr ? 'en' : 'he'));
  const parts = [...fundingParts, ...referralParts];
  if (!parts.length) return '';
  const heading = isLtr ? 'How to get it: ' : 'איך מקבלים: ';
  const source = codes.length ? entry.raw.referralSource : '';
  const sourceLabel = isLtr ? 'As published: ' : 'כפי שפורסם: ';
  if (!source) return `<p class="badge-ref"><strong>${esc(heading)}</strong>${esc(parts.join(' · '))}</p>`;
  return `<details class="badge-ref"><summary>${esc(heading)}${esc(parts.join(' · '))}</summary><p>${esc(sourceLabel)}${starCodesHtml(source)}</p></details>`;
}

function renderEntryPage(ctx, entry) {
  const { DATA, CATEGORY_GROUPS, LAST_UPDATED, published } = ctx;
  const primaryCat = entry.categories[0];
  const cat = DATA[primaryCat] || {};
  const groupId = Object.keys(CATEGORY_GROUPS).find((g) => CATEGORY_GROUPS[g].subcategories.includes(primaryCat));
  const group = CATEGORY_GROUPS[groupId] || {};
  const isLtr = entry.raw.dir === 'ltr';

  const trail = [
    { name: 'מדריך נפש', url: '/' },
    ...(group.title && groupPath(ctx, groupId) ? [{ name: group.title, url: groupPath(ctx, groupId) }] : []),
    ...(cat.title && !cat.unlisted ? [{ name: cat.title, url: `/c/${primaryCat}` }] : []),
    { name: entry.org, url: entry.path },
  ];

  const emitted = [];
  // LTR entries are English services inside a Hebrew document. The direction switch belongs
  // on the English content only: the section headings, breadcrumbs and sibling list are
  // Hebrew and must stay RTL. Applying it to the whole <article> left-aligns Hebrew headings.
  const ltrAttrs = isLtr ? ' lang="en" dir="ltr" class="ltr-block"' : '';
  const valueDir = isLtr ? ' dir="ltr" class="ltr-block"' : '';

  const sites = sitesFor(entry, ctx);
  const soleAddress = sites.length === 1 ? sites[0].address : '';
  const hideRegion = (soleAddress && regionCoveredByAddress(entry.raw.region, soleAddress)) || regionCoveredByBranches(entry.raw.region, sites);
  const facts = FIELD_LABELS
    .filter(([k]) => entry.raw[k] && String(entry.raw[k]).trim())
    .filter(([k]) => !(k === 'region' && hideRegion))
    .map(([k, label]) => `<div><dt>${esc(label)}</dt><dd${valueDir}>${esc(String(entry.raw[k]).replace(/\s+/g, ' ').trim())}</dd></div>`)
    .join('');

  const referralBadge = renderReferralBadge(entry);

  const locations = sites
    .map((l) => {
      const detail = l.address && l.address !== l.label ? l.address : '';
      const copyValue = detail || l.label || '';
      if (sites.length < 2) {
        const parts = [l.label];
        if (detail) parts.push(detail);
        if (l.note) parts.push(l.note);
        return `<li>${parts.map((part) => esc(part)).join(' — ')}</li>`;
      }
      const href = mapsUrl(l);
      const mapLink = href ? `<a class="send-map" href="${esc(href)}" rel="noopener" aria-label="פתיחת ${esc(l.label || copyValue)} במפה">${MAP_ICON}</a>` : '';
      return `<li class="email-option"><span class="email-text"><span>${esc(l.label || '')}</span>${detail ? `<span class="email-address">${esc(detail)}</span>` : ''}${l.note ? `<span>${esc(l.note)}</span>` : ''}</span><span class="email-actions">${mapLink}${copyButton(copyValue, `העתקת ${copyValue}`)}</span></li>`;
    })
    .join('');

  const catTags = entry.categories
    .filter((c) => DATA[c] && !DATA[c].unlisted)
    .map((c) => `<a class="tag" href="/c/${esc(c)}">${esc(DATA[c].title)}</a>`)
    .join('');

  // Siblings keep the page from being a dead end for a person who landed on the wrong entry.
  // An unlisted category has no category page, so its cards do not point at one another here.
  const siblings = cat.unlisted
    ? ''
    : published
        .filter((e) => e !== entry && e.categories.includes(primaryCat))
        .slice(0, 8)
        .map((e) => `<li><a href="${esc(e.path)}">${esc(e.org)}</a><span class="svc">${esc(truncate(e.svc, 90))}</span></li>`)
        .join('');

  const appUrl = `/?entry=${encodeURIComponent(entry.row)}&section=${encodeURIComponent(primaryCat)}`;

  const termLinks = (entry.raw.cardTerms || [])
    .filter((k) => ctx.terms[k])
    .map((k) => `<a class="tag" href="/term/${esc(termSlug(k))}">${esc(ctx.terms[k].title)}</a>`)
    .join('');

  const body = `
<article>
  <header${ltrAttrs}>
    <h1>${esc(entry.org)}</h1>
    ${renderIndicatorBadges(entry)}
    ${entry.svc ? `<p class="lede">${esc(entry.svc.replace(/\s+/g, ' '))}</p>` : ''}
  </header>
  <div class="card">
    ${referralBadge}
    ${facts ? `<dl class="facts">${facts}</dl>` : ''}
    ${renderContact(entry, emitted, sites)}
    ${entry.raw.notes && entry.raw.notes.trim() ? `<h2>הערות</h2><div class="notes"${ltrAttrs}>${paragraphs(entry.raw.notes, ctx.hiddenLinkRows)}</div>` : ''}
    ${locations ? `<h2>מיקומים</h2><ul${valueDir}>${locations}</ul>` : ''}
  </div>
  <p><a class="btn" href="${esc(appUrl)}">פתחו את הכרטיס במדריך המלא</a></p>
  ${catTags ? `<h2>קטגוריות</h2><div>${catTags}</div>` : ''}
  ${termLinks ? `<h2>מונחים קשורים</h2><div>${termLinks}</div>` : ''}
  ${siblings ? `<h2>שירותים נוספים ב${esc(cat.title || 'קטגוריה זו')}</h2><ul class="entry-list">${siblings}</ul>
  <p><a class="btn btn-secondary" href="/c/${esc(primaryCat)}">כל השירותים בקטגוריה</a></p>` : ''}
</article>`;

  // Build the markup from the numbers the page rendered, not from DATA directly, so the
  // structured data can never assert a phone number the visible page does not show.
  const telsBySlot = new Map();
  for (const e of emitted) {
    if (!telsBySlot.has(e.slot)) telsBySlot.set(e.slot, []);
    telsBySlot.get(e.slot).push(e.tel);
  }

  return {
    html: T.renderPage({
      title: entryTitle(entry),
      description: entryDescription(entry, cat.title),
      path: entry.path,
      trail,
      body,
      jsonLd: LD.serialize(LD.entryGraph(entry, { ...ctx, lastUpdatedIso: isoDate(LAST_UPDATED) }, telsBySlot, trail)),
      lastUpdated: LAST_UPDATED,
      lastUpdatedIso: isoDate(LAST_UPDATED),
    }),
    emitted,
  };
}

// ---------------------------------------------------------------- category / group / term pages

function entryListHtml(entries) {
  return entries
    .map((e) => `<li><a href="${esc(e.path)}">${esc(e.org)}</a><span class="svc">${esc(truncate(e.svc, 120))}</span></li>`)
    .join('');
}

const FILM_TYPE_LABEL = { movie: 'סרט', series: 'סדרה', doc: 'סרט תעודי', doc_series: 'סדרה תעודית' };

/**
 * Films carry Hebrew topic tags but English titles and briefs, so each block mixes
 * directions. The title and brief are marked ltr; the topic tags and the type label stay rtl.
 */
function mediaListHtml(films) {
  if (!films.length) return '';
  const items = films
    .map((f) => {
      const meta = [FILM_TYPE_LABEL[f.type] || f.type, f.year, (f.languages || []).join(', '), f.hebrewSubs]
        .filter(Boolean)
        .map((x) => esc(x))
        .join(' · ');
      const platforms = (f.platforms || [])
        .filter((p) => p && p.url)
        .map((p) => `<a href="${esc(p.url)}" rel="nofollow noopener" lang="en" dir="ltr">${esc(p.name)}</a>`)
        .join(' ');
      const topics = (f.topics || []).map((t) => `<span class="tag">${esc(t)}</span>`).join('');
      return `<li>
<strong lang="en" dir="ltr">${esc(f.title)}</strong>
<span class="svc">${meta}</span>
${f.brief ? `<span class="svc" lang="en" dir="ltr">${esc(f.brief)}</span>` : ''}
${topics ? `<span class="tags">${topics}</span>` : ''}
${platforms ? `<span class="svc">צפייה: ${platforms}</span>` : ''}
</li>`;
    })
    .join('');
  return `<h2>סרטים, סדרות ותעודיים <span class="count">(${films.length})</span></h2>
<ul class="entry-list">${items}</ul>`;
}

function renderCategoryPage(ctx, categoryId, subsectionId) {
  const { DATA, CATEGORY_GROUPS, LAST_UPDATED, published } = ctx;
  const cat = DATA[categoryId];
  const sub = subsectionId ? cat.subsections[subsectionId] : null;
  const groupId = Object.keys(CATEGORY_GROUPS).find((g) => CATEGORY_GROUPS[g].subcategories.includes(categoryId));
  const group = CATEGORY_GROUPS[groupId] || {};

  const pagePath = subsectionId ? `/c/${categoryId}/${subsectionId}` : `/c/${categoryId}`;
  const title = sub ? `${sub.title} — ${cat.title}` : cat.title;

  const members = subsectionId
    ? published.filter((e) => e.subsections.includes(`${categoryId}/${subsectionId}`))
    : published.filter((e) => e.categories.includes(categoryId));

  const subsectionLinks = !subsectionId && cat.subsections
    ? `<h2>תתי-קטגוריות</h2><ul class="entry-list">${Object.entries(cat.subsections)
        .map(([sid, s]) => {
          const n = published.filter((e) => e.subsections.includes(`${categoryId}/${sid}`)).length;
          return `<li><a href="/c/${esc(categoryId)}/${esc(sid)}">${esc(s.title)}</a> <span class="count">(${n})</span></li>`;
        })
        .join('')}</ul>`
    : '';

  // books_movies is a resource hub: it holds no service entries, so without this it would
  // render as an empty page and go into the sitemap as one. The films are real content.
  const media = !subsectionId && cat.resourceHub ? mediaListHtml(ctx.FILMS || []) : '';
  const mediaCount = !subsectionId && cat.resourceHub ? (ctx.FILMS || []).length : 0;

  const desc = truncate(
    mediaCount && !members.length
      ? `${title}${cat.desc ? ` — ${cat.desc}` : ''}. ${mediaCount} סרטים, סדרות ותעודיים על טיפול ובריאות הנפש, במדריך נפש.`
      : `${title}${cat.desc ? ` — ${cat.desc}` : ''}. ${members.length} שירותים במדריך נפש, מדריך שירותי בריאות הנפש בישראל.`,
    155
  );

  const body = `
<h1>${esc(title)}</h1>
${cat.desc ? `<p class="lede">${esc(cat.desc)}</p>` : ''}
${cat.intro ? `<div class="notes">${paragraphs(cat.intro, ctx.hiddenLinkRows)}</div>` : ''}
${subsectionLinks}
${members.length || !mediaCount ? `<h2>שירותים <span class="count">(${members.length})</span></h2>
<ul class="entry-list">${entryListHtml(members)}</ul>` : ''}
${media}
<p><a class="btn" href="/?section=${esc(categoryId)}">פתחו את הקטגוריה במדריך המלא</a></p>
`;

  const trail = [
    { name: 'מדריך נפש', url: '/' },
    ...(group.title && groupPath(ctx, groupId) ? [{ name: group.title, url: groupPath(ctx, groupId) }] : []),
    ...(subsectionId ? [{ name: cat.title, url: `/c/${categoryId}` }] : []),
    { name: title, url: pagePath },
  ];

  return T.renderPage({
    title: `${title} | מדריך נפש`,
    description: desc,
    path: pagePath,
    ogType: 'website',
    trail,
    body,
    jsonLd: LD.serialize(
      LD.collectionGraph({
        name: title,
        description: desc,
        path: pagePath,
        members,
        trail,
        lastUpdatedIso: isoDate(LAST_UPDATED),
      })
    ),
    lastUpdated: LAST_UPDATED,
    lastUpdatedIso: isoDate(LAST_UPDATED),
  });
}

/** Glossary keys are already ASCII-safe identifiers; reuse them rather than transliterating Hebrew. */
const termSlug = (key) => String(key).toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');

function renderTermPage(ctx, key, term, slugByKey) {
  const { TERM_CATEGORIES, LAST_UPDATED } = ctx;
  const cat = TERM_CATEGORIES[term.category];
  const related = (term.related || [])
    .filter((k) => slugByKey[k])
    .map((k) => `<li><a href="/term/${esc(slugByKey[k])}">${esc(ctx.terms[k].title)}</a></li>`)
    .join('');
  const services = ctx.published
    .filter((e) => (e.raw.cardTerms || []).includes(key))
    .sort((a, b) => a.org.localeCompare(b.org, 'he'))
    .map((e) => `<li><a href="${esc(e.path)}">${esc(e.org)}</a><span class="svc">${esc(truncate(e.svc, 90))}</span></li>`)
    .join('');

  const body = `
<h1>${esc(term.title)}</h1>
${cat ? `<p class="lede">${esc(cat.title)}</p>` : ''}
<div class="card">${paragraphs(term.text, ctx.hiddenLinkRows)}
${[[term.phone, term.phoneLabel], [term.phone2, term.phoneLabel2]].filter(([p]) => p).length ? `<p><strong>טלפון:</strong> ${[[term.phone, term.phoneLabel], [term.phone2, term.phoneLabel2]].filter(([p]) => p).map(([p, label]) => {
    const compact = String(p).replace(/[^\d*#]/g, '');
    const tel = /^\d{3,5}\*$/.test(compact) ? `*${compact.replace(/\D/g, '')}` : compact;
    const face = label ? `${label}: ${p}` : String(p);
    return `<a href="tel:${esc(tel)}">${starCodesHtml(face)}</a>`;
  }).join(' · ')}</p>` : ''}
${term.web ? `<p><a class="btn" href="${esc(term.web)}" rel="nofollow noopener">${esc(term.webLabel || 'לאתר')}</a></p>` : ''}
${term.web2 ? `<p><a class="btn" href="${esc(term.web2)}" rel="nofollow noopener">${esc(term.webLabel2 || 'לאתר')}</a></p>` : ''}</div>
${services ? `<h2>שירותים במדריך</h2><ul class="entry-list">${services}</ul>` : ''}
${related ? `<h2>מונחים קשורים</h2><ul class="entry-list">${related}</ul>` : ''}
<p><a class="btn btn-secondary" href="/terms">כל המונחים</a></p>
`;

  const trail = [
    { name: 'מדריך נפש', url: '/' },
    { name: 'מילון מונחים', url: '/terms' },
    { name: term.title, url: `/term/${slugByKey[key]}` },
  ];

  return T.renderPage({
    title: `${term.title} — מה זה? | מילון מונחים, מדריך נפש`,
    description: truncate(`${term.title}: ${String(term.text || '').replace(/\s+/g, ' ')}`, 155),
    path: `/term/${slugByKey[key]}`,
    trail,
    body,
    jsonLd: LD.serialize(
      LD.termGraph({
        key,
        term,
        slug: slugByKey[key],
        categoryTitle: cat ? cat.title : undefined,
        trail,
        lastUpdatedIso: isoDate(LAST_UPDATED),
      })
    ),
    lastUpdated: LAST_UPDATED,
    lastUpdatedIso: isoDate(LAST_UPDATED),
  });
}

function renderTermsIndex(ctx, slugByKey) {
  const { terms, TERM_CATEGORIES, LAST_UPDATED } = ctx;
  const byCat = {};
  for (const [k, t] of Object.entries(terms)) (byCat[t.category || 'other'] = byCat[t.category || 'other'] || []).push([k, t]);

  const sections = Object.entries(TERM_CATEGORIES)
    .filter(([cid]) => byCat[cid])
    .map(([cid, c]) => `<h2>${esc(c.title)} <span class="count">(${byCat[cid].length})</span></h2><ul class="entry-list">${byCat[cid]
      .map(([k, t]) => `<li><a href="/term/${esc(slugByKey[k])}">${esc(t.title)}</a><span class="svc">${esc(truncate(t.text, 110))}</span></li>`)
      .join('')}</ul>`)
    .join('');

  const trail = [{ name: 'מדריך נפש', url: '/' }, { name: 'מילון מונחים', url: '/terms' }];

  return T.renderPage({
    title: 'מילון מונחים בבריאות הנפש | מדריך נפש',
    description: truncate(`${Object.keys(terms).length} מונחים בבריאות הנפש בישראל: זכויות, טיפול, אשפוז, שיקום, קופות חולים ומצבים נפשיים. הסבר קצר לכל מונח.`, 155),
    path: '/terms',
    ogType: 'website',
    trail,
    body: `<h1>מילון מונחים</h1><p class="lede">${Object.keys(terms).length} מונחים שחוזרים בשירותי בריאות הנפש בישראל.</p>${sections}`,
    jsonLd: LD.serialize(
      LD.termsIndexGraph({ terms, TERM_CATEGORIES, slugByKey, trail, lastUpdatedIso: isoDate(LAST_UPDATED) })
    ),
    lastUpdated: LAST_UPDATED,
    lastUpdatedIso: isoDate(LAST_UPDATED),
  });
}

function renderPrivacyPage() {
  return T.renderPage({
    title: 'מדיניות פרטיות | מדריך נפש',
    description: 'איזה מידע האתר nefesh-il.org אוסף, למה, למי הוא מועבר, כמה זמן הוא נשמר ואיך מעיינים בו, מתקנים או מוחקים אותו.',
    path: '/privacy',
    ogType: 'website',
    trail: [{ name: 'מדריך נפש', url: '/' }, { name: 'מדיניות פרטיות', url: '/privacy' }],
    body: `${PRIVACY.HE}\n${PRIVACY.EN}`,
    lastUpdated: PRIVACY.EFFECTIVE,
    lastUpdatedIso: PRIVACY.EFFECTIVE_ISO,
  });
}

function renderDirectoryHub(ctx) {
  const { DATA, CATEGORY_GROUPS, LAST_UPDATED, published } = ctx;
  const listed = published.filter((e) => !(DATA[e.categories[0]] && DATA[e.categories[0]].unlisted));
  const categoryCount = Object.values(DATA).filter((cat) => !cat.unlisted).length;
  const groups = Object.entries(CATEGORY_GROUPS)
    .map(([gid, g]) => {
      const cats = g.subcategories
        .filter((c) => DATA[c])
        .map((c) => `<li><a href="/c/${esc(c)}">${esc(DATA[c].title)}</a> <span class="count">(${published.filter((e) => e.categories.includes(c)).length})</span></li>`)
        .join('');
      return `<h2><a href="${esc(groupPath(ctx, gid))}">${esc(g.title)}</a></h2><ul class="entry-list">${cats}</ul>`;
    })
    .join('');

  const all = [...listed]
    .sort((a, b) => a.org.localeCompare(b.org, 'he'))
    .map((e) => `<li><a href="${esc(e.path)}">${esc(e.org)}</a><span class="svc">${esc(truncate(e.svc, 90))}</span></li>`)
    .join('');

  const trail = [{ name: 'מדריך נפש', url: '/' }, { name: 'כל הקטגוריות', url: '/directory' }];
  const description = truncate(`${listed.length} שירותי בריאות נפש בישראל ב-${categoryCount} קטגוריות: עזרה דחופה, קווי סיוע, זכויות, טיפול, שיקום, משפחות ונוער.`, 155);

  return T.renderPage({
    title: 'כל הקטגוריות והשירותים | מדריך נפש',
    description,
    path: '/directory',
    ogType: 'website',
    trail,
    jsonLd: LD.serialize(
      LD.collectionGraph({
        name: 'כל הקטגוריות והשירותים',
        description,
        path: '/directory',
        members: listed,
        trail,
        lastUpdatedIso: isoDate(LAST_UPDATED),
        // The hub is where the WebSite node lives for the pre-rendered surface, so the
        // SearchAction is discoverable without JavaScript.
        extra: [LD.websiteNode()],
      })
    ),
    body: `<h1>כל הקטגוריות והשירותים</h1>
<p class="lede">${listed.length} שירותים ב-${categoryCount} קטגוריות.</p>
${groups}
<h2>כל השירותים לפי שם <span class="count">(${listed.length})</span></h2>
<ul class="entry-list">${all}</ul>`,
    lastUpdated: LAST_UPDATED,
    lastUpdatedIso: isoDate(LAST_UPDATED),
  });
}

// ---------------------------------------------------------------- group pages of the app

function wordCount(text) {
  return String(text || '').trim().split(/\s+/).filter(Boolean).length;
}

function entryMetaLine(entry, ctx) {
  const r = entry.raw;
  const sites = sitesFor(entry, ctx);
  const soleAddress = sites.length === 1 ? sites[0].address : '';
  const hideRegion = (soleAddress && regionCoveredByAddress(r.region, soleAddress)) || regionCoveredByBranches(r.region, sites);
  const bits = [];
  if (r.target && String(r.target).trim()) bits.push(`מיועד ל: ${String(r.target).trim()}`);
  if (r.region && String(r.region).trim() && !hideRegion) bits.push(String(r.region).trim());
  if (r.cost && String(r.cost).trim()) bits.push(`עלות: ${String(r.cost).trim()}`);
  if (r.specialty && String(r.specialty).trim()) bits.push(String(r.specialty).trim());
  const phones = phonesOf(r).map((p) => (p.label ? `${p.label}: ${p.number}` : p.number));
  if (phones.length) bits.push(phones.join(' · '));
  const emails = emailsOf(r).map((mail) => mail.label || mail.address);
  if (emails.length) bits.push(emails.join(' · '));
  return bits.join(' · ').replace(/\s+/g, ' ').trim();
}

function renderStaticEntry(entry, ctx) {
  const org = entry.org.replace(/\s+/g, ' ').trim();
  const svc = entry.svc.replace(/\s+/g, ' ').trim();
  const notes = String(entry.raw.notes || '').replace(/\s+/g, ' ').trim();
  const ltr = entry.raw.dir === 'ltr' ? ' lang="en" dir="ltr"' : '';
  const meta = entryMetaLine(entry, ctx);
  return `<li><a href="${esc(entry.path)}"${ltr}>${esc(org)}</a><span class="svc"${ltr}>${esc(svc)}</span>${
    notes ? `<p class="notes"${ltr}>${linkifyNotes(notes, ctx.hiddenLinkRows)}</p>` : ''
  }${meta ? `<span class="svc">${starCodesHtml(meta)}</span>` : ''}</li>`;
}

function renderStaticServiceList(entries, ctx) {
  if (!entries.length) return '';
  return `<ul class="entry-list">${entries.map((entry) => renderStaticEntry(entry, ctx)).join('')}</ul>`;
}

/** One category inside a group page: its heading, then every service as HTML, not as a script. */
function renderStaticCategory(ctx, categoryId) {
  const { DATA, published } = ctx;
  const cat = DATA[categoryId];
  const parts = [];
  if (cat.desc) parts.push(`<p class="svc">${esc(cat.desc)}</p>`);
  if (cat.intro) parts.push(`<div class="notes">${paragraphs(cat.intro, ctx.hiddenLinkRows)}</div>`);
  if (cat.sectionLinks && cat.sectionLinks.length) {
    const links = cat.sectionLinks
      .map((link) => {
        const href = DATA[link.target] ? `/c/${link.target}` : '';
        return href ? `<li><a href="${esc(href)}">${esc(link.label)}</a></li>` : `<li>${esc(link.label)}</li>`;
      })
      .join('');
    parts.push(`<ul>${links}</ul>`);
  }

  if (cat.subsections) {
    for (const [sid, sub] of Object.entries(cat.subsections)) {
      const members = published.filter((e) => e.subsections.includes(`${categoryId}/${sid}`));
      parts.push(
        `<h3><a href="/c/${esc(categoryId)}/${esc(sid)}">${esc(sub.title)}</a> <span class="count">(${members.length})</span></h3>${renderStaticServiceList(members, ctx)}`
      );
    }
  } else if (!cat.resourceHub) {
    const members = published.filter((e) => e.categories.includes(categoryId));
    parts.push(renderStaticServiceList(members, ctx));
  }

  if (cat.resourceHub) {
    parts.push(mediaListHtml(ctx.FILMS || []).replace('<h2>', '<h3>').replace('</h2>', '</h3>'));
  }

  return `<section>
<h2><a href="/c/${esc(categoryId)}">${esc(cat.title)}</a></h2>
${parts.join('\n')}
</section>`;
}

/**
 * The readable page: its own h1, a 150–300 word intro, then every service in the group.
 * Sits in the HTML source. index.html hides it once JavaScript adds class mh-js, so the
 * app can take over without a second copy on screen.
 */
function renderGroupStaticArticle(ctx, groupId) {
  const { DATA, CATEGORY_GROUPS } = ctx;
  const group = CATEGORY_GROUPS[groupId];
  const intro = String(group.intro || '').trim();
  const words = wordCount(intro);
  if (words < 150 || words > 300) {
    throw new Error(`Group ${groupId} intro is ${words} words; expected 150–300`);
  }
  const sections = group.subcategories
    .filter((id) => DATA[id])
    .map((id) => renderStaticCategory(ctx, id))
    .join('\n');
  return `<article id="mh-group-static">
<h1>${esc(group.title)}</h1>
<div class="mh-group-lede">${paragraphs(intro, ctx.hiddenLinkRows)}</div>
${sections}
</article>`;
}

/**
 * The app reads the group from the path, so every group page starts as a copy of index.html.
 * The head gets its own title and canonical, and the body gets the static article above.
 * Each head substitution must match exactly once, so an edit to index.html fails the build
 * instead of silently shipping the home page's metadata.
 */
function renderGroupAppPage(ctx, groupId, slug) {
  const { html, CATEGORY_GROUPS, published } = ctx;
  const group = CATEGORY_GROUPS[groupId];
  const url = `${T.SITE}/${slug}`;
  const siteTitle = 'מדריך בריאות הנפש בישראל';
  const title = `${group.title} | ${siteTitle}`;
  const n = published.filter((e) => e.categories.some((c) => group.subcategories.includes(c))).length;
  const description = truncate(`${group.title}: ${group.desc}. ${n} שירותים ב${siteTitle}.`, 155);

  const subs = [
    [/<title>[^<]*<\/title>/, `<title>${esc(title)}</title>`],
    [/<meta name="description" content="[^"]*">/, `<meta name="description" content="${esc(description)}">`],
    [/<link rel="canonical" href="[^"]*">/, `<link rel="canonical" href="${url}">`],
    [/<meta property="og:url" content="[^"]*">/, `<meta property="og:url" content="${url}">`],
    [/<meta property="og:title" content="[^"]*">/, `<meta property="og:title" content="${esc(title)}">`],
    [/<meta property="og:description" content="[^"]*">/, `<meta property="og:description" content="${esc(description)}">`],
    [/<meta name="twitter:title" content="[^"]*">/, `<meta name="twitter:title" content="${esc(title)}">`],
    [/<meta name="twitter:description" content="[^"]*">/, `<meta name="twitter:description" content="${esc(description)}">`],
    [
      /"@id": "https:\/\/nefesh-il\.org\/#webpage",(\s*)"url": "[^"]*",(\s*)"name": "[^"]*"/,
      `"@id": "${url}#webpage",$1"url": "${url}",$2"name": ${JSON.stringify(title)}`,
    ],
  ];

  let out = html;
  for (const [re, replacement] of subs) {
    const count = (out.match(new RegExp(re.source, 'g')) || []).length;
    if (count !== 1) throw new Error(`Group page /${slug}: expected one match for ${re} in index.html, found ${count}`);
    out = out.replace(re, replacement);
  }

  const marker = '<!-- MH_GROUP_STATIC -->';
  const markerCount = out.split(marker).length - 1;
  if (markerCount !== 1) {
    throw new Error(`Group page /${slug}: expected one ${marker} in index.html, found ${markerCount}`);
  }
  // A function replacement, so a $ in a service note is not treated as a replace pattern.
  out = out.replace(marker, () => renderGroupStaticArticle(ctx, groupId));

  const crisisH1 = '<h1 style="font-size:1.1rem;color:#c0392b;margin:0 0 8px">במצב משבר — עזרה מיידית</h1>';
  if (!out.includes(crisisH1)) throw new Error(`Group page /${slug}: noscript crisis heading not found`);
  out = out.replace(crisisH1, '<h2 style="font-size:1.1rem;color:#c0392b;margin:0 0 8px">במצב משבר — עזרה מיידית</h2>');

  const noscriptLead = '<p>המדריך המלא דורש JavaScript. הגרסה הנגישה ללא JavaScript זמינה כאן:</p>';
  if (!out.includes(noscriptLead)) throw new Error(`Group page /${slug}: noscript lead not found`);
  out = out.replace(
    noscriptLead,
    '<p>רשימת השירותים בעמוד הזה כתובה למטה גם בלי JavaScript. חיפוש וסינון דורשים JavaScript. עמודים נפרדים:</p>'
  );
  return out;
}

// ---------------------------------------------------------------- sitemap

function renderSitemap(urls, lastmod) {
  const entries = urls
    .map((u) => `  <url>\n    <loc>${T.SITE}${u.path}</loc>\n    <lastmod>${lastmod}</lastmod>\n    <priority>${u.priority}</priority>\n  </url>`)
    .join('\n');
  return `<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n${entries}\n</urlset>\n`;
}

// ---------------------------------------------------------------- orchestration

function writePage(outRoot, urlPath, html, written) {
  const rel = urlPath === '/' ? 'index.html' : path.join(urlPath.replace(/^\//, ''), 'index.html');
  const full = path.join(outRoot, rel);
  fs.mkdirSync(path.dirname(full), { recursive: true });
  fs.writeFileSync(full, html, 'utf8');
  written.push(rel.split(path.sep).join('/')); // normalise so assertions work on Windows too
}

function loadHoldout() {
  const p = path.join(ROOT, 'experiments', 'holdout.json');
  if (!fs.existsSync(p)) return { rows: [], cycle: null };
  const j = JSON.parse(fs.readFileSync(p, 'utf8'));
  return { rows: (j.rows || []).map((r) => r.row), cycle: j.cycle };
}

/** A same-site card link uses the row number. Drop it only when every card on that row is hidden. */
function rowsWithOnlyHiddenCards(entries) {
  const byRow = new Map();
  for (const entry of entries) {
    const row = Number(entry.row);
    if (!byRow.has(row)) byRow.set(row, { hidden: 0, visible: 0 });
    const bucket = byRow.get(row);
    if (entry.raw && entry.raw.hidden === true) bucket.hidden += 1;
    else bucket.visible += 1;
  }
  const rows = new Set();
  for (const [row, bucket] of byRow) {
    if (bucket.hidden > 0 && bucket.visible === 0) rows.add(row);
  }
  return rows;
}

function build(outRoot, data = load()) {
  const holdout = loadHoldout();
  const holdoutRows = new Set(holdout.rows);

  // The holdout slice is the within-site control for the GEO experiment: excluded from
  // pages, sitemap and export for one cycle. See experiments/holdout.json.
  const published = data.entries.filter((e) => !holdoutRows.has(e.row) && !(e.raw && e.raw.hidden === true));
  const withheld = data.entries.filter((e) => holdoutRows.has(e.row));
  const hidden = data.entries.filter((e) => e.raw && e.raw.hidden === true && !holdoutRows.has(e.row));
  const hiddenLinkRows = rowsWithOnlyHiddenCards(data.entries);

  const ctx = { ...data, published, hiddenLinkRows };
  const written = [];
  const urls = [];
  const emittedPhones = [];

  for (const entry of published) {
    const { html, emitted } = renderEntryPage(ctx, entry);
    writePage(outRoot, entry.path, html, written);
    urls.push({ path: entry.path, priority: '0.8' });
    emittedPhones.push(...emitted);
  }

  for (const [categoryId, cat] of Object.entries(data.DATA)) {
    if (cat.unlisted) continue;
    writePage(outRoot, `/c/${categoryId}`, renderCategoryPage(ctx, categoryId, null), written);
    urls.push({ path: `/c/${categoryId}`, priority: '0.7' });
    for (const subId of Object.keys(cat.subsections || {})) {
      writePage(outRoot, `/c/${categoryId}/${subId}`, renderCategoryPage(ctx, categoryId, subId), written);
      urls.push({ path: `/c/${categoryId}/${subId}`, priority: '0.6' });
    }
  }

  const slugByKey = {};
  for (const key of Object.keys(data.terms)) slugByKey[key] = termSlug(key);
  const dupSlugs = Object.values(slugByKey).filter((s, i, a) => a.indexOf(s) !== i);
  if (dupSlugs.length) throw new Error(`Glossary slug collision: ${[...new Set(dupSlugs)].join(', ')}`);

  for (const [key, term] of Object.entries(data.terms)) {
    writePage(outRoot, `/term/${slugByKey[key]}`, renderTermPage(ctx, key, term, slugByKey), written);
    urls.push({ path: `/term/${slugByKey[key]}`, priority: '0.5' });
  }
  writePage(outRoot, '/terms', renderTermsIndex(ctx, slugByKey), written);
  urls.push({ path: '/terms', priority: '0.7' });

  writePage(outRoot, '/directory', renderDirectoryHub(ctx), written);
  urls.push({ path: '/directory', priority: '0.9' });

  writePage(outRoot, '/privacy', renderPrivacyPage(), written);
  urls.push({ path: '/privacy', priority: '0.2' });

  for (const groupId of Object.keys(data.CATEGORY_GROUPS)) {
    const slug = (data.MH_GROUP_SLUGS || {})[groupId];
    if (!slug) throw new Error(`MH_GROUP_SLUGS in index.html has no slug for group ${groupId}`);
    if (!GENERATED_DIRS.includes(slug)) throw new Error(`Group slug ${slug} is missing from GENERATED_DIRS, so --clean would leave it behind`);
    writePage(outRoot, `/${slug}`, renderGroupAppPage(ctx, groupId, slug), written);
    urls.push({ path: `/${slug}`, priority: '0.9' });
  }
  urls.unshift({ path: '/', priority: '1.0' });

  const lastmod = isoDate(data.LAST_UPDATED) || new Date().toISOString().slice(0, 10);
  fs.writeFileSync(path.join(outRoot, 'sitemap.xml'), renderSitemap(urls, lastmod), 'utf8');

  return { data, written, urls, emittedPhones, withheld, holdout, hidden };
}

// ---------------------------------------------------------------- assertions

function assertPhonesCameFromData(data, emittedPhones) {
  // Every tel: link on a generated page must trace back to a phone string in DATA.
  // A wrong crisis number is the worst thing this build could ship, and once it is in
  // static HTML it is machine-consumable and propagates.
  const sourceSignatures = new Set();
  for (const e of data.entries) {
    for (const p of phonesOf(e.raw)) sourceSignatures.add(`${e.row}:${signature(p.number)}`);
  }
  const bad = emittedPhones.filter((p) => {
    const sig = signature(p.tel).replace(/^\*/, '');
    const src = signature(p.source).replace(/\*/g, '');
    return !src.includes(sig);
  });
  if (bad.length) {
    const sample = bad.slice(0, 5).map((b) => `  row ${b.entry.row} (${b.entry.org}): emitted ${b.tel} from "${b.source}"`);
    throw new Error(`${bad.length} emitted phone number(s) do not trace back to DATA:\n${sample.join('\n')}`);
  }
  return emittedPhones.length;
}

/**
 * Every internal link must resolve to a page this build actually emitted. The holdout
 * slice is the obvious way to get this wrong: withhold an entry but keep linking to it
 * from its category page.
 */
function assertNoDanglingLinks(outRoot, written, groupPaths) {
  const pages = new Set(written.map((w) => '/' + w.replace(/\/index\.html$/, '')));
  pages.add('/');
  const groups = new Set(groupPaths || []);
  const dangling = [];

  for (const rel of written) {
    const html = fs.readFileSync(path.join(outRoot, rel), 'utf8');
    for (const m of html.matchAll(/href="(\/[^"#?]*)"/g)) {
      const target = m[1].replace(/\/$/, '') || '/';
      if (!/^\/(s|c|g|term|terms|directory|privacy)(\/|$)/.test(target) && !groups.has(target)) continue;
      if (!pages.has(target)) dangling.push({ from: rel, to: target });
    }
  }
  if (dangling.length) {
    const sample = dangling.slice(0, 8).map((d) => `  ${d.from} -> ${d.to}`);
    throw new Error(`${dangling.length} dangling internal link(s):\n${sample.join('\n')}`);
  }
  return pages.size;
}

/**
 * /g/<group> used to be a separate static page. Google may still have those URLs.
 * vercel.json must send each one to the group page people actually use, permanently,
 * and the sitemap must not keep advertising the old URL.
 */
function assertGroupRedirects(data, urls) {
  const vercel = JSON.parse(fs.readFileSync(path.join(ROOT, 'vercel.json'), 'utf8'));
  const redirects = vercel.redirects || [];
  const problems = [];
  for (const [groupId, slug] of Object.entries(data.MH_GROUP_SLUGS || {})) {
    const source = `/g/${groupId}`;
    const destination = `/${slug}`;
    const hit = redirects.find((r) => r.source === source);
    if (!hit) {
      problems.push(`missing redirect ${source} -> ${destination}`);
      continue;
    }
    if (hit.destination !== destination || hit.permanent !== true) {
      problems.push(`${source} goes to ${hit.destination} (permanent: ${hit.permanent}); expected ${destination}, permanent`);
    }
  }
  const advertised = (urls || []).filter((u) => String(u.path || '').startsWith('/g/')).map((u) => u.path);
  if (advertised.length) problems.push(`sitemap still lists ${advertised.join(', ')}`);
  if (problems.length) throw new Error(`Group redirects:\n  ${problems.join('\n  ')}`);
}

/**
 * /glossary is the in-app glossary, served by a rewrite of the root app. cleanUrls
 * strips .html before rewrites run, so a destination of /index.html is not a file
 * at the edge and Vercel answers with its own 404.
 */
function assertGlossaryRewrite() {
  const vercel = JSON.parse(fs.readFileSync(path.join(ROOT, 'vercel.json'), 'utf8'));
  const hit = (vercel.rewrites || []).find((r) => r.source === '/glossary');
  const expected = vercel.cleanUrls ? '/index' : '/index.html';
  if (!hit) throw new Error(`missing rewrite /glossary -> ${expected}`);
  if (hit.destination !== expected) {
    throw new Error(`/glossary rewrites to ${hit.destination}; expected ${expected}`);
  }
}

function assertReferralCodesValid(data) {
  const vocabPath = path.join(__dirname, 'vocabularies.json');
  const vocab = JSON.parse(fs.readFileSync(vocabPath, 'utf8'));
  const valid = new Set((vocab.referral_route?.terms || []).map((t) => t.code));
  const bad = [];
  for (const e of data.entries) {
    for (const c of e.raw.referralCodes || []) {
      if (!valid.has(c)) bad.push(`row ${e.row}: ${c}`);
    }
  }
  if (bad.length) throw new Error(`Unknown referral_route code(s):\n  ${bad.slice(0, 8).join('\n  ')}`);
  return data.entries.filter((e) => (e.raw.referralCodes || []).some((c) => c !== 'unknown')).length;
}

/**
 * The five category URLs must carry their h1, intro and service text as HTML elements,
 * ahead of the Babel script. A copy of index.html with only the <title> swapped does
 * not count: crawlers that skip JavaScript would still see an empty page.
 */
function assertGroupPagesAreStatic(outRoot, data) {
  const problems = [];
  for (const [groupId, group] of Object.entries(data.CATEGORY_GROUPS)) {
    const slug = (data.MH_GROUP_SLUGS || {})[groupId];
    const rel = `${slug}/index.html`;
    const html = fs.readFileSync(path.join(outRoot, rel), 'utf8');
    const artAt = html.indexOf('<article id="mh-group-static">');
    const artEnd = html.indexOf('</article>');
    const scriptAt = html.indexOf('<script type="text/babel">');
    const noscriptEnd = html.indexOf('</noscript>');
    if (artAt < 0 || artEnd < artAt) {
      problems.push(`/${slug}: static article missing`);
      continue;
    }
    if (!(noscriptEnd < artAt && artAt < scriptAt)) {
      problems.push(`/${slug}: static article must sit after the noscript block and before the app script`);
    }
    const article = html.slice(artAt, artEnd);
    const h1 = `<h1>${esc(group.title)}</h1>`;
    if ((article.match(/<h1>/g) || []).length !== 1 || !article.includes(h1)) {
      problems.push(`/${slug}: expected a single h1 “${group.title}”`);
    }
    const words = wordCount(group.intro);
    if (words < 150 || words > 300) problems.push(`/${slug}: intro is ${words} words, expected 150–300`);
    const snippet = String(group.intro || '').trim().slice(0, 40);
    if (!snippet || !article.includes(snippet)) problems.push(`/${slug}: intro text is not in the article HTML`);
    for (const id of group.subcategories) {
      const cat = data.DATA[id];
      if (cat && !article.includes(`<h2><a href="/c/${id}">${cat.title}</a></h2>`)) {
        problems.push(`/${slug}: category “${cat.title}” is not an h2 in the article`);
      }
    }
    if (/<script/i.test(article)) problems.push(`/${slug}: static article contains a script`);
  }
  if (problems.length) {
    throw new Error(`${problems.length} group-page problem(s):\n  ${problems.slice(0, 12).join('\n  ')}`);
  }
}

function assertEmergencyReachable(written) {
  // The crisis path must exist as a static page even if everything else changed.
  const required = ['c/emergency/index.html', 'c/helplines/index.html'];
  const missing = required.filter((r) => !written.includes(r));
  if (missing.length) throw new Error(`Emergency pages missing from build: ${missing.join(', ')}`);
}

/**
 * Structured data is machine-consumable, which means an error in it propagates further than
 * an error on the page. Three things are checked: it parses, every phone number in it also
 * appears on the visible page, and a free claim is one of the three honest cases in
 * freeClaimIsHonest (a cost sentence that says only "free", an owner-set free funding
 * channel that is not also paid, or an information-only page).
 */
function assertJsonLdIsHonest(outRoot, written, data) {
  const pageTels = new Set();
  for (const e of data.entries) {
    for (const p of phonesOf(e.raw)) pageTels.add(signature(p.number).replace(/\*/g, ''));
  }

  const problems = [];
  let nodes = 0;
  let freeClaims = 0;

  for (const rel of written) {
    const html = fs.readFileSync(path.join(outRoot, rel), 'utf8');
    const m = /<script type="application\/ld\+json">([\s\S]*?)<\/script>/.exec(html);
    if (!m) continue;

    let graph;
    try {
      graph = JSON.parse(m[1].replace(/<\\\//g, '</'));
    } catch (err) {
      problems.push(`${rel}: JSON-LD does not parse (${err.message})`);
      continue;
    }
    if (!graph['@graph'] || !Array.isArray(graph['@graph'])) {
      problems.push(`${rel}: JSON-LD has no @graph array`);
      continue;
    }

    for (const node of graph['@graph']) {
      nodes++;
      if (!node['@type']) problems.push(`${rel}: a JSON-LD node has no @type`);

      for (const tel of collectTelephones(node)) {
        const sig = signature(tel).replace(/\*/g, '');
        if (![...pageTels].some((p) => p.includes(sig))) {
          problems.push(`${rel}: JSON-LD telephone ${tel} does not appear in DATA`);
        }
      }

      if (node.isAccessibleForFree === true) {
        freeClaims++;
        if (!LD.freeClaimIsHonest(node)) {
          const offers = LD.offerNodes(node.offers);
          const described = offers.map((o) => o && o.description).filter(Boolean).join(' | ');
          problems.push(
            `${rel}: claims isAccessibleForFree but cost is "${described || '(none)'}", which is not unconditionally free`
          );
        }
      }
    }
  }

  if (problems.length) {
    throw new Error(`${problems.length} JSON-LD problem(s):\n${problems.slice(0, 8).map((p) => `  ${p}`).join('\n')}`);
  }
  return { nodes, freeClaims };
}

function collectTelephones(node) {
  const out = [];
  const walk = (v) => {
    if (Array.isArray(v)) return v.forEach(walk);
    if (v && typeof v === 'object') {
      if (typeof v.telephone === 'string') out.push(v.telephone);
      return Object.values(v).forEach(walk);
    }
  };
  walk(node);
  return out;
}

/**
 * Two organisations hashing to the same @id would silently merge into one graph node,
 * attributing one charity's services to another.
 */
function assertOrgIdsUnique(data) {
  const byId = new Map();
  for (const e of data.entries) {
    const id = LD.orgId(e.org);
    const name = e.org.replace(/\s+/g, ' ').trim();
    if (!byId.has(id)) byId.set(id, new Set());
    byId.get(id).add(name);
  }
  const collided = [...byId.entries()].filter(([, names]) => names.size > 1);
  if (collided.length) {
    throw new Error(
      `Organisation @id collision:\n${collided.map(([id, n]) => `  ${id} <- ${[...n].join(' | ')}`).join('\n')}`
    );
  }
  return byId.size;
}

/**
 * robots.txt is committed rather than generated, so the two can drift. A sitemap that
 * robots.txt does not point at is a silently useless sitemap.
 */
function assertRobotsAgrees(outRoot, urlCount) {
  const robotsPath = path.join(ROOT, 'robots.txt');
  if (!fs.existsSync(robotsPath)) throw new Error('robots.txt is missing from the repo root.');
  const robots = fs.readFileSync(robotsPath, 'utf8');
  const declared = /^Sitemap:\s*(\S+)/im.exec(robots);
  if (!declared) throw new Error('robots.txt does not declare a Sitemap.');
  const expected = `${T.SITE}/sitemap.xml`;
  if (declared[1] !== expected) {
    throw new Error(`robots.txt points at ${declared[1]}, expected ${expected}`);
  }

  const xml = fs.readFileSync(path.join(outRoot, 'sitemap.xml'), 'utf8');
  const locs = [...xml.matchAll(/<loc>([^<]+)<\/loc>/g)].map((m) => m[1]);
  if (locs.length !== urlCount) throw new Error(`sitemap has ${locs.length} <loc>, expected ${urlCount}`);
  const bad = locs.filter((l) => !l.startsWith(`${T.SITE}/`) || /[&<>"']/.test(l));
  if (bad.length) throw new Error(`sitemap contains malformed URLs: ${bad.slice(0, 3).join(', ')}`);
  if (new Set(locs).size !== locs.length) throw new Error('sitemap contains duplicate URLs');
  return locs.length;
}

// ---------------------------------------------------------------- cli

function clean(outRoot) {
  for (const d of GENERATED_DIRS) fs.rmSync(path.join(outRoot, d), { recursive: true, force: true });
  for (const f of GENERATED_FILES) fs.rmSync(path.join(outRoot, f), { force: true });
}

async function main() {
  const args = process.argv.slice(2);
  const isCheck = args.includes('--check');

  if (args.includes('--clean')) {
    clean(ROOT);
    console.log('Removed generated output.');
    return;
  }

  const outRoot = isCheck ? fs.mkdtempSync(path.join(require('os').tmpdir(), 'nefesh-check-')) : ROOT;
  if (!isCheck) clean(ROOT);

  const t0 = Date.now();
  const catalog = load();
  const cardText = await overlayDirectoryCards(catalog);
  const { data, written, urls, emittedPhones, withheld, holdout, hidden } = build(outRoot, catalog);

  const phoneCount = assertPhonesCameFromData(data, emittedPhones);
  assertEmergencyReachable(written);
  assertGroupPagesAreStatic(outRoot, data);
  const referralKnown = assertReferralCodesValid(data);
  const groupPaths = Object.values(data.MH_GROUP_SLUGS || {}).map((slug) => `/${slug}`);
  assertGroupRedirects(data, urls);
  assertGlossaryRewrite();
  const linkTargets = assertNoDanglingLinks(outRoot, written, groupPaths);
  const sitemapCount = assertRobotsAgrees(outRoot, urls.length);
  const ld = assertJsonLdIsHonest(outRoot, written, data);
  const orgCount = assertOrgIdsUnique(data);

  console.log(`Built ${written.length} pages in ${Date.now() - t0}ms -> ${isCheck ? outRoot : 'repo root'}`);
  console.log(`  entries ${data.entries.length - withheld.length - hidden.length} published, ${withheld.length} withheld (holdout cycle ${holdout.cycle}), ${hidden.length} hidden`);
  console.log(`  categories ${Object.keys(data.DATA).length}, groups ${Object.keys(data.CATEGORY_GROUPS).length}, terms ${Object.keys(data.terms).length}`);
  console.log(`  sitemap ${sitemapCount} urls, lastmod ${isoDate(data.LAST_UPDATED)}, declared in robots.txt`);
  console.log(`  ${phoneCount} tel: links, all traced back to DATA`);
  console.log(`  ${referralKnown} entries carry a known referral_route code`);
  console.log(`  ${linkTargets} link targets, no dangling internal links`);
  console.log(`  ${ld.nodes} JSON-LD nodes across ${orgCount} organisations, all phones traced`);
  console.log(`  ${ld.freeClaims} entries claim isAccessibleForFree (cost says so, funding is free, or the card is information only)`);
  console.log(`  card text: ${cardText.source} (${cardText.applied} of ${cardText.rows} database rows applied)`);

  if (data.collisions.length) {
    console.log(`\n  NOTE: ${data.collisions.length} row numbers are shared by more than one entry.`);
    console.log('  The first entry in DATA order keeps /s/<row>; the others get a suffixed path.');
    console.log('  Row 15 in particular is two unrelated organisations and is worth fixing in index.html.');
    for (const c of data.collisions) {
      console.log(`    row ${c.row}: ${c.entries.map((e) => `${e.path} (${e.org.replace(/\s+/g, ' ').slice(0, 28)})`).join(' | ')}`);
    }
  }

  if (withheld.length) {
    console.log(`\n  Holdout (excluded on purpose, see experiments/holdout.json):`);
    for (const e of withheld) console.log(`    row ${e.row} ${e.org.replace(/\s+/g, ' ').slice(0, 40)}`);
  }

  if (isCheck) fs.rmSync(outRoot, { recursive: true, force: true });
}

if (require.main === module) {
  main().catch((err) => {
    console.error(`\nBUILD FAILED: ${err.message}`);
    process.exit(1);
  });
}

module.exports = { build, parsePhoneField, entryDescription, entryTitle, termSlug, isoDate };
