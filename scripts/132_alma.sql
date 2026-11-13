-- Migration 132 (12 Nov 2026)
-- אלמה (row 782): a licensed women-only balancing house in Tzahala, Tel Aviv,
-- for women with complex PTSD, with the eating disorder as the symptom.
-- One card, under חלופות אשפוז, טראומה, and טיפול תזונתי.
-- Pin: צה״ל 2א, צהלה, תל אביב. OSM node 2079031703.
-- The English control is GTranslate on the same Hebrew URL (url_structure none).
-- https://almarecoveryhome.co.il/en/ is 404, so the card is listed in Hebrew.
-- English wording is stored for a direct link.
-- Audit wording approved with the plan on 12.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'אלמה_בית_מאזן_782',
  'אלמה',
  'בית מאזן לנשים עם פוסט־טראומה מורכבת והפרעת אכילה',
  'alternatives',
  ARRAY['alternatives', 'trauma', 'nutrition']::text[],
  ARRAY['psychiatrist_referral', 'gp_referral']::text[]
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
  '782|||בית מאזן לנשים עם פוסט־טראומה מורכבת והפרעת אכילה',
  782,
  'אלמה_בית_מאזן_782',
  $card782${"org":"אלמה","svc":"בית מאזן לנשים עם פוסט־טראומה מורכבת והפרעת אכילה","target":"נשים מגיל 18 עם פוסט־טראומה מורכבת, שהפרעת האכילה היא הסימפטום שלה. הקבלה בהסכמה, מ-BMI 16, בלי הזנה בזונדה","region":"צהלה, תל אביב","cost":"פרטי, עם הסדר מול מאוחדת. מחיר לא פורסם","specialty":"פוסט־טראומה מורכבת, הפרעות אכילה","languages":"עברית","diseases":"","notes":"חלופת אשפוז ברישיון משרד הבריאות. רוב הנשים עברו טראומה מורכבת, והפרעת האכילה היא הסימפטום. הטיפול מתייחס גם לטראומה וגם להפרעת האכילה. שהות של כשלושה חודשים, ואחר כך אפשרות לטיפול יום. הקבלה עם הפניה כתובה מגורם טיפולי. לא מתאים מתחת ל-BMI 16, לסכנה רפואית, להתמכרות פעילה, או לסכנה מיידית. באתר יש גם קליניקה אמבולטורית. הכרטיס הזה הוא הבית המאזן. [רשימת הבתים](https://nefesh-il.org/treatment?entry=53&section=alternatives) בכרטיס נפרד.","tags":"","whatsapp":"","whatsappLabel":"","email":"contact@almarecoveryhome.co.il","emailLabel":"אימייל","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://almarecoveryhome.co.il/","webLabel":"","web2":"https://almarecoveryhome.co.il/process/","webLabel2":"תהליך קבלה","add":"","addLabel":"","add2":"","addLabel2":"","add3":"","addLabel3":"","phone":"054-2180866","phoneLabel":"טלפון","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}$card782$::jsonb,
  $elig782${"age_min":18,"age_max":null,"sex":"female","location_mode":"any","regions":[],"diagnoses":["פוסט־טראומה מורכבת","הפרעות אכילה"],"presenting_problems":["פוסט־טראומה מורכבת","הפרעות אכילה"],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"12.11.2026: נבדק מול https://almarecoveryhome.co.il/ , https://almarecoveryhome.co.il/about/ , https://almarecoveryhome.co.il/process/ , https://almarecoveryhome.co.il/contact/ ו-https://almarecoveryhome.co.il/lp/ . https://almarecoveryhome.co.il/en/ מחזיר 404. אין עמודי אנגלית באתר. GTranslate עם url_structure none (en, iw) מתרגם את אותו עמוד עברי, ולכן אין en ב-site_languages. כתובת בכרטיס: צה״ל 2א, צהלה, תל אביב. שורת האזור לא מוצגת, כי הכתובת כבר כוללת את צהלה ואת תל אביב. סיכה: OSM node 2079031703. טלפון ומייל מהעמוד הראשי ומדף הקשר: 054-2180866, contact@almarecoveryhome.co.il. דף הנחיתה מציין גם 054-440-4743 ו-almahome247@gmail.com, וכותב שהסכמים עם קופות יתאפשרו בעתיד. השאלות הנפוצות בעמוד הראשי אומרות שהשירות פרטי מלבד הסדר עם מאוחדת, וזה מה שעל הכרטיס. jobs@ לא על הכרטיס. Alma Clinic בעמוד נפרד ואינה הכרטיס. קהל: נשים מעל 18, בהסכמה, BMI מינימום 16 בלי זונדה. לא מתאים מתחת ל-16, סכנה רפואית, התמכרות פעילה, או סכנה מיידית. הפניה כתובה מגורם טיפולי. שהות כ-3 חודשים ואחר כך טיפול יום. 12.11.2026, בעל האתר: הנשים עם CPTSD, לרוב טראומה מורכבת מאוד, והפרעת האכילה היא הסימפטום. הטיפול משלב את שניהם. בשיבא הדגש על הפרעת האכילה. BMI נמוך מאוד: מתחילות בשיבא וממשיכות בבית. אין כרטיס נפרד למחלקת האשפוז להפרעות אכילה בשיבא. כרטיס 641 הוא מרפאה ברשימה הציבורית, ולא קושר. 13.11.2026, בעל האתר: הנוסח של «למי» ושל ההערות עודכן. שיבא והשהות 24 שעות ירדו מההערות הגלויות."}$elig782$::jsonb,
  '[{"label":"צהלה","address":"צה״ל 2א, צהלה, תל אביב","lat":32.122469,"lng":34.827065,"phone":"","email":"","note":"","sort_order":0}]'::jsonb,
  $ind782${"offers":["care"],"whole_org":true,"funding":[{"channel":"private","terms":""},{"channel":"hmo","terms":"הסדר עם מאוחדת"}],"referral":["psychiatrist_referral","gp_referral"],"referral_source":"הפנייה עדכנית ומנומקת בכתב מגורם טיפולי מוסמך (פסיכיאטר, רופא משפחה ו/או מטפל מקצועי מורשה אחר)","ownership":"private","app":""}$ind782$::jsonb,
  $en782${"en":{"org":"Alma","svc":"Balancing house for women with complex PTSD and an eating disorder","phoneLabel":"Phone","emailLabel":"Email","webLabel2":"Intake","target":"Women aged 18 and over with complex PTSD, whose eating disorder is a symptom of it. Admission is by consent, from a BMI of 16, without tube feeding","region":"Tzahala, Tel Aviv","cost":"Private, with an arrangement with Meuhedet. Price not published","specialty":"Complex PTSD, eating disorders","languages":"Hebrew","notes":"A hospitalization alternative licensed by the Ministry of Health. Most of the women have been through complex trauma, and the eating disorder is the symptom. Treatment addresses both the trauma and the eating disorder. A stay of about three months, then the option of day treatment. Admission is with a written referral from a treating professional. Not suitable below a BMI of 16, with a medical danger, with active addiction, or with immediate danger. The website also has an outpatient clinic. This card is the balancing house. The [list of balancing houses](https://nefesh-il.org/treatment?entry=53&section=alternatives) is a separate card.","siteLabels":["Tzahala"],"siteAddresses":["Tzahal 2A, Tzahala, Tel Aviv"]}}$en782$::jsonb,
  '{"he":{"web":"https://almarecoveryhome.co.il/","web2":"https://almarecoveryhome.co.il/process/"}}'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c
JOIN (
  VALUES
    (782, 'צהלה', 'צה״ל 2א, צהלה, תל אביב', 32.122469::float8, 34.827065::float8, 0)
) AS v(row_id, label, address, lat, lng, sort_order)
  ON v.row_id = c.row_id
WHERE c.card_key = '782|||בית מאזן לנשים עם פוסט־טראומה מורכבת והפרעת אכילה'
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-12-alma',
  DATE '2026-11-12',
  'נוסף אלמה בית מאזן',
  'בית מאזן בצהלה, תל אביב, לנשים מגיל 18 עם הפרעות אכילה. חלופת אשפוז ברישיון משרד הבריאות, פרטית עם הסדר מול מאוחדת. הכרטיס בחלופות אשפוז ובטיפול תזונתי.',
  'cards',
  ARRAY['782|||בית מאזן לנשים עם פוסט־טראומה מורכבת והפרעת אכילה'],
  '{}',
  '132_alma.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
