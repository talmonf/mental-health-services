-- Migration 123 (8 Nov 2026)
-- Rows 778 and 779: the phone and WhatsApp buttons no longer print the number.
-- The numbers stay on the buttons, so they still dial and open WhatsApp.
-- 122 is unchanged; this applies to rows it already inserted.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'phoneShowNumber', false,
      'phoneShowNumber2', false
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '778|||בית מאזן פרטי יוקרתי, ללא רשימת המתנה';

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'phoneShowNumber', false,
      'whatsappLabel', ''
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '779|||בית מאזן';

COMMIT;
