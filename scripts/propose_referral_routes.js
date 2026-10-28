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

const TREAT = new Set(['therapists', 'treatments', 'hmo', 'mh_clinics', 'hospitalization', 'day_care', 'alternatives', 'addictions', 'trauma', 'nutrition']);
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
  1: { codes: ['self_referral'], source: '' },
  2: { codes: ['self_referral'], source: '' },
  3: { codes: ['self_referral'], source: '' },
  4: { codes: ['self_referral'], source: 'ייעוץ והכנה בחינם לוועדה הרפואית' },
  5: { codes: ['rehab_basket_committee'], source: 'חוק שיקום מתמודדי נפש בקהילה (התש"ס, 2000)' },
  6: { codes: ['rehab_basket_committee'], source: 'target: זכאי סל שיקום' },
  7: { codes: ['rehab_basket_committee'], source: 'target: זכאי סל שיקום' },
  8: { codes: ['rehab_basket_committee'], source: 'target: זכאי סל שיקום' },
  9: { codes: ['rehab_basket_committee'], source: 'target: זכאי סל שיקום' },
  10: { codes: ['self_referral'], source: 'זמין 24/7 לחיילים, מילואים וכוחות הביטחון' },
  11: { codes: ['self_referral'], source: 'ניתן לפנות באופן אנונימי' },
  14: { codes: ['self_referral'], source: 'cost: חינם' },
  18: { codes: ['self_referral'], source: 'cost: האתר חינם' },
  20: { codes: ['self_referral'], source: '1201 — קו כללי, 24/7.' },
  22: { codes: ['self_referral'], source: 'צ׳אט אנונימי באתר או בוואטסאפ, 24/7, עם מתנדבים שמלווים על ידי אנשי מקצוע בבריאות הנפש.' },
  24: { codes: ['self_referral'], source: '' },
  25: { codes: ['self_referral'], source: '' },
  26: { codes: ['self_referral'], source: 'אפשר לפנות באופן אנונימי.' },
  28: { codes: ['gp_referral'], source: 'מסובסד עם המלצה מרופא משפחה' },
  29: { codes: ['self_referral'], source: 'אין צורך בהפניית רופא: פונים למרפאה בטופס מקוון, והצוות חוזר תוך 5 ימי עבודה.' },
  31: { codes: ['self_referral'], source: '' },
  32: { codes: ['self_referral'], source: '' },
  33: { codes: ['self_referral'], source: '' },
  34: { codes: ['self_referral'], source: '' },
  37: { codes: ['self_referral'], source: '' },
  38: { codes: ['self_referral', 'gp_referral', 'psychiatrist_referral'], source: '' },
  39: { codes: ['self_referral', 'mod_rehab_worker'], source: 'הבתים נמצאים בתוך בתי חולים, פעילים 24/7, ואפשר לשהות בהם עד 10 ימים, ללא עלות.' },
  40: { codes: ['hmo_form17'], source: 'cost: לאומית ומאוחדת' },
  41: { codes: ['self_referral'], source: 'שירות פרטי. פגישה עם פסיכיאטר ב-Zoom תוך 48 שעות ממועד הפנייה.' },
  42: { codes: ['mod_rehab_worker'], source: 'ייעוץ וטיפולי מעקב בוידאו לחיילים משוחררים באישור אגף השיקום.' },
  43: { codes: ['gp_referral', 'psychiatrist_referral', 'hmo_form17'], source: 'cost: ללא תשלום בהפניה של קופת החולים (כללית, מאוחדת ולאומית).' },
  45: { codes: ['self_referral'], source: 'שירות פרטי' },
  46: { codes: ['gp_referral', 'psychiatrist_referral', 'hmo_form17', 'self_referral'], source: 'ההפניה מרופא משפחה או מפסיכיאטר מטפל.' },
  47: { codes: ['mod_rehab_worker'], source: 'cost: זכאי משרד הבטחון' },
  48: { codes: ['psychiatrist_referral', 'hmo_form17'], source: 'cost: ממונן ע"י הקופות: מכבי, מאוחדת ולאומית' },
  50: { codes: ['self_referral'], source: '' },
  52: { codes: ['self_referral'], source: 'cost: חינם' },
  53: { codes: ['gp_referral', 'psychiatrist_referral', 'hmo_form17'], source: 'cost: במימון קופת החולים (טופס 17), עם השתתפות עצמית של כמה עשרות שקלים' },
  61: { codes: ['self_referral'], source: '' },
  62: { codes: ['unknown'], source: '' },
  63: { codes: ['self_referral', 'hmo_form17'], source: 'נוער וצעירים בגילאי 10-25, הצוות המקצועי שלנו ישמח לעזור לכם להתמודד עם תקופות מאתגרות בחיים בהתערבות רגשית ממוקדת וללא עלות.' },
  70: { codes: ['self_referral'], source: '' },
  73: { codes: ['self_referral'], source: '' },
  74: { codes: ['rehab_basket_committee', 'mod_rehab_worker', 'self_referral'], source: 'cost: במסגרת סל שיקום, אגף השיקום במשרד הביטחון, או באופן פרטי' },
  76: { codes: ['self_referral'], source: '' },
  78: { codes: ['unknown'], source: '' },
  80: { codes: ['gp_referral'], source: 'מסובסד עם המלצה מרופא משפחה' },
  81: { codes: ['gp_referral'], source: 'מסובסד עם המלצה מרופא משפחה' },
  87: { codes: ['self_referral'], source: '' },
  88: { codes: ['self_referral'], source: '' },
  90: { codes: ['self_referral'], source: '' },
  91: { codes: ['self_referral'], source: '' },
  93: { codes: ['self_referral'], source: '' },
  103: { codes: ['self_referral'], source: '' },
  104: { codes: ['self_referral'], source: '' },
  108: { codes: ['self_referral'], source: '' },
  109: { codes: ['psychiatrist_referral'], source: 'הפניה פסיכיאטרית; מימון דרך הקופה והמרכז המטפל.' },
  200: { codes: ['self_referral'], source: '' },
  201: { codes: ['self_referral'], source: 'קווי המענה הארציים 1202/1203' },
  204: { codes: ['self_referral'], source: '' },
  205: { codes: ['self_referral'], source: '' },
  210: { codes: ['self_referral'], source: 'cost: חינם' },
  211: { codes: ['self_referral', 'mod_rehab_worker'], source: 'cost: במימון מלא של אגף השיקום, משרד הביטחון (למתאימים)' },
  212: { codes: ['self_referral'], source: 'cost: חינם' },
  214: { codes: ['self_referral'], source: 'cost: חינם' },
  215: { codes: ['self_referral'], source: 'cost: חינם' },
  217: { codes: ['self_referral'], source: '' },
  218: { codes: ['mod_rehab_worker'], source: 'במימון משרד הביטחון' },
  220: { codes: ['self_referral'], source: 'cost: חינם' },
  221: { codes: ['gp_referral', 'hmo_form17'], source: 'cost: ללא עלות, בהפניה מרופא משפחה וטופס 17 (כל הקופות)' },
  222: { codes: ['self_referral'], source: 'cost: חינם' },
  223: { codes: ['self_referral'], source: 'cost: חינם' },
  224: { codes: ['self_referral'], source: '' },
  225: { codes: ['self_referral'], source: 'cost: חינם' },
  226: { codes: ['self_referral'], source: 'cost: חינם' },
  227: { codes: ['court_or_welfare'], source: '' },
  229: { codes: ['self_referral'], source: 'cost: חינם' },
  230: { codes: ['self_referral'], source: 'cost: חינם' },
  234: { codes: ['self_referral'], source: 'cost: חינם' },
  236: { codes: ['self_referral'], source: 'פועל 24/7 כל השנה, חוץ מיום כיפור.' },
  237: { codes: ['self_referral'], source: 'cost: חינם' },
  239: { codes: ['self_referral'], source: '' },
  241: { codes: ['self_referral', 'gp_referral', 'psychiatrist_referral', 'hmo_form17'], source: 'פנייה בדרך כלל דרך חדר מיון, וגם דרך רופא/ת משפחה, פסיכיאטר/ית, יועץ/ת חינוכי/ת או ישירות.' },
  242: { codes: ['self_referral'], source: 'cost: חינם' },
  243: { codes: ['self_referral'], source: 'מאוחדת *3833 · לאומית *507 (קו כוננים 24/7).' },
  244: { codes: ['self_referral'], source: 'אתר עם שאלון התאמה לספקי שירות' },
  245: { codes: ['self_referral'], source: 'cost: ללא עלות' },
  246: { codes: ['self_referral'], source: 'cost: ללא עלות' },
  247: { codes: ['self_referral'], source: 'הכוונה ראשונית ללא עלות וללא התחייבות' },
  251: { codes: ['self_referral'], source: 'cost: חינם' },
  252: { codes: ['self_referral'], source: 'cost: חינם' },
  253: { codes: ['self_referral'], source: 'cost: חינם' },
  254: { codes: ['self_referral'], source: 'קו חם מאויש 24/7 כולל סופי שבוע' },
  257: { codes: ['self_referral'], source: '' },
  258: { codes: ['self_referral'], source: '' },
  259: { codes: ['self_referral'], source: 'cost: חינם' },
  261: { codes: ['self_referral'], source: '' },
  265: { codes: ['self_referral'], source: '' },
  267: { codes: ['self_referral'], source: 'אפשר לפנות 24/7 גם בוואטסאפ 052-1210105 ובטופס מקוון.' },
  268: { codes: ['psychiatrist_referral'], source: 'נדרשת אבחנה של פסיכיאטר.' },
  269: { codes: ['self_referral'], source: '' },
  270: { codes: ['psychiatrist_referral', 'hmo_form17'], source: 'נדרש מרשם פסיכיאטר ואישור הקופה.' },
  271: { codes: ['psychiatrist_referral'], source: 'נדרשת הערכה פסיכיאטרית.' },
  273: { codes: ['psychiatrist_referral', 'hmo_form17'], source: 'הפניה מפסיכיאטר או נוירולוג.' },
  274: { codes: ['psychiatrist_referral', 'hmo_form17'], source: 'לכל פנייה יש לצרף מכתב הפניה מפסיכיאטר מטפל וטופס 17 מהקופה.' },
  275: { codes: ['psychiatrist_referral'], source: 'ההפניה להערכה ברמב״ם מהפסיכיאטר המטפל.' },
  276: { codes: ['self_referral'], source: '' },
  278: { codes: ['rehab_basket_committee'], source: 'target: זכאי סל שיקום' },
  279: { codes: ['hmo_form17', 'psychiatrist_referral', 'mod_rehab_worker'], source: 'חינם דרך קופות החולים (טופס 17) או משרד הביטחון; הפניה מפסיכיאטר.' },
  280: { codes: ['gp_referral'], source: 'הפנייה מרופא משפחה דרך קופת החולים.' },
  281: { codes: ['mod_rehab_worker', 'nii_referral'], source: 'הפניה דרך עובדות השיקום של משרד הביטחון או ביטוח לאומי (פעולות איבה).' },
  283: { codes: ['rehab_basket_committee', 'mod_rehab_worker'], source: 'זכאי סל שיקום; נכי צה"ל (באישור עובד השיקום)' },
  286: { codes: ['self_referral'], source: 'פתוח 24/7, 365 ימים.' },
  288: { codes: ['court_or_welfare'], source: '' },
  291: { codes: ['self_referral'], source: 'פרטי כל מרפאה באתר' },
  293: { codes: ['hmo_form17'], source: 'טופס 17 — כללית ומאוחדת' },
  296: { codes: ['self_referral', 'rehab_basket_committee'], source: 'מוקד *9913. מכינת הד: גילאי 18–28, זכאי סל שיקום' },
  297: { codes: ['psychiatrist_referral', 'hmo_form17'], source: 'הפניה מפסיכיאטר. טופס 17, קוד L0771.' },
  298: { codes: ['gp_referral'], source: 'אשפוז יום ניתן רק לאחר הפניית רופא.' },
  299: { codes: ['gp_referral', 'psychiatrist_referral', 'hmo_form17'], source: 'טופס 17, קוד L0822. הפניה מגורם בבריאות הנפש, מנוירולוג או מרופא משפחה; אם יש פסיכיאטר מטפל — לצרף מכתב.' },
  300: { codes: ['gp_referral', 'hmo_form17'], source: 'כללית ומכבי: הפניה מרופא מטפל. מאוחדת ולאומית: טופס 17.' },
  302: { codes: ['psychiatrist_referral', 'hmo_form17'], source: 'נדרשת הפניה מהפסיכיאטר המטפל או גורם מוסמך אחר בבריאות הנפש, וטופס התחייבות.' },
  303: { codes: ['gp_referral'], source: 'בהפניית רופא.' },
  306: { codes: ['self_referral', 'rehab_basket_committee'], source: 'סל שיקום, דיור, תעסוקה וסיוע להורים מתמודדים. מוקד 1599-504949.' },
  307: { codes: ['rehab_basket_committee'], source: 'ניתן אל מול אישור ועדת סל שיקום לדיור מוגן.' },
  771: { codes: ['self_referral'], source: '' },
  772: { codes: ['self_referral'], source: 'פנייה באימייל; הקבוצות לפי יחידה' },
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
