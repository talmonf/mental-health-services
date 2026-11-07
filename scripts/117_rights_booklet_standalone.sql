-- Migration 117 (7 Nov 2026)
-- The rights booklet (row 776) stands alone. The card no longer names
-- המרכז לבריאות הנפש לב השרון or links to its page.
-- 116 already ran; this updates that row. The PDF file name is unchanged.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_entries
SET display_name = 'מיכל יום טוב',
    description = 'חוברת זכויות בריאות הנפש'
WHERE entry_id = 'lev_hasharon_rights_booklet_776';

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'org', 'מיכל יום טוב',
      'web', '',
      'webLabel', ''
    ),
    translations = jsonb_set(
      translations #- '{en,webLabel}',
      '{en,org}',
      to_jsonb('Michal Yom Tov'::text)
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '776|||חוברת זכויות בריאות הנפש';

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-07-rights-booklet-standalone',
  DATE '2026-11-07',
  'החוברת עומדת בפני עצמה',
  'חוברת הזכויות של מיכל יום טוב מוצגת כחוברת עצמאית. הכרטיס לא נושא שם של מוסד, ואין בו קישור לאתר של מוסד.',
  'cards',
  ARRAY['776|||חוברת זכויות בריאות הנפש'],
  '{}',
  '117_rights_booklet_standalone.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
