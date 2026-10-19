-- Migration 096 (19 Oct 2026)
-- Audit log: website button on organization glossary cards, and star-prefix
-- phone numbers shown with the star first.
-- Descriptions approved by the site owner on 19.10.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-19-glossary-org-websites',
    DATE '2026-10-19',
    'כפתור לאתר בכרטיסי מילון',
    'בכרטיס «כל זכות» נוסף כפתור לאתר כל זכות. אותו כפתור נוסף גם לביטוח לאומי, משרד הבריאות, אגף השיקום, כללית, מכבי, מאוחדת, לאומית, נט״ל וער״ן.',
    'glossary',
    '{}',
    ARRAY['kol_zchut', 'btl', 'moh', 'mod_rehab', 'clalit', 'maccabi', 'meuhedet', 'leumit', 'natal', 'eran'],
    '096_site_audit_entries_glossary_web_and_star_phones.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-19-star-phone-display',
    DATE '2026-10-19',
    'כוכבית לפני מספר הטלפון',
    'מספרי טלפון קצרים שמתחילים בכוכבית, כמו *5400, מוצגים עכשיו עם הכוכבית לפני הספרות בכל האתר.',
    'ui',
    '{}',
    '{}',
    '096_site_audit_entries_glossary_web_and_star_phones.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
