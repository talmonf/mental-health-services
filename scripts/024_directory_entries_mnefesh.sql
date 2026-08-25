-- Migration 024 (25 Aug 2026)
-- directory_entries: מעגלי נפש (row 276) — rabbinic/halachic support, not a clinic.
-- Listed under populations + families.
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
    'מעגלי_נפש_276',
    'מעגלי נפש',
    'ייעוץ הלכתי ורוחני למתמודדים ולבני משפחה — רבנים ורבניות שעברו הכשרה בבריאות הנפש (לא טיפול קליני)',
    'populations',
    ARRAY['populations', 'families']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

COMMIT;
