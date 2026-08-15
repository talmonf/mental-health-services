-- Migration 019 (Aug 2026)
-- directory_entries: מפה לנפש (row 255)
-- Geographic directory of mental-health responses — https://mapalanefesh.org.il/
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
    'מפה_לנפש_255',
    'מפה לנפש',
    'מפה ומאגר מענים טיפוליים ונפשיים בישראל — ילדים, נוער ומבוגרים',
    'portals',
    ARRAY['portals', 'youth']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

COMMIT;
