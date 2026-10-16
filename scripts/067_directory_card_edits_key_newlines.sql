-- Migration 067 (16 Oct 2026)
-- Six card keys (rows 15, 16, 24, 60, 62, 92) were seeded from a Windows checkout, so the
-- service text inside the key has \r\n line breaks. index.html is served with \n, so the page
-- never matched these rows and showed the embedded text instead of the edited one.
-- Strip the \r. glossary_card_links follows through ON UPDATE CASCADE.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits c
SET card_key = replace(c.card_key, E'\r', ''),
    updated_at = now()
WHERE c.card_key LIKE E'%\r%'
  AND NOT EXISTS (
    SELECT 1 FROM directory_card_edits d WHERE d.card_key = replace(c.card_key, E'\r', '')
  );

UPDATE site_audit_entries
SET card_keys = ARRAY(SELECT replace(k, E'\r', '') FROM unnest(card_keys) AS k)
WHERE EXISTS (SELECT 1 FROM unnest(card_keys) AS k WHERE k LIKE E'%\r%');

COMMIT;
