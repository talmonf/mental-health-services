-- Migration 092 (18 Oct 2026)
-- Audit log entry for glossary share links and the directory list of a term's services.
-- Description approved by the site owner on 18.10.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-18-glossary-share-links',
    DATE '2026-10-18',
    'קישורי שיתוף במילון המונחים',
    'במילון המונחים יש סמל קישור ליד כל קטגוריה וליד כל מונח. הקישור פותח את המילון כולו, ומגלגל אל הקטגוריה או אל המונח. ממונח שיש לו שירותים במדריך אפשר לפתוח את הרשימה הזאת בדף הראשי, כמו תוצאות חיפוש, ולשתף קישור לאותה רשימה.',
    'ui',
    '{}',
    '{}',
    '092_site_audit_entries_glossary_share.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
