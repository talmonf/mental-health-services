-- Migration 119 (7 Nov 2026)
-- The rights booklet heading is the booklet title. מיכל יום טוב stays in the notes.
-- The subtitle is cleared so the title is not shown twice.
-- The booklet file is Hebrew, so the English wording is removed.
-- card_key stays 776|||חוברת זכויות בריאות הנפש. The copy in index.html keeps that svc
-- so the row still matches; the published subtitle is the empty field here.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_entries
SET display_name = 'חוברת זכויות בריאות הנפש',
    description = 'חוברת זכויות בריאות הנפש'
WHERE entry_id = 'lev_hasharon_rights_booklet_776';

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'org', 'חוברת זכויות בריאות הנפש',
      'svc', ''
    ),
    translations = translations - 'en',
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '776|||חוברת זכויות בריאות הנפש';

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-07-rights-booklet-title',
  DATE '2026-11-07',
  'כותרת החוברת',
  'כותרת הכרטיס היא חוברת זכויות בריאות הנפש. השם מיכל יום טוב נשאר בהערות, כמי שכתבה את החוברת.',
  'cards',
  ARRAY['776|||חוברת זכויות בריאות הנפש'],
  '{}',
  '119_rights_booklet_title.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
