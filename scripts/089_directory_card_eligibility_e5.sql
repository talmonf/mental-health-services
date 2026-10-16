-- Migration 089 (16 Oct 2026)
-- Eligibility for batch E5, from docs/card-eligibility-2026-10.md, approved by the site owner.
-- Each UPDATE applies only while every condition is still «ללא הגבלה», so a later admin edit is kept.
-- Public card text and public_edited_at are left unchanged.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- E5-R200 row 200
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide","presenting_problems":["תקיפה מינית"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי; קשיים: תקיפה מינית.', E'\n ')),
    updated_at = now()
WHERE card_key = '200|||קווי המענה הארציים של ארגון הגג למרכזי הסיוע'
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

-- E5-R201 row 201
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"regions","regions":["השפלה מורחבת"],"presenting_problems":["תקיפה מינית"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: אזורים: השפלה מורחבת; קשיים: תקיפה מינית.', E'\n ')),
    updated_at = now()
WHERE card_key = '201|||סיוע וליווי, חינוך ומניעה, קבוצות תמיכה (פרונטלי וזום)'
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

-- E5-R202 row 202
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '202|||מידע, הכשרות, מוקדי חוסן ושותפות ארצית בטראומה וחוסן (Israel Trauma Coalition)'
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

-- E5-R203 row 203
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '203|||רשת ארצית לטיפול פסיכולוגי, אבחון והכשרה — כולל טיפול בטראומה ובמצוקה נפשית.'
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

-- E5-R206 row 206
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '206|||מודל נשימה — טיפול מסובסד, רשת מטפלים לטראומה מורכבת וגישת גוף–נפש קהילתית.'
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

-- E5-R207 row 207
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '207|||עמותת בני ובנות משפחה של מתמודדי/ות נפש בישראל. מטרת העמותה היא לפעול למען המתמודדים ולמען משפחותיהם למימוש ולהרחבת זכויות, לטיפול מיטבי, להכלה ולשיקום בקהילה ולהסברה בקרב מקבלי החלטות, בקרב הממסד ובקרב הציבור.'
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

-- E5-R208 row 208
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '208|||מנחה ומלווה משפחות למתמודדי נפש'
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

-- E5-R209 row 209
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '209|||חוברת מענים פסיכוסוציאליים — מדריך מרוכז למלחמת חרבות ברזל'
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

-- E5-R213 row 213
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '213|||עזרה ראשונה נפשית לנפגעי חרבות ברזל — עד 10 מפגשים'
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

-- E5-R215 row 215
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '215|||סיוע נפשי ללא עלות לאנשי קבע ומשפחותיהם'
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

-- E5-R217 row 217
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"regions","regions":["תל אביב"],"presenting_problems":["פוסט-טראומה"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: אזורים: תל אביב; קשיים: פוסט-טראומה.', E'\n ')),
    updated_at = now()
WHERE card_key = '217|||קליניקה לטיפול בפוסט-טראומה (מילואים/משוחררים — תשלום סמלי)'
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

-- E5-R219 row 219
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"regions","regions":["יזרעאל","מגידו","גלבוע","עמק המעיינות","בית שאן ועפולה"],"presenting_problems":["פוסט-טראומה"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: אזורים: יזרעאל, מגידו, גלבוע, עמק המעיינות, בית שאן ועפולה; קשיים: פוסט-טראומה.', E'\n ')),
    updated_at = now()
WHERE card_key = '219|||תוכנית טיפול לפוסט-טראומה — מושב משק פרזון (רישום מוקדם)'
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

-- E5-R220 row 220
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide","presenting_problems":["פוסט-טראומה"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי; קשיים: פוסט-טראומה.', E'\n ')),
    updated_at = now()
WHERE card_key = '220|||CBT זוגי במחקר — 15 מפגשים בזום'
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

-- E5-R223 row 223
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '223|||סיוע מקצועי לנפגעים בצה"ל ולבני משפחותיהם'
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

-- E5-R224 row 224
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '224|||רשת מטפלים מוסמכים לחיילים ומילואים — עד 10 מפגשים מסובסדים'
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

-- E5-R225 row 225
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '225|||טיפול נפשי ללוחמי גזית/שריון (חטיבה 188) — ללא תשלום'
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

-- E5-R231 row 231
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '231|||ייעוץ והפניה — חברתי-ביטחוני'
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

-- E5-R232 row 232
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '232|||מאגר תחנות לטיפול זוגי'
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

-- E5-R233 row 233
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"regions","regions":["הרצליה"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: אזורים: הרצליה.', E'\n ')),
    updated_at = now()
WHERE card_key = '233|||סיוע וטיפול לשורדי המסיבות בנובה — הרצליה'
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

-- E5-R234 row 234
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '234|||טיפול עומק לפצועי נובה — לפחות 24 מפגשים'
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

-- E5-R235 row 235
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"regions","regions":["צור משה (שרון)"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: אזורים: צור משה (שרון).', E'\n ')),
    updated_at = now()
WHERE card_key = '235|||טיפול ממוקד בטראומה לשורדי מסיבות — מרכז רפואי + מסיבות בדרום'
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

-- E5-R236 row 236
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '236|||מידע, סיוע והכוונה — 24/7'
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

-- E5-R237 row 237
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '237|||טיפול לבני זוג שאיבדו בן/בת במהלך שירות (מלחמה, תאונה, מחלה, התאבדות)'
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

-- E5-R239 row 239
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '239|||טיפול פרטני, זוגי, משפחתי וייעוץ פסיכיאטרי'
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

-- E5-R240 row 240
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '240|||קישורים למטה להגנה, על"ם, מצמיחים, בית בטוח לנוער, נע"ן, עמותת ל.מ.ה, עמ"י ועוד'
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

-- E5-R241 row 241
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":6,"age_max":18,"location_mode":"regions","regions":["עמק יזרעאל"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: גיל 6–18; אזורים: עמק יזרעאל.', E'\n ')),
    updated_at = now()
WHERE card_key = '241|||טיפול משפחתי אינטנסיבי לילדים 6-18'
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

-- E5-R242 row 242
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '242|||קו סיוע וקישורים — להט"ב, הורים, דתיים, נוער'
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

-- E5-R243 row 243
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '243|||3 שיחות טיפוליות מקוונות ללא עלות'
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

-- E5-R244 row 244
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '244|||מידע, זכויות ואיתור ספקי שירות בסל שיקום'
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

-- E5-R245 row 245
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '245|||שירותי אמבולנס ללא תשלום להסעת חולים, נכים ומוגבלים לטיפולים, בדיקות ושמחות'
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

-- E5-R246 row 246
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '246|||שירותי אמבולנס להסעת חולים, נכים ומוגבלים לטיפולים, בדיקות ואירועים משפחתיים'
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

-- E5-R247 row 247
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '247|||טיפול בהתמכרויות התנהגותיות (מין, פורנו, הימורים, אוכל, קשרים, מסכים) ותמיכה מערכתית לבני משפחה ובני זוג — טיפול, קבוצות ותוכנית 12 הצעדים'
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

-- E5-R248 row 248
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '248|||טיפול בנפגעי אלכוהול, הימורים והתמכרויות התנהגותיות נוספות — למכורים ולבני משפחותיהם; הסברה ומניעה'
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

-- E5-R249 row 249
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"regions","regions":["בית שמש","גבעת שמש"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: אזורים: בית שמש, גבעת שמש.', E'\n ')),
    updated_at = now()
WHERE card_key = '249|||אשפוזית, טיפול יום וקהילות טיפוליות לגמילה ושיקום; מותאם גם לאוכלוסייה דתית וחרדית; מפוקח ע״י משרדי הבריאות והרווחה'
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

-- E5-R251 row 251
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '251|||קבוצות עזרה עצמית אנונימיות (12 צעדים) למשפחות וחברים של מכורים לסמים'
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

-- E5-R252 row 252
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '252|||קבוצות תמיכה אנונימיות (12 צעדים) למשפחות וחברים של אנשים הסובלים מאלכוהוליזם — פרונטלי וזום'
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

-- E5-R253 row 253
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '253|||קבוצות עזרה עצמית אנונימיות (12 צעדים) לאנשים הסובלים מבעיית שתייה'
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

-- E5-R254 row 254
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"regions","regions":["גלבוע"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: אזורים: גלבוע.', E'\n ')),
    updated_at = now()
WHERE card_key = '254|||כפר ומרכז לטיפול בהתמכרויות — גמילה פיזית, קהילות טיפוליות לנוער/צעירים/בגירים/נשים; בפיקוח משרדי הרווחה והבריאות'
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

-- E5-R255 row 255
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '255|||מפה ומאגר מענים טיפוליים ונפשיים בישראל לילדים, נוער ומבוגרים'
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

-- E5-R256 row 256
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '256|||איתור, ליווי וטיפול בנוער וצעירים במצבי סיכון — בקהילה, ברחוב ובמרחב הדיגיטלי'
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

-- E5-R257 row 257
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '257|||ייעוץ וטיפול לנוער וצעירים עד גיל 24 ולהוריהם בנושאי סמים, אלכוהול והתמכרויות'
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

-- E5-R258 row 258
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_max":21,"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: גיל עד 21; מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '258|||תנועת נוער משלבת לילדים עם ובלי צרכים מיוחדים — שילוב חברתי מלא ושוויוני'
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

-- E5-R259 row 259
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '259|||תנועת נוער וצעירים להט"ב — קבוצות חברתיות ותמיכה בעשרות יישובים'
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

-- E5-R260 row 260
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '260|||הסברה וסדנאות בבתי ספר ובמסגרות נוער למניעת להט"בופוביה ולתמיכה בנוער להט"ב'
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

-- E5-R261 row 261
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '261|||מניעת אובדנות ותמיכה במשפחות שכולות לאחר התאבדות או מוות פתאומי'
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

-- E5-R262 row 262
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '262|||פורום ארצי של בני משפחה של מתמודדי נפש — תמיכה, מיצוי זכויות, סנגור והפחתת סטיגמה'
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

-- E5-R263 row 263
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '263|||פורום משפחות המתמודדות עם הפרעות אכילה — קבוצות תמיכה, מידע על זכויות וסנגור'
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

-- E5-R264 row 264
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '264|||מידע לציבור ולמשפחות, מפת מסגרות טיפול ואינדקס מטפלים בהפרעות אכילה'
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

-- E5-R265 row 265
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide","diagnoses":["אוטיזם"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי; אבחנות: אוטיזם.', E'\n ')),
    updated_at = now()
WHERE card_key = '265|||ליווי ילדים ובוגרים על הרצף האוטיסטי ומשפחותיהם — זכויות, מרכזי משפחה ותמיכה'
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

-- E5-R266 row 266
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"regions","regions":["גליל עליון","קריית שמונה"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: אזורים: גליל עליון, קריית שמונה.', E'\n ')),
    updated_at = now()
WHERE card_key = '266|||מרכז רב-תחומי לייעוץ, טיפול וחינוך בקהילה — ילדים, מתבגרים ומבוגרים; כולל יחידת קשב'
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

-- E5-R267 row 267
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '267|||דיווח ומענה 24/7 על פגיעות, בריונות, סחיטה ופשיעה נגד ילדים ונוער במרחב המקוון'
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

-- E5-R271 row 271
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"regions","regions":["תל אביב","חיפה"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: אזורים: תל אביב, חיפה.', E'\n ')),
    updated_at = now()
WHERE card_key = '271|||מרפאה פסיכיאטרית מקבוצת Stella Israel: עירוי קטמין במינון נמוך בהשגחה רפואית לדיכאון, חרדה ופוסט־טראומה.'
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

-- E5-R272 row 272
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"regions","regions":["Jerusalem"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: אזורים: Jerusalem.', E'\n ')),
    updated_at = now()
WHERE card_key = '272|||Ketamine-assisted psychotherapy in Jerusalem: psychiatrist and KAP therapist (mainly IM ketamine with preparation and integration) for treatment-resistant depression, PTSD and anxiety.'
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

-- E5-R274 row 274
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"regions","regions":["שרון","תל אביב"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: אזורים: שרון, תל אביב.', E'\n ')),
    updated_at = now()
WHERE card_key = '274|||השתלת קוצב המגרה את עצב הואגוס לדיכאון קשה עמיד לטיפול. בישראל: הערכה ביחידה לגרייה מוחית בלב השרון; ההשתלה בנוירוכירורגיה תפקודית באיכילוב. מוגבל, דורש הפניה פסיכיאטרית.'
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

-- E5-R275 row 275
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"regions","regions":["חיפה"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: אזורים: חיפה.', E'\n ')),
    updated_at = now()
WHERE card_key = '275|||הליך נוירוכירורגי להשתלת אלקטרודות וקוצב מוחי במקרי OCD חמורים ועמידים לטיפול. ניתן במספר מרכזים בודדים (למשל רמב"ם). אינו בסל הבריאות; רק באישור מיוחד של משרד הבריאות או במחקר.'
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

-- E5-R276 row 276
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '276|||ייעוץ הלכתי ורוחני למתמודדים ולבני משפחה — רבנים ורבניות שעברו הכשרה בבריאות הנפש (לא טיפול קליני)'
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

-- E5-R277 row 277
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '277|||קבוצה בפייסבוק'
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

-- E5-R278 row 278
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '278|||שירותי סל שיקום'
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

-- E5-R281 row 281
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '281|||שיקום לנכי צה"ל ונפגעי פעולות איבה — מרכז החממה ותכנית תושייה למשפחות הלומי קרב'
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

-- E5-R289 row 289
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":13,"age_max":22,"sex":"female","location_mode":"regions","regions":["ראשון לציון"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: גיל 13–22; מין נקבה; אזורים: ראשון לציון.', E'\n ')),
    updated_at = now()
WHERE card_key = '289|||רשת הוסטלים לנערות וצעירות במצבי סיכון — ראשון לציון; גישה מודעת טראומה'
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

-- E5-R290 row 290
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"sex":"female"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מין נקבה.', E'\n ')),
    updated_at = now()
WHERE card_key = '290|||קליניקה לטיפול בנשים ובנערות — פסיכותרפיה, פגיעות מיניות, הפרעות אכילה, דיכאון אחרי לידה ואלימות ביחסים'
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

-- E5-R294 row 294
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '294|||הכוונה וליווי למציאת מענה בפסיכיאטריה ובריאות הנפש'
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

-- E5-R296 row 296
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '296|||תעסוקה נתמכת, מועדון חברתי באשקלון, מכינת הד, דיור מוגן לבודדים / ליווי, וסייעים בחינוך'
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

-- E5-R304 row 304
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '304|||הסבר על השירות, וטבלאות מרכזים שאין להם כרטיס נפרד'
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

-- E5-R306 row 306
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '306|||סל שיקום, דיור, תעסוקה וסיוע להורים מתמודדים'
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

-- E5-R308 row 308
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '308|||רשימת מרכזי הייעוץ למשפחות בקהילה ובבתי החולים'
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
    '2026-10-16-eligibility-e5',
    DATE '2026-10-16',
    'מידע פנימי — כרטיסים משורה 200',
    'בכרטיסים משורה 200 ומעלה שלא היו להם תנאי התאמה, נוסף מידע פנימי לפי הטקסט שבכרטיס: אזור, גיל, מין, אבחנה או קושי, איפה שהטקסט אומר זאת. בכרטיסים בלי תנאי נוסף שנבדקו ושאין תנאי התאמה. הטקסט שעל הכרטיס לא השתנה.',
    'data',
    ARRAY[
      '200|||קווי המענה הארציים של ארגון הגג למרכזי הסיוע',
      '201|||סיוע וליווי, חינוך ומניעה, קבוצות תמיכה (פרונטלי וזום)',
      '202|||מידע, הכשרות, מוקדי חוסן ושותפות ארצית בטראומה וחוסן (Israel Trauma Coalition)',
      '203|||רשת ארצית לטיפול פסיכולוגי, אבחון והכשרה — כולל טיפול בטראומה ובמצוקה נפשית.',
      '206|||מודל נשימה — טיפול מסובסד, רשת מטפלים לטראומה מורכבת וגישת גוף–נפש קהילתית.',
      '207|||עמותת בני ובנות משפחה של מתמודדי/ות נפש בישראל. מטרת העמותה היא לפעול למען המתמודדים ולמען משפחותיהם למימוש ולהרחבת זכויות, לטיפול מיטבי, להכלה ולשיקום בקהילה ולהסברה בקרב מקבלי החלטות, בקרב הממסד ובקרב הציבור.',
      '208|||מנחה ומלווה משפחות למתמודדי נפש',
      '209|||חוברת מענים פסיכוסוציאליים — מדריך מרוכז למלחמת חרבות ברזל',
      '213|||עזרה ראשונה נפשית לנפגעי חרבות ברזל — עד 10 מפגשים',
      '215|||סיוע נפשי ללא עלות לאנשי קבע ומשפחותיהם',
      '217|||קליניקה לטיפול בפוסט-טראומה (מילואים/משוחררים — תשלום סמלי)',
      '219|||תוכנית טיפול לפוסט-טראומה — מושב משק פרזון (רישום מוקדם)',
      '220|||CBT זוגי במחקר — 15 מפגשים בזום',
      '223|||סיוע מקצועי לנפגעים בצה"ל ולבני משפחותיהם',
      '224|||רשת מטפלים מוסמכים לחיילים ומילואים — עד 10 מפגשים מסובסדים',
      '225|||טיפול נפשי ללוחמי גזית/שריון (חטיבה 188) — ללא תשלום',
      '231|||ייעוץ והפניה — חברתי-ביטחוני',
      '232|||מאגר תחנות לטיפול זוגי',
      '233|||סיוע וטיפול לשורדי המסיבות בנובה — הרצליה',
      '234|||טיפול עומק לפצועי נובה — לפחות 24 מפגשים',
      '235|||טיפול ממוקד בטראומה לשורדי מסיבות — מרכז רפואי + מסיבות בדרום',
      '236|||מידע, סיוע והכוונה — 24/7',
      '237|||טיפול לבני זוג שאיבדו בן/בת במהלך שירות (מלחמה, תאונה, מחלה, התאבדות)',
      '239|||טיפול פרטני, זוגי, משפחתי וייעוץ פסיכיאטרי',
      '240|||קישורים למטה להגנה, על"ם, מצמיחים, בית בטוח לנוער, נע"ן, עמותת ל.מ.ה, עמ"י ועוד',
      '241|||טיפול משפחתי אינטנסיבי לילדים 6-18',
      '242|||קו סיוע וקישורים — להט"ב, הורים, דתיים, נוער',
      '243|||3 שיחות טיפוליות מקוונות ללא עלות',
      '244|||מידע, זכויות ואיתור ספקי שירות בסל שיקום',
      '245|||שירותי אמבולנס ללא תשלום להסעת חולים, נכים ומוגבלים לטיפולים, בדיקות ושמחות',
      '246|||שירותי אמבולנס להסעת חולים, נכים ומוגבלים לטיפולים, בדיקות ואירועים משפחתיים',
      '247|||טיפול בהתמכרויות התנהגותיות (מין, פורנו, הימורים, אוכל, קשרים, מסכים) ותמיכה מערכתית לבני משפחה ובני זוג — טיפול, קבוצות ותוכנית 12 הצעדים',
      '248|||טיפול בנפגעי אלכוהול, הימורים והתמכרויות התנהגותיות נוספות — למכורים ולבני משפחותיהם; הסברה ומניעה',
      '249|||אשפוזית, טיפול יום וקהילות טיפוליות לגמילה ושיקום; מותאם גם לאוכלוסייה דתית וחרדית; מפוקח ע״י משרדי הבריאות והרווחה',
      '251|||קבוצות עזרה עצמית אנונימיות (12 צעדים) למשפחות וחברים של מכורים לסמים',
      '252|||קבוצות תמיכה אנונימיות (12 צעדים) למשפחות וחברים של אנשים הסובלים מאלכוהוליזם — פרונטלי וזום',
      '253|||קבוצות עזרה עצמית אנונימיות (12 צעדים) לאנשים הסובלים מבעיית שתייה',
      '254|||כפר ומרכז לטיפול בהתמכרויות — גמילה פיזית, קהילות טיפוליות לנוער/צעירים/בגירים/נשים; בפיקוח משרדי הרווחה והבריאות',
      '255|||מפה ומאגר מענים טיפוליים ונפשיים בישראל לילדים, נוער ומבוגרים',
      '256|||איתור, ליווי וטיפול בנוער וצעירים במצבי סיכון — בקהילה, ברחוב ובמרחב הדיגיטלי',
      '257|||ייעוץ וטיפול לנוער וצעירים עד גיל 24 ולהוריהם בנושאי סמים, אלכוהול והתמכרויות',
      '258|||תנועת נוער משלבת לילדים עם ובלי צרכים מיוחדים — שילוב חברתי מלא ושוויוני',
      '259|||תנועת נוער וצעירים להט"ב — קבוצות חברתיות ותמיכה בעשרות יישובים',
      '260|||הסברה וסדנאות בבתי ספר ובמסגרות נוער למניעת להט"בופוביה ולתמיכה בנוער להט"ב',
      '261|||מניעת אובדנות ותמיכה במשפחות שכולות לאחר התאבדות או מוות פתאומי',
      '262|||פורום ארצי של בני משפחה של מתמודדי נפש — תמיכה, מיצוי זכויות, סנגור והפחתת סטיגמה',
      '263|||פורום משפחות המתמודדות עם הפרעות אכילה — קבוצות תמיכה, מידע על זכויות וסנגור',
      '264|||מידע לציבור ולמשפחות, מפת מסגרות טיפול ואינדקס מטפלים בהפרעות אכילה',
      '265|||ליווי ילדים ובוגרים על הרצף האוטיסטי ומשפחותיהם — זכויות, מרכזי משפחה ותמיכה',
      '266|||מרכז רב-תחומי לייעוץ, טיפול וחינוך בקהילה — ילדים, מתבגרים ומבוגרים; כולל יחידת קשב',
      '267|||דיווח ומענה 24/7 על פגיעות, בריונות, סחיטה ופשיעה נגד ילדים ונוער במרחב המקוון',
      '271|||מרפאה פסיכיאטרית מקבוצת Stella Israel: עירוי קטמין במינון נמוך בהשגחה רפואית לדיכאון, חרדה ופוסט־טראומה.',
      '272|||Ketamine-assisted psychotherapy in Jerusalem: psychiatrist and KAP therapist (mainly IM ketamine with preparation and integration) for treatment-resistant depression, PTSD and anxiety.',
      '274|||השתלת קוצב המגרה את עצב הואגוס לדיכאון קשה עמיד לטיפול. בישראל: הערכה ביחידה לגרייה מוחית בלב השרון; ההשתלה בנוירוכירורגיה תפקודית באיכילוב. מוגבל, דורש הפניה פסיכיאטרית.',
      '275|||הליך נוירוכירורגי להשתלת אלקטרודות וקוצב מוחי במקרי OCD חמורים ועמידים לטיפול. ניתן במספר מרכזים בודדים (למשל רמב"ם). אינו בסל הבריאות; רק באישור מיוחד של משרד הבריאות או במחקר.',
      '276|||ייעוץ הלכתי ורוחני למתמודדים ולבני משפחה — רבנים ורבניות שעברו הכשרה בבריאות הנפש (לא טיפול קליני)',
      '277|||קבוצה בפייסבוק',
      '278|||שירותי סל שיקום',
      '281|||שיקום לנכי צה"ל ונפגעי פעולות איבה — מרכז החממה ותכנית תושייה למשפחות הלומי קרב',
      '289|||רשת הוסטלים לנערות וצעירות במצבי סיכון — ראשון לציון; גישה מודעת טראומה',
      '290|||קליניקה לטיפול בנשים ובנערות — פסיכותרפיה, פגיעות מיניות, הפרעות אכילה, דיכאון אחרי לידה ואלימות ביחסים',
      '294|||הכוונה וליווי למציאת מענה בפסיכיאטריה ובריאות הנפש',
      '296|||תעסוקה נתמכת, מועדון חברתי באשקלון, מכינת הד, דיור מוגן לבודדים / ליווי, וסייעים בחינוך',
      '304|||הסבר על השירות, וטבלאות מרכזים שאין להם כרטיס נפרד',
      '306|||סל שיקום, דיור, תעסוקה וסיוע להורים מתמודדים',
      '308|||רשימת מרכזי הייעוץ למשפחות בקהילה ובבתי החולים'
    ],
    '{}',
    '089_directory_card_eligibility_e5.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
