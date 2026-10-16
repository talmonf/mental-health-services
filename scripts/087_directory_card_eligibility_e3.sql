-- Migration 087 (16 Oct 2026)
-- Eligibility for batch E3, from docs/card-eligibility-2026-10.md, approved by the site owner.
-- Each UPDATE applies only while every condition is still «ללא הגבלה», so a later admin edit is kept.
-- Public card text and public_edited_at are left unchanged.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- E3-R8 row 8
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '8|||שירותי סל שיקום'
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

-- E3-R15 row 15
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '15|||מרכזי תמיכה רגשית ונפשית
'
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

-- E3-R28 row 28
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '28|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה'
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

-- E3-R29 row 29
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '29|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה'
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

-- E3-R38 row 38
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '38|||אשפוז פסיכיאטרי'
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

-- E3-R47 row 47
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '47|||פסיכותרפיה מקוונת'
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

-- E3-R48 row 48
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '48|||אשפוז בית פסיכיאטרי'
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

-- E3-R53 row 53
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '53|||חלופת אשפוז'
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

-- E3-R62 row 62
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '62|||מרפאות לבריאות הנפש
'
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

-- E3-R71 row 71
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '71|||לשילוב מתמודדים והעצמה בבריאות הנפש'
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

-- E3-R73 row 73
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '73|||נתיבי שיקום והחלמה'
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

-- E3-R74 row 74
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '74|||שיקום ובריאות הנפש'
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

-- E3-R79 row 79
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"regions","regions":["מרכז (כללית ומואחדת)","ירושלים (מאוחדת)"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: אזורים: מרכז (כללית ומואחדת), ירושלים (מאוחדת).', E'\n ')),
    updated_at = now()
WHERE card_key = '79|||תוכנית טיפול ביתי ממושך למתמודדים עם מחלת נפש חמורה'
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

-- E3-R80 row 80
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '80|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה'
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

-- E3-R81 row 81
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '81|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה'
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

-- E3-R96 row 96
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '96|||הכוונה לטיפול הפסיכולוגי המתאים וסבסוד טיפולים פסיכולוגיים'
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

-- E3-R105 row 105
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '105|||טיפולי גרייה מוחית (TMS ו-Deep TMS) למגוון מצבים נפשיים ונוירולוגיים. דיכאון מג''ורי בסל לפי תנאים; שיפוי אגף השיקום ל-PTSD בחלק מבתי החולים הציבוריים.'
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

-- E3-R106 row 106
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '106|||Access center for psychedelic treatment and therapy.'
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

-- E3-R107 row 107
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '107|||טיפול פסיכדלי ומידע מקצועי בתחום.'
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

-- E3-R108 row 108
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"regions","regions":["תל אביב"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: אזורים: תל אביב.', E'\n ')),
    updated_at = now()
WHERE card_key = '108|||טיפול בגרייה מגנטית מוחית (TMS) במרפאה לטיפולים מתקדמים. באותה יחידה גם ECT, אסקטמין ונוירופידבק.'
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

-- E3-R109 row 109
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '109|||טיפול ביולוגי תחת הרדמה קצרה במצבים נפשיים חמורים — בעיקר דיכאון קשה, קטטוניה ומצבים דחופים. ניתן בסדרה בבתי חולים פסיכיאטריים ובחטיבות פסיכיאטריות (למשל איכילוב, שלוותה, כפר שאול).'
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
    '2026-10-16-eligibility-e3',
    DATE '2026-10-16',
    'מידע פנימי — מרפאות, אשפוז ושיקום',
    'בכרטיסי מרפאות, אשפוז ושיקום שלא היו להם תנאי התאמה, נוסף מידע פנימי לפי הטקסט שבכרטיס: אזור, ובמקום שהטקסט מציין גם גיל. בכרטיסים בלי תנאי נוסף שנבדקו ושאין תנאי התאמה. הטקסט שעל הכרטיס לא השתנה.',
    'data',
    ARRAY[
      '8|||שירותי סל שיקום',
      '15|||מרכזי תמיכה רגשית ונפשית
',
      '28|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה',
      '29|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה',
      '38|||אשפוז פסיכיאטרי',
      '47|||פסיכותרפיה מקוונת',
      '48|||אשפוז בית פסיכיאטרי',
      '53|||חלופת אשפוז',
      '62|||מרפאות לבריאות הנפש
',
      '71|||לשילוב מתמודדים והעצמה בבריאות הנפש',
      '73|||נתיבי שיקום והחלמה',
      '74|||שיקום ובריאות הנפש',
      '79|||תוכנית טיפול ביתי ממושך למתמודדים עם מחלת נפש חמורה',
      '80|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה',
      '81|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה',
      '96|||הכוונה לטיפול הפסיכולוגי המתאים וסבסוד טיפולים פסיכולוגיים',
      '105|||טיפולי גרייה מוחית (TMS ו-Deep TMS) למגוון מצבים נפשיים ונוירולוגיים. דיכאון מג''ורי בסל לפי תנאים; שיפוי אגף השיקום ל-PTSD בחלק מבתי החולים הציבוריים.',
      '106|||Access center for psychedelic treatment and therapy.',
      '107|||טיפול פסיכדלי ומידע מקצועי בתחום.',
      '108|||טיפול בגרייה מגנטית מוחית (TMS) במרפאה לטיפולים מתקדמים. באותה יחידה גם ECT, אסקטמין ונוירופידבק.',
      '109|||טיפול ביולוגי תחת הרדמה קצרה במצבים נפשיים חמורים — בעיקר דיכאון קשה, קטטוניה ומצבים דחופים. ניתן בסדרה בבתי חולים פסיכיאטריים ובחטיבות פסיכיאטריות (למשל איכילוב, שלוותה, כפר שאול).'
    ],
    '{}',
    '087_directory_card_eligibility_e3.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
