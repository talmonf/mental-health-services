-- Migration 122 (8 Nov 2026)
-- רוח ים (row 778): private balancing house, Ramat Yam 77, Herzliya.
-- רוח ים פרובנס (row 779): the other balancing house, Nachshon 2, Herzliya.
-- Both under חלופות אשפוז. Pins: Ramat Yam sits on OSM way 976153796
-- (the road is named שדרות אלי לנדאו there; the site still says רמת ים 77).
-- Nachshon is OSM way 403081308; the street is short and has no separate house node.
-- Audit wording approved on 08.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'רוח_ים_778',
  'רוח ים',
  'בית מאזן פרטי יוקרתי, ללא רשימת המתנה',
  'alternatives',
  ARRAY['alternatives']::text[],
  ARRAY['self_referral']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '778|||בית מאזן פרטי יוקרתי, ללא רשימת המתנה',
  778,
  'רוח_ים_778',
  $card778${"org":"רוח ים","svc":"בית מאזן פרטי יוקרתי, ללא רשימת המתנה","target":"מבוגרים מעל גיל 18, נשים וגברים, במשבר נפשי חריף, שלא יכולים להישאר בבית. גם מי שהוכר במשרד הביטחון","region":"הרצליה","cost":"פרטי. מחיר לא פורסם","specialty":"","languages":"","diseases":"","notes":"זה הבית הפרטי, ברמת ים 77. גם למי שהוכר במשרד הביטחון, אגף השיקום. זה לא [רוח ים פרובנס](https://nefesh-il.org/treatment?entry=779&section=alternatives). חלופה לאשפוז פסיכיאטרי, על חוף הים. צוות עם פסיכיאטרים, עובד סוציאלי, אחות מוסמכת, מטפלים אלטרנטיביים ומלווים בעלי ניסיון. התוכנית נבנית על ידי פסיכיאטר, וכוללת טיפול פסיכיאטרי, פסיכוסוציאלי, תרופתי לפי הצורך וטיפול רגשי, וגם מענה לבני המשפחה. במקום חדרים או סוויטות, שף לשלוש ארוחות ביום וצוות 24/7. [רשימת הבתים](https://nefesh-il.org/treatment?entry=53&section=alternatives) ו[בית מאזן של האגף](https://nefesh-il.org/treatment?entry=762&section=alternatives) בכרטיסים נפרדים.","tags":"","whatsapp":"972502230860","whatsappLabel":"חמוטל","email":"eyal@ruahyam.com","emailLabel":"","emailShowAddress":true,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://ruahyam.com/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"050-5923086","phoneLabel":"","phoneShowNumber":true,"phone2":"050-2230860","phoneLabel2":"חמוטל","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}$card778$::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"08.11.2026: נבדק מול https://ruahyam.com/ , דף האודות ודף המגורים. וואטסאפ באתר הוא 972502230860 (חמוטל), לא 050-5923086. סיכה: רמת ים 77. ב-OSM הרחוב שם נקרא שדרות אלי לנדאו (way 976153796); אין מספר בית נפרד. «ללא רשימת המתנה» לפי בעל האתר."}'::jsonb,
  '[{"label":"הרצליה","address":"רמת ים 77, הרצליה","lat":32.169976,"lng":34.800575,"phone":"","email":"","note":"","sort_order":0}]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c
JOIN (
  VALUES
    (778, 'הרצליה', 'רמת ים 77, הרצליה', 32.169976::float8, 34.800575::float8, 0)
) AS v(row_id, label, address, lat, lng, sort_order)
  ON v.row_id = c.row_id
WHERE c.card_key = '778|||בית מאזן פרטי יוקרתי, ללא רשימת המתנה'
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'רוח_ים_פרובנס_779',
  'רוח ים פרובנס',
  'בית מאזן',
  'alternatives',
  ARRAY['alternatives']::text[],
  ARRAY['self_referral']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '779|||בית מאזן',
  779,
  'רוח_ים_פרובנס_779',
  $card779${"org":"רוח ים פרובנס","svc":"בית מאזן","target":"אנשים במשבר נפשי חריף","region":"הרצליה","cost":"","specialty":"","languages":"","diseases":"","notes":"זה בית מאזן, לא הבית הפרטי. הבית הפרטי הוא [רוח ים ברמת ים](https://nefesh-il.org/treatment?entry=778&section=alternatives). חלופה לאשפוז, בנחשון 2. האתר מציין שיתוף עם האגף לנפגעי פעולות איבה בביטוח לאומי. בדף האודות הבית מתואר גם כבית מאזן לתחלואה כפולה. באתר מוזכרת הפנייה מפסיכיאטר, וגם פגישת ייעוץ ראשונית בלי התחייבות. [רשימת הבתים](https://nefesh-il.org/treatment?entry=53&section=alternatives) בכרטיס נפרד.","tags":"","whatsapp":"972502704333","whatsappLabel":"050-2704333","email":"ida@ruahyam-provence.co.il","emailLabel":"","emailShowAddress":true,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://ruahyam-provence.co.il/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"055-6698519","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}$card779$::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"08.11.2026: נבדק מול https://ruahyam-provence.co.il/ ודף האודות. טלפון בדף 055-6698519. וואטסאפ 972502704333, לא כפתור חיוג. סיכה: נחשון 2, OSM way 403081308. הרחוב קצר ואין מספר בית נפרד. גיל לא צוין."}'::jsonb,
  '[{"label":"הרצליה","address":"נחשון 2, הרצליה","lat":32.1741673,"lng":34.8146496,"phone":"","email":"","note":"","sort_order":0}]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c
JOIN (
  VALUES
    (779, 'הרצליה', 'נחשון 2, הרצליה', 32.1741673::float8, 34.8146496::float8, 0)
) AS v(row_id, label, address, lat, lng, sort_order)
  ON v.row_id = c.row_id
WHERE c.card_key = '779|||בית מאזן'
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-08-ruah-yam',
  DATE '2026-11-08',
  'נוספו שני בתי מאזן של רוח ים',
  'שני בתים בהרצליה, בכרטיסים נפרדים תחת חלופות אשפוז. רוח ים ברמת ים 77 הוא בית מאזן פרטי, בלי רשימת המתנה, וגם למי שהוכר במשרד הביטחון. רוח ים פרובנס בנחשון 2 הוא בית מאזן, בשיתוף האגף לנפגעי פעולות איבה.',
  'cards',
  ARRAY[
    '778|||בית מאזן פרטי יוקרתי, ללא רשימת המתנה',
    '779|||בית מאזן'
  ],
  '{}',
  '122_ruah_yam.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
