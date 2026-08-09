-- Migration 018 (Aug 2026)
-- directory_entries: עמותת נוה מלכישוע (row 254)
-- Therapeutic village / addiction rehab — https://malkishua.org.il/
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
    'עמותת_נוה_מלכישוע_254',
    'עמותת נוה מלכישוע',
    'כפר ומרכז לטיפול בהתמכרויות — גמילה פיזית, קהילות טיפוליות לנוער/צעירים/בגירים/נשים; בפיקוח משרדי הרווחה והבריאות',
    'addictions',
    ARRAY['addictions']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

COMMIT;
