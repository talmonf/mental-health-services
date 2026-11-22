/**
 * One-off: write scripts/144_addictions_wording.sql and patch index.html.
 * Deleted after it runs. Row 785 is not in this list.
 */
const fs = require('fs');
const path = require('path');

const root = path.join(__dirname, '..');
const indexPath = path.join(root, 'index.html');
const sqlPath = path.join(__dirname, '144_addictions_wording.sql');
const masterPath = path.join(__dirname, 'database_updates_master.sql');

function slot(i) {
  return i === 1 ? '' : String(i);
}

function phones(list) {
  const o = {};
  for (let i = 1; i <= 6; i++) {
    const item = list[i - 1];
    o['phone' + (i === 1 ? '' : i)] = item ? item[0] : '';
    o['phoneLabel' + slot(i)] = item ? item[1] : '';
    o['phoneShowNumber' + slot(i)] = false;
  }
  return o;
}

function emails(list) {
  const o = {};
  for (let i = 1; i <= 3; i++) {
    const item = list[i - 1];
    o['email' + (i === 1 ? '' : i)] = item ? item[0] : '';
    o['emailLabel' + slot(i)] = item ? item[1] : '';
    o['emailShowAddress' + slot(i)] = false;
  }
  return o;
}

function base(extra) {
  return Object.assign(
    {
      whatsapp: '',
      whatsappLabel: '',
      cost: '',
      founded: '',
      meeting: '',
      specialty: '',
      approaches: '',
      languages: '',
      notes: '',
      target: '',
    },
    extra
  );
}

const CARDS = [
  {
    row: 94,
    unique: true,
    note: '22.11.2026: נבדק מול https://ica.org.il/clinic/ ו-https://ica.org.il/about/. הניסוח אושר עם אצוות ההתמכרויות.',
    fields: base({
      org: 'ICA – המרכז הישראלי להתמכרויות ובריאות הנפש',
      svc: 'מרפאה להתמכרויות: טיפול רפואי, וגם פסיכותרפיה. במרפאה.',
      target: 'מבוגרים ונוער',
      region: 'נתניה',
      founded: '2018',
      meeting: 'in_person',
      specialty: 'התמכרויות, וגם פוסט־טראומה, קשב ודיכאון כשהם באים עם ההתמכרות',
      approaches: 'גישה מוטיבציונית, טיפול מיודע טראומה, חיזוק קהילתי, מזעור נזקים, CBT, פסיכודינמית',
      notes: 'מרפאת מבוגרים, מרפאת נוער «נטע», ותוכנית מעג״ל. גם הכשרה, מחקר ומניעה. הצורן 2, נתניה.',
      ...phones([
        ['09-9789510', 'כללי'],
        ['09-9789500', 'מרפאה'],
      ]),
      ...emails([
        ['info@ica.org.il', 'כללי'],
        ['clinic@ica.org.il', 'מרפאה'],
      ]),
    }),
    words: {
      org: 'ICA – Israel Center on Addiction and Mental Health',
      svc: 'An addiction clinic: medical treatment, and also psychotherapy. At the clinic.',
      target: 'Adults and youth',
      region: 'Netanya',
      specialty: 'Addictions, and also post-trauma, ADHD, and depression when they come with the addiction',
      approaches: 'Motivational interviewing, trauma-informed care, community reinforcement, harm reduction, CBT, psychodynamic therapy',
      notes: 'An adult clinic, the Neta youth clinic, and the Maagal program. Also training, research, and prevention. 2 HaTzuran St, Netanya.',
      phoneLabel: 'General',
      phoneLabel2: 'Clinic',
      emailLabel: 'General',
      emailLabel2: 'Clinic',
    },
  },
  {
    row: 95,
    unique: true,
    note: '22.11.2026: נבדק מול https://hacheret.com/. הניסוח אושר עם אצוות ההתמכרויות.',
    fields: base({
      org: 'אחרת',
      svc: 'מרכז גמילה פרטי: פסיכותרפיה, ולעיתים גם מעקב פסיכיאטרי. בשהייה מלאה במרכז.',
      region: 'אור עקיבא',
      meeting: 'in_person',
      cost: 'פרטי',
      specialty: 'סמים, אלכוהול, הימורים',
      approaches: '12 הצעדים, גישות רוחניות',
      notes: 'עמותת צעדים «אחרת». עד 15 מטופלים. העצמאות 34, אור עקיבא.',
      ...phones([
        ['050-2244220', 'פניות'],
        ['050-5350387', 'פניות'],
      ]),
      ...emails([['beniaheret@gmail.com', 'אימייל']]),
    }),
    words: {
      org: 'Acheret',
      svc: 'A private addiction center: psychotherapy, and sometimes also psychiatric follow-up. A full stay at the center.',
      region: 'Or Akiva',
      cost: 'Private',
      specialty: 'Drugs, alcohol, gambling',
      approaches: 'The 12 steps, spiritual approaches',
      notes: 'The Tzeadim Acheret association. Up to 15 patients. 34 HaAtzmaut St, Or Akiva.',
      phoneLabel: 'Inquiries',
      phoneLabel2: 'Inquiries',
      emailLabel: 'Email',
    },
  },
  {
    row: 231,
    unique: true,
    note: '22.11.2026: אין אתר לכרטיס. הניסוח אושר עם אצוות ההתמכרויות.',
    fields: {
      notes: '',
      ...phones([
        ['02-5085813', 'טלפון'],
        ['02-5065814', 'טלפון'],
        ['02-5085850', 'טלפון'],
      ]),
    },
    words: {
      org: 'Ministry of Welfare – addiction services',
      svc: 'Counseling and referral, social and security.',
      notes: '',
      phoneLabel: 'Phone',
      phoneLabel2: 'Phone',
      phoneLabel3: 'Phone',
    },
  },
  {
    row: 247,
    unique: true,
    note: '22.11.2026: נבדק מול https://www.ksharim-center.org/. הניסוח אושר עם אצוות ההתמכרויות.',
    fields: base({
      org: 'מרכז קשרים',
      svc: 'פסיכותרפיה פרטנית וקבוצתית להתמכרויות התנהגותיות, וגם תוכנית 12 הצעדים. לבני משפחה יש ליווי נפרד.',
      target: 'מכורים ובני משפחה',
      region: '',
      specialty: 'מין, פורנו, הימורים, אוכל, קשרים',
      approaches: '12 הצעדים, טיפול מערכתי, טיפול פרטני, טיפול קבוצתי',
      notes: 'הכוונה ראשונית ללא עלות, בלי התחייבות ובלי הזדהות.',
      ...phones([
        ['077-9972327', 'משרד'],
        ['058-7004846', 'נייד'],
      ]),
      ...emails([['office@ksharim-center.org', 'אימייל']]),
    }),
    words: {
      org: 'Ksharim Center',
      svc: 'Individual and group psychotherapy for behavioral addictions, and also the 12-step program. Family members have separate guidance.',
      target: 'People with an addiction and family members',
      region: '',
      specialty: 'Sex, pornography, gambling, food, relationships',
      approaches: 'The 12 steps, systemic therapy, individual therapy, group therapy',
      notes: 'A first referral is free, with no commitment and no need to identify yourself.',
      phoneLabel: 'Office',
      phoneLabel2: 'Mobile',
      emailLabel: 'Email',
    },
  },
  {
    row: 248,
    unique: true,
    note: '22.11.2026: נבדק מול https://hitmakruyot.efshar.org.il/. הניסוח אושר עם אצוות ההתמכרויות.',
    fields: base({
      org: 'עמותת אפשר',
      svc: 'טיפול בהתמכרות לאלכוהול, להימורים ולהתמכרויות התנהגותיות, למכורים ולבני משפחה. במרכז.',
      target: 'מכורים ובני משפחה',
      region: 'רמת גן, רחובות, ירושלים, ראש פינה',
      meeting: 'in_person',
      specialty: 'אלכוהול, הימורים, קניות, עבודה, אינטרנט',
      notes: 'במרכז רמת גן יש גם פסיכיאטר. גם הרצאות הסברה לנוער ולמבוגרים. במרכז מתארחות קבוצות GA וקבוצת צעדים. קו ההימורים הוא מיזם עם מפעל הפיס. ארלוזרוב 1, רמת גן.',
      ...phones([
        ['03-6733228', 'יחידה'],
        ['1-700-500-888', 'הימורים'],
        ['03-5026033', 'משרד'],
      ]),
      ...emails([['efsharrg@netvision.net', 'אימייל']]),
    }),
    words: {
      org: 'Efshar Association',
      svc: 'Treatment for addiction to alcohol, gambling, and behavioral addictions, for the person and for the family. At the center.',
      target: 'People with an addiction and family members',
      region: 'Ramat Gan, Rehovot, Jerusalem, Rosh Pina',
      specialty: 'Alcohol, gambling, shopping, work, the internet',
      notes: 'The Ramat Gan center also has a psychiatrist. Also information talks for youth and adults. GA groups and a steps group meet at the center. The gambling line is a joint project with Mifal HaPais. 1 Arlozorov St, Ramat Gan.',
      phoneLabel: 'Unit',
      phoneLabel2: 'Gambling',
      phoneLabel3: 'Office',
      emailLabel: 'Email',
    },
  },
  {
    row: 249,
    unique: true,
    note: '22.11.2026: נבדק מול https://retorno.org.il/ ו-https://retorno.org.il/contact_us/. הניסוח אושר עם אצוות ההתמכרויות.',
    fields: base({
      org: 'רטורנו',
      svc: 'מרכז לגמילה מהתמכרויות: אשפוזית, טיפול יום, קהילה טיפולית וטיפול אמבולטורי. במרכז.',
      target: 'נוער ומבוגרים, נשים ונערות, וגם הציבור הדתי והחרדי',
      region: 'גבעת שמש, בית שמש',
      meeting: 'in_person',
      specialty: 'סמים, הימורים, והתמכרויות נוספות',
      notes: 'תוכניות הטראומה בכרטיסים נפרדים. גבעת שמש 815, ד.נ. שמשון. 02-999-8243 הוא פקס.',
      ...phones([['053-3773070', 'טלפון']]),
      ...emails([['retorno@retorno.org', 'אימייל']]),
    }),
    words: {
      org: 'Retorno',
      svc: 'An addiction-treatment center: inpatient care, day treatment, a therapeutic community, and outpatient care. At the center.',
      target: 'Youth and adults, women and girls, and also the religious and Haredi community',
      region: 'Givat Shemesh, Beit Shemesh',
      specialty: 'Drugs, gambling, and other addictions',
      notes: 'The trauma programs are on separate cards. Givat Shemesh 815, Doar Na Shimshon. 02-999-8243 is a fax.',
      phoneLabel: 'Phone',
      emailLabel: 'Email',
    },
  },
  {
    row: 250,
    unique: true,
    note: '22.11.2026: נבדק מול https://acher.org.il/. הניסוח אושר עם אצוות ההתמכרויות.',
    fields: base({
      org: 'דרך אחרת',
      svc: 'טיפול בהתמכרויות ובתחלואה כפולה: פסיכותרפיה, עם פסיכיאטרים בצוות. בבית מאזן או במרפאת יום.',
      region: 'בית שמש',
      meeting: 'in_person',
      cost: 'בשיתוף קופות החולים',
      specialty: 'תחלואה כפולה, סמים, אלכוהול, הימורים, מין, אינטרנט, הפרעות אכילה',
      approaches: 'טיפול מיודע טראומה, CBT, מיינדפולנס, גוף־נפש, טיפול באמנויות, פסיכודרמה',
      notes: 'רישיון משרד הבריאות. בית המאזן לגברים. יש שילוב של המשפחה, וליווי אחרי הטיפול. ההדס 4, בית שמש.',
      ...phones([
        ['02-6661166', 'משרד'],
        ['054-5553370', 'נייד'],
      ]),
      ...emails([['office@acher.org.il', 'אימייל']]),
    }),
    words: {
      org: 'Derech Acheret',
      svc: 'Treatment for addictions and dual diagnosis: psychotherapy, with psychiatrists on the team. In a balancing home or in the day clinic.',
      region: 'Beit Shemesh',
      cost: 'In cooperation with the health funds',
      specialty: 'Dual diagnosis, drugs, alcohol, gambling, sex, the internet, eating disorders',
      approaches: 'Trauma-informed care, CBT, mindfulness, mind-body therapy, arts therapy, psychodrama',
      notes: 'Licensed by the Ministry of Health. The balancing home is for men. The family is part of the treatment, and there is follow-up after it ends. 4 HaHadas St, Beit Shemesh.',
      phoneLabel: 'Office',
      phoneLabel2: 'Mobile',
      emailLabel: 'Email',
    },
  },
  {
    row: 251,
    unique: true,
    note: '22.11.2026: נבדק מול https://www.nar-anon.org.il/. הניסוח אושר עם אצוות ההתמכרויות.',
    fields: base({
      org: 'נר-אנון',
      svc: 'קבוצות 12 הצעדים למשפחות ולחברים של מכורים לסמים. זו תמיכת עמיתים, לא פסיכותרפיה.',
      target: 'משפחות וחברים של מכורים',
      region: '',
      cost: 'חינם',
      approaches: '12 הצעדים',
      languages: 'עברית, רוסית',
      notes: 'הקבוצה למשפחה ולחברים, לא למכור.',
      ...phones([
        ['050-5845886', 'עברית'],
        ['054-3759779', 'רוסית'],
      ]),
      ...emails([['info.naranon@gmail.com', 'אימייל']]),
    }),
    words: {
      org: 'Nar-Anon',
      svc: '12-step groups for families and friends of people addicted to drugs. Peer support, not psychotherapy.',
      target: 'Families and friends of people with an addiction',
      region: '',
      cost: 'Free',
      approaches: 'The 12 steps',
      languages: 'Hebrew, Russian',
      notes: 'The group is for the family and for friends, not for the person with the addiction.',
      phoneLabel: 'Hebrew',
      phoneLabel2: 'Russian',
      emailLabel: 'Email',
    },
  },
  {
    row: 252,
    unique: true,
    note: '22.11.2026: נבדק מול https://al-anon-israel.org/. הניסוח אושר עם אצוות ההתמכרויות.',
    fields: base({
      org: 'Al-Anon',
      svc: 'קבוצות תמיכה למשפחות ולחברים של אנשים עם בעיית שתייה. המפגשים פנים אל פנים או בזום.',
      target: 'משפחות וחברים של אנשים עם בעיית שתייה',
      region: 'כל הארץ',
      meeting: 'both',
      approaches: '12 הצעדים',
      languages: 'עברית, אנגלית, רוסית',
      ...phones([['02-385-1200', 'טלפון']]),
      ...emails([['israelalanon@gmail.com', 'אימייל']]),
    }),
    words: {
      org: 'Al-Anon',
      svc: 'Support groups for families and friends of someone with a drinking problem. Meetings are in person or on Zoom.',
      target: 'Families and friends of someone with a drinking problem',
      region: 'Nationwide',
      approaches: 'The 12 steps',
      languages: 'Hebrew, English, Russian',
      phoneLabel: 'Phone',
      emailLabel: 'Email',
    },
  },
  {
    row: 253,
    unique: true,
    note: '22.11.2026: נבדק מול https://www.aa-israel.co.il/. הניסוח אושר עם אצוות ההתמכרויות.',
    fields: base({
      org: 'אלכוהוליסטים אנונימיים ישראל',
      svc: 'קבוצות 12 הצעדים לאנשים עם בעיית שתייה.',
      target: 'אנשים עם בעיית שתייה',
      region: 'כל הארץ',
      cost: 'חינם',
      approaches: '12 הצעדים',
      notes: 'לבני משפחה יש את אל-אנון.',
      ...phones([['072-393-2500', 'טלפון']]),
      ...emails([['contact.aa.israel@gmail.com', 'אימייל']]),
    }),
    words: {
      org: 'Alcoholics Anonymous Israel',
      svc: '12-step groups for people with a drinking problem.',
      target: 'People with a drinking problem',
      region: 'Nationwide',
      cost: 'Free',
      approaches: 'The 12 steps',
      notes: 'Family members have Al-Anon.',
      phoneLabel: 'Phone',
      emailLabel: 'Email',
    },
  },
  {
    row: 254,
    unique: true,
    note: '22.11.2026: נבדק מול https://malkishua.org.il/contact/. הניסוח אושר עם אצוות ההתמכרויות.',
    fields: base({
      org: 'נוה מלכישוע',
      svc: 'גמילה פיזית וקהילה טיפולית. בשהייה מלאה במרכז.',
      target: 'נוער, צעירים ומבוגרים, וגם נערות',
      region: 'גלבוע',
      founded: '1990',
      meeting: 'in_person',
      specialty: 'סמים, אלכוהול והתמכרויות נוספות',
      approaches: 'קהילה טיפולית, גמילה פיזית',
      notes: 'קו חם מאויש 24/7, כולל סופי שבוע. בית בטירה וקווי קבלה נמצאים בעמוד הקשר.',
      ...phones([
        ['052-3081133', 'קו חם'],
        ['04-6488224', 'גמילה'],
        ['04-6488226', 'נוער'],
        ['04-6488230', 'אפיק'],
        ['04-6488204', 'מבוגרים'],
        ['04-6488255', 'נשים'],
      ]),
      ...emails([]),
    }),
    words: {
      org: 'Neve Malkishua',
      svc: 'Physical detox and a therapeutic community. A full stay at the center.',
      target: 'Youth, young adults, and adults, and also girls',
      region: 'Gilboa',
      specialty: 'Drugs, alcohol, and other addictions',
      approaches: 'A therapeutic community, physical detox',
      notes: 'A staffed hotline, 24/7, including weekends. The house in Tira and the intake lines are on the contact page.',
      phoneLabel: 'Hotline',
      phoneLabel2: 'Detox',
      phoneLabel3: 'Youth',
      phoneLabel4: 'Afik',
      phoneLabel5: 'Adults',
      phoneLabel6: 'Women',
    },
  },
  {
    row: 257,
    unique: true,
    note: '22.11.2026: נבדק מול https://alsam.org.il/. הניסוח אושר עם אצוות ההתמכרויות.',
    fields: base({
      org: 'עמותת אל-סם',
      svc: 'פסיכותרפיה וייעוץ לנוער ולצעירים שמשתמשים בסמים או באלכוהול, ולהורים.',
      target: 'נוער, צעירים ובני משפחה',
      region: 'כל הארץ',
      founded: '1974',
      cost: 'מסובסד על ידי העמותה, כשיש צורך',
      specialty: 'סמים, אלכוהול, הימורים, פורנוגרפיה',
      approaches: 'טיפול אישי, עבודה עם המשפחה, הדרכת הורים',
      notes: 'הטיפול בבני הנוער חסוי. אין תנאי קבלה. המשרד ברמת ישי.',
      ...phones([
        ['*3228', 'קו ייעוץ'],
        ['050-2353572', 'משרד'],
      ]),
      ...emails([['contact@alsam.org.il', 'אימייל']]),
    }),
    words: {
      org: 'Al-Sam Association',
      svc: 'Psychotherapy and counseling for youth and young people who use drugs or alcohol, and for their parents.',
      target: 'Youth, young people, and family members',
      region: 'Nationwide',
      cost: 'Subsidized by the association, when needed',
      specialty: 'Drugs, alcohol, gambling, pornography',
      approaches: 'Individual therapy, work with the family, parent guidance',
      notes: 'Care for youth is confidential. There are no admission conditions. The office is in Ramat Yishai.',
      phoneLabel: 'Counseling line',
      phoneLabel2: 'Office',
      emailLabel: 'Email',
    },
  },
];

function englishOf(card) {
  const en = {};
  for (const [k, v] of Object.entries(card.fields)) {
    if (/ShowNumber|ShowAddress/.test(k)) continue;
    if (typeof v === 'boolean') continue;
    en[k] = v;
  }
  Object.assign(en, card.words);
  return en;
}

function q(s) {
  return "'" + String(s).replace(/'/g, "''") + "'";
}

function findObjects(html, row) {
  const needle = `"row": ${row},`;
  const found = [];
  let from = 0;
  while (from < html.length) {
    const at = html.indexOf(needle, from);
    if (at < 0) break;
    let start = at;
    while (start > 0 && html[start] !== '{') start--;
    let depth = 0;
    let i = start;
    let inStr = false;
    let esc = false;
    for (; i < html.length; i++) {
      const ch = html[i];
      if (inStr) {
        if (esc) esc = false;
        else if (ch === '\\') esc = true;
        else if (ch === '"') inStr = false;
        continue;
      }
      if (ch === '"') inStr = true;
      else if (ch === '{') depth++;
      else if (ch === '}') {
        depth--;
        if (depth === 0) {
          i++;
          break;
        }
      }
    }
    const raw = html.slice(start, i);
    const tagged = raw.includes('HARAVOT_BARZEL_SEARCH');
    const parseable = tagged
      ? raw.replace(/HARAVOT_BARZEL_SEARCH/g, '"HARAVOT_BARZEL_SEARCH"')
      : raw;
    let o;
    try {
      o = JSON.parse(parseable);
    } catch (err) {
      throw new Error(`Row ${row} did not parse at ${at}: ${err.message}`);
    }
    if (o && o.svc != null && o.org != null && Number(o.row) === row) {
      found.push({ start, end: i, raw, tagged, o });
    }
    from = i;
  }
  return found;
}

let html = fs.readFileSync(indexPath, 'utf8');
const shivAt = html.indexOf('const SHIVTAYA_785 = ');
if (shivAt < 0) throw new Error('SHIVTAYA_785 missing');
const shivLine = html.slice(shivAt, html.indexOf('\n', shivAt));
const applied = [];

for (const card of CARDS) {
  const hits = findObjects(html, card.row);
  if (hits.length === 0) throw new Error(`No catalog object for row ${card.row}`);
  const orgs = new Set(hits.map((h) => h.o.org));
  if (orgs.size !== 1) {
    throw new Error(`Row ${card.row} has more than one organization: ${[...orgs].join(' | ')}`);
  }
  const svcs = new Set(hits.map((h) => h.o.svc));
  if (svcs.size !== 1) {
    throw new Error(`Row ${card.row} copies do not share a service sentence`);
  }
  const oldSvc = hits[0].o.svc;
  const newSvc = card.fields.svc || oldSvc;
  card.oldKey = `${card.row}|||${oldSvc}`;
  card.newKey = `${card.row}|||${newSvc}`;
  if (!card.fields.svc) card.fields = Object.assign({ svc: oldSvc, org: hits[0].o.org }, card.fields);

  for (let n = hits.length - 1; n >= 0; n--) {
    const hit = hits[n];
    const next = Object.assign({}, hit.o, card.fields);
    if (!card.fields.svc) next.svc = oldSvc;
    let out = JSON.stringify(next);
    if (hit.tagged || next.tags === 'HARAVOT_BARZEL_SEARCH') {
      out = out.replace('"tags":"HARAVOT_BARZEL_SEARCH"', '"tags": HARAVOT_BARZEL_SEARCH');
    }
    html = html.slice(0, hit.start) + out + html.slice(hit.end);
  }
  applied.push({ row: card.row, copies: hits.length, old: card.oldKey });
}

if (!html.includes(shivLine)) throw new Error('Row 785 was changed');

fs.writeFileSync(indexPath, html);

function rowSql(card) {
  const fields = card.fields.svc ? card.fields : Object.assign({ svc: card.oldKey.split('|||')[1] }, card.fields);
  return `  (${card.row}, ${card.unique ? 'true' : 'false'}, ${q(card.oldKey)}, ${q(card.newKey)}, ${q(JSON.stringify(fields))}::jsonb, ${q(JSON.stringify(englishOf(card)))}::jsonb, ${q(card.note)})`;
}

const keys = CARDS.map((c) => `  ${q(c.newKey)}`).join(',\n');

const sql = `-- Migration 144 (22 Nov 2026)
-- Addiction-card wording. Row 785 stays unchanged.
-- Wording approved on 22.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

CREATE TEMP TABLE addiction_wording (
  row_id integer NOT NULL,
  unique_row boolean NOT NULL,
  old_key text NOT NULL,
  new_key text NOT NULL,
  fields jsonb NOT NULL,
  en jsonb NOT NULL,
  note text NOT NULL
);

INSERT INTO addiction_wording (row_id, unique_row, old_key, new_key, fields, en, note)
VALUES
${CARDS.map(rowSql).join(',\n')};

UPDATE site_audit_entries s
SET card_keys = (
  SELECT COALESCE(array_agg(
    COALESCE((SELECT w.new_key FROM addiction_wording w WHERE w.old_key = k), k)
    ORDER BY ord
  ), '{}')
  FROM unnest(s.card_keys) WITH ORDINALITY AS u(k, ord)
)
WHERE EXISTS (
  SELECT 1
  FROM unnest(s.card_keys) k
  JOIN addiction_wording w ON w.old_key = k
);

UPDATE directory_card_edits c
SET card_key = w.new_key,
    public_fields = COALESCE(c.public_fields, '{}'::jsonb) || w.fields,
    translations = jsonb_set(
      COALESCE(c.translations, '{}'::jsonb),
      '{en}',
      COALESCE(c.translations->'en', '{}'::jsonb) || w.en,
      true
    ),
    eligibility = jsonb_set(
      COALESCE(c.eligibility, '{}'::jsonb),
      '{internal_notes}',
      to_jsonb(
        CASE
          WHEN COALESCE(c.eligibility->>'internal_notes', '') = '' THEN w.note
          ELSE rtrim(c.eligibility->>'internal_notes') || E'\\n\\n' || w.note
        END
      ),
      true
    ),
    public_edited_at = now(),
    updated_at = now()
FROM addiction_wording w
WHERE c.card_key = w.old_key
   OR (
     w.unique_row
     AND c.row_id = w.row_id
     AND (SELECT count(*) FROM directory_card_edits d WHERE d.row_id = w.row_id) = 1
   );

UPDATE directory_entries e
SET display_name = c.public_fields->>'org',
    description = c.public_fields->>'svc'
FROM directory_card_edits c
JOIN addiction_wording w ON w.new_key = c.card_key
WHERE e.entry_id = c.entry_id;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-22-addictions-wording',
  DATE '2026-11-22',
  'עודכן הניסוח בהתמכרויות',
  'בכרטיסי ההתמכרויות נכתב עכשיו מה הטיפול ואיך נפגשים, ומי משלם.',
  'cards',
  ARRAY[
${keys}
  ],
  '{}',
  '144_addictions_wording.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
`;

const written = sql.replace("E'\\\\n\\\\n'", "E'\\n\\n'");
if (!written.includes("E'\\n\\n'")) throw new Error('newline escape was lost');
fs.writeFileSync(sqlPath, written);

let master = fs.readFileSync(masterPath, 'utf8');
if (!master.startsWith('[ ] 144_addictions_wording.sql\n')) {
  master = '[ ] 144_addictions_wording.sql\n' + master;
  fs.writeFileSync(masterPath, master);
}

console.log(applied.map((a) => `${a.row} copies=${a.copies}`).join('\n'));
console.log('old keys:');
for (const c of CARDS) console.log(c.oldKey);
