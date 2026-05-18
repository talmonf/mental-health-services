-- Migration 005 (May 2026)
-- directory_entries: משפחות בריאות הנפש (row 207) — families category
-- entry_id slug matches generate_directory_entries_sql.js.

BEGIN;

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
) VALUES
  ('משפחות_בריאות_הנפש_207', 'משפחות בריאות הנפש', 'עמותת בני ובנות משפחה של מתמודדי/ות נפש בישראל. מטרת העמותה היא לפעול למען המתמודדים ולמען משפחותיהם למימוש ולהרחבת זכויות, לטיפול מיטבי, להכלה ולשיקום בקהילה ולהסברה בקרב מקבלי החלטות, בקרב הממסד ובקרב הציבור.', 'families', ARRAY['families']::text[])
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

COMMIT;
