-- Migration 101 (19 Oct 2026)
-- Hide the open-data portal card (row 356) without deleting it or its contact.
-- hidden = true keeps the row in the admin list and off the public site.
-- Audit wording approved with the plan on 19.10.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

ALTER TABLE directory_card_edits
  ADD COLUMN IF NOT EXISTS hidden boolean NOT NULL DEFAULT false;

COMMENT ON COLUMN directory_card_edits.hidden IS
  'When true, the card stays in the admin list and keeps its contacts, but visitors do not see it and links to it are not shown.';

UPDATE directory_card_edits
   SET hidden = true,
       updated_at = now()
 WHERE card_key = '356|||מאגרי נתונים פתוחים על בריאות הנפש בישראל';

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-10-19-hide-open-mental-health-data-portal',
  DATE '2026-10-19',
  'הפורטל של הסדנא לידע ציבורי הוסתר',
  'הכרטיס של פורטל המידע הפתוח לבריאות הנפש לא מוצג באתר כרגע. הפרטים ואיש הקשר נשארים, ואפשר להחזיר את הכרטיס ממסך הכרטיס.',
  'cards',
  ARRAY['356|||מאגרי נתונים פתוחים על בריאות הנפש בישראל'],
  '{}',
  '101_hide_datacity_portal.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
