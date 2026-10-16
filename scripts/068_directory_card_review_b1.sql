-- Migration 068 (16 Oct 2026)
-- Card review, batch 1: changes approved by the site owner, from docs/card-review-2026-10.md.
-- Each UPDATE only applies if the fields it changes still hold the reviewed text, so a later
-- admin edit is never overwritten. Pins are geocoded with OpenStreetMap Nominatim.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- Row 1: ביטוח לאומי. 2 field(s).
--   להוסיף את מוקד ביטוח לאומי *6050 ולמלא קהל יעד: מתמודדים עם בעיה נפשית.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"*6050","target":"מתמודדים עם בעיה נפשית (נכות נפשית)"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.btl.gov.il/ZcuyotAsdience/MitmoddiNefesh/Pages/default.aspx. עודכנו: phone, target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '1|||קצבת נכות למתמודדי נפש'
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'target', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '1|||קצבת נכות למתמודדי נפש');

-- Row 2: ביטוח לאומי. 2 field(s), eligibility.
--   להוסיף טלפון *6050, קהל יעד (מגיל 18 עד גיל פרישה, הזקוקים לעזרה רבה או להשגחה) וגיל מינימום 18.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"*6050","target":"מבוטחים מגיל 18 ועד גיל פרישה, הזקוקים לעזרה רבה של אדם אחר בפעולות היום-יום או להשגחה מתמדת"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":18}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.btl.gov.il/benefits/Attendance_Allowance/Pages/default.aspx , https://www.kolzchut.org.il/he/%D7%A7%D7%A6%D7%91%D7%AA_%D7%A9%D7%99%D7%A8%D7%95%D7%AA%D7%99%D7%9D_%D7%9E%D7%99%D7%95%D7%97%D7%93%D7%99%D7%9D. עודכנו: phone, target. התאמה: age_min.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '2|||שירותים מיוחדים (שר"מ)'
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'target', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '2|||שירותים מיוחדים (שר"מ)');

-- Row 3: ביטוח לאומי. 2 field(s).
--   לעדכן את ההערה לנוסח הנוכחי של ביטוח לאומי (בלי התנאי של סכנה לעצמו או לאחרים) ולמלא קהל יעד.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"קצבת סיעוד ניתנת לאנשים שהגיעו לגיל פרישה, הגרים בבית וזקוקים לעזרת אדם אחר בביצוע פעולות היום יום (ניידות, רחצה, הלבשה, אכילה וטיפול בהפרשות), וכן לאנשים הזקוקים להשגחה ופיקוח צמוד של הזולת בשל מצב רפואי ותפקודי.","target":"בני גיל פרישה הגרים בבית וזקוקים לעזרה בפעולות היום-יום או להשגחה צמודה"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.btl.gov.il/benefits/Long_Term_Care/Pages/default.aspx , https://www.kolzchut.org.il/he/%D7%92%D7%9E%D7%9C%D7%AA_%D7%A1%D7%99%D7%A2%D7%95%D7%93. עודכנו: notes, target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '3|||קצבת סיעוד'
  AND COALESCE(public_fields->>'notes', '') = 'קצבת סיעוד ניתנת לאנשים שהגיעו לגיל פרישה, הגרים בבית וזקוקים לעזרת אדם אחר בביצוע פעולות היום יום וכן לאנשים הזקוקים להשגחה ופיקוח צמוד של הזולת בשל מצב רפואי ותפקודי המעמיד אותם בסכנה לפגיעה בעצמם או באחרים.'
  AND COALESCE(public_fields->>'target', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '3|||קצבת סיעוד');

-- Row 4: יד מכוונת. 1 field(s).
--   למלא קהל יעד: מגישי תביעה לביטוח לאומי, מוזמנים לוועדה רפואית או מגישי ערר.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"מגישי תביעה לביטוח לאומי, מי שזומנו לוועדה רפואית או רוצים להגיש ערר (נכות כללית, נפגעי עבודה, נפגעי איבה, שירותים מיוחדים, ילד נכה, פטור ממס הכנסה)"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.btl.gov.il/snifim/Pages/yadMechavenet1.aspx. עודכנו: target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '4|||ייעוץ והכנה בחינם לוועדה הרפואית'
  AND COALESCE(public_fields->>'target', '') = '';

-- Row 5: משרד הבריאות. 1 field(s), eligibility.
--   למלא קהל יעד (בני 18 ומעלה עם 40% נכות נפשית לפחות) ולהגדיר גיל מינימום 18.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"בני 18 ומעלה שנקבעו להם לפחות 40% נכות רפואית על רקע נפשי"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":18}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.gov.il/he/service/rehabilitation-support-package , https://www.kolzchut.org.il/he/%D7%A1%D7%9C_%D7%A9%D7%99%D7%A7%D7%95%D7%9D_%D7%9C%D7%9E%D7%AA%D7%9E%D7%95%D7%93%D7%93%D7%99_%D7%A0%D7%A4%D7%A9. עודכנו: target. התאמה: age_min.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '5|||סל שיקום'
  AND COALESCE(public_fields->>'target', '') = '';

-- Row 6: אנוש. 3 field(s), eligibility.
--   להוסיף טלפון 074-7556155, דוא"ל info@enosh.org.il ואזור כל הארץ, ולסמן שנדרש אישור ועדת סל שיקום.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"074-7556155","email":"info@enosh.org.il","region":"כל הארץ"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":18,"recognition":{"btl":"any","mod":"any","moh":"any","rehab_basket":"required"}}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.enosh.org.il/. עודכנו: phone, email, region. התאמה: age_min, recognition.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '6|||שירותי סל שיקום'
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'region', '') = '';

-- Row 7: קידום. 3 field(s), eligibility.
--   להוסיף טלפון 1-800-800-747 ואזורי פעילות, לציין שמדובר בדיור מוגן והוסטלים, ולסמן שנדרש אישור ועדת סל שיקום.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"1-800-800-747","region":"ירושלים, מרכז, צפון ודרום","notes":"דיור מוגן, הוסטלים וקהילות משקמות. כולל קידום חרדי – דיור לציבור הדתי והחרדי בפריסה ארצית."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"recognition":{"btl":"any","mod":"any","moh":"any","rehab_basket":"required"}}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://kidumpro.co.il/ , https://kidumpro.co.il/communities/haredi-advancement/ , https://kidumpro.co.il/our-services/. עודכנו: phone, region, notes. התאמה: recognition.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '7|||שירותי סל שיקום'
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'כולל קידום חרדי';

-- Row 8: ידיד נפש. 3 field(s).
--   להוסיף אזור כל הארץ, לציין שהשירות ניתן בבית ופתוח גם לזכאי משרד הביטחון ובשירות פרטי.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"region":"כל הארץ","target":"זכאי סל שיקום ממשרד הבריאות או ממשרד הביטחון; יש גם שירות פרטי","notes":"השירות ניתן בבית המתמודד. פונים לסניף הקרוב למקום המגורים. יש שירותים מותאמים תרבות: ערבית, רוסית, אנגלית, יוצאי אתיופיה, להט\"ב."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://yadidnefesh.co.il/ , https://yadidnefesh.co.il/branches/%D7%97%D7%99%D7%A4%D7%94/. עודכנו: region, target, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '8|||שירותי סל שיקום'
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'target', '') = 'זכאי סל שיקום'
  AND COALESCE(public_fields->>'notes', '') = '';

-- Row 9: אור לנפש. 4 field(s), eligibility.
--   להוסיף טלפון, דוא"ל, אזורי פעילות (ירושלים והסביבה, מודיעין, שלוחה חרדית בצפון) ושעות, ולסמן שנדרש אישור ועדת סל שיקום.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"02-6223294","email":"orlenefesh@bezeqint.net","region":"ירושלים, בית שמש, קריית ספר, חשמונאים, מודיעין; שלוחה חרדית בצפון","notes":"מתמקדים בדיור בקהילה במסגרת סל השיקום. משרד: הצבי 11, ירושלים. שעות: א''-ה'' 9:00–17:00."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"recognition":{"btl":"any","mod":"any","moh":"any","rehab_basket":"required"}}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://orlanefesh.org.il/ , https://orlanefesh.org.il/%d7%99%d7%a6%d7%99%d7%a8%d7%aa-%d7%a7%d7%a9%d7%a8/ , https://orlanefesh.org.il/%d7%a1%d7%9c-%d7%a9%d7%99%d7%a7%d7%95%d7%9d/. עודכנו: phone, email, region, notes. התאמה: recognition.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '9|||שירותי סל שיקום'
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

-- Row 12: אגף השיקום, משרד הבטחון. 2 field(s), eligibility.
--   להוסיף אזור כל הארץ, לסמן שנדרשת הכרה של משרד הביטחון, ולקשר לכרטיס הטיפולים הרגשיים במימון.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"region":"כל הארץ","notes":"מדריך המרכז את הזכויות העיקריות שחשוב להכיר בתהליך השיקום של המתמודדים עם פגיעה נפשית או פוסט טראומה. ראו גם [אגף השיקום — טיפולים רגשיים במימון](https://nefesh-il.org/rights?entry=218&section=mod)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"recognition":{"btl":"any","mod":"required","moh":"any","rehab_basket":"any"}}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://shikum.mod.gov.il/rights/injury-type/mental. עודכנו: region, notes. התאמה: recognition.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '12|||זכויות למתמודדים עם פגיעה נפשית'
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'מדריך המרכז את הזכויות העיקריות שחשוב להכיר בתהליך השיקום של המתמודדים עם פגיעה נפשית או פוסט טראומה';

-- Row 16: פורטל בריאות הנפש בישראל. 1 field(s).
--   למלא קהל יעד: מתמודדים ובני משפחה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"מתמודדים ובני משפחה"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.mh-israel.co.il/. עודכנו: target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '16|||שירותים למתמודד
אינדקס מטפלים
פורומים
ועוד ועוד'
  AND COALESCE(public_fields->>'target', '') = '';

-- Row 17: החלמה - הנגשת מידע למתמודד נפש ומשפחתו. 2 field(s).
--   להפריד את השם מהטלפון: טלפון 054-4749809 ותווית יוסי שמעונוביץ.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"054-4749809","phoneLabel":"יוסי שמעונוביץ"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://nefesh-il.org/s/17 , https://nefesh-il.org/. עודכנו: phone, phoneLabel.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '17|||'
  AND COALESCE(public_fields->>'phone', '') = 'יוסי שמעונוביץ
054-4749809'
  AND COALESCE(public_fields->>'phoneLabel', '') = '';

-- Row 18: GET HELP Israel. 4 field(s).
--   להוסיף שעות לטלפון, קהל יעד (דוברי אנגלית), אזור כל הארץ ועלות (האתר חינם, הטיפול בתשלום).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"שירות לקוחות (א''-ג'', ה'' 9:00–15:00)","target":"דוברי אנגלית בישראל","region":"כל הארץ","cost":"האתר חינם; הטיפול אצל המטפלים בתשלום"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://gethelpisrael.com/ , https://gethelpisrael.com/contact/. עודכנו: phoneLabel, target, region, cost.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '18|||Provides English-speakers with access to verified mental health specialists as well as resources and information on navigating the mental health system in Israel'
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'cost', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '18|||Provides English-speakers with access to verified mental health specialists as well as resources and information on navigating the mental health system in Israel');

-- Row 21: רי"ל - הרשת הישראלית לחוסן. 2 field(s).
--   להוסיף עלות חינם וקהל יעד: הקהל הרחב, מילואימניקים ומשפחות, צוותי חירום ואנשי מקצוע.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"cost":"חינם","target":"הקהל הרחב, מילואימניקים ומשפחות, צוותי חירום ואנשי מקצוע"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.ril.org.il/. עודכנו: cost, target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '21|||רשת לאומית לחוסן נפשי המאפשרת יצירת כלים אינטראקטיביים מותאמים לקהלי יעד שונים'
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'target', '') = '';

-- Row 27: רגיש לי. 1 field(s).
--   למלא קהל יעד: מתמודדי נפש ובני משפחה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"מתמודדי נפש ובני משפחה"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.ragish.li/. עודכנו: target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '27|||אינדקס שירותים למתמודדי נפש'
  AND COALESCE(public_fields->>'target', '') = '';

-- Row 28: כללית. 7 field(s).
--   להחליף את מספר החירום שלא אומת במוקד התמיכה הנפשית של כללית *8703, ולהוסיף קהל יעד, עלות ואזור.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"*2700","target":"מבוטחי כללית","cost":"פסיכולוג ועו\"ס ללא עלות; פסיכיאטר בהשתתפות עצמית רבעונית","region":"כל הארץ","phone2":"*8703","phoneLabel2":"מוקד תמיכה נפשית 24/7","phoneShowNumber2":true}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.clalit.co.il/he/your_health/family/mental_health/Pages/default.aspx , https://me.health.gov.il/mental-health/therapy-rehabilitation/crisis-support/first-aid/ , https://www.kolsherut.org.il/mental_illness/mental_health_care. עודכנו: phone, target, cost, region, phone2, phoneLabel2, phoneShowNumber2.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '28|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה'
  AND COALESCE(public_fields->>'phone', '') = '*2700 | חירום: 1-700-50-70-50'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'phone2', '') = ''
  AND COALESCE(public_fields->>'phoneLabel2', '') = ''
  AND COALESCE(public_fields->>'phoneShowNumber2', '') = 'true';

-- Row 29: מכבי. 9 field(s).
--   לתקן: במכבי אין צורך בהפניית רופא; להוסיף עלות וקהל יעד, ולהחליף את מספר החירום שלא אומת בקו התמיכה הנפשית *3028.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"אין צורך בהפניית רופא: פונים למרפאה בטופס מקוון, והצוות חוזר תוך 5 ימי עבודה.","cost":"פסיכיאטר: השתתפות עצמית רבעונית 34 ₪; שאר השירותים ללא עלות","target":"חברי מכבי","phone":"*3555","phone2":"*3028","phoneLabel2":"3 שיחות תמיכה בטלפון","phoneShowNumber2":true,"phoneLabel":"מוקד תמיכה נפשית 24/7","phoneShowNumber":true}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.maccabi4u.co.il/eligibilites/2062/ , https://www.maccabi4u.co.il/31276/digital-services/info/information_mental_health/ , https://www.maccabi4u.co.il/eligibilites/2124/. עודכנו: notes, cost, target, phone, phone2, phoneLabel2, phoneShowNumber2, phoneLabel, phoneShowNumber.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '29|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה'
  AND COALESCE(public_fields->>'notes', '') = 'מסובסד עם המלצה מרופא משפחה'
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'phone', '') = '*3555 | חירום: 1-800-401-040'
  AND COALESCE(public_fields->>'phone2', '') = ''
  AND COALESCE(public_fields->>'phoneLabel2', '') = ''
  AND COALESCE(public_fields->>'phoneShowNumber2', '') = 'true'
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'phoneShowNumber', '') = 'true';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '29|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה');

-- Row 36: מהפנטים. 1 field(s).
--   לתקן את שם הארגון ל'משרד הבריאות'.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"משרד הבריאות"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://practitioners.health.gov.il/Hypnotists/901. עודכנו: org.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '36|||אינדקס משרד הבריאות - מהפנטים בעלי רשיון'
  AND COALESCE(public_fields->>'org', '') = 'מהפנטים';

-- Row 52: מילם (מרכז ייעוץ למשפחות מתמודדים). 3 field(s), 4 pin(s), eligibility.
--   להוסיף עלות חינם, תווית ושעות לטלפון *5873, ארבעה סניפים למפה וקישור לכרטיס של אנוש.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"cost":"חינם","phoneLabel":"מרכז המידע של אנוש (א''-ה'' 8:00–15:30)","notes":"המרכזים ברחבי הארץ מופעלים על ידי עמותת אנוש, במימון ובפיקוח של משרד הבריאות. הרשימה הרשמית של מרכזי הייעוץ, בקהילה ובבתי חולים: [מרכזי ייעוץ למשפחות](https://nefesh-il.org/support?entry=308&section=families). ראו גם [אנוש](https://nefesh-il.org/rights?entry=6&section=moh)."}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"מילם כרמיאל","address":"קניון לב כרמיאל, קומה ב'', מורד הגיא 100, כרמיאל","lat":32.9077781,"lng":35.293949,"phone":"04-6882898","email":"","sort_order":0},{"label":"מילם נתניה","address":"הזית 1, שכונת עין התכלת, נתניה","lat":32.3503563,"lng":34.8628662,"phone":"09-8335042","email":"","sort_order":1},{"label":"מילם תל אביב","address":"דרך מנחם בגין 82, קומה 5, תל אביב","lat":32.063416,"lng":34.780072,"phone":"03-5368101","email":"","sort_order":2},{"label":"מילם אילת","address":"שדרות התמרים 39, בניין פירסט, אילת","lat":29.5556768,"lng":34.9523442,"phone":"08-6242522","email":"","sort_order":3}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.milam.org.il/ , https://www.milam.org.il/%D7%9E%D7%A8%D7%9B%D7%96%D7%99_%D7%9E%D7%99%D7%9C%D7%9D/ , https://me.health.gov.il/mental-health/therapy-rehabilitation/rehabilitation/rehabilitation-basket/family-counseling-centers/. עודכנו: cost, phoneLabel, notes. התאמה: location_mode. סיכות: קניון לב כרמיאל, קומה ב'', מורד הגיא 100, כרמיאל; הזית 1, שכונת עין התכלת, נתניה; דרך מנחם בגין 82, קומה 5, תל אביב; שדרות התמרים 39, בניין פירסט, אילת.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '52|||מרכזי ייעוץ, הכוונה, סיוע והדרכה למשפחות מתמודדים'
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'המרכזים ברחבי הארץ מופעלים על ידי עמותת אנוש, במימון ובפיקוח של משרד הבריאות. הרשימה הרשמית של מרכזי הייעוץ, בקהילה ובבתי חולים: [מרכזי ייעוץ למשפחות](https://nefesh-il.org/support?entry=308&section=families).';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('מילם כרמיאל', 'קניון לב כרמיאל, קומה ב'', מורד הגיא 100, כרמיאל', 32.9077781, 35.293949, 0),
  ('מילם נתניה', 'הזית 1, שכונת עין התכלת, נתניה', 32.3503563, 34.8628662, 1),
  ('מילם תל אביב', 'דרך מנחם בגין 82, קומה 5, תל אביב', 32.063416, 34.780072, 2),
  ('מילם אילת', 'שדרות התמרים 39, בניין פירסט, אילת', 29.5556768, 34.9523442, 3)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '52|||מרכזי ייעוץ, הכוונה, סיוע והדרכה למשפחות מתמודדים' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '52|||מרכזי ייעוץ, הכוונה, סיוע והדרכה למשפחות מתמודדים');

-- Row 59: זה מגיע לכם - ד"ר גילי תמיר. 2 field(s).
--   להוסיף תווית לקישור לתוכנית ברשת ב' והערה עם שעות השידור ודוא"ל התוכנית.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"addLabel":"התוכנית ברשת ב''","notes":"תוכנית רדיו על זכויות ברשת ב'' של כאן, בימים א''-ד'' 19:00–20:00. אפשר לכתוב לתוכנית: ze@kan.org.il"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.facebook.com/drgilitamir/ , https://www.kan.org.il/content/kan/kan-b/p-10067/. עודכנו: addLabel, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '59|||מיצוי זכויות'
  AND COALESCE(public_fields->>'addLabel', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

-- Row 62: עמותת בית חם. 2 field(s), 3 pin(s), eligibility.
--   להוסיף קהל יעד (מבוגרים וילדים), אזורים, וחמש מרפאות למפה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"מבוגרים וילדים","region":"ירושלים, בית שמש, בני ברק, אלעד, מודיעין עילית"}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"מרפאת בית שמש","address":"דבורה הנביאה 16, רמת בית שמש ג'' 2, בית שמש","lat":31.7042655,"lng":34.9920601,"phone":"073-2800-570","email":"","sort_order":0},{"label":"מרפאת בני ברק","address":"כהנמן 72, בני ברק","lat":32.0812317,"lng":34.840977,"phone":"073-2800-550","email":"","sort_order":1},{"label":"מרפאת אלעד","address":"בן זכאי 93, אלעד","lat":32.051212,"lng":34.9670308,"phone":"073-2800-560","email":"","sort_order":2}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.bayit-cham.org.il/%d7%9e%d7%a8%d7%a4%d7%90%d7%aa-%d7%93%d7%a8%d7%95%d7%a8/. עודכנו: target, region. התאמה: location_mode. סיכות: דבורה הנביאה 16, רמת בית שמש ג'' 2, בית שמש; כהנמן 72, בני ברק; בן זכאי 93, אלעד.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '62|||מרפאות לבריאות הנפש
'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'region', '') = '';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('מרפאת בית שמש', 'דבורה הנביאה 16, רמת בית שמש ג'' 2, בית שמש', 31.7042655, 34.9920601, 0),
  ('מרפאת בני ברק', 'כהנמן 72, בני ברק', 32.0812317, 34.840977, 1),
  ('מרפאת אלעד', 'בן זכאי 93, אלעד', 32.051212, 34.9670308, 2)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '62|||מרפאות לבריאות הנפש
' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

-- Row 68: בלב ובנפש (עזר מציון). 7 field(s).
--   להוסיף טלפון למרכז בלב ובנפש ולמרכזי המשפחות, ולהחליף 'ערים שונות' ברשימת הערים.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"073-3956204","phoneLabel":"מרכז בלב ובנפש","phone2":"073-3956218","phoneLabel2":"מרכזי משפחות","region":"בני ברק, פתח תקווה, אלעד, ראש העין, מודיעין עילית, ביתר, ירושלים, בית שמש, חיפה","target":"מתמודדי נפש ובני משפחותיהם","notes":"מרכז לליווי מתמודדים במימוש הזכויות ובתהליך השיקום. ראו גם [האגף לבריאות הנפש (עזר מציון)](https://nefesh-il.org/rights?entry=305&section=rehabilitation)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.ami.org.il/services. עודכנו: phone, phoneLabel, phone2, phoneLabel2, region, target, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '68|||סיוע למשפחות של מתמודדי נפש'
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'phone2', '') = ''
  AND COALESCE(public_fields->>'phoneLabel2', '') = ''
  AND COALESCE(public_fields->>'region', '') = 'ערים שונות'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'מרכז לליווי מתמודדים במימוש הזכויות ובתהליך השיקום';

-- Row 78: המרכז הירושלמי לבריאות הנפש (כפר שאול-איתנים). 3 field(s), 1 pin(s), eligibility.
--   להוסיף טלפון 1599-50-60-80, קהל יעד (כל הגילאים), שני הקמפוסים למפה וקישור לכרטיס נזעי חשמל.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"1599-50-60-80","target":"כל הגילאים, מילדות ועד זקנה","notes":"ראו גם [ECT (נזעי חשמל)](https://nefesh-il.org/treatment?entry=109&section=treatments)."}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"קמפוס כפר שאול","address":"קצנלבוגן 101, ירושלים","lat":31.7832812,"lng":35.1752191,"phone":"1599-50-60-80","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול http://www.psjer.org.il/ , https://psjer.org.il/%D7%90%D7%95%D7%93%D7%95%D7%AA/ , https://psjer.org.il/%D7%94%D7%A6%D7%94%D7%A8%D7%AA-%D7%A0%D7%92%D7%99%D7%A9%D7%95%D7%AA/. עודכנו: phone, target, notes. התאמה: location_mode. סיכות: קצנלבוגן 101, ירושלים.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '78|||המרכז מעניק רצף טיפולי למגוון הפרעות הנפש, בכל הגילאים, למצבים פסיכוטיים חריפים, מצבים ממושכים עם דגש שיקומי ושירות קהילתי. מערך הטיפול כולל את כל סוגי הטיפולים הביולוגיים המקובלים (תרופות חדישות לסוגיהן, חדר סנוסלן – גרייה רב חושית ונזעי חשמל), טיפול זוגי ומשפחתי, פסיכותראפיה פרטנית וקבוצתית, טיפול באומנות וריפוי בעיסוק.'
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('קמפוס כפר שאול', 'קצנלבוגן 101, ירושלים', 31.7832812, 35.1752191, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '78|||המרכז מעניק רצף טיפולי למגוון הפרעות הנפש, בכל הגילאים, למצבים פסיכוטיים חריפים, מצבים ממושכים עם דגש שיקומי ושירות קהילתי. מערך הטיפול כולל את כל סוגי הטיפולים הביולוגיים המקובלים (תרופות חדישות לסוגיהן, חדר סנוסלן – גרייה רב חושית ונזעי חשמל), טיפול זוגי ומשפחתי, פסיכותראפיה פרטנית וקבוצתית, טיפול באומנות וריפוי בעיסוק.' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

-- Row 80: מאוחדת. 5 field(s).
--   לתקן: במאוחדת קובעים פגישת מיון ישירות ב-*3833 בלי הפניה; להסיר את מספר החירום שלא אומת ולהוסיף עלות, אזור וקהל יעד.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"אין צורך בהפניית רופא: קובעים פגישת מיון במוקד *3833.","phone":"*3833","cost":"טיפול פסיכולוגי ללא עלות; ביקור פסיכיאטר בהשתתפות עצמית","region":"כל הארץ","target":"מבוטחי מאוחדת"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.meuhedet.co.il/%D7%9E%D7%90%D7%95%D7%97%D7%93%D7%AA-%D7%9C%D7%A0%D7%A4%D7%A9/ , https://www.meuhedet.co.il/%D7%9E%D7%90%D7%95%D7%97%D7%93%D7%AA-%D7%9C%D7%A0%D7%A4%D7%A9/%D7%90%D7%9C-%D7%AA%D7%94%D7%99%D7%95-%D7%9C%D7%91%D7%93/. עודכנו: notes, phone, cost, region, target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '80|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה'
  AND COALESCE(public_fields->>'notes', '') = 'מסובסד עם המלצה מרופא משפחה'
  AND COALESCE(public_fields->>'phone', '') = '*3833 | חירום: 1-800-20-20-60'
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'target', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '80|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה');

-- Row 81: לאומית. 3 field(s).
--   לתקן: בלאומית אפשר גם לפנות ישירות לתומך בריאות הנפש ב-*507; להסיר את מספר החירום שלא אומת ולהוסיף קהל יעד.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"אפשר בהפניית רופא, או בפנייה ישירה: מי שלא היה בטיפול בחצי השנה האחרונה קובע תור לתומך בריאות הנפש ב-*507.","phone":"*507","target":"מבוטחי לאומית"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.leumit.co.il/mental-health-arena/ , https://leumit.co.il/leumit-for-you/appointments/. עודכנו: notes, phone, target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '81|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה'
  AND COALESCE(public_fields->>'notes', '') = 'מסובסד עם המלצה מרופא משפחה'
  AND COALESCE(public_fields->>'phone', '') = '*507 | חירום: 1-800-240-240'
  AND COALESCE(public_fields->>'target', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['gp_referral', 'self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '81|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה');

-- Row 82: כל זכות. 1 field(s), eligibility.
--   למלא קהל יעד (בני 18 ומעלה המתמודדים עם לקות נפשית) ולהגדיר גיל מינימום 18.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"בני 18 ומעלה המתמודדים עם לקות נפשית"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":18}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.kolzchut.org.il/he/%D7%A7%D7%91%D7%99%D7%A2%D7%AA_%D7%A0%D7%9B%D7%95%D7%AA_%D7%9C%D7%9E%D7%AA%D7%9E%D7%95%D7%93%D7%93%D7%99_%D7%A0%D7%A4%D7%A9. עודכנו: target. התאמה: age_min.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '82|||קביעת נכות למתמודדי נפש'
  AND COALESCE(public_fields->>'target', '') = '';

-- Row 83: כל זכות. 1 field(s), eligibility.
--   למלא קהל יעד ולהגדיר גיל מינימום 18.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"בני 18 ומעלה הזקוקים לעזרה רבה של אדם אחר בפעולות היום-יום או להשגחה מתמדת"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":18}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.kolzchut.org.il/he/%D7%A7%D7%A6%D7%91%D7%AA_%D7%A9%D7%99%D7%A8%D7%95%D7%AA%D7%99%D7%9D_%D7%9E%D7%99%D7%95%D7%97%D7%93%D7%99%D7%9D. עודכנו: target. התאמה: age_min.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '83|||קצבת שירותים מיוחדים למתמודדי נפש'
  AND COALESCE(public_fields->>'target', '') = '';

-- Row 84: כל זכות. 1 field(s), eligibility.
--   למלא קהל יעד (בני 18 ומעלה עם 40% נכות נפשית לפחות) ולהגדיר גיל מינימום 18.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"בני 18 ומעלה שנקבעו להם לפחות 40% נכות רפואית על רקע נפשי"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":18}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.kolzchut.org.il/he/%D7%A1%D7%9C_%D7%A9%D7%99%D7%A7%D7%95%D7%9D_%D7%9C%D7%9E%D7%AA%D7%9E%D7%95%D7%93%D7%93%D7%99_%D7%A0%D7%A4%D7%A9. עודכנו: target. התאמה: age_min.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '84|||סל שיקום למתמודדי נפש'
  AND COALESCE(public_fields->>'target', '') = '';

-- Row 85: כל זכות. 1 field(s).
--   למלא קהל יעד: מתמודדי נפש ובני משפחותיהם.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"מתמודדי נפש ובני משפחותיהם"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.kolzchut.org.il/he/%D7%9E%D7%93%D7%A8%D7%99%D7%9A_%D7%9E%D7%99%D7%A6%D7%95%D7%99_%D7%96%D7%9B%D7%95%D7%99%D7%95%D7%AA_%D7%9C%D7%9E%D7%AA%D7%9E%D7%95%D7%93%D7%93%D7%99_%D7%A0%D7%A4%D7%A9_%D7%95%D7%91%D7%A0%D7%99_%D7%9E%D7%A9%D7%A4%D7%97%D7%95%D7%AA%D7%99%D7%94%D7%9D. עודכנו: target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '85|||מדריך מיצוי זכויות למתמודדי נפש ובני משפחותיהם'
  AND COALESCE(public_fields->>'target', '') = '';

-- Row 202: הקואליציה הישראלית לטראומה. 4 field(s).
--   להוסיף את טלפון המשרד 02-6722618 ודוא"ל הקואליציה, ולקשר לכרטיס מרכזי החוסן.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone3":"02-6722618","phoneLabel3":"משרד הקואליציה","email":"info@itc-office.org.il","notes":"שותפות ארגונים ומרכזי חוסן; מענים רגשיים בחירום ובשגרה. אתר דו-לשוני (עברית / English). ראו גם [מרכזי חוסן](https://nefesh-il.org/treatment?entry=30&section=therapists)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://israeltraumacoalition.org/. עודכנו: phone3, phoneLabel3, email, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '202|||מידע, הכשרות, מוקדי חוסן ושותפות ארצית בטראומה וחוסן (Israel Trauma Coalition)'
  AND COALESCE(public_fields->>'phone3', '') = ''
  AND COALESCE(public_fields->>'phoneLabel3', '') = ''
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'שותפות ארגונים ומרכזי חוסן; מענים רגשיים בחירום ובשגרה. אתר דו-לשוני (עברית / English).';

-- Row 244: סל שיקום. 2 field(s).
--   לציין שהטלפון *5400 הוא מוקד משרד הבריאות, ולקשר לכרטיס ביטוח לאומי.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"מוקד משרד הבריאות","notes":"אתר עם שאלון התאמה לספקי שירות, מדריכי זכויות, ביטוח לאומי ומידע למשפחות. ראו גם [ביטוח לאומי](https://nefesh-il.org/rights?entry=1&section=rights)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://salshikum.org/. עודכנו: phoneLabel, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '244|||מידע, זכויות ואיתור ספקי שירות בסל שיקום'
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'אתר עם שאלון התאמה לספקי שירות, מדריכי זכויות, ביטוח לאומי ומידע למשפחות';

-- Row 278: האגודה לבריאות הציבור. 3 field(s).
--   להרחיב את קהל היעד גם למוכרים במשרד הרווחה ובמשרד הביטחון, ולהוסיף את הטלפון הרשמי 02-5656900.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"מתמודדי נפש ואנשים עם מוגבלויות המוכרים לשירות על ידי משרד הבריאות, משרד הרווחה או משרד הביטחון","phone2":"02-5656900","phoneLabel2":"מוקד האגודה (א''-ה'' 8:00–15:00)"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.aguda.co.il/service-categories/%d7%a9%d7%99%d7%a7%d7%95%d7%9d-%d7%95%d7%97%d7%95%d7%a0%d7%9b%d7%95%d7%aa/ , https://www.aguda.co.il/service-categories/%D7%A9%D7%99%D7%A7%D7%95%D7%9D-%D7%9C%D7%90%D7%A0%D7%A9%D7%99%D7%9D-%D7%A2%D7%9D-%D7%9E%D7%95%D7%92%D7%91%D7%9C%D7%95%D7%99%D7%95%D7%AA/. עודכנו: target, phone2, phoneLabel2.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '278|||שירותי סל שיקום'
  AND COALESCE(public_fields->>'target', '') = 'זכאי סל שיקום'
  AND COALESCE(public_fields->>'phone2', '') = ''
  AND COALESCE(public_fields->>'phoneLabel2', '') = '';

-- Row 283: יוזמה דרך הלב. 0 field(s), 2 pin(s), eligibility.
--   להוסיף למפה את שני המשרדים בכפר סבא ובבאר שבע.
UPDATE directory_card_edits
SET sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"משרד כפר סבא","address":"תע\"ש 20, כפר סבא","lat":32.171784,"lng":34.924593,"phone":"09-7656475","email":"","sort_order":0},{"label":"משרד באר שבע","address":"רמב\"ם 4, באר שבע","lat":31.2414389,"lng":34.7929652,"phone":"08-6655462","email":"","sort_order":1}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.yozma4u.co.il/. התאמה: location_mode. סיכות: תע"ש 20, כפר סבא; רמב"ם 4, באר שבע.', E'\n ')),
    updated_at = now()
WHERE card_key = '283|||שיקום תעסוקתי, תעסוקה נתמכת ויזמות — כולל תוכנית צרכנים נותני שירות';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('משרד כפר סבא', 'תע"ש 20, כפר סבא', 32.171784, 34.924593, 0),
  ('משרד באר שבע', 'רמב"ם 4, באר שבע', 31.2414389, 34.7929652, 1)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '283|||שיקום תעסוקתי, תעסוקה נתמכת ויזמות — כולל תוכנית צרכנים נותני שירות' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

COMMIT;
