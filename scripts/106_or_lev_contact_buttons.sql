-- Migration 106 (1 Nov 2026)
-- אור לב, rows 773 and 774: the phone and email buttons show the icon only.
-- Clears the button labels "וואטסאפ" and "פניות". The number and address stay.
-- Applies to rows already inserted by 105. 105 itself is unchanged.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'phoneLabel', '',
      'emailLabel', '',
      'emailShowAddress', false
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key IN (
  '773|||קבוצת תמיכה למתמודדים עם OCD',
  '774|||קבוצת תמיכה להורים למתמודדים עם OCD'
);

COMMIT;
