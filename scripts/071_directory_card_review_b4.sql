-- Migration 071 (16 Oct 2026)
-- Card review, batch 4: changes approved by the site owner, from docs/card-review-2026-10.md.
-- Each UPDATE only applies if the fields it changes still hold the reviewed text, so a later
-- admin edit is never overwritten. Pins are geocoded with OpenStreetMap Nominatim.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- Row 96: חיים של טובה. 2 field(s).
--   להוסיף עלות (מסובסד) וקהל יעד (משפחות, זוגות ויחידים); הפנייה עצמית בוואטסאפ או במייל.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"cost":"מסובסד (תעריפים מוזלים וקרן לסבסוד טיפולים)","target":"משפחות, זוגות ויחידים במצוקה"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://hst.org.il/. עודכנו: cost, target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '96|||הכוונה לטיפול הפסיכולוגי המתאים לכם, סבסוד טיפולים, חוסן משפחתי. שינוי מפת ההתמודדות המשפחתית והקהילתית במצבי מצוקה אישיים ומשפחתיים.'
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'target', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '96|||הכוונה לטיפול הפסיכולוגי המתאים לכם, סבסוד טיפולים, חוסן משפחתי. שינוי מפת ההתמודדות המשפחתית והקהילתית במצבי מצוקה אישיים ומשפחתיים.');

-- Row 201: תאיר – מרכז הסיוע לנפגעות ולנפגעי תקיפה מינית. 4 field(s).
--   להוסיף את קו הסיוע הישיר של המרכז ואת העלות (קבוצות בתשלום סמלי), ולתקן את ההפניה לכרטיס איגוד מרכזי הסיוע.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"08-9496020","phoneLabel":"קו הסיוע הישיר של המרכז","cost":"ליווי חינם; קבוצות תמיכה בתשלום סמלי","notes":"קווי המענה הארציים 1202/1203 רשומים בכרטיס [איגוד מרכזי הסיוע](https://nefesh-il.org/support?entry=200&section=emergency)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.tair-1202.org/ , https://www.tair-1202.org/support-groups. עודכנו: phone, phoneLabel, cost, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '201|||סיוע וליווי, חינוך ומניעה, קבוצות תמיכה (פרונטלי וזום)'
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'קווי המענה הארציים 1202/1203 רשומים תחת "איגוד מרכזי הסיוע" בקטגוריית קווי סיוע.';

-- Row 203: תלמ. 4 field(s).
--   להסיר את *2708 (קו של כללית), לתקן את תווית 072-2000272 לשיחות תמיכה ללקוחות לאומית, ולעדכן את ההערה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone2":"","phoneLabel2":"","phoneLabel3":"שיחות תמיכה ללקוחות לאומית (חזרה תוך 24 שעות)","notes":"תלם מפעילה את שיחות התמיכה הטלפוניות של מכבי (*3028) ושל לאומית (072-2000272). פרטים בכרטיס [קווי התמיכה של קופות החולים](https://nefesh-il.org/support?entry=243&section=trauma)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.telem.org.il/ , https://www.leumit.co.il/mental-health-arena/mental-health-services/ , https://www.maccabi4u.co.il/eligibilites/2124/ , https://www.clalit.co.il/arb/your_health/family/Pages/phone_therapy.aspx. עודכנו: phone2, phoneLabel2, phoneLabel3, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '203|||רשת ארצית לטיפול פסיכולוגי, אבחון והכשרה — כולל טיפול בטראומה ובמצוקה נפשית.'
  AND COALESCE(public_fields->>'phone2', '') = '*2708'
  AND COALESCE(public_fields->>'phoneLabel2', '') = 'תמיכה נפשית (7:00-20:00)'
  AND COALESCE(public_fields->>'phoneLabel3', '') = 'תלם חירום'
  AND COALESCE(public_fields->>'notes', '') = 'קווי תמיכה נפשית בחרבות ברזל — פרטים נוספים באתר.';

-- Row 206: מרכז נשימה. 2 field(s).
--   להוסיף קהל יעד (מתמודדים עם טראומה מורכבת) ועלות (מסובסד).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"מתמודדים עם טראומה מורכבת ובני משפחותיהם","cost":"מסובסד"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://neshima-ptsd.co.il/%d7%9e%d7%95%d7%93%d7%9c-%d7%a0%d7%a9%d7%99%d7%9e%d7%94/ , https://neshima-ptsd.co.il/. עודכנו: target, cost.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '206|||מודל נשימה — טיפול מסובסד, רשת מטפלים לטראומה מורכבת וגישת גוף–נפש קהילתית.'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'cost', '') = '';

-- Row 210: מטיב (המרכז הישראלי לפסיכוטראומה). 5 field(s), 1 pin(s), eligibility.
--   לעדכן את האתר לכתובת הפעילה, ולציין שהטיפול החינמי מיועד לחיילים משוחררים עם פוסט-טראומה צבאית וניתן במסגרת מחקר.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"web":"https://metiv.org/%D7%98%D7%99%D7%A4%D7%95%D7%9C%D7%99%D7%9D-%D7%9C%D7%9C%D7%90-%D7%A2%D7%9C%D7%95%D7%AA-%D7%93%D7%A8%D7%9A-%D7%9E%D7%98%D7%99%D7%91/","target":"חיילים משוחררים ומילואימניקים (לא בסדיר) עם פוסט-טראומה מהשירות הצבאי","phoneLabel":"וואטסאפ — טיפול ללא עלות","email":"shir@metiv.org","notes":"הטיפול ללא עלות הוא חלק ממחקר קליני (חוויה סומטית או חשיפה ממושכת) וניתן בכל הארץ. מרפאת המבוגרים של מטיב בירושלים (02-644-9666) בתשלום, אלא אם יש גורם מממן. שונה מ[מטיבת\"א](https://nefesh-il.org/support?entry=24&section=helplines) (*2837)."}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"מטיב — המרכז הישראלי לפסיכוטראומה","address":"גבעת שאול, המרכז הרפואי הרצוג, ירושלים","lat":31.7911185,"lng":35.1931023,"phone":"02-6449666","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://metiv.org.il/ , https://metiv.org/ , https://metiv.org/%D7%98%D7%99%D7%A4%D7%95%D7%9C%D7%99%D7%9D-%D7%9C%D7%9C%D7%90-%D7%A2%D7%9C%D7%95%D7%AA-%D7%93%D7%A8%D7%9A-%D7%9E%D7%98%D7%99%D7%91/. עודכנו: web, target, phoneLabel, email, notes. התאמה: location_mode. סיכות: גבעת שאול, המרכז הרפואי הרצוג, ירושלים.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '210|||טיפול ארצי ללא עלות לטווח ארוך בטראומה'
  AND COALESCE(public_fields->>'web', '') = 'https://metiv.org.il/'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'גם 02-644-9666 באתר. שונה ממטיבת"א (*2837).';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('מטיב — המרכז הישראלי לפסיכוטראומה', 'גבעת שאול, המרכז הרפואי הרצוג, ירושלים', 31.7911185, 35.1931023, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '210|||טיפול ארצי ללא עלות לטווח ארוך בטראומה' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

-- Row 211: רטורנו — חוות חוסן. 7 field(s), 1 pin(s), eligibility.
--   לתקן את המיקום לגבעת שמש, להוסיף עלות (במימון אגף השיקום), קהל יעד, אתר ייעודי ומייל.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"svc":"טיפול, ליווי ושיקום לפוסט-טראומה (בהכרה או לאחר אבחון) — חוות החוסן בגבעת שמש","web":"https://retorno.org.il/%D7%97%D7%95%D7%95%D7%AA-%D7%94%D7%97%D7%95%D7%A1%D7%9F/","target":"לוחמים, מילואימניקים ונכי צה\"ל עם פוסט-טראומה (מוכרים באגף השיקום או בתהליך הכרה)","region":"גבעת שמש (ליד בית שמש)","cost":"במימון מלא של אגף השיקום, משרד הביטחון (למתאימים)","email":"lilach@retorno.org","notes":"להתקבל לתוכנית חייבת הכרה/אבחון טראומה. ראו גם [חיבוק ברזל (רטורנו)](https://nefesh-il.org/treatment?entry=230&section=trauma), [רטורנו — גמילה מהתמכרויות](https://nefesh-il.org/treatment?entry=249&section=addictions)."}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"רטורנו — חוות החוסן","address":"רטורנו, גבעת שמש (ליד בית שמש)","lat":31.7750342,"lng":34.9514146,"phone":"058-6000881","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.retorno.org.il/ , https://retorno.org.il/%D7%97%D7%95%D7%95%D7%AA-%D7%94%D7%97%D7%95%D7%A1%D7%9F/ , https://retorno.org.il/%D7%97%D7%95%D7%95%D7%AA-%D7%94%D7%97%D7%95%D7%A1%D7%9F-%D7%9E%D7%9C%D7%97%D7%9E%D7%95%D7%AA-%D7%A7%D7%95%D7%93%D7%9E%D7%95%D7%AA/. עודכנו: svc, web, target, region, cost, email, notes. התאמה: location_mode. סיכות: רטורנו, גבעת שמש (ליד בית שמש).', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '211|||טיפול, ליווי ושיקום לפוסט-טראומה (בהכרה או לאחר אבחון) — חוות במושב שמש'
  AND COALESCE(public_fields->>'svc', '') = 'טיפול, ליווי ושיקום לפוסט-טראומה (בהכרה או לאחר אבחון) — חוות במושב שמש'
  AND COALESCE(public_fields->>'web', '') = 'https://www.retorno.org.il/'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'להתקבל לתוכנית חייבת הכרה/אבחון טראומה.';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('רטורנו — חוות החוסן', 'רטורנו, גבעת שמש (ליד בית שמש)', 31.7750342, 34.9514146, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '211|||טיפול, ליווי ושיקום לפוסט-טראומה (בהכרה או לאחר אבחון) — חוות במושב שמש' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral', 'mod_rehab_worker']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '211|||טיפול, ליווי ושיקום לפוסט-טראומה (בהכרה או לאחר אבחון) — חוות במושב שמש');

-- Row 212: עמ"ך. 2 field(s), 2 pin(s), eligibility.
--   להחליף את כתובת האתר השבורה לאתר הרשמי של עמך ולהוסיף כתובות לשלושת הסניפים בצפון.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"web":"https://www.amcha.org/","notes":"נהריה: 04-6665566 · חיפה: 04-8375649. ראו גם [עמך - המרכז הישראלי לתמיכה נפשית וחברתית בניצולי השואה והדור השני](https://nefesh-il.org/rights?entry=70&section=rehabilitation)."}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"עמך קריית מוצקין","address":"יוני נתניהו 8, קריית מוצקין","lat":32.842326,"lng":35.087608,"phone":"04-8766967","email":"","sort_order":0},{"label":"עמך נהריה","address":"לוחמי הגטאות 18, נהריה","lat":33.0018976,"lng":35.0973758,"phone":"04-6665566","email":"","sort_order":1}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.amok.org.il/ , https://www.amcha.org/ , https://www.amcha.org/%D7%A6%D7%95%D7%A8-%D7%A7%D7%A9%D7%A8/. עודכנו: web, notes. התאמה: location_mode. סיכות: יוני נתניהו 8, קריית מוצקין; לוחמי הגטאות 18, נהריה.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '212|||טיפוליים מפגשים ללא עלות בצפון (פרונטלי או מקוון)'
  AND COALESCE(public_fields->>'web', '') = 'https://www.amok.org.il/'
  AND COALESCE(public_fields->>'notes', '') = 'נהריה: 04-6665566 · חיפה: 04-8375649';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('עמך קריית מוצקין', 'יוני נתניהו 8, קריית מוצקין', 32.842326, 35.087608, 0),
  ('עמך נהריה', 'לוחמי הגטאות 18, נהריה', 33.0018976, 35.0973758, 1)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '212|||טיפוליים מפגשים ללא עלות בצפון (פרונטלי או מקוון)' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

-- Row 213: מבצע הקשב. 3 field(s).
--   האתר של מבצע הקשב לא עולה ולא נמצא מידע עדכני מ-2025 ואילך; לבדוק אם המיזם עדיין פעיל, ואם כן להוסיף עלות (70 ₪ למפגש) וקהל יעד.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"cost":"70 ₪ למפגש","target":"מילואימניקים ובני/בנות זוגם במצוקה בעקבות המלחמה","notes":"ייתכן שהמיזם הסתיים: האתר לא עולה ולא נמצא מידע מ-2025 ואילך. כדאי לבדוק לפני שפונים."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.hakshev.com/ , https://www.mvhr.org.il/%D7%9E%D7%A2%D7%A0%D7%99%D7%9D-%D7%98%D7%99%D7%A4%D7%95%D7%9C%D7%99%D7%99%D7%9D/ , https://www.maariv.co.il/news/israel/article-1048712. עודכנו: cost, target, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '213|||עזרה ראשונה נפשית לנפגעי חרבות ברזל — עד 10 מפגשים'
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'ייתכן שאתר לא זמין לעיתים — בדקו לפני הפניה.';

-- Row 215: מכון הקבע. 3 field(s).
--   לתקן את מספר הטלפון ל-076-8600010, להוסיף קהל יעד ושעות פעילות.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"076-8600010","target":"אנשי קבע בצה\"ל ובני משפחותיהם","notes":"א''-ה'' 8:00-17:00. משרתי קבע פונים למכון מהשנה השלישית לקבע; בשנתיים הראשונות — דרך קב\"ן היחידה."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.idf.il/%D7%90%D7%AA%D7%A8%D7%99-%D7%99%D7%97%D7%99%D7%93%D7%95%D7%AA/%D7%90%D7%92%D7%A3-%D7%94%D7%98%D7%9B%D7%A0%D7%95%D7%9C%D7%95%D7%92%D7%99%D7%94-%D7%95%D7%94%D7%9C%D7%95%D7%92%D7%99%D7%A1%D7%98%D7%99%D7%A7%D7%94/%D7%9B%D7%9C-%D7%94%D7%9B%D7%AA%D7%91%D7%95%D7%AA/2023/%D7%9E%D7%9B%D7%95%D7%9F-%D7%91%D7%A8%D7%99%D7%90%D7%95%D7%AA-%D7%94%D7%A0%D7%A4%D7%A9-%D7%A9%D7%99%D7%A0%D7%95%D7%99%D7%99%D7%9D-%D7%90%D7%A0%D7%A9%D7%99-%D7%A7%D7%91%D7%A2-%D7%98%D7%99%D7%A4%D7%95%D7%9C-%D7%9E%D7%A9%D7%A4%D7%97%D7%94-%D7%9C%D7%95%D7%97%D7%9E%D7%99%D7%9D-2023/ , https://www.zvulun.org.il/%D7%A1%D7%99%D7%95%D7%A2-%D7%A0%D7%A4%D7%A9%D7%99-%D7%95%D7%9E%D7%95%D7%A7%D7%93%D7%99-%D7%AA%D7%9E%D7%99%D7%9B%D7%94/. עודכנו: phone, target, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '215|||סיוע נפשי ללא עלות לאנשי קבע ומשפחותיהם'
  AND COALESCE(public_fields->>'phone', '') = '07-686000010'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '215|||סיוע נפשי ללא עלות לאנשי קבע ומשפחותיהם');

-- Row 217: מרכז לטראומה וחוסן — אוניברסיטת ת"א. 3 field(s).
--   להוסיף מייל, כתובת הקליניקה, קהל יעד ועלות (50 ₪ למפגש).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"email":"hosen@tauex.tau.ac.il","target":"מתמודדים עם פוסט-טראומה מכל סוג של אירוע, כולל מילואימניקים משוחררים","cost":"50 ₪ למפגש"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://people.socsci.tau.ac.il/mu/traumaresilience/. עודכנו: email, target, cost.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '217|||קליניקה לטיפול בפוסט-טראומה (מילואים/משוחררים — תשלום סמלי)'
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'cost', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '217|||קליניקה לטיפול בפוסט-טראומה (מילואים/משוחררים — תשלום סמלי)');

-- Row 219: נשימה מרחב בעמק. 6 field(s).
--   לתקן את שם העמותה ל'מרחב נשימה בעמק', להוסיף אתר, קהל יעד ועלות (חינם ברישום מוקדם), ולתאר את השירות כבית תמיכה וקבוצות.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"מרחב נשימה בעמק","web":"https://m-neshima.co.il/","svc":"בית תמיכה, קבוצות וסדנאות למתמודדי פוסט-טראומה ולבני משפחותיהם — פרזון (רישום מוקדם)","target":"מתמודדים עם פוסט-טראומה עקב שירות צבאי או פעולות איבה, ובני משפחותיהם (אמהות, בנות זוג)","region":"העמקים: יזרעאל, מגידו, גלבוע, עמק המעיינות, בית שאן ועפולה","cost":"חינם (נדרש רישום מוקדם)"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://m-neshima.co.il/ , https://m-neshima.co.il/%d7%90%d7%95%d7%93%d7%95%d7%aa/ , https://m-neshima.co.il/%d7%94%d7%a7%d7%91%d7%95%d7%a6%d7%95%d7%aa-%d7%91%d7%9e%d7%a8%d7%97%d7%91/. עודכנו: org, web, svc, target, region, cost.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '219|||תוכנית טיפול לפוסט-טראומה — מושב משק פרזון (רישום מוקדם)'
  AND COALESCE(public_fields->>'org', '') = 'נשימה מרחב בעמק'
  AND COALESCE(public_fields->>'web', '') = ''
  AND COALESCE(public_fields->>'svc', '') = 'תוכנית טיפול לפוסט-טראומה — מושב משק פרזון (רישום מוקדם)'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'region', '') = 'עמק יזרעאל'
  AND COALESCE(public_fields->>'cost', '') = '';

-- Row 220: קליניקה לטיפול זוגי ב-PTSD (בר אילן). 6 field(s).
--   להחליף את קישור האתר לעמוד התוכנית, להוסיף מייל, קהל יעד ואזור (זום), ולציין שהטיפול חינם רק במסגרת המחקר.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"web":"https://sites.biu.ac.il/ripples-recovery/page/5604","svc":"טיפול זוגי CBCT מודע טראומה במחקר — 15 מפגשים בזום","email":"centerf@biu.ac.il","target":"זוגות שבהם אחד או שני בני הזוג מתמודדים עם פוסט-טראומה","region":"מקוון (זום)","notes":"שני בני הזוג משתתפים. הטיפול הוא חלק ממחקר קליני וניתן ללא עלות; מחוץ למחקר נדרשת השתתפות עצמית סמלית. ראו גם [אדוות להחלמה (בר אילן)](https://nefesh-il.org/treatment?entry=222&section=trauma)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.biu.ac.il/ , https://sites.biu.ac.il/ripples-recovery/page/5604 , https://social-work.biu.ac.il/couples_post_trauma_more_info. עודכנו: web, svc, email, target, region, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '220|||CBT זוגי במחקר — 15 מפגשים בזום'
  AND COALESCE(public_fields->>'web', '') = 'https://www.biu.ac.il/'
  AND COALESCE(public_fields->>'svc', '') = 'CBT זוגי במחקר — 15 מפגשים בזום'
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'לזוגות שני בני זוג משתתפים.';

-- Row 221: קמה — מרפאת כללית. 5 field(s), 1 pin(s), eligibility.
--   לתקן את קוד ההפניה של כללית (74055) ואת הימים (א'-ד'), להוסיף כתובת בהוד השרון, גיל 18+, הפניה מרופא וטופס 17, ולציין שהמרפאה פתוחה לכל הקופות ולכל טראומה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"קמה — מרפאה לטראומה ואובדן (שלוותה, כללית)","svc":"טיפול ממוקד ותחום בזמן לאחר טראומה או אובדן — כולל משרתי מילואים משוחררים","target":"מבוגרים מגיל 18, מכל קופות החולים, אחרי אירוע טראומטי או אובדן","cost":"ללא עלות, בהפניה מרופא משפחה וטופס 17 (כל הקופות)","notes":"פקס 09-7478628 · קוד הפניה: כללית 74055, קופות אחרות L0771 · א''-ד'' 8:00-15:30 · טיפול של כ-4-6 חודשים; למי שגר רחוק — אפשר בזום."}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"מרפאת קמה (שלוותה)","address":"כיכר המושבה, סוקולוב 46, קומה 14G, הוד השרון","lat":32.1687805,"lng":34.9018048,"phone":"09-7470349","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":18,"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.betipulnet.co.il/articles/%D7%98%D7%99%D7%A4%D7%95%D7%9C_%D7%A0%D7%A4%D7%A9%D7%99_%D7%99%D7%99%D7%A2%D7%95%D7%93%D7%99_%D7%9C%D7%A0%D7%A4%D7%92%D7%A2%D7%99_%D7%94%D7%9E%D7%9C%D7%97%D7%9E%D7%94/ , https://www.invisiblealbum.com/he/product/6a8542c363b1947a593d7605 , https://www.neshot-miluim-keva.com/%D7%98%D7%99%D7%A4%D7%95%D7%9C-%D7%A8%D7%92%D7%A9%D7%99. עודכנו: org, svc, target, cost, notes. התאמה: age_min, location_mode. סיכות: כיכר המושבה, סוקולוב 46, קומה 14G, הוד השרון.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '221|||טיפול ממוקד טראומה למשרתי/מילואימניקים משוחררים (מלחמה/אובדן)'
  AND COALESCE(public_fields->>'org', '') = 'קמה — מרפאת כללית'
  AND COALESCE(public_fields->>'svc', '') = 'טיפול ממוקד טראומה למשרתי/מילואימניקים משוחררים (מלחמה/אובדן)'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'cost', '') = 'במסגרת כללית'
  AND COALESCE(public_fields->>'notes', '') = 'פקס 09-7478628 · קוד L0771 · א''-ה'' 8:00-15:30';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('מרפאת קמה (שלוותה)', 'כיכר המושבה, סוקולוב 46, קומה 14G, הוד השרון', 32.1687805, 34.9018048, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '221|||טיפול ממוקד טראומה למשרתי/מילואימניקים משוחררים (מלחמה/אובדן)' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

UPDATE directory_entries
SET referral_codes = ARRAY['gp_referral', 'hmo_form17']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '221|||טיפול ממוקד טראומה למשרתי/מילואימניקים משוחררים (מלחמה/אובדן)');

-- Row 222: אדוות להחלמה (בר אילן). 4 field(s), 1 pin(s), eligibility.
--   להוסיף אתר, מיקום (בר אילן), קהל יעד ופירוט המפגשים; לבדוק אם הטיפול עדיין חינם.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"web":"https://sites.biu.ac.il/ripples-recovery","region":"אוניברסיטת בר אילן, רמת גן","target":"ילדי משרתי מילואים בגילאי 3-12 והוריהם","notes":"התערבות משפחתית קצרה לאחר המלחמה: 4-5 מפגשים בבר אילן, עם ההורים ולעיתים גם עם הילדים, כולל מילוי שאלונים. ראו גם [קליניקה לטיפול זוגי ב-PTSD (בר אילן)](https://nefesh-il.org/treatment?entry=220&section=trauma)."}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"אדוות להחלמה — אוניברסיטת בר אילן","address":"אוניברסיטת בר אילן, בניין 417, רמת גן","lat":32.0693292,"lng":34.8433434,"phone":"","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":3,"age_max":12,"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://sites.biu.ac.il/ripples-recovery , https://sites.biu.ac.il/en/sunflower-center-academic-resiliency/page/6743 , https://www.mvhr.org.il/%D7%9E%D7%A2%D7%A0%D7%99%D7%9D-%D7%98%D7%99%D7%A4%D7%95%D7%9C%D7%99%D7%99%D7%9D/. עודכנו: web, region, target, notes. התאמה: age_min, age_max, location_mode. סיכות: אוניברסיטת בר אילן, בניין 417, רמת גן.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '222|||טיפול קצר לילדי מילואימניקים 3-12 ומשפחות'
  AND COALESCE(public_fields->>'web', '') = ''
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'התערבות משפחתית לאחר מלחמה.';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('אדוות להחלמה — אוניברסיטת בר אילן', 'אוניברסיטת בר אילן, בניין 417, רמת גן', 32.0693292, 34.8433434, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '222|||טיפול קצר לילדי מילואימניקים 3-12 ומשפחות' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '222|||טיפול קצר לילדי מילואימניקים 3-12 ומשפחות');

-- Row 226: שיב"א — המרפאה הלאומית. 5 field(s), eligibility.
--   השירות עדיין פעיל (2026): להוסיף את הטלפון הרשמי 03-5309661, גיל 18+, קהל יעד ומימון ביטוח לאומי, ולתקן את כתובת האתר.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"web":"https://beyond-en.sheba.co.il/242605","phone2":"03-5309661","phoneLabel2":"פרטים נוספים","target":"מבוגרים מגיל 18 עם חרדה או טראומה בעקבות המלחמה, שאין באזור מגוריהם מרכז חוסן פעיל","notes":"טיפול מקוון של שיבא BEYOND, ממוקד טראומה וחרדה, במימון ביטוח לאומי. ראו גם [מרכזי חוסן](https://nefesh-il.org/treatment?entry=30&section=therapists)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":18}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.shiba.org.il/ , https://beyond-en.sheba.co.il/242605 , https://www.kolsherut.org.il/emergency_mental_assistance , https://www.linkedin.com/posts/sheba-beyond_%D7%90%D7%99%D7%9F-%D7%A7%D7%A9%D7%94-%D7%9B%D7%9E%D7%95-%D7%9C%D7%94%D7%99%D7%A9%D7%90%D7%A8-%D7%9C%D7%91%D7%93-%D7%A2%D7%9D-%D7%94%D7%97%D7%A8%D7%93%D7%94-%D7%A9%D7%99%D7%91%D7%90-%D7%9B%D7%90%D7%9F-activity-7425507485953912832-ap0I. עודכנו: web, phone2, phoneLabel2, target, notes. התאמה: age_min.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '226|||עד 12 מפגשים טיפול רגשי ללא עלות'
  AND COALESCE(public_fields->>'web', '') = 'https://www.shiba.org.il/'
  AND COALESCE(public_fields->>'phone2', '') = ''
  AND COALESCE(public_fields->>'phoneLabel2', '') = ''
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

-- Row 228: מרפא מרחב (חוות מרפא). 6 field(s), 1 pin(s), eligibility.
--   להסיר את הטלפון 074-7556155 (שייך לעמותת אנוש) ואת ההערה השגויה, ולהוסיף מייל, כתובת וקהל יעד.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"","phoneLabel":"","notes":"","email":"groups@healingspace.co.il","org":"חוות מרפא רשפון","target":"נפגעי טראומה — יחידים וקהילות, בשגרה ובחירום"}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"חוות מרפא רשפון","address":"הפרדס 48, רשפון","lat":32.2024685,"lng":34.826654,"phone":"","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://healingspace.co.il/ , https://healingspace.co.il/contact/ , https://www.enosh.org.il/%D7%9E%D7%A8%D7%9B%D7%96-%D7%94%D7%9E%D7%99%D7%93%D7%A2/. עודכנו: phone, phoneLabel, notes, email, org, target. התאמה: location_mode. סיכות: הפרדס 48, רשפון.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '228|||טיפול, ליווי ושיקום — רשפון'
  AND COALESCE(public_fields->>'phone', '') = '074-7556155'
  AND COALESCE(public_fields->>'phoneLabel', '') = 'קו סיוע'
  AND COALESCE(public_fields->>'notes', '') = '074-7556155 — מוקצה לחוות מרפא מרחב (לא למוקד אנוש).'
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'org', '') = 'מרפא מרחב (חוות מרפא)'
  AND COALESCE(public_fields->>'target', '') = '';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('חוות מרפא רשפון', 'הפרדס 48, רשפון', 32.2024685, 34.826654, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '228|||טיפול, ליווי ושיקום — רשפון' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

-- Row 229: משאבים — מרכז גליל. 7 field(s), eligibility.
--   לתקן שעות (א'-ה' 8:00-20:00) והגבלת הגיל השגויה, להוסיף את הגולן, ולקשר לעמוד הרשמי של משאבים לצד טופס הפנייה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"svc":"מוקד סיוע רגשי מרחוק — עד 12 שיחות ללא עלות — עברית, ערבית, רוסית, אנגלית","web":"https://icspc.org/clinical-response-in-resilience/","add":"https://forms.gle/3i4Zw5Wu3dHk2AqH8","addLabel":"טופס פנייה לטיפול פרטני","region":"גליל מערבי, גליל מזרחי וגולן","target":"תושבי הגליל המערבי, הגליל המזרחי והגולן, בכל גיל","notes":"ערבית 04-7702649 · רוסית 04-7702650 · אנגלית 04-7702651 · א''-ה'' 8:00-20:00. טיפול פרטני ממוקד (עד 12 מפגשים, מגיל 6) — בטופס הפנייה; לשאלות 058-5822579. לאזרחים בלבד: חיילים פונים למענה הצבאי. ראו גם [מרכזי חוסן](https://nefesh-il.org/treatment?entry=30&section=therapists)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"regions","regions":["גליל מערבי","גליל מזרחי","גולן"]}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://forms.gle/3i4Zw5Wu3dHk2AqH8 , https://icspc.org/clinical-response-in-resilience/ , https://icspc.org/help-lines/. עודכנו: svc, web, add, addLabel, region, target, notes. התאמה: location_mode, regions.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '229|||מוקד סיוע רגשי מרחוק (מגיל 12) — עברית, ערבית, רוסית, אנגלית'
  AND COALESCE(public_fields->>'svc', '') = 'מוקד סיוע רגשי מרחוק (מגיל 12) — עברית, ערבית, רוסית, אנגלית'
  AND COALESCE(public_fields->>'web', '') = 'https://forms.gle/3i4Zw5Wu3dHk2AqH8'
  AND COALESCE(public_fields->>'add', '') = ''
  AND COALESCE(public_fields->>'addLabel', '') = ''
  AND COALESCE(public_fields->>'region', '') = 'גליל מזרחי ומערבי'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'ערבית 04-7702649 · רוסית 04-7702650 · אנגלית 04-7702651 · 24/6';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '229|||מוקד סיוע רגשי מרחוק (מגיל 12) — עברית, ערבית, רוסית, אנגלית');

-- Row 230: חיבוק ברזל (רטורנו). 5 field(s), 1 pin(s), eligibility.
--   לתקן גילאים (18-35) ומיקום (גבעת שמש, לא דרום), ולהוסיף אתר התוכנית, קהל יעד וימי פעילות.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"svc":"תמיכה רגשית וטיפול לצעירים 18-35 בחוות רטורנו בגבעת שמש — ללא עלות","region":"גבעת שמש (עמק האלה, ליד בית שמש)","web":"https://retorno.org.il/%D7%97%D7%A8%D7%91%D7%95%D7%AA-%D7%91%D7%A8%D7%96%D7%9C/","target":"צעירים 18-35 שחוו משבר או טראומה בעקבות 7 באוקטובר והמלחמה (שורדי נובה, תושבי העוטף, מילואימניקים, מפונים, משפחות חטופים ועוד)","notes":"ימי ג'' 14:00-17:00 וימי ה'' 11:30-18:00. טלפון רטורנו: 053-3773070. ראו גם [רטורנו — חוות חוסן](https://nefesh-il.org/treatment?entry=211&section=trauma), [רטורנו — גמילה מהתמכרויות](https://nefesh-il.org/treatment?entry=249&section=addictions)."}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"רטורנו — חיבוק ברזל","address":"רטורנו, גבעת שמש (ליד בית שמש)","lat":31.7750342,"lng":34.9514146,"phone":"053-3773070","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":18,"age_max":35,"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.retorno.org.il/ , https://retorno.org.il/%D7%97%D7%A8%D7%91%D7%95%D7%AA-%D7%91%D7%A8%D7%96%D7%9C/ , https://retorno.org.il/%D7%97%D7%99%D7%91%D7%95%D7%A7-%D7%91%D7%A8%D7%96%D7%9C-%D7%90%D7%AA%D7%9D-%D7%9C%D7%90-%D7%9C%D7%91%D7%93/. עודכנו: svc, region, web, target, notes. התאמה: age_min, age_max, location_mode. סיכות: רטורנו, גבעת שמש (ליד בית שמש).', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '230|||תמיכה רגשית לצעירים 17-27 בחוות שמש — ללא עלות'
  AND COALESCE(public_fields->>'svc', '') = 'תמיכה רגשית לצעירים 17-27 בחוות שמש — ללא עלות'
  AND COALESCE(public_fields->>'region', '') = 'דרום'
  AND COALESCE(public_fields->>'web', '') = 'https://www.retorno.org.il/'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('רטורנו — חיבוק ברזל', 'רטורנו, גבעת שמש (ליד בית שמש)', 31.7750342, 34.9514146, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '230|||תמיכה רגשית לצעירים 17-27 בחוות שמש — ללא עלות' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '230|||תמיכה רגשית לצעירים 17-27 בחוות שמש — ללא עלות');

-- Row 232: תחנות ציבוריות — טיפול זוגי ומשפחתי. 2 field(s).
--   להוסיף קהל יעד (זוגות ומשפחות) והערה שהרשימה של האגודה ליעוץ זוגי ומשפחתי בפיקוח משרד הרווחה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"זוגות ומשפחות","notes":"רשימת התחנות של האגודה ליעוץ זוגי ומשפחתי, בפיקוח משרד הרווחה, לפי אזורים."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://tinyurl.com/mv7zdka2. עודכנו: target, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '232|||מאגר תחנות לטיפול זוגי'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

-- Row 233: ארנה איזון. 1 field(s).
--   מרכז איזון ארנה בהרצליה פעל מינואר 2024 עד יולי 2025 ונסגר; להסתיר או להסיר את הכרטיס.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"לפי אתר עמותת איזון, המרכז בהרצליה פעל מינואר 2024 עד יולי 2025. ייתכן שהשירות הסתיים; כדאי לבדוק לפני שפונים."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://izun.org.il/ , https://izun.org.il/therapy-spaces/%D7%90%D7%99%D7%96%D7%95%D7%9F-%D7%90%D7%A8%D7%A0%D7%94/ , https://www.izunarena.com/. עודכנו: notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '233|||סיוע וטיפול לשורדי המסיבות בנובה — הרצליה'
  AND COALESCE(public_fields->>'notes', '') = '';

-- Row 234: Safe Heart. 6 field(s).
--   להוסיף אתר ומייל, ולתקן שהשירות מיועד לכל שורדי המסיבות ב-7 באוקטובר ובני משפחותיהם, לא רק לפצועים.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"לב בטוח (SafeHeart)","svc":"טיפול עומק לשורדי המסיבות ב-7 באוקטובר — לפחות 24 מפגשים","web":"https://www.safeheartil.com/","email":"info@safeheartil.com","target":"שורדי המסיבות בעוטף עזה ב-7 באוקטובר ובני משפחותיהם","notes":"מטפלים ברחבי הארץ, קרוב לבית; גם קבוצות, ריטריטים וליווי למשפחות. ספק של ביטוח לאומי ומשרד הבריאות."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.safeheartil.com/ , https://www.safeheartil.com/en , https://www.safeheartil.com/about , https://www.safeheartil.com/contactus. עודכנו: org, svc, web, email, target, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '234|||טיפול עומק לפצועי נובה — לפחות 24 מפגשים'
  AND COALESCE(public_fields->>'org', '') = 'Safe Heart'
  AND COALESCE(public_fields->>'svc', '') = 'טיפול עומק לפצועי נובה — לפחות 24 מפגשים'
  AND COALESCE(public_fields->>'web', '') = ''
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '234|||טיפול עומק לפצועי נובה — לפחות 24 מפגשים');

-- Row 235: לב השרון. 5 field(s).
--   לתקן את המייל השגוי, להוסיף את הטלפון הרשמי ואת כתובת צור משה, ולתקן את האזור (שרון).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"email":"lev-pniot@lev-hasharon.co.il","phone2":"09-8981111","phoneLabel2":"מרכזייה","region":"צור משה (שרון)","svc":"טיפול ממוקד בטראומה למשתתפי מסיבות הטבע בדרום — לב השרון, צור משה"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.lev-hasharon.co.il/ , https://www.lev-hasharon.co.il/?clinic=%D7%9E%D7%A8%D7%9B%D7%96-%D7%A2%D7%95%D7%92%D7%9F-%D7%98%D7%99%D7%A4%D7%95%D7%9C-%D7%99%D7%95%D7%9D-%D7%9C%D7%A0%D7%A4%D7%92%D7%A2%D7%99-%D7%98%D7%A8%D7%90%D7%95%D7%9E%D7%94. עודכנו: email, phone2, phoneLabel2, region, svc.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '235|||טיפול ממוקד בטראומה לשורדי מסיבות — מרכז רפואי + מסיבות בדרום'
  AND COALESCE(public_fields->>'email', '') = 'amaliab@lev-hasharin.co.il'
  AND COALESCE(public_fields->>'phone2', '') = ''
  AND COALESCE(public_fields->>'phoneLabel2', '') = ''
  AND COALESCE(public_fields->>'region', '') = 'דרום / שרון'
  AND COALESCE(public_fields->>'svc', '') = 'טיפול ממוקד בטראומה לשורדי מסיבות — מרכז רפואי + מסיבות בדרום';

-- Row 237: חברה הותיר אחריו. 7 field(s).
--   לתקן את שם העמותה ואת הטלפון (077-770-3166), להוסיף אתר ומייל, ולציין שהטיפול חינם.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"הותיר אחריו חבר.ה","phone":"077-770-3166","web":"https://www.girlfriendsidf.org.il/","email":"info@gfidf.org.il","cost":"חינם","target":"בנות ובני זוג שכולים של חללי צה\"ל וכוחות הביטחון","notes":"ראו גם [אגף משפחות, הנצחה ומורשת (משרד הביטחון)](https://nefesh-il.org/support?entry=238&section=families)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.girlfriendsidf.org.il/ , https://www.girlfriendsidf.org.il/%D7%98%D7%99%D7%A4%D7%95%D7%9C-%D7%A4%D7%A8%D7%98%D7%A0%D7%99 , https://www.kolzchut.org.il/he/%D7%94%D7%95%D7%AA%D7%99%D7%A8_%D7%90%D7%97%D7%A8%D7%99%D7%95_%D7%97%D7%91%D7%A8.%D7%94. עודכנו: org, phone, web, email, cost, target, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '237|||טיפול לבני זוג שאיבדו בן/בת במהלך שירות (מלחמה, תאונה, מחלה, התאבדות)'
  AND COALESCE(public_fields->>'org', '') = 'חברה הותיר אחריו'
  AND COALESCE(public_fields->>'phone', '') = '050-8298292'
  AND COALESCE(public_fields->>'web', '') = ''
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'cost', '') = 'במימון משרד הביטחון'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '237|||טיפול לבני זוג שאיבדו בן/בת במהלך שירות (מלחמה, תאונה, מחלה, התאבדות)');

-- Row 238: אגף משפחות, הנצחה ומורשת (משרד הביטחון). 6 field(s), eligibility.
--   לתקן את הטלפון ל-03-7776700, להוסיף וואטסאפ, להחליף את האתר לאתר אגף המשפחות, ולפרט קהל יעד, שעות ודרך האישור.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-7776700","whatsapp":"97237776700","web":"https://mishpahot-hantzaha.mod.gov.il/emotional-support","cost":"במימון משרד הביטחון","target":"הורים שכולים, אלמנות ואלמנים, יתומים, אחים וארוסים של חללי מערכות הביטחון","notes":"שכולים ממערכי הביטחון. מרכז השירות: א''-ה'' 8:00-18:00, גם בוואטסאפ; מייל 7776700@mod.gov.il. אישור הטיפול דרך העובד/ת הסוציאלי/ת במחוז. ראו גם [חברה הותיר אחריו](https://nefesh-il.org/support?entry=237&section=families)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"recognition":{"btl":"any","mod":"required","moh":"any","rehab_basket":"any"}}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://shikum.mod.gov.il/ , https://mishpahot-hantzaha.mod.gov.il/contact-us , https://mishpahot-hantzaha.mod.gov.il/emotional-support , https://mishpahot-hantzaha.mod.gov.il/emotional-support/emotional-therapy. עודכנו: phone, whatsapp, web, cost, target, notes. התאמה: recognition.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '238|||טיפול קבוצתי/זוגי/פרטני לשכולים ואחים/יתומים/אלמנות'
  AND COALESCE(public_fields->>'phone', '') = '03-07776700'
  AND COALESCE(public_fields->>'whatsapp', '') = ''
  AND COALESCE(public_fields->>'web', '') = 'https://shikum.mod.gov.il/'
  AND COALESCE(public_fields->>'cost', '') = 'במימון'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'שכולים ממערכי הביטחון.';

-- Row 239: אל"ה — מרכז להתמודדות עם אבדן. 5 field(s).
--   לעדכן את הטלפון לתיאום טיפול (1-800-800-440), להוסיף וואטסאפ ולתקן את המייל ל-info@elah.org.il.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"1-800-800-440","phoneLabel":"תיאום טיפול","whatsapp":"972506644000","email":"info@elah.org.il","notes":""}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.elah.org.il/. עודכנו: phone, phoneLabel, whatsapp, email, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '239|||טיפול פרטני, זוגי, משפחתי וייעוץ פסיכיאטרי'
  AND COALESCE(public_fields->>'phone', '') = '03-6910921'
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'whatsapp', '') = ''
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'elah@elah.org.il';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '239|||טיפול פרטני, זוגי, משפחתי וייעוץ פסיכיאטרי');

-- Row 243: קווי תמיכה נפשית — קופות חולים (חרבות ברזל). 7 field(s).
--   השירות עדיין קיים: לתקן תוויות הטלפונים (כללית ולאומית דרך תלם), לעדכן את שעות מכבי (א'-ה' 8:00-16:00), ולציין שהשיחות בטלפון.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"svc":"3 שיחות טיפוליות בטלפון ללא עלות","phoneLabel":"כללית (א''-ה'' 7:00-20:00, ו'' 7:00-13:00)","phoneLabel2":"לאומית (דרך תלם)","phoneLabel3":"מכבי (א''-ה'' 8:00-16:00)","notes":"מאוחדת *3833 · לאומית *507 (קו כוננים 24/7). מכבי: מגיל 14, 3 שיחות פעמיים בשנה, בלי הפניה. לאומית: מגיל 18, שיחה חוזרת תוך 24 שעות. ראו גם [תלמ](https://nefesh-il.org/treatment?entry=203&section=trauma), [כללית](https://nefesh-il.org/treatment?entry=28&section=hmo), [מכבי](https://nefesh-il.org/treatment?entry=29&section=hmo), [מאוחדת](https://nefesh-il.org/support?entry=80&section=populations), [לאומית](https://nefesh-il.org/treatment?entry=81&section=therapists).","web":"https://me.health.gov.il/mental-health/therapy-rehabilitation/crisis-support/first-aid/","target":"מבוטחי קופות החולים במצוקה נפשית"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.telem.org.il/ , https://www.clalit.co.il/arb/your_health/family/Pages/phone_therapy.aspx , https://www.maccabi4u.co.il/eligibilites/2124/ , https://www.leumit.co.il/mental-health-arena/mental-health-services/ , https://me.health.gov.il/mental-health/therapy-rehabilitation/crisis-support/first-aid/. עודכנו: svc, phoneLabel, phoneLabel2, phoneLabel3, notes, web, target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '243|||3 שיחות טיפוליות מקוונות ללא עלות'
  AND COALESCE(public_fields->>'svc', '') = '3 שיחות טיפוליות מקוונות ללא עלות'
  AND COALESCE(public_fields->>'phoneLabel', '') = 'כללית/תלם'
  AND COALESCE(public_fields->>'phoneLabel2', '') = 'תלם חירום'
  AND COALESCE(public_fields->>'phoneLabel3', '') = 'מכבי (8:00-22:00)'
  AND COALESCE(public_fields->>'notes', '') = 'תלם חירום 072-2000272 · מכבי *3028 (8:00-22:00) · מאוחדת *3833 · לאומית *507'
  AND COALESCE(public_fields->>'web', '') = 'https://www.telem.org.il/'
  AND COALESCE(public_fields->>'target', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '243|||3 שיחות טיפוליות מקוונות ללא עלות');

-- Row 261: בשביל החיים. 5 field(s).
--   להוסיף מייל וטלפון נוסף, ולפרט בקהל היעד את סוגי המוות הפתאומי (התאבדות, תאונת דרכים, עבירת המתה).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"email":"centers@bishvil-hahayim.com","phone2":"03-7487771","phoneLabel2":"רכזת","target":"משפחות שכולות לאחר התאבדות, תאונת דרכים או עבירת המתה; הסברה ומניעה בקהילה","notes":"האתר אינו מוקד חירום — במצוקה מיידית פנו ל-1201 או 101. מרכזי סיוע במרכז ובדרום מטעם משרד הרווחה. ראו גם [עמותת ער\"ן (עזרה ראשונה נפשית)](https://nefesh-il.org/emergency?entry=20&section=emergency)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://path-to-life.org/. עודכנו: email, phone2, phoneLabel2, target, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '261|||מניעת אובדנות ותמיכה במשפחות שכולות לאחר התאבדות או מוות פתאומי'
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'phone2', '') = ''
  AND COALESCE(public_fields->>'phoneLabel2', '') = ''
  AND COALESCE(public_fields->>'target', '') = 'משפחות שכולות; הסברה ומניעה בקהילה'
  AND COALESCE(public_fields->>'notes', '') = 'האתר אינו מוקד חירום — במצוקה מיידית פנו ל-1201 או 101. מרכזי סיוע במרכז ובדרום מטעם משרד הרווחה.';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '261|||מניעת אובדנות ותמיכה במשפחות שכולות לאחר התאבדות או מוות פתאומי');

-- Row 262: עמותת עוצמה. 2 field(s).
--   לעדכן את הטלפון ל-052-3670386 ולהוסיף מייל.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"052-3670386","email":"ozma.office@gmail.com"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.ozma.org.il/. עודכנו: phone, email.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '262|||פורום ארצי של בני משפחה של מתמודדי נפש — תמיכה, מיצוי זכויות, סנגור והפחתת סטיגמה'
  AND COALESCE(public_fields->>'phone', '') = '02-5494567'
  AND COALESCE(public_fields->>'email', '') = '';

-- Row 282: מרכז צ׳ויס (CHOICE). 1 field(s), eligibility.
--   להוסיף מיקום במפה (בר כוכבא 23, בני ברק) ותנאי גיל 12-35.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"שירות היברידי (פרונטלי ודיגיטלי). ראו גם [האגודה לבריאות הציבור](https://nefesh-il.org/rights?entry=278&section=moh)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":12,"age_max":35}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.aguda.co.il/services/%d7%9e%d7%a8%d7%9b%d7%96-%d7%a6%d7%b3%d7%95%d7%99%d7%a1-choice/. עודכנו: notes. התאמה: age_min, age_max.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '282|||מרכז יום לנוער וצעירים (12–35) על רצף הטראומה וההתמכרות — אבחון, טיפול פרטני וקבוצתי וליווי שיקומי'
  AND COALESCE(public_fields->>'notes', '') = 'שירות היברידי (פרונטלי ודיגיטלי).';

COMMIT;
