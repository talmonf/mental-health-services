// Merge Nominatim hits + city fallbacks into ENTRY_LOCATIONS JS and SQL.
const fs = require('fs');
const path = require('path');

function slugify(str) {
  return String(str || '')
    .toLowerCase()
    .replace(/[^a-zA-Z0-9א-ת]+/g, '_')
    .replace(/^_+|_+$/g, '')
    .slice(0, 60);
}

const geocoded = JSON.parse(fs.readFileSync(path.join(__dirname, 'directory_locations_geocoded.json'), 'utf8'));
const cities = JSON.parse(fs.readFileSync(path.join(__dirname, 'directory_locations_cities_geocoded.json'), 'utf8'));
const cityByLabel = {};
for (const c of cities) {
  if (c.lat != null) cityByLabel[c.label] = c;
}

const CITY = {
  jerusalem: cityByLabel.jerusalem,
  telaviv: cityByLabel.telaviv,
  haifa: cityByLabel.haifa,
  beersheba: cityByLabel.beersheba,
  bneibrak: cityByLabel.bneibrak,
  beitshemesh: cityByLabel.beitshemesh,
  ramatbeitshemesh: cityByLabel.ramatbeitshemesh,
  ramatgan: cityByLabel.ramatgan,
  afula: cityByLabel.afula,
  netanya: cityByLabel.netanya,
  hadassah: cityByLabel.hadassah,
};

const ICHILOV = { lat: 32.080381, lng: 34.790155, address: 'בית החולים איכילוב, תל אביב' };

const fallbacks = [
  { row: 39, org: 'אגף השיקום, משרד הבטחון', label: 'באר שבע', address: 'בית בטוח, באר שבע', city: 'beersheba' },
  { row: 39, org: 'אגף השיקום, משרד הבטחון', label: 'ירושלים', address: 'בית בטוח, ירושלים', city: 'jerusalem' },
  { row: 60, org: 'עמותת בית חם', label: 'בני ברק', address: 'עמותת בית חם, בני ברק', city: 'bneibrak' },
  { row: 62, org: 'עמותת בית חם', label: 'בני ברק', address: 'מרפאות בית חם, בני ברק', city: 'bneibrak' },
  { row: 63, org: 'הדספייס', label: 'תל אביב', address: 'הדספייס, תל אביב', city: 'telaviv' },
  { row: 63, org: 'הדספייס', label: 'ירושלים', address: 'הדספייס, ירושלים', city: 'jerusalem' },
  { row: 63, org: 'הדספייס', label: 'חיפה', address: 'הדספייס, חיפה', city: 'haifa' },
  { row: 63, org: 'הדספייס', label: 'באר שבע', address: 'הדספייס, באר שבע', city: 'beersheba' },
  { row: 65, org: 'מכון למרחב', label: 'ירושלים', address: 'מכון למרחב, ירושלים', city: 'jerusalem' },
  { row: 70, org: 'עמך', label: 'תל אביב', address: 'עמך, תל אביב', city: 'telaviv' },
  { row: 80, org: 'Amudim', label: 'Jerusalem', address: 'Amudim, Jerusalem', city: 'jerusalem' },
  { row: 91, org: "Hakshiva Therapy Clinic - הקשיבה", label: 'רמת בית שמש', address: 'הקשיבה, רמת בית שמש', city: 'ramatbeitshemesh' },
  { row: 92, org: 'חבלי קשר - Hevlei Kesher', label: 'ירושלים', address: 'חבלי קשר, ירושלים', city: 'jerusalem' },
  { row: 94, org: 'המרכז הישראלי להתמכרויות (ICA)', label: 'נתניה', address: 'ICA, נתניה', city: 'netanya' },
  { row: 102, org: "Kav L'Noar (Merchav L'Noar)", label: 'Jerusalem', address: "Kav L'Noar, Jerusalem", city: 'jerusalem' },
  { row: 102, org: "Kav L'Noar (Merchav L'Noar)", label: 'Beit Shemesh', address: "Kav L'Noar, Beit Shemesh", city: 'beitshemesh' },
  { row: 205, org: 'רזולוציה', label: 'תל אביב', address: 'רזולוציה, תל אביב', city: 'telaviv' },
  { row: 210, org: 'מטיב (המרכז הישראלי לפסיכוטראומה)', label: 'ירושלים', address: 'מטיב, הדסה עין כרם', city: 'hadassah' },
  { row: 211, org: 'רטורנו — חוות חוסן', label: 'מושב שמש', address: 'חוות רטורנו, מושב שמש', lat: 31.74079, lng: 34.9778 },
  { row: 219, org: 'נשימה מרחב בעמק', label: 'משק פרזון', address: 'מושב משק פרזון, עמק יזרעאל', city: 'afula' },
  { row: 230, org: 'חיבוק ברזל (רטורנו)', label: 'חוות שמש', address: 'חוות רטורנו, מושב שמש', lat: 31.74079, lng: 34.9778 },
  { row: 235, org: 'לב השרון', label: 'מרכז רפואי לב השרון', address: 'מרכז רפואי לב השרון', city: 'netanya' },
  { row: 241, org: 'יחידה להתערבות במשבר — מרכז רפואי העמק (כללית)', label: 'עפולה', address: 'מרכז רפואי העמק, עפולה', city: 'afula' },
  { row: 248, org: 'עמותת אפשר — יחידה להתמכרויות', label: 'רמת גן', address: 'עמותת אפשר, רמת גן', city: 'ramatgan' },
  { row: 250, org: 'דרך אחרת', label: 'בית שמש', address: 'דרך אחרת, בית שמש', city: 'beitshemesh' },
  { row: 24, org: 'מטיבת"א (מרכז טיפול יעוץ במשפחה תורני)', label: 'ירושלים', address: 'מטיבת"א, ירושלים', city: 'jerusalem' },
  { row: 6, org: 'אנוש', label: 'תל אביב', address: 'עמותת אנוש, תל אביב', city: 'telaviv' },
  { row: 52, org: 'מילם (מרכז ייעוץ למשפחות מתמודדים)', label: 'תל אביב', address: 'מילם / אנוש, תל אביב', city: 'telaviv' },
  { row: 108, org: '(איכילוב) TMS - גרייה מגנטית מוחית', label: 'איכילוב', address: ICHILOV.address, lat: ICHILOV.lat, lng: ICHILOV.lng },
];

function locFromHit(h) {
  return {
    row: h.row,
    org: h.org,
    label: h.label,
    address: h.address,
    lat: Number(Number(h.lat).toFixed(6)),
    lng: Number(Number(h.lng).toFixed(6)),
  };
}

const byKey = new Map();
function add(item) {
  if (item.lat == null || item.lng == null || !item.row) return;
  const k = `${item.row}::${item.label}`;
  if (byKey.has(k)) return;
  byKey.set(k, locFromHit(item));
}

for (const h of geocoded) {
  if (h.lat != null) add(h);
}
for (const f of fallbacks) {
  if (f.lat != null) {
    add(f);
    continue;
  }
  const c = CITY[f.city];
  if (!c) continue;
  add({ ...f, lat: c.lat, lng: c.lng });
}

const locations = Array.from(byKey.values()).sort((a, b) => a.row - b.row || String(a.label).localeCompare(String(b.label), 'he'));

const grouped = {};
for (const loc of locations) {
  if (!grouped[loc.row]) grouped[loc.row] = [];
  grouped[loc.row].push({ label: loc.label, address: loc.address, lat: loc.lat, lng: loc.lng });
}

const jsLines = ['        const ENTRY_LOCATIONS = {'];
const rows = Object.keys(grouped).map(Number).sort((a, b) => a - b);
for (const row of rows) {
  const arr = grouped[row];
  const inner = arr
    .map((p) => `{ label: ${JSON.stringify(p.label)}, address: ${JSON.stringify(p.address)}, lat: ${p.lat}, lng: ${p.lng} }`)
    .join(', ');
  jsLines.push(`            ${row}: [${inner}],`);
}
jsLines.push('        };');

fs.writeFileSync(path.join(__dirname, 'directory_locations_entry_object.js'), jsLines.join('\n') + '\n', 'utf8');

function esc(s) {
  return String(s).replace(/'/g, "''");
}

const sqlRows = [];
let sort = 0;
let lastRow = null;
for (const loc of locations) {
  if (loc.row !== lastRow) {
    sort = 0;
    lastRow = loc.row;
  }
  const entryId = `${slugify(loc.org)}_${loc.row}`;
  sqlRows.push(
    `  (${loc.row}, '${esc(entryId)}', '${esc(loc.label)}', '${esc(loc.address)}', ${loc.lat}, ${loc.lng}, ${sort})`
  );
  sort += 1;
}

const sql = `-- Migration 022 (Aug 2026)
-- Physical sites for directory cards (Google Maps + nearby search).
-- Coordinates from Nominatim (OpenStreetMap), curated from this directory's own listings.

BEGIN;

CREATE TABLE IF NOT EXISTS directory_entry_locations (
  id serial PRIMARY KEY,
  row_id integer NOT NULL,
  entry_id text NOT NULL,
  label text NOT NULL,
  address text,
  lat double precision NOT NULL,
  lng double precision NOT NULL,
  sort_order integer NOT NULL DEFAULT 0
);

CREATE UNIQUE INDEX IF NOT EXISTS directory_entry_locations_row_label_uidx
  ON directory_entry_locations (row_id, label);

COMMENT ON TABLE directory_entry_locations IS 'Geocoded physical sites for directory_entries.row; used by the live UI via index.html ENTRY_LOCATIONS.';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
VALUES
${sqlRows.join(',\n')}
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

COMMIT;
`;

fs.writeFileSync(path.join(__dirname, '022_directory_entry_locations.sql'), sql, 'utf8');
console.log(`locations: ${locations.length} points, ${rows.length} rows`);
console.log('rows', rows.join(','));
