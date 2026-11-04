-- Migration 112 (4 Nov 2026)
-- Optional text in languages other than Hebrew. Hebrew stays in public_fields.
-- A key inside translations.en replaces that field while the site is in English.
-- An empty English field is omitted, so the Hebrew is shown.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

ALTER TABLE directory_card_edits
  ADD COLUMN IF NOT EXISTS translations jsonb NOT NULL DEFAULT '{}'::jsonb;

COMMENT ON COLUMN directory_card_edits.translations IS
  'Locale overlays keyed by language code. Hebrew remains public_fields. A present key replaces that field for that language.';

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-04-language-switch',
  DATE '2026-11-04',
  'בחירה בין עברית לאנגלית',
  'בראש המדריך, מימין לכניסה ולהרשמה, אפשר לבחור עברית או אנגלית. המדריך נפתח בעברית. באנגלית התפריטים וכותרות המדורים באנגלית. כרטיס עם נוסח אנגלי מוצג באנגלית, והקישור לאתר הארגון מוביל לעמוד האנגלי. כרטיס בלי נוסח אנגלי נשאר בעברית.',
  'ui',
  '{}',
  '{}',
  '112_card_translations.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
