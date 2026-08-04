-- Migration 012 (August 2026)
-- חבלי קשר (row 92): reaffirm entry; website URLs live only in index.html
-- - hevleikesher.org EN + HE links commented out while that site is down
-- - Jerusalem municipality Hebrew page set as `add` (kept after restore)

BEGIN;

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
) VALUES
  (
    'חבלי_קשר_hevlei_kesher_92',
    'חבלי קשר - Hevlei Kesher',
    'דיכאון אחרי לידה ועוד, דרך טיפת חלב בירושלים
Support and treatment for Maternal Mental Health through Tipat Halav. Services for mothers and families impacted by perinatal mental health disorders (PMHD) such as postpartum depression',
    'local',
    ARRAY['local']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

COMMIT;
