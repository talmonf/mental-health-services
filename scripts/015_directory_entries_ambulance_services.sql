-- Migration 015 (Aug 2026)
-- directory_entries: רפואה ושמחה (row 245) + update עזר מציון הסעות (row 83)
-- Free ambulance services — booking notes and ambulance-specific link.
-- entry_id slugs match generate_directory_entries_sql.js.

BEGIN;

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
) VALUES
  (
    'רפואה_ושמחה_245',
    'רפואה ושמחה',
    'שירותי אמבולנס ללא תשלום להסעת חולים, נכים ומוגבלים לטיפולים, בדיקות ושמחות',
    'transport',
    ARRAY['transport']::text[]
  ),
  (
    'עזר_מציון_הסעות_83',
    'עזר מציון הסעות',
    'הסעות חולים, אמבולנסים לצרכים רפואיים ואירועים משפחתיים, נהגים מתנדבים',
    'transport',
    ARRAY['transport']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

COMMIT;
