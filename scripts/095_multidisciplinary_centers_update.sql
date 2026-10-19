-- Migration 095 (19 Oct 2026)
-- The multidisciplinary-centers spreadsheet was checked again on 19.10.2026.
-- MindMe (row 104) joins the term list. דרור (62), תלם (203), and תחנת העמקים (354)
-- get the updated addresses and team notes. Row 62 is matched by row_id: its card_key
-- still contains a line break.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- Row 104: מיינדמי. Keep the address, the phone hours, the pin, and the private cost.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'notes', 'כתובת: מנחם בגין 148, תל אביב. מענה טלפוני בימים א׳-ה׳ 09:00-19:00. בצוות ארבעה פסיכיאטרים, פסיכולוגים, פסיכותרפיסטית CBT, עובדים סוציאליים קליניים ודיאטנית קלינית. החזר מביטוח או מקופת חולים לא צוין באתר.'
    ),
    eligibility = COALESCE(eligibility, '{}'::jsonb) || jsonb_build_object(
      'internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '19.10.2026: נבדק מול https://mindme.co.il/ . נוסף לרשימת המרכזים הרב-צוותיים. הצוות: ארבעה פסיכיאטרים, פסיכולוגים, פסיכותרפיסטית CBT, עובדים סוציאליים קליניים ודיאטנית קלינית. למבוגרים. פרטי. החזר מביטוח או מקופה לא צוין באתר.', E'\n ')
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 104
  AND COALESCE(public_fields->>'target', '') = 'מבוגרים'
  AND COALESCE(public_fields->>'notes', '') = 'כתובת: מנחם בגין 148, תל אביב. מענה טלפוני בימים א׳-ה׳ 09:00-19:00.';

INSERT INTO glossary_card_links (term_key, card_key, status, matched_text)
SELECT 'multidisciplinary_center', c.card_key, 'approved', 'מיינדמי (MindMe)'
FROM directory_card_edits c
WHERE c.row_id = 104
ON CONFLICT (term_key, card_key) DO UPDATE SET
  status = 'approved',
  reviewed_at = now()
WHERE glossary_card_links.status IS DISTINCT FROM 'rejected';

-- Row 62: מרפאות דרור. Six clinics on the דרור page. Pins for Jerusalem, Ashdod,
-- and Modiin Illit are new. Beit Shemesh, Bnei Brak, and Elad stay where they are.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'ירושלים (המלך ג׳ורג׳ 16, קומה 2), בית שמש (דבורה הנביאה 16, רמה ג׳ 2), בני ברק (כהנמן 72), אלעד (בן זכאי 93), אשדוד (יהודה המכבי 15), מודיעין עילית (השל״ה 9)',
      'notes', 'מיועד בעיקר למגזר הדתי-חרדי. בדף הבית מצוינות 11 מרפאות, ובדף «דרור» מפורטות שש. בכל שש המרפאות יש פסיכיאטר ועובדים סוציאליים קליניים. פסיכולוגים קליניים יש בכולן חוץ מבית שמש. יש תוכנית Navigate לצעירים אחרי אפיזודה פסיכוטית ראשונה, ותוכניות לנפגעי טראומה מינית: «בליבנו» לילדים ו«בנפשנו» למבוגרים.'
    ),
    sites = COALESCE(sites, '[]'::jsonb) || jsonb_build_array(
      jsonb_build_object('label', 'מרפאת ירושלים', 'address', 'המלך ג׳ורג׳ 16, קומה 2, ירושלים', 'lat', 31.7819878, 'lng', 35.2164111, 'phone', '', 'email', '', 'sort_order', 3),
      jsonb_build_object('label', 'מרפאת אשדוד', 'address', 'יהודה המכבי 15, אשדוד', 'lat', 31.7965898, 'lng', 34.6574963, 'phone', '', 'email', '', 'sort_order', 4),
      jsonb_build_object('label', 'מרפאת מודיעין עילית', 'address', 'השל״ה 9, מודיעין עילית', 'lat', 31.9311619, 'lng', 35.0389516, 'phone', '', 'email', '', 'sort_order', 5)
    ),
    eligibility = COALESCE(eligibility, '{}'::jsonb) || jsonb_build_object(
      'internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '19.10.2026: נבדק מול דף דרור. בדף הבית 11 מרפאות, בדף דרור שש. אופקים ירד מהרשימה. נוספו סיכות לירושלים (המלך ג׳ורג׳ 16), אשדוד (יהודה המכבי 15) ומודיעין עילית. הסיכה במודיעין עילית על הרחוב, כי מספר הבית לא נמצא במפה. בקישור המפה באתר בני ברק מופיע כהנמן 111; הסיכה נשארה על כהנמן 72.', E'\n ')
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 62
  AND COALESCE(public_fields->>'region', '') = 'ירושלים, בית שמש, בני ברק, אלעד, מודיעין עילית, אשדוד ואופקים'
  AND COALESCE(public_fields->>'cost', '') = 'הסדר עם כל קופות החולים. עלות למטופל לא צוינה באתר.'
  AND COALESCE(public_fields->>'notes', '') = 'מיועד בעיקר למגזר הדתי-חרדי. בצוות פסיכיאטרים, פסיכולוגים ועובדים סוציאליים קליניים, וגם מאבחנים ויועצים. יש מרכזי טיפול לנפגעי ולנפגעות טראומה מינית מהמגזר הדתי-חרדי. משרדי העמותה: כהנמן 72, בני ברק.';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c
JOIN (VALUES
  ('מרפאת ירושלים', 'המלך ג׳ורג׳ 16, קומה 2, ירושלים', 31.7819878::float8, 35.2164111::float8, 3),
  ('מרפאת אשדוד', 'יהודה המכבי 15, אשדוד', 31.7965898::float8, 34.6574963::float8, 4),
  ('מרפאת מודיעין עילית', 'השל״ה 9, מודיעין עילית', 31.9311619::float8, 35.0389516::float8, 5)
) AS v(label, address, lat, lng, sort_order) ON true
WHERE c.row_id = 62
  AND c.entry_id IS NOT NULL
  AND COALESCE(c.public_fields->>'region', '') = 'ירושלים (המלך ג׳ורג׳ 16, קומה 2), בית שמש (דבורה הנביאה 16, רמה ג׳ 2), בני ברק (כהנמן 72), אלעד (בן זכאי 93), אשדוד (יהודה המכבי 15), מודיעין עילית (השל״ה 9)'
ON CONFLICT (row_id, label) DO NOTHING;

-- The original seed pin for row 62 is a city point in Bnei Brak. The street pin is מרפאת בני ברק.
DELETE FROM directory_entry_locations
WHERE row_id = 62
  AND label = 'בני ברק'
  AND address = 'מרפאות בית חם, בני ברק';

-- Row 203, reviewed text: five branches, psychiatrist only in Ra'anana and Tel Aviv.
-- Payment is not on the organization site, so the «קשר» price comes off the card.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'רעננה: אחוזה 301. תל אביב: מנחם בגין 116, בית קלקא, קומה 3. ראשון לציון: ירושלים 12. אשדוד: הציונות 50, קומה 1. באר שבע: רגר 11, בניין 7, קומה 3',
      'cost', '',
      'notes', 'תלם מפעילה את שיחות התמיכה הטלפוניות של מכבי (*3028) ושל לאומית (072-2000272). פרטים בכרטיס [קווי התמיכה של קופות החולים](https://nefesh-il.org/support?entry=243&section=trauma). פסיכיאטר מצוין רק בסניפי רעננה ותל אביב. בראשון לציון, באשדוד ובבאר שבע לא צוין. בצוות פסיכולוגים קליניים, חינוכיים, התפתחותיים ורפואיים, ועובדים סוציאליים קליניים ברעננה ובראשון לציון, וגם מטפלים זוגיים ומשפחתיים ומטפלים בהבעה ויצירה. מי משלם לא צוין באתר.'
    ),
    sites = COALESCE(sites, '[]'::jsonb) || jsonb_build_array(
      jsonb_build_object('label', 'תל אביב', 'address', 'מנחם בגין 116, בית קלקא, קומה 3, תל אביב', 'lat', 32.0712913, 'lng', 34.7898440, 'phone', '', 'email', '', 'sort_order', 1),
      jsonb_build_object('label', 'ראשון לציון', 'address', 'ירושלים 12, ראשון לציון', 'lat', 31.9626937, 'lng', 34.8161832, 'phone', '03-6097373', 'email', '', 'sort_order', 2),
      jsonb_build_object('label', 'אשדוד', 'address', 'הציונות 50, קומה 1, אשדוד', 'lat', 31.7863462, 'lng', 34.6399492, 'phone', '', 'email', '', 'sort_order', 3),
      jsonb_build_object('label', 'באר שבע', 'address', 'רגר 11, בניין 7, קומה 3, באר שבע', 'lat', 31.2597921, 'lng', 34.7982013, 'phone', '08-6230349', 'email', '', 'sort_order', 4)
    ),
    eligibility = COALESCE(eligibility, '{}'::jsonb) || jsonb_build_object(
      'internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '19.10.2026: נבדק מול https://www.telem.org.il . נוספו כתובות חמשת הסניפים. פסיכיאטר מצוין רק ברעננה ובתל אביב. מי משלם לא צוין באתר. לפי מאגר קשר: תשלום לפי מחירון לשעת טיפול וסבסוד חלקי למשפחות מאמצות. הסיכה בתל אביב על בית קלקא. הסיכות בראשון לציון ובבאר שבע על הרחוב, כי מספר הבית לא נמצא במפה.', E'\n ')
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 203
  AND COALESCE(public_fields->>'region', '') = 'כל הארץ. סניף ברעננה: אחוזה 301, ועוד סניפים'
  AND COALESCE(public_fields->>'cost', '') = 'לפי מחירון לשעת טיפול, בלי צורך בחברות. סבסוד חלקי למשפחות מאמצות ומאומצים.'
  AND COALESCE(public_fields->>'notes', '') = 'תלם מפעילה את שיחות התמיכה הטלפוניות של מכבי (*3028) ושל לאומית (072-2000272). פרטים בכרטיס [קווי התמיכה של קופות החולים](https://nefesh-il.org/support?entry=243&section=trauma). בצוות הטיפול פסיכיאטרים לילדים ולמבוגרים (כולל פסיכיאטר שמתמחה ב-ADHD), פסיכולוגים קליניים וחינוכיים ועובדים סוציאליים, וגם מטפלים באמנות. מטפלים בין השאר בלקויות למידה, בקשב וריכוז ובקשיים נפשיים. הפירוט לפי מאגר «קשר», והאתר לא נטען בבדיקה, וייתכן שאינו עדכני.';

-- Row 203, if the review note was never applied and the catalog sentence is still there.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'רעננה: אחוזה 301. תל אביב: מנחם בגין 116, בית קלקא, קומה 3. ראשון לציון: ירושלים 12. אשדוד: הציונות 50, קומה 1. באר שבע: רגר 11, בניין 7, קומה 3',
      'cost', '',
      'notes', 'קווי תמיכה נפשית בחרבות ברזל — פרטים נוספים באתר. פסיכיאטר מצוין רק בסניפי רעננה ותל אביב. בראשון לציון, באשדוד ובבאר שבע לא צוין. בצוות פסיכולוגים קליניים, חינוכיים, התפתחותיים ורפואיים, ועובדים סוציאליים קליניים ברעננה ובראשון לציון, וגם מטפלים זוגיים ומשפחתיים ומטפלים בהבעה ויצירה. מי משלם לא צוין באתר.'
    ),
    sites = COALESCE(sites, '[]'::jsonb) || jsonb_build_array(
      jsonb_build_object('label', 'תל אביב', 'address', 'מנחם בגין 116, בית קלקא, קומה 3, תל אביב', 'lat', 32.0712913, 'lng', 34.7898440, 'phone', '', 'email', '', 'sort_order', 1),
      jsonb_build_object('label', 'ראשון לציון', 'address', 'ירושלים 12, ראשון לציון', 'lat', 31.9626937, 'lng', 34.8161832, 'phone', '03-6097373', 'email', '', 'sort_order', 2),
      jsonb_build_object('label', 'אשדוד', 'address', 'הציונות 50, קומה 1, אשדוד', 'lat', 31.7863462, 'lng', 34.6399492, 'phone', '', 'email', '', 'sort_order', 3),
      jsonb_build_object('label', 'באר שבע', 'address', 'רגר 11, בניין 7, קומה 3, באר שבע', 'lat', 31.2597921, 'lng', 34.7982013, 'phone', '08-6230349', 'email', '', 'sort_order', 4)
    ),
    eligibility = COALESCE(eligibility, '{}'::jsonb) || jsonb_build_object(
      'internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '19.10.2026: נבדק מול https://www.telem.org.il . נוספו כתובות חמשת הסניפים. פסיכיאטר מצוין רק ברעננה ובתל אביב. מי משלם לא צוין באתר. לפי מאגר קשר: תשלום לפי מחירון לשעת טיפול וסבסוד חלקי למשפחות מאמצות. הסיכה בתל אביב על בית קלקא. הסיכות בראשון לציון ובבאר שבע על הרחוב, כי מספר הבית לא נמצא במפה.', E'\n ')
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 203
  AND COALESCE(public_fields->>'region', '') = 'כל הארץ. סניף ברעננה: אחוזה 301, ועוד סניפים'
  AND COALESCE(public_fields->>'cost', '') = 'לפי מחירון לשעת טיפול, בלי צורך בחברות. סבסוד חלקי למשפחות מאמצות ומאומצים.'
  AND COALESCE(public_fields->>'notes', '') = 'קווי תמיכה נפשית בחרבות ברזל — פרטים נוספים באתר. בצוות הטיפול פסיכיאטרים לילדים ולמבוגרים (כולל פסיכיאטר שמתמחה ב-ADHD), פסיכולוגים קליניים וחינוכיים ועובדים סוציאליים, וגם מטפלים באמנות. מטפלים בין השאר בלקויות למידה, בקשב וריכוז ובקשיים נפשיים. הפירוט לפי מאגר «קשר», והאתר לא נטען בבדיקה, וייתכן שאינו עדכני.';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c
JOIN (VALUES
  ('תל אביב', 'מנחם בגין 116, בית קלקא, קומה 3, תל אביב', 32.0712913::float8, 34.7898440::float8, 1),
  ('ראשון לציון', 'ירושלים 12, ראשון לציון', 31.9626937::float8, 34.8161832::float8, 2),
  ('אשדוד', 'הציונות 50, קומה 1, אשדוד', 31.7863462::float8, 34.6399492::float8, 3),
  ('באר שבע', 'רגר 11, בניין 7, קומה 3, באר שבע', 31.2597921::float8, 34.7982013::float8, 4)
) AS v(label, address, lat, lng, sort_order) ON true
WHERE c.row_id = 203
  AND c.entry_id IS NOT NULL
  AND COALESCE(c.public_fields->>'region', '') = 'רעננה: אחוזה 301. תל אביב: מנחם בגין 116, בית קלקא, קומה 3. ראשון לציון: ירושלים 12. אשדוד: הציונות 50, קומה 1. באר שבע: רגר 11, בניין 7, קומה 3'
ON CONFLICT (row_id, label) DO NOTHING;

-- Row 354: the station's own site now lists the team. Payment stays the «קשר» detail, marked as such.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'cost', 'לפי מאגר «קשר»: בתשלום, עם מימון חלקי אפשרי ממשרדי הרווחה, ממשרד הביטחון, כללית מושלם ומכבי. באתר התחנה זה לא צוין.',
      'notes', 'עמותה בבעלות המועצות האזוריות גלבוע ועמק המעיינות, עם כ-70 עובדים. בצוות פסיכיאטרית, פסיכולוגים, עובדים סוציאליים קליניים ודיאטנית קלינית. יש מרכזים ייעודיים להפרעות אכילה ולפוסט-טראומה, וגם טיפול במשברי חיים, לחץ, אובדן, חרדה, דיכאון, הפרעות התפתחותיות ולקויות למידה.',
      'phone2', '04-6533239',
      'phoneShowNumber2', true,
      'web', 'https://www.psy.org.il'
    ),
    eligibility = COALESCE(eligibility, '{}'::jsonb) || jsonb_build_object(
      'internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '19.10.2026: האתר https://www.psy.org.il נטען. הצוות אושר באתר: פסיכיאטרית, פסיכולוגים, עובדים סוציאליים קליניים ודיאטנית קלינית, כ-70 עובדים, ומרכזים להפרעות אכילה ולפוסט-טראומה. מי משלם לא צוין באתר; נשאר הפירוט ממאגר קשר, מסומן ככזה. אין רחוב, ולכן אין סיכה.', E'\n ')
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 354
  AND COALESCE(public_fields->>'cost', '') = 'בתשלום. מימון חלקי אפשרי לפי זכאות ממשרדי הרווחה, ממשרד הביטחון ומקופות (כללית מושלם, מכבי)'
  AND COALESCE(public_fields->>'notes', '') = 'עמותה שהוקמה על ידי מועצות אזוריות בעמק, עם כ-60 אנשי מקצוע: פסיכיאטר, פסיכולוגים (רובם קליניים) ועובדים סוציאליים. מטפלים בין השאר במשברי חיים, לחץ, חרדה, פוסט-טראומה, אובדן, הפרעות התפתחותיות, אוטיזם והפרעות אכילה. המידע לפי מאגר «קשר». האתר לא נטען בבדיקה, וייתכן שהפירוט אינו עדכני.';

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, term_keys, card_keys, migration)
SELECT
  '2026-10-19-multidisciplinary-centers-update',
  DATE '2026-10-19',
  'עדכון מרכזים רב-צוותיים',
  'מיינדמי נוסף לרשימת המרכזים הרב-צוותיים. עודכנו הכתובות והצוות במרפאות דרור של בית חם, בסניפי תלם, ובתחנת העמקים.',
  'cards',
  ARRAY['multidisciplinary_center'],
  ARRAY[
    (SELECT c.card_key FROM directory_card_edits c WHERE c.row_id = 62 ORDER BY c.id LIMIT 1),
    (SELECT c.card_key FROM directory_card_edits c WHERE c.row_id = 104 ORDER BY c.id LIMIT 1),
    (SELECT c.card_key FROM directory_card_edits c WHERE c.row_id = 203 ORDER BY c.id LIMIT 1),
    (SELECT c.card_key FROM directory_card_edits c WHERE c.row_id = 354 ORDER BY c.id LIMIT 1)
  ],
  '095_multidisciplinary_centers_update.sql'
WHERE NOT EXISTS (
  SELECT 1 FROM site_audit_entries WHERE entry_key = '2026-10-19-multidisciplinary-centers-update'
);

COMMIT;
