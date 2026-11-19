-- Migration 138 (19 Nov 2026)
-- Calmer home page: search jump, softer emergency and Iron Swords, stronger nearby button.
-- Audit wording approved with the plan on 19.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-19-home-calmer-ui',
  DATE '2026-11-19',
  'עמוד הבית רגוע יותר',
  'בראש העמוד יש כפתור חיפוש שמוריד לשדה החיפוש. בלוק החירום וכפתור חרבות ברזל פחות אדומים. כפתור השירותים הקרובים בולט יותר, וכרטיס העזרה הדחופה נראה כמו שאר הכרטיסים עם סימון קטן.',
  'ui',
  '{}',
  '{}',
  '138_home_calmer_ui.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
