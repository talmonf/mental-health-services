// One-time Nominatim geocode of curated physical sites (1 req/s).
// Usage: node scripts/geocode_directory_locations.js
const fs = require('fs');
const path = require('path');

const QUERIES_PATH = path.join(__dirname, process.argv[2] || 'directory_locations_queries.json');
const OUT_PATH = path.join(__dirname, process.argv[3] || 'directory_locations_geocoded.json');
const USER_AGENT = 'mental-health-services-directory/1.0 (https://nefesh-il.org; geocode script)';

function sleep(ms) {
  return new Promise((r) => setTimeout(r, ms));
}

async function nominatimSearch(q) {
  const url = new URL('https://nominatim.openstreetmap.org/search');
  url.searchParams.set('q', q);
  url.searchParams.set('format', 'json');
  url.searchParams.set('limit', '1');
  url.searchParams.set('countrycodes', 'il');
  url.searchParams.set('addressdetails', '0');
  const res = await fetch(url, { headers: { 'User-Agent': USER_AGENT, Accept: 'application/json' } });
  if (!res.ok) throw new Error(`Nominatim ${res.status} for ${q}`);
  const data = await res.json();
  return Array.isArray(data) && data[0] ? data[0] : null;
}

async function main() {
  const queries = JSON.parse(fs.readFileSync(QUERIES_PATH, 'utf8'));
  const results = [];
  for (let i = 0; i < queries.length; i++) {
    const item = queries[i];
    let hit = null;
    let err = null;
    try {
      hit = await nominatimSearch(item.query);
    } catch (e) {
      err = String(e && e.message ? e.message : e);
    }
    const row = {
      row: item.row,
      org: item.org,
      label: item.label,
      address: item.address,
      query: item.query,
      lat: hit ? Number(hit.lat) : null,
      lng: hit ? Number(hit.lon) : null,
      displayName: hit ? hit.display_name : null,
      error: err,
    };
    results.push(row);
    console.log(
      `[${i + 1}/${queries.length}] row ${item.row} ${item.label}:`,
      row.lat != null ? `${row.lat.toFixed(5)},${row.lng.toFixed(5)}` : `FAIL ${err || 'no hit'}`
    );
    await sleep(1100);
  }
  fs.writeFileSync(OUT_PATH, JSON.stringify(results, null, 2), 'utf8');
  const ok = results.filter((r) => r.lat != null).length;
  console.log(`Wrote ${OUT_PATH} (${ok}/${results.length} geocoded)`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
