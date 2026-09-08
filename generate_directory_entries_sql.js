// generate_directory_entries_sql.js
// Optional: rebuild the legacy bulk snapshot directory_entries_insert.sql from index.html.
// Normal workflow: edit index.html + add a numbered scripts/00N_*.sql migration (do not regenerate the snapshot).
// Usage: node generate_directory_entries_sql.js
//
// DATA extraction lives in scripts/lib/extract_data.js, shared with build_pages.js and
// build_export.js so there is only one parser of index.html.

const fs = require('fs');
const path = require('path');
const { readIndexHtml, evaluateLiterals, slugify } = require('./scripts/lib/extract_data');

// -----------------------------
// 1. Load index.html and extract DATA
// -----------------------------

const html = readIndexHtml();
const { DATA } = evaluateLiterals(html, ['HARAVOT_BARZEL_SEARCH', 'DATA']);

if (!DATA || typeof DATA !== 'object') {
  console.error('DATA is not an object after evaluation.');
  process.exit(1);
}

// -----------------------------
// 2. Build deduplicated entries
// -----------------------------

// Map keyed by logical identity: org + svc
// value: { entryId, displayName, description, primaryCategory, categoryKeys: Set<string> }
const entries = new Map();

for (const [categoryKey, cat] of Object.entries(DATA)) {
  const sources = [];
  if (cat && Array.isArray(cat.services)) {
    sources.push({ services: cat.services, extraKeys: [] });
  }
  if (cat && cat.subsections && typeof cat.subsections === 'object') {
    for (const [subsectionKey, subsection] of Object.entries(cat.subsections)) {
      const subsectionServices = subsection && Array.isArray(subsection.services) ? subsection.services : [];
      if (subsectionServices.length) {
        sources.push({
          services: subsectionServices,
          extraKeys: [`${categoryKey}_${subsectionKey}`],
        });
      }
    }
  }

  for (const { services, extraKeys } of sources) {
    for (const svc of services) {
      const org = svc.org || '';
      const desc = svc.svc || '';
      const logicalKey = `${org}|||${desc}`;

      if (entries.has(logicalKey)) {
        // Already seen: just add category to set
        const existing = entries.get(logicalKey);
        existing.categoryKeys.add(categoryKey);
        for (const k of extraKeys) existing.categoryKeys.add(k);
        continue;
      }

      const displayName = org;
      const description = desc || null;

      // Primary category is where we first saw it
      const primaryCategory = categoryKey;

      // For entry_id, prefer org-based slug; fall back to category+row
      const rowId =
        svc.row != null && svc.row !== ''
          ? String(svc.row)
          : slugify(displayName || categoryKey || 'entry');

      const baseSlug =
        displayName && displayName.trim() !== ''
          ? slugify(displayName)
          : `${categoryKey}_${rowId}`;

      const entryId = `${baseSlug || categoryKey}_${rowId}`;

      entries.set(logicalKey, {
        entryId,
        displayName,
        description,
        primaryCategory,
        categoryKeys: new Set([categoryKey, ...extraKeys]),
      });
    }
  }
}

// -----------------------------
// 3. Generate SQL INSERT
// -----------------------------

const rows = [];

const esc = (s) => String(s).replace(/'/g, "''");

for (const entry of entries.values()) {
  const { entryId, displayName, description, primaryCategory, categoryKeys } = entry;

  const entryIdSql = `'${esc(entryId)}'`;
  const displayNameSql = `'${esc(displayName)}'`;
  const descriptionSql = description ? `'${esc(description)}'` : 'NULL';
  const primaryCategorySql = `'${esc(primaryCategory)}'`;

  const cats = Array.from(categoryKeys);
  const catsSql =
    'ARRAY[' +
    cats.map((c) => `'${esc(c)}'`).join(', ') +
    ']::text[]';

  rows.push(
    `  (${entryIdSql}, ${displayNameSql}, ${descriptionSql}, ${primaryCategorySql}, ${catsSql})`
  );
}

if (rows.length === 0) {
  console.error('No entries found in DATA. Check that DATA.services or DATA.subsections[].services arrays are present.');
  process.exit(1);
}

let sql = '';
sql += '-- Generated INSERT for directory_entries from index.html DATA\n';
sql += 'INSERT INTO directory_entries (\n';
sql += '  entry_id,\n';
sql += '  display_name,\n';
sql += '  description,\n';
sql += '  primary_category,\n';
sql += '  category_keys\n';
sql += ')\nVALUES\n';
sql += rows.join(',\n');
sql += ';\n';

// Write directly as UTF-8 instead of printing to stdout
const OUT_PATH = path.join(__dirname, 'directory_entries_insert.sql');
fs.writeFileSync(OUT_PATH, sql, { encoding: 'utf8' });

console.log('Wrote SQL to', OUT_PATH);
