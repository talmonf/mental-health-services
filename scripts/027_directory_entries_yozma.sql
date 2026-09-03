-- Migration 027 (3 Sep 2026)
-- directory_entries: יוזמה דרך הלב (row 283) — vocational rehab / supported employment.
-- Listed under rehabilitation + moh (סל שיקום provider).
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
    'יוזמה_דרך_הלב_283',
    'יוזמה דרך הלב',
    'שיקום תעסוקתי, תעסוקה נתמכת ויזמות — כולל תוכנית צרכנים נותני שירות',
    'rehabilitation',
    ARRAY['rehabilitation', 'moh']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
VALUES
  (283, 'יוזמה_דרך_הלב_283', 'באר שבע', 'רמב"ם 4, באר שבע', 31.243457, 34.790211, 0),
  (283, 'יוזמה_דרך_הלב_283', 'כפר סבא', 'תע"ש 20, אזור התעשייה, כפר סבא', 32.17611, 34.927626, 1)
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

COMMIT;
