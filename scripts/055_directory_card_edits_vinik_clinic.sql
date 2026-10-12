-- Migration 055 (12 Oct 2026)
-- directory_card_edits: ויניק טלביה (row 298).
-- Add the clinic's own Clalit page. The אשפוז יום link stays the general service page.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'add', 'https://www.clalit.co.il/he/sefersherut/pages/clinicdetails.aspx?ddeptcode=15533',
      'addLabel', 'המרפאה'
    ),
    eligibility = jsonb_set(
      eligibility,
      '{internal_notes}',
      to_jsonb(
        rtrim(COALESCE(eligibility->>'internal_notes', ''))
        || E'\n\n12.10.2026: נוסף דף המרפאה עצמה (ddeptcode=15533). קישור אשפוז היום נשאר הדף הכללי של כללית. רשומת 15530 נשארה.'
      )
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '298|||אשפוז יום פסיכיאטרי למבוטחי כללית'
  AND COALESCE(public_fields->>'add', '') = '';

COMMIT;
