#!/usr/bin/env node
/**
 * Suggest glossary-card links by finding each term's title and aliases in card text.
 * Suggestions are reviewed in /admin#glossary; only approved links are published.
 *
 *   node scripts/suggest_glossary_links.js                  with DATABASE_URL: inserts suggested rows
 *   node scripts/suggest_glossary_links.js --sql FILE       writes the same inserts as a SQL migration
 *   node scripts/suggest_glossary_links.js --dry            prints counts per term only
 *
 * Inserts use ON CONFLICT DO NOTHING, so a link that was approved or rejected is never reset.
 * With DATABASE_URL the text is the published text in directory_card_edits; without it the
 * embedded copy in index.html is used.
 */

const fs = require('fs');
const path = require('path');
const { Client } = require('pg');
const { load } = require('./lib/extract_data');

const FIELDS = ['org', 'svc', 'target', 'cost', 'specialty', 'diseases', 'notes', 'tags'];
const HE = '\u05d0-\u05ea';

function normalizePgSslMode(connectionString) {
  try {
    const u = new URL(connectionString);
    const mode = u.searchParams.get('sslmode');
    if (mode === 'prefer' || mode === 'require' || mode === 'verify-ca') u.searchParams.set('sslmode', 'verify-full');
    return u.toString();
  } catch {
    return connectionString;
  }
}

function escapeRe(s) {
  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

/** "CBT - טיפול קוגניטיבי התנהגותי" gives both halves; "Spravato / אסקטמין (ספראבטו)" gives three. */
function phrasesFor(term) {
  const parts = String(term.title)
    .split(/\s+[-–—/]\s+|\s*[()]\s*/)
    .map((s) => s.trim())
    .filter(Boolean);
  return [...new Set([...parts, ...(term.aliases || [])])].filter((p) => p.length >= 2);
}

/**
 * Hebrew has no word boundaries in \b. A match may carry up to three one-letter prefixes
 * (ו, ה, ב, ל, מ, ש, כ) and a plural or feminine suffix on the last word. The adjective
 * ending ־י is left out: «פסיכיאטרי» describes a ward, not a psychiatrist.
 */
function matcherFor(phrase) {
  if (/^[A-Za-z0-9 .\-/]+$/.test(phrase)) {
    return new RegExp(`(?<![A-Za-z0-9])${escapeRe(phrase)}(?![A-Za-z0-9])`);
  }
  const body = escapeRe(phrase).replace(/\s+/g, '\\s+');
  return new RegExp(`(?<![${HE}])[והבלמשכ]{0,3}${body}(?:ים|ות|ית)?(?![${HE}])`);
}

function snippet(text, index, length) {
  const start = Math.max(0, index - 30);
  const end = Math.min(text.length, index + length + 30);
  return `${start > 0 ? '…' : ''}${text.slice(start, end).replace(/\s+/g, ' ').trim()}${end < text.length ? '…' : ''}`.slice(0, 200);
}

function suggest(terms, cards) {
  const out = [];
  for (const [key, term] of Object.entries(terms)) {
    if (term.noAutoLink) continue;
    const matchers = phrasesFor(term).map(matcherFor);
    for (const card of cards) {
      const text = FIELDS.map((f) => String(card.fields[f] || '')).join('\n');
      for (const re of matchers) {
        const m = re.exec(text);
        if (m) {
          out.push({ termKey: key, cardKey: card.cardKey, matched: snippet(text, m.index, m[0].length) });
          break;
        }
      }
    }
  }
  return out;
}

const sqlStr = (s) => `'${String(s).replace(/'/g, "''")}'`;

async function main() {
  const args = process.argv.slice(2);
  const sqlIdx = args.indexOf('--sql');
  const sqlFile = sqlIdx >= 0 ? args[sqlIdx + 1] : null;
  const dry = args.includes('--dry');
  const data = load();

  let client = null;
  let cards;
  if (process.env.DATABASE_URL) {
    client = new Client({ connectionString: normalizePgSslMode(process.env.DATABASE_URL) });
    await client.connect();
    const { rows } = await client.query(`SELECT card_key, public_fields FROM directory_card_edits`);
    cards = rows.map((r) => ({ cardKey: String(r.card_key), fields: r.public_fields || {} }));
  } else {
    cards = data.entries.map((e) => ({ cardKey: e.key, fields: e.raw }));
  }

  const found = suggest(data.terms, cards);
  const perTerm = new Map();
  found.forEach((f) => perTerm.set(f.termKey, (perTerm.get(f.termKey) || 0) + 1));
  const source = client ? 'directory_card_edits' : 'index.html (DATABASE_URL unset)';
  console.log(`${found.length} suggestions across ${perTerm.size} terms from ${cards.length} cards (${source})`);
  [...perTerm.entries()].sort((a, b) => b[1] - a[1]).forEach(([k, n]) => console.log(`  ${String(n).padStart(4)}  ${k}`));

  try {
    if (dry) return;
    if (sqlFile) {
      const values = found
        .map((f) => `  (${sqlStr(f.termKey)}, ${sqlStr(f.cardKey)}, ${sqlStr(f.matched)})`)
        .join(',\n');
      const name = path.basename(sqlFile);
      const today = new Date().toISOString().slice(0, 10);
      const sql = `-- ${name} (${today})
-- Glossary-card link suggestions from scripts/suggest_glossary_links.js (${found.length} suggestions,
-- text source: ${source}). They stay hidden until approved in /admin#glossary.
-- Cards that are not in directory_card_edits are skipped by the join. Existing links,
-- approved or rejected, are left as they are.
-- Requires 064. Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO glossary_card_links (term_key, card_key, status, matched_text)
SELECT v.term_key, c.card_key, 'suggested', v.matched_text
  FROM (VALUES
${values}
  ) AS v (term_key, card_key, matched_text)
  JOIN directory_card_edits c ON replace(c.card_key, E'\\r', '') = v.card_key
ON CONFLICT (term_key, card_key) DO NOTHING;

COMMIT;
`;
      fs.writeFileSync(path.resolve(sqlFile), sql, 'utf8');
      console.log(`Wrote ${sqlFile}`);
      return;
    }
    if (!client) {
      console.log('DATABASE_URL is not set. Use --sql FILE to write a migration instead.');
      return;
    }
    let inserted = 0;
    for (const f of found) {
      const r = await client.query(
        `INSERT INTO glossary_card_links (term_key, card_key, status, matched_text)
         VALUES ($1, $2, 'suggested', $3)
         ON CONFLICT (term_key, card_key) DO NOTHING`,
        [f.termKey, f.cardKey, f.matched]
      );
      inserted += r.rowCount || 0;
    }
    console.log(`Inserted ${inserted} new suggestions (existing links were left as they are).`);
  } finally {
    if (client) await client.end().catch(() => {});
  }
}

if (require.main === module) {
  main().catch((err) => {
    console.error(err);
    process.exit(1);
  });
}

module.exports = { suggest, phrasesFor, matcherFor };
