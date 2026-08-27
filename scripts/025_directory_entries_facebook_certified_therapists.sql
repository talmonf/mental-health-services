-- Migration 025 (27 Aug 2026)
-- directory_entries: מתייעצים עם מטפלים מוסמכים (row 277) — public Facebook consultation group.
-- Listed under facebook only.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
) VALUES
  (
    'מתייעצים_עם_מטפלים_מוסמכים_277',
    'מתייעצים עם מטפלים מוסמכים',
    'קבוצה בפייסבוק',
    'facebook',
    ARRAY['facebook']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

COMMIT;
