-- Migration 070 (16 Oct 2026)
-- Card review, batch 3: changes approved by the site owner, from docs/card-review-2026-10.md.
-- Each UPDATE only applies if the fields it changes still hold the reviewed text, so a later
-- admin edit is never overwritten. Pins are geocoded with OpenStreetMap Nominatim.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- Row 30: על הספה. 1 field(s).
--   להוסיף אזור «כל הארץ» ודרך פנייה עצמית.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"region":"כל הארץ"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.alhasapa.co.il/. עודכנו: region.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '30|||אינדקס מטפלים (כולל פסיכיאטרים)'
  AND COALESCE(public_fields->>'region', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '30|||אינדקס מטפלים (כולל פסיכיאטרים)');

-- Row 31: פסיכולוגיה עברית. 1 field(s).
--   להוסיף אזור «כל הארץ» ודרך פנייה עצמית.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"region":"כל הארץ"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.hebpsy.net/pl.asp. עודכנו: region.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '31|||אינדקס מטפלים (כולל פסיכיאטרים)'
  AND COALESCE(public_fields->>'region', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '31|||אינדקס מטפלים (כולל פסיכיאטרים)');

-- Row 32: בטיפולנט. 1 field(s).
--   להוסיף אזור «כל הארץ» ודרך פנייה עצמית.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"region":"כל הארץ"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.betipulnet.co.il/profileUser/profileLists.aspx. עודכנו: region.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '32|||אינדקס מטפלים (כולל פסיכיאטרים)'
  AND COALESCE(public_fields->>'region', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '32|||אינדקס מטפלים (כולל פסיכיאטרים)');

-- Row 33: MEDREVIEWS. 0 field(s).
--   להוסיף דרך פנייה עצמית; שאר הפרטים תקינים.
UPDATE directory_card_edits
SET eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.medreviews.co.il/search/psychiatry.', E'\n ')),
    updated_at = now()
WHERE card_key = '33|||אינדקס פסיכיאטרים';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '33|||אינדקס פסיכיאטרים');

-- Row 34: אינפומד. 2 field(s).
--   להוסיף אזור «כל הארץ», עלות (פרטי, חלק בהסדר קופות) ופנייה עצמית.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"region":"כל הארץ","cost":"פרטי; חלק מהרופאים בהסדר עם קופות חולים וביטוחים"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.infomed.co.il/expertsresults/psychiatry/all_subspecialities/all_areas/. עודכנו: region, cost.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '34|||אינדקס פסיכיאטרים'
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'cost', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '34|||אינדקס פסיכיאטרים');

-- Row 37: רקליני - הבית לטיפולים קליניים. 1 field(s).
--   להוסיף אזור «כל הארץ (וגם אונליין)» ופנייה עצמית.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"region":"כל הארץ (וגם אונליין)"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.raclini.co.il/. עודכנו: region.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '37|||אינדקס מטפלים'
  AND COALESCE(public_fields->>'region', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '37|||אינדקס מטפלים');

-- Row 41: שרן רפואה עד הבית. 3 field(s), eligibility.
--   להוסיף «בני 18 ומעלה», טלפון להזמנה והגבלת גיל 18+.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"בני 18 ומעלה","phone":"03-7545928","phoneLabel":"הזמנת השירות (שלוחה 2), כל יום 7:00-21:00"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":18}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://sharanmedical.co.il/psychiatric-consultation-at-home/. עודכנו: target, phone, phoneLabel. התאמה: age_min.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '41|||ייעוץ פסיכיאטרי מקוון'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'phoneLabel', '') = '';

-- Row 46: שרן רפואה עד הבית. 6 field(s), eligibility.
--   לתקן את העלות וההערות (כללית ומאוחדת בלי הגבלה לירושלים, עד 30 מפגשים), להוסיף גיל 18+, טלפון, מייל ודרכי הפניה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"cost":"ללא תשלום למבוטחי כללית ומאוחדת, בהפניה ובאישור הקופה. אפשר גם באופן פרטי","notes":"טיפול רגשי מרחוק (Zoom) ע״י עו״סים קליניים. עד 30 מפגשים באישור הקופה (ואפשר להאריך באישור נוסף). ההפניה מרופא משפחה או מפסיכיאטר מטפל. פגישות בימים א׳-ה׳ 8:00-22:00. ראו גם [כללית](https://nefesh-il.org/treatment?entry=28&section=hmo), [מאוחדת](https://nefesh-il.org/support?entry=80&section=populations).","target":"בני 18 ומעלה","phone":"03-7545938","phoneLabel":"מחלקת בריאות הנפש עד הבית, 7:00-21:00","email":"nefesh@med-trix.com"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":18}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://sharanmedical.co.il/online-therapy/. עודכנו: cost, notes, target, phone, phoneLabel, email. התאמה: age_min.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '46|||פסיכותרפיה מקוונת'
  AND COALESCE(public_fields->>'cost', '') = 'ממונן ע"י הקופות: כללית, 
מאוחדת (בירושלים)'
  AND COALESCE(public_fields->>'notes', '') = 'טיפול רגשי מרחוק (Zoom) ע"י עו"סים קליניים. 
הסכם ספציפי לירושלים של 30 מפגשים ללא עלות וללא רשימת המתנה.'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'email', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['gp_referral', 'psychiatrist_referral', 'hmo_form17', 'self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '46|||פסיכותרפיה מקוונת');

-- Row 47: שרן רפואה עד הבית. 1 field(s).
--   לא נמצא באתר שרן שירות פסיכותרפיה מקוונת לזכאי משרד הביטחון; מומלץ לבדוק אם להסיר את הכרטיס או להשאיר כ«עתידי».
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"בעתיד אמור להתחיל. ראו גם [שרן רפואה עד הבית](https://nefesh-il.org/rights?entry=42&section=mod), [אגף השיקום — טיפולים רגשיים במימון](https://nefesh-il.org/rights?entry=218&section=mod)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://sharanmedical.co.il/online-therapy/ , https://www.sharanmedical.co.il/online-psychiatric-consultation-for-idf/ , https://shikum.mod.gov.il/medical/treatment/therapy. עודכנו: notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '47|||פסיכותרפיה מקוונת'
  AND COALESCE(public_fields->>'notes', '') = 'בעתיד אמור להתחיל';

-- Row 50: איט"ה האגודה הישראלית לטיפול קוגניטיבי התנהגותי - CBT. 3 field(s).
--   להוסיף טלפון ומייל של האגודה, אזור «כל הארץ» ופנייה עצמית.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"052-3257005","email":"itacbtisrael@gmail.com","region":"כל הארץ"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://itacbt.co.il/therapists-index/. עודכנו: phone, email, region.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '50|||אינדקס מטפלים'
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'region', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '50|||אינדקס מטפלים');

-- Row 51: טיפול סומטי Somatic Experiencing. 2 field(s).
--   להוסיף קישור למאגר מטפלי SE בישראל של ITI, לצד המאגר הבינלאומי.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"web2":"https://iti-israel.org/en/category/se-en-2/practitioner/","webLabel2":"מאגר מטפלי SE בישראל (ITI)"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://directory.traumahealing.org/ , https://iti-israel.org/en/category/se-en-2/practitioner/ , https://iti-israel.org/en/home-3/. עודכנו: web2, webLabel2.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '51|||אינדקס מטפלים'
  AND COALESCE(public_fields->>'web2', '') = ''
  AND COALESCE(public_fields->>'webLabel2', '') = '';

-- Row 81: Relief Resources. 1 field(s).
--   להוסיף אזור (כל הארץ, משרד בירושלים) ולשנות את דרך ההפניה לפנייה עצמית.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"region":"All of Israel (office in Jerusalem)"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.reliefhelp.org/ , https://www.reliefhelp.org/contact/. עודכנו: region.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '81|||Help finding qualified mental health providers for English-speakers'
  AND COALESCE(public_fields->>'region', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '81|||Help finding qualified mental health providers for English-speakers');

-- Row 88: אימפולס - מרכז קליני אינטגרטיבי. 2 field(s).
--   להוסיף אזור «כל הארץ», ייעוץ פסיכיאטרי ואינטגרציה פסיכדלית בהתמחות, ופנייה עצמית.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"region":"כל הארץ","specialty":"פסיכותרפיה אינטגרטיבית, ייעוץ פסיכיאטרי, אינטגרציה פסיכדלית"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://impulseclinics.com/. עודכנו: region, specialty.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '88|||מרכז לפסיכותרפיה אינטגרטיבית. תמיכה נפשית, רגשית ורוחנית דרך מגוון רחב של גישות ועל ידי אנשי מקצוע מוסמכים'
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'specialty', '') = 'פסיכותרפיה אינטגרטיבית';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '88|||מרכז לפסיכותרפיה אינטגרטיבית. תמיכה נפשית, רגשית ורוחנית דרך מגוון רחב של גישות ועל ידי אנשי מקצוע מוסמכים');

-- Row 89: המרכז הישראלי להתמכרויות. Merged into row 94 and removed from the catalogue in index.html.
DELETE FROM directory_card_edits WHERE card_key = '89|||טיפול והתמודדות עם התמכרויות';

-- Row 96: חיים של טובה. 2 field(s).
--   להוסיף עלות (תעריפים מוזלים וסבסוד), קהל יעד ופנייה עצמית.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"cost":"תעריפים מוזלים וקרן לסבסוד טיפולים למי שמתקשה לשלם","target":"משפחות, זוגות ויחידים"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://hst.org.il/. עודכנו: cost, target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '96|||הכוונה לטיפול הפסיכולוגי המתאים לכם וסבסוד טיפולים'
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'target', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '96|||הכוונה לטיפול הפסיכולוגי המתאים לכם וסבסוד טיפולים');

-- Row 96: חיים של טובה. 2 field(s).
--   להוסיף עלות (תעריפים מוזלים וסבסוד), קהל יעד ופנייה עצמית.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"cost":"תעריפים מוזלים וקרן לסבסוד טיפולים למי שמתקשה לשלם","target":"משפחות, זוגות ויחידים"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://hst.org.il/. עודכנו: cost, target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '96|||הכוונה לטיפול הפסיכולוגי המתאים וסבסוד טיפולים פסיכולוגיים'
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'target', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '96|||הכוונה לטיפול הפסיכולוגי המתאים וסבסוד טיפולים פסיכולוגיים');

-- Row 101: אפליקציית Rescue. 4 field(s).
--   אתר האפליקציה מכיל כעת פרסומות הימורים; מוצע לקשר לחנויות האפליקציות במקום.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"web":"https://apps.apple.com/il/app/rescue-anxiety-first-aid/id6473524067","webLabel":"App Store","web2":"https://play.google.com/store/apps/details?id=com.anxietyapporg.anxietyapp","webLabel2":"Google Play"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://rescueanxietyapp.org/ , https://apps.apple.com/il/app/rescue-anxiety-first-aid/id6473524067 , https://play.google.com/store/apps/details?id=com.anxietyapporg.anxietyapp&hl=en_US. עודכנו: web, webLabel, web2, webLabel2.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '101|||אפליקציה חינמית המספקת עזרה ראשונה נפשית ותמיכה מיידית בזמן התקף חרדה, ומלווה את המשתמש עד חזרה הדרגתית לשגרה.'
  AND COALESCE(public_fields->>'web', '') = 'https://rescueanxietyapp.org/'
  AND COALESCE(public_fields->>'webLabel', '') = ''
  AND COALESCE(public_fields->>'web2', '') = ''
  AND COALESCE(public_fields->>'webLabel2', '') = '';

-- Row 102: Kav L'Noar (Merchav L'Noar). 2 field(s), 1 pin(s), eligibility.
--   שני הקישורים לדפי המרפאות שבורים; להחליף לדף הבית ולהוסיף את המשרד הראשי בירושלים למפה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"web":"https://www.kavlnoar.org/","add":""}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"Kav L''Noar main office","address":"Kiryat HaMada 4, Jerusalem","lat":31.805952,"lng":35.207807,"phone":"02-622-3039","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.kavlnoar.org/jerusalem-clinic , https://www.kavlnoar.org/beit-shemesh-clinic , https://www.kavlnoar.org/. עודכנו: web, add. התאמה: location_mode. סיכות: Kiryat HaMada 4, Jerusalem.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '102|||Therapy clinic for teenagers & young adults (11-27) and parents; specializes in Anglo olim; Halachik framework; therapy for individuals, couples and families'
  AND COALESCE(public_fields->>'web', '') = 'https://www.kavlnoar.org/jerusalem-clinic'
  AND COALESCE(public_fields->>'add', '') = 'https://www.kavlnoar.org/beit-shemesh-clinic';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('Kav L''Noar main office', 'Kiryat HaMada 4, Jerusalem', 31.805952, 35.207807, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '102|||Therapy clinic for teenagers & young adults (11-27) and parents; specializes in Anglo olim; Halachik framework; therapy for individuals, couples and families' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '102|||Therapy clinic for teenagers & young adults (11-27) and parents; specializes in Anglo olim; Halachik framework; therapy for individuals, couples and families');

-- Row 103: המדריך ל-PTSD. 2 field(s).
--   להוסיף קהל יעד (מתמודדים עם פוסט טראומה), הערה שאינה תחליף לטיפול, וקישור לכרטיס אגף השיקום.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"מתמודדים עם פוסט טראומה","notes":"האפליקציה אינה מחליפה אבחון או טיפול מקצועי. אפשר להשתמש בה לעזרה עצמית או כחלק מטיפול. ראו גם [אגף השיקום, משרד הבטחון](https://nefesh-il.org/information?entry=12&section=portals)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://shikum.mod.gov.il/medical/mental-therapy/ptsd-app. עודכנו: target, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '103|||אפליקציה/מדריך דיגיטלי להתמודדות עם PTSD, מטעם אגף השיקום (משרד הביטחון).'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '103|||אפליקציה/מדריך דיגיטלי להתמודדות עם PTSD, מטעם אגף השיקום (משרד הביטחון).');

-- Row 104: מיינדמי (MindMe). 2 field(s), 1 pin(s), eligibility.
--   להוסיף «מבוגרים», שעות מענה ונקודה במפה במנחם בגין 148.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"מבוגרים","notes":"כתובת: מנחם בגין 148, תל אביב. מענה טלפוני בימים א׳-ה׳ 09:00-19:00."}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"MindMe","address":"מנחם בגין 148, תל אביב","lat":32.0665291,"lng":34.7843181,"phone":"03-6511229","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://mindme.co.il/. עודכנו: target, notes. התאמה: location_mode. סיכות: מנחם בגין 148, תל אביב.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '104|||מרכז פסיכיאטרי וטיפול רגשי: פסיכותרפיה, טיפול קוגניטיבי-התנהגותי (CBT), טיפול זוגי ומשפחתי, פסיכיאטריה ומתן תרופות, EMDR/DBT/NLP, חרדה, דיכאון, טראומה, התמכרויות ועוד'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'כתובת: מנחם בגין 148, תל אביב';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('MindMe', 'מנחם בגין 148, תל אביב', 32.0665291, 34.7843181, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '104|||מרכז פסיכיאטרי וטיפול רגשי: פסיכותרפיה, טיפול קוגניטיבי-התנהגותי (CBT), טיפול זוגי ומשפחתי, פסיכיאטריה ומתן תרופות, EMDR/DBT/NLP, חרדה, דיכאון, טראומה, התמכרויות ועוד' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '104|||מרכז פסיכיאטרי וטיפול רגשי: פסיכותרפיה, טיפול קוגניטיבי-התנהגותי (CBT), טיפול זוגי ומשפחתי, פסיכיאטריה ומתן תרופות, EMDR/DBT/NLP, חרדה, דיכאון, טראומה, התמכרויות ועוד');

-- Row 107: טיפול פסיכדלי. 1 field(s).
--   לעדכן את ההערה: הדף הוא רשימת מרכזים ומחקרים מוסדרים לטיפול פסיכדלי.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"רשימה מעודכנת באתר PsyCircle של מרכזים מוסדרים ומחקרים קליניים בישראל המציעים טיפול פסיכדלי חוקי (למשל טיפול בסיוע קטמין), עם פרטי קשר."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://psycircle.co.il/psychedelic-therapy/. עודכנו: notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '107|||טיפול פסיכדלי ומידע מקצועי בתחום.'
  AND COALESCE(public_fields->>'notes', '') = 'מידע ותוכן מקצועי מתוך אתר PsyCircle.';

-- Row 108: (איכילוב) TMS - גרייה מגנטית מוחית. 4 field(s).
--   להוסיף טלפון, מייל ושעות; לבדוק אם TMS עדיין ניתן — העמוד מפרט כיום ECT, אסקטמין ונוירומודולציה (נוירופידבק) בלבד.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-694-7866","phoneLabel":"היחידה לטיפולים מתקדמים, ימים ב׳, ד׳, ה׳ 8:00-15:00","email":"brainclinictlv@tlvmc.gov.il","notes":"היחידה לטיפולים מתקדמים, המכון לבריאות הנפש איכילוב. בניין השיקום, קומת קרקע. פנייה דרך טופס מקוון באתר. נוירופידבק בתשלום; למוכרי משרד הביטחון עם פוסט טראומה ייתכן מימון דרך אגף השיקום. ראו גם [ECT (נזעי חשמל)](https://nefesh-il.org/treatment?entry=109&section=treatments), [אסקטמין / Spravato (ספראבטו)](https://nefesh-il.org/treatment?entry=270&section=treatments)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.tasmc.org.il/unit-index-page/psychiatr/psychiatry-clinic/brain-magnetic-stimulation/. עודכנו: phone, phoneLabel, email, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '108|||טיפול בגרייה מגנטית מוחית (TMS) במרפאה לטיפולים מתקדמים. באותה יחידה גם ECT, אסקטמין ונוירופידבק.'
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'מרפאה פסיכיאטרית, איכילוב / TASMC.';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '108|||טיפול בגרייה מגנטית מוחית (TMS) במרפאה לטיפולים מתקדמים. באותה יחידה גם ECT, אסקטמין ונוירופידבק.');

-- Row 109: ECT (נזעי חשמל). 1 field(s).
--   לא נמצאו שינויים בעובדות; מוצע לקשר לכרטיסי איכילוב וכפר שאול.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"הפניה פסיכיאטרית; מימון דרך הקופה והמרכז המטפל. ראו גם [(איכילוב) TMS - גרייה מגנטית מוחית](https://nefesh-il.org/treatment?entry=108&section=treatments), [המרכז הירושלמי לבריאות הנפש (כפר שאול-איתנים)](https://nefesh-il.org/rights?entry=78&section=moh)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.gov.il/BlobFolder/reports/ect-electroconvulsive-therapy/he/units_governmental_health_centers_ect-electroconvulsive-therapy-ac.pdf , https://www.tasmc.org.il/unit-index-page/psychiatr/psychiatry-clinic/brain-magnetic-stimulation/. עודכנו: notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '109|||טיפול ביולוגי תחת הרדמה קצרה במצבים נפשיים חמורים — בעיקר דיכאון קשה, קטטוניה ומצבים דחופים. ניתן בסדרה בבתי חולים פסיכיאטריים ובחטיבות פסיכיאטריות (למשל איכילוב, שלוותה, כפר שאול).'
  AND COALESCE(public_fields->>'notes', '') = 'הפניה פסיכיאטרית; מימון דרך הקופה והמרכז המטפל.';

-- Row 205: רזולוציה. 2 field(s), 1 pin(s), eligibility.
--   להוסיף מייל, כתובת מלאה ונקודה במפה בהברזל 11, תל אביב.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"email":"info@resolution.co.il","notes":"מרכז בתל אביב: הברזל 11, קומה 2, יחידה A15."}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"רזולוציה","address":"הברזל 11, קומה 2, יחידה A15, תל אביב","lat":32.1075,"lng":34.836679,"phone":"03-6919961","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.resolution.co.il/. עודכנו: email, notes. התאמה: location_mode. סיכות: הברזל 11, קומה 2, יחידה A15, תל אביב.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '205|||יישומים פסיכולוגיים ממוקדים — הערכה ראשונית והתאמת טיפול (פגישות בקליניקה או זום).'
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'מרכז בתל אביב — פרטים באתר.';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('רזולוציה', 'הברזל 11, קומה 2, יחידה A15, תל אביב', 32.1075, 34.836679, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '205|||יישומים פסיכולוגיים ממוקדים — הערכה ראשונית והתאמת טיפול (פגישות בקליניקה או זום).' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '205|||יישומים פסיכולוגיים ממוקדים — הערכה ראשונית והתאמת טיפול (פגישות בקליניקה או זום).');

-- Row 268: SGB — סטלה ישראל. 2 field(s), 2 pin(s), eligibility.
--   לתקן «תחת אולטרסאונד» ל«תחת שיקוף», לפרט את העלות, ולהוסיף שתי נקודות במפה (מדיקה תל אביב, אלישע חיפה).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"svc":"הליך רפואי קצר (Stellate Ganglion Block): שתי זריקות הרדמה מקומית בצידי הצוואר תחת שיקוף, להקלה על תסמינים פיזיים של פוסט־טראומה, חרדה ודיכאון. מיועד לשילוב עם טיפול רגשי.","cost":"פרטי: כ-4,000 ₪ לשני הטיפולים אחרי סבסוד (מחיר מלא כ-10,000 ₪). סבסוד נוסף למוכרי משרד הביטחון ולנפגעי חרבות ברזל"}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"סטלה ישראל — מדיקה רמת החייל","address":"הברזל 28, תל אביב-יפו","lat":32.1092993,"lng":34.8410782,"phone":"","email":"","sort_order":0},{"label":"סטלה ישראל — בית חולים אלישע","address":"יאיר כ״ץ 12, חיפה","lat":32.8008854,"lng":34.992364,"phone":"","email":"","sort_order":1}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://israel.stellacenter.com/ , https://israel.stellacenter.com/procedure/ , https://www.medica.co.il/. עודכנו: svc, cost. התאמה: location_mode. סיכות: הברזל 28, תל אביב-יפו; יאיר כ״ץ 12, חיפה.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '268|||הליך רפואי קצר (Stellate Ganglion Block): שתי זריקות הרדמה מקומית בצידי הצוואר תחת אולטרסאונד, להקלה על תסמינים פיזיים של פוסט־טראומה, חרדה ודיכאון. מיועד לשילוב עם טיפול רגשי.'
  AND COALESCE(public_fields->>'svc', '') = 'הליך רפואי קצר (Stellate Ganglion Block): שתי זריקות הרדמה מקומית בצידי הצוואר תחת אולטרסאונד, להקלה על תסמינים פיזיים של פוסט־טראומה, חרדה ודיכאון. מיועד לשילוב עם טיפול רגשי.'
  AND COALESCE(public_fields->>'cost', '') = 'פרטי; סבסוד אפשרי — פרטים באתר';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('סטלה ישראל — מדיקה רמת החייל', 'הברזל 28, תל אביב-יפו', 32.1092993, 34.8410782, 0),
  ('סטלה ישראל — בית חולים אלישע', 'יאיר כ״ץ 12, חיפה', 32.8008854, 34.992364, 1)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '268|||הליך רפואי קצר (Stellate Ganglion Block): שתי זריקות הרדמה מקומית בצידי הצוואר תחת אולטרסאונד, להקלה על תסמינים פיזיים של פוסט־טראומה, חרדה ודיכאון. מיועד לשילוב עם טיפול רגשי.' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

-- Row 269: Prism — גרייה עצמית לפוסט טראומה. 2 field(s), 14 pin(s), eligibility.
--   להוסיף עלות (מימון משרד הביטחון למוכרים), פרטי סדרת הטיפול ונקודות במפה למרכזי הטיפול.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"cost":"במימון משרד הביטחון למוכרים; אחרים — לברר מול מרכז הטיפול","notes":"טיפול משלים לטיפול רגשי או תרופתי — לא מכשיר ביתי. 15 מפגשים של כ-45 דקות, פעמיים בשבוע. לשימוש במרשם בלבד."}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"נט״ל","address":"פנחס רוזן 72, תל אביב","lat":32.1147382,"lng":34.825767,"phone":"073-2363324","email":"","sort_order":0},{"label":"המרכז הרפואי ברזילי","address":"ההסתדרות 2, אשקלון","lat":31.6558924,"lng":34.5582856,"phone":"08-6745103","email":"","sort_order":1},{"label":"בית הלוחם חיפה","address":"דרך צרפת 101, חיפה","lat":32.822979,"lng":34.967502,"phone":"","email":"","sort_order":2},{"label":"טירת כרמל (מעלה הכרמל)","address":"האלה 17, טירת כרמל","lat":32.7550477,"lng":34.9746007,"phone":"050-6265612","email":"","sort_order":3},{"label":"בית הלוחם נהריה","address":"שדרות קיי 11, נהריה","lat":32.9985807,"lng":35.0926981,"phone":"052-6667913","email":"","sort_order":4},{"label":"ד״ר עומר פורת — מרכז חדוותא","address":"הרצל 18, באר שבע","lat":31.2386242,"lng":34.7869831,"phone":"03-6555821","email":"","sort_order":5},{"label":"מרכז BRAINTECH","address":"שוהם 32, חריש","lat":32.4676477,"lng":35.0455838,"phone":"054-2010120","email":"","sort_order":6},{"label":"נוירואקטיב קרית אתא","address":"חנקין 1, קרית אתא","lat":32.8105009,"lng":35.11111,"phone":"072-2500636","email":"","sort_order":7},{"label":"נוירואקטיב רמת גן","address":"ז׳בוטינסקי 33, רמת גן","lat":32.0837168,"lng":34.8059532,"phone":"072-2500636","email":"","sort_order":8},{"label":"נוירואקטיב עפולה","address":"יצחק נבון 3, עפולה","lat":32.6129776,"lng":35.3006983,"phone":"072-2500636","email":"","sort_order":9},{"label":"בסט מדיקל תל אביב","address":"הברזל 11A, רמת החייל, תל אביב-יפו","lat":32.1068938,"lng":34.8331545,"phone":"03-6988433","email":"","sort_order":10},{"label":"מרפאת פרופ׳ גל שובל","address":"סוקולוב 81, רמת השרון","lat":32.1474623,"lng":34.8388414,"phone":"050-9998029","email":"","sort_order":11},{"label":"מרכז גולדנטל","address":"שארית ישראל 37, יפו","lat":32.0517594,"lng":34.7642582,"phone":"054-5930644","email":"","sort_order":12},{"label":"שערי נפש (שערי צדק)","address":"רבקה 11, ירושלים","lat":31.754407,"lng":35.217947,"phone":"02-6666516","email":"","sort_order":13}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://prism-il.com/. עודכנו: cost, notes. התאמה: location_mode. סיכות: פנחס רוזן 72, תל אביב; ההסתדרות 2, אשקלון; דרך צרפת 101, חיפה; האלה 17, טירת כרמל; שדרות קיי 11, נהריה; הרצל 18, באר שבע; שוהם 32, חריש; חנקין 1, קרית אתא; ז׳בוטינסקי 33, רמת גן; יצחק נבון 3, עפולה; הברזל 11A, רמת החייל, תל אביב-יפו; סוקולוב 81, רמת השרון; שארית ישראל 37, יפו; רבקה 11, ירושלים.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '269|||טיפול EEG לא פולשני (GrayMatters Health) לאימון ויסות פעילות מוחית הקשורה לפוסט־טראומה, ללא חשיפה לטראומה. מאושר FDA ו־אמ"ר; מוכר לאגף השיקום למטופלים זכאים. רשימת מרכזים באתר (שיבא, איכילוב, ברזילי, מעלה הכרמל, בתי הלוחם ועוד).'
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'טיפול משלים לטיפול רגשי או תרופתי — לא מכשיר ביתי.';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('נט״ל', 'פנחס רוזן 72, תל אביב', 32.1147382, 34.825767, 0),
  ('המרכז הרפואי ברזילי', 'ההסתדרות 2, אשקלון', 31.6558924, 34.5582856, 1),
  ('בית הלוחם חיפה', 'דרך צרפת 101, חיפה', 32.822979, 34.967502, 2),
  ('טירת כרמל (מעלה הכרמל)', 'האלה 17, טירת כרמל', 32.7550477, 34.9746007, 3),
  ('בית הלוחם נהריה', 'שדרות קיי 11, נהריה', 32.9985807, 35.0926981, 4),
  ('ד״ר עומר פורת — מרכז חדוותא', 'הרצל 18, באר שבע', 31.2386242, 34.7869831, 5),
  ('מרכז BRAINTECH', 'שוהם 32, חריש', 32.4676477, 35.0455838, 6),
  ('נוירואקטיב קרית אתא', 'חנקין 1, קרית אתא', 32.8105009, 35.11111, 7),
  ('נוירואקטיב רמת גן', 'ז׳בוטינסקי 33, רמת גן', 32.0837168, 34.8059532, 8),
  ('נוירואקטיב עפולה', 'יצחק נבון 3, עפולה', 32.6129776, 35.3006983, 9),
  ('בסט מדיקל תל אביב', 'הברזל 11A, רמת החייל, תל אביב-יפו', 32.1068938, 34.8331545, 10),
  ('מרפאת פרופ׳ גל שובל', 'סוקולוב 81, רמת השרון', 32.1474623, 34.8388414, 11),
  ('מרכז גולדנטל', 'שארית ישראל 37, יפו', 32.0517594, 34.7642582, 12),
  ('שערי נפש (שערי צדק)', 'רבקה 11, ירושלים', 31.754407, 35.217947, 13)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '269|||טיפול EEG לא פולשני (GrayMatters Health) לאימון ויסות פעילות מוחית הקשורה לפוסט־טראומה, ללא חשיפה לטראומה. מאושר FDA ו־אמ"ר; מוכר לאגף השיקום למטופלים זכאים. רשימת מרכזים באתר (שיבא, איכילוב, ברזילי, מעלה הכרמל, בתי הלוחם ועוד).' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '269|||טיפול EEG לא פולשני (GrayMatters Health) לאימון ויסות פעילות מוחית הקשורה לפוסט־טראומה, ללא חשיפה לטראומה. מאושר FDA ו־אמ"ר; מוכר לאגף השיקום למטופלים זכאים. רשימת מרכזים באתר (שיבא, איכילוב, ברזילי, מעלה הכרמל, בתי הלוחם ועוד).');

-- Row 270: אסקטמין / Spravato (ספראבטו). 1 field(s), eligibility.
--   להוסיף קהל יעד ומגבלת גיל 18+.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"בני 18 ומעלה עם דיכאון עמיד"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":18}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.maccabi4u.co.il/eligibilites/12022/ , https://www.tasmc.org.il/unit-index-page/psychiatr/psychiatry-clinic/brain-magnetic-stimulation/. עודכנו: target. התאמה: age_min.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '270|||תרסיס אף של אסקטמין לדיכאון מג''ורי עמיד. בסל הבריאות (מ-2020) למבוגרים שלא הגיבו לשני קווי טיפול משתי קבוצות פרמקולוגיות, בשילוב SSRI/SNRI. ניתן רק במרפאה מורשית תחת השגחה.'
  AND COALESCE(public_fields->>'target', '') = '';

-- Row 271: קטמיינד (KetaMind) — עירוי קטמין. 1 field(s).
--   הפרטים תקינים; מוצע לקשר לכרטיס סטלה ישראל.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"בבעלות Stella Israel. נדרשת הערכה פסיכיאטרית. ראו גם [SGB — סטלה ישראל](https://nefesh-il.org/treatment?entry=268&section=treatments)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://ketamindclinic.com/. עודכנו: notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '271|||מרפאה פסיכיאטרית מקבוצת Stella Israel: עירוי קטמין במינון נמוך בהשגחה רפואית לדיכאון, חרדה ופוסט־טראומה.'
  AND COALESCE(public_fields->>'notes', '') = 'בבעלות Stella Israel. נדרשת הערכה פסיכיאטרית.';

-- Row 273: tDCS — המרכז הרפואי הרצוג. 3 field(s), eligibility.
--   להוסיף «בני 18 ומעלה», תנאי הסל ל-Deep TMS, מיקום ושעות, ולהוסיף טופס 17 לדרכי ההפניה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"בני 18 ומעלה","region":"ירושלים (פתוח גם לשאר הארץ)","notes":"לא קו ראשון. הפניה מפסיכיאטר או נוירולוג. Deep TMS בסל לבני 22 ומעלה עם דיכאון מג׳ורי אחרי כישלון שני טיפולים, עד 40 טיפולים. המרפאה בבניין המרפאה האמבולטורית ע״ש גלסמן, 09:00-18:00. ראו גם [(BrainsWay) TMS - גרייה מגנטית מוחית](https://nefesh-il.org/treatment?entry=105&section=treatments)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":18}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://herzoghospital.org.il/clinicsinstitutes/%D7%9E%D7%A8%D7%A4%D7%90%D7%94-%D7%9C%D7%92%D7%A8%D7%99%D7%99%D7%94-%D7%9E%D7%95%D7%97%D7%99%D7%AA/. עודכנו: target, region, notes. התאמה: age_min.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '273|||גרייה מוחית בזרם ישר חלש (tDCS) במרפאה לגרייה מוחית בהרצוג. לא פולשני; למצבים פסיכיאטריים ונוירולוגיים לפי הערכה רפואית. באותה מרפאה גם Deep TMS לדיכאון מג''ורי (טופס 17).'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'region', '') = 'ירושלים'
  AND COALESCE(public_fields->>'notes', '') = 'לא קו ראשון. הפניה מפסיכיאטר או נוירולוג.';

UPDATE directory_entries
SET referral_codes = ARRAY['psychiatrist_referral', 'hmo_form17']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '273|||גרייה מוחית בזרם ישר חלש (tDCS) במרפאה לגרייה מוחית בהרצוג. לא פולשני; למצבים פסיכיאטריים ונוירולוגיים לפי הערכה רפואית. באותה מרפאה גם Deep TMS לדיכאון מג''ורי (טופס 17).');

-- Row 274: VNS — גירוי העצב התועה. 4 field(s).
--   להוסיף טלפון ומייל של היחידה, דרישת טופס 17, ונקודה במפה בצור משה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"09-8980474","phoneLabel":"מזכירות היחידה לגרייה מוחית","email":"litalmalachi@lev-hasharon.co.il","notes":"לא קו ראשון. זמינות ומימון — לברר מול המרכז והקופה. לכל פנייה יש לצרף מכתב הפניה מפסיכיאטר מטפל וטופס 17 מהקופה. ראו גם [לב השרון](https://nefesh-il.org/treatment?entry=235&section=trauma), [ECT (נזעי חשמל)](https://nefesh-il.org/treatment?entry=109&section=treatments)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.lev-hasharon.co.il/?clinic=%D7%9E%D7%A8%D7%A4%D7%90%D7%94. עודכנו: phone, phoneLabel, email, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '274|||השתלת קוצב המגרה את עצב הואגוס לדיכאון קשה עמיד לטיפול. בישראל: הערכה ביחידה לגרייה מוחית בלב השרון; ההשתלה בנוירוכירורגיה תפקודית באיכילוב. מוגבל, דורש הפניה פסיכיאטרית.'
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'לא קו ראשון. זמינות ומימון — לברר מול המרכז והקופה.';

UPDATE directory_entries
SET referral_codes = ARRAY['psychiatrist_referral', 'hmo_form17']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '274|||השתלת קוצב המגרה את עצב הואגוס לדיכאון קשה עמיד לטיפול. בישראל: הערכה ביחידה לגרייה מוחית בלב השרון; ההשתלה בנוירוכירורגיה תפקודית באיכילוב. מוגבל, דורש הפניה פסיכיאטרית.');

-- Row 275: DBS — גירוי מוחי עמוק (OCD עמיד). 3 field(s).
--   להוסיף לדרישות אבחנה של 5 שנים לפחות והפניה מפסיכיאטר, ומספר מוקד של רמב״ם.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"לא קו ראשון. מיועד למקרים חריגים לאחר כישלון טיפולים מקובלים. נדרשת אבחנה של 5 שנים לפחות. ההפניה להערכה ברמב״ם מהפסיכיאטר המטפל.","phone2":"04-777-3568","phoneLabel2":"מוקד רמב״ם (*5324)"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.rambam.org.il/en/rambam_news/dbs_for_tx-resistant_ocd.aspx. עודכנו: notes, phone2, phoneLabel2.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '275|||הליך נוירוכירורגי להשתלת אלקטרודות וקוצב מוחי במקרי OCD חמורים ועמידים לטיפול. ניתן במספר מרכזים בודדים (למשל רמב"ם). אינו בסל הבריאות; רק באישור מיוחד של משרד הבריאות או במחקר.'
  AND COALESCE(public_fields->>'notes', '') = 'לא קו ראשון. מיועד למקרים חריגים לאחר כישלון טיפולים מקובלים.'
  AND COALESCE(public_fields->>'phone2', '') = ''
  AND COALESCE(public_fields->>'phoneLabel2', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['psychiatrist_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '275|||הליך נוירוכירורגי להשתלת אלקטרודות וקוצב מוחי במקרי OCD חמורים ועמידים לטיפול. ניתן במספר מרכזים בודדים (למשל רמב"ם). אינו בסל הבריאות; רק באישור מיוחד של משרד הבריאות או במחקר.');

COMMIT;
