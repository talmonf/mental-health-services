-- Migration 002
-- directory_entries: last title updates for TMS cards only
-- Use this if Migration 001 was already applied.

BEGIN;

UPDATE directory_entries
SET display_name = '(BrainsWay) TMS - גרייה מגנטית מוחית'
WHERE entry_id = 'tms_deep_tms_105';

UPDATE directory_entries
SET display_name = '(איכילוב) TMS - גרייה מגנטית מוחית'
WHERE entry_id = 'tms_גרייה_מגנטית_מוחית_108';

COMMIT;
