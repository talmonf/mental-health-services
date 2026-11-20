-- Migration 139 (19 Nov 2026)
-- שבטיא (row 785): a private residential addiction center in Beer Sheva.
-- One card, under התמכרויות.
-- Pin: גרשון דובנבוים 24, באר שבע. OSM has no building node for 24.
-- The pin is the center of the southern street segment named גרשון דובינבוים
-- (way 79652321). Neighboring numbers 35 and 46 place 24 there.
-- https://shivtaya.co.il/en/ is 404, and the page is Hebrew only, so no en site.
-- English wording is stored for a direct link.
-- Audit wording approved with the plan on 19.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'שבטיא_785',
  'שבטיא',
  'אבחון וטיפול תרופתי, וגם פסיכותרפיה, בשהייה מלאה',
  'addictions',
  ARRAY['addictions']::text[],
  ARRAY['self_referral']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (
  card_key, row_id, entry_id, public_fields, eligibility, sites, indicators, translations, site_languages
) VALUES (
  '785|||מרכז גמילה פרטי: אבחון וטיפול תרופתי, וגם פסיכותרפיה. בשהייה מלאה במרכז.',
  785,
  'שבטיא_785',
  $card785${"org":"שבטיא","svc":"מרכז גמילה פרטי: אבחון וטיפול תרופתי, וגם פסיכותרפיה. בשהייה מלאה במרכז.","target":"מבוגרים","region":"באר שבע","cost":"פרטי, או במימון מלא של אגף השיקום או של ביטוח לאומי לנפגעי פעולות איבה.","specialty":"התמכרות לסמים, לקנאביס, לאלכוהול, להימורים, לקוקאין ולקטמין","languages":"עברית","diseases":"","notes":"עד 15 מטופלים, כחצי שנה. שלושה שלבים: גמילה פיזית, עבודה על שורש ההתמכרות, והכנה ליציאה. אחר כך ליווי לבוגרים בקהילה. גם הדרכה למשפחה. רישיון משולב של משרד הבריאות ומשרד הרווחה. למטופלים בתוכנית עם דיכאון עמיד או פוסט־טראומה יש הפניה ל־Deep TMS במרכז לבריאות הנפש בבאר שבע. [גרייה מגנטית](https://nefesh-il.org/treatment?entry=105&section=treatments) בכרטיס נפרד.","tags":"","whatsapp":"","whatsappLabel":"","email":"info@shivtaya.co.il","emailLabel":"אימייל","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://shivtaya.co.il/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","add2":"","addLabel2":"","add3":"","addLabel3":"","phone":"058-712-4712","phoneLabel":"טלפון","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true,"founded":"2019","approaches":"גישה מוטיבציונית, CBT, טיפול ממוקד יחסים, 12 הצעדים, קבוצות, פסיכו־חינוך, מיינדפולנס, תרפיה באומנות, דיקור","meeting":""}$card785$::jsonb,
  $elig785${"age_min":18,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":["התמכרות לסמים","התמכרות לקנאביס","התמכרות לאלכוהול","התמכרות להימורים","התמכרות לקוקאין","התמכרות לקטמין"],"presenting_problems":["התמכרות לסמים","התמכרות לקנאביס","התמכרות לאלכוהול","התמכרות להימורים","התמכרות לקוקאין","התמכרות לקטמין"],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"19.11.2026: נבדק מול https://shivtaya.co.il/ , https://shivtaya.co.il/%d7%9b%d7%aa%d7%91%d7%95%d7%aa/%d7%9b%d7%aa%d7%91%d7%95%d7%aa-%d7%a2%d7%9c-%d7%98%d7%99%d7%a4%d7%95%d7%9c%d7%99-%d7%92%d7%9e%d7%99%d7%9c%d7%94-%d7%9e%d7%95%d7%aa%d7%90%d7%9e%d7%99%d7%9d/%d7%9e%d7%a8%d7%9b%d7%96-%d7%92%d7%9e%d7%99%d7%9c%d7%94-%d7%9c%d7%a0%d7%95%d7%a2%d7%a8/ , https://shivtaya.co.il/%d7%92%d7%99%d7%a9%d7%95%d7%aa-%d7%98%d7%99%d7%a4%d7%95%d7%9c%d7%99%d7%95%d7%aa-%d7%91%d7%a9%d7%91%d7%98%d7%99%d7%90/%d7%98%d7%99%d7%a4%d7%95%d7%9c-deep-tms/ , https://shivtaya.co.il/%d7%aa%d7%95%d7%9b%d7%a0%d7%99%d7%95%d7%aa-%d7%98%d7%99%d7%a4%d7%95%d7%9c/%d7%98%d7%99%d7%a4%d7%95%d7%9c-%d7%99%d7%95%d7%9d-%d7%a4%d7%a1%d7%99%d7%9b%d7%99%d7%90%d7%98%d7%a8%d7%99/ והרישיון ב-https://shivtaya.co.il/wp-content/uploads/2026/06/ . https://shivtaya.co.il/en/ מחזיר 404. העמוד הראשי הוא lang=he-IL, בלי hreflang ובלי מתג שפה, ולכן אין en ב-site_languages. נוסח הכרטיס באנגלית לפי העמוד בעברית. קהל: מבוגרים. באתר: מגיל 18, בלי קטינים. זה לא חוזר בלמי ובהערות. הוקם 2019, מתוך העמוד על גמילה לצעירים. meeting ריק: אין מרפאה ואין זום, יש שהייה מלאה. טיפול יום פסיכיאטרי מתואר באתר כמתוכנן להיפתח, ולא על הכרטיס. Deep TMS הוא הפניה למטופלים בתוכנית, במרכז לבריאות הנפש בבאר שבע, לא מרפאה של שבטיא. כרטיס 105 הוא גרייה מגנטית. רישיון משולב 16716, בתוקף 1.2.2026 עד 1.2.2028. ספק אגף השיקום 11031936. ספק ביטוח לאומי לנפגעי פעולות איבה 514725779. המספרים לא על הכרטיס. טלפון 058-712-4712 ומייל info@shivtaya.co.il. כפתור אחד לכל אחד, בלי מילה על הכפתור. כתובת בכרטיס: גרשון דובנבוים 24, באר שבע, לפי הרישיון ודפי זהב. ב-OSM שם הרחוב הוא גרשון דובינבוים (name:en Gershon Dubenboim). אין סיכת בניין למספר 24. המספרים 35, 38, 39 ו-46 יושבים על הקטע הצפוני. קו ישר מ-35 ל-46 נוחת על הקטע הדרומי, way 79652321. הסיכה היא מרכז הקטע הזה: 31.240536, 34.792970. מען הבעלים ברישיון, גרשון דובנבוים 42, לא על הכרטיס."}$elig785$::jsonb,
  '[{"label":"באר שבע","address":"גרשון דובנבוים 24, באר שבע","lat":31.240536,"lng":34.792970,"phone":"","email":"","note":"","sort_order":0}]'::jsonb,
  $ind785${"offers":["care"],"whole_org":true,"funding":[{"channel":"private","terms":""},{"channel":"mod","terms":"full"},{"channel":"btl","terms":"full"}],"referral":["self_referral"],"referral_source":"פנייה ישירה. מימון מלא דרך אגף השיקום או ביטוח לאומי לנפגעי פעולות איבה, כשמתקיימת זכאות.","ownership":"private","app":""}$ind785$::jsonb,
  $en785${"en":{"org":"Shivtaya","svc":"Private addiction center: assessment and medication, and also psychotherapy. A full stay at the center.","target":"Adults","region":"Beer Sheva","cost":"Private, or fully funded by the Ministry of Defense rehabilitation department or by the National Insurance Institute for victims of hostilities.","specialty":"Addiction to drugs, cannabis, alcohol, gambling, cocaine, and ketamine","languages":"Hebrew","notes":"Up to 15 patients, about half a year. Three stages: physical withdrawal, work on the root of the addiction, and preparation to leave. Then community follow-up for graduates. Also guidance for the family. A combined license from the Ministry of Health and the Ministry of Welfare. Patients in the program who also have treatment-resistant depression or post-trauma can be referred for Deep TMS at the mental-health center in Beer Sheva. [Magnetic stimulation](https://nefesh-il.org/treatment?entry=105&section=treatments) is a separate card.","phoneLabel":"Phone","emailLabel":"Email","siteLabels":["Beer Sheva"],"siteAddresses":["24 Gershon Dubenboim St, Beer Sheva"],"founded":"2019","approaches":"Motivational approach, CBT, relationship-focused therapy, the 12 steps, groups, psychoeducation, mindfulness, art therapy, and acupuncture"}}$en785$::jsonb,
  '{"he":{"web":"https://shivtaya.co.il/"}}'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c
JOIN (
  VALUES
    (785, 'באר שבע', 'גרשון דובנבוים 24, באר שבע', 31.240536::float8, 34.792970::float8, 0)
) AS v(row_id, label, address, lat, lng, sort_order)
  ON v.row_id = c.row_id
WHERE c.card_key = '785|||מרכז גמילה פרטי: אבחון וטיפול תרופתי, וגם פסיכותרפיה. בשהייה מלאה במרכז.'
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-19-shivtaya',
  DATE '2026-11-19',
  'נוסף שבטיא',
  'מרכז גמילה פרטי בבאר שבע למבוגרים, בשהייה מלאה. אבחון וטיפול תרופתי, וגם פסיכותרפיה. פרטי, או במימון מלא של אגף השיקום או של ביטוח לאומי לנפגעי פעולות איבה. הכרטיס בהתמכרויות. יש טלפון ואימייל, וסיכה בגרשון דובנבוים 24. האתר בעברית.',
  'cards',
  ARRAY['785|||מרכז גמילה פרטי: אבחון וטיפול תרופתי, וגם פסיכותרפיה. בשהייה מלאה במרכז.'],
  '{}',
  '139_shivtaya.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
