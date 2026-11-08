-- Migration 125 (8 Nov 2026)
-- Audit log: glossary term for the Nefesh Ahat reform.
-- Description approved by the site owner on 08.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-08-glossary-one-soul',
  DATE '2026-11-08',
  'רפורמת נפש אחת במילון',
  'נוסף למילון מונח על רפורמת נפש אחת. הוא מתאר את הזכויות והטיפולים לנכי צה״ל ולכוחות הביטחון, ואת ההרחבה לנפגעי פעולות איבה בביטוח הלאומי, עם קישורים לעמוד של אגף השיקום ולעמוד של הביטוח הלאומי.',
  'glossary',
  '{}',
  ARRAY['one_soul'],
  '125_glossary_one_soul.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-08-glossary-one-soul-link',
  DATE '2026-11-08',
  'קישור לרפורמת נפש אחת',
  'במונח «אגף השיקום במשרד הביטחון» נוסף קישור למונח רפורמת נפש אחת.',
  'glossary',
  '{}',
  ARRAY['mod_rehab'],
  '125_glossary_one_soul.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
