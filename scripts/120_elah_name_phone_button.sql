-- Migration 120 (7 Nov 2026)
-- Row 239: the organization calls itself מרכז אלה on https://www.elah.org.il/.
-- The phone button keeps תיאום טיפול and no longer prints 1-800-800-440.
-- The number stays on the button, so it still dials. card_key and entry_id stay.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'org', replace(replace(COALESCE(public_fields->>'org', ''), 'אל״ה', 'מרכז אלה'), 'אל"ה', 'מרכז אלה'),
      'phoneShowNumber', false
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '239|||טיפול פרטני, זוגי, משפחתי וייעוץ פסיכיאטרי';

UPDATE directory_entries
SET display_name = replace(replace(display_name, 'אל״ה', 'מרכז אלה'), 'אל"ה', 'מרכז אלה')
WHERE entry_id = 'אל_ה_מרכז_להתמודדות_עם_אבדן_239';

COMMIT;
