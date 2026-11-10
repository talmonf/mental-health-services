-- Migration 129 (10 Nov 2026)
-- שרק תחייך (row 780): subsidized psychological and psychiatric treatment.
-- Shown under טיפול רגשי. Nationwide; the pin is the office at קרן היסוד 23, ירושלים
-- (OSM node 1697893461). The site is Hebrew only. WhatsApp is a group invite, not wa.me.
-- Audit wording approved on 10.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'שרק_תחייך_780',
  'שרק תחייך',
  'סבסוד טיפול פסיכולוגי ופסיכיאטרי למי שאין לו אפשרות לממן',
  'treatments',
  ARRAY['treatments']::text[],
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
  '780|||סבסוד טיפול פסיכולוגי ופסיכיאטרי למי שאין לו אפשרות לממן',
  780,
  'שרק_תחייך_780',
  $card780${"org":"שרק תחייך","svc":"סבסוד טיפול פסיכולוגי ופסיכיאטרי למי שאין לו אפשרות לממן","target":"מתמודדים ומשפחות בציבור הישראלי שאין ביכולתם לממן טיפול","region":"כל הארץ","cost":"סבסוד. הסכום, מספר הטיפולים ודמי ההשתתפות לא פורסמו באתר","specialty":"","languages":"עברית","diseases":"","notes":"עמותה (ע״ר 580744498) שהוקמה ב-2022 בירושלים, לזכרה של רונית וולף ז״ל. מממנת טיפול פסיכולוגי או פסיכיאטרי למי שאין ביכולתו לשלם, ועוסקת גם בהעלאת מודעות לבריאות הנפש ולמניעת אובדנות, בשיח, בכנסים ובאירועים. אינה מוקד חירום. במצוקה מיידית פנו ל-[ער״ן](https://nefesh-il.org/emergency?entry=20&section=emergency) ב-1201 או ל-101. כפתור הוואטסאפ פותח את קבוצת הוואטסאפ של העמותה. הכתובת במפה היא משרד העמותה, לא מרפאה.","tags":"","whatsapp":"https://chat.whatsapp.com/KB6L6VMXwlN8TKNrS7yFLc","whatsappLabel":"וואטסאפ","email":"tipulim@justsmile.support","emailLabel":"אימייל","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://sherak-techayech.org/","webLabel":"","web2":"","webLabel2":"","add":"https://www.facebook.com/profile.php?id=100086483650043","addLabel":"","add2":"https://www.instagram.com/just_smile_organization/","addLabel2":"","add3":"","addLabel3":"","phone":"054-9666053","phoneLabel":"טלפון","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}$card780$::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"10.11.2026: נבדק מול https://sherak-techayech.org/ . אין עמוד באנגלית. טלפון 054-9666053, אימייל tipulim@justsmile.support. פייסבוק https://www.facebook.com/profile.php?id=100086483650043 . אינסטגרם https://www.instagram.com/just_smile_organization/ (בלי פרמטר igsh). וואטסאפ הוא קישור לקבוצה https://chat.whatsapp.com/KB6L6VMXwlN8TKNrS7yFLc , לא שיחה פרטית במספר. כתובת שפורסמה: קרן היסוד 23, ירושלים. סיכה: OSM node 1697893461 (31.7735681, 35.2197131). ע״ר 580744498. בריאיון לכל העיר (27.8.2025) המייסד תיאר סבסוד עד 400 ₪ לטיפול, בין 6 ל-24 טיפולים, לעיתים עם דמי השתתפות, והמטופל בוחר את המטפל. זה לא באתר, ולכן לא על הכרטיס. פרטי תרומה (בנק, פייבוקס) לא הועתקו. justsmile.co.il הוא עסק צילום אחר."}'::jsonb,
  '[{"label":"ירושלים","address":"קרן היסוד 23, ירושלים","lat":31.7735681,"lng":35.2197131,"phone":"","email":"","note":"","sort_order":0}]'::jsonb,
  '{"offers":["navigate"],"whole_org":true,"funding":[],"referral":["self_referral"],"referral_source":"פנייה בטלפון, באימייל או בקבוצת הוואטסאפ, לפי האתר","ownership":"nonprofit","app":""}'::jsonb,
  $en780${"en":{"org":"Sherak Techayech","svc":"Subsidized psychological and psychiatric treatment for people who cannot afford it","phoneLabel":"Phone","whatsappLabel":"WhatsApp","emailLabel":"Email","target":"People and families in Israel who cannot pay for treatment","region":"Nationwide","cost":"Subsidized. The amount, the number of sessions, and any co-payment are not published on the website","languages":"Hebrew","notes":"A nonprofit (association no. 580744498) founded in Jerusalem in 2022, in memory of Ronit Wolf. It pays for psychological or psychiatric treatment for people who cannot afford it, and also raises public awareness of mental health and suicide prevention through talks, conferences and events. Not a crisis line. In immediate distress call [ERAN](https://nefesh-il.org/emergency?entry=20&section=emergency) at 1201 or 101. The WhatsApp button opens the association's WhatsApp group. The address on the map is the association's office, not a clinic.","siteLabels":["Jerusalem"],"siteAddresses":["Keren Hayesod 23, Jerusalem"]}}$en780$::jsonb,
  '{"he":{"web":"https://sherak-techayech.org/"}}'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c
JOIN (
  VALUES
    (780, 'ירושלים', 'קרן היסוד 23, ירושלים', 31.7735681::float8, 35.2197131::float8, 0)
) AS v(row_id, label, address, lat, lng, sort_order)
  ON v.row_id = c.row_id
WHERE c.card_key = '780|||סבסוד טיפול פסיכולוגי ופסיכיאטרי למי שאין לו אפשרות לממן'
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-10-sherak-techayech',
  DATE '2026-11-10',
  'נוסף כרטיס של עמותת שרק תחייך',
  'עמותה שמסבסדת טיפול פסיכולוגי ופסיכיאטרי למי שאין לו אפשרות לממן, ועוסקת גם בהעלאת מודעות למניעת אובדנות. הכרטיס מופיע תחת טיפול רגשי. המשרד בקרן היסוד 23 בירושלים, והסיוע לכל הארץ. בכרטיס יש אתר, טלפון, אימייל, קבוצת וואטסאפ, פייסבוק, אינסטגרם ומפה. האתר בעברית, ולכן הכרטיס מופיע בעברית.',
  'cards',
  ARRAY['780|||סבסוד טיפול פסיכולוגי ופסיכיאטרי למי שאין לו אפשרות לממן'],
  '{}',
  '129_sherak_techayech.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
