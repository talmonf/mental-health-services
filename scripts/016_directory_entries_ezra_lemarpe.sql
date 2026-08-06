-- Migration 016 (Aug 2026)
-- directory_entries: עזרה למרפא (row 246)
-- Free ambulance services nationwide — https://www.ezra-lemarpe.org/ambulances/
-- entry_id slug matches generate_directory_entries_sql.js.

BEGIN;

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
) VALUES
  (
    'עזרה_למרפא_246',
    'עזרה למרפא',
    'שירותי אמבולנס להסעת חולים, נכים ומוגבלים לטיפולים, בדיקות ואירועים משפחתיים',
    'transport',
    ARRAY['transport']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

COMMIT;
