-- Migration 013 (Aug 2026)
-- directory_entries: סל שיקום / salshikum.org (row 244)
-- Portal for rehab-basket rights, providers, and family guidance.
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
    'סל_שיקום_244',
    'סל שיקום',
    'מידע, זכויות ואיתור ספקי שירות בסל שיקום',
    'rehabilitation',
    ARRAY['rehabilitation', 'rights', 'moh', 'portals']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

COMMIT;
