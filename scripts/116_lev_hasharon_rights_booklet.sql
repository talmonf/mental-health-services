-- Migration 116 (5 Nov 2026)
-- Rights booklet by Michal Yom Tov (row 776), first under מיצוי זכויות.
-- Download: /downloads/חוברת-זכויות-לב-השרון.pdf
-- The PDF is the November 2022 edition. The card says it is not advice and that details may have changed.
-- Audit wording approved with the plan on 05.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'lev_hasharon_rights_booklet_776',
  'המרכז לבריאות הנפש לב השרון',
  'חוברת זכויות בריאות הנפש',
  'rights',
  ARRAY['rights']::text[],
  ARRAY['unknown']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (
  card_key, row_id, entry_id, public_fields, eligibility, sites, indicators, translations
)
VALUES (
  '776|||חוברת זכויות בריאות הנפש',
  776,
  'lev_hasharon_rights_booklet_776',
  $card776${"org":"המרכז לבריאות הנפש לב השרון","svc":"חוברת זכויות בריאות הנפש","target":"מתמודדים, בני משפחה, ואנשי צוות שמלווים אותם","region":"כל הארץ","cost":"חינם","specialty":"","languages":"עברית","diseases":"","notes":"נכתבה בנובמבר 2022 על ידי מיכל יום טוב, עובדת סוציאלית קלינית. מרכזת זכויות בביטוח לאומי, בסל שיקום, בדיור, בתעסוקה, בהשכלה, בטיפול נפשי, באשפוז ובאפוטרופסות. החומר נאסף ממקורות שונים ואינו כולל את כל האפשרויות. אינו ייעוץ רפואי או משפטי, וייתכן שחלק מהפרטים השתנו. יש לאמת מול הגורם עצמו.","tags":"","whatsapp":"","whatsappLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://www.lev-hasharon.co.il/?page_id=4338","webLabel":"העמוד באתר לב השרון","web2":"","webLabel2":"","add":"/downloads/חוברת-זכויות-לב-השרון.pdf","addLabel":"הורדת החוברת (PDF)","add2":"","addLabel2":"","add3":"","addLabel3":"","phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}$card776$::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"05.11.2026: חוברת זכויות מנובמבר 2022, מאת מיכל יום טוב. באישורה להורדה. אין כתובת ואין סיכה."}'::jsonb,
  '[]'::jsonb,
  '{"offers":["info"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":[],"referral_source":""}'::jsonb,
  $en776${"en":{"org":"Lev Hasharon Mental Health Center","svc":"Mental-health rights booklet (Hebrew)","target":"People in care, family members, and staff who support them","region":"Nationwide","cost":"Free","languages":"Hebrew","notes":"Written in November 2022 by Michal Yom Tov, a clinical social worker. The PDF is in Hebrew. It was compiled from several sources and does not list every option. It is not medical or legal advice, and some details may have changed. Check with the relevant office.","webLabel":"Lev HaSharon page","addLabel":"Download the booklet (PDF)"}}$en776$::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-05-lev-hasharon-rights-booklet',
  DATE '2026-11-05',
  'נוספה חוברת זכויות להורדה',
  'תחת זכויות ושירותים ממשלתיים, במיצוי זכויות, אפשר להוריד את חוברת הזכויות שכתבה מיכל יום טוב מהמרכז לבריאות הנפש לב השרון. בכרטיס כתוב שהחוברת מנובמבר 2022, שאינה ייעוץ רפואי או משפטי, ושכדאי לבדוק פרטים מול הגורם עצמו.',
  'cards',
  ARRAY['776|||חוברת זכויות בריאות הנפש'],
  '{}',
  '116_lev_hasharon_rights_booklet.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
