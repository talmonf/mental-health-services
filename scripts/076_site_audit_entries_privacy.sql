-- Migration 076 (16 Oct 2026)
-- Audit log entry for the new privacy policy page. Description approved by the site
-- owner on 16.10.2026.
-- Requires 062. Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-16-privacy-policy',
    DATE '2026-10-16',
    'דף מדיניות פרטיות',
    'נוסף דף «מדיניות פרטיות» בכתובת nefesh-il.org/privacy, עם קישור בתחתית כל דף. הדף מסביר איזה מידע האתר אוסף, למי הוא מועבר, כמה זמן הוא נשמר ואיך מעיינים בו או מוחקים אותו. בנוסף, מחיקת חשבון מוחקת עכשיו גם את המסמכים שהועלו ל«התיק שלי».',
    'ui',
    '{}',
    '{}',
    '076_site_audit_entries_privacy.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
