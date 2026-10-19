// Builds migration 099 and the index.html cards for the multidisciplinary-centers spreadsheet.
//   node scripts/generate_mh_public_centers.js prepare
//   node scripts/geocode_directory_locations.js <queries> <out>
//   node scripts/generate_mh_public_centers.js emit <geocoded.json>
//
// Checked centers that already have a card are not rewritten. A public row is folded
// into an existing card only when its phone matches that card and the names overlap.
// תלם (row 203) is never a match target.

const fs = require('fs');
const path = require('path');
const os = require('os');
const { load, phonesOf } = require('./lib/extract_data');

const XLSX = process.argv[3] && process.argv[2] !== 'prepare' && process.argv[2] !== 'emit'
  ? process.argv[3]
  : path.join(
      'C:\\Users\\Owner\\My Drive\\Social Work\\Projects\\Mental Health Resources',
      'מרכזי בריאות הנפש  רב-צוותיים.xlsx'
    );
const WORK = path.join(os.tmpdir(), 'mh-public-centers');
const DRAFT = path.join(WORK, 'draft.json');
const QUERIES = path.join(WORK, 'queries.json');

const NS = 'http://schemas.openxmlformats.org/spreadsheetml/2006/main';

function slugify(str) {
  return String(str)
    .toLowerCase()
    .replace(/[^a-zA-Z0-9א-ת]+/g, '_')
    .replace(/^_+|_+$/g, '')
    .slice(0, 60);
}

function norm(s) {
  return String(s || '')
    .replace(/[״"׳']/g, '')
    .replace(/\s+/g, ' ')
    .trim()
    .toLowerCase();
}

function clip(s, max) {
  const t = String(s || '').replace(/\s+/g, ' ').trim();
  return t.length > max ? t.slice(0, max).trim() : t;
}

function phoneKey(raw) {
  let d = String(raw || '').replace(/\D/g, '');
  if (d.startsWith('972')) d = `0${d.slice(3)}`;
  if (d.length < 8) return '';
  return d;
}

function parsePhones(text) {
  const parts = String(text || '')
    .split(/[,;]| ו-/)
    .map((p) => p.replace(/\s+/g, ' ').trim())
    .filter(Boolean);
  const out = [];
  for (const part of parts) {
    const cleaned = part.replace(/^טלפון:\s*/, '').trim();
    if (!cleaned || cleaned.length > 80) continue;
    if (!/\d/.test(cleaned)) continue;
    if (!out.includes(cleaned)) out.push(cleaned);
    if (out.length === 6) break;
  }
  return out;
}

function parseExtra(text) {
  const src = String(text || '').replace(/\n/g, ' ');
  const labels = ['קהל', 'טלפון', 'שיטות טיפול', 'מפעיל', 'מקור', 'התמחויות', 'התמחות'];
  const idxs = [];
  for (const label of labels) {
    const i = src.indexOf(`${label}:`);
    if (i >= 0) idxs.push({ label, i });
  }
  idxs.sort((a, b) => a.i - b.i);
  const out = {};
  for (let n = 0; n < idxs.length; n++) {
    const start = idxs[n].i + idxs[n].label.length + 1;
    const end = n + 1 < idxs.length ? idxs[n + 1].i : src.length;
    out[idxs[n].label] = src
      .slice(start, end)
      .replace(/^[\s.:]+|[\s.]+$/g, '')
      .replace(/\s+/g, ' ')
      .trim();
  }
  return out;
}

function ownershipBucket(raw) {
  const s = String(raw || '').trim();
  if (!s || s === 'לא צוין' || s.includes('לא צוין')) return 'unspecified';
  if (s.startsWith('פרטי')) return 'private';
  if (s.startsWith('בית חולים')) return 'hospital';
  if (s.includes('עמותה') || s.includes('מלכ')) return 'nonprofit';
  if (s === 'קופת חולים') return 'hmo';
  if (s.includes('מרכז ממשלתי')) return 'government';
  return 'unspecified';
}

function kindOf(sheetRow) {
  if (sheetRow <= 16) return 'vetted';
  if (sheetRow <= 344) return 'clinic';
  if (sheetRow <= 377) return 'day';
  return 'hospital';
}

function localityOf(address) {
  const parts = String(address || '')
    .split(',')
    .map((p) => p.trim())
    .filter(Boolean);
  if (!parts.length) return '';
  return clip(parts[parts.length - 1], 500);
}

function cleanWeb(web) {
  const s = String(web || '').trim();
  if (!/^https?:\/\//i.test(s)) return '';
  return clip(s, 2000);
}

function readSheet(file) {
  const zip = require('zlib');
  // xlsx is a zip. Read it with the built-in approach via a tiny unzip using PowerShell-free Node.
  const { execFileSync } = require('child_process');
  // Use Python-free JS: Node 20 has no unzip. Read with the `unzip` equivalent implemented below.
  void zip;
  void execFileSync;
  const buf = fs.readFileSync(file);
  return readXlsxRows(buf);
}

function readXlsxRows(buf) {
  // Minimal ZIP reader for stored/deflated entries named xl/worksheets/sheet2.xml.
  const files = unzip(buf);
  const xml = files['xl/worksheets/sheet2.xml'];
  if (!xml) throw new Error('sheet2 missing');
  const rows = [];
  const rowRe = /<row r="(\d+)"[^>]*>([\s\S]*?)<\/row>/g;
  let m;
  while ((m = rowRe.exec(xml))) {
    const cells = {};
    const cellRe = /<c r="([A-Z]+)\d+"[^>]*>([\s\S]*?)<\/c>/g;
    let c;
    while ((c = cellRe.exec(m[2]))) {
      const is = c[2];
      const texts = [];
      const tRe = /<t[^>]*>([\s\S]*?)<\/t>/g;
      let t;
      while ((t = tRe.exec(is))) texts.push(decodeXml(t[1]));
      cells[c[1]] = texts.join('').trim();
    }
    rows.push({ sheetRow: Number(m[1]), cells });
  }
  return rows;
}

function decodeXml(s) {
  return s
    .replace(/&#(\d+);/g, (_, n) => String.fromCodePoint(Number(n)))
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&quot;/g, '"')
    .replace(/&apos;/g, "'")
    .replace(/&amp;/g, '&');
}

function unzip(buf) {
  const zlib = require('zlib');
  const out = {};
  let o = 0;
  while (o + 30 < buf.length && buf.readUInt32LE(o) === 0x04034b50) {
    const method = buf.readUInt16LE(o + 8);
    const compSize = buf.readUInt32LE(o + 18);
    const nameLen = buf.readUInt16LE(o + 26);
    const extraLen = buf.readUInt16LE(o + 28);
    const name = buf.slice(o + 30, o + 30 + nameLen).toString('utf8');
    const dataStart = o + 30 + nameLen + extraLen;
    const comp = buf.slice(dataStart, dataStart + compSize);
    let data = comp;
    if (method === 8) data = zlib.inflateRawSync(comp);
    else if (method !== 0) throw new Error(`zip method ${method} for ${name}`);
    out[name] = data.toString('utf8');
    o = dataStart + compSize;
  }
  return out;
}

function loadSheetRows() {
  const raw = readSheet(XLSX);
  const rows = [];
  for (const r of raw) {
    if (r.sheetRow === 1) continue;
    const name = (r.cells.H || '').replace(/\s+/g, ' ').trim();
    const ownershipRaw = (r.cells.G || '').trim();
    if (!name || name.startsWith('שורות ') || name.startsWith('הרכב הצוות')) continue;
    const extra = parseExtra(r.cells.A || '');
    const address = (r.cells.F || '').replace(/\s+/g, ' ').trim();
    const phones = parsePhones(extra['טלפון'] || '');
    rows.push({
      sheetRow: r.sheetRow,
      name: clip(name, 300),
      ownershipRaw,
      ownership: ownershipBucket(ownershipRaw),
      payer: clip(r.cells.B || '', 500),
      conditions: clip(r.cells.C || '', 2000),
      staff: (r.cells.D || '').replace(/\s+/g, ' ').trim(),
      web: cleanWeb(r.cells.E || ''),
      address,
      locality: localityOf(address),
      audience: clip(extra['קהל'] || '', 4000),
      methods: clip(extra['שיטות טיפול'] || '', 500),
      operator: clip(extra['מפעיל'] || '', 200),
      phones,
      kind: kindOf(r.sheetRow),
    });
  }
  return rows;
}

const VETTED_RULES = [
  { re: /גוני/, row: 345, ownership: 'private' },
  { re: /ד["״']?ר טל|דר טל/, row: 346, ownership: 'private' },
  { re: /הכח לשנות|הכוח לשנות/, row: 347, ownership: 'private' },
  { re: /קשת/, row: 348, ownership: 'private' },
  { re: /אפרת|רעות/, row: 349, ownership: 'hospital' },
  { re: /fym|מיינדמי|mindme/i, row: null, ownership: null },
  { re: /עד ת/, row: 351, ownership: 'private' },
  { re: /דביר/, row: 352, ownership: 'unspecified' },
  { re: /חוף הגליל/, row: 353, ownership: 'nonprofit' },
  { re: /העמקים/, row: 354, ownership: 'nonprofit' },
  { re: /מעייני/, row: 355, ownership: 'hospital' },
  { re: /בית חם/, row: 62, ownership: 'nonprofit' },
  { re: /עמך|עמיך/, row: 70, ownership: 'nonprofit' },
  { re: /ת\.?\s*ל\.?\s*מ/, row: 0, ownership: 'nonprofit' },
];

function matchVetted(row) {
  if (/fym/i.test(row.name)) return { row: 350, ownership: 'private' };
  if (/mindme|מיינדמי/i.test(row.name)) return { row: 104, ownership: 'private' };
  for (const rule of VETTED_RULES) {
    if (rule.row == null) continue;
    if (rule.re.test(row.name)) return { row: rule.row, ownership: rule.ownership };
  }
  return null;
}

const GENERIC = /עמותת|מרפאת|מרפאה|מרכז|לבריאות|בריאות|הנפש|פסיכיאטרית|פסיכיאטרי|אשפוז|טיפול|יום|מבוגרים|ילדים|נוער|יחידה|מחלקה/g;

function coreName(s) {
  return norm(s).replace(GENERIC, ' ').replace(/\s+/g, ' ').trim();
}

function namesOverlap(sheetName, cardOrg) {
  const core = coreName(cardOrg);
  if (core.length < 3) return false;
  return norm(sheetName).includes(core);
}

function placeKey(row) {
  return `${norm(row.name)}|${norm(row.locality)}`;
}

function svcFor(row) {
  if (row.kind === 'day') return row.name.includes('אשפוז יום') ? 'אשפוז יום פסיכיאטרי' : 'טיפול יום פסיכיאטרי';
  if (row.kind === 'hospital') return 'אשפוז פסיכיאטרי';
  return 'מרפאה רב-צוותית לבריאות הנפש';
}

function sourceLine(row) {
  if (row.kind === 'day') return 'מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023.';
  if (row.kind === 'hospital') return 'מקור: מאגר בתי החולים הפסיכיאטריים והמחלקות הפסיכיאטריות של משרד הבריאות.';
  return 'מקור: מאגר מרפאות בריאות הנפש של משרד הבריאות, עדכון 28.12.2025.';
}

function buildNotes(row, geocoded) {
  const bits = [];
  if (row.ownershipRaw) bits.push(`סוג בעלות: ${row.ownershipRaw}.`);
  if (row.kind !== 'vetted') {
    bits.push('הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו.');
  } else if (row.staff && !row.staff.includes('לפי הגדרת משרד הבריאות')) {
    bits.push(row.staff);
  }
  if (row.methods) bits.push(`שיטות טיפול: ${row.methods}.`);
  if (row.operator && !norm(row.name).includes(norm(row.operator))) bits.push(`מפעיל: ${row.operator}.`);
  if (row.kind !== 'vetted') bits.push(sourceLine(row));
  if (!geocoded && row.address && norm(row.address) !== norm(row.locality)) bits.push(`כתובת: ${row.address}.`);
  return clip(bits.join(' '), 4000);
}

function publicFields(card) {
  const base = {
    org: card.org,
    svc: card.svc,
    target: card.target,
    region: card.region,
    cost: card.cost,
    specialty: card.specialty,
    languages: '',
    diseases: '',
    notes: card.notes,
    tags: '',
    whatsapp: '',
    whatsappLabel: '',
    email: '',
    web: card.web,
    webLabel: '',
    web2: '',
    webLabel2: '',
    add: '',
    addLabel: '',
    phone: card.phones[0] || '',
    phoneLabel: '',
    phoneShowNumber: true,
    phone2: card.phones[1] || '',
    phoneLabel2: '',
    phoneShowNumber2: true,
    phone3: card.phones[2] || '',
    phoneLabel3: '',
    phoneShowNumber3: true,
    phone4: card.phones[3] || '',
    phoneLabel4: '',
    phoneShowNumber4: true,
    phone5: card.phones[4] || '',
    phoneLabel5: '',
    phoneShowNumber5: true,
    phone6: card.phones[5] || '',
    phoneLabel6: '',
    phoneShowNumber6: true,
  };
  return base;
}

function dataObject(card) {
  const o = {
    row: card.row,
    org: card.org,
    svc: card.svc,
    target: card.target,
    region: card.region,
    cost: card.cost,
    specialty: card.specialty,
    notes: card.notes,
    languages: '',
    diseases: '',
    add: '',
    ownership: card.ownership,
    cardTerms: ['multidisciplinary_center'],
  };
  if (card.phones[0]) {
    o.phone = card.phones[0];
    o.phoneShowNumber = true;
  }
  if (card.phones[1]) {
    o.phone2 = card.phones[1];
    o.phoneShowNumber2 = true;
  }
  if (card.web) o.web = card.web;
  return o;
}

function prepare() {
  const sheet = loadSheetRows();
  const data = load();
  let maxRow = 0;
  for (const e of data.entries) if (e.row > maxRow) maxRow = e.row;

  const phoneIndex = new Map();
  for (const e of data.entries) {
    if (e.row === 203) continue;
    for (const p of phonesOf(e.raw)) {
      const key = phoneKey(p.number);
      if (!key) continue;
      if (!phoneIndex.has(key)) phoneIndex.set(key, []);
      const list = phoneIndex.get(key);
      if (!list.some((x) => x.row === e.row)) list.push({ row: e.row, org: e.org });
    }
  }

  const linked = [];
  const unmatchedVetted = [];
  const publicRows = [];

  for (const row of sheet) {
    if (row.kind === 'vetted') {
      const hit = matchVetted(row);
      if (!hit) unmatchedVetted.push(row.name);
      else if (hit.row === 0) publicRows.push({ ...row, category: 'mh_clinics', checked: true });
      else linked.push({ sheetRow: row.sheetRow, name: row.name, row: hit.row, ownership: hit.ownership, via: 'vetted' });
      continue;
    }
    publicRows.push(row);
  }

  const clinics = publicRows.filter((r) => r.kind === 'clinic' || r.checked);
  const clinicPlaces = new Set(publicRows.filter((r) => r.kind === 'clinic').map(placeKey));
  const rest = publicRows.filter((r) => {
    if (r.checked) return true;
    if (r.kind === 'day' && clinicPlaces.has(placeKey(r))) return false;
    return true;
  });
  const droppedDays = publicRows.filter((r) => r.kind === 'day' && clinicPlaces.has(placeKey(r))).length;

  const seen = new Map();
  const unique = [];
  let droppedDupes = 0;
  for (const row of rest) {
    const key = `${placeKey(row)}|${norm(row.audience)}|${row.kind}|${row.checked ? 'c' : ''}`;
    const prev = seen.get(key);
    if (!prev) {
      seen.set(key, row);
      unique.push(row);
    } else {
      droppedDupes += 1;
      if (!prev.phones.length && row.phones.length) {
        const i = unique.indexOf(prev);
        unique[i] = row;
        seen.set(key, row);
      }
    }
  }

  const folded = [];
  const fresh = [];
  for (const row of unique) {
    if (row.checked) {
      fresh.push(row);
      continue;
    }
    let match = null;
    for (const phone of row.phones) {
      const key = phoneKey(phone);
      if (!key) continue;
      const hits = phoneIndex.get(key) || [];
      const named = hits.filter((h) => namesOverlap(row.name, h.org));
      if (named.length === 1) {
        match = named[0];
        break;
      }
    }
    if (match) folded.push({ sheetRow: row.sheetRow, name: row.name, row: match.row, ownership: row.ownership, via: 'phone' });
    else fresh.push(row);
  }

  fresh.sort((a, b) => a.sheetRow - b.sheetRow);
  let next = maxRow + 1;
  const cards = fresh.map((row) => {
    const card = {
      sheetRow: row.sheetRow,
      row: next,
      org: row.checked ? clip(row.name.split(/–|-|—/)[0], 300) : row.name,
      svc: row.checked ? clip(row.name.split(/–|-|—/).slice(1).join(' ').replace(/^\s+|\s+$/g, '') || 'רשת לטיפול פסיכולוגי, ייעוץ ואבחון', 500) : svcFor(row),
      target: row.audience,
      region: row.locality,
      cost: row.payer,
      specialty: row.conditions && !/^לא צוין(?:\s|$)/.test(row.conditions) ? row.conditions : '',
      web: row.web,
      phones: row.phones,
      address: row.address,
      ownership: row.ownership,
      ownershipRaw: row.ownershipRaw,
      kind: row.kind,
      category: row.checked ? 'mh_clinics' : 'mh_public',
      checked: Boolean(row.checked),
      methods: row.methods,
      operator: row.operator,
      staff: row.staff,
    };
    if (!card.org) card.org = row.name;
    if (!card.svc) card.svc = svcFor(row);
    card.entryId = `${slugify(card.org) || 'center'}_${card.row}`;
    next += 1;
    return card;
  });

  // One ownership per existing row. A later sheet row must not overwrite a vetted match.
  const byExisting = new Map();
  for (const item of linked) byExisting.set(item.row, item);
  for (const item of folded) if (!byExisting.has(item.row)) byExisting.set(item.row, item);

  fs.mkdirSync(WORK, { recursive: true });
  const draft = {
    maxRow,
    droppedDays,
    droppedDupes,
    unmatchedVetted,
    linked: [...byExisting.values()],
    cards,
  };
  fs.writeFileSync(DRAFT, JSON.stringify(draft));
  const queries = cards
    .filter((c) => c.address)
    .map((c) => ({ row: c.row, org: c.org, label: c.locality || c.org, address: c.address, query: `${c.address}, ישראל` }));
  fs.writeFileSync(QUERIES, JSON.stringify(queries, null, 2));

  const own = {};
  for (const c of cards) own[c.ownership] = (own[c.ownership] || 0) + 1;
  console.log(JSON.stringify({
    sheet: sheet.length,
    maxRow,
    newCards: cards.length,
    mhClinics: cards.filter((c) => c.category === 'mh_clinics').map((c) => ({ row: c.row, org: c.org, svc: c.svc })),
    linked: draft.linked,
    unmatchedVetted,
    droppedDays,
    droppedDupes,
    ownership: own,
    queries: queries.length,
    work: WORK,
  }, null, 2));
}

function findObjectEnd(html, open) {
  let depth = 0;
  let inString = false;
  let escapeNext = false;
  for (let i = open; i < html.length; i++) {
    const ch = html[i];
    if (escapeNext) {
      escapeNext = false;
      continue;
    }
    if (inString) {
      if (ch === '\\') escapeNext = true;
      else if (ch === '"') inString = false;
      continue;
    }
    if (ch === '"') {
      inString = true;
      continue;
    }
    if (ch === '{') depth += 1;
    else if (ch === '}') {
      depth -= 1;
      if (depth === 0) return i + 1;
    }
  }
  throw new Error('object end not found');
}

function stampOwnership(html, row, ownership) {
  const tokens = [`"row": ${row},`, `"row":${row},`];
  let from = 0;
  while (from < html.length) {
    let at = -1;
    for (const token of tokens) {
      const found = html.indexOf(token, from);
      if (found >= 0 && (at < 0 || found < at)) at = found;
    }
    if (at < 0) break;
    const open = html.lastIndexOf('{', at);
    const end = findObjectEnd(html, open);
    const obj = html.slice(open, end);
    if (!obj.includes('"ownership"')) {
      const insertion = `,"ownership":${JSON.stringify(ownership)}`;
      html = `${html.slice(0, end - 1)}${insertion}${html.slice(end - 1)}`;
      from = end + insertion.length;
    } else {
      from = end;
    }
  }
  return html;
}

function dollar(value) {
  const text = typeof value === 'string' ? value : JSON.stringify(value);
  return `'${text.replace(/'/g, "''")}'`;
}

function emit(geocodedPath) {
  const draft = JSON.parse(fs.readFileSync(DRAFT, 'utf8'));
  const hits = geocodedPath && fs.existsSync(geocodedPath) ? JSON.parse(fs.readFileSync(geocodedPath, 'utf8')) : [];
  const byRow = new Map();
  for (const hit of hits) {
    if (hit && hit.lat != null && hit.lng != null && hit.row != null) byRow.set(Number(hit.row), hit);
  }

  const cards = draft.cards.map((card) => {
    const hit = byRow.get(card.row);
    const geocoded = Boolean(hit);
    const notes = buildNotes(card, geocoded);
    const site = geocoded
      ? {
          label: clip(card.locality || card.org, 120),
          address: clip(card.address, 300),
          lat: Number(hit.lat),
          lng: Number(hit.lng),
          phone: card.phones[0] || '',
          email: '',
          note: '',
          sort_order: 0,
        }
      : null;
    return { ...card, notes, site };
  });

  const lines = [];
  lines.push('-- Migration 102 (19 Oct 2026)');
  lines.push('-- Public multidisciplinary settings from the Ministry of Health lists in the');
  lines.push('-- multidisciplinary-centers spreadsheet. New cards are not in the clinics browse');
  lines.push('-- list. Existing checked centers only gain an ownership mark and a glossary link.');
  lines.push('-- Register as [ ] in database_updates_master.sql; do not mark [x].');
  lines.push('');
  lines.push('BEGIN;');
  lines.push('');

  if (cards.length) {
    lines.push('INSERT INTO directory_entries (');
    lines.push('  entry_id, display_name, description, primary_category, category_keys, referral_codes');
    lines.push(') VALUES');
    lines.push(
      cards
        .map((c) => {
          const cats = c.category === 'mh_clinics' ? `ARRAY['mh_clinics']::text[]` : `ARRAY['mh_public']::text[]`;
          return `(${dollar(c.entryId)}, ${dollar(c.org)}, ${dollar(c.svc)}, ${dollar(c.category)}, ${cats}, ARRAY[]::text[])`;
        })
        .join(',\n')
    );
    lines.push('ON CONFLICT (entry_id) DO NOTHING;');
    lines.push('');
  }

  for (const c of cards) {
    const fields = publicFields(c);
    const eligibility = {
      age_min: null,
      age_max: null,
      sex: 'any',
      location_mode: c.site ? 'sites' : 'any',
      regions: [],
      diagnoses: [],
      presenting_problems: [],
      recognition: { btl: 'any', moh: 'any', mod: 'any', rehab_basket: 'any' },
      internal_notes: c.checked
        ? '19.10.2026: ת.ל.מ. נוסף מהשורות שנבדקו בגיליון המרכזים הרב-צוותיים. לא היה כרטיס קודם.'
        : '19.10.2026: שורה מגיליון המרכזים הרב-צוותיים. המסגרות הציבוריות לא נבדקו אחת-אחת.',
    };
    const sites = c.site ? [c.site] : [];
    const indicators = { ownership: c.ownership };
    const cardKey = `${c.row}|||${c.svc}`;
    lines.push('INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites, indicators)');
    lines.push('VALUES (');
    lines.push(`  ${dollar(cardKey)},`);
    lines.push(`  ${c.row},`);
    lines.push(`  ${dollar(c.entryId)},`);
    lines.push(`  ${dollar(fields)}::jsonb,`);
    lines.push(`  ${dollar(eligibility)}::jsonb,`);
    lines.push(`  ${dollar(sites)}::jsonb,`);
    lines.push(`  ${dollar(indicators)}::jsonb`);
    lines.push(')');
    lines.push('ON CONFLICT (card_key) DO NOTHING;');
    if (c.site) {
      lines.push('INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)');
      lines.push('VALUES (');
      lines.push(
        `  ${c.row}, ${dollar(c.entryId)}, ${dollar(c.site.label)}, ${dollar(c.site.address)}, ${c.site.lat}, ${c.site.lng}, 0`
      );
      lines.push(')');
      lines.push('ON CONFLICT (row_id, label) DO NOTHING;');
    }
    lines.push('');
  }

  const linkRows = [
    ...cards.map((c) => ({ key: `${c.row}|||${c.svc}`, text: c.org, literal: true })),
    ...draft.linked.map((l) => ({ row: l.row, text: l.name, literal: false })),
  ];
  if (linkRows.length) {
    lines.push('INSERT INTO glossary_card_links (term_key, card_key, status, matched_text)');
    lines.push('VALUES');
    const values = [];
    for (const link of linkRows) {
      if (link.literal) values.push(`('multidisciplinary_center', ${dollar(link.key)}, 'approved', ${dollar(link.text)})`);
    }
    if (values.length) {
      lines.push(values.join(',\n'));
      lines.push('ON CONFLICT (term_key, card_key) DO UPDATE SET');
      lines.push("  status = 'approved',");
      lines.push('  reviewed_at = now()');
      lines.push("WHERE glossary_card_links.status IS DISTINCT FROM 'rejected';");
      lines.push('');
    }
  }

  const existingIds = [...new Set(draft.linked.map((l) => l.row))];
  if (existingIds.length) {
    lines.push('INSERT INTO glossary_card_links (term_key, card_key, status, matched_text)');
    lines.push('SELECT \'multidisciplinary_center\', c.card_key, \'approved\', v.matched_text');
    lines.push('FROM directory_card_edits c');
    lines.push('JOIN (VALUES');
    lines.push(draft.linked.map((l) => `  (${l.row}, ${dollar(l.name)})`).join(',\n'));
    lines.push(') AS v(row_id, matched_text) ON v.row_id = c.row_id');
    lines.push('ON CONFLICT (term_key, card_key) DO UPDATE SET');
    lines.push("  status = 'approved',");
    lines.push('  reviewed_at = now()');
    lines.push("WHERE glossary_card_links.status IS DISTINCT FROM 'rejected';");
    lines.push('');

    for (const l of draft.linked) {
      lines.push('UPDATE directory_card_edits');
      lines.push(`SET indicators = COALESCE(indicators, '{}'::jsonb) || ${dollar({ ownership: l.ownership })}::jsonb,`);
      lines.push('    updated_at = now()');
      lines.push(`WHERE row_id = ${l.row}`);
      lines.push("  AND COALESCE(indicators->>'ownership', '') = '';");
      lines.push('');
    }
  }

  const allRows = [...cards.map((c) => c.row), ...existingIds];
  lines.push('INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, term_keys, card_keys, migration)');
  lines.push('SELECT');
  lines.push("  '2026-10-19-multidisciplinary-public-centers',");
  lines.push("  DATE '2026-10-19',");
  lines.push("  'מרפאות ציבוריות במרכז הרב-צוותי',");
  lines.push(`  ${dollar('במונח «מרכז רב-צוותי לבריאות הנפש» נוספו מרפאות הקהילה, יחידות טיפול היום ובתי החולים מרשימות משרד הבריאות. אפשר לסנן לפי סוג: פרטי, עמותה, קופת חולים, ממשלתי, בית חולים, או לא צוין. הן לא נוספו לרשימת «מרפאות בריאות הנפש», כדי לא להציף אותה. מחפשים אותן מהמונח או בחיפוש. במרפאות הציבוריות הרכב הצוות הוא לפי הגדרת המשרד, ולא נבדק מרפאה-מרפאה.')},`);
  lines.push("  'glossary',");
  lines.push("  ARRAY['multidisciplinary_center'],");
  lines.push('  ARRAY(');
  lines.push('    SELECT c.card_key FROM directory_card_edits c');
  lines.push(`    WHERE c.row_id = ANY(ARRAY[${allRows.join(',')}]::int[])`);
  lines.push('    ORDER BY c.row_id');
  lines.push('  ),');
  lines.push("  '102_multidisciplinary_public_centers.sql'");
  lines.push('WHERE NOT EXISTS (');
  lines.push("  SELECT 1 FROM site_audit_entries WHERE entry_key = '2026-10-19-multidisciplinary-public-centers'");
  lines.push(');');
  lines.push('');
  lines.push('COMMIT;');
  lines.push('');

  const sqlPath = path.join(__dirname, '102_multidisciplinary_public_centers.sql');
  fs.writeFileSync(sqlPath, lines.join('\n'), 'utf8');

  const indexPath = path.join(__dirname, '..', 'index.html');
  let html = fs.readFileSync(indexPath, 'utf8');
  if (html.includes('"mh_public"')) throw new Error('mh_public is already in index.html; refusing to insert it again');
  const nl = html.includes('\r\n') ? '\r\n' : '\n';

  const clinics = cards.filter((c) => c.category === 'mh_clinics');
  if (clinics.length) {
    const block = clinics.map((c) => `         ${JSON.stringify(dataObject(c))}`).join(`,${nl}`);
    const anchor = '         {"row": 355, "org": "מעייני הישועה — מרפאה לדוברי אנגלית"';
    const at = html.indexOf(anchor);
    if (at < 0) throw new Error('mh_clinics anchor missing');
    const end = html.indexOf(`${nl}        ]},`, at);
    if (end < 0) throw new Error('mh_clinics close missing');
    html = `${html.slice(0, end)},${nl}${block}${html.slice(end)}`;
  }

  const hidden = cards.filter((c) => c.category === 'mh_public');
  if (hidden.length) {
    const services = hidden.map((c) => `         ${JSON.stringify(dataObject(c))}`).join(`,${nl}`);
    const category = [
      '',
      '       "mh_public": {"icon": "🏥", "title": "מסגרות ציבוריות רב-צוותיות", "titleEn": "Public multidisciplinary settings", "desc": "מרפאות, טיפול יום ובתי חולים מרשימות משרד הבריאות. נפתחות מהמונח מרכז רב-צוותי ומחיפוש.", "unlisted": true, "services": [',
      services,
      '       ]}',
    ].join(nl);
    const close = `${nl}       ]}};${nl}         ${nl}${nl}        const MH_RESOURCE_PAGES`;
    if (!html.includes(close)) throw new Error('DATA close missing');
    html = html.replace(
      close,
      `${nl}       ]},${category}${nl}       };${nl}         ${nl}${nl}        const MH_RESOURCE_PAGES`
    );
  }

  const located = cards.filter((c) => c.site);
  if (located.length) {
    const locs = located
      .map((c) => {
        const site = {
          label: c.site.label,
          address: c.site.address,
          lat: c.site.lat,
          lng: c.site.lng,
        };
        if (c.site.phone) site.phone = c.site.phone;
        return `            ${c.row}: [${JSON.stringify(site)}]`;
      })
      .join(`,${nl}`);
    const locAnchor = `        };${nl}        const mhGetLocationsForRow`;
    if (!html.includes(locAnchor)) throw new Error('ENTRY_LOCATIONS close missing');
    html = html.replace(locAnchor, `,${nl}${locs}${nl}        };${nl}        const mhGetLocationsForRow`);
  }

  for (const link of draft.linked) html = stampOwnership(html, link.row, link.ownership);

  fs.writeFileSync(indexPath, html, 'utf8');
  const pinned = cards.filter((c) => c.site).length;
  console.log(`sql ${sqlPath}`);
  console.log(`cards ${cards.length}, pinned ${pinned}, unpinned ${cards.length - pinned}`);
}

const cmd = process.argv[2];
if (cmd === 'prepare') prepare();
else if (cmd === 'emit') emit(process.argv[3]);
else {
  console.error('Usage: node scripts/generate_mh_public_centers.js prepare|emit [geocoded.json]');
  process.exit(1);
}
