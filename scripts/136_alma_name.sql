-- Migration 136 (13 Nov 2026)
-- Alma (row 782): the heading changes from אלמה to אלמה בית מאזן.
-- English heading: Alma Beit Mazen, the name on the website.
-- card_key and entry_id stay.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'org', 'אלמה בית מאזן'
    ),
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || jsonb_build_object(
        'org', 'Alma Beit Mazen'
      ),
      true
    ),
    eligibility = jsonb_set(
      COALESCE(eligibility, '{}'::jsonb),
      '{internal_notes}',
      to_jsonb(
        CASE
          WHEN COALESCE(eligibility->>'internal_notes', '') LIKE '%אלמה בית מאזן%'
          THEN rtrim(eligibility->>'internal_notes')
          ELSE rtrim(COALESCE(eligibility->>'internal_notes', ''))
            || E'\n\n13.11.2026, בעל האתר: הכותרת היא «אלמה בית מאזן». באנגלית: Alma Beit Mazen, כשם באתר.'
        END
      )
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '782|||בית מאזן לנשים עם פוסט־טראומה מורכבת והפרעת אכילה';

UPDATE directory_entries
SET display_name = 'אלמה בית מאזן'
WHERE entry_id = 'אלמה_בית_מאזן_782';

COMMIT;
