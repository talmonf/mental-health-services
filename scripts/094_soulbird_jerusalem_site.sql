-- Migration 094 (18 Oct 2026)
-- ציפור הנפש (row 307): map pin for the Jerusalem center only.
-- Address recorded on 14.10.2026: קרן היסוד 27, OSM house node 1697893994.
-- Other centers stay unpinned until street addresses are added.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET sites = '[{"label":"ירושלים","address":"קרן היסוד 27, ירושלים","lat":31.7733591,"lng":35.2200541,"phone":"1599-502120","email":"soulbird@slavpro.co.il","sort_order":0}]'::jsonb,
    eligibility = jsonb_set(
      COALESCE(eligibility, '{}'::jsonb),
      '{internal_notes}',
      to_jsonb(
        rtrim(COALESCE(eligibility->>'internal_notes', ''))
        || E'\n\n18.10.2026: נוספה סיכה למרכז ירושלים, קרן היסוד 27. שאר המרכזים בלי כתובת רחוב — לא נוספו.'
      )
    ),
    updated_at = now()
WHERE card_key = '307|||ליווי ממוקד הורות להורים המתמודדים עם קשיים נפשיים'
  AND COALESCE(sites, '[]'::jsonb) = '[]'::jsonb;

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, 'ירושלים', 'קרן היסוד 27, ירושלים', 31.7733591, 35.2200541, 0
FROM directory_card_edits c
WHERE c.card_key = '307|||ליווי ממוקד הורות להורים המתמודדים עם קשיים נפשיים'
  AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

COMMIT;
