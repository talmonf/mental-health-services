-- Migration 073 (16 Oct 2026)
-- Card review, batch 6: changes approved by the site owner, from docs/card-review-2026-10.md.
-- Each UPDATE only applies if the fields it changes still hold the reviewed text, so a later
-- admin edit is never overwritten. Pins are geocoded with OpenStreetMap Nominatim.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- Row 94: המרכז הישראלי להתמכרויות (ICA). 7 field(s), 1 pin(s), eligibility.
--   הפרטים בכרטיס תואמים את האתר; מוצע להוסיף נקודה במפה לכתובת המרכז בנתניה (הצורן 2).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"המרכז הישראלי להתמכרויות ובריאות הנפש (ICA)","web2":"https://ica.org.il/treatment_frames","webLabel2":"חיפוש מסגרות טיפול","add":"https://ica.org.il/contact","addLabel":"צור קשר","specialty":"התמכרויות","notes":"באתר: חיפוש מסגרות טיפול מורשות בהתמכרויות לפי אזור וסוג. המרפאה של ICA ברחוב הצורן 2, נתניה. זמן ההמתנה לכניסה לטיפול במרפאה הוא יותר מ-6 חודשים."}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"המרכז הישראלי להתמכרויות — מרפאה, נתניה","address":"הצורן 2, נתניה","lat":32.289513,"lng":34.8655217,"phone":"09-9789500","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://ica.org.il/. עודכנו: org, web2, webLabel2, add, addLabel, specialty, notes. אוחד עם כרטיס 89, שהיה כרטיס שני לאותו מרכז. התאמה: location_mode. סיכות: הצורן 2, נתניה.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '94|||מרכז לאומי מוביל לצמצום תופעת ההתמכרויות ונזקיה. טיפול, מידע והכוונה למי שמתמודד עם התמכרות'
  AND COALESCE(public_fields->>'org', '') = 'המרכז הישראלי להתמכרויות (ICA)'
  AND COALESCE(public_fields->>'web2', '') = ''
  AND COALESCE(public_fields->>'webLabel2', '') = ''
  AND COALESCE(public_fields->>'add', '') = ''
  AND COALESCE(public_fields->>'addLabel', '') = ''
  AND COALESCE(public_fields->>'specialty', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('המרכז הישראלי להתמכרויות — מרפאה, נתניה', 'הצורן 2, נתניה', 32.289513, 34.8655217, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '94|||מרכז לאומי מוביל לצמצום תופעת ההתמכרויות ונזקיה. טיפול, מידע והכוונה למי שמתמודד עם התמכרות' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

-- Row 95: מרכז גמילה - המרכז ההוליסטי "אחרת". 1 field(s), 1 pin(s), eligibility.
--   מוצע להוסיף את כתובת המרכז (העצמאות 34, אור עקיבא) כנקודה במפה ולציין שהמרכז פרטי ובתשלום.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"cost":"בתשלום (מרכז פרטי)"}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"המרכז ההוליסטי \"אחרת\"","address":"העצמאות 34, אור עקיבא","lat":32.5103607,"lng":34.9231784,"phone":"050-2244220","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://hacheret.com/. עודכנו: cost. התאמה: location_mode. סיכות: העצמאות 34, אור עקיבא.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '95|||מרכז גמילה הוליסטי לטיפול בהתמכרויות (סמים, אלכוהול, הימורים ועוד) המבוסס על 12 הצעדים וגישות טיפוליות נוספות'
  AND COALESCE(public_fields->>'cost', '') = '';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('המרכז ההוליסטי "אחרת"', 'העצמאות 34, אור עקיבא', 32.5103607, 34.9231784, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '95|||מרכז גמילה הוליסטי לטיפול בהתמכרויות (סמים, אלכוהול, הימורים ועוד) המבוסס על 12 הצעדים וגישות טיפוליות נוספות' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

-- Row 227: יתד (משרד הרווחה). 2 field(s), eligibility.
--   מוצע לתקן את טווח הגילים ל־18–26 לפי משרד הרווחה, להוסיף «למי» ולסמן הפניה דרך המחלקה לשירותים חברתיים.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"svc":"שירותים חברתיים לצעירים 18-26","target":"צעירים וצעירות 18–26 במצבי סיכון"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":18,"age_max":26}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://data.gov.il/dataset/ce12ebb6-fbec-4134-80b1-79d068bd96ee/resource/a683c177-131b-400d-b639-cc9b77e6f4c3/download/yated2022-explaination.pdf , https://beer-tuvia.org.il/%D7%AA%D7%9B%D7%A0%D7%99%D7%AA-%D7%99%D7%AA%D7%93-%D7%9C%D7%A6%D7%A2%D7%99%D7%A8%D7%99%D7%9D/ , https://rosh-haayin.muni.il/%D7%AA%D7%95%D7%9B%D7%A0%D7%99%D7%AA-%D7%99%D7%AA%D7%93-%D7%9C%D7%A6%D7%A2%D7%99%D7%A8%D7%99%D7%9D/. עודכנו: svc, target. התאמה: age_min, age_max.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '227|||שירותים חברתיים לצעירים 18-27'
  AND COALESCE(public_fields->>'svc', '') = 'שירותים חברתיים לצעירים 18-27'
  AND COALESCE(public_fields->>'target', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['court_or_welfare']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '227|||שירותים חברתיים לצעירים 18-27');

-- Row 231: משרד הרווחה — שירותי התמכרויות. 2 field(s).
--   מוצע לתקן מספר טלפון שגוי בהערות (02-5085814) ולהוסיף קישור לדף השירות להתמכרויות באתר gov.il.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"טלפונים נוספים: 02-5085814 · 02-5085850","web":"https://www.gov.il/he/Departments/units/molsa-units-addiction-treatment-service"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.gov.il/he/Departments/units/molsa-units-addiction-treatment-service. עודכנו: notes, web.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '231|||ייעוץ והפניה — חברתי-ביטחוני'
  AND COALESCE(public_fields->>'notes', '') = '02-5065814 · 02-5085850'
  AND COALESCE(public_fields->>'web', '') = '';

-- Row 240: מאגר מענים — ילדים ונוער (חרבות ברזל). 1 field(s).
--   לא ניתן היה לפתוח את הדף ב־gov.il; מוצע לקשר את על"ם, ער"ן ומוקד 105 לכרטיסים שלהם.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"ראו גם: eran.org.il ותוכניות משרד הרווחה. ראו גם [עמותת על\"ם](https://nefesh-il.org/support?entry=256&section=youth), [עמותת ער\"ן (עזרה ראשונה נפשית)](https://nefesh-il.org/emergency?entry=20&section=emergency), [מוקד 105 — המטה הלאומי להגנה על ילדים ברשת](https://nefesh-il.org/emergency?entry=267&section=emergency)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.gov.il/he/pages/children_online_safety. עודכנו: notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '240|||קישורים למטה להגנה, על"ם, מצמיחים, בית בטוח לנוער, נע"ן, עמותת ל.מ.ה, עמ"י ועוד'
  AND COALESCE(public_fields->>'notes', '') = 'ראו גם: eran.org.il ותוכניות משרד הרווחה.';

-- Row 241: יחידה להתערבות במשבר — מרכז רפואי העמק (כללית). 3 field(s).
--   מוצע לתקן את תדירות הטיפול (לפחות 3 פגישות בשבוע), לציין שנדרש טופס 17 ודרכי הפנייה, ולהוסיף קישור לדף משרד הבריאות.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"לפחות 3 פגישות בשבוע, עד 6 שבועות. פנייה בדרך כלל דרך חדר מיון, וגם דרך רופא/ת משפחה, פסיכיאטר/ית, יועץ/ת חינוכי/ת או ישירות. נדרש טופס 17 מקופת החולים. פנייה: ayol_clalit.org.il","cost":"במסגרת קופת החולים (טופס 17)","web":"https://me.health.gov.il/mental-health/therapy-rehabilitation/public-care/kids-and-teens/intervention-centers/"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://me.health.gov.il/mental-health/therapy-rehabilitation/public-care/kids-and-teens/intervention-centers/. עודכנו: notes, cost, web.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '241|||טיפול משפחתי אינטנסיבי לילדים 6-18'
  AND COALESCE(public_fields->>'notes', '') = '2-3 טיפולים בשבוע, עד 6 שבועות. פנייה: ayol_clalit.org.il'
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'web', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral', 'gp_referral', 'psychiatrist_referral', 'hmo_form17']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '241|||טיפול משפחתי אינטנסיבי לילדים 6-18');

-- Row 249: רטורנו — גמילה מהתמכרויות. 1 field(s).
--   הפרטים תואמים; מוצע לקשר בהערות לכרטיסי הטראומה של רטורנו (חוות חוסן, חיבוק ברזל).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"מעני טראומה של רטורנו מופיעים גם בקטגוריות אחרות — כרטיס זה לגמילה והחלמה. ראו גם [רטורנו — חוות חוסן](https://nefesh-il.org/treatment?entry=211&section=trauma), [חיבוק ברזל (רטורנו)](https://nefesh-il.org/treatment?entry=230&section=trauma)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://retorno.org.il/. עודכנו: notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '249|||אשפוזית, טיפול יום וקהילות טיפוליות לגמילה ושיקום; מותאם גם לאוכלוסייה דתית וחרדית; מפוקח ע״י משרדי הבריאות והרווחה'
  AND COALESCE(public_fields->>'notes', '') = 'מעני טראומה של רטורנו מופיעים גם בקטגוריות אחרות — כרטיס זה לגמילה והחלמה';

-- Row 250: דרך אחרת. 1 field(s), 1 pin(s), eligibility.
--   מוצע להוסיף כתובת דוא"ל (office@acher.org.il) ונקודה במפה ברחוב ההדס 4, בית שמש.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"email":"office@acher.org.il"}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"דרך אחרת — בית שמש","address":"ההדס 4, בית שמש","lat":31.7436051,"lng":34.9748397,"phone":"02-6661166","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://acher.org.il/. עודכנו: email. התאמה: location_mode. סיכות: ההדס 4, בית שמש.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '250|||מרכז ברישיון משרד הבריאות לטיפול בהתמכרויות — בית מאזן לתחלואה כפולה, מרפאת יום, גמילה ותמיכה למשפחות; בשיתוף קופות החולים'
  AND COALESCE(public_fields->>'email', '') = '';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('דרך אחרת — בית שמש', 'ההדס 4, בית שמש', 31.7436051, 34.9748397, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '250|||מרכז ברישיון משרד הבריאות לטיפול בהתמכרויות — בית מאזן לתחלואה כפולה, מרפאת יום, גמילה ותמיכה למשפחות; בשיתוף קופות החולים' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

-- Row 252: אל-אנון ישראל. 1 field(s).
--   הפרטים תואמים; מוצע לקשר את האזכור של א.א. בהערות לכרטיס של א.א.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"נפרד מא.א.; אל-טין לנוער קיים במסגרת אל-אנון. ראו גם [א.א. אלכוהוליסטים אנונימיים](https://nefesh-il.org/treatment?entry=253&section=addictions)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://al-anon-israel.org/. עודכנו: notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '252|||קבוצות תמיכה אנונימיות (12 צעדים) למשפחות וחברים של אנשים הסובלים מאלכוהוליזם — פרונטלי וזום'
  AND COALESCE(public_fields->>'notes', '') = 'נפרד מא.א.; אל-טין לנוער קיים במסגרת אל-אנון';

-- Row 253: א.א. אלכוהוליסטים אנונימיים. 1 field(s).
--   הפרטים תואמים; מוצע לקשר את האזכור של אל-אנון בהערות לכרטיס של אל-אנון.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"למשפחות — אל-אנון. ראו גם [אל-אנון ישראל](https://nefesh-il.org/treatment?entry=252&section=addictions)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.aa-israel.co.il/ , https://www.aa-israel.org/bigbook/. עודכנו: notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '253|||קבוצות עזרה עצמית אנונימיות (12 צעדים) לאנשים הסובלים מבעיית שתייה'
  AND COALESCE(public_fields->>'notes', '') = 'למשפחות — אל-אנון';

-- Row 254: עמותת נוה מלכישוע. 1 field(s).
--   מוצע למלא «למי»: נפגעי סמים ואלכוהול — נוער, צעירים, מבוגרים ונשים.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"נפגעי סמים ואלכוהול — נוער, צעירים, מבוגרים ונשים"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://malkishua.org.il/. עודכנו: target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '254|||כפר ומרכז לטיפול בהתמכרויות — גמילה פיזית, קהילות טיפוליות לנוער/צעירים/בגירים/נשים; בפיקוח משרדי הרווחה והבריאות'
  AND COALESCE(public_fields->>'target', '') = '';

-- Row 257: עמותת אל-סם. 2 field(s).
--   מוצע להוסיף דוא"ל, לציין שהטיפול מסובסד לפי הצורך ושאפשר לפנות ישירות.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"email":"contact@alsam.org.il","cost":"מסובסד לפי הצורך"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://alsam.org.il/ , https://alsam.org.il/our-therapists/. עודכנו: email, cost.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '257|||ייעוץ וטיפול לנוער וצעירים עד גיל 24 ולהוריהם בנושאי סמים, אלכוהול והתמכרויות'
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'cost', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '257|||ייעוץ וטיפול לנוער וצעירים עד גיל 24 ולהוריהם בנושאי סמים, אלכוהול והתמכרויות');

-- Row 258: כנפיים של קרמבו. 3 field(s).
--   הגילים בכרטיס נכונים; מוצע להוסיף את טלפון המשרד 09-8852385 ולתייג את שני המספרים.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone2":"09-8852385","phoneLabel":"מענה קולי 24 שעות","phoneLabel2":"משרד"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.krembo.org.il/ , https://www.krembo.org.il/%D7%90%D7%95%D7%93%D7%95%D7%AA/ , https://www.krembo.org.il/%D7%A6%D7%95%D7%A8-%D7%A7%D7%A9%D7%A8/. עודכנו: phone2, phoneLabel, phoneLabel2.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '258|||תנועת נוער משלבת לילדים עם ובלי צרכים מיוחדים — שילוב חברתי מלא ושוויוני'
  AND COALESCE(public_fields->>'phone2', '') = ''
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'phoneLabel2', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '258|||תנועת נוער משלבת לילדים עם ובלי צרכים מיוחדים — שילוב חברתי מלא ושוויוני');

-- Row 259: איגי — ארגון הנוער הגאה. 0 field(s).
--   לא ניתן לאמת את מספר הטלפון בכרטיס; מוצע לסמן שאפשר להצטרף ישירות.
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://igy.org.il/ , https://igy.org.il/contact , https://www.d.co.il/77225490/300/.', E'\n ')),
    updated_at = now()
WHERE card_key = '259|||תנועת נוער וצעירים להט"ב — קבוצות חברתיות ותמיכה בעשרות יישובים';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '259|||תנועת נוער וצעירים להט"ב — קבוצות חברתיות ותמיכה בעשרות יישובים');

-- Row 266: עמותת מיט"ב. 1 field(s).
--   מוצע למלא «למי» (ילדים, מתבגרים ומבוגרים) ולהוסיף נקודה במפה במתחם המועצה האזורית גליל עליון.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"ילדים, מתבגרים ומבוגרים"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.meitav.net/. עודכנו: target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '266|||מרכז רב-תחומי לייעוץ, טיפול וחינוך בקהילה — ילדים, מתבגרים ומבוגרים; כולל יחידת קשב'
  AND COALESCE(public_fields->>'target', '') = '';

-- Row 284: החוט המשולש. 0 field(s), eligibility.
--   הפרטים תואמים; מוצע לקבוע תנאי גיל 14–25.
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":14,"age_max":25}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://meshulash.org/. התאמה: age_min, age_max.', E'\n ')),
    updated_at = now()
WHERE card_key = '284|||בית חם, מרחב פתוח והלנת חירום לנוער וצעירים בסיכון — כולל שלטר לצעירות חרדיות';

-- Row 285: בית השנטי. 0 field(s), 2 pin(s), eligibility.
--   הפרטים תואמים; מוצע להוסיף שלוש נקודות במפה (תל אביב, ירושלים, מדבר) ותנאי גיל 14–21.
UPDATE directory_card_edits
SET sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"בית השנטי תל אביב","address":"נחום גולדמן 5, תל אביב-יפו","lat":32.0575316,"lng":34.7578575,"phone":"03-5103339","email":"","sort_order":0},{"label":"בית השנטי ירושלים","address":"מדרגות הביקור 2, עין כרם, ירושלים","lat":31.765403,"lng":35.1601488,"phone":"054-7080100","email":"","sort_order":1}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":14,"age_max":21,"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://shanti.org.il/. התאמה: age_min, age_max, location_mode. סיכות: נחום גולדמן 5, תל אביב-יפו; מדרגות הביקור 2, עין כרם, ירושלים.', E'\n ')),
    updated_at = now()
WHERE card_key = '285|||בית חם ומקלט חירום לנוער בסיכון ובסכנת חיים (14–21)';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('בית השנטי תל אביב', 'נחום גולדמן 5, תל אביב-יפו', 32.0575316, 34.7578575, 0),
  ('בית השנטי ירושלים', 'מדרגות הביקור 2, עין כרם, ירושלים', 31.765403, 35.1601488, 1)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '285|||בית חם ומקלט חירום לנוער בסיכון ובסכנת חיים (14–21)' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

-- Row 286: עמותת יחדיו — קורת גג בראשית. 0 field(s), 1 pin(s), eligibility.
--   הפרטים תואמים; מוצע להוסיף נקודה במפה (משה דיין 1, באר שבע), תנאי גיל 12–18 ופנייה עצמית.
UPDATE directory_card_edits
SET sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"קורת גג בראשית","address":"משה דיין 1, באר שבע","lat":31.2648999,"lng":34.7725441,"phone":"08-6868610","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":12,"age_max":18,"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.yachdav.org.il/ , https://www.yachdav.org.il/%D7%91%D7%A8%D7%90%D7%A9%D7%99%D7%AA. התאמה: age_min, age_max, location_mode. סיכות: משה דיין 1, באר שבע.', E'\n ')),
    updated_at = now()
WHERE card_key = '286|||קורת גג 24/7 לנוער 12–18 ללא קבלה בירוקרטית — עד 3 חודשים';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('קורת גג בראשית', 'משה דיין 1, באר שבע', 31.2648999, 34.7725441, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '286|||קורת גג 24/7 לנוער 12–18 ללא קבלה בירוקרטית — עד 3 חודשים' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '286|||קורת גג 24/7 לנוער 12–18 ללא קבלה בירוקרטית — עד 3 חודשים');

-- Row 287: אנוש — הלנת חירום. 1 field(s), 2 pin(s), eligibility.
--   הפרטים תואמים; מוצע להוסיף שתי נקודות במפה (עומר, קריית חיים), תנאי גיל 18–25 וקישור לכרטיס אנוש.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"עומר — צעירים וצעירות, מרגנית 31. קריית חיים — צעירות, הגדוד העברי 58. בפיקוח משרד הרווחה. שונה מכרטיס סל השיקום של אנוש. ראו גם [אנוש](https://nefesh-il.org/rights?entry=6&section=moh)."}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"הלנת חירום עומר — צעירים וצעירות","address":"מרגנית 31, עומר","lat":31.2752897,"lng":34.8482097,"phone":"054-8101690","email":"","sort_order":0},{"label":"הלנת חירום קריית חיים — צעירות","address":"הגדוד העברי 58, קריית חיים, חיפה","lat":32.8243569,"lng":35.0685844,"phone":"054-9299625","email":"","sort_order":1}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":18,"age_max":25,"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.enosh.org.il/%D7%94%D7%9C%D7%A0%D7%AA-%D7%97%D7%99%D7%A8%D7%95%D7%9D/. עודכנו: notes. התאמה: age_min, age_max, location_mode. סיכות: מרגנית 31, עומר; הגדוד העברי 58, קריית חיים, חיפה.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '287|||קורת גג 24/7 לצעירים 18–25 ללא עורף משפחתי — עד 6 חודשים'
  AND COALESCE(public_fields->>'notes', '') = 'עומר — צעירים וצעירות, מרגנית 31. קריית חיים — צעירות, הגדוד העברי 58. בפיקוח משרד הרווחה. שונה מכרטיס סל השיקום של אנוש.';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('הלנת חירום עומר — צעירים וצעירות', 'מרגנית 31, עומר', 31.2752897, 34.8482097, 0),
  ('הלנת חירום קריית חיים — צעירות', 'הגדוד העברי 58, קריית חיים, חיפה', 32.8243569, 35.0685844, 1)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '287|||קורת גג 24/7 לצעירים 18–25 ללא עורף משפחתי — עד 6 חודשים' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

-- Row 288: עו״ס יתד. 0 field(s), eligibility.
--   מוצע לקבוע תנאי גיל 18–26 ולסמן הפניה דרך המחלקה לשירותים חברתיים.
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":18,"age_max":26}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.gov.il/he/departments/dynamiccollectors/molsa-yated-social-workers , https://data.gov.il/dataset/ce12ebb6-fbec-4134-80b1-79d068bd96ee/resource/a683c177-131b-400d-b639-cc9b77e6f4c3/download/yated2022-explaination.pdf , https://beer-tuvia.org.il/%D7%AA%D7%9B%D7%A0%D7%99%D7%AA-%D7%99%D7%AA%D7%93-%D7%9C%D7%A6%D7%A2%D7%99%D7%A8%D7%99%D7%9D/. התאמה: age_min, age_max.', E'\n ')),
    updated_at = now()
WHERE card_key = '288|||עובד/ת סוציאלי/ת בתוכנית יתד — ליווי צעירים וצעירות (18–25/26) במצבי חיים מורכבים';

UPDATE directory_entries
SET referral_codes = ARRAY['court_or_welfare']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '288|||עובד/ת סוציאלי/ת בתוכנית יתד — ליווי צעירים וצעירות (18–25/26) במצבי חיים מורכבים');

COMMIT;
