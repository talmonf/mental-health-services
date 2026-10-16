-- Migration 088 (16 Oct 2026)
-- Eligibility for batch E4, from docs/card-eligibility-2026-10.md, approved by the site owner.
-- Each UPDATE applies only while every condition is still «ללא הגבלה», so a later admin edit is kept.
-- Public card text and public_edited_at are left unchanged.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- E4-R17 row 17
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '17|||'
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

-- E4-R30 row 30
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '30|||רשימת מרכזי חוסן ברחבי הארץ'
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

-- E4-R40 row 40
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '40|||צוות משבר (חלופה לחדר מיון)'
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

-- E4-R45 row 45
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":12,"age_max":35}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: גיל 12–35.', E'\n ')),
    updated_at = now()
WHERE card_key = '45|||הקול שבפנים – טיפול ביתי לצעירים במצבי משבר נפשי'
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

-- E4-R64 row 64
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '64|||קבוצה חברתית לנערים ונערות מתמודדי ומתמודדות נפש דתיים ודתלשים'
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

-- E4-R68 row 68
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"regions","regions":["בני ברק","פתח תקווה","אלעד","ראש העין","מודיעין עילית","ביתר","ירושלים","בית שמש","חיפה"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: אזורים: בני ברק, פתח תקווה, אלעד, ראש העין, מודיעין עילית, ביתר, ירושלים, בית שמש, חיפה.', E'\n ')),
    updated_at = now()
WHERE card_key = '68|||סיוע למשפחות של מתמודדי נפש'
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

-- E4-R69 row 69
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '69|||טיפול משפחתי-מערכתי למצבי משבר'
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

-- E4-R72 row 72
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '72|||תמיכה בילדים ונוער המטופלים במרכזי בריאות הנפש'
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

-- E4-R77 row 77
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '77|||Israel''s Emergency Mental Health Resources During War - Comprehensive list of mental health resources'
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

-- E4-R80 row 80
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '80|||Clinical case management for English-speakers in Israel from all walks of life: counseling, referrals to therapists, treatment programs, guidance through the legal process'
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

-- E4-R83 row 83
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '83|||הסעות חולים, אמבולנסים לצרכים רפואיים ואירועים משפחתיים, נהגים מתנדבים'
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

-- E4-R84 row 84
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק — אין תנאי התאמה.', E'\n ')),
    updated_at = now()
WHERE card_key = '84|||סיוע באמבולנסים בהעברת חולים ונכים'
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

-- E4-R92 row 92
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"regions","regions":["Jerusalem"]}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: אזורים: Jerusalem.', E'\n ')),
    updated_at = now()
WHERE card_key = '92|||דיכאון אחרי לידה ועוד, דרך טיפת חלב בירושלים
Support and treatment for Maternal Mental Health through Tipat Halav. Services for mothers and families impacted by perinatal mental health disorders (PMHD) such as postpartum depression'
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

-- E4-R96 row 96
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"nationwide"}'::jsonb)
    || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: נבדק מול הטקסט בכרטיס. התאמה: מיקום ארצי.', E'\n ')),
    updated_at = now()
WHERE card_key = '96|||הכוונה לטיפול הפסיכולוגי המתאים לכם, סבסוד טיפולים, חוסן משפחתי. שינוי מפת ההתמודדות המשפחתית והקהילתית במצבי מצוקה אישיים ומשפחתיים.'
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
    '2026-10-16-eligibility-e4',
    DATE '2026-10-16',
    'מידע פנימי — טראומה, נוער ומשפחות',
    'בכרטיסי טראומה, נוער, משפחות וקהילות שלא היו להם תנאי התאמה, נוסף מידע פנימי לפי הטקסט שבכרטיס: אזור, ובמקום שהטקסט מציין גם גיל. בכרטיסים בלי תנאי נוסף שנבדקו ושאין תנאי התאמה. הטקסט שעל הכרטיס לא השתנה.',
    'data',
    ARRAY[
      '17|||',
      '30|||רשימת מרכזי חוסן ברחבי הארץ',
      '40|||צוות משבר (חלופה לחדר מיון)',
      '45|||הקול שבפנים – טיפול ביתי לצעירים במצבי משבר נפשי',
      '64|||קבוצה חברתית לנערים ונערות מתמודדי ומתמודדות נפש דתיים ודתלשים',
      '68|||סיוע למשפחות של מתמודדי נפש',
      '69|||טיפול משפחתי-מערכתי למצבי משבר',
      '72|||תמיכה בילדים ונוער המטופלים במרכזי בריאות הנפש',
      '77|||Israel''s Emergency Mental Health Resources During War - Comprehensive list of mental health resources',
      '80|||Clinical case management for English-speakers in Israel from all walks of life: counseling, referrals to therapists, treatment programs, guidance through the legal process',
      '83|||הסעות חולים, אמבולנסים לצרכים רפואיים ואירועים משפחתיים, נהגים מתנדבים',
      '84|||סיוע באמבולנסים בהעברת חולים ונכים',
      '92|||דיכאון אחרי לידה ועוד, דרך טיפת חלב בירושלים
Support and treatment for Maternal Mental Health through Tipat Halav. Services for mothers and families impacted by perinatal mental health disorders (PMHD) such as postpartum depression',
      '96|||הכוונה לטיפול הפסיכולוגי המתאים לכם, סבסוד טיפולים, חוסן משפחתי. שינוי מפת ההתמודדות המשפחתית והקהילתית במצבי מצוקה אישיים ומשפחתיים.'
    ],
    '{}',
    '088_directory_card_eligibility_e4.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
