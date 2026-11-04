-- Migration 114 (4 Nov 2026)
-- The welcome and the credits follow the directory language.
-- A visitor can choose to list cards written in the other language.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-04-language-chrome',
  DATE '2026-11-04',
  'ברכה וקרדיט לפי שפה, והצגת כל הכרטיסים',
  'באנגלית ברכת הפתיחה ושורת הקרדיט באנגלית, ובעברית הן בעברית. שורת הקרדיט אומרת שאתר זה נוצר על ידי יוסי שמעונוביץ וטלמון פרידלנדר. אפשר לבחור להציג גם כרטיסים שכתובים בשפה האחרת.',
  'ui',
  '{}',
  '{}',
  '114_language_chrome.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
