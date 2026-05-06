-- Migration 004 (May 2026)
-- Follow-up to 003: align directory_entries with index.html after איגוד was added under
-- `emergency` (red banner + DATA) and רזולוציה listed under both `therapists` and `local`.
-- Run this if migration 003 has already been applied on your database.

BEGIN;

UPDATE directory_entries
SET
  primary_category = 'emergency',
  category_keys = ARRAY['emergency', 'helplines']::text[]
WHERE entry_id = 'איגוד_מרכזי_הסיוע_לנפגעות_ולנפגעי_תקיפה_מינית_200';

UPDATE directory_entries
SET category_keys = ARRAY['therapists', 'local']::text[]
WHERE entry_id = 'רזולוציה_205';

UPDATE directory_entries
SET description = 'קווי המענה הארציים של ארגון הגג; סיוע לחברה הדתית (*2511, 02-5328000); צ''אט אנונימי וסיוע ב-WhatsApp (קולמילה).'
WHERE entry_id = 'איגוד_מרכזי_הסיוע_לנפגעות_ולנפגעי_תקיפה_מינית_200';

COMMIT;
