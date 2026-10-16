-- Migration 072 (16 Oct 2026)
-- Card review, batch 5: changes approved by the site owner, from docs/card-review-2026-10.md.
-- Each UPDATE only applies if the fields it changes still hold the reviewed text, so a later
-- admin edit is never overwritten. Pins are geocoded with OpenStreetMap Nominatim.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- Row 38: בתי חולים פסיכיאטריים ומחלקות פסיכיאטריות בבתי חולים כלליים. 4 field(s).
--   להוסיף למי מיועד (מצב נפשי חריף, מבוגרים וילדים), אזור כל הארץ, דרך הפנייה (מיון, רופא משפחה, גורם מטפל או הגעה עצמית) וקישור להסבר של משרד הבריאות.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"מבוגרים, ילדים ונוער במצב נפשי חריף שלא ניתן לאזן בקהילה","region":"כל הארץ","web2":"https://me.health.gov.il/mental-health/therapy-rehabilitation/public-care/psychiatric-hospitalization/mental-health-facilities/","webLabel2":"הסבר על אשפוז"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.gov.il/he/Departments/DynamicCollectors/hospitals_psyc?skip=0 , https://me.health.gov.il/mental-health/therapy-rehabilitation/public-care/psychiatric-hospitalization/mental-health-facilities/ , https://mental-data.datacity.org.il/dataset/hospitals_psyc. עודכנו: target, region, web2, webLabel2.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '38|||אשפוז פסיכיאטרי'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'web2', '') = ''
  AND COALESCE(public_fields->>'webLabel2', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral', 'gp_referral', 'psychiatrist_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '38|||אשפוז פסיכיאטרי');

-- Row 43: שרן רפואה עד הבית. 6 field(s), eligibility.
--   להוסיף למי מיועד (מגיל 18, עם מטפל עיקרי), טלפונים, גיל מינימום 18, הפניה מרופא משפחה או פסיכיאטר, ולציין שאפשר גם באופן פרטי.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"מגיל 18, במשבר נפשי או בהחמרה, שאינם מסוכנים לעצמם או לסביבה, מסכימים לטיפול, ויש להם מטפל עיקרי בגיר בבית","cost":"ללא תשלום בהפניה של קופת החולים (כללית, מאוחדת ולאומית). אפשר גם באופן פרטי","phone":"1-700-508-586","phoneLabel":"כללי","phone2":"03-7545928","phoneLabel2":"שירות פרטי (שלוחה 2)"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":18}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://sharanmedical.co.il/psychiatric-home-hospitalization/. עודכנו: target, cost, phone, phoneLabel, phone2, phoneLabel2. אוחד עם כרטיס 44. לא נמצא מקור למימון משרד הביטחון שכרטיס 44 ציין. התאמה: age_min.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '43|||אשפוז בית פסיכיאטרי'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'cost', '') = 'ממונן ע"י הקופות: כללית, מאוחדת ולאומית'
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'phone2', '') = ''
  AND COALESCE(public_fields->>'phoneLabel2', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['gp_referral', 'psychiatrist_referral', 'hmo_form17']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '43|||אשפוז בית פסיכיאטרי');

-- Row 45: שרן רפואה עד הבית. 1 field(s).
--   נראה שהשירות 'הקול שבפנים' הופסק: הקישור בכרטיס מוביל לדף אשפוז בית כללי ואתר השירות מחזיר שגיאה. כדאי לברר מול שרן לפני הסרה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"ייתכן שהשירות הסתיים: דף השירות באתר שרן כבר לא פעיל. כדאי לבדוק מול שרן לפני שפונים. שירות למשפחות וצעירים (12-35) החווים הסתגרות ונסיגה תפקודית."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://sharanmedical.co.il/voiceover/ , https://voiceover.sharanmedical.co.il/ , https://voiceover.sharanmedical.co.il/free-consulting , https://voiceover.sharanmedical.co.il/intervention. עודכנו: notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '45|||הקול שבפנים – טיפול ביתי לצעירים במצבי משבר נפשי'
  AND COALESCE(public_fields->>'notes', '') = 'שירות למשפחות וצעירים (12-35) החווים הסתגרות ונסיגה תפקודית.';

-- Row 48: צבר רפואה. 4 field(s).
--   להוסיף טלפונים (*2590, 072-2508878), דוא"ל ולמי מתאים, ולציין שהפנייה דרך הגורם המטפל בקהילה או בבית החולים.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"*2590","phone2":"072-2508878","email":"Office@SabarHealth.co.il","target":"מתמודדים שאינם זקוקים להשגחה מסביב לשעון ואינם בסיכון לעצמם או לאחרים, משתפים פעולה עם הטיפול התרופתי, ויש להם מטפל עיקרי זמין"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.sabarhealth.co.il/%d7%a4%d7%a1%d7%99%d7%9b%d7%99%d7%90%d7%98%d7%a8%d7%99%d7%94-%d7%91%d7%91%d7%99%d7%aa/. עודכנו: phone, phone2, email, target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '48|||אשפוז בית פסיכיאטרי'
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'phone2', '') = ''
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'target', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['psychiatrist_referral', 'hmo_form17']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '48|||אשפוז בית פסיכיאטרי');

-- Row 53: בתים מאזנים. 3 field(s).
--   להוסיף למי מיועד, אזור כל הארץ, עלות (טופס 17 והשתתפות עצמית קטנה) ודרך הפנייה (הצוות המטפל בקופה או רופא המשפחה).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"מי שנמצא במצב נפשי חמור וחריף שדורש אשפוז או חלופה אינטנסיבית, מסכים לטיפול ויכול לשתף פעולה. יש בתים לבני נוער ולמבוגרים","region":"כל הארץ","cost":"במימון קופת החולים (טופס 17), עם השתתפות עצמית של כמה עשרות שקלים"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://me.health.gov.il/mental-health/therapy-rehabilitation/public-care/community-treatment/balancing-homes/ , https://www.gov.il/he/Departments/DynamicCollectors/ballancing-homes-db?skip=0. עודכנו: target, region, cost.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '53|||חלופת אשפוז'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'cost', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['gp_referral', 'psychiatrist_referral', 'hmo_form17']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '53|||חלופת אשפוז');

-- Row 65: מכון למרחב (מרכז טיפולי רב תחומי). 4 field(s), 3 pin(s), eligibility.
--   להוסיף למי מיועד, עלות (חינם דרך הקופות), דוא"ל, שפות, וארבע נקודות במפה למרפאות בירושלים, בית שמש, ביתר עילית ורחובות.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"הציבור הדתי-חרדי: ילדים, נוער ומבוגרים","cost":"חינם במסגרת קופות החולים (הרפורמה בבריאות הנפש)","email":"office@lamerchav.org.il","languages":"עברית, אנגלית, אידיש, צרפתית, איטלקית, הונגרית"}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"מכון למרחב ירושלים","address":"חירם 4, ירושלים","lat":31.7930526,"lng":35.2079737,"phone":"02-5954571 שלוחה 1","email":"","sort_order":0},{"label":"מכון למרחב בית שמש","address":"נחל הירקון 34, בית שמש","lat":31.7058739,"lng":35.0066443,"phone":"02-5954571 שלוחה 2","email":"","sort_order":1},{"label":"מכון למרחב רחובות","address":"לוין אפשטיין 39, רחובות","lat":31.896832,"lng":34.8073698,"phone":"08-6308892","email":"","sort_order":2}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.lamerchav.org.il/ , https://www.lamerchav.org.il/pt_clinics/machon_lamerchav/. עודכנו: target, cost, email, languages. התאמה: location_mode. סיכות: חירם 4, ירושלים; נחל הירקון 34, בית שמש; לוין אפשטיין 39, רחובות.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '65|||מענה מקצועי מותאם תרבות בתחום בריאות הנפש לאוכלוסיה הדתית - חרדית.'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'languages', '') = '';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('מכון למרחב ירושלים', 'חירם 4, ירושלים', 31.7930526, 35.2079737, 0),
  ('מכון למרחב בית שמש', 'נחל הירקון 34, בית שמש', 31.7058739, 35.0066443, 1),
  ('מכון למרחב רחובות', 'לוין אפשטיין 39, רחובות', 31.896832, 34.8073698, 2)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '65|||מענה מקצועי מותאם תרבות בתחום בריאות הנפש לאוכלוסיה הדתית - חרדית.' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

-- Row 69: דיאלוג פתוח בישראל (דפ"י). 4 field(s).
--   להבהיר שדפ"י הוא ארגון הכשרה, לתייג את הטלפון כפרויקט מעגלים, ולהוסיף אזורים, עלות והערות על שלוש דרכי הטיפול.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"פרויקט מעגלים (חיפה–נצרת–חוף הכרמל)","region":"פרטי: כל הארץ. ציבורי: עכו, ירושלים. מסובסד: חיפה–נצרת–חוף הכרמל","cost":"פרטי; במימון מלא במרפאות הציבוריות בעכו ובכפר שאול; מסובסד בפרויקט מעגלים","notes":"דפ\"י הוא ארגון הכשרה ואינו נותן טיפול בעצמו. אפשר לקבל טיפול בגישת דיאלוג פתוח: באופן פרטי אצל בוגרי ההכשרות בכל הארץ; במימון מלא ב\"מרפאת דיאלוג פתוח\" בעכו (מרכז מזור) ובמרפאה בכפר שאול של [המרכז הירושלמי לבריאות הנפש](https://nefesh-il.org/support?entry=78&section=moh) (בטופס הפנייה במייל); ובמימון מסובסד בפרויקט מעגלים באזור חיפה–נצרת–חוף הכרמל, בטלפון א''–ה'' 10:30–13:00 ו-14:00–15:30."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://opendialogue.co.il/therapy/. עודכנו: phoneLabel, region, cost, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '69|||טיפול משפחתי-מערכתי למצבי משבר'
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

-- Row 70: עמך - המרכז הישראלי לתמיכה נפשית וחברתית בניצולי השואה והדור השני. 5 field(s), 12 pin(s), eligibility.
--   להרחיב את 'למי' (גם נפגעי טראומה, מילואים וילדים), להוסיף אזור, עלות, דוא"ל ו-14 נקודות במפה לסניפי עמך.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"ניצולי שואה והדור השני, וגם נפגעי טראומה, חרדה ואובדן ובני משפחותיהם, חיילי מילואים, ילדים ובני נוער","region":"כל הארץ (סניפים מנהריה עד באר שבע)","cost":"במסגרת הסדרים עם קופות החולים, או טיפול פרטי מסובסד","email":"amcha@amcha.org","notes":"ראו גם [עמ\"ך](https://nefesh-il.org/treatment?entry=212&section=trauma)."}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"עמך נהריה","address":"לוחמי הגטאות 18, נהריה","lat":33.0018976,"lng":35.0973758,"phone":"04-6665566","email":"","sort_order":0},{"label":"עמך קריית מוצקין","address":"יוני נתניהו 8, קריית מוצקין","lat":32.842326,"lng":35.087608,"phone":"04-8766967","email":"","sort_order":1},{"label":"עמך חיפה והצפון","address":"שדרות בן גוריון 6, קומה 4 (קניון הסיטי סנטר), חיפה","lat":32.8233985,"lng":34.9925078,"phone":"04-8375649","email":"","sort_order":2},{"label":"עמך נתניה","address":"סמילנסקי 4, נתניה","lat":32.3284841,"lng":34.8560923,"phone":"09-8341670","email":"","sort_order":3},{"label":"עמך פתח תקווה","address":"ההסתדרות 19, פתח תקווה","lat":32.0859522,"lng":34.8834559,"phone":"03-9300577","email":"","sort_order":4},{"label":"עמך תל אביב וגוש דן","address":"מזא\"ה 58, תל אביב","lat":32.06522,"lng":34.779805,"phone":"03-5665701","email":"","sort_order":5},{"label":"עמך חולון","address":"הרצוג 14, חולון","lat":32.019831,"lng":34.7800664,"phone":"03-5584054","email":"","sort_order":6},{"label":"עמך ראשון לציון","address":"ז''בוטינסקי 16, ראשון לציון","lat":31.962774,"lng":34.8005569,"phone":"03-6225301","email":"","sort_order":7},{"label":"עמך רחובות","address":"הרצל 143, רחובות","lat":31.8948428,"lng":34.8113535,"phone":"08-9467293","email":"","sort_order":8},{"label":"עמך אשדוד","address":"חיים משה שפירא 22, משרד 109, אשדוד","lat":31.8006566,"lng":34.6421682,"phone":"08-6119671","email":"","sort_order":9},{"label":"עמך אשקלון","address":"הרצל 3, קומה 2 (בית פרנק), אשקלון","lat":31.6676302,"lng":34.5866477,"phone":"08-6847328","email":"","sort_order":10},{"label":"עמך באר שבע ושדרות","address":"הרצל 91, באר שבע","lat":31.2386242,"lng":34.7869831,"phone":"08-6270224","email":"","sort_order":11}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.amcha.org/ , https://www.amcha.org/%D7%A6%D7%95%D7%A8-%D7%A7%D7%A9%D7%A8/. עודכנו: target, region, cost, email, notes. התאמה: location_mode. סיכות: לוחמי הגטאות 18, נהריה; יוני נתניהו 8, קריית מוצקין; שדרות בן גוריון 6, קומה 4 (קניון הסיטי סנטר), חיפה; סמילנסקי 4, נתניה; ההסתדרות 19, פתח תקווה; מזא"ה 58, תל אביב; הרצוג 14, חולון; ז''בוטינסקי 16, ראשון לציון; הרצל 143, רחובות; חיים משה שפירא 22, משרד 109, אשדוד; הרצל 3, קומה 2 (בית פרנק), אשקלון; הרצל 91, באר שבע.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '70|||תמיכה נפשית וחברתית בניצולי השואה והדור השני '
  AND COALESCE(public_fields->>'target', '') = 'ניצולי השואה והדור השני'
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('עמך נהריה', 'לוחמי הגטאות 18, נהריה', 33.0018976, 35.0973758, 0),
  ('עמך קריית מוצקין', 'יוני נתניהו 8, קריית מוצקין', 32.842326, 35.087608, 1),
  ('עמך חיפה והצפון', 'שדרות בן גוריון 6, קומה 4 (קניון הסיטי סנטר), חיפה', 32.8233985, 34.9925078, 2),
  ('עמך נתניה', 'סמילנסקי 4, נתניה', 32.3284841, 34.8560923, 3),
  ('עמך פתח תקווה', 'ההסתדרות 19, פתח תקווה', 32.0859522, 34.8834559, 4),
  ('עמך תל אביב וגוש דן', 'מזא"ה 58, תל אביב', 32.06522, 34.779805, 5),
  ('עמך חולון', 'הרצוג 14, חולון', 32.019831, 34.7800664, 6),
  ('עמך ראשון לציון', 'ז''בוטינסקי 16, ראשון לציון', 31.962774, 34.8005569, 7),
  ('עמך רחובות', 'הרצל 143, רחובות', 31.8948428, 34.8113535, 8),
  ('עמך אשדוד', 'חיים משה שפירא 22, משרד 109, אשדוד', 31.8006566, 34.6421682, 9),
  ('עמך אשקלון', 'הרצל 3, קומה 2 (בית פרנק), אשקלון', 31.6676302, 34.5866477, 10),
  ('עמך באר שבע ושדרות', 'הרצל 91, באר שבע', 31.2386242, 34.7869831, 11)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '70|||תמיכה נפשית וחברתית בניצולי השואה והדור השני ' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '70|||תמיכה נפשית וחברתית בניצולי השואה והדור השני ');

-- Row 71: עמותת לשמה. 1 field(s).
--   האתר כמעט ריק; אפשר להוסיף למי מיועד, אבל לא ניתן לאמת את הטלפון או את השירותים בפועל.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"אנשים המתמודדים עם קשיים נפשיים (עמותה שנוסדה ומופעלת על ידי מתמודדים)"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.lishma.co.il/. עודכנו: target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '71|||לשילוב מתמודדים והעצמה בבריאות הנפש'
  AND COALESCE(public_fields->>'target', '') = '';

-- Row 72: זה בנפשי. 2 field(s).
--   להוסיף למי מיועד (ילדים ונוער במרכזי בריאות הנפש ומשפחותיהם) ודוא"ל.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"ילדים ובני נוער המאושפזים או מטופלים במרכזי בריאות הנפש, ובני משפחותיהם","email":"zebenafshi@gmail.com"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.zebenafshi.com/. עודכנו: target, email.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '72|||תמיכה בילדים ונוער המטופלים במרכזי בריאות הנפש'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'email', '') = '';

-- Row 73: מכון צוהר. 5 field(s).
--   לתייג את הטלפון כניהול ארצי, ולהוסיף דוא"ל, למי מיועד, אזור כל הארץ ואנשי קשר לפי אזור.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"ניהול ארצי","email":"max.tzohar@gmail.com","target":"אנשים המתמודדים עם מצבי תקיעות, משבר ומצוקה נפשית","region":"כל הארץ","notes":"אנשי קשר לפי אזור: צפון 052-6797493, מרכז והשפלה 050-3030560, ירושלים 054-5442964, השרון 054-4212721, תל אביב וגוש דן 054-6284266."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.machon-tzohar.com/. עודכנו: phoneLabel, email, target, region, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '73|||נתיבי שיקום והחלמה'
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '73|||נתיבי שיקום והחלמה');

-- Row 74: חברת נתן. 6 field(s).
--   לנקות את שדה הטלפון ולהוסיף תווית, למי מיועד, אזור, עלות (סל שיקום, משרד הביטחון או פרטי), רשימת שירותים ונקודה לקהילה השיקומית ברמת גן.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"072-3926558","phoneLabel":"מוקד ארצי – ייעוץ חינם","target":"מתמודדים עם מגבלה נפשית","region":"כל הארץ","cost":"במסגרת סל שיקום, אגף השיקום במשרד הביטחון, או באופן פרטי","notes":"חונכות חברתית, תמיכה בלימודים אקדמיים, השלמת השכלה, דיור מוגן וסומכות שיקומית. אפשר גם באופן פרטי בזמן תהליך ההכרה בזכאות."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://nathan.co.il/%d7%a9%d7%99%d7%a7%d7%95%d7%9d-%d7%95%d7%91%d7%a8%d7%99%d7%90%d7%95%d7%aa-%d7%94%d7%a0%d7%a4%d7%a9/. עודכנו: phone, phoneLabel, target, region, cost, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '74|||שיקום ובריאות הנפש'
  AND COALESCE(public_fields->>'phone', '') = 'לייעוץ חינם 072-3926558'
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['rehab_basket_committee', 'mod_rehab_worker', 'self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '74|||שיקום ובריאות הנפש');

-- Row 79: שרן רפואה עד הבית. 1 field(s).
--   התוכנית ('גשר לנפש') הסתיימה בסוף 2024 ואינה מקבלת מטופלים; מומלץ להסתיר את הכרטיס.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"לפי אתר שרן, התוכנית הסתיימה בסוף 2024 ואינה מקבלת מטופלים כרגע."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.sharanmedical.co.il/gesher-le-nefesh/. עודכנו: notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '79|||תוכנית טיפול ביתי ממושך למתמודדים עם מחלת נפש חמורה'
  AND COALESCE(public_fields->>'notes', '') = '';

-- Row 80: Amudim. 1 field(s).
--   להוסיף דוא"ל ואת כתובת המשרד בירושלים (נתן שטראוס 3).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"email":"office@amudim.org.il"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://amudim.org.il/. עודכנו: email.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '80|||Clinical case management for English-speakers in Israel from all walks of life: counseling, referrals to therapists, treatment programs, guidance through the legal process'
  AND COALESCE(public_fields->>'email', '') = '';

-- Row 83: עזר מציון הסעות. 8 field(s).
--   לתקן טלפונים: 03-5742742 הוא מוקד רפואי, 1800-236-236 הוא קו תרומות, ו-073-3956218 הוא מרכזי משפחות ולא נהגים מתנדבים; להוסיף למי, אזור והערות מלאות (מלווה, הזמנה ביום חמישי, שעות).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"מוקד רפואי (ערבים, שבתות וחגים)","phone2":"","phoneLabel2":"","target":"חולים ומוגבלים בתנועה, בלי הגבלת גיל","region":"כל הארץ","notes":"אמבולנסים ורכבים מונגשים ללא תשלום, לטיפולים רפואיים ולשמחות משפחתיות. יש להזמין יום קודם עד 12:00 (למוצ\"ש וליום ראשון – ביום חמישי); לא תמיד יש אמבולנס פנוי. חובה מלווה בוגר. לא לנסיעות חירום. נהגים מתנדבים לנסיעות רפואיות: א''–ה'' 07:45–01:00, ו'' 08:00–12:00. ראו גם [האגף לבריאות הנפש (עזר מציון)](https://nefesh-il.org/rights?entry=305&section=rehabilitation).","phone5":"","phoneLabel5":""}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.ami.org.il/services/ambulances , https://www.ami.org.il/services , https://www.ami.org.il/services/patient-transport. עודכנו: phoneLabel, phone2, phoneLabel2, target, region, notes, phone5, phoneLabel5.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '83|||הסעות חולים, אמבולנסים לצרכים רפואיים ואירועים משפחתיים, נהגים מתנדבים'
  AND COALESCE(public_fields->>'phoneLabel', '') = 'כללי'
  AND COALESCE(public_fields->>'phone2', '') = '1800-236-236'
  AND COALESCE(public_fields->>'phoneLabel2', '') = 'כללי'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'אמבולנסים ללא תשלום; לא תמיד יש אמבולנס פנוי — יש לפנות יום קודם עד 12:00'
  AND COALESCE(public_fields->>'phone5', '') = '073-3956218'
  AND COALESCE(public_fields->>'phoneLabel5', '') = 'נהגים מתנדבים';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '83|||הסעות חולים, אמבולנסים לצרכים רפואיים ואירועים משפחתיים, נהגים מתנדבים');

-- Row 84: לב מלכה. 2 field(s).
--   להוסיף דוא"ל והערה שהנסיעות חינם וללא תנאים, כולל לשדה התעופה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"email":"m662@levmalka.org.il","notes":"כל הנסיעות חינם וללא תנאים, כל השבוע ולאורך כל השנה. גם העברה לשדה התעופה וממנו לחולים שטסים לטיפול בחו\"ל."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://levmalka.org.il/ , https://levmalka.org.il/%D7%AA%D7%97%D7%95%D7%9E%D7%99-%D7%A2%D7%A9%D7%99%D7%99%D7%94/. עודכנו: email, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '84|||סיוע באמבולנסים בהעברת חולים ונכים'
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '84|||סיוע באמבולנסים בהעברת חולים ונכים');

-- Row 87: ענת אופיר. 4 field(s), 1 pin(s), eligibility.
--   לעדכן שם מלא, לתקן את תיאור השירות לפי האתר (תזונאית קלינית), ולהוסיף דוא"ל, אזור ושתי קליניקות במפה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"ענת אופיר מטיאש","svc":"תזונאית קלינית: הפרעות אכילה, תזונת ילדים ונוער, ספורט ואכילה רגשית","email":"Anatmatiash@gmail.com","region":"גבעת שמואל ותל אביב, וגם בפגישות וידאו"}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"קליניקה גבעת שמואל","address":"ירושלים 6, גבעת שמואל","lat":32.0865434,"lng":34.8495901,"phone":"054-2224646","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.fiteat.com. עודכנו: org, svc, email, region. התאמה: location_mode. סיכות: ירושלים 6, גבעת שמואל.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '87|||מומחית בהפרעות אכילה/תזונה/כושר/דיאטה, מטפלת בפגועי נפש עם רישיון. בעלות סימלית, חברות ביטוח מחזירות'
  AND COALESCE(public_fields->>'org', '') = 'ענת אופיר'
  AND COALESCE(public_fields->>'svc', '') = 'מומחית בהפרעות אכילה/תזונה/כושר/דיאטה, מטפלת בפגועי נפש עם רישיון. בעלות סימלית, חברות ביטוח מחזירות'
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'region', '') = '';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('קליניקה גבעת שמואל', 'ירושלים 6, גבעת שמואל', 32.0865434, 34.8495901, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '87|||מומחית בהפרעות אכילה/תזונה/כושר/דיאטה, מטפלת בפגועי נפש עם רישיון. בעלות סימלית, חברות ביטוח מחזירות' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '87|||מומחית בהפרעות אכילה/תזונה/כושר/דיאטה, מטפלת בפגועי נפש עם רישיון. בעלות סימלית, חברות ביטוח מחזירות');

-- Row 90: ME-MENTAL EXPERTS. 3 field(s), 2 pin(s), eligibility.
--   להוסיף למי מיועד, אזורים, דוא"ל וארבעה סניפים במפה (פתח תקווה, כפר סבא, חיפה, אילת).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"ילדים ומבוגרים בכל גיל, כולל גיל הזהב (60+)","region":"פתח תקווה, כפר סבא, חיפה, אילת","email":"info@mexp.co.il"}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"ME כפר סבא","address":"רפפורט 3, קומה 11 (שר\"פ פלוס, קניון כפר סבא הירוקה), כפר סבא","lat":32.1918767,"lng":34.891643,"phone":"*5806","email":"","sort_order":0},{"label":"ME חיפה","address":"ההסתדרות 55, קומה 3 (שר\"פ פלוס), חיפה","lat":32.7935104,"lng":35.0373412,"phone":"*5806","email":"","sort_order":1}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://mexp.co.il/. עודכנו: target, region, email. התאמה: location_mode. סיכות: רפפורט 3, קומה 11 (שר"פ פלוס, קניון כפר סבא הירוקה), כפר סבא; ההסתדרות 55, קומה 3 (שר"פ פלוס), חיפה.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '90|||מרכזים לטיפול רגשי'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'email', '') = '';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('ME כפר סבא', 'רפפורט 3, קומה 11 (שר"פ פלוס, קניון כפר סבא הירוקה), כפר סבא', 32.1918767, 34.891643, 0),
  ('ME חיפה', 'ההסתדרות 55, קומה 3 (שר"פ פלוס), חיפה', 32.7935104, 35.0373412, 1)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '90|||מרכזים לטיפול רגשי' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '90|||מרכזים לטיפול רגשי');

-- Row 91: Hakshiva Therapy Clinic - הקשיבה. 7 field(s), 1 pin(s), eligibility.
--   שני הקישורים בכרטיס מתים; להחליף לדף הבית, להעביר את המספר לשדה טלפון, ולהוסיף דוא"ל, למי מיועד (ילדים 6–18 והורים, זוגות) וכתובת במפה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"web":"https://hakshiva.org/","add":"","phone":"02-992-5152","phoneLabel":"Intake","whatsapp":"","email":"office@hakshiva.org","target":"Children 6–12 and teens 12–18 with their parents; couples and parents"}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"Hakshiva Therapy Clinic","address":"נחל שורק 14, רמת בית שמש א''","lat":31.716816,"lng":34.9944443,"phone":"02-992-5152","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://hakshiva.org/therapy-clinic/ , https://hakshiva.org/he/%d7%a7%d7%9c%d7%99%d7%a0%d7%99%d7%a7%d7%94-%d7%98%d7%99%d7%a4%d7%95%d7%9c%d7%99%d7%aa/ , https://hakshiva.org/ , https://hakshiva.org/contact-us/. עודכנו: web, add, phone, phoneLabel, whatsapp, email, target. התאמה: location_mode. סיכות: נחל שורק 14, רמת בית שמש א''.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '91|||Therapy for teenagers, couples therapy and parenting guidance'
  AND COALESCE(public_fields->>'web', '') = 'https://hakshiva.org/therapy-clinic/#'
  AND COALESCE(public_fields->>'add', '') = 'https://hakshiva.org/he/%d7%a7%d7%9c%d7%99%d7%a0%d7%99%d7%a7%d7%94-%d7%98%d7%99%d7%a4%d7%95%d7%9c%d7%99%d7%aa/'
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'whatsapp', '') = '02-992-5152'
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'target', '') = '';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('Hakshiva Therapy Clinic', 'נחל שורק 14, רמת בית שמש א''', 31.716816, 34.9944443, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '91|||Therapy for teenagers, couples therapy and parenting guidance' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '91|||Therapy for teenagers, couples therapy and parenting guidance');

-- Row 92: חבלי קשר - Hevlei Kesher. 1 field(s).
--   להוסיף למי מיועד (אמהות ומשפחות בהריון ואחרי לידה).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"Mothers and families affected by perinatal mental health disorders (pregnancy and postpartum)"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://hevleikesher.org/. עודכנו: target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '92|||דיכאון אחרי לידה ועוד, דרך טיפת חלב בירושלים
Support and treatment for Maternal Mental Health through Tipat Halav. Services for mothers and families impacted by perinatal mental health disorders (PMHD) such as postpartum depression'
  AND COALESCE(public_fields->>'target', '') = '';

-- Row 93: Modi'in Behavioral. 0 field(s), 1 pin(s), eligibility.
--   להוסיף את כתובת הקליניקה במפה (בניין רקיע, דם המכבים 36, מודיעין).
UPDATE directory_card_edits
SET sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"Modi''in Behavioral (Rakia Building)","address":"דם המכבים 36, מודיעין","lat":31.9035282,"lng":35.0059356,"phone":"053-304-8701","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.modiinbehavioral.com/. התאמה: location_mode. סיכות: דם המכבים 36, מודיעין.', E'\n ')),
    updated_at = now()
WHERE card_key = '93|||CBT, DBT, and Exposure-Based Therapies';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('Modi''in Behavioral (Rakia Building)', 'דם המכבים 36, מודיעין', 31.9035282, 35.0059356, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '93|||CBT, DBT, and Exposure-Based Therapies' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '93|||CBT, DBT, and Exposure-Based Therapies');

-- Row 204: אדווה ליזר. 1 field(s), 1 pin(s), eligibility.
--   להוסיף דוא"ל ואת כתובת הקליניקה בנתניה במפה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"email":"forevergenyoung@gmail.com"}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"קליניקה – אדווה ליזר","address":"ברוש 5, נתניה","lat":32.2989916,"lng":34.8743703,"phone":"054-6414863","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://adva-lieser.co.il. עודכנו: email. התאמה: location_mode. סיכות: ברוש 5, נתניה.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '204|||נטורופתיה קלינית — איזון גוף–נפש (כאבים, עייפות, סטרס, עיכול, אכילה רגשית ועוד); קליניקה ומפגשים מקוונים.'
  AND COALESCE(public_fields->>'email', '') = '';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('קליניקה – אדווה ליזר', 'ברוש 5, נתניה', 32.2989916, 34.8743703, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '204|||נטורופתיה קלינית — איזון גוף–נפש (כאבים, עייפות, סטרס, עיכול, אכילה רגשית ועוד); קליניקה ומפגשים מקוונים.' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '204|||נטורופתיה קלינית — איזון גוף–נפש (כאבים, עייפות, סטרס, עיכול, אכילה רגשית ועוד); קליניקה ומפגשים מקוונים.');

-- Row 242: מענים לקהילה הגאה (חרבות ברזל). 6 field(s).
--   להוסיף אתר האגודה (lgbt.org.il), וואטסאפ, שעות קו הקשב, למי ועלות, לתקן את הדומיין בהערות ולקשר לכרטיסי איגי וחוש"ן.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"קו הקשב של האגודה למען הלהט\"ב","web":"https://www.lgbt.org.il/","target":"חברי וחברות הקהילה הגאה, בני משפחה וחברים","cost":"חינם","whatsapp":"972586205591","notes":"קו הקשב \"יש עם מי לדבר\": א''–ה'' ומוצ\"ש 19:30–22:30, גם ב-*2982, בוואטסאפ ובמייל yesh@lgbt.org.il. קישורים: lgbt.org.il, תהלה, [נוער גאה](https://nefesh-il.org/support?entry=259&section=youth), [חוש\"ן](https://nefesh-il.org/support?entry=260&section=populations)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.lgbt.org.il/ , https://www.kolzchut.org.il/he/%22%D7%99%D7%A9_%D7%A2%D7%9D_%D7%9E%D7%99_%D7%9C%D7%93%D7%91%D7%A8%22_-_%D7%A7%D7%95_%D7%9E%D7%99%D7%93%D7%A2_%D7%95%D7%99%D7%99%D7%A2%D7%95%D7%A5_%D7%9C%D7%A7%D7%94%D7%99%D7%9C%D7%94_%D7%94%D7%92%D7%90%D7%94. עודכנו: phoneLabel, web, target, cost, whatsapp, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '242|||קו סיוע וקישורים — להט"ב, הורים, דתיים, נוער'
  AND COALESCE(public_fields->>'phoneLabel', '') = 'להט"ב'
  AND COALESCE(public_fields->>'web', '') = ''
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'whatsapp', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'קישורים: aguda.org.il, תהלה, נוער גאה.';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '242|||קו סיוע וקישורים — להט"ב, הורים, דתיים, נוער');

-- Row 245: רפואה ושמחה. 2 field(s).
--   לתקן את מועד התיאום ושעות המוקד בהערות, ולציין שהשירות גם לילדים.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"מוקד ההזמנות פועל בימי חול 08:00–15:00 (אחרי השעות – מענה קולי). יש לתאם מוקדם ככל האפשר, בדרך כלל עד בוקר היום שלפני הנסיעה. לא מיועד למקרי חירום רפואיים. נדרש מלווה לנסיעה. אפשר גם לילדים.","target":"חולים, נכים ומוגבלים בניידות, כולל ילדים"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://refuavesimcha.co.il/free-ambulance/. עודכנו: notes, target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '245|||שירותי אמבולנס ללא תשלום להסעת חולים, נכים ומוגבלים לטיפולים, בדיקות ושמחות'
  AND COALESCE(public_fields->>'notes', '') = 'יש לתאם יום לפני הנסיעה עד 12:00. לא מיועד למקרי חירום רפואיים. נדרש מלווה לנסיעה'
  AND COALESCE(public_fields->>'target', '') = 'חולים, נכים ומוגבלים בניידות';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '245|||שירותי אמבולנס ללא תשלום להסעת חולים, נכים ומוגבלים לטיפולים, בדיקות ושמחות');

-- Row 246: עזרה למרפא. 1 field(s).
--   לדייק בהערות מה נדרש להזמנה (מכתב שחרור רק בהסעה מבית חולים, מלווה וציוד ניידות).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"מרכז ודרום: 09:30–14:30 (שלוחה 5). בשאר השעות וביתר הארץ — מוקד ארצי. יש למסור פרטי החולה וכתובות מוצא ויעד, ונדרש מלווה שיסייע בהעלאה לאמבולנס. להסעה מבית חולים — רק אחרי קבלת מכתב שחרור חתום. יש להגיע עם ציוד הניידות (כיסא גלגלים, הליכון)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.ezra-lemarpe.org/ambulances/. עודכנו: notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '246|||שירותי אמבולנס להסעת חולים, נכים ומוגבלים לטיפולים, בדיקות ואירועים משפחתיים'
  AND COALESCE(public_fields->>'notes', '') = 'מרכז ודרום: 09:30–14:30 (שלוחה 5). בשאר השעות וביתר הארץ — מוקד ארצי. נדרש מלווה לנסיעה. נדרשת התראה מראש ומסמך רפואי';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '246|||שירותי אמבולנס להסעת חולים, נכים ומוגבלים לטיפולים, בדיקות ואירועים משפחתיים');

-- Row 260: חוש"ן — חינוך ושינוי. 1 field(s).
--   להוסיף למי מיועד (תלמידים וצוותי חינוך, צוותים טיפוליים וכוחות הביטחון).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"תלמידים וצוותי חינוך מהגן ועד התיכון, צוותים טיפוליים ואנשי כוחות הביטחון"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.hoshen.org/ , https://www.hoshen.org/contact. עודכנו: target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '260|||הסברה וסדנאות בבתי ספר ובמסגרות נוער למניעת להט"בופוביה ולתמיכה בנוער להט"ב'
  AND COALESCE(public_fields->>'target', '') = '';

-- Row 264: IAED — העמותה הישראלית להפרעות אכילה. 2 field(s).
--   להוסיף דוא"ל ולמי מיועד.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"email":"israel.aed@gmail.com","target":"מתמודדים עם הפרעות אכילה, בני משפחה ואנשי מקצוע"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.iaed.org.il/. עודכנו: email, target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '264|||מידע לציבור ולמשפחות, מפת מסגרות טיפול ואינדקס מטפלים בהפרעות אכילה'
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'target', '') = '';

-- Row 265: אלו"ט. 2 field(s).
--   להוסיף עלות (קווים חינם, טיפול מסובסד), שעות שישי בקו ההורים ואת קו מרכז המשפחה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"קו תמיכה רגשי מהורים להורים: א''–ה'' 20:00–22:30, ו'' 12:00–14:30, ללא תשלום. מיצוי זכויות ב-*5922 ללא תשלום. מרכז משפחה: טיפול וליווי במחיר מסובסד, 03-5115001 (גם וואטסאפ).","cost":"קווי התמיכה והסיוע בזכויות ללא תשלום; טיפול במרכז משפחה במחיר מסובסד"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://alut.org.il/ , https://alut.org.il/services/family-centers/ , https://lp.alut.org.il/. עודכנו: notes, cost.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '265|||ליווי ילדים ובוגרים על הרצף האוטיסטי ומשפחותיהם — זכויות, מרכזי משפחה ותמיכה'
  AND COALESCE(public_fields->>'notes', '') = 'קו תמיכה רגשי מהורים להורים: א''-ה'' 20:00-22:30'
  AND COALESCE(public_fields->>'cost', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '265|||ליווי ילדים ובוגרים על הרצף האוטיסטי ומשפחותיהם — זכויות, מרכזי משפחה ותמיכה');

-- Row 276: מעגלי נפש. 0 field(s).
--   הפרטים בכרטיס נכונים; להגדיר פנייה עצמית (קביעת שיחה במייל או בטופס).
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://mnefesh.org/he/ , https://mnefesh.org/he/schedule/ , https://mnefesh.org/contact/.', E'\n ')),
    updated_at = now()
WHERE card_key = '276|||ייעוץ הלכתי ורוחני למתמודדים ולבני משפחה — רבנים ורבניות שעברו הכשרה בבריאות הנפש (לא טיפול קליני)';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '276|||ייעוץ הלכתי ורוחני למתמודדים ולבני משפחה — רבנים ורבניות שעברו הכשרה בבריאות הנפש (לא טיפול קליני)');

-- Row 279: בית רעים (האגודה לבריאות הציבור). 2 field(s), eligibility.
--   להוסיף אזור (כל הארץ, המרכז בנתניה), דוא"ל להפניות וגיל מינימום 18.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"region":"כל הארץ (המרכז באזור התעשייה פולג, נתניה)","email":"netanya@tipulyom.co.il"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":18}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.aguda.co.il/services/%d7%91%d7%99%d7%aa-%d7%a8%d7%a2%d7%99%d7%9d-%d7%a0%d7%aa%d7%a0%d7%99%d7%94/. עודכנו: region, email. התאמה: age_min.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '279|||טיפול יום פסיכיאטרי — חלופת אשפוז למבוגרים במצבי משבר'
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'email', '') = '';

-- Row 280: מרפאת הנגב (האגודה לבריאות הציבור). 2 field(s), 1 pin(s), eligibility.
--   להוסיף אזור (אופקים), עלות במסגרת הקופות, גיל מינימום 18 ונקודה במפה (הרצל 37, אופקים); דרך הכניסה היא הפניית רופא משפחה בלבד.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"region":"אופקים","cost":"במסגרת קופת החולים (כל הקופות)"}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"מרפאת הנגב","address":"הרצל 37, אופקים","lat":31.3081191,"lng":34.6200851,"phone":"08-9982640","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":18,"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.aguda.co.il/services/%d7%9e%d7%a8%d7%a4%d7%90%d7%aa-%d7%90%d7%95%d7%a4%d7%a7%d7%99%d7%9d/. עודכנו: region, cost. התאמה: age_min, location_mode. סיכות: הרצל 37, אופקים.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '280|||טיפול נפשי מרפאתי — הערכה פסיכיאטרית, טיפול תרופתי ופסיכותרפיה'
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'cost', '') = '';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('מרפאת הנגב', 'הרצל 37, אופקים', 31.3081191, 34.6200851, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '280|||טיפול נפשי מרפאתי — הערכה פסיכיאטרית, טיפול תרופתי ופסיכותרפיה' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

UPDATE directory_entries
SET referral_codes = ARRAY['gp_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '280|||טיפול נפשי מרפאתי — הערכה פסיכיאטרית, טיפול תרופתי ופסיכותרפיה');

COMMIT;
