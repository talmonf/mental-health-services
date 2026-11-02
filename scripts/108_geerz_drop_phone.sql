-- Migration 108 (2 Nov 2026)
-- גירז, rows 770 and 771: drop 052-452-2891. That person is no longer with the organization.
-- Phone buttons keep the label and do not print the number.
-- 104 is unchanged; this applies to rows it already inserted.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'phone3', '',
      'phoneLabel3', '',
      'phoneShowNumber', false,
      'phoneShowNumber2', false
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key IN (
  '770|||רכיבת הרים טיפולית לילדים ונוער, גילאי 7–16',
  '771|||רכיבת הרים טיפולית ללוחמים ומילואימניקים'
);

COMMIT;
