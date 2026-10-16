#!/usr/bin/env node
/**
 * Draft card indicators (migration 077) for every card, for the site owner to review.
 *
 *   node scripts/propose_card_indicators.js                 writes docs/card-indicators-2026-10.md
 *                                                           and scripts/card_indicators_proposal.json
 *   node scripts/propose_card_indicators.js --sql <batch> <migration-file-name>
 *                                                           writes an approved batch as a migration
 *
 * The draft is built from what is already on the card: its section, the domain of its link,
 * words in cost / notes / target / svc, and the row-keyed referral codes. Every proposed value
 * carries the evidence it came from and a confidence, so the owner can approve or correct it.
 *
 * Text comes from directory_card_edits when DATABASE_URL is set, otherwise from the live
 * /api/directory-cards (CARDS_URL overrides), otherwise from index.html (--offline forces this).
 *
 * The --sql migration only fills cards whose indicators are still empty, so an admin edit made
 * after the review is never overwritten. Approved corrections are made in the JSON file first.
 */

const fs = require('fs');
const path = require('path');
const { Client } = require('pg');
const { load } = require('./lib/extract_data');

const ROOT = path.join(__dirname, '..');
const DOC = path.join(ROOT, 'docs', 'card-indicators-2026-10.md');
const PROPOSAL = path.join(__dirname, 'card_indicators_proposal.json');
const BATCH_SIZE = 60;

const OFFER_HE = { info: 'מידע', navigate: 'הכוונה ואיתור', care: 'טיפול ותמיכה', claim: 'מימוש זכות', community: 'קהילה' };
const FUND_HE = {
  private: 'בתשלום', free: 'חינם', hmo: 'קופות חולים', moh: 'משרד הבריאות', mod: 'משרד הביטחון',
  welfare: 'רווחה', btl: 'ביטוח לאומי', supplementary: 'ביטוח משלים', edu: 'משרד החינוך',
};
const TERMS_HE = { full: 'מלא', partial: 'השתתפות עצמית', eligible: 'לזכאים' };
const FUND_ORDER = ['free', 'hmo', 'moh', 'mod', 'welfare', 'btl', 'edu', 'supplementary', 'private'];
const CONF_HE = { high: 'גבוהה', medium: 'בינונית', low: 'נמוכה' };

/** Sections whose cards are mental-health treatment that the קופות provide under the 2015 reform. */
const HMO_REFORM_SECTIONS = new Set(['hmo', 'mh_clinics', 'day_care', 'hospitalization', 'alternatives']);

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

async function databaseCards() {
  if (!process.env.DATABASE_URL) return null;
  const client = new Client({ connectionString: normalizePgSslMode(process.env.DATABASE_URL) });
  await client.connect();
  try {
    const { rows } = await client.query(`SELECT id, card_key, public_fields FROM directory_card_edits`);
    return { map: new Map(rows.map((r) => [String(r.card_key).replace(/\r/g, ''), r])), source: 'directory_card_edits' };
  } finally {
    await client.end().catch(() => {});
  }
}

async function liveCards() {
  const url = process.env.CARDS_URL || 'https://nefesh-il.org/api/directory-cards';
  try {
    const res = await fetch(url);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const { cards } = await res.json();
    if (!Array.isArray(cards) || !cards.length) throw new Error('no cards');
    return {
      map: new Map(cards.map((c) => [String(c.cardKey), { id: c.id, public_fields: c.publicFields }])),
      source: url,
    };
  } catch (err) {
    console.warn(`Could not load ${url}: ${err.message}`);
    return null;
  }
}

function hostOf(url) {
  try {
    return new URL(url).hostname.replace(/^www\./, '');
  } catch {
    return '';
  }
}

const text = (v) => String(v || '').replace(/\s+/g, ' ').trim();
const short = (v, n = 70) => {
  const s = text(v);
  return s.length > n ? `${s.slice(0, n - 1)}…` : s;
};

/** One proposal per card. Evidence strings are shown to the owner next to each value. */
function propose(entry, fields) {
  const cats = entry.categories;
  const svc = text(fields.svc);
  const svcRaw = String(fields.svc || '');
  const cost = text(fields.cost);
  const notes = text(fields.notes);
  const target = text(fields.target);
  const all = `${svc} ${cost} ${notes} ${target}`;
  const hosts = [fields.web, fields.web2, fields.add].map(hostOf).filter(Boolean);
  const host = hosts[0] || '';
  const hasPhone = ['', '2', '3', '4', '5', '6'].some((s) => text(fields[`phone${s}`])) || text(fields.whatsapp);

  const offers = new Map();
  const addOffer = (code, why) => {
    if (!offers.has(code)) offers.set(code, why);
  };
  let offerConf = 'medium';

  if (/facebook\.com\/groups/.test(String(fields.web || '')) || /קבוצה בפייסבוק|קבוצות? תמיכה|עמיתים|קהילה/.test(svc)) {
    addOffer('community', svc.includes('פייסבוק') || /facebook\.com\/groups/.test(String(fields.web || '')) ? 'קבוצה בפייסבוק' : 'בתיאור: קבוצה / עמיתים');
  }
  if (host === 'kolzchut.org.il') {
    addOffer('info', 'האתר: כל זכות');
    offerConf = 'high';
  }
  if (/practitioners\.health\.gov\.il/.test(hosts.join(' ')) || /אינדקס|מאגר|רשימת|מפה ומאגר|איתור/.test(svc)) {
    addOffer('navigate', 'בתיאור: אינדקס / מאגר / רשימה');
  }
  if (/הכוונה|התאמת מטפל|ליווי למציאת/.test(svc) && !offers.has('navigate')) addOffer('navigate', 'בתיאור: הכוונה');
  if (/קצבת|קצבה|שירותים מיוחדים|שר"מ|קביעת נכות|הכרה|ועדת|ועדה/.test(svc) && !/ייעוץ והכנה/.test(svc)) {
    addOffer('claim', 'בתיאור: קצבה / ועדה / הכרה');
    if (!offers.has('info') && (cats.includes('rights') || /gov\.il|kolzchut/.test(host))) addOffer('info', 'דף מידע על הזכות');
  }
  if (svc === 'סל שיקום' || /^סל שיקום$/.test(svc)) addOffer('claim', 'סל שיקום: הגשת בקשה לוועדה');
  if (/זכויות|מדריך|מידע/.test(svc) && !hasPhone) addOffer('info', 'בתיאור: זכויות / מדריך / מידע, ואין טלפון');
  if (cats.includes('portals') && !offers.size) addOffer('info', 'מקטע: פורטלים ומידע');

  const careWords = /טיפול|תמיכה|קו |קווי|סיוע|ייעוץ|מרפאה|מרפאות|אשפוז|שיקום|ליווי|מרכז|חלופת|צוות|שיחות|מפגשים|מוקד|הדרכה/;
  const careSection = !cats.every((c) => c === 'portals' || c === 'rights');
  if ((careWords.test(svc) && (hasPhone || careSection)) || (careSection && !offers.size)) {
    addOffer('care', careWords.test(svc) ? 'בתיאור: טיפול / תמיכה / קו / מרפאה' : `מקטע: ${cats.join(', ')}`);
  }
  if (!offers.size) {
    addOffer(hasPhone ? 'care' : 'info', hasPhone ? 'יש טלפון לפנייה' : 'אין טלפון; כנראה דף לקריאה');
    offerConf = 'low';
  }

  const offerCodes = ['info', 'navigate', 'care', 'claim', 'community'].filter((c) => offers.has(c));
  const infoOnly = offerCodes.length === 1 && offerCodes[0] === 'info';

  // Whole organization: a list of services in svc, or "ועוד", or the general homepage.
  let wholeOrg = false;
  let wholeOrgWhy = '';
  const svcLines = svcRaw.split('\n').map((l) => l.trim()).filter(Boolean);
  if (svcLines.length >= 3 || /\nועוד|ועוד ועוד/.test(svcRaw)) {
    wholeOrg = true;
    wholeOrgWhy = 'התיאור הוא רשימת שירותים';
  }

  const funding = new Map();
  const fundWhy = [];
  let fundConf = 'medium';
  const addFund = (channel, terms, why) => {
    if (!funding.has(channel) || (terms && !funding.get(channel))) funding.set(channel, terms || '');
    if (why && !fundWhy.includes(why)) fundWhy.push(why);
  };
  const codes = (entry.raw.referralCodes || []).filter((c) => c && c !== 'unknown');

  if (!infoOnly) {
    if (/^(חינם|ללא עלות|ללא תשלום|בחינם)\.?$/.test(cost)) {
      addFund('free', '', `עלות: ${cost}`);
      fundConf = 'high';
    }
    // "נכות כללית" is a disability type, not the Clalit health fund.
    const costNotes = `${cost} ${notes}`.replace(/נכות כללית/g, '');
    if (/קופ(ת|ות) ה?חולים|טופס 17|כללית|מכבי|מאוחדת|לאומית|מסובסד|ממונן ע"י הקופות/.test(costNotes) || codes.includes('hmo_form17') || codes.includes('gp_referral') || cats.includes('hmo')) {
      const partial = /השתתפות עצמית|מסובסד/.test(costNotes);
      addFund('hmo', partial ? 'partial' : /ללא עלות|ללא תשלום|חינם/.test(cost) ? 'full' : '', 'קופות חולים / טופס 17 / הפניה מרופא משפחה');
      if (cats.some((c) => HMO_REFORM_SECTIONS.has(c))) addFund('moh', '', 'שירות בריאות נפש במימון משרד הבריאות דרך הקופות (רפורמה 2015)');
    }
    if (/סל שיקום/.test(all) || codes.includes('rehab_basket_committee')) addFund('moh', 'eligible', 'סל שיקום (משרד הבריאות)');
    if (/מימון משרד הבריאות|במימון ובפיקוח של משרד הבריאות|משרד הבריאות/.test(`${cost} ${notes}`) && !funding.has('moh')) {
      addFund('moh', '', 'בטקסט: מימון משרד הבריאות');
    }
    if (/משרד הביטחון|משרד הבטחון|אגף השיקום|נכי צה"ל|זכאי משרד/.test(all) || codes.includes('mod_rehab_worker') || cats.includes('mod')) {
      addFund('mod', /כלל המשרתים|לחיילים|אנונימי/.test(all) && !/מוכרים|הכרה|זכאי|נכי/.test(all) ? '' : 'eligible', 'משרד הביטחון / אגף השיקום');
    }
    if (/ביטוח לאומי|פעולות איבה|נפגעי טרור/.test(`${cost} ${notes}`) || codes.includes('nii_referral') || (host === 'btl.gov.il' && offers.has('care'))) {
      addFund('btl', /פעולות איבה|נפגעי טרור/.test(all) ? 'eligible' : '', 'ביטוח לאומי');
    }
    if (/משרד הרווחה|רווחה|שירותים חברתיים/.test(`${entry.org} ${all}`) || codes.includes('court_or_welfare')) addFund('welfare', '', 'רווחה');
    if (/משרד החינוך|שפ"ח/.test(`${entry.org} ${all}`)) addFund('edu', '', 'משרד החינוך');
    if (/שב"ן|ביטוח משלים|ביטוחים|ביטוח פרטי/.test(all)) addFund('supplementary', 'partial', 'ביטוח משלים / ביטוחים');
    if (/פרטי|בתשלום|₪|ש"ח|ש״ח/.test(cost) || /שירות פרטי|מרכז פרטי|בתשלום/.test(notes)) addFund('private', '', 'עלות / הערות: פרטי / בתשלום');
    if (!funding.size && /חינם|ללא עלות|ללא תשלום|בחינם/.test(all) && !/לזכאים|למוכרים|למתאימים/.test(all)) {
      addFund('free', '', 'בטקסט: חינם / ללא עלות');
      fundConf = 'low';
    }
    if (!funding.size) fundConf = 'none';
  }

  const fundingList = FUND_ORDER.filter((c) => funding.has(c)).map((c) => ({ channel: c, terms: funding.get(c) }));
  const referral = codes.slice();
  return {
    offers: offerCodes,
    offersWhy: offerCodes.map((c) => offers.get(c)),
    offerConf,
    wholeOrg,
    wholeOrgWhy,
    funding: fundingList,
    fundWhy,
    fundConf,
    referral,
    referralSource: String(entry.raw.referralSource || ''),
    referralConf: referral.length ? (entry.rowIsAmbiguous ? 'low' : 'high') : 'none',
  };
}

function fundingLabel(list) {
  return list.map((f) => (f.terms ? `${FUND_HE[f.channel]} (${TERMS_HE[f.terms]})` : FUND_HE[f.channel])).join(' · ');
}

function esc(s) {
  return String(s || '').replace(/\|/g, '\\|').replace(/\n/g, ' ');
}

async function writeDraft() {
  const data = load();
  let db = await databaseCards();
  if (!db && !process.argv.includes('--offline')) db = await liveCards();
  const source = db ? db.source : 'index.html (fallback)';

  const seen = new Set();
  const cards = [];
  for (const entry of data.entries) {
    if (seen.has(entry.key)) continue;
    seen.add(entry.key);
    const row = db ? db.map.get(entry.key) : null;
    const fields = row && row.public_fields ? row.public_fields : entry.raw;
    const p = propose(entry, fields);
    cards.push({
      cardKey: entry.key,
      cardEditId: row ? Number(row.id) : null,
      row: entry.row,
      org: text(fields.org || entry.org),
      svc: text(fields.svc || entry.svc),
      categories: entry.categories,
      rowShared: Boolean(entry.rowIsAmbiguous),
      ...p,
    });
  }

  // Website-checked corrections (scripts/card_indicators_corrections*.json) replace the rule-based draft.
  const corrections = new Map();
  for (const f of fs.readdirSync(__dirname).filter((n) => /^card_indicators_corrections.*\.json$/.test(n)).sort()) {
    for (const fix of JSON.parse(fs.readFileSync(path.join(__dirname, f), 'utf8'))) corrections.set(fix.cardKey, fix);
  }
  for (const card of cards) {
    const fix = corrections.get(card.cardKey);
    if (!fix) continue;
    const ind = fix.indicators || {};
    if (ind.offers) card.offers = ind.offers;
    if (ind.whole_org !== undefined) card.wholeOrg = Boolean(ind.whole_org);
    if (ind.funding) card.funding = ind.funding;
    if (ind.referral) card.referral = ind.referral;
    if (ind.referral_source !== undefined) card.referralSource = ind.referral_source;
    if (fix.members) {
      card.members = fix.members
        .map((key) => cards.find((c) => c.cardKey === key))
        .filter(Boolean)
        .map((c) => ({ cardKey: c.cardKey, row: c.row, svc: short(c.svc, 50) }));
    }
    card.checked = fix.note ? `נבדק: ${fix.note}${fix.url ? ` (${fix.url})` : ''}` : 'נבדק';
  }

  // Organization members: other cards whose organization name matches the general card's.
  const orgName = (s) => text(s).replace(/["״׳']/g, '').replace(/\(.*?\)/g, '').trim();
  for (const card of cards) {
    if (!card.wholeOrg) {
      card.members = [];
      continue;
    }
    if (card.members) continue;
    const name = orgName(card.org);
    card.members = cards
      .filter((c) => c !== card && name && orgName(c.org) === name)
      .map((c) => ({ cardKey: c.cardKey, row: c.row, svc: short(c.svc, 50) }));
  }

  cards.forEach((c, i) => {
    c.batch = Math.floor(i / BATCH_SIZE) + 1;
    c.code = `I${c.batch}-${String(i + 1).padStart(3, '0')}`;
  });

  fs.writeFileSync(
    PROPOSAL,
    JSON.stringify(
      {
        note: 'Draft card indicators from propose_card_indicators.js. Edit values here after review; --sql writes a batch.',
        source,
        cards: cards.map((c) => ({
          code: c.code,
          batch: c.batch,
          row: c.row,
          cardKey: c.cardKey,
          org: c.org,
          indicators: {
            offers: c.offers,
            whole_org: c.wholeOrg,
            funding: c.funding,
            referral: c.referral,
            referral_source: c.referralSource,
          },
          members: (c.members || []).map((m) => m.cardKey),
        })),
      },
      null,
      2
    ) + '\n'
  );

  const batches = [...new Set(cards.map((c) => c.batch))];
  const lines = [
    '# סימונים בכרטיסים — טיוטה לאישור (אוקטובר 2026)',
    '',
    'הצעה לסימונים בכל כרטיס: מה יש בכרטיס, האם זה הכרטיס הכללי של הארגון, מימון, ודרך ההפניה. שום דבר עוד לא מוצג באתר.',
    `הטקסט שממנו נבנתה ההצעה: ${source}.`,
    '',
    'איך לקרוא את הטבלה:',
    '- **מה יש:** מידע · הכוונה ואיתור · טיפול ותמיכה · מימוש זכות · קהילה. כרטיס שמסומן רק «מידע» יוצג כ«מידע בלבד» ובלי מימון.',
    '- **כללי:** ✓ כשהכרטיס הוא הכרטיס הכללי של הארגון. מתחת מופיעים הכרטיסים שיקושרו אליו.',
    '- **מימון:** בסוגריים תנאי המימון (מלא / השתתפות עצמית / לזכאים). כשמשרד הבריאות מממן דרך הקופות מסומנים שניהם.',
    '- **הפניה:** הקודים הקיימים. ודאות נמוכה כשמספר השורה משותף לשני כרטיסים, כי הקודים נשמרו לפי מספר שורה.',
    '- **ודאות:** מה יש / מימון / הפניה.',
    '',
    'לאישור: «קבוצה N מאושרת», או תיקון לפי קוד (למשל «I1-004: מימון רק חינם»).',
    '',
  ];
  for (const b of batches) {
    const inBatch = cards.filter((c) => c.batch === b);
    lines.push(`## קבוצה ${b} (${inBatch.length} כרטיסים)`, '');
    lines.push('| קוד | שורה | כרטיס | מה יש | כללי | מימון | הפניה | ודאות | על מה מבוסס |');
    lines.push('|---|---|---|---|---|---|---|---|---|');
    for (const c of inBatch) {
      const offers = c.offers.length === 1 && c.offers[0] === 'info' ? '**מידע בלבד**' : c.offers.map((o) => OFFER_HE[o]).join(' · ');
      const whole = c.wholeOrg ? `✓${c.members && c.members.length ? ` (${c.members.map((m) => m.row).join(', ')})` : ''}` : '';
      const conf = [c.offerConf, c.fundConf, c.referralConf].map((x) => CONF_HE[x] || '—').join(' / ');
      const why = c.checked || [...c.offersWhy, c.wholeOrgWhy, ...c.fundWhy].filter(Boolean).join('; ');
      lines.push(
        `| ${c.code} | ${c.row}${c.rowShared ? '*' : ''} | ${esc(c.org)} — ${esc(short(c.svc, 60))} | ${offers} | ${whole} | ${esc(fundingLabel(c.funding)) || '—'} | ${esc(c.referral.join(', ')) || '—'} | ${conf} | ${esc(why)} |`
      );
    }
    lines.push('');
  }
  lines.push('\\* מספר השורה משותף לכרטיס אחר.', '');
  fs.writeFileSync(DOC, lines.join('\n'));
  console.log(`${cards.length} cards in ${batches.length} batches → ${path.relative(ROOT, DOC)}, ${path.relative(ROOT, PROPOSAL)} (source: ${source})`);
}

const sqlText = (s) => `'${String(s).replace(/'/g, "''")}'`;

function writeSql(batch, fileName) {
  if (!batch || !fileName || !/^\d{3}_[a-z0-9_]+\.sql$/.test(fileName)) {
    throw new Error('Usage: --sql <batch> <NNN_name.sql>');
  }
  const proposal = JSON.parse(fs.readFileSync(PROPOSAL, 'utf8'));
  const cards = proposal.cards.filter((c) => String(c.batch) === String(batch));
  if (!cards.length) throw new Error(`No cards in batch ${batch}`);
  const num = fileName.slice(0, 3);
  const out = [
    `-- Migration ${num} (${new Date().toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' })})`,
    `-- Card indicators, batch ${batch}: values approved by the site owner, from docs/card-indicators-2026-10.md.`,
    '-- Only cards whose indicators are still empty are filled, so an admin edit is never overwritten.',
    '-- Requires migration 077. Register as [ ] in database_updates_master.sql; do not mark [x].',
    '',
    'BEGIN;',
    '',
  ];
  for (const c of cards) {
    out.push(`-- ${c.code} · row ${c.row} · ${c.org}`);
    out.push(
      `UPDATE directory_card_edits SET indicators = ${sqlText(JSON.stringify(c.indicators))}::jsonb, updated_at = now()`,
      `WHERE card_key = ${sqlText(c.cardKey)} AND indicators = '{}'::jsonb;`
    );
    (c.members || []).forEach((m, i) => {
      out.push(
        'INSERT INTO card_org_links (org_card_key, member_card_key, sort_order)',
        `SELECT o.card_key, m.card_key, ${i} FROM directory_card_edits o, directory_card_edits m`,
        `WHERE o.card_key = ${sqlText(c.cardKey)} AND m.card_key = ${sqlText(m)}`,
        'ON CONFLICT (org_card_key, member_card_key) DO NOTHING;'
      );
    });
    out.push('');
  }
  out.push('COMMIT;', '');
  fs.writeFileSync(path.join(__dirname, fileName), out.join('\n'));
  console.log(`${cards.length} cards → scripts/${fileName}`);
}

const sqlIdx = process.argv.indexOf('--sql');
if (sqlIdx !== -1) {
  try {
    writeSql(process.argv[sqlIdx + 1], process.argv[sqlIdx + 2]);
  } catch (err) {
    console.error(err.message);
    process.exit(1);
  }
} else {
  writeDraft().catch((err) => {
    console.error(err);
    process.exit(1);
  });
}
