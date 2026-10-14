-- Migration 056 (14 Oct 2026)
-- directory_entries + directory_card_edits: האגף לבריאות הנפש (עזר מציון), row 305.
-- Umbrella for rehabilitation employment, leisure, and family centers.
-- ידידי נפש stays row 26. בלב ובנפש stays row 68.
-- Listed under rehabilitation + families. No map pin: the address is headquarters.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys,
  referral_codes
) VALUES (
  'האגף_לבריאות_הנפש_עזר_מציון_305',
  'האגף לבריאות הנפש (עזר מציון)',
  'שיקום תעסוקתי, תעסוקה נתמכת, פנאי ומרכזי משפחות למתמודדי נפש מגיל 18',
  'rehabilitation',
  ARRAY['rehabilitation', 'families']::text[],
  ARRAY['self_referral', 'rehab_basket_committee']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '305|||שיקום תעסוקתי, תעסוקה נתמכת, פנאי ומרכזי משפחות למתמודדי נפש מגיל 18',
  305,
  'האגף_לבריאות_הנפש_עזר_מציון_305',
  '{"org":"האגף לבריאות הנפש (עזר מציון)","svc":"שיקום תעסוקתי, תעסוקה נתמכת, פנאי ומרכזי משפחות למתמודדי נפש מגיל 18","target":"מתמודדי נפש מגיל 18 ובני משפחותיהם. שיקום תעסוקתי ותעסוקה בשוק החופשי: זכאי סל שיקום, עד גיל פרישה","region":"מטה: הרב רבינוב 5, בני ברק. שיקום תעסוקתי: אזור המרכז. תעסוקה נתמכת: גוש דן, חיפה והקריות, מודיעין עילית","cost":"","specialty":"","languages":"","diseases":"","notes":"רצף שיקום תעסוקתי לזכאי סל שיקום: כישורי חיים, אפיקים לגברים, מטעמים מהלב לנשים, צלילי הנפש. תעסוקה נתמכת בשוק החופשי. קו הייעוץ ידידי נפש בכרטיס נפרד (שורה 26). בלב ובנפש בכרטיס נפרד (שורה 68).","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://www.ami.org.il/communities/mental-health","webLabel":"","web2":"https://www.ami.org.il/services/rehabilitation-employment","webLabel2":"שיקום תעסוקתי","add":"https://www.ami.org.il/services/free-market-labor","addLabel":"תעסוקה נתמכת","phone":"073-3952222","phoneLabel":"שיקום ותעסוקה","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"נבדק 14.10.2026 מול ami.org.il/communities/mental-health, ami.org.il/services/rehabilitation-employment ו-ami.org.il/services/free-market-labor. האגף למתמודדי נפש מגיל 18 ולבני משפחותיהם. שיקום תעסוקתי ותעסוקה נתמכת: זכאי סל שיקום מגיל 18 עד גיל פרישה. שיקום תעסוקתי באזור המרכז: כישורי חיים, אפיקים לגברים, מטעמים מהלב לנשים, צלילי הנפש. תעסוקה נתמכת: גוש דן, חיפה והקריות, מודיעין עילית. טלפון השיקום 073-3952222. מטה: הרב רבינוב 5, בני ברק. קו הייעוץ ידידי נפש (1-800-30-30-12) נשאר בכרטיס 26. בלב ובנפש נשאר בכרטיס 68. מספרי התרומות בפוטר לא נוספו. לא הוצמד מיקום למפה — הכתובת היא מטה, והשירותים פרוסים באזורים."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

COMMIT;
