-- Migration 086 (16 Oct 2026)
-- Eligibility for batch E2, from docs/card-eligibility-2026-10.md, approved by the site owner.
-- Each UPDATE applies only while every condition is still «ללא הגבלה», so a later admin edit is kept.
-- Public card text and public_edited_at are left unchanged.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- E2-R10 row 10
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '10|||קבלת סיוע נפשי מיידי'
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

-- E2-R11 row 11
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '11|||קו המעניק תמיכה נפשית ראשונית'
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

-- E2-R13 row 13
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '13|||קווי סיוע והכוונה'
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

-- E2-R14 row 14
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '14|||רשימת מוקדי הטיפול ומרכזי החוסן'
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

-- E2-R15 row 15
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '15|||מוקד סיוע רגשי-חברתי להורים ולתלמידים'
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

-- E2-R16 row 16
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '16|||שירותים למתמודד
אינדקס מטפלים
פורומים
ועוד ועוד'
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

-- E2-R18 row 18
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '18|||Provides English-speakers with access to verified mental health specialists as well as resources and information on navigating the mental health system in Israel'
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

-- E2-R19 row 19
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '19|||אינדקס שירותים למענה נפשי וטיפול בפוסט-טראומה'
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

-- E2-R20 row 20
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '20|||קו סיוע והכוונה'
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

-- E2-R21 row 21
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '21|||תמיכה נפשית ותעסוקתית לנפגעי טראומה ממלחמה וטרור'
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

-- E2-R22 row 22
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '22|||קו סיוע והכוונה'
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

-- E2-R24 row 24
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '24|||מוקדי סיוע
מרכז טיפול
ועוד'
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

-- E2-R25 row 25
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '25|||תמיכה ואוזן קשבת לבני משפחה למתמודדי נפש'
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

-- E2-R26 row 26
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '26|||קו ייעוץ ותמיכה - בימים א-ה בשעות 10:00-13:00 ו-16:00-22:00'
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

-- E2-R30 row 30
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '30|||אינדקס מטפלים (כולל פסיכיאטרים)'
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

-- E2-R31 row 31
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '31|||אינדקס מטפלים (כולל פסיכיאטרים)'
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

-- E2-R32 row 32
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '32|||אינדקס מטפלים (כולל פסיכיאטרים)'
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

-- E2-R33 row 33
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '33|||אינדקס פסיכיאטרים'
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

-- E2-R34 row 34
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '34|||אינדקס פסיכיאטרים'
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

-- E2-R35 row 35
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '35|||אינדקס פסיכולוגים מורשים'
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

-- E2-R36 row 36
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '36|||אינדקס משרד הבריאות - מהפנטים בעלי רשיון'
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

-- E2-R37 row 37
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '37|||אינדקס מטפלים'
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

-- E2-R46 row 46
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '46|||פסיכותרפיה מקוונת'
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

-- E2-R49 row 49
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '49|||התאגדות המטפלים הדתיים'
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

-- E2-R50 row 50
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '50|||אינדקס מטפלים'
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

-- E2-R51 row 51
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '51|||אינדקס מטפלים'
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

-- E2-R54 row 54
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '54|||קבוצה בפייסבוק'
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

-- E2-R55 row 55
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '55|||קבוצה בפייסבוק'
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

-- E2-R56 row 56
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '56|||קבוצה בפייסבוק'
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

-- E2-R57 row 57
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '57|||קבוצה בפייסבוק'
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

-- E2-R58 row 58
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '58|||קבוצה בפייסבוק'
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

-- E2-R60 row 60
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '60|||מידע, ייעוץ ותמיכה
מרכזי טיפול
מרכזי שיקום'
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

-- E2-R61 row 61
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '61|||מידע, ייעוץ ותמיכה'
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

-- E2-R76 row 76
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '76|||Crisis Support, Family Support, Family & Sibling Therapy, Legal Support, Mentors and Volunteers, Network of Professionals'
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

-- E2-R81 row 81
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '81|||Help finding qualified mental health providers for English-speakers'
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

-- E2-R86 row 86
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '86|||קבוצה בפייסבוק'
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

-- E2-R88 row 88
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '88|||מרכז לפסיכותרפיה אינטגרטיבית. תמיכה נפשית, רגשית ורוחנית דרך מגוון רחב של גישות ועל ידי אנשי מקצוע מוסמכים'
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

-- E2-R96 row 96
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '96|||הכוונה לטיפול הפסיכולוגי המתאים לכם וסבסוד טיפולים'
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

-- E2-R101 row 101
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '101|||אפליקציה חינמית המספקת עזרה ראשונה נפשית ותמיכה מיידית בזמן התקף חרדה, ומלווה את המשתמש עד חזרה הדרגתית לשגרה.'
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

-- E2-R102 row 102
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '102|||אפליקציה אינטראקטיבית לבניית תוכניות תרגול יומי ומעקב לאורך זמן.'
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

-- E2-R103 row 103
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '103|||אפליקציה/מדריך דיגיטלי להתמודדות עם PTSD, מטעם אגף השיקום (משרד הביטחון).'
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
    '2026-10-16-eligibility-e2',
    DATE '2026-10-16',
    'מידע פנימי — קווי סיוע, קבוצות ואינדקסים',
    'בכרטיסי קווי סיוע, קבוצות פייסבוק ואינדקסים שלא היו להם תנאי התאמה, נוסף מידע פנימי לפי הטקסט שבכרטיס. איפה שהאזור הוא כל הארץ סומן «ארצי». בכרטיסים בלי תנאי נוסף שנבדקו ושאין תנאי התאמה. הטקסט שעל הכרטיס לא השתנה.',
    'data',
    ARRAY[
      '10|||קבלת סיוע נפשי מיידי',
      '11|||קו המעניק תמיכה נפשית ראשונית',
      '13|||קווי סיוע והכוונה',
      '14|||רשימת מוקדי הטיפול ומרכזי החוסן',
      '15|||מוקד סיוע רגשי-חברתי להורים ולתלמידים',
      '16|||שירותים למתמודד
אינדקס מטפלים
פורומים
ועוד ועוד',
      '18|||Provides English-speakers with access to verified mental health specialists as well as resources and information on navigating the mental health system in Israel',
      '19|||אינדקס שירותים למענה נפשי וטיפול בפוסט-טראומה',
      '20|||קו סיוע והכוונה',
      '21|||תמיכה נפשית ותעסוקתית לנפגעי טראומה ממלחמה וטרור',
      '22|||קו סיוע והכוונה',
      '24|||מוקדי סיוע
מרכז טיפול
ועוד',
      '25|||תמיכה ואוזן קשבת לבני משפחה למתמודדי נפש',
      '26|||קו ייעוץ ותמיכה - בימים א-ה בשעות 10:00-13:00 ו-16:00-22:00',
      '30|||אינדקס מטפלים (כולל פסיכיאטרים)',
      '31|||אינדקס מטפלים (כולל פסיכיאטרים)',
      '32|||אינדקס מטפלים (כולל פסיכיאטרים)',
      '33|||אינדקס פסיכיאטרים',
      '34|||אינדקס פסיכיאטרים',
      '35|||אינדקס פסיכולוגים מורשים',
      '36|||אינדקס משרד הבריאות - מהפנטים בעלי רשיון',
      '37|||אינדקס מטפלים',
      '46|||פסיכותרפיה מקוונת',
      '49|||התאגדות המטפלים הדתיים',
      '50|||אינדקס מטפלים',
      '51|||אינדקס מטפלים',
      '54|||קבוצה בפייסבוק',
      '55|||קבוצה בפייסבוק',
      '56|||קבוצה בפייסבוק',
      '57|||קבוצה בפייסבוק',
      '58|||קבוצה בפייסבוק',
      '60|||מידע, ייעוץ ותמיכה
מרכזי טיפול
מרכזי שיקום',
      '61|||מידע, ייעוץ ותמיכה',
      '76|||Crisis Support, Family Support, Family & Sibling Therapy, Legal Support, Mentors and Volunteers, Network of Professionals',
      '81|||Help finding qualified mental health providers for English-speakers',
      '86|||קבוצה בפייסבוק',
      '88|||מרכז לפסיכותרפיה אינטגרטיבית. תמיכה נפשית, רגשית ורוחנית דרך מגוון רחב של גישות ועל ידי אנשי מקצוע מוסמכים',
      '96|||הכוונה לטיפול הפסיכולוגי המתאים לכם וסבסוד טיפולים',
      '101|||אפליקציה חינמית המספקת עזרה ראשונה נפשית ותמיכה מיידית בזמן התקף חרדה, ומלווה את המשתמש עד חזרה הדרגתית לשגרה.',
      '102|||אפליקציה אינטראקטיבית לבניית תוכניות תרגול יומי ומעקב לאורך זמן.',
      '103|||אפליקציה/מדריך דיגיטלי להתמודדות עם PTSD, מטעם אגף השיקום (משרד הביטחון).'
    ],
    '{}',
    '086_directory_card_eligibility_e2.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
