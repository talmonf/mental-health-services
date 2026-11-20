-- Migration 141 (20 Nov 2026)
-- מנוע הזכויות הלאומי (row 786): the government benefits site.
-- One card, under מיצוי זכויות.
-- Hebrew heading and document title: מנוע הזכויות הלאומי.
-- Arabic site title: محرك الحقوق.
-- The language menu offers Hebrew and Arabic only. The card is Hebrew only
-- (locales he). No English translation of the card.
-- Header phone: 1299, labeled
-- למענה ממשלתי מרכזי. No address, so no pin.
-- Audit wording approved with the plan on 20.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'mybenefits_786',
  'מנוע הזכויות הלאומי',
  'אתר ממשלתי לאיתור זכויות. שאלון אנונימי באתר, ואחר כך הסבר איך לממש כל זכות.',
  'rights',
  ARRAY['rights']::text[],
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
  '786|||אתר ממשלתי לאיתור זכויות. שאלון אנונימי באתר, ואחר כך הסבר איך לממש כל זכות.',
  786,
  'mybenefits_786',
  $card786${"org":"מנוע הזכויות הלאומי","svc":"אתר ממשלתי לאיתור זכויות. שאלון אנונימי באתר, ואחר כך הסבר איך לממש כל זכות.","target":"תושבי ישראל","region":"כל הארץ","cost":"חינם","specialty":"","languages":"עברית, ערבית","diseases":"","notes":"התשובות לא נשמרות באתר. לכל זכות מופיעה רמת סבירות, והגוף שנותן את הזכות הוא שמחליט. שונה מ[כל זכות](https://nefesh-il.org/rights?entry=85&section=rights).","tags":"","whatsapp":"","whatsappLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://mybenefits.gov.il/he/home","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","add2":"","addLabel2":"","add3":"","addLabel3":"","phone":"1299","phoneLabel":"טלפון","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true,"founded":"","approaches":"","meeting":""}$card786$::jsonb,
  $elig786${"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"20.11.2026: נבדק מול https://mybenefits.gov.il/he/home ו-https://mybenefits.gov.il/ar/home , והתרגומים ב-https://mybenefits.gov.il/api/Storage/translations/he ו-/ar . כותרת המסמך בעברית והכותרת בדף: מנוע הזכויות הלאומי. בקבצי התרגום SiteTitle הקצר הוא מנוע הזכויות, בערבית محرك الحقوق. תפריט השפה מציע רק עברית וערבית: שני כפתורים, he ו-ar. אין גרסה אנגלית לכרטיס. השאלון אנונימי, לפי AnonymousComment. לכל זכות יש הסבירות לזכאות (גבוהה, נמוכה, או חסר מידע) וקישור למימוש הזכות. אין כתובת ואין סיכה. meeting ריק: זה שאלון באתר, לא מפגש. טלפון בכותרת: tel:1299, והתווית למענה ממשלתי מרכזי. כפתור אחד, בלי המספר על הכפתור."}$elig786$::jsonb,
  '[]'::jsonb,
  $ind786${"offers":["info"],"whole_org":true,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"נכנסים לאתר ועונים על השאלון. אין הפניה.","ownership":"government","app":""}$ind786$::jsonb,
  '{}'::jsonb,
  '{"he":{"web":"https://mybenefits.gov.il/he/home"},"ar":{"web":"https://mybenefits.gov.il/ar/home"}}'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-20-mybenefits',
  DATE '2026-11-20',
  'נוסף מנוע הזכויות הלאומי',
  'אתר ממשלתי שמאתר זכויות לפי שאלון אנונימי, ומסביר איך לממש אותן. הכרטיס במיצוי זכויות. חינם, לכל הארץ.',
  'cards',
  ARRAY['786|||אתר ממשלתי לאיתור זכויות. שאלון אנונימי באתר, ואחר כך הסבר איך לממש כל זכות.'],
  '{}',
  '141_mybenefits.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
