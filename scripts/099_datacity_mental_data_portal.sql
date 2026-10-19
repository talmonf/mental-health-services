-- Migration 099 (19 Oct 2026)
-- פורטל מידע פתוח — בריאות נפשית (row 356): https://mental-data.datacity.org.il/
-- Open-data portal of הסדנא לידע ציבורי, listed under portals.
-- Audit wording approved with the plan on 19.10.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'פורטל_מידע_פתוח_בריאות_נפשית_356',
  'פורטל מידע פתוח — בריאות נפשית',
  'מאגרי נתונים פתוחים על בריאות הנפש בישראל',
  'portals',
  ARRAY['portals']::text[],
  ARRAY['unknown']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '356|||מאגרי נתונים פתוחים על בריאות הנפש בישראל',
  356,
  'פורטל_מידע_פתוח_בריאות_נפשית_356',
  '{"org":"פורטל מידע פתוח — בריאות נפשית","svc":"מאגרי נתונים פתוחים על בריאות הנפש בישראל","target":"","region":"כל הארץ","cost":"חינם","specialty":"","languages":"","diseases":"","notes":"אתר של הסדנא לידע ציבורי, בתמיכת רשות החדשנות. אפשר לחפש ולהוריד קבצי נתונים על בריאות הנפש, רווחה ומדיניות. אינו שירות טיפולי ואינו קו סיוע.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://mental-data.datacity.org.il/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"19.10.2026: נבדק מול https://mental-data.datacity.org.il/ . פורטל מידע פתוח, בלי כתובת ובלי סיכה."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-10-19-open-mental-health-data-portal',
  DATE '2026-10-19',
  'פורטל מידע פתוח לבריאות הנפש',
  'נוסף כרטיס לפורטל המידע הפתוח של הסדנא לידע ציבורי, עם מאגרי נתונים על בריאות הנפש.',
  'cards',
  ARRAY['356|||מאגרי נתונים פתוחים על בריאות הנפש בישראל'],
  '{}',
  '099_datacity_mental_data_portal.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
