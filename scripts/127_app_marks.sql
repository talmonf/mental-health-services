-- Migration 127 (8 Nov 2026)
-- App marks: self-help apps and a service reached through an app.
-- Rescue, VIVID, and the PTSD guide leave the anxiety-apps section.
-- Shikum.Me stays under Ministry of Defense and is marked as a service reached through an app.
-- Audit wording approved with the plan on 08.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET indicators = COALESCE(indicators, '{}'::jsonb) || '{"app":"self_help"}'::jsonb,
    updated_at = now()
WHERE card_key IN (
  '101|||אפליקציה חינמית המספקת עזרה ראשונה נפשית ותמיכה מיידית בזמן התקף חרדה, ומלווה את המשתמש עד חזרה הדרגתית לשגרה.',
  '102|||אפליקציה אינטראקטיבית לבניית תוכניות תרגול יומי ומעקב לאורך זמן.',
  '103|||אפליקציה/מדריך דיגיטלי להתמודדות עם PTSD, מטעם אגף השיקום (משרד הביטחון).'
);

UPDATE directory_card_edits
SET indicators = COALESCE(indicators, '{}'::jsonb) || '{"app":"via_app"}'::jsonb,
    updated_at = now()
WHERE card_key = '765|||טיפולי רפואה משלימה באפליקציית Shikum.Me';

UPDATE directory_entries
SET primary_category = 'emergency',
    category_keys = ARRAY['emergency']::text[]
WHERE entry_id = 'אפליקציית_rescue_101';

UPDATE directory_entries
SET primary_category = 'treatments',
    category_keys = ARRAY['treatments', 'treatments_therapy']::text[]
WHERE entry_id = 'vivid_the_flexible_app_for_life_changing_practices_102';

UPDATE directory_entries
SET primary_category = 'trauma',
    category_keys = ARRAY['trauma']::text[]
WHERE entry_id = 'המדריך_ל_ptsd_103';

UPDATE directory_card_edits
SET public_fields = jsonb_set(
      public_fields,
      '{notes}',
      to_jsonb(replace(
        public_fields->>'notes',
        'https://nefesh-il.org/emergency?entry=103&section=anxiety_apps',
        'https://nefesh-il.org/treatment?entry=103&section=trauma'
      ))
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key IN (
  '755|||עמוד השירותים לטיפול ושיקום נפשי',
  '757|||מדריך מענים נפשיים למי שטרם הגיש בקשה להכרה'
)
AND COALESCE(public_fields->>'notes', '') LIKE '%section=anxiety_apps%';

UPDATE directory_card_edits
SET     translations = jsonb_set(
      translations,
      '{en,notes}',
      to_jsonb(replace(
        translations#>>'{en,notes}',
        'https://nefesh-il.org/emergency?entry=103&section=anxiety_apps',
        'https://nefesh-il.org/treatment?entry=103&section=trauma'
      ))
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key IN (
  '755|||עמוד השירותים לטיפול ושיקום נפשי',
  '757|||מדריך מענים נפשיים למי שטרם הגיש בקשה להכרה'
)
AND COALESCE(translations#>>'{en,notes}', '') LIKE '%section=anxiety_apps%';

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-08-app-marks',
  DATE '2026-11-08',
  'אפליקציות על הכרטיס',
  'אפליקציות כבר לא יושבות בקטגוריה נפרדת. Rescue בעזרה דחופה, VIVID בטיפול רגשי, והמדריך ל-PTSD בטראומה, וכולן מסומנות אפליקציה לעזרה עצמית. הרפואה המשלימה ב-Shikum.Me מסומנת שירות דרך אפליקציה. אפשר לסנן לפי שני הסימונים.',
  'ui',
  ARRAY[
    '101|||אפליקציה חינמית המספקת עזרה ראשונה נפשית ותמיכה מיידית בזמן התקף חרדה, ומלווה את המשתמש עד חזרה הדרגתית לשגרה.',
    '102|||אפליקציה אינטראקטיבית לבניית תוכניות תרגול יומי ומעקב לאורך זמן.',
    '103|||אפליקציה/מדריך דיגיטלי להתמודדות עם PTSD, מטעם אגף השיקום (משרד הביטחון).',
    '765|||טיפולי רפואה משלימה באפליקציית Shikum.Me',
    '755|||עמוד השירותים לטיפול ושיקום נפשי',
    '757|||מדריך מענים נפשיים למי שטרם הגיש בקשה להכרה'
  ],
  '{}',
  '127_app_marks.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
