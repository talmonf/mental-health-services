-- Migration 148 (24 Nov 2026)
-- Navigate (row 291): the Hebrew heading is נויגייט (NAVIGATE).
-- The Latin name is on the organization's site and was missing from the Hebrew heading.
-- English heading stays NAVIGATE. card_key and entry_id stay.
-- No audit entry: this restores a name that search could not find.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'org', 'נויגייט (NAVIGATE)'
    ),
    eligibility = jsonb_set(
      COALESCE(eligibility, '{}'::jsonb),
      '{internal_notes}',
      to_jsonb(
        CASE
          WHEN COALESCE(eligibility->>'internal_notes', '') LIKE '%נויגייט (NAVIGATE)%'
          THEN rtrim(eligibility->>'internal_notes')
          ELSE rtrim(COALESCE(eligibility->>'internal_notes', ''))
            || E'\n\n24.11.2026: הכותרת בעברית היא «נויגייט (NAVIGATE)», כמו השם הלטיני באתר. באנגלית NAVIGATE כבר היה.'
        END
      )
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '291|||תוכנית קהילתית אחרי אפיזודה פסיכוטית ראשונה: טיפול תרופתי, וגם פסיכותרפיה. במרפאה.';

UPDATE directory_entries
SET display_name = 'נויגייט (NAVIGATE)'
WHERE entry_id = 'נויגייט_navigate_291';

COMMIT;
