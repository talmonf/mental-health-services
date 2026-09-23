/**
 * directory_card_edits is the published text of a card.
 * index.html still lists which cards exist and which section they sit in. When this
 * overlay runs, each matching database row replaces those visible fields on the
 * in-memory catalog. A cleared field becomes empty; the old wording is not kept.
 *
 * Vercel builds require DATABASE_URL so the pre-rendered pages and directory.json
 * cannot ship the embedded copy by accident. A local build without it keeps the
 * embedded copy and says so.
 */

const { Client } = require('pg');

const PUBLIC_KEYS = [
  'org', 'svc', 'target', 'region', 'cost', 'specialty', 'languages', 'diseases', 'notes', 'tags',
  'whatsapp', 'whatsappLabel', 'email', 'web', 'webLabel', 'web2', 'webLabel2', 'add', 'addLabel',
  'phone', 'phoneLabel', 'phoneShowNumber',
  'phone2', 'phoneLabel2', 'phoneShowNumber2',
  'phone3', 'phoneLabel3', 'phoneShowNumber3',
  'phone4', 'phoneLabel4', 'phoneShowNumber4',
  'phone5', 'phoneLabel5', 'phoneShowNumber5',
  'phone6', 'phoneLabel6', 'phoneShowNumber6',
];

function normalizePgSslMode(connectionString) {
  try {
    const u = new URL(connectionString);
    const mode = u.searchParams.get('sslmode');
    if (mode === 'prefer' || mode === 'require' || mode === 'verify-ca') {
      u.searchParams.set('sslmode', 'verify-full');
    }
    return u.toString();
  } catch {
    return connectionString;
  }
}

/** Replace every visible field. Missing keys are cleared so embedded text cannot remain. */
function replacePublicFields(svc, fields) {
  const src = fields && typeof fields === 'object' ? fields : {};
  for (const key of PUBLIC_KEYS) {
    if (Object.prototype.hasOwnProperty.call(src, key)) {
      svc[key] = src[key];
    } else {
      svc[key] = key.startsWith('phoneShowNumber') ? true : '';
    }
  }
}

async function fetchCardRows() {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    if (process.env.VERCEL) {
      throw new Error(
        'DATABASE_URL is required on Vercel so published pages use directory_card_edits, not the copy in index.html'
      );
    }
    return null;
  }

  const client = new Client({ connectionString: normalizePgSslMode(databaseUrl) });
  await client.connect();
  try {
    const { rows } = await client.query(
      `SELECT card_key, public_fields FROM directory_card_edits`
    );
    return rows;
  } finally {
    await client.end().catch(() => {});
  }
}

/**
 * Mutates entry.raw on `data` from load(). Returns where the text came from.
 * @param {{ entries: Array<{ raw: object }> }} data
 */
async function overlayDirectoryCards(data) {
  const rows = await fetchCardRows();
  if (!rows) return { source: 'index.html fallback (DATABASE_URL unset)', applied: 0, rows: 0 };

  const byKey = new Map();
  for (const row of rows) {
    if (row && row.card_key) byKey.set(String(row.card_key), row.public_fields);
  }

  let applied = 0;
  const seen = new Set();
  for (const entry of data.entries || []) {
    const svc = entry && entry.raw;
    if (!svc || seen.has(svc)) continue;
    seen.add(svc);
    const key = `${svc.row}|||${svc.svc || ''}`;
    const fields = byKey.get(key);
    if (!fields) continue;
    replacePublicFields(svc, fields);
    applied++;
  }

  return { source: 'directory_card_edits', applied, rows: rows.length };
}

module.exports = { overlayDirectoryCards, replacePublicFields, PUBLIC_KEYS };
