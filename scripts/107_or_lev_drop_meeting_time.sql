-- Migration 107 (1 Nov 2026)
-- אור לב, rows 773 and 774: drop the weekday and the hour from the notes.
-- The length of a meeting stays. 105 is unchanged.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = jsonb_set(
      public_fields,
      '{notes}',
      to_jsonb(replace(public_fields->>'notes', 'ימי רביעי ב-20:00, ', ''))
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '773|||קבוצת תמיכה למתמודדים עם OCD'
  AND public_fields->>'notes' LIKE 'ימי רביעי ב-20:00, %';

UPDATE directory_card_edits
SET public_fields = jsonb_set(
      public_fields,
      '{notes}',
      to_jsonb(replace(public_fields->>'notes', 'ימי ראשון ב-20:00, ', ''))
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '774|||קבוצת תמיכה להורים למתמודדים עם OCD'
  AND public_fields->>'notes' LIKE 'ימי ראשון ב-20:00, %';

COMMIT;
