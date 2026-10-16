-- Migration 084 (16 Oct 2026)
-- Audit log entry for the admin directory list: selected tab, and the internal-info tick.
-- Description approved by the site owner on 16.10.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-16-admin-directory-internal-filter',
    DATE '2026-10-16',
    'סימון הלשונית הפתוחה וסינון מידע פנימי',
    'במסך הניהול, הלשונית שפתוחה מסומנת בקו. ברשימת כרטיסי המדריך יש עמודה «מידע פנימי»: סימון ירוק כשיש מידע, וסימון אדום כשאין. אפשר לסנן את הרשימה לפי זה.',
    'admin',
    '{}',
    '{}',
    '084_site_audit_entries_admin_directory.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
