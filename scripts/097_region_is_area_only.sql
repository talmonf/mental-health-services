-- Migration 097 (19 Oct 2026)
-- אזור is the place, not the street. Streets, floors, and wayfinding leave that
-- field. A street that was only in אזור moves into the notes or onto the pin.
-- An UPDATE applies only when אזור still holds the expected text, so a later
-- admin edit is not overwritten.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- Row 62: דרור. The six streets are already on the pins.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'ירושלים, בית שמש, בני ברק, אלעד, אשדוד, מודיעין עילית'
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 62
  AND COALESCE(public_fields->>'region', '') = 'ירושלים (המלך ג׳ורג׳ 16, קומה 2), בית שמש (דבורה הנביאה 16, רמה ג׳ 2), בני ברק (כהנמן 72), אלעד (בן זכאי 93), אשדוד (יהודה המכבי 15), מודיעין עילית (השל״ה 9)';

-- Row 203: תלם. The five streets are already on the pins.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'רעננה, תל אביב, ראשון לציון, אשדוד, באר שבע'
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 203
  AND COALESCE(public_fields->>'region', '') = 'רעננה: אחוזה 301. תל אביב: מנחם בגין 116, בית קלקא, קומה 3. ראשון לציון: ירושלים 12. אשדוד: הציונות 50, קומה 1. באר שבע: רגר 11, בניין 7, קומה 3';

-- Row 305: עזר מציון. No pin, so the headquarters street moves into the notes.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'מטה: בני ברק. שיקום תעסוקתי: אזור המרכז. תעסוקה נתמכת: גוש דן, חיפה והקריות, מודיעין עילית',
      'notes', CASE
        WHEN COALESCE(public_fields->>'notes', '') LIKE '%הרב רבינוב 5%' THEN public_fields->>'notes'
        ELSE rtrim(COALESCE(public_fields->>'notes', '')) || ' מטה: הרב רבינוב 5, בני ברק.'
      END
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 305
  AND COALESCE(public_fields->>'region', '') = 'מטה: הרב רבינוב 5, בני ברק. שיקום תעסוקתי: אזור המרכז. תעסוקה נתמכת: גוש דן, חיפה והקריות, מודיעין עילית';

-- Row 337: קרני שמש. The locality was never published, so אזור is empty.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', '',
      'notes', CASE
        WHEN COALESCE(public_fields->>'notes', '') LIKE '%ארז 11%' THEN public_fields->>'notes'
        ELSE rtrim(COALESCE(public_fields->>'notes', '')) || ' הכתובת שפורסמה: ארז 11, בלי שם יישוב.'
      END
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 337
  AND COALESCE(public_fields->>'region', '') = 'ארז 11; היישוב לא צוין';

-- Row 338: מרפאת עירון. The gate direction is already in the title and the notes.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'שער מנשה'
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 338
  AND COALESCE(public_fields->>'region', '') = 'שער מנשה, ליד שער בית החולים';

-- Row 345: מרכז גוני. The street stays on the pin.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'צהלה, תל אביב'
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 345
  AND COALESCE(public_fields->>'region', '') = 'ענתות 11, צהלה, תל אביב';

-- Row 347: הכח לשנות.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'ראשון לציון'
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 347
  AND COALESCE(public_fields->>'region', '') = 'יוסף לישנסקי 27, ראשון לציון';

-- Row 348: קשת רפואה.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'מבשרת ציון'
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 348
  AND COALESCE(public_fields->>'region', '') = 'צור 1, מבשרת ציון';

-- Row 349: המכון ברעות.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'תל אביב'
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 349
  AND COALESCE(public_fields->>'region', '') = 'שדרות החייל 2, תל אביב';

-- Row 351: א׳ עד ת׳. The floor moves onto the pin; אזור is the city.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'רמת השרון'
    ),
    sites = COALESCE((
      SELECT jsonb_agg(
        CASE
          WHEN site->>'address' = 'סוקולוב 48, רמת השרון'
            THEN jsonb_set(site, '{address}', to_jsonb('סוקולוב 48, קומה 4, רמת השרון'::text))
          ELSE site
        END
        ORDER BY ordinality
      )
      FROM jsonb_array_elements(sites) WITH ORDINALITY AS s(site, ordinality)
    ), sites),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 351
  AND COALESCE(public_fields->>'region', '') = 'סוקולוב 48, קומה 4, רמת השרון';

UPDATE directory_entry_locations
SET address = 'סוקולוב 48, קומה 4, רמת השרון'
WHERE row_id = 351
  AND address = 'סוקולוב 48, רמת השרון';

-- Row 352: מכון דביר. בית שמש and רעננה are not on the Jerusalem pin.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'ירושלים, בית שמש ורעננה'
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 352
  AND COALESCE(public_fields->>'region', '') = 'ירושלים (דרך בית לחם 16), בית שמש ורעננה';

-- Row 353: חוף הגליל. Place names only.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'מושב רגבה, משגב, קריית מוצקין וכרמיאל'
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 353
  AND COALESCE(public_fields->>'region', '') = 'משרדים במושב רגבה. גם משגב, קריית מוצקין וכרמיאל';

-- Row 354: תחנת העמקים. No pin, so the junction stays in the notes.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'תל יוסף',
      'notes', CASE
        WHEN COALESCE(public_fields->>'notes', '') LIKE '%צומת תל יוסף%' THEN public_fields->>'notes'
        ELSE rtrim(COALESCE(public_fields->>'notes', '')) || ' המקום: צומת תל יוסף, ליד המועצה האזורית.'
      END
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 354
  AND COALESCE(public_fields->>'region', '') = 'צומת תל יוסף, ליד המועצה האזורית';

-- Row 355: מעייני הישועה. The street is on the pin; the department and floor move into the notes.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'בני ברק',
      'notes', CASE
        WHEN COALESCE(public_fields->>'notes', '') LIKE '%קומה 1%' THEN public_fields->>'notes'
        ELSE rtrim(COALESCE(public_fields->>'notes', '')) || ' המרפאה במחלקת בריאות הנפש, קומה 1.'
      END
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 355
  AND COALESCE(public_fields->>'region', '') = 'מרכז רפואי מעייני הישועה, בני ברק, מחלקת בריאות הנפש, קומה 1';

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, term_keys, card_keys, migration)
SELECT
  '2026-10-19-region-without-street',
  DATE '2026-10-19',
  'אזור בלי כתובת',
  'בשדה האזור לא מופיעים רחוב, מספר בית או קומה. אם מה שנשאר הוא רק היישוב שכבר כתוב בכתובת, שורת האזור לא מוצגת.',
  'cards',
  '{}',
  ARRAY(
    SELECT c.card_key
    FROM directory_card_edits c
    WHERE c.row_id = ANY(ARRAY[
      62, 93, 95, 104, 108, 203, 205, 217, 219, 228, 233, 249, 250, 254,
      273, 275, 284, 286, 297, 298, 299, 300, 301, 302, 303, 305, 311, 312,
      313, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328,
      331, 333, 334, 335, 337, 338, 339, 341, 342, 345, 347, 348, 349, 351,
      352, 353, 354, 355
    ])
    ORDER BY c.row_id, c.id
  ),
  '097_region_is_area_only.sql'
WHERE NOT EXISTS (
  SELECT 1 FROM site_audit_entries WHERE entry_key = '2026-10-19-region-without-street'
);

COMMIT;
