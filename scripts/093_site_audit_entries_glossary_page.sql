-- Migration 093 (18 Oct 2026)
-- Audit log entry for the glossary page's own address.
-- Description approved by the site owner on 18.10.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-18-glossary-page-url',
    DATE '2026-10-18',
    'כתובת משלה למילון המונחים',
    'מילון המונחים נפתח בכתובת משלו, באנגלית. קישור למונח או לקטגוריה פותח את המילון כולו באותה כתובת, ומגלגל אל המונח או אל הקטגוריה.',
    'ui',
    '{}',
    '{}',
    '093_site_audit_entries_glossary_page.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
