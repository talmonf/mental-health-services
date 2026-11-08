#!/usr/bin/env node
/**
 * Fetches each card's website and keeps an English URL only when it is that same page.
 * A language menu that points at the English homepage is recorded as a reject.
 *
 *   node scripts/review_site_languages.js
 *
 * Output: scripts/site_language_review.json
 * Fetch metadata is cached under the system temp directory so a second run can reclassify
 * without downloading every page again. Pass --refresh to ignore the cache.
 */

const fs = require('fs');
const os = require('os');
const path = require('path');
const { load } = require('./lib/extract_data');
const {
  SITE_LANGUAGE_CODES,
  SITE_URL_KEYS,
  nameToLang,
  isHttp,
  isSocial,
  isGenericLanguageHome,
  pathsCorrespond,
  isShallowLanding,
  titleLooksHebrew,
  exactKey,
  swapCandidates,
  englishPageOk,
  classifyAlternate,
} = require('./lib/site_languages');

const OUT = path.join(__dirname, 'site_language_review.json');
const SQL_OUT = path.join(__dirname, '124_site_languages.sql');
const LANG_LABEL = /^(english|hebrew|arabic|russian|french|עברית|אנגלית|ערבית|רוסית|צרפתית|français|francais)$/i;
const CACHE = path.join(os.tmpdir(), 'nefesh-site-language-cache.json');
const CONCURRENCY = 8;
const TIMEOUT_MS = 10000;
const MAX_BYTES = 700000;
const REFRESH = process.argv.includes('--refresh');

function decodeAttr(value) {
  return String(value || '')
    .replace(/&amp;/g, '&')
    .replace(/&quot;/g, '"')
    .replace(/&#39;|&apos;/g, "'")
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>');
}

function attr(tag, name) {
  const re = new RegExp(`\\b${name}\\s*=\\s*("([^"]*)"|'([^']*)')`, 'i');
  const m = re.exec(tag);
  return m ? decodeAttr(m[2] != null ? m[2] : m[3]) : '';
}

function normLang(code) {
  const raw = String(code || '').trim().toLowerCase().replace(/_/g, '-');
  if (!raw || raw === 'x-default') return '';
  const primary = raw.split('-')[0];
  if (!/^[a-z]{2,3}$/.test(primary)) return '';
  if (primary === 'iw') return 'he';
  return SITE_LANGUAGE_CODES.includes(primary) ? primary : primary;
}

function resolveUrl(href, base) {
  try {
    const abs = new URL(href, base);
    if (abs.protocol !== 'http:' && abs.protocol !== 'https:') return '';
    abs.hash = '';
    return abs.href;
  } catch {
    return '';
  }
}

function findAlternates(html, pageUrl) {
  const out = [];
  const seen = new Set();
  const add = (lang, href, source) => {
    const code = normLang(lang);
    const url = resolveUrl(href, pageUrl);
    if (!code || !url || isSocial(url) || code === 'he') return;
    if (!SITE_LANGUAGE_CODES.includes(code) && code !== 'en') {
      if (!['en', 'ar', 'ru', 'fr', 'am'].includes(code)) return;
    }
    if (!['en', 'ar', 'ru', 'fr', 'am'].includes(code)) return;
    const key = `${code} ${exactKey(url)}`;
    if (seen.has(key)) return;
    seen.add(key);
    out.push({ lang: code, url, source });
  };
  for (const tag of html.match(/<link\b[^>]*>/gi) || []) {
    const rel = attr(tag, 'rel').toLowerCase();
    if (!rel.split(/\s+/).includes('alternate')) continue;
    add(attr(tag, 'hreflang'), attr(tag, 'href'), 'hreflang');
  }
  for (const block of html.match(/<a\b[^>]*>[\s\S]*?<\/a>/gi) || []) {
    const open = (block.match(/<a\b[^>]*>/i) || [''])[0];
    const href = attr(open, 'href');
    const text = block.replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim();
    const fromName = nameToLang(text);
    const fromHref = normLang(attr(open, 'hreflang'));
    if (fromHref) add(fromHref, href, 'hreflang');
    else if (fromName) add(fromName, href, 'link-text');
  }
  const htmlLang = normLang(attr((html.match(/<html\b[^>]*>/i) || [''])[0], 'lang'));
  const title = decodeAttr((html.match(/<title\b[^>]*>([^<]*)/i) || ['', ''])[1] || '').replace(/\s+/g, ' ').trim();
  return { alternates: out, pageLang: htmlLang === 'iw' ? 'he' : htmlLang, title: title.slice(0, 180) };
}

async function fetchPage(url) {
  const ctrl = new AbortController();
  const timer = setTimeout(() => ctrl.abort(), TIMEOUT_MS);
  try {
    const res = await fetch(url, {
      redirect: 'follow',
      signal: ctrl.signal,
      headers: {
        'user-agent': 'nefesh-il-language-review/1.0',
        accept: 'text/html,application/xhtml+xml',
      },
    });
    if (!res.ok) return { fetch: `http ${res.status}`, status: res.status, pageLang: '', alternates: [], title: '' };
    const type = String(res.headers.get('content-type') || '');
    if (type && !/html|xml/i.test(type)) {
      return { fetch: 'not html', status: res.status, finalUrl: res.url || url, pageLang: '', alternates: [], title: '' };
    }
    const buf = Buffer.from(await res.arrayBuffer());
    const html = buf.subarray(0, MAX_BYTES).toString('utf8');
    const parsed = findAlternates(html, res.url || url);
    if (/404|not found|העמוד לא נמצא|page not found/i.test(parsed.title)) {
      return { fetch: 'soft-404', status: res.status, finalUrl: res.url || url, ...parsed };
    }
    return { fetch: 'ok', status: res.status, finalUrl: res.url || url, ...parsed };
  } catch (err) {
    const aborted = err && (err.name === 'AbortError' || err.name === 'TimeoutError');
    return { fetch: aborted ? 'timeout' : 'blocked', status: 0, pageLang: '', alternates: [], title: '' };
  } finally {
    clearTimeout(timer);
  }
}

async function mapPool(items, worker) {
  const out = new Array(items.length);
  let next = 0;
  let done = 0;
  async function run() {
    while (next < items.length) {
      const i = next;
      next += 1;
      out[i] = await worker(items[i], i);
      done += 1;
      if (done % 40 === 0 || done === items.length) console.log(`  ${done}/${items.length}`);
    }
  }
  await Promise.all(Array.from({ length: Math.min(CONCURRENCY, items.length) }, run));
  return out;
}

function loadCache() {
  if (REFRESH || !fs.existsSync(CACHE)) return new Map();
  try {
    const body = JSON.parse(fs.readFileSync(CACHE, 'utf8'));
    return new Map(Object.entries(body));
  } catch {
    return new Map();
  }
}

function saveCache(cache) {
  const body = {};
  for (const [url, value] of cache) body[url] = value;
  fs.writeFileSync(CACHE, JSON.stringify(body));
}

async function fetchAll(urls, cache) {
  const pending = urls.filter((url) => !cache.has(url));
  console.log(`Fetching ${pending.length} pages (${urls.length - pending.length} cached)`);
  await mapPool(pending, async (url) => {
    cache.set(url, await fetchPage(url));
  });
  saveCache(cache);
}

function cardSlots(raw) {
  const slots = [];
  for (const field of SITE_URL_KEYS) {
    const url = String(raw[field] || '').trim();
    if (!isHttp(url) || isSocial(url)) continue;
    slots.push({
      field,
      url,
      label: String(raw[`${field}Label`] || raw[field === 'web' ? 'webLabel' : `${field}Label`] || '').trim(),
    });
  }
  return slots;
}

function sourceRank(source) {
  if (source === 'hreflang') return 0;
  if (source === 'card-label') return 1;
  if (source === 'swap') return 2;
  if (source === 'page-lang') return 3;
  return 4;
}

function sqlStr(value) {
  return `'${String(value).replace(/'/g, "''")}'`;
}

function labelKey(field) {
  const match = /^(web|add)(\d*)$/.exec(field);
  return match ? `${match[1]}Label${match[2]}` : '';
}

function writeMigration(catalog, reviewCards) {
  const labels = new Map(catalog.map((card) => [card.cardKey, new Map(card.slots.map((slot) => [slot.field, slot.label]))]));
  const updates = reviewCards.map((card) => {
    const site = card.siteLanguages || {};
    const patch = {};
    const names = labels.get(card.cardKey) || new Map();
    for (const key of SITE_URL_KEYS) {
      const url = site.en && site.en[key];
      if (!url) continue;
      patch[key] = url;
      const label = names.get(key) || '';
      const keyName = labelKey(key);
      if (keyName && LANG_LABEL.test(label)) patch[keyName] = 'Website';
    }
    let sql = `UPDATE directory_card_edits\nSET site_languages = ${sqlStr(JSON.stringify(site))}::jsonb`;
    if (Object.keys(patch).length) {
      sql += `,\n    translations = jsonb_set(\n      COALESCE(translations, '{}'::jsonb),\n      '{en}',\n      COALESCE(translations->'en', '{}'::jsonb) || ${sqlStr(JSON.stringify(patch))}::jsonb,\n      true\n    )`;
    }
    sql += `\nWHERE card_key = ${sqlStr(card.cardKey)};\n`;
    return sql;
  });
  const body = `-- Migration 124 (8 Nov 2026)
-- The languages in which each card's own website pages exist, and the address of each page.
-- English lists a card only when English is marked, and the website button opens that page.
-- A language menu that only points at a homepage is not treated as a translation of a deeper page.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

ALTER TABLE directory_card_edits
  ADD COLUMN IF NOT EXISTS site_languages jsonb NOT NULL DEFAULT '{}'::jsonb;

COMMENT ON COLUMN directory_card_edits.site_languages IS
  'Languages in which this card''s own pages exist. Keys are language codes. Values map website buttons to the URL in that language. Hebrew wording stays in public_fields.';

${updates.join('\n')}
INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-08-english-site-languages',
  DATE '2026-11-08',
  'כרטיסים באנגלית רק כשיש אתר באנגלית',
  'במצב אנגלית מוצגים כרטיסים שהעמוד שלהם קיים באנגלית, והקישור לאתר נפתח בעמוד האנגלי. כרטיס בלי עמוד באנגלית לא מופיע, אלא אם בוחרים «הצג כרטיסים בכל השפות».',
  'cards',
  '{}',
  '{}',
  '124_site_languages.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
`;
  fs.writeFileSync(SQL_OUT, body);
  console.log(`Wrote ${SQL_OUT}`);
}

async function main() {
  const data = load();
  const cards = data.entries.map((entry) => ({
    row: entry.row,
    cardKey: entry.key,
    org: entry.org,
    svc: entry.svc,
    slots: cardSlots(entry.raw || {}),
  }));

  const cache = loadCache();
  const hebrewUrls = [...new Set(cards.flatMap((card) => card.slots.map((slot) => slot.url)))];
  await fetchAll(hebrewUrls, cache);

  const extra = new Set();
  for (const url of hebrewUrls) {
    const page = cache.get(url) || { alternates: [] };
    for (const alt of page.alternates || []) {
      if (alt.lang === 'en') extra.add(alt.url);
    }
    for (const slot of cards.flatMap((card) => card.slots).filter((slot) => slot.url === url)) {
      const labeled = nameToLang(slot.label);
      if (labeled === 'en') extra.add(slot.url);
    }
    for (const swap of swapCandidates(url)) extra.add(swap);
  }
  const missing = [...extra].filter((url) => isHttp(url) && !cache.has(url));
  await fetchAll(missing, cache);

  // Proposals of an English URL, so a menu target shared by many Hebrew pages can be dropped.
  const proposals = [];
  for (const card of cards) {
    for (const slot of card.slots) {
      const page = cache.get(slot.url) || { fetch: 'blocked', alternates: [], pageLang: '' };
      const labeled = nameToLang(slot.label);
      const candidates = [];
      let englishHost = false;
      try { englishHost = /^(en|english)\./i.test(new URL(slot.url).hostname); } catch { /* ignore */ }
      if (page.pageLang === 'en' || englishHost) {
        candidates.push({ lang: 'en', url: slot.url, source: 'page-lang' });
      }
      if (labeled === 'en') candidates.push({ lang: 'en', url: slot.url, source: 'card-label' });
      for (const alt of page.alternates || []) {
        if (alt.lang === 'en') candidates.push(alt);
      }
      for (const swap of swapCandidates(slot.url)) {
        candidates.push({ lang: 'en', url: swap, source: 'swap' });
      }
      const seen = new Set();
      for (const candidate of candidates) {
        const kind = classifyAlternate(slot.url, candidate.url, candidate.source);
        if (kind === 'skip' || kind === 'other-site') continue;
        const fetched = cache.get(candidate.url);
        const check = englishPageOk(slot.url, candidate.url, fetched);
        const finalUrl = (check.finalUrl || (fetched && fetched.finalUrl) || candidate.url);
        const id = exactKey(finalUrl);
        if (seen.has(id)) continue;
        seen.add(id);
        proposals.push({
          cardKey: card.cardKey,
          row: card.row,
          field: slot.field,
          hebrew: slot.url,
          hebrewKey: exactKey(slot.url),
          english: finalUrl,
          englishKey: id,
          source: candidate.source,
          kind,
          ok: check.ok && kind === 'same-page',
          reason: kind !== 'same-page' ? kind : (check.ok ? 'verified' : check.reason),
        });
      }
    }
  }

  for (const item of proposals) {
    if (!item.ok) continue;
    const heHome = isGenericLanguageHome(item.hebrew);
    const enHome = isGenericLanguageHome(item.english);
    if (heHome && !enHome) {
      item.ok = false;
      item.reason = 'not-the-home';
    } else if ((item.source === 'link-text' || item.source === 'swap') && !pathsCorrespond(item.hebrew, item.english)) {
      item.ok = false;
      item.reason = 'different-page';
    } else if (item.source === 'hreflang' && !heHome && isShallowLanding(item.english) && !pathsCorrespond(item.hebrew, item.english)) {
      item.ok = false;
      item.reason = 'shallow-english';
    }
  }

  const byEnglish = new Map();
  for (const item of proposals) {
    if (!item.ok) continue;
    if (!byEnglish.has(item.englishKey)) byEnglish.set(item.englishKey, new Set());
    byEnglish.get(item.englishKey).add(item.hebrewKey);
  }
  for (const item of proposals) {
    if (!item.ok) continue;
    const shared = (byEnglish.get(item.englishKey) || new Set()).size >= 2;
    const hebrewIsHome = isGenericLanguageHome(item.hebrew);
    const englishIsHome = isGenericLanguageHome(item.english);
    if (shared && !(hebrewIsHome && englishIsHome)) {
      item.ok = false;
      item.reason = 'shared-menu';
    }
  }

  const rejectCounts = {};
  const acceptCounts = {};
  let withEnglish = 0;
  const rejects = [];
  const outputCards = cards.map((card) => {
    const siteLanguages = {};
    const decisions = [];
    for (const slot of card.slots) {
      const page = cache.get(slot.url) || { pageLang: '' };
      const pageLang = page.pageLang || '';
      const labeled = nameToLang(slot.label);
      const hebrewUrl = labeled && labeled !== 'he' ? '' : slot.url;
      if (hebrewUrl && (pageLang !== 'en' || titleLooksHebrew(page.title))) {
        if (!siteLanguages.he) siteLanguages.he = {};
        siteLanguages.he[slot.field] = slot.url;
      }
      const options = proposals.filter((item) => item.cardKey === card.cardKey && item.field === slot.field);
      options.sort((a, b) => {
        if (a.ok !== b.ok) return a.ok ? -1 : 1;
        const home = Number(isGenericLanguageHome(a.english)) - Number(isGenericLanguageHome(b.english));
        if (home) return home;
        const rank = sourceRank(a.source) - sourceRank(b.source);
        if (rank) return rank;
        return b.english.length - a.english.length;
      });
      const chosen = options.find((item) => item.ok);
      if (chosen) {
        if (!siteLanguages.en) siteLanguages.en = {};
        siteLanguages.en[slot.field] = chosen.english;
        acceptCounts[chosen.source] = (acceptCounts[chosen.source] || 0) + 1;
        decisions.push({ field: slot.field, hebrew: slot.url, english: chosen.english, verdict: 'accept', reason: chosen.source });
      }
      for (const item of options) {
        if (item.ok) continue;
        rejectCounts[item.reason] = (rejectCounts[item.reason] || 0) + 1;
        if (rejects.length < 400) {
          rejects.push({
            row: card.row,
            field: slot.field,
            hebrew: slot.url,
            english: item.english,
            reason: item.reason,
            source: item.source,
          });
        }
      }
      // Other languages from the Hebrew page, same structural rule, without a second fetch.
      for (const alt of page.alternates || []) {
        if (alt.lang === 'en' || alt.lang === 'he') continue;
        if (!SITE_LANGUAGE_CODES.includes(alt.lang)) continue;
        const kind = classifyAlternate(slot.url, alt.url, alt.source);
        if (kind !== 'same-page') continue;
        const heHome = isGenericLanguageHome(slot.url);
        const altHome = isGenericLanguageHome(alt.url);
        if (heHome !== altHome) continue;
        if (alt.source !== 'hreflang' && !pathsCorrespond(slot.url, alt.url)) continue;
        if (alt.source === 'hreflang' && !heHome && isShallowLanding(alt.url) && !pathsCorrespond(slot.url, alt.url)) continue;
        if (!siteLanguages[alt.lang]) siteLanguages[alt.lang] = {};
        if (!siteLanguages[alt.lang][slot.field]) siteLanguages[alt.lang][slot.field] = alt.url;
      }
    }
    if (siteLanguages.en) {
      const seenUrl = new Set();
      for (const key of SITE_URL_KEYS) {
        const url = siteLanguages.en[key];
        if (!url) continue;
        const id = exactKey(url);
        if (seenUrl.has(id)) delete siteLanguages.en[key];
        else seenUrl.add(id);
      }
      if (!Object.keys(siteLanguages.en).length) delete siteLanguages.en;
    }
    if (siteLanguages.en) withEnglish += 1;
    return {
      row: card.row,
      cardKey: card.cardKey,
      org: card.org,
      svc: card.svc,
      siteLanguages,
      decisions,
    };
  });

  const body = {
    generatedAt: '2026-11-08',
    summary: {
      cards: outputCards.length,
      withWebsite: outputCards.filter((card) => Object.keys(card.siteLanguages).length).length,
      withEnglish,
      acceptCounts,
      rejectCounts,
    },
    rejects,
    cards: outputCards,
  };
  fs.writeFileSync(OUT, JSON.stringify(body, null, 2));
  writeMigration(cards, outputCards);
  console.log(JSON.stringify(body.summary, null, 2));
  console.log(`Wrote ${OUT}`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
