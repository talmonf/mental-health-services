-- Migration 078 (16 Oct 2026)
-- Audit log entry for search treating צפור and ציפור as the same spelling.
-- Description approved by the site owner on 16.10.2026.
-- Requires 062. Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-16-search-tsipor',
    DATE '2026-10-16',
    'חיפוש: צפור מוצא את ציפור',
    'חיפוש «צפור», בלי היוד שאחרי הצד״י, מוצא את אותם כרטיסים כמו חיפוש «ציפור».',
    'ui',
    '{}',
    '{}',
    '078_site_audit_entries_search_tsipor.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
