-- Migration 033 (8 Sep 2026)
-- directory_entries: לב השרון (row 235) — UI-only: clear notes, hide phone number on the button.
-- Live card in index.html; core DB fields unchanged.
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
    'לב_השרון_235',
    'לב השרון',
    'טיפול ממוקד בטראומה לשורדי מסיבות — מרכז רפואי + מסיבות בדרום',
    'trauma',
    ARRAY['trauma']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

COMMIT;
