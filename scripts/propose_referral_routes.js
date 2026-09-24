#!/usr/bin/env node
/**
 * Propose referral_route codes from source wording, then write the curated overlay.
 *
 *   node scripts/propose_referral_routes.js           print a review table
 *   node scripts/propose_referral_routes.js --write   write scripts/referral_codes.json
 *
 * Keyword proposals are a starting point. Curated overrides (CURATED below) win, because
 * a wrong "must have a GP referral" badge on a walk-in crisis line is a real harm.
 * Undeterminable values get `unknown`, never silent emptiness.
 */
const fs = require('fs');
const path = require('path');
const { load } = require('./lib/extract_data');

const VOCAB = JSON.parse(fs.readFileSync(path.join(__dirname, 'vocabularies.json'), 'utf8'));
const VALID = new Set(VOCAB.referral_route.terms.map((t) => t.code));

const TREAT = new Set(['therapists', 'treatments', 'hmo', 'mh_clinics', 'hospitalization', 'alternatives', 'addictions', 'trauma', 'nutrition']);
const RIGHTS = new Set(['rights', 'moh', 'mod', 'rehabilitation']);
const SCOPE = new Set([...TREAT, ...RIGHTS]);

const RULES = [
  { re: /טופס\s*17|form\s*17/i, code: 'hmo_form17' },
  { re: /הפניה מרופא משפחה|הפנייה מרופא משפחה|המלצה מרופא משפחה|רפורמת בריאות הנפש/i, code: 'gp_referral' },
  { re: /הפניה מפסיכיאטר|הפנייה מפסיכיאטר|הפניה פסיכיאטרית|נדרשת אבחנה של פסיכיאטר|נדרש מרשם פסיכיאטר|הפניה מפסיכיאטר או נוירולוג/i, code: 'psychiatrist_referral' },
  { re: /עובד(?:ות)? השיקום|עובד השיקום|באישור אגף השיקום|באישור עובד השיקום|הפניה דרך עובדות השיקום/i, code: 'mod_rehab_worker' },
  { re: /ועדת סל שיקום|ועדות סל שיקום|זכאי סל שיקום/i, code: 'rehab_basket_committee' },
  { re: /ביטוח לאומי \(פעולות איבה\)|הפניה מביטוח לאומי/i, code: 'nii_referral' },
];

/**
 * Hand-reviewed overlay for the treatment and rights groups. Source sentences are copied
 * from the published fields, never paraphrased — the badge UI shows this text on expand.
 * Only rows whose wording actually supports a code are listed; everything else stays unknown.
 */
const CURATED = {
  4: { codes: ['self_referral'], source: 'ייעוץ והכנה בחינם לוועדה הרפואית' },
  5: { codes: ['rehab_basket_committee'], source: 'חוק שיקום מתמודדי נפש בקהילה (התש"ס, 2000)' },
  6: { codes: ['rehab_basket_committee'], source: 'target: זכאי סל שיקום' },
  7: { codes: ['rehab_basket_committee'], source: 'target: זכאי סל שיקום' },
  8: { codes: ['rehab_basket_committee'], source: 'target: זכאי סל שיקום' },
  9: { codes: ['rehab_basket_committee'], source: 'target: זכאי סל שיקום' },
  10: { codes: ['self_referral'], source: 'זמין 24/7 לחיילים, מילואים וכוחות הביטחון' },
  11: { codes: ['self_referral'], source: 'ניתן לפנות באופן אנונימי' },
  28: { codes: ['gp_referral'], source: 'מסובסד עם המלצה מרופא משפחה' },
  29: { codes: ['gp_referral'], source: 'מסובסד עם המלצה מרופא משפחה' },
  38: { codes: ['unknown'], source: '' },
  39: { codes: ['self_referral'], source: 'בית בטוח לטיפול מיידי — חלופת אשפוז' },
  40: { codes: ['hmo_form17'], source: 'cost: לאומית ומאוחדת' },
  41: { codes: ['self_referral'], source: 'שירות פרטי. פגישה עם פסיכיאטר ב-Zoom תוך 48 שעות ממועד הפנייה.' },
  42: { codes: ['mod_rehab_worker'], source: 'ייעוץ וטיפולי מעקב בוידאו לחיילים משוחררים באישור אגף השיקום.' },
  43: { codes: ['hmo_form17'], source: 'ממומן ע"י הקופות: כללית, מאוחדת ולאומית' },
  44: { codes: ['mod_rehab_worker'], source: 'cost: זכאי משרד הבטחון' },
  45: { codes: ['self_referral'], source: 'שירות פרטי' },
  46: { codes: ['hmo_form17'], source: 'ממומן ע"י הקופות: כללית, מאוחדת (בירושלים)' },
  47: { codes: ['mod_rehab_worker'], source: 'cost: זכאי משרד הבטחון' },
  48: { codes: ['hmo_form17'], source: 'ממומן ע"י הקופות: מכבי, מאוחדת ולאומית' },
  53: { codes: ['unknown'], source: '' },
  62: { codes: ['unknown'], source: '' },
  63: { codes: ['self_referral'], source: 'התערבות רגשית ממוקדת וללא עלות' },
  78: { codes: ['unknown'], source: '' },
  80: { codes: ['gp_referral'], source: 'מסובסד עם המלצה מרופא משפחה' },
  81: { codes: ['gp_referral'], source: 'מסובסד עם המלצה מרופא משפחה' },
  109: { codes: ['psychiatrist_referral'], source: 'הפניה פסיכיאטרית; מימון דרך הקופה והמרכז המטפל.' },
  201: { codes: ['self_referral'], source: 'קווי המענה הארציים 1202/1203' },
  210: { codes: ['self_referral'], source: 'cost: חינם' },
  211: { codes: ['unknown'], source: 'להתקבל לתוכנית חייבת הכרה/אבחון טראומה.' },
  212: { codes: ['self_referral'], source: 'cost: חינם' },
  214: { codes: ['self_referral'], source: 'cost: חינם' },
  216: { codes: ['self_referral'], source: 'cost: חינם' },
  218: { codes: ['mod_rehab_worker'], source: 'במימון משרד הביטחון' },
  220: { codes: ['self_referral'], source: 'cost: חינם' },
  221: { codes: ['gp_referral'], source: 'מרפאת כללית' },
  224: { codes: ['mod_rehab_worker'], source: 'החזר משרד הביטחון עד תקרת 1500 ₪ למפגש.' },
  226: { codes: ['self_referral'], source: 'cost: חינם' },
  244: { codes: ['self_referral'], source: 'אתר עם שאלון התאמה לספקי שירות' },
  247: { codes: ['self_referral'], source: 'הכוונה ראשונית ללא עלות וללא התחייבות' },
  251: { codes: ['self_referral'], source: 'cost: חינם' },
  252: { codes: ['self_referral'], source: 'cost: חינם' },
  253: { codes: ['self_referral'], source: 'cost: חינם' },
  254: { codes: ['self_referral'], source: 'קו חם מאויש 24/7 כולל סופי שבוע' },
  268: { codes: ['psychiatrist_referral'], source: 'נדרשת אבחנה של פסיכיאטר.' },
  270: { codes: ['psychiatrist_referral', 'hmo_form17'], source: 'נדרש מרשם פסיכיאטר ואישור הקופה.' },
  271: { codes: ['psychiatrist_referral'], source: 'נדרשת הערכה פסיכיאטרית.' },
  273: { codes: ['psychiatrist_referral'], source: 'הפניה מפסיכיאטר או נוירולוג.' },
  278: { codes: ['rehab_basket_committee'], source: 'target: זכאי סל שיקום' },
  279: { codes: ['hmo_form17', 'psychiatrist_referral', 'mod_rehab_worker'], source: 'חינם דרך קופות החולים (טופס 17) או משרד הביטחון; הפניה מפסיכיאטר.' },
  280: { codes: ['gp_referral', 'rehab_basket_committee'], source: 'הפנייה מרופא משפחה דרך קופת החולים. כולל ועדות סל שיקום במרפאה.' },
  281: { codes: ['mod_rehab_worker', 'nii_referral'], source: 'הפניה דרך עובדות השיקום של משרד הביטחון או ביטוח לאומי (פעולות איבה).' },
  283: { codes: ['rehab_basket_committee', 'mod_rehab_worker'], source: 'זכאי סל שיקום; נכי צה"ל (באישור עובד השיקום)' },
  291: { codes: ['self_referral'], source: 'פרטי כל מרפאה באתר' },
};

function blob(entry) {
  const r = entry.raw;
  return [r.cost, r.target, r.notes, r.svc].filter(Boolean).join('\n');
}

function propose(entry) {
  const text = blob(entry);
  const codes = [];
  let source = '';
  for (const rule of RULES) {
    const m = text.match(rule.re);
    if (m && !codes.includes(rule.code)) {
      codes.push(rule.code);
      if (!source) source = m[0];
    }
  }
  return { codes: codes.length ? codes : ['unknown'], source, confidence: codes.length ? 'keyword' : 'none' };
}

function resolve(entry) {
  const curated = CURATED[entry.row];
  if (curated) {
    const codes = curated.codes.filter((c) => VALID.has(c));
    return { codes: codes.length ? codes : ['unknown'], source: curated.source || '', confidence: 'curated' };
  }
  return propose(entry);
}

function inScope(entry) {
  return entry.categories.some((c) => SCOPE.has(c));
}

function main() {
  const data = load();
  const write = process.argv.includes('--write');
  const out = {};
  const rows = data.entries.filter((e, i, a) => inScope(e) && a.findIndex((x) => x.row === e.row) === i);

  let curated = 0;
  let known = 0;
  for (const e of rows) {
    const r = resolve(e);
    for (const c of r.codes) {
      if (!VALID.has(c)) throw new Error(`Invalid code ${c} on row ${e.row}`);
    }
    out[String(e.row)] = { codes: r.codes, source: r.source, confidence: r.confidence };
    if (r.confidence === 'curated') curated++;
    if (!(r.codes.length === 1 && r.codes[0] === 'unknown')) known++;
  }

  if (write) {
    const payload = {
      vocab: 'referral_route',
      note: 'Codes sit alongside free-text notes/cost/target. Source wording is preserved in `source` and shown on the badge expand. Generated by propose_referral_routes.js --write.',
      rows: out,
    };
    const dest = path.join(__dirname, 'referral_codes.json');
    fs.writeFileSync(dest, JSON.stringify(payload, null, 2) + '\n', 'utf8');
    console.log(`Wrote ${dest}`);
    syncIndexHtml(payload.rows);
  }

  console.log(`in-scope unique rows: ${rows.length}`);
  console.log(`curated: ${curated}`);
  console.log(`known (not unknown): ${known} (${((known / rows.length) * 100).toFixed(1)}%)`);
  if (!write) {
    console.log('\nSample (first 15):');
    for (const e of rows.slice(0, 15)) {
      const r = out[String(e.row)];
      console.log(`  ${e.row} ${r.confidence.padEnd(8)} ${r.codes.join(',')}  ${e.org.replace(/\s+/g, ' ').slice(0, 40)}`);
    }
    console.log('\nRe-run with --write to save scripts/referral_codes.json');
  }
}

/**
 * Keep the live UI in step with the JSON file without a second hand-maintained copy.
 * The SPA reads #mh-referral-codes; the build reads scripts/referral_codes.json.
 */
function syncIndexHtml(rows) {
  const indexPath = path.join(__dirname, '..', 'index.html');
  const html = fs.readFileSync(indexPath, 'utf8');
  const start = '<!-- REFERRAL_CODES_START -->';
  const end = '<!-- REFERRAL_CODES_END -->';
  if (!html.includes(start) || !html.includes(end)) {
    console.warn('index.html is missing REFERRAL_CODES markers; UI will not see the overlay until they are added.');
    return;
  }
  const compact = JSON.stringify({ rows });
  const block = `${start}\n<script type="application/json" id="mh-referral-codes">${compact}</script>\n${end}`;
  const next = html.replace(new RegExp(`${start}[\\s\\S]*?${end}`), block);
  fs.writeFileSync(indexPath, next, 'utf8');
  console.log('Updated #mh-referral-codes in index.html');
}

if (require.main === module) main();

module.exports = { CURATED, propose, resolve, VALID };
