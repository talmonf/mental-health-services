-- Migration 159 (28 Nov 2026)
-- רחל פרידלנדר (row 790): drop the "how to get it" line.
-- The phone, email, and WhatsApp buttons already say how to reach her.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET indicators = jsonb_set(
      jsonb_set(indicators, '{referral}', '[]'::jsonb, true),
      '{referral_source}', '""'::jsonb, true
    ),
    eligibility = jsonb_set(
      eligibility,
      '{internal_notes}',
      to_jsonb(
        rtrim(COALESCE(eligibility->>'internal_notes', ''))
        || E'\n\n28.11.2026: ירד משפט «איך מקבלים». הפנייה בטלפון, באימייל או בוואטסאפ כבר בכפתורים.'
      )
    ),
    updated_at = now()
WHERE card_key = '790|||רחל פרידלנדר';

UPDATE directory_entries
SET referral_codes = ARRAY[]::text[]
WHERE entry_id = 'רחל_פרידלנדר_790';

COMMIT;
