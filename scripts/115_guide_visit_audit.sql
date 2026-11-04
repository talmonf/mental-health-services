-- Migration 115 (4 Nov 2026)
-- Analytics can show which search article was opened, when, where the visitor
-- came from, and where that same visitor went next.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-04-guide-visit-audit',
  DATE '2026-11-04',
  'כניסות למדריכי החיפוש',
  'במסך האנליטיקה אפשר לראות איזה מדריך נפתח, מתי, מאיפה הגיעו (גוגל, ChatGPT וכדומה), ולאן המשיכו — למדריך אחר או לאתר עצמו — ואת המסלול של מבקר מסוים.',
  'admin',
  '{}',
  '{}',
  '115_guide_visit_audit.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
