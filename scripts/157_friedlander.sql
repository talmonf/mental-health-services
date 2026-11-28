-- Migration 157 (27 Nov 2026)
-- רחל פרידלנדר (row 790): psychotherapy for pre- and perinatal trauma.
-- One card, under טיפולים → טיפול רגשי and טראומה.
-- The site name is רחל פרידלנדר. The Birth of Healing is only the domain.
-- No city, street, clinic or Zoom, fee, or founding year, so no pin.
-- 156_local_populations_wording.sql was already registered, so this is 157.
-- Audit wording approved with the plan on 27.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'רחל_פרידלנדר_790',
  'מטפלת בטראומה סביב הלידה',
  'רחל פרידלנדר',
  'treatments',
  ARRAY['treatments', 'trauma']::text[],
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
  '790|||רחל פרידלנדר',
  790,
  'רחל_פרידלנדר_790',
  $card790${"org":"מטפלת בטראומה סביב הלידה","svc":"רחל פרידלנדר","target":"נשים, אמהות ותינוקות אחרי לידה, והורים","region":"","founded":"","meeting":"","cost":"","specialty":"טראומה סביב הלידה, טראומה התפתחותית, חרדה, דיכאון, אבל ואובדן, טראומה אחרי הליך רפואי","approaches":"CBT, Somatic Experiencing, טיפול במגע לילודים ולתינוקות","languages":"","diseases":"","notes":"עובדת סוציאלית קלינית. המפגש יכול לכלול גם את המשפחה, התינוק או הילד.","tags":"","whatsapp":"972544490957","whatsappLabel":"וואטסאפ","email":"rach_fried@yahoo.com","emailLabel":"אימייל","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://www.thebirthofhealing.com/he/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","add2":"","addLabel2":"","add3":"","addLabel3":"","phone":"054-4490957","phoneLabel":"טלפון","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"phone4":"","phoneLabel4":"","phoneShowNumber4":false,"phone5":"","phoneLabel5":"","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":false}$card790$::jsonb,
  $elig790${"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":["טראומה סביב הלידה","טראומה התפתחותית","חרדה","דיכאון","אבל ואובדן","טראומה אחרי הליך רפואי"],"presenting_problems":["טראומה סביב הלידה","טראומה התפתחותית","חרדה","דיכאון","אבל ואובדן","טראומה אחרי הליך רפואי"],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"27.11.2026: נבדק מול https://www.thebirthofhealing.com/ , https://www.thebirthofhealing.com/he/ ו-https://www.thebirthofhealing.com/en/ . 28.11.2026: הכותרת היא מטפלת בטראומה סביב הלידה, והתיאור הוא רחל פרידלנדר. באנגלית הכותרת היא Pre & Perinatal trauma therapist, והתיאור Rachael Friedlander. במה מטפלים נפתח בטראומה סביב הלידה. The Birth of Healing הוא רק הדומיין. אין עיר, אין רחוב, אין מרפאה או זום, אין עלות, אין שנת הקמה, ואין שפת מפגש, ולכן אלה ריקים ואין סיכה. אין פסיכיאטריה. תארי MA, MBA, MSW, SEP, המרכז הישראלי לטיפול בפסיכוטראומה וד״ר ג׳ונתן אוונס לא על הכרטיס. הטלפון באתר מוצג כ-+972 54 4490957, הקישור הוא tel:+972544490957, ובכרטיס 054-4490957. הוואטסאפ הוא https://wa.me/972544490957. 27.11.2026: נוסח היומן אושר עם התוכנית."}$elig790$::jsonb,
  '[]'::jsonb,
  $ind790${"offers":["care"],"whole_org":true,"funding":[],"referral":["self_referral"],"referral_source":"פנייה בטלפון, באימייל או בוואטסאפ.","ownership":"private","app":""}$ind790$::jsonb,
  $en790${"en":{"org":"Pre & Perinatal trauma therapist","svc":"Rachael Friedlander","target":"Women, mothers and babies after birth, and parents","region":"","cost":"","specialty":"Pre- and perinatal trauma, developmental trauma, anxiety, depression, grief and loss, trauma after a medical procedure","languages":"","notes":"A licensed clinical social worker. A session can also include the family, the baby, or the child.","approaches":"CBT, Somatic Experiencing, and touch therapy for newborns and infants","phoneLabel":"Phone","emailLabel":"Email","whatsappLabel":"WhatsApp","web":"https://www.thebirthofhealing.com/en/"}}$en790$::jsonb,
  '{"he":{"web":"https://www.thebirthofhealing.com/he/"},"en":{"web":"https://www.thebirthofhealing.com/en/"}}'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-27-friedlander',
  DATE '2026-11-27',
  'נוסף כרטיס לרחל פרידלנדר',
  'מטפלת בטראומה סביב הלידה. רחל פרידלנדר. הכרטיס בטיפול רגשי ובטראומה.',
  'cards',
  ARRAY['790|||רחל פרידלנדר'],
  '{}',
  '157_friedlander.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
