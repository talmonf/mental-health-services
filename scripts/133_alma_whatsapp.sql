-- Migration 133 (13 Nov 2026)
-- Alma (row 782): a WhatsApp button on the same number as the phone,
-- +972 54-218-0866. The label is וואטסאפ / WhatsApp, so the digits stay off the button.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'whatsapp', '972542180866',
      'whatsappLabel', 'וואטסאפ'
    ),
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || jsonb_build_object(
        'whatsappLabel', 'WhatsApp'
      ),
      true
    ),
    eligibility = jsonb_set(
      COALESCE(eligibility, '{}'::jsonb),
      '{internal_notes}',
      to_jsonb(
        CASE
          WHEN COALESCE(eligibility->>'internal_notes', '') LIKE '%972542180866%'
          THEN rtrim(eligibility->>'internal_notes')
          ELSE rtrim(COALESCE(eligibility->>'internal_notes', ''))
            || E'\n\n13.11.2026: נוסף וואטסאפ לאותו מספר של הטלפון, 054-218-0866 (972542180866).'
        END
      )
    ),
    updated_at = now()
WHERE card_key = '782|||בית מאזן לנשים עם פוסט־טראומה מורכבת והפרעת אכילה';

COMMIT;
