// generate_directory_entries_sql.js
// Usage:
//   cd to the folder that contains index.html
//   node generate_directory_entries_sql.js > directory_entries_insert.sql

const fs = require('fs');
const path = require('path');
const vm = require('vm');

// -----------------------------
// 1. Load index.html and extract DATA
// -----------------------------

const INDEX_PATH = path.join(__dirname, 'index.html');
const html = fs.readFileSync(INDEX_PATH, 'utf8');

const marker = 'const DATA =';
const markerIndex = html.indexOf(marker);
if (markerIndex === -1) {
  throw new Error('Could not find "const DATA =" in index.html');
}

// Find the first '{' after "const DATA ="
let start = html.indexOf('{', markerIndex);
if (start === -1) {
  throw new Error('Could not find opening "{" for DATA in index.html');
}

// Walk character by character to find the matching closing '}'.
// We handle nested braces and string literals so we don't stop early.
let depth = 0;
let inString = false;
let stringQuote = null;
let escapeNext = false;
let end = -1;

for (let i = start; i < html.length; i++) {
  const ch = html[i];

  if (escapeNext) {
    escapeNext = false;
    continue;
  }

  if (inString) {
    if (ch === '\\') {
      escapeNext = true;
    } else if (ch === stringQuote) {
      inString = false;
      stringQuote = null;
    }
    continue;
  }

  if (ch === '"' || ch === "'") {
    inString = true;
    stringQuote = ch;
    continue;
  }

  if (ch === '{') {
    depth++;
  } else if (ch === '}') {
    depth--;
    if (depth === 0) {
      end = i;
      break;
    }
  }
}

if (end === -1) {
  throw new Error('Could not find closing "}" for DATA in index.html');
}

const dataSource = html.slice(start, end + 1);

// Evaluate the DATA object in a sandboxed VM context
const sandbox = {};
vm.createContext(sandbox);

try {
  vm.runInContext('DATA = ' + dataSource + ';', sandbox, { timeout: 2000 });
} catch (err) {
  console.error('Failed to evaluate DATA from index.html:', err);
  process.exit(1);
}

const DATA = sandbox.DATA;
if (!DATA || typeof DATA !== 'object') {
  console.error('DATA is not an object after evaluation.');
  process.exit(1);
}

// -----------------------------
// 2. Build deduplicated entries
// -----------------------------

function slugify(str) {
  return String(str)
    .toLowerCase()
    // keep Hebrew/Latin letters and digits; replace others with _
    .replace(/[^a-zA-Z0-9א-ת]+/g, '_')
    .replace(/^_+|_+$/g, '')
    .slice(0, 60);
}

// Map keyed by logical identity: org + svc
// value: { entryId, displayName, description, primaryCategory, categoryKeys: Set<string> }
const entries = new Map();

for (const [categoryKey, cat] of Object.entries(DATA)) {
  const services = cat && Array.isArray(cat.services) ? cat.services : [];
  for (const svc of services) {
    const org = svc.org || '';
    const desc = svc.svc || '';
    const logicalKey = `${org}|||${desc}`;

    if (entries.has(logicalKey)) {
      // Already seen: just add category to set
      entries.get(logicalKey).categoryKeys.add(categoryKey);
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
      categoryKeys: new Set([categoryKey]),
    });
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

// ... keep everything above unchanged ...

if (rows.length === 0) {
  console.error('No entries found in DATA. Check that DATA.services arrays are present.');
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