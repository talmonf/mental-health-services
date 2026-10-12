-- Migration 052 (12 Oct 2026)
-- directory_entries + directory_card_edits: עמותת גוונים, row 296.
-- Psychiatric tracks only: דיור הד (סל שיקום, 18–28), protected housing,
-- and Ashkelon employment for a psychiatric disability.
-- Listed under rehabilitation + youth. Other disability programs stay off the card.
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
  'עמותת_גוונים_296',
  'עמותת גוונים',
  'דיור ותעסוקה לצעירים עם מגבלה נפשית — כולל זכאי סל שיקום',
  'rehabilitation',
  ARRAY['rehabilitation', 'youth']::text[],
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
  '296|||דיור ותעסוקה לצעירים עם מגבלה נפשית — כולל זכאי סל שיקום',
  296,
  'עמותת_גוונים_296',
  '{"org":"עמותת גוונים","svc":"דיור ותעסוקה לצעירים עם מגבלה נפשית — כולל זכאי סל שיקום","target":"צעירים עם מגבלה נפשית. דיור ״הד״: גילאי 18–28, זכאי סל שיקום","region":"דיור הד: לוד, יוקנעם, עפולה, שדרות, טירת כרמל. תעסוקה ודיור מוגן נפשי: אשקלון, קריית מלאכי והסביבה","cost":"","specialty":"","languages":"","diseases":"","notes":"מוקד *9913. דיור ״הד״ לזכאי סל שיקום, שנה עד 5 שנים. מרכז התעסוקה ו״גוונים בקפה״ באשקלון מיועדים למגבלה נפשית. לעמותה גם תכניות נפרדות למוגבלות פיזית, חושית, שכלית-התפתחותית ואוטיזם. מטה: הרקפת 6, שדרות.","tags":"","whatsapp":"972546689104","whatsappLabel":"וואטסאפ","email":"","web":"https://www.gvanim.org.il/","webLabel":"","web2":"","webLabel2":"","add":"https://www.facebook.com/youngvanim/","addLabel":"פייסבוק","phone":"*9913","phoneLabel":"מוקד","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"נבדק 12.10.2026 מול gvanim.org.il. דיור הד: גילאי 18–28 שעברו משבר נפשי, זכאי סל שיקום, שנה עד 5 שנים, בלוד, יוקנעם, עפולה, שדרות וטירת כרמל. דיור מוגן לבודדים: מגבלה נפשית, אשקלון, קריית מלאכי והסביבה. מרכז תעסוקה וגוונים בקפה באשקלון: מגבלה נפשית בלבד. שאר תכניות הדיור (כנפיים, דרור, בית לחיים, דיור נתמך) הן למוגבלות פיזית, חושית, אוטיזם או שכלית-התפתחותית, ולכן לא תוארו כשירות הכרטיס. וואטסאפ 054-668-9104 ופייסבוק youngvanim נמסרו עם הבקשה להוספה; דפי התכניות שאומתו מפרסמים את מוקד *9913. מטה: הרקפת 6, שדרות. לא הוצמד מיקום למפה — הקואורדינטה הציבורית היא של הרחוב, לא של הבניין."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

COMMIT;
