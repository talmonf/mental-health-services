// Shared extractor for the data structures embedded in index.html.
//
// index.html is the source of truth: a single static file whose JSX is transpiled in the
// browser. Everything downstream (the SQL snapshot generator, the static page builder, the
// JSON export) reads DATA from it rather than keeping a second copy.
//
// Consumers: generate_directory_entries_sql.js, build_pages.js, build_export.js,
// facet_coverage.js, propose_referral_routes.js.

const fs = require('fs');
const path = require('path');
const vm = require('vm');

const INDEX_PATH = path.join(__dirname, '..', '..', 'index.html');

const DQ = '"';
const SQ = "'";
const BT = '`';

function readIndexHtml(indexPath = INDEX_PATH) {
  return fs.readFileSync(indexPath, 'utf8');
}

/**
 * Walk from the opening brace/bracket of a top-level declaration to its match, skipping
 * over string literals so a brace inside Hebrew prose does not end the scan early.
 * Returns the source text of the literal, or null if the name is not a literal declaration.
 */
function extractLiteralSource(html, name) {
  const re = new RegExp(`(?:const|let|var)\\s+${name}\\s*=\\s*`, 'g');
  const m = re.exec(html);
  if (!m) return null;

  const start = m.index + m[0].length;
  const open = html[start];
  if (open !== '{' && open !== '[') return null;
  const close = open === '{' ? '}' : ']';

  let depth = 0;
  let inString = false;
  let quote = null;
  let escapeNext = false;

  for (let i = start; i < html.length; i++) {
    const ch = html[i];

    if (escapeNext) {
      escapeNext = false;
      continue;
    }
    if (inString) {
      if (ch === '\\') escapeNext = true;
      else if (ch === quote) {
        inString = false;
        quote = null;
      }
      continue;
    }
    if (ch === DQ || ch === SQ || ch === BT) {
      inString = true;
      quote = ch;
      continue;
    }
    if (ch === open) depth++;
    else if (ch === close) {
      depth--;
      if (depth === 0) return html.slice(start, i + 1);
    }
  }
  return null;
}

/**
 * Evaluate named literals from index.html in one shared sandbox, in the order given, so a
 * literal may reference one declared before it (HARAVOT_BARZEL_NEW_ENTRIES refers to
 * HARAVOT_BARZEL_SEARCH). Missing names come back undefined rather than throwing.
 */
function evaluateLiterals(html, names) {
  const sandbox = {};
  vm.createContext(sandbox);
  const out = {};

  for (const name of names) {
    const src = extractLiteralSource(html, name);
    if (src == null) {
      // Not a literal: it may be a plain scalar such as LAST_UPDATED, or a Set/new expression.
      const scalar = new RegExp(`(?:const|let|var)\\s+${name}\\s*=\\s*(['"\`])([^'"\`]*)\\1`).exec(html);
      out[name] = scalar ? scalar[2] : undefined;
      if (scalar) sandbox[name] = scalar[2];
      continue;
    }
    try {
      vm.runInContext(`${name} = ${src};`, sandbox, { timeout: 5000 });
      out[name] = sandbox[name];
    } catch (err) {
      throw new Error(`Failed to evaluate ${name} from index.html: ${err.message}`);
    }
  }
  return out;
}

/** Same slug rule as mhGetEntryId in index.html — keep the two in step. */
function slugify(str) {
  return String(str)
    .toLowerCase()
    .replace(/[^a-zA-Z0-9א-ת]+/g, '_')
    .replace(/^_+|_+$/g, '')
    .slice(0, 60);
}

/** The legacy Hebrew entry_id still used by directory_entries and by old share links. */
function getEntryId(svc, categoryKey) {
  const displayName = svc.org || '';
  const rowId =
    svc.row != null && svc.row !== '' ? String(svc.row) : slugify(displayName || categoryKey || 'entry');
  const baseSlug = displayName && displayName.trim() !== '' ? slugify(displayName) : `${categoryKey}_${rowId}`;
  return `${baseSlug || categoryKey}_${rowId}`;
}

/** Every phone slot an entry can carry: phone, phone2..phone6, each with a label and a show flag. */
const PHONE_SLOTS = [1, 2, 3, 4, 5, 6];

function phonesOf(svc) {
  const out = [];
  for (const n of PHONE_SLOTS) {
    const suffix = n === 1 ? '' : String(n);
    const number = svc[`phone${suffix}`];
    if (!number || !String(number).trim()) continue;
    out.push({
      slot: n,
      number: String(number).trim(),
      label: (svc[`phoneLabel${suffix}`] || '').trim() || null,
      showNumber: svc[`phoneShowNumber${suffix}`] !== false,
    });
  }
  return out;
}

/**
 * Build the canonical entry list.
 *
 * Entries are multi-homed: the same service appears under several categories, and the
 * Haravot Barzel and national-NGO arrays are merged into categories at runtime by the app.
 * Identity is (row, svc) — org alone is not unique (Sharan Medical is five services) and
 * row alone is not unique either (see rowCollisions below).
 */
function buildEntries(literals) {
  const { DATA, HARAVOT_BARZEL_NEW_ENTRIES = [], NATIONAL_NGO_ENTRIES = [] } = literals;
  const byKey = new Map();

  const identity = (svc) => `${svc.row}|||${svc.svc || ''}`;

  const upsert = (svc, categoryKey, subsectionKey) => {
    const key = identity(svc);
    if (!byKey.has(key)) {
      byKey.set(key, {
        key,
        row: svc.row,
        org: (svc.org || '').trim(),
        svc: (svc.svc || '').trim(),
        entryId: getEntryId(svc, categoryKey),
        categories: [],
        subsections: [],
        raw: svc,
      });
    }
    const entry = byKey.get(key);
    if (categoryKey && !entry.categories.includes(categoryKey)) entry.categories.push(categoryKey);
    if (subsectionKey) {
      const composite = `${categoryKey}/${subsectionKey}`;
      if (!entry.subsections.includes(composite)) entry.subsections.push(composite);
    }
    return entry;
  };

  for (const [categoryKey, cat] of Object.entries(DATA)) {
    if (Array.isArray(cat.services)) {
      for (const svc of cat.services) upsert(svc, categoryKey, null);
    }
    if (cat.subsections) {
      for (const [subKey, sub] of Object.entries(cat.subsections)) {
        for (const svc of sub.services || []) upsert(svc, categoryKey, subKey);
      }
    }
  }

  // Runtime-injected entries. The app skips injection when the row already exists in the
  // category (index.html mirrors this with a row-number check), so match that behaviour.
  for (const item of [...HARAVOT_BARZEL_NEW_ENTRIES, ...NATIONAL_NGO_ENTRIES]) {
    for (const categoryKey of item.categories || []) upsert(item.entry, categoryKey, null);
  }

  // Insertion order, deliberately not sorted: it is DATA order, which is what decides
  // which entry keeps the bare /s/<row> when a row is shared. Sorting here would make
  // that assignment depend on Hebrew collation instead.
  return [...byKey.values()].map((e, i) => ({ ...e, dataOrder: i }));
}

/**
 * Rows shared by more than one entry. `row` is treated as the permanent public identifier,
 * but it is not actually unique in the source: row 15 belongs to two different organisations.
 * The page builder needs this to keep URLs stable, and the maintainer needs it to fix the data.
 */
function rowCollisions(entries) {
  const byRow = new Map();
  for (const e of entries) {
    if (!byRow.has(e.row)) byRow.set(e.row, []);
    byRow.get(e.row).push(e);
  }
  return [...byRow.entries()]
    .filter(([, list]) => list.length > 1)
    .map(([row, list]) => ({ row, entries: list }));
}

/**
 * Public URL path for an entry.
 * Unique rows get /s/<row>. Colliding rows keep /s/<row> for the first entry in DATA order
 * and give later ones a deterministic 4-char discriminator, so no existing path ever moves
 * when an unrelated entry is added.
 */
function entryPath(entry, collisionIndex) {
  if (!collisionIndex) return `/s/${entry.row}`;
  return `/s/${entry.row}-${collisionIndex}`;
}

function shortHash(str) {
  let h = 2166136261;
  for (let i = 0; i < str.length; i++) {
    h ^= str.charCodeAt(i);
    h = Math.imul(h, 16777619);
  }
  return (h >>> 0).toString(36).slice(0, 4);
}

/**
 * Assign a stable path to every entry, resolving row collisions deterministically.
 * Must be called on DATA-ordered entries: the first occurrence of a row keeps /s/<row>,
 * which is the same entry the app resolves ?entry=<row> to by default.
 */
function assignPaths(entries) {
  const seenRow = new Map();
  for (const e of entries) {
    const n = seenRow.get(e.row) || 0;
    seenRow.set(e.row, n + 1);
    e.path = n === 0 ? entryPath(e, null) : entryPath(e, shortHash(e.key));
    e.rowIsAmbiguous = false;
  }
  for (const { entries: list } of rowCollisions(entries)) {
    for (const e of list) e.rowIsAmbiguous = true;
  }
  return entries;
}

const LITERAL_NAMES = [
  'HARAVOT_BARZEL_SEARCH',
  'DATA',
  'HARAVOT_BARZEL_NEW_ENTRIES',
  'NATIONAL_NGO_ENTRIES',
  'CATEGORY_GROUPS',
  'CAT_ICONS',
  'TERM_CATEGORIES',
  'terms',
  'ENTRY_LOCATIONS',
  'FILMS',
  'LAST_UPDATED',
];

/** One call that gives every consumer the same view of index.html. */
function load(indexPath = INDEX_PATH) {
  const html = readIndexHtml(indexPath);
  const literals = evaluateLiterals(html, LITERAL_NAMES);

  if (!literals.DATA || typeof literals.DATA !== 'object') {
    throw new Error('DATA could not be extracted from index.html');
  }

  // Paths are assigned in DATA order, then the list is sorted by row for stable output.
  const inDataOrder = assignPaths(buildEntries(literals));
  const entries = [...inDataOrder].sort((a, b) => a.row - b.row || a.dataOrder - b.dataOrder);

  attachReferralCodes(entries);

  return {
    html,
    ...literals,
    entries,
    entriesInDataOrder: inDataOrder,
    collisions: rowCollisions(entries),
    byRow: new Map(entries.map((e) => [e.row, e])),
    byPath: new Map(entries.map((e) => [e.path, e])),
  };
}

/**
 * Overlay referral_route codes from scripts/referral_codes.json onto each entry's raw
 * object. The free-text notes/cost/target fields are never written. Missing file = no codes.
 */
function attachReferralCodes(entries) {
  const p = path.join(__dirname, '..', 'referral_codes.json');
  if (!fs.existsSync(p)) return;
  let overlay;
  try {
    overlay = JSON.parse(fs.readFileSync(p, 'utf8'));
  } catch {
    return;
  }
  const rows = overlay.rows || overlay;
  for (const e of entries) {
    const rec = rows[String(e.row)];
    if (!rec) continue;
    e.raw.referralCodes = Array.isArray(rec.codes) ? rec.codes : [];
    e.raw.referralSource = rec.source || '';
  }
}

function referralLabel(code, lang = 'he') {
  const vocabPath = path.join(__dirname, '..', 'vocabularies.json');
  if (!fs.existsSync(vocabPath)) return code;
  const vocab = JSON.parse(fs.readFileSync(vocabPath, 'utf8'));
  const term = (vocab.referral_route?.terms || []).find((t) => t.code === code);
  if (!term) return code;
  return lang === 'en' ? term.label_en : term.label_he;
}

module.exports = {
  load,
  readIndexHtml,
  extractLiteralSource,
  evaluateLiterals,
  buildEntries,
  rowCollisions,
  assignPaths,
  phonesOf,
  getEntryId,
  slugify,
  shortHash,
  PHONE_SLOTS,
  INDEX_PATH,
  attachReferralCodes,
  referralLabel,
};
