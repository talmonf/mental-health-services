-- Migration 121 (8 Nov 2026)
-- Shikum Acher (row 777): supported employment and career development for rehabilitation-basket recipients.
-- Shown under שיקום and under נוער וצעירים.
-- Hebrew stays in public_fields. translations.en replaces those fields while the site is in English.
-- One pin: המרץ 20, קרית אריה, פתח תקווה. OSM has the street (way 367504058, HaMerets) and not house 20; the pin is the street centroid.
-- Audit wording approved with the plan on 07.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'shikum_acher_777',
  'שיקום אחר',
  'תעסוקה נתמכת ופיתוח קריירה לזכאי סל שיקום',
  'rehabilitation',
  ARRAY['rehabilitation', 'youth']::text[],
  ARRAY['rehab_basket_committee']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (
  card_key, row_id, entry_id, public_fields, eligibility, sites, translations
) VALUES (
  '777|||תעסוקה נתמכת ופיתוח קריירה לזכאי סל שיקום',
  777,
  'shikum_acher_777',
  $card777${"org":"שיקום אחר","svc":"תעסוקה נתמכת ופיתוח קריירה לזכאי סל שיקום","target":"זכאי סל שיקום מגיל 18. וורקאיט: 18–35. אמצע החיים: 45 ומעלה","region":"כל הארץ","cost":"במימון סל שיקום","specialty":"","languages":"","diseases":"","notes":"וורקאיט: חקר קריירה והתנסות לצעירים, בליווי בעיר שלהם. ג׳ובי: תעסוקה נתמכת בשוק החופשי לפי בחירת המשתתף, גם אחרי ההשתלבות. אמצע החיים: חזרה לעבודה או שינוי קריירה. גם סדנאות הכנה לעבודה. הכניסה אחרי אישור ועדת סל שיקום לתעסוקה נתמכת.","tags":"","whatsapp":"","whatsappLabel":"","email":"info@shikumacher.org.il","emailLabel":"אימייל","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://shikumacher.org.il/","webLabel":"","web2":"https://shikumacher.org.il/programs/","webLabel2":"תכניות","add":"","addLabel":"","phone":"073-3745040","phoneLabel":"טלפון","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}$card777$::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"required"},"internal_notes":"08.11.2026: נבדק מול https://shikumacher.org.il/ , https://shikumacher.org.il/programs/ , https://shikumacher.org.il/programs/workit/ , https://shikumacher.org.il/programs/jobbi/ , https://shikumacher.org.il/programs/midlife_plan/ ו-https://shikumacher.org.il/en/ . העמוד /en/programs/ עדיין בעברית, ו-/en/programs/workit/ מחזיר 404, ולכן הקישור באנגלית הוא לעמוד הבית האנגלי. סיכה: המרץ 20, קרית אריה, פתח תקווה. ב-OSM יש את הרחוב (way 367504058, HaMerets) ואין בית 20; הסיכה היא מרכז הרחוב (32.0931914, 34.8556856). מודעות דרושים מאפריל 2026 מנו רכזים בירושלים, בשפלה, בצפון, בחדרה–נתניה, בתל אביב ובבאר שבע. אלה לא כתובות סניף שפורסמו, ולכן לא נכנסו לאזור."}'::jsonb,
  '[{"label":"פתח תקווה","address":"המרץ 20, קרית אריה, פתח תקווה","lat":32.0931914,"lng":34.8556856,"phone":"","email":"","note":"","sort_order":0}]'::jsonb,
  $en777${"en":{"org":"Shikum Acher","svc":"Supported employment and career development for rehabilitation-basket recipients","web":"https://shikumacher.org.il/en/","web2":"https://shikumacher.org.il/en/","webLabel2":"Programs","phoneLabel":"Phone","emailLabel":"Email","target":"Rehabilitation-basket recipients, age 18 and up. WORKIT: ages 18–35. Mid-Life: age 45 and over","region":"Nationwide","cost":"Funded by the rehabilitation basket","notes":"WORKIT: career exploration for young adults, with support in their own city. Jobbi: supported employment in the open job market, in a role the participant chooses, including after placement. Mid-Life: returning to work or a career change. Short workshops on preparing for work are also offered. Joining requires the rehabilitation-basket committee's approval for supported employment.","siteLabels":["Petah Tikva"],"siteAddresses":["HaMartz 20, Kiryat Aryeh, Petah Tikva"]}}$en777$::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c
JOIN (
  VALUES
    (777, 'פתח תקווה', 'המרץ 20, קרית אריה, פתח תקווה', 32.0931914::float8, 34.8556856::float8, 0)
) AS v(row_id, label, address, lat, lng, sort_order)
  ON v.row_id = c.row_id
WHERE c.card_key = '777|||תעסוקה נתמכת ופיתוח קריירה לזכאי סל שיקום'
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-07-shikum-acher',
  DATE '2026-11-07',
  'נוסף כרטיס של עמותת שיקום אחר',
  'שיקום תעסוקתי לזכאי סל שיקום: וורקאיט לצעירים בני 18 עד 35, ג׳ובי לתעסוקה נתמכת, ואמצע החיים לבני 45 ומעלה. הכרטיס מופיע בשיקום ובנוער וצעירים. המשרד בפתח תקווה, והליווי בקהילה ברחבי הארץ. באנגלית הכרטיס מוצג כ-Shikum Acher, והקישור לאתר מוביל לעמוד האנגלי.',
  'cards',
  ARRAY['777|||תעסוקה נתמכת ופיתוח קריירה לזכאי סל שיקום'],
  '{}',
  '121_shikum_acher.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
