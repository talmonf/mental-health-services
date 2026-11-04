-- Migration 111 (4 Nov 2026)
-- Jerusalem Therapy Center (row 775): counseling in English for adults.
-- Shown under אוכלוסיות מיוחדות and under טיפול רגשי.
-- One pin: Ha-Nevi'im St 55, Jerusalem (OSM node 2830392760).
-- Audit wording approved on 04.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'jerusalem_therapy_center_775',
  'Jerusalem Therapy Center',
  'Counseling in English for adults in Jerusalem',
  'populations',
  ARRAY['populations', 'treatments']::text[],
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
  '775|||Counseling in English for adults in Jerusalem',
  775,
  'jerusalem_therapy_center_775',
  $card775${"org":"Jerusalem Therapy Center","svc":"Counseling in English for adults in Jerusalem","target":"English-speaking adults, including gap-year students, new olim and lone soldiers. Ages 16–17 only with signed parental consent.","region":"Jerusalem and the surrounding area","cost":"150 NIS a session. A sliding scale in some cases. Psychiatry: intake 500 NIS, follow-up 300 NIS, no sliding scale. Not through a health fund or US insurance.","specialty":"","languages":"English","diseases":"","notes":"Multidisciplinary counseling in English. A project of Amudim Israel and Yeshiva University's Wurzweiler School of Social Work. Intake first; the clinic assigns the therapist. A psychiatrist sees existing clients only. No reports for courts, Bituach Leumi, or other official offices. Case management stays on [Amudim](https://nefesh-il.org/support?entry=80&section=populations).","tags":"","whatsapp":"97223803060","whatsappLabel":"","email":"office@jtc.org.il","emailLabel":"Email","emailShowAddress":true,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://jtc.org.il/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"02-380-3060","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}$card775$::jsonb,
  '{"age_min":16,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"04.11.2026: נבדק מול https://jtc.org.il/ , https://jtc.org.il/about/ ו-https://jtc.org.il/faq/ . סיכה: הנביאים 55, ירושלים (OSM node 2830392760). וואטסאפ באתר עם 0 מיותר (972023803060); נשמר 97223803060."}'::jsonb,
  '[{"label":"Jerusalem","address":"Ha-Nevi''im St 55, Jerusalem","lat":31.7844535,"lng":35.2181757,"phone":"","email":"","note":"","sort_order":0}]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c
JOIN (
  VALUES
    (775, 'Jerusalem', 'Ha-Nevi''im St 55, Jerusalem', 31.7844535::float8, 35.2181757::float8, 0)
) AS v(row_id, label, address, lat, lng, sort_order)
  ON v.row_id = c.row_id
WHERE c.card_key = '775|||Counseling in English for adults in Jerusalem'
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-04-jerusalem-therapy-center',
  DATE '2026-11-04',
  'נוסף כרטיס של Jerusalem Therapy Center',
  'מרכז טיפול באנגלית למבוגרים בירושלים והסביבה, ברחוב הנביאים 55. הכרטיס מופיע תחת אוכלוסיות מיוחדות וגם תחת טיפול רגשי, עם טלפון, וואטסאפ, אימייל ומפה.',
  'cards',
  ARRAY['775|||Counseling in English for adults in Jerusalem'],
  '{}',
  '111_jerusalem_therapy_center.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
