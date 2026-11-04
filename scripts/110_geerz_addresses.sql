-- Migration 110 (2 Nov 2026)
-- גירז: official office on both cards. Youth (770) is that pin only.
-- Veterans (771) also lists the areas that were named, without street addresses.
-- Office pin: OSM building Nahal Mata 14, Beit Shemesh (way 583201589).
-- Area pins are the mapped place, not a street. גוש טלמונים is pinned at טלמון.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = jsonb_set(
      public_fields,
      '{notes}',
      to_jsonb(replace(
        public_fields->>'notes',
        'משרד: נחל מטה 14/2, בית שמש, ואינו נקודת המפגש.',
        'המשרד אינו נקודת המפגש.'
      ))
    ),
    sites = '[
      {"label":"בית שמש","address":"נחל מטה 14/2, בית שמש 9963215","lat":31.711288,"lng":34.9982753,"phone":"","email":"","note":"","sort_order":0}
    ]'::jsonb,
    eligibility = jsonb_set(
      COALESCE(eligibility, '{}'::jsonb),
      '{internal_notes}',
      to_jsonb(
        rtrim(COALESCE(eligibility->>'internal_notes', ''))
        || E'\n\n02.11.2026: כתובת המשרד נחל מטה 14/2, בית שמש 9963215. סיכה אחת. המשרד אינו נקודת המפגש של הקבוצות.'
      )
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '770|||רכיבת הרים טיפולית לילדים ונוער, גילאי 7–16';

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'בית שמש, מעלה אדומים, גוש עציון, אבן שמואל, גוש טלמונים, חוף הכרמל, מועצה אזורית שומרון'
    ),
    sites = '[
      {"label":"בית שמש","address":"נחל מטה 14/2, בית שמש 9963215","lat":31.711288,"lng":34.9982753,"phone":"","email":"","note":"","sort_order":0},
      {"label":"מעלה אדומים","address":"מעלה אדומים","lat":31.7706181,"lng":35.2984501,"phone":"","email":"","note":"","sort_order":1},
      {"label":"גוש עציון","address":"גוש עציון","lat":31.689983,"lng":35.2298049,"phone":"","email":"","note":"","sort_order":2},
      {"label":"אבן שמואל","address":"אבן שמואל","lat":31.5748942,"lng":34.7643312,"phone":"","email":"","note":"","sort_order":3},
      {"label":"גוש טלמונים","address":"גוש טלמונים","lat":31.9393963,"lng":35.1323035,"phone":"","email":"","note":"","sort_order":4},
      {"label":"חוף הכרמל","address":"חוף הכרמל","lat":32.6239104,"lng":34.9853969,"phone":"","email":"","note":"","sort_order":5},
      {"label":"מועצה אזורית שומרון","address":"מועצה אזורית שומרון","lat":32.4207007,"lng":35.1722266,"phone":"","email":"","note":"","sort_order":6}
    ]'::jsonb,
    eligibility = jsonb_set(
      COALESCE(eligibility, '{}'::jsonb),
      '{internal_notes}',
      to_jsonb(
        rtrim(COALESCE(eligibility->>'internal_notes', ''))
        || E'\n\n02.11.2026: משרד בנחל מטה 14/2, בית שמש, ועוד שישה אזורים בלי כתובת רחוב: מעלה אדומים, גוש עציון, אבן שמואל, גוש טלמונים (הסיכה בטלמון), חוף הכרמל, מועצה אזורית שומרון.'
      )
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '771|||רכיבת הרים טיפולית ללוחמים ומילואימניקים';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c
JOIN (
  VALUES
    (770, 'בית שמש', 'נחל מטה 14/2, בית שמש 9963215', 31.711288::float8, 34.9982753::float8, 0),
    (771, 'בית שמש', 'נחל מטה 14/2, בית שמש 9963215', 31.711288::float8, 34.9982753::float8, 0),
    (771, 'מעלה אדומים', 'מעלה אדומים', 31.7706181::float8, 35.2984501::float8, 1),
    (771, 'גוש עציון', 'גוש עציון', 31.689983::float8, 35.2298049::float8, 2),
    (771, 'אבן שמואל', 'אבן שמואל', 31.5748942::float8, 34.7643312::float8, 3),
    (771, 'גוש טלמונים', 'גוש טלמונים', 31.9393963::float8, 35.1323035::float8, 4),
    (771, 'חוף הכרמל', 'חוף הכרמל', 32.6239104::float8, 34.9853969::float8, 5),
    (771, 'מועצה אזורית שומרון', 'מועצה אזורית שומרון', 32.4207007::float8, 35.1722266::float8, 6)
) AS v(row_id, label, address, lat, lng, sort_order)
  ON v.row_id = c.row_id
WHERE c.card_key IN (
  '770|||רכיבת הרים טיפולית לילדים ונוער, גילאי 7–16',
  '771|||רכיבת הרים טיפולית ללוחמים ומילואימניקים'
)
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-02-geerz-address',
  DATE '2026-11-02',
  'נוספה כתובת לכרטיסי גירז',
  'בשני הכרטיסים מופיעה כתובת המשרד, נחל מטה 14/2 בבית שמש. בכרטיס הנוער זו נקודת המפה היחידה, והמשרד אינו נקודת המפגש. בכרטיס הלוחמים המפה כוללת גם את מעלה אדומים, גוש עציון, אבן שמואל, גוש טלמונים, חוף הכרמל ומועצה אזורית שומרון.',
  'cards',
  ARRAY[
    '770|||רכיבת הרים טיפולית לילדים ונוער, גילאי 7–16',
    '771|||רכיבת הרים טיפולית ללוחמים ומילואימניקים'
  ],
  '{}',
  '110_geerz_addresses.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
