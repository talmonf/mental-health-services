-- Migration 049 (6 Oct 2026)
-- directory_card_edits: עזרה למרפא (row 246).
-- Advance notice and a medical document are required, in addition to a companion.
-- Touches only the notes field, so other admin edits on the card stay.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = jsonb_set(
      public_fields,
      '{notes}',
      to_jsonb(
        CASE
          WHEN btrim(COALESCE(public_fields->>'notes', '')) = ''
            THEN 'נדרשת התראה מראש ומסמך רפואי'
          ELSE rtrim(btrim(public_fields->>'notes'), '.') || '. נדרשת התראה מראש ומסמך רפואי'
        END
      )
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '246|||שירותי אמבולנס להסעת חולים, נכים ומוגבלים לטיפולים, בדיקות ואירועים משפחתיים'
  AND position('מסמך רפואי' IN COALESCE(public_fields->>'notes', '')) = 0;

COMMIT;
