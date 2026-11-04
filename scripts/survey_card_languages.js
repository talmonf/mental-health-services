#!/usr/bin/env node
/**
 * Reads each organization's public page and records language URLs found in the HTML.
 * A menu drawn only by JavaScript is marked unseen. Nothing here is written onto a card.
 *
 *   node scripts/survey_card_languages.js
 *
 * Output: scripts/card_language_pages.json
 */

const fs = require('fs');
const path = require('path');
const { load } = require('./lib/extract_data');

const OUT = path.join(__dirname, 'card_language_pages.json');
const LINK_FIELDS = ['web', 'web2', 'add', 'add2', 'add3'];
const SOCIAL = /(?:^|\.)(?:facebook|fb|instagram|linkedin|youtube|youtu\.be|wa\.me|whatsapp|t\.me|twitter|x|tiktok)\./i;
const CONCURRENCY = 6;
const TIMEOUT_MS = 12000;
const MAX_BYTES = 1500000;

const LANG_NAMES = {
  english: 'en', אנגלית: 'en',
  hebrew: 'he', עברית: 'he',
  arabic: 'ar', العربية: 'ar', عربي: 'ar', ערבית: 'ar',
  russian: 'ru', русский: 'ru', רוסית: 'ru',
  amharic: 'am', አማርኛ: 'am', אמהרית: 'am',
  french: 'fr', français: 'fr', francais: 'fr', צרפתית: 'fr',
  spanish: 'es', español: 'es', espanol: 'es', ספרדית: 'es',
  german: 'de', deutsch: 'de', גרמנית: 'de',
  yiddish: 'yi', יידיש: 'yi',
  ukrainian: 'uk', українська: 'uk', אוקראינית: 'uk',
  tigrinya: 'ti', תגרית: 'ti',
  persian: 'fa', farsi: 'fa', فارسی: 'fa', פרסית: 'fa',
  portuguese: 'pt',
  italian: 'it',
  romanian: 'ro',
  polish: 'pl',
  chinese: 'zh',
  'swiss-german': 'gsw',
};

const KNOWN = new Set(Object.values(LANG_NAMES));

function normLang(code) {
  const raw = String(code || '').trim().toLowerCase().replace(/_/g, '-');
  if (!raw || raw === 'x-default') return '';
  const primary = raw.split('-')[0];
  if (!/^[a-z]{2,3}$/.test(primary)) return '';
  return KNOWN.has(primary) ? primary : primary;
}

function nameToLang(text) {
  const t = String(text || '').replace(/\s+/g, ' ').trim().toLowerCase();
  if (!t || t.length > 40) return '';
  if (LANG_NAMES[t]) return LANG_NAMES[t];
  if (/^[a-z]{2,3}$/.test(t) && KNOWN.has(t)) return t;
  return '';
}

function isHttp(url) {
  return /^https?:\/\//i.test(String(url || '').trim());
}

function skipUrl(url) {
  try {
    const host = new URL(url).hostname;
    return SOCIAL.test(host) || SOCIAL.test(url);
  } catch {
    return true;
  }
}

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

function pathLang(url) {
  try {
    const parts = new URL(url).pathname.split('/').filter(Boolean);
    // Only a language home such as /en or /ru. A slug like /am-i-addicted is not Amharic,
    // and an article under /he/ is not a language switch.
    if (parts.length !== 1) return '';
    const code = parts[0].toLowerCase();
    if (!/^[a-z]{2,3}$/.test(code) || !KNOWN.has(code)) return '';
    return code;
  } catch { /* ignore */ }
  return '';
}

function findAlternates(html, pageUrl) {
  const out = [];
  const seen = new Set();
  const add = (lang, href, source) => {
    const code = normLang(lang);
    const url = resolveUrl(href, pageUrl);
    if (!code || !url || skipUrl(url)) return;
    const key = `${code} ${url}`;
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
    const fromHrefLang = normLang(attr(open, 'hreflang'));
    const fromPath = pathLang(resolveUrl(href, pageUrl));
    if (fromHrefLang) add(fromHrefLang, href, 'hreflang');
    else if (fromName) add(fromName, href, 'link-text');
    else if (fromPath && text.length <= 3) add(fromPath, href, 'path');
  }

  const htmlLang = normLang(attr((html.match(/<html\b[^>]*>/i) || [''])[0], 'lang'));
  return { alternates: out, pageLang: htmlLang };
}

async function fetchPage(url) {
  const ctrl = new AbortController();
  const timer = setTimeout(() => ctrl.abort(), TIMEOUT_MS);
  try {
    const res = await fetch(url, {
      redirect: 'follow',
      signal: ctrl.signal,
      headers: {
        'user-agent': 'nefesh-il-language-survey/1.0',
        accept: 'text/html,application/xhtml+xml',
      },
    });
    if (res.status === 401 || res.status === 403 || res.status === 429) {
      return { fetch: 'blocked', status: res.status, pageLang: '', alternates: [] };
    }
    if (!res.ok) {
      return { fetch: `http ${res.status}`, status: res.status, pageLang: '', alternates: [] };
    }
    const type = String(res.headers.get('content-type') || '');
    if (type && !/html|xml/i.test(type)) {
      return { fetch: 'not html', status: res.status, pageLang: '', alternates: [] };
    }
    const buf = Buffer.from(await res.arrayBuffer());
    const html = buf.subarray(0, MAX_BYTES).toString('utf8');
    const parsed = findAlternates(html, res.url || url);
    return { fetch: 'ok', status: res.status, finalUrl: res.url || url, ...parsed };
  } catch (err) {
    const aborted = err && (err.name === 'AbortError' || err.name === 'TimeoutError');
    return {
      fetch: aborted ? 'timeout' : 'blocked',
      status: 0,
      pageLang: '',
      alternates: [],
      error: aborted ? '' : String(err && err.message ? err.message : err).slice(0, 160),
    };
  } finally {
    clearTimeout(timer);
  }
}

async function mapPool(items, limit, worker) {
  const out = new Array(items.length);
  let next = 0;
  async function run() {
    while (next < items.length) {
      const i = next;
      next += 1;
      out[i] = await worker(items[i], i);
    }
  }
  await Promise.all(Array.from({ length: Math.min(limit, items.length) }, run));
  return out;
}

function cardLinks(raw) {
  const links = [];
  for (const field of LINK_FIELDS) {
    const url = String(raw[field] || '').trim();
    if (!isHttp(url) || skipUrl(url)) continue;
    links.push({
      field,
      url,
      label: String(raw[`${field}Label`] || '').trim(),
    });
  }
  return links;
}

function labeledAlternate(link) {
  const lang = nameToLang(link.label);
  if (!lang) return null;
  return { lang, url: link.url, source: 'card' };
}

async function main() {
  const data = load();
  const cards = data.entries.map((entry) => {
    const raw = entry.raw || {};
    return {
      row: entry.row,
      org: String(raw.org || '').replace(/\s+/g, ' ').trim(),
      serviceLanguages: String(raw.languages || '').replace(/\s+/g, ' ').trim(),
      links: cardLinks(raw),
    };
  });

  const unique = [...new Set(cards.flatMap((card) => card.links.map((link) => link.url)))];
  console.log(`Fetching ${unique.length} pages for ${cards.length} cards`);
  let done = 0;
  const fetched = new Map();
  await mapPool(unique, CONCURRENCY, async (url) => {
    const result = await fetchPage(url);
    fetched.set(url, result);
    done += 1;
    if (done % 25 === 0 || done === unique.length) console.log(`  ${done}/${unique.length}`);
  });

  const byLanguage = {};
  let withAlternate = 0;
  const outputCards = cards.map((card) => {
    if (!card.links.length) {
      return { row: card.row, org: card.org, serviceLanguages: card.serviceLanguages, links: [], reason: 'no link' };
    }
    const links = card.links.map((link) => {
      const page = fetched.get(link.url) || { fetch: 'blocked', pageLang: '', alternates: [] };
      const alternates = [];
      const labeled = labeledAlternate(link);
      if (labeled) alternates.push(labeled);
      for (const alt of page.alternates || []) {
        if (!alternates.some((item) => item.lang === alt.lang && item.url === alt.url)) alternates.push(alt);
      }
      const item = {
        field: link.field,
        url: link.url,
        label: link.label,
        fetch: page.fetch,
        pageLang: page.pageLang || '',
        alternates,
      };
      if (page.fetch === 'ok' && !alternates.length) item.unseen = true;
      if (page.error) item.error = page.error;
      return item;
    });
    const langs = new Set(links.flatMap((link) => link.alternates.map((alt) => alt.lang)));
    if (langs.size) {
      withAlternate += 1;
      for (const lang of langs) byLanguage[lang] = (byLanguage[lang] || 0) + 1;
    }
    return { row: card.row, org: card.org, serviceLanguages: card.serviceLanguages, links };
  });

  const body = {
    generatedAt: '2026-11-04',
    summary: {
      cards: outputCards.length,
      withWebsite: outputCards.filter((card) => card.links.length).length,
      withAlternate,
      byLanguage,
    },
    cards: outputCards,
  };
  fs.writeFileSync(OUT, `${JSON.stringify(body, null, 2)}\n`, 'utf8');
  console.log(`Wrote ${OUT}`);
  console.log(JSON.stringify(body.summary));
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
