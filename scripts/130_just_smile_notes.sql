-- Migration 130 (10 Nov 2026)
-- Row 780 was inserted by the first run of 129. That insert uses
-- ON CONFLICT DO NOTHING, and this update does not match its old sentences.
-- It writes the public notes and the English name over whatever 129 stored.
--
-- English org: Just Smile, the name used on the platforms.
-- Notes, Hebrew and English: not a crisis line; the WhatsApp button opens a
-- group; the pin is the office. No instruction to call ERAN.
-- The stored labels stay טלפון / וואטסאפ / אימייל (and Phone / WhatsApp / Email).
-- Clearing them would make an older page print the number. The page hides a
-- label that only names the icon.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'notes', $he780$אינה מוקד חירום. כפתור הוואטסאפ פותח קבוצה, לא שיחה פרטית. הכתובת במפה היא משרד העמותה, לא מרפאה.$he780$
    ),
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || jsonb_build_object(
        'org', 'Just Smile',
        'notes', $en780$Not a crisis line. The WhatsApp button opens a group, not a private chat. The address on the map is the office, not a clinic.$en780$
      ),
      true
    ),
    eligibility = jsonb_set(
      COALESCE(eligibility, '{}'::jsonb),
      '{internal_notes}',
      to_jsonb(
        CASE
          WHEN COALESCE(eligibility->>'internal_notes', '') LIKE '%השם באנגלית בכרטיס הוא Just Smile%'
          THEN rtrim(eligibility->>'internal_notes')
          ELSE rtrim(COALESCE(eligibility->>'internal_notes', ''))
            || E'\n\n10.11.2026: השם באנגלית בכרטיס הוא Just Smile, כפי שהעמותה נקראת בפלטפורמות. מההערות לציבור הוסרו שנת ההקמה, ע״ר 580744498, האזכור לזכרה של רונית וולף ז״ל, פעילות ההסברה, וההפניה לער״ן. נשאר המשפט שאינה מוקד חירום.'
        END
      )
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '780|||סבסוד טיפול פסיכולוגי ופסיכיאטרי למי שאין לו אפשרות לממן';

COMMIT;
