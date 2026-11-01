-- Migration 105 (1 Nov 2026)
-- אור לב: קבוצת תמיכה למתמודדים עם OCD (row 773, טיפול רגשי)
-- וקבוצת תמיכה להורים לילדים ולבני נוער עם OCD (row 774, תמיכה למשפחות).
-- המפגשים בזום. אין סיכות.
-- Audit wording approved on 01.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'אור_לב_773',
  'אור לב',
  'קבוצת תמיכה למתמודדים עם OCD',
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

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '773|||קבוצת תמיכה למתמודדים עם OCD',
  773,
  'אור_לב_773',
  $card773${"org":"אור לב","svc":"קבוצת תמיכה למתמודדים עם OCD","target":"מבוגרים מגיל 18 שמתמודדים עם OCD","region":"אונליין","cost":"400 ₪ לחודש, לארבעה מפגשים, בלי התחייבות","specialty":"OCD","languages":"עברית","diseases":"","notes":"ימי רביעי ב-20:00, מפגש זום של 60 דקות, בקבוצה קטנה. מנחה אור לב, מתמודדת עם OCD מגיל 8 ומחברת הספר להילחם ב-OCD (2020). אין חובה לדבר, והמפגשים אינם מוקלטים. הקבוצה רציפה, ומצטרפים פעם בחודש לפני מחזור חדש. זו קבוצת תמיכה, לא טיפול נפשי. אור גם מרצה על OCD ומציעה מפגש אישי. קבוצה להורים: [הורים למתמודדים עם OCD](https://nefesh-il.org/support?entry=774&section=families).","tags":"","whatsapp":"972552629976","whatsappLabel":"","email":"Or.lev.books@gmail.com","emailLabel":"פניות","emailShowAddress":true,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://fighting-ocd.com/ocdgroup/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"055-262-9976","phoneLabel":"וואטסאפ","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}$card773$::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"01.11.2026: נבדק מול https://fighting-ocd.com/ocdgroup/ , https://fighting-ocd.com/contact/ ו-https://fighting-ocd.com/terms2/ . אין סיכה: המפגשים בזום."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'אור_לב_774',
  'אור לב',
  'קבוצת תמיכה להורים למתמודדים עם OCD',
  'families',
  ARRAY['families']::text[],
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
  '774|||קבוצת תמיכה להורים למתמודדים עם OCD',
  774,
  'אור_לב_774',
  $card774${"org":"אור לב","svc":"קבוצת תמיכה להורים למתמודדים עם OCD","target":"הורים לילדים ולבני נוער עם OCD","region":"אונליין","cost":"500 ₪ למחזור של 4 מפגשים, בלי התחייבות להמשך","specialty":"OCD","languages":"עברית","diseases":"","notes":"ימי ראשון ב-20:00, מפגש זום של שעה עד שעה וחצי, עד 10 משתתפים. מחזור של 4 מפגשים, וההצטרפות בתחילת כל מחזור. המחיר להורה אחד. המפגשים אינם מוקלטים. זו קבוצת תמיכה והדרכה להורים לילדים ולבני נוער, לא טיפול לילד. מנחה אור לב, מתמודדת עם OCD מגיל 8. קבוצה למבוגרים: [מתמודדים עם OCD](https://nefesh-il.org/treatment?entry=773&section=treatments).","tags":"","whatsapp":"972552629976","whatsappLabel":"","email":"Or.lev.books@gmail.com","emailLabel":"פניות","emailShowAddress":true,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://fighting-ocd.com/pereants-sec/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"055-262-9976","phoneLabel":"וואטסאפ","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}$card774$::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"01.11.2026: נבדק מול https://fighting-ocd.com/pereants-sec/ ו-https://fighting-ocd.com/contact/ . אין סיכה: המפגשים בזום. הקהל בדף הוא הורים לילדים ולבני נוער, לא לכל בני המשפחה."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-01-or-lev-ocd-groups',
  DATE '2026-11-01',
  'נוספו שתי קבוצות תמיכה של אור לב',
  'אור לב מנחה שתי קבוצות זום בנושא OCD. קבוצה למבוגרים שמתמודדים עם OCD, תחת טיפול רגשי, וקבוצה להורים לילדים ולבני נוער עם OCD, תחת תמיכה למשפחות.',
  'cards',
  ARRAY[
    '773|||קבוצת תמיכה למתמודדים עם OCD',
    '774|||קבוצת תמיכה להורים למתמודדים עם OCD'
  ],
  '{}',
  '105_or_lev_ocd_groups.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
