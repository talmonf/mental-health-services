-- Migration 007 (May 2026)
-- directory_entries: חרבות ברזל — booklet card (row 209)
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
    'חרבות_ברזל_209',
    'חרבות ברזל',
    'חוברת מענים פסיכוסוציאליים — מדריך מרוכז למלחמת חרבות ברזל (PDF להורדה)',
    'trauma',
    ARRAY['trauma', 'emergency', 'helplines']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

COMMIT;
