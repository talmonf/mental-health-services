-- Migration 008 (May 2026)
-- directory_entries: חרבות ברזל booklet (row 209) — remove helplines from category_keys
-- Run after 007; aligns DB with Phase 1 UI (emergency + trauma only).

BEGIN;

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
) VALUES
  (
    'חרבות_ברזל_209',
    'חרבות ברזל',
    'חוברת מענים פסיכוסוציאליים — מדריך מרוכז למלחמת חרבות ברזל (PDF להורדה)',
    'trauma',
    ARRAY['trauma', 'emergency']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  category_keys = EXCLUDED.category_keys;

COMMIT;
