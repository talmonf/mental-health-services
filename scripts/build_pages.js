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
 *   /g/<group>          one per top-level group
 *   /term/<slug>        one per glossary term, /terms index
 *   /directory          hub linking everything, so nothing is more than two hops from the root
 *   /sitemap.xml
 */

const fs = require('fs');
const path = require('path');
const { load, phonesOf, referralLabel } = require('./lib/extract_data');
const { overlayDirectoryCards } = require('./lib/overlay_directory_cards');
const T = require('./lib/page_template');
const LD = require('./lib/jsonld');

const ROOT = path.join(__dirname, '..');
const GENERATED_DIRS = ['s', 'c', 'g', 'term', 'terms', 'directory'];
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

const { escapeHtml: esc, paragraphs, startsWithLatin, truncate } = T;

function isoDate(ddmmyyyy) {
  const m = String(ddmmyyyy || '').match(/^(\d{2})\.(\d{2})\.(\d{4})$/);
  return m ? `${m[3]}-${m[2]}-${m[1]}` : '';
}

function firstSentence(text) {
  const t = String(text || '').replace(/\s+/g, ' ').trim();
  const m = t.match(/^(.{20,}?[.!?])\s/);
  return m ? m[1] : t;
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

const FIELD_LABELS = [
  ['target', 'קהל יעד'],
  ['region', 'אזור'],
  ['cost', 'עלות'],
  ['specialty', 'התמחות'],
  ['diseases', 'מצבים'],
  ['languages', 'שפות'],
];

function renderContact(entry, emitted) {
  const r = entry.raw;
  const items = [];

  for (const p of phonesOf(entry.raw)) {
    const parsed = parsePhoneField(p.number);
    // Record every tel: we emit, so the build can prove it came from DATA and so the
    // JSON-LD can only ever claim numbers the visible page actually renders.
    for (const tok of parsed.tokens) emitted.push({ entry, slot: p.slot, source: p.number, tel: tok.tel });
    const links = parsed.tokens.map((t) => `<a href="tel:${esc(t.tel)}">${esc(t.display)}</a>`).join(' · ');
    const label = p.label ? `<span class="label">${esc(p.label)}: </span>` : '';
    // The source string is shown verbatim. Only when the field is nothing but the number
    // itself is the bare link enough; anything else (a Hebrew qualifier, a second number)
    // keeps the published wording and gets the links appended.
    const isBareNumber = parsed.tokens.length === 1 && parsed.text === parsed.tokens[0].display;
    const body = isBareNumber
      ? links
      : `${esc(parsed.text)}${links ? ` <span class="label">(${links})</span>` : ''}`;
    items.push(`<li>${label}${body}</li>`);
  }

  if (r.whatsapp) {
    const digits = String(r.whatsapp).replace(/\D/g, '');
    const label = r.whatsappLabel ? esc(r.whatsappLabel) : 'WhatsApp';
    items.push(`<li><span class="label">WhatsApp: </span><a href="https://wa.me/${esc(digits)}" rel="nofollow">${label}</a></li>`);
  }
  if (r.email) {
    items.push(`<li><span class="label">דוא"ל: </span><a href="mailto:${esc(r.email)}">${esc(r.email)}</a></li>`);
  }
  for (const [urlKey, labelKey, fallback] of [['web', 'webLabel', 'אתר הארגון'], ['web2', 'webLabel2', 'קישור נוסף'], ['add', 'addLabel', 'מידע נוסף']]) {
    const url = r[urlKey];
    if (!url || !/^https?:\/\//.test(url)) continue;
    const label = r[labelKey] ? esc(r[labelKey]) : fallback;
    items.push(`<li><span class="label">${fallback === 'אתר הארגון' ? 'אתר' : 'קישור'}: </span><a href="${esc(url)}" rel="nofollow noopener">${label}</a></li>`);
  }

  return items.length ? `<h2>יצירת קשר</h2><ul class="contact">${items.join('')}</ul>` : '';
}

function renderReferralBadge(entry) {
  const codes = (entry.raw.referralCodes || []).filter((c) => c && c !== 'unknown');
  if (!codes.length) return '';
  const isLtr = entry.raw.dir === 'ltr';
  const title = codes.includes('self_referral')
    ? (isLtr ? 'You can contact directly' : 'אפשר לפנות ישירות')
    : codes.map((c) => referralLabel(c, isLtr ? 'en' : 'he')).join(' · ');
  const source = entry.raw.referralSource;
  const sourceLabel = isLtr ? 'As published: ' : 'כפי שפורסם: ';
  return `<details class="badge-ref"><summary>${esc(title)}</summary>${
    source ? `<p>${esc(sourceLabel)}${esc(source)}</p>` : ''
  }</details>`;
}

function renderEntryPage(ctx, entry) {
  const { DATA, CATEGORY_GROUPS, ENTRY_LOCATIONS, LAST_UPDATED, published } = ctx;
  const primaryCat = entry.categories[0];
  const cat = DATA[primaryCat] || {};
  const groupId = Object.keys(CATEGORY_GROUPS).find((g) => CATEGORY_GROUPS[g].subcategories.includes(primaryCat));
  const group = CATEGORY_GROUPS[groupId] || {};
  const isLtr = entry.raw.dir === 'ltr';

  const trail = [
    { name: 'מדריך נפש', url: '/' },
    ...(group.title ? [{ name: group.title, url: `/g/${groupId}` }] : []),
    ...(cat.title ? [{ name: cat.title, url: `/c/${primaryCat}` }] : []),
    { name: entry.org, url: entry.path },
  ];

  const emitted = [];
  // LTR entries are English services inside a Hebrew document. The direction switch belongs
  // on the English content only: the section headings, breadcrumbs and sibling list are
  // Hebrew and must stay RTL. Applying it to the whole <article> left-aligns Hebrew headings.
  const ltrAttrs = isLtr ? ' lang="en" dir="ltr" class="ltr-block"' : '';
  const valueDir = isLtr ? ' dir="ltr" class="ltr-block"' : '';

  const facts = FIELD_LABELS
    .filter(([k]) => entry.raw[k] && String(entry.raw[k]).trim())
    .map(([k, label]) => `<div><dt>${esc(label)}</dt><dd${valueDir}>${esc(String(entry.raw[k]).replace(/\s+/g, ' ').trim())}</dd></div>`)
    .join('');

  const referralBadge = renderReferralBadge(entry);

  const locations = (ENTRY_LOCATIONS[String(entry.row)] || [])
    .map((l) => `<li>${esc(l.label)}${l.address && l.address !== l.label ? ` — ${esc(l.address)}` : ''}</li>`)
    .join('');

  const catTags = entry.categories
    .filter((c) => DATA[c])
    .map((c) => `<a class="tag" href="/c/${esc(c)}">${esc(DATA[c].title)}</a>`)
    .join('');

  // Siblings keep the page from being a dead end for a person who landed on the wrong entry.
  const siblings = published
    .filter((e) => e !== entry && e.categories.includes(primaryCat))
    .slice(0, 8)
    .map((e) => `<li><a href="${esc(e.path)}">${esc(e.org)}</a><span class="svc">${esc(truncate(e.svc, 90))}</span></li>`)
    .join('');

  const appUrl = `/?entry=${encodeURIComponent(entry.row)}&section=${encodeURIComponent(primaryCat)}`;

  const body = `
<article>
  <header${ltrAttrs}>
    <h1>${esc(entry.org)}</h1>
    ${entry.svc ? `<p class="lede">${esc(entry.svc.replace(/\s+/g, ' '))}</p>` : ''}
  </header>
  <div class="card">
    ${referralBadge}
    ${facts ? `<dl class="facts">${facts}</dl>` : ''}
    ${renderContact(entry, emitted)}
    ${entry.raw.notes && entry.raw.notes.trim() ? `<h2>הערות</h2><div class="notes"${ltrAttrs}>${paragraphs(entry.raw.notes)}</div>` : ''}
    ${locations ? `<h2>מיקומים</h2><ul${valueDir}>${locations}</ul>` : ''}
  </div>
  <p><a class="btn" href="${esc(appUrl)}">פתחו את הכרטיס במדריך המלא</a></p>
  ${catTags ? `<h2>קטגוריות</h2><div>${catTags}</div>` : ''}
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
${cat.intro ? `<div class="notes">${paragraphs(cat.intro)}</div>` : ''}
${subsectionLinks}
${members.length || !mediaCount ? `<h2>שירותים <span class="count">(${members.length})</span></h2>
<ul class="entry-list">${entryListHtml(members)}</ul>` : ''}
${media}
<p><a class="btn" href="/?section=${esc(categoryId)}">פתחו את הקטגוריה במדריך המלא</a></p>
`;

  const trail = [
    { name: 'מדריך נפש', url: '/' },
    ...(group.title ? [{ name: group.title, url: `/g/${groupId}` }] : []),
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

function renderGroupPage(ctx, groupId) {
  const { DATA, CATEGORY_GROUPS, LAST_UPDATED, published } = ctx;
  const group = CATEGORY_GROUPS[groupId];

  const cats = group.subcategories
    .filter((c) => DATA[c])
    .map((c) => {
      const n = published.filter((e) => e.categories.includes(c)).length;
      return `<li><a href="/c/${esc(c)}">${esc(DATA[c].title)}</a> <span class="count">(${n})</span><span class="svc">${esc(DATA[c].desc || '')}</span></li>`;
    })
    .join('');

  const body = `
<h1>${esc(group.title)}</h1>
${group.desc ? `<p class="lede">${esc(group.desc)}</p>` : ''}
<h2>קטגוריות</h2>
<ul class="entry-list">${cats}</ul>
<p><a class="btn" href="/#${esc(groupId)}">פתחו את הקבוצה במדריך המלא</a></p>
`;

  const trail = [{ name: 'מדריך נפש', url: '/' }, { name: group.title, url: `/g/${groupId}` }];
  const description = truncate(`${group.title}${group.desc ? ` — ${group.desc}` : ''}. מדריך נפש, שירותי בריאות הנפש בישראל.`, 155);
  const members = published.filter((e) => e.categories.some((c) => group.subcategories.includes(c)));

  return T.renderPage({
    title: `${group.title} | מדריך נפש`,
    description,
    path: `/g/${groupId}`,
    ogType: 'website',
    trail,
    body,
    jsonLd: LD.serialize(
      LD.collectionGraph({
        name: group.title,
        description,
        path: `/g/${groupId}`,
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

  const body = `
<h1>${esc(term.title)}</h1>
${cat ? `<p class="lede">${esc(cat.title)}</p>` : ''}
<div class="card">${paragraphs(term.text)}
${term.phone ? `<p><strong>טלפון:</strong> ${esc(term.phone)}</p>` : ''}</div>
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

function renderDirectoryHub(ctx) {
  const { DATA, CATEGORY_GROUPS, LAST_UPDATED, published } = ctx;
  const groups = Object.entries(CATEGORY_GROUPS)
    .map(([gid, g]) => {
      const cats = g.subcategories
        .filter((c) => DATA[c])
        .map((c) => `<li><a href="/c/${esc(c)}">${esc(DATA[c].title)}</a> <span class="count">(${published.filter((e) => e.categories.includes(c)).length})</span></li>`)
        .join('');
      return `<h2><a href="/g/${esc(gid)}">${esc(g.title)}</a></h2><ul class="entry-list">${cats}</ul>`;
    })
    .join('');

  const all = [...published]
    .sort((a, b) => a.org.localeCompare(b.org, 'he'))
    .map((e) => `<li><a href="${esc(e.path)}">${esc(e.org)}</a><span class="svc">${esc(truncate(e.svc, 90))}</span></li>`)
    .join('');

  const trail = [{ name: 'מדריך נפש', url: '/' }, { name: 'כל הקטגוריות', url: '/directory' }];
  const description = truncate(`${published.length} שירותי בריאות נפש בישראל ב-${Object.keys(DATA).length} קטגוריות: עזרה דחופה, קווי סיוע, זכויות, טיפול, שיקום, משפחות ונוער.`, 155);

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
        members: published,
        trail,
        lastUpdatedIso: isoDate(LAST_UPDATED),
        // The hub is where the WebSite node lives for the pre-rendered surface, so the
        // SearchAction is discoverable without JavaScript.
        extra: [LD.websiteNode()],
      })
    ),
    body: `<h1>כל הקטגוריות והשירותים</h1>
<p class="lede">${published.length} שירותים ב-${Object.keys(DATA).length} קטגוריות.</p>
${groups}
<h2>כל השירותים לפי שם <span class="count">(${published.length})</span></h2>
<ul class="entry-list">${all}</ul>`,
    lastUpdated: LAST_UPDATED,
    lastUpdatedIso: isoDate(LAST_UPDATED),
  });
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

function build(outRoot, data = load()) {
  const holdout = loadHoldout();
  const holdoutRows = new Set(holdout.rows);

  // The holdout slice is the within-site control for the GEO experiment: excluded from
  // pages, sitemap and export for one cycle. See experiments/holdout.json.
  const published = data.entries.filter((e) => !holdoutRows.has(e.row));
  const withheld = data.entries.filter((e) => holdoutRows.has(e.row));

  const ctx = { ...data, published };
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
    writePage(outRoot, `/c/${categoryId}`, renderCategoryPage(ctx, categoryId, null), written);
    urls.push({ path: `/c/${categoryId}`, priority: '0.7' });
    for (const subId of Object.keys(cat.subsections || {})) {
      writePage(outRoot, `/c/${categoryId}/${subId}`, renderCategoryPage(ctx, categoryId, subId), written);
      urls.push({ path: `/c/${categoryId}/${subId}`, priority: '0.6' });
    }
  }

  for (const groupId of Object.keys(data.CATEGORY_GROUPS)) {
    writePage(outRoot, `/g/${groupId}`, renderGroupPage(ctx, groupId), written);
    urls.push({ path: `/g/${groupId}`, priority: '0.7' });
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
  urls.unshift({ path: '/', priority: '1.0' });

  const lastmod = isoDate(data.LAST_UPDATED) || new Date().toISOString().slice(0, 10);
  fs.writeFileSync(path.join(outRoot, 'sitemap.xml'), renderSitemap(urls, lastmod), 'utf8');

  return { data, written, urls, emittedPhones, withheld, holdout };
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
function assertNoDanglingLinks(outRoot, written) {
  const pages = new Set(written.map((w) => '/' + w.replace(/\/index\.html$/, '')));
  pages.add('/');
  const dangling = [];

  for (const rel of written) {
    const html = fs.readFileSync(path.join(outRoot, rel), 'utf8');
    for (const m of html.matchAll(/href="(\/[^"#?]*)"/g)) {
      const target = m[1].replace(/\/$/, '') || '/';
      if (!/^\/(s|c|g|term|terms|directory)(\/|$)/.test(target)) continue;
      if (!pages.has(target)) dangling.push({ from: rel, to: target });
    }
  }
  if (dangling.length) {
    const sample = dangling.slice(0, 8).map((d) => `  ${d.from} -> ${d.to}`);
    throw new Error(`${dangling.length} dangling internal link(s):\n${sample.join('\n')}`);
  }
  return pages.size;
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

function assertEmergencyReachable(written) {
  // The crisis path must exist as a static page even if everything else changed.
  const required = ['c/emergency/index.html', 'c/helplines/index.html'];
  const missing = required.filter((r) => !written.includes(r));
  if (missing.length) throw new Error(`Emergency pages missing from build: ${missing.join(', ')}`);
}

/**
 * Structured data is machine-consumable, which means an error in it propagates further than
 * an error on the page. Three things are checked: it parses, every phone number in it also
 * appears on the visible page, and nothing is claimed free unless the source says so
 * unconditionally.
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
        const described = node.offers?.description;
        if (!described || !LD.isLiterallyFree(described)) {
          problems.push(
            `${rel}: claims isAccessibleForFree but cost is "${described ?? '(none)'}", which is not unconditionally free`
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
  const { data, written, urls, emittedPhones, withheld, holdout } = build(outRoot, catalog);

  const phoneCount = assertPhonesCameFromData(data, emittedPhones);
  assertEmergencyReachable(written);
  const referralKnown = assertReferralCodesValid(data);
  const linkTargets = assertNoDanglingLinks(outRoot, written);
  const sitemapCount = assertRobotsAgrees(outRoot, urls.length);
  const ld = assertJsonLdIsHonest(outRoot, written, data);
  const orgCount = assertOrgIdsUnique(data);

  console.log(`Built ${written.length} pages in ${Date.now() - t0}ms -> ${isCheck ? outRoot : 'repo root'}`);
  console.log(`  entries ${data.entries.length - withheld.length} published, ${withheld.length} withheld (holdout cycle ${holdout.cycle})`);
  console.log(`  categories ${Object.keys(data.DATA).length}, groups ${Object.keys(data.CATEGORY_GROUPS).length}, terms ${Object.keys(data.terms).length}`);
  console.log(`  sitemap ${sitemapCount} urls, lastmod ${isoDate(data.LAST_UPDATED)}, declared in robots.txt`);
  console.log(`  ${phoneCount} tel: links, all traced back to DATA`);
  console.log(`  ${referralKnown} entries carry a known referral_route code`);
  console.log(`  ${linkTargets} link targets, no dangling internal links`);
  console.log(`  ${ld.nodes} JSON-LD nodes across ${orgCount} organisations, all phones traced`);
  console.log(`  ${ld.freeClaims} entries claim isAccessibleForFree (only where cost says so unconditionally)`);
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
