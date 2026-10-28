-- Migration 104 (28 Oct 2026)
-- גירז: קבוצות ילדים ונוער (row 770) ותוכנית ללוחמים (row 771).
-- Healing in Nature: ריטריט בטבע ללוחמים קרביים (row 772).
-- אין סיכות. כתובות 19 המרכזים של גירז יגיעו בנפרד.
-- Audit wording approved on 28.10.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'גירז_geerz_770',
  'גירז (Geerz)',
  'רכיבת הרים טיפולית לילדים ונוער, גילאי 7–16',
  'youth',
  ARRAY['youth']::text[],
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
  '770|||רכיבת הרים טיפולית לילדים ונוער, גילאי 7–16',
  770,
  'גירז_geerz_770',
  '{"org":"גירז (Geerz)","svc":"רכיבת הרים טיפולית לילדים ונוער, גילאי 7–16","target":"ילדים ונוער בגילאי 7–16, בנים ובנות בקבוצות נפרדות","region":"בית שמש, רמת בית שמש א'', רמת בית שמש ג'', קיבוץ סעד, נירים, שבי דרום, אבן שמואל, כפר חסידים, אלוני יצחק","cost":"ברוב הערים 1,800 ₪ לעונה; הנחה מוקדמת, הנחת אחים ומלגה","specialty":"","languages":"עברית, אנגלית","diseases":"","notes":"מפגש שבועי של 90 דקות בשנת הלימודים: רכיבה, מיומנויות, ושיחה באמצע המסלול. בין השאר ל-ADHD, חרדה, קשיים חברתיים או התנהגותיים ודימוי עצמי. הפניה עצמית. מפגש ניסיון בפיקדון של 100 ₪. משרד: נחל מטה 14/2, בית שמש, ואינו נקודת המפגש. תוכנית ללוחמים ומילואימניקים: [גירז ללוחמים](https://nefesh-il.org/treatment?entry=771&section=trauma).","tags":"","whatsapp":"","whatsappLabel":"","email":"miriam@geerz.org","emailLabel":"מרים","emailShowAddress":false,"email2":"admin@geerz.org","emailLabel2":"משרד","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://www.geerz.org/","webLabel":"","web2":"https://www.geerz.org/en/page/registration/","webLabel2":"הרשמה","add":"","addLabel":"","phone":"058-766-2212","phoneLabel":"מרים, רכזת התוכנית","phoneShowNumber":true,"phone2":"052-772-3500","phoneLabel2":"משרד","phoneShowNumber2":true,"phone3":"052-452-2891","phoneLabel3":"משרד","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":7,"age_max":16,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"28.10.2026: נבדק מול https://www.geerz.org/ ו-https://www.geerz.org/en/faq.php . אין סיכות עד שתימסר רשימת הכתובות."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'גירז_geerz_771',
  'גירז (Geerz)',
  'רכיבת הרים טיפולית ללוחמים ומילואימניקים',
  'trauma',
  ARRAY['trauma']::text[],
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
  '771|||רכיבת הרים טיפולית ללוחמים ומילואימניקים',
  771,
  'גירז_geerz_771',
  '{"org":"גירז (Geerz)","svc":"רכיבת הרים טיפולית ללוחמים ומילואימניקים","target":"לוחמים ומילואימניקים קרביים, גם בלי אבחנה, במעבר לשגרה","region":"","cost":"600 ₪ ל-16 מפגשים; ניתן לשלם ממענק הטיפולים האישי","specialty":"","languages":"","diseases":"","notes":"16 מפגשים שבועיים של שעתיים. בחלק מהקבוצות אין צורך בניסיון, והאופניים ניתנים למשך התוכנית. פיילוט בשבי דרום, מרץ 2025. קבוצה נוספת נפתחת לפי בקשה בקהילה. קבוצות הילדים והנוער: [גירז לנוער](https://nefesh-il.org/support?entry=770&section=youth).","tags":"","whatsapp":"","whatsappLabel":"","email":"admin@geerz.org","emailLabel":"משרד","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://www.geerz.org/en/veterans.php","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"058-766-2212","phoneLabel":"מרים, רכזת התוכנית","phoneShowNumber":true,"phone2":"052-772-3500","phoneLabel2":"משרד","phoneShowNumber2":true,"phone3":"052-452-2891","phoneLabel3":"משרד","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"28.10.2026: נבדק מול https://www.geerz.org/en/faq.php ו-https://www.geerz.org/en/veterans.php . מענק הטיפולים האישי אפשרי, לא חובה. אין סיכה."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'healing_in_nature_hin_772',
  'Healing in Nature (HiN)',
  'ריטריט בטבע ללוחמים קרביים',
  'trauma',
  ARRAY['trauma']::text[],
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
  '772|||ריטריט בטבע ללוחמים קרביים',
  772,
  'healing_in_nature_hin_772',
  '{"org":"Healing in Nature (HiN)","svc":"ריטריט בטבע ללוחמים קרביים","target":"לוחמים קרביים, בקבוצה מהיחידה","region":"","cost":"לא צוין מחיר למשתתף; שבוע הריטריט מתואר כממומן בתרומות","specialty":"","languages":"","diseases":"","notes":"שבוע בטבע, כולל רכיבה טיפולית, ואחר כך קהילת בוגרים. הערכה לפני ואחרי, כולל באוניברסיטת תל אביב. צוות עם פסיכיאטר ופסיכולוגים קליניים. פנייה באימייל; הקבוצות לפי יחידה. משרד העמותה: חוט השני 1, מודיעין. הריטריט שפורסם באתר ובעיתונות (2024) היה במונטנה, לא במשרד.","tags":"","whatsapp":"","whatsappLabel":"","email":"contact@hin-group.org","emailLabel":"פניות","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://www.hin-group.org/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"054-203-0339","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"28.10.2026: נבדק מול https://www.hin-group.org/ , https://www.hin-group.org/terms-and-conditions ו-https://www.timesofisrael.com/weeklong-retreat-in-montana-ranch-aims-to-heal-idf-vets-from-war-traumas/ . אין סיכה: המשרד במודיעין אינו מקום הריטריט."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-10-28-geerz',
  DATE '2026-10-28',
  'נוספו שני כרטיסים של גירז',
  'גירז, תוכנית רכיבת הרים טיפולית. כרטיס לקבוצות ילדים ונוער בגילאי 7–16 תחת נוער וצעירים, וכרטיס ללוחמים ומילואימניקים תחת טראומה.',
  'cards',
  ARRAY[
    '770|||רכיבת הרים טיפולית לילדים ונוער, גילאי 7–16',
    '771|||רכיבת הרים טיפולית ללוחמים ומילואימניקים'
  ],
  '{}',
  '104_geerz_and_healing_in_nature.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-10-28-healing-in-nature',
  DATE '2026-10-28',
  'נוסף כרטיס של Healing in Nature',
  'ריטריט של שבוע בטבע ללוחמים קרביים, תחת טראומה. כולל הערכה לפני ואחרי וקהילת בוגרים. אין כתובת מפגש קבועה; משרד העמותה במודיעין.',
  'cards',
  ARRAY['772|||ריטריט בטבע ללוחמים קרביים'],
  '{}',
  '104_geerz_and_healing_in_nature.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
