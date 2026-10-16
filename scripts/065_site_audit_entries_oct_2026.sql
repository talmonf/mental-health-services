-- Migration 065 (16 Oct 2026)
-- First audit log entries: the audit log, card verification, new glossary terms and
-- glossary-card links. Descriptions approved by the site owner on 16.10.2026.
-- Requires 062. Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, term_keys, migration)
VALUES
  (
    '2026-10-audit-log',
    DATE '2026-10-16',
    'יומן שינויים חדש בניהול',
    'נוסף דף «יומן שינויים» בניהול האתר. הוא מציג את השינויים באתר מהחדש לישן, עם קישורים לכרטיסים ולמונחים שהשתנו. כל תיאור ביומן מאושר לפני שהוא נרשם.',
    'admin',
    '{}',
    '062_site_audit_entries.sql'
  ),
  (
    '2026-10-card-verification',
    DATE '2026-10-16',
    'אימות כרטיסים ואנשי קשר',
    'נוסף דף «אימות כרטיסים» בניהול האתר. לכל כרטיס אפשר לרשום עד כמה הוא אומת, מרמה 0 (לא אומת) עד רמה 3 (אושר מול איש קשר בארגון), מתי ועל ידי מי, ולשמור את אנשי הקשר הקשורים אליו מתוך Google Contacts. המידע פנימי ולא מוצג באתר.',
    'admin',
    '{}',
    '063_card_verification_contacts.sql'
  ),
  (
    '2026-10-glossary-terms',
    DATE '2026-10-16',
    'מונחים חדשים במילון',
    'נוספו 20 מונחים למילון המונחים, ביניהם טיפול יום, טופס 17, ביטוח לאומי, ועדת סל שיקום, הוסטל, ער"ן ונט"ל.',
    'glossary',
    ARRAY[
      'day_treatment', 'form17', 'btl', 'moh', 'mod_rehab', 'family_doctor', 'rehab_committee',
      'supported_employment', 'hostel', 'open_closed_ward', 'sexual_trauma', 'medication', 'natal',
      'eran', 'postpartum_depression', 'health_basket', 'kol_zchut', 'trauma', 'family_support', 'addictions'
    ],
    NULL
  ),
  (
    '2026-10-glossary-card-links',
    DATE '2026-10-16',
    'קישורים בין המילון לכרטיסים',
    'כרטיסים יכולים להציג «מונחים קשורים», וכל מונח במילון מציג «שירותים במדריך» שקשורים אליו. אפשר גם לפתוח מונח ישירות מקישור. הקישורים מופיעים רק אחרי שאושרו בדף «קישורי מילון» בניהול.',
    'glossary',
    '{}',
    '064_glossary_card_links.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
