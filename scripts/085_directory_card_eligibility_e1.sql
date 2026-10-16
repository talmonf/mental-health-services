-- Migration 085 (16 Oct 2026)
-- Eligibility for batch E1, from docs/card-eligibility-2026-10.md, approved by the site owner.
-- Each UPDATE applies only while every condition is still «ללא הגבלה», so a later admin edit is kept.
-- Public card text and public_edited_at are left unchanged.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- E1-R1 row 1
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '1|||קצבת נכות למתמודדי נפש'
  AND NULLIF(eligibility->>'age_min', '') IS NULL
  AND NULLIF(eligibility->>'age_max', '') IS NULL
  AND COALESCE(NULLIF(eligibility->>'sex', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility->>'location_mode', ''), 'any') = 'any'
  AND COALESCE(eligibility->'regions', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(eligibility->'diagnoses', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(eligibility->'presenting_problems', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(NULLIF(eligibility#>>'{recognition,btl}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,moh}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,mod}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,rehab_basket}', ''), 'any') = 'any';

-- E1-R3 row 3
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '3|||קצבת סיעוד'
  AND NULLIF(eligibility->>'age_min', '') IS NULL
  AND NULLIF(eligibility->>'age_max', '') IS NULL
  AND COALESCE(NULLIF(eligibility->>'sex', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility->>'location_mode', ''), 'any') = 'any'
  AND COALESCE(eligibility->'regions', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(eligibility->'diagnoses', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(eligibility->'presenting_problems', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(NULLIF(eligibility#>>'{recognition,btl}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,moh}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,mod}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,rehab_basket}', ''), 'any') = 'any';

-- E1-R4 row 4
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '4|||ייעוץ והכנה בחינם לוועדה הרפואית'
  AND NULLIF(eligibility->>'age_min', '') IS NULL
  AND NULLIF(eligibility->>'age_max', '') IS NULL
  AND COALESCE(NULLIF(eligibility->>'sex', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility->>'location_mode', ''), 'any') = 'any'
  AND COALESCE(eligibility->'regions', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(eligibility->'diagnoses', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(eligibility->'presenting_problems', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(NULLIF(eligibility#>>'{recognition,btl}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,moh}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,mod}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,rehab_basket}', ''), 'any') = 'any';

-- E1-R21 row 21
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '21|||רשת לאומית לחוסן נפשי המאפשרת יצירת כלים אינטראקטיביים מותאמים לקהלי יעד שונים'
  AND NULLIF(eligibility->>'age_min', '') IS NULL
  AND NULLIF(eligibility->>'age_max', '') IS NULL
  AND COALESCE(NULLIF(eligibility->>'sex', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility->>'location_mode', ''), 'any') = 'any'
  AND COALESCE(eligibility->'regions', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(eligibility->'diagnoses', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(eligibility->'presenting_problems', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(NULLIF(eligibility#>>'{recognition,btl}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,moh}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,mod}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,rehab_basket}', ''), 'any') = 'any';

-- E1-R23 row 23
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '23|||אינדקס שירותים'
  AND NULLIF(eligibility->>'age_min', '') IS NULL
  AND NULLIF(eligibility->>'age_max', '') IS NULL
  AND COALESCE(NULLIF(eligibility->>'sex', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility->>'location_mode', ''), 'any') = 'any'
  AND COALESCE(eligibility->'regions', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(eligibility->'diagnoses', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(eligibility->'presenting_problems', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(NULLIF(eligibility#>>'{recognition,btl}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,moh}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,mod}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,rehab_basket}', ''), 'any') = 'any';

-- E1-R27 row 27
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '27|||אינדקס שירותים למתמודדי נפש'
  AND NULLIF(eligibility->>'age_min', '') IS NULL
  AND NULLIF(eligibility->>'age_max', '') IS NULL
  AND COALESCE(NULLIF(eligibility->>'sex', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility->>'location_mode', ''), 'any') = 'any'
  AND COALESCE(eligibility->'regions', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(eligibility->'diagnoses', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(eligibility->'presenting_problems', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(NULLIF(eligibility#>>'{recognition,btl}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,moh}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,mod}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,rehab_basket}', ''), 'any') = 'any';

-- E1-R59 row 59
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '59|||מיצוי זכויות'
  AND NULLIF(eligibility->>'age_min', '') IS NULL
  AND NULLIF(eligibility->>'age_max', '') IS NULL
  AND COALESCE(NULLIF(eligibility->>'sex', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility->>'location_mode', ''), 'any') = 'any'
  AND COALESCE(eligibility->'regions', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(eligibility->'diagnoses', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(eligibility->'presenting_problems', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(NULLIF(eligibility#>>'{recognition,btl}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,moh}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,mod}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,rehab_basket}', ''), 'any') = 'any';

-- E1-R85 row 85
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '85|||מדריך מיצוי זכויות למתמודדי נפש ובני משפחותיהם'
  AND NULLIF(eligibility->>'age_min', '') IS NULL
  AND NULLIF(eligibility->>'age_max', '') IS NULL
  AND COALESCE(NULLIF(eligibility->>'sex', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility->>'location_mode', ''), 'any') = 'any'
  AND COALESCE(eligibility->'regions', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(eligibility->'diagnoses', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(eligibility->'presenting_problems', '[]'::jsonb) = '[]'::jsonb
  AND COALESCE(NULLIF(eligibility#>>'{recognition,btl}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,moh}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,mod}', ''), 'any') = 'any'
  AND COALESCE(NULLIF(eligibility#>>'{recognition,rehab_basket}', ''), 'any') = 'any';

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-16-eligibility-e1',
    DATE '2026-10-16',
    'מידע פנימי — זכויות ופורטלים',
    'בכרטיסי זכויות, משרד הבריאות ופורטלים שלא היו להם תנאי התאמה, נוסף מידע פנימי לפי הטקסט שבכרטיס. איפה שהאזור הוא כל הארץ סומן «ארצי». בכרטיסים בלי תנאי נוסף שנבדקו ושאין תנאי התאמה. הטקסט שעל הכרטיס לא השתנה.',
    'data',
    ARRAY[
      '1|||קצבת נכות למתמודדי נפש',
      '3|||קצבת סיעוד',
      '4|||ייעוץ והכנה בחינם לוועדה הרפואית',
      '21|||רשת לאומית לחוסן נפשי המאפשרת יצירת כלים אינטראקטיביים מותאמים לקהלי יעד שונים',
      '23|||אינדקס שירותים',
      '27|||אינדקס שירותים למתמודדי נפש',
      '59|||מיצוי זכויות',
      '85|||מדריך מיצוי זכויות למתמודדי נפש ובני משפחותיהם'
    ],
    '{}',
    '085_directory_card_eligibility_e1.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
