-- Migration 006 (May 2026)
-- directory_entries: ענת רוסמן (row 208) — families category
-- entry_id slug matches generate_directory_entries_sql.js.

BEGIN;

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
) VALUES
  ('ענת_רוסמן_208', 'ענת רוסמן', 'מנחה ומלווה משפחות למתמודדי נפש', 'families', ARRAY['families']::text[])
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

COMMIT;
