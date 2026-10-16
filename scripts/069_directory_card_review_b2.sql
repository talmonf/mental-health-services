-- Migration 069 (16 Oct 2026)
-- Card review, batch 2: changes approved by the site owner, from docs/card-review-2026-10.md.
-- Each UPDATE only applies if the fields it changes still hold the reviewed text, so a later
-- admin edit is never overwritten. Pins are geocoded with OpenStreetMap Nominatim.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- Row 10: מערך בריאות הנפש במשרד הביטחון. 2 field(s).
--   לתקן את שם הארגון למערך בריאות הנפש בצה״ל ולהוסיף בהערות את שלוחה 4.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"מערך בריאות הנפש בצה״ל","notes":"מופעל על ידי מערך בריאות הנפש בצה״ל, במוקד מקול הלב: *6690 שלוחה 4. זמין 24/7 לחיילים בסדיר ובמילואים, ומאויש על ידי קב״נים. במקרה דחוף מעבירים לקב״ן תורן; אחרת מפנים לקב״ן היחידה להמשך טיפול."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.idf.il/%D7%90%D7%AA%D7%A8%D7%99-%D7%99%D7%97%D7%99%D7%93%D7%95%D7%AA/%D7%90%D7%92%D7%A3-%D7%94%D7%98%D7%9B%D7%A0%D7%95%D7%9C%D7%95%D7%92%D7%99%D7%94-%D7%95%D7%94%D7%9C%D7%95%D7%92%D7%99%D7%A1%D7%98%D7%99%D7%A7%D7%94/%D7%9B%D7%9C-%D7%94%D7%9B%D7%AA%D7%91%D7%95%D7%AA/2025/%D7%A1%D7%99%D7%95%D7%A2-%D7%A0%D7%A4%D7%A9%D7%99-%D7%91%D7%A6%D7%94-%D7%9C-%D7%90%D7%99%D7%9A-%D7%A4%D7%95%D7%A0%D7%99%D7%9D-%D7%9C%D7%A7%D7%91-%D7%9F-%D7%95%D7%9C%D7%90%D7%9F-%D7%9E%D7%AA%D7%A7%D7%A9%D7%A8%D7%99%D7%9D/ , https://www.miluim.idf.il/articles-list/%D7%A9%D7%A2%D7%95%D7%AA-%D7%A4%D7%A2%D7%99%D7%9C%D7%95%D7%AA-%D7%9E%D7%95%D7%A7%D7%93-%D7%94%D7%9E%D7%99%D7%9C%D7%95%D7%90%D7%99%D7%9D. עודכנו: org, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '10|||קבלת סיוע נפשי מיידי'
  AND COALESCE(public_fields->>'org', '') = 'מערך בריאות הנפש במשרד הביטחון'
  AND COALESCE(public_fields->>'notes', '') = 'מופעל על ידי מערך בריאות הנפש בצה״ל. זמין 24/7 לחיילים, מילואים וכוחות הביטחון. סיוע נפשי מיידי; במידת הצורך הפניה להמשך טיפול.';

-- Row 11: "נפש אחת בישראל" (אגף השיקום, משרד הבטחון). 4 field(s).
--   להרחיב את קהל היעד (גם מגישי בקשה להכרה, משטרה, שב״ס ובני משפחה), להוסיף אזור ועלות (חינם), ולציין בהערות שהקו פועל 24/7 ושעונים בו אנשי נט״ל.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"נכי ונכות צה״ל וכוחות הביטחון, מי שהגישו בקשה להכרה, מי ששירתו בצה״ל, במשטרה, בשב״ס וביחידות הביטחון ומתמודדים עם קשיים בעקבות השירות, ובני משפחותיהם","region":"כל הארץ","cost":"חינם","notes":"קו התמיכה של אגף השיקום, זמין 24/7 כולל בחגים. המענה ניתן על ידי אנשי מקצוע ומתנדבים של [נט״ל](https://nefesh-il.org/support?entry=21&section=helplines). אפשר לפנות באופן אנונימי, בלי אישורים ובלי בירוקרטיה. בשעת משבר נפשי הקו יכול לשלוח צוות התערבות שמגיע עד הבית, רק בהסכמת הפונה."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://shikum.mod.gov.il/ContactUs/helpline. עודכנו: target, region, cost, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '11|||קו המעניק תמיכה נפשית ראשונית'
  AND COALESCE(public_fields->>'target', '') = 'נכי צה"ל וכוחות הביטחון, ולחיילים משוחררים שמתמודדים עם פוסט טראומה עקב שירותם הצבאי'
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'קו המופעל על ידי אגף השיקום ומעניק תמיכה נפשית ראשונית לכוחות הביטחון וחיילים וחיילות משוחררים המתמודדים עם פוסט טראומה בעקבות שירותם הצבאי. ניתן לפנות באופן אנונימי.';

-- Row 13: בנפש בריאה - משרד הבריאות. 3 field(s).
--   להוסיף את מספרי הקשר של הפורטל (*5400, 08-6241010) ולקשר ישירות לעמוד מוקדי הסיוע.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"*5400","phone2":"08-6241010","web":"https://me.health.gov.il/mental-health/therapy-rehabilitation/crisis-support/first-aid/"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://me.health.gov.il/mental-health/ , https://me.health.gov.il/mental-health/therapy-rehabilitation/crisis-support/first-aid/ , http://www.gov.il/he/life-events/information-for-evacuation/support-in-health-and-welfare. עודכנו: phone, phone2, web.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '13|||קווי סיוע והכוונה'
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'phone2', '') = ''
  AND COALESCE(public_fields->>'web', '') = 'https://me.health.gov.il/mental-health/';

-- Row 14: ביטוח לאומי. 4 field(s).
--   הקישור לרשימה של ביטוח לאומי לא עובד; להחליף לרשימה הממשלתית, לדייק את קהל היעד (פצועים ומשפחות שכולות) ולהוסיף עלות חינם.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"web":"https://www.gov.il/he/Departments/DynamicCollectors/resilience-centers-list","target":"פצועים ומשפחות שכולות (נפגעי פעולות איבה), ומי שחווים חרדה על רקע ביטחוני","cost":"חינם","notes":"מרכזי חוסן לחרבות ברזל. קו חירום לפצועים ולמשפחות שכולות: א-ה 8:00-17:00. בכל נושא אחר: מוקד ביטוח לאומי *6050. ראו גם [מרכזי חוסן](https://nefesh-il.org/treatment?entry=30&section=therapists)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.btl.gov.il/HaravotBarzel1/Harada_HB/Pages/MrkaziHosenResima.aspx , http://www.btl.gov.il/HaravotBarzel1/Pages/KavHeromHB.aspx , http://www.btl.gov.il/About/news/Pages/ArchiveFolder/2024/IdconimMazavBitconi.aspx , https://me.health.gov.il/mental-health/therapy-rehabilitation/public-care/community-treatment/resilience-center/. עודכנו: web, target, cost, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '14|||רשימת מוקדי הטיפול ומרכזי החוסן'
  AND COALESCE(public_fields->>'web', '') = 'https://www.btl.gov.il/HaravotBarzel1/Harada_HB/Pages/MrkaziHosenResima.aspx'
  AND COALESCE(public_fields->>'target', '') = 'נפגעי טרור, שכולות, חטופים ונעדרים'
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'מרכזי חוסן לחרבות ברזל. קו חירום: א-ה 8:00-17:00.';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '14|||רשימת מוקדי הטיפול ומרכזי החוסן');

-- Row 15: מוקד הסיוע של משרד החינוך. 4 field(s).
--   לעדכן לשם המוקד "קול לכולם", להוסיף אנשי חינוך לקהל היעד, ולהוסיף שעות פעילות וטופס פנייה אנונימי.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"מוקד \"קול לכולם\" - משרד החינוך","target":"תלמידים, הורים ואנשי חינוך","notes":"מוקד של משרד החינוך, שמופעל על ידי אנשי מקצוע מהשירות הפסיכולוגי-ייעוצי. מענה רגשי וחברתי במצבי מצוקה, דחייה חברתית וחרם. פועל א׳-ה׳ 8:00-20:00, ו׳ 8:00-14:00. אפשר גם לפתוח פנייה אנונימית בטופס מקוון.","web":"https://pob.education.gov.il/inquiries-services/support/"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://pob.education.gov.il/inquiries-services/support/ , https://pob.education.gov.il/municipal-services/shefi-psichologists/. עודכנו: org, target, notes, web.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '15|||מוקד סיוע רגשי-חברתי להורים ולתלמידים'
  AND COALESCE(public_fields->>'org', '') = 'מוקד הסיוע של משרד החינוך'
  AND COALESCE(public_fields->>'target', '') = 'הורים ותלמידים'
  AND COALESCE(public_fields->>'notes', '') = 'משרד החינוך מרחיב את פעילות מוקד הסיוע הרגשי-חברתי להורים ולתלמידים.'
  AND COALESCE(public_fields->>'web', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '15|||מוקד סיוע רגשי-חברתי להורים ולתלמידים');

-- Row 20: עמותת ער"ן (עזרה ראשונה נפשית). 6 field(s).
--   לתקן את מספר הוואטסאפ ל-052-8451201 (המספר הכללי שער״ן מפרסם), לציין שקו *2201 פתוח גם לבני משפחה, ולהוסיף קהל יעד ואזור.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"whatsapp":"972528451201","whatsappLabel":"וואטסאפ","phoneLabel2":"לחיילים, מילואים ומשפחותיהם","target":"כלל הציבור, בכל גיל","region":"כל הארץ","notes":"1201 — קו כללי, 24/7. *2201 — לחיילים בסדיר, בקבע ובמילואים ולבני משפחותיהם, 24/7. וואטסאפ: 052-8451201. אפשר גם בצ׳אט באתר, במייל וב-SMS. הפנייה אנונימית."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.eran.org.il/ , https://www.eran.org.il/eran-for-the-community/soldiers/ , https://www.eran.org.il/services/. עודכנו: whatsapp, whatsappLabel, phoneLabel2, target, region, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '20|||קו סיוע והכוונה'
  AND COALESCE(public_fields->>'whatsapp', '') = '972528451202'
  AND COALESCE(public_fields->>'whatsappLabel', '') = 'לחיילים · וואטסאפ'
  AND COALESCE(public_fields->>'phoneLabel2', '') = 'לחיילים ומילואים'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '1201 — קו כללי. *2201 ו-052-8451202 — לחיילים ומילואים, 24/7.';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '20|||קו סיוע והכוונה');

-- Row 21: נט"ל (נפגעי טראומה על רקע לאומי). 3 field(s).
--   לתקן את ההערה: 1-800-363-363 הוא המספר הישן של נט״ל ולא של ארגון אחר; להרחיב את קהל היעד לאזרחים, ולהוסיף עלות חינם לקו.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"קו הסיוע של נט״ל זמין 24/7. המספר הישן 1-800-363-363 עדיין מופיע במקורות רשמיים, והוא של נט״ל. נט״ל עונה גם בקו [נפש אחת](https://nefesh-il.org/support?entry=11&section=emergency) של אגף השיקום. יש גם טיפול פרטני קצר, עד 12 מפגשים ללא עלות.","target":"נפגעי טראומה על רקע לאומי (מלחמה וטרור): אזרחים, חיילים משוחררים ומשפחותיהם","cost":"חינם (קו הסיוע)"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.natal.org.il/ , https://www.kolsherut.org.il/p/card/c/47d40bba , https://me.health.gov.il/mental-health/therapy-rehabilitation/crisis-support/first-aid/. עודכנו: notes, target, cost. אוחד עם כרטיס 216 (ל"נט), שתיאר את נט"ל בשם שגוי.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '21|||תמיכה נפשית ותעסוקתית לנפגעי טראומה ממלחמה וטרור'
  AND COALESCE(public_fields->>'notes', '') = 'שונה מל"נט (1800-363-363).'
  AND COALESCE(public_fields->>'target', '') = 'חיילי מילואים, משוחררים ומשפחותיהם'
  AND COALESCE(public_fields->>'cost', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '21|||תמיכה נפשית ותעסוקתית לנפגעי טראומה ממלחמה וטרור');

-- Row 22: סיוע והקשבה ברשת (סהר). 2 field(s).
--   להוסיף שהשירות חינמי וזמין 24/7 בצ׳אט ובוואטסאפ.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"cost":"חינם","notes":"צ׳אט אנונימי באתר או בוואטסאפ, 24/7, עם מתנדבים שמלווים על ידי אנשי מקצוע בבריאות הנפש."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://sahar.org.il/. עודכנו: cost, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '22|||קו סיוע והכוונה'
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'התכתבות עם נציג, אפשר באופן אנונימי';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '22|||קו סיוע והכוונה');

-- Row 24: מטיבת"א (מרכז טיפול יעוץ במשפחה תורני). 2 field(s).
--   להוסיף קהל יעד: הציבור הדתי והחרדי.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"הציבור הדתי והחרדי","notes":"מרכז מטיבת\"א מציע שירותי טיפול ויעוץ נפשי ורגשי, מותאם עבור הציבור הדתי והחרדי. שונה ממטיב (מרכז לפסיכוטראומה, 02-5952240 — חוברת חרבות ברזל). כאן תוכלו למצוא מוקדי סיוע מיידי, מידע מקצועי, פורום מומחים ואת מרכז הטיפול של מטיבת\"א, המציע התאמת מטפל לפי מספר קריטריונים המותאמים במיוחד לציבור הדתי והחרדי. ראו גם [מטיב (המרכז הישראלי לפסיכוטראומה)](https://nefesh-il.org/treatment?entry=210&section=trauma)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://metivta.org.il/. עודכנו: target, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '24|||מוקדי סיוע
מרכז טיפול
ועוד'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'מרכז מטיבת"א מציע שירותי טיפול ויעוץ נפשי ורגשי, מותאם עבור הציבור הדתי והחרדי. שונה ממטיב (מרכז לפסיכוטראומה, 02-5952240 — חוברת חרבות ברזל). כאן תוכלו למצוא מוקדי סיוע מיידי, מידע מקצועי, פורום מומחים ואת מרכז הטיפול של מטיבת"א, המציע התאמת מטפל לפי מספר קריטריונים המותאמים במיוחד לציבור הדתי והחרדי.';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '24|||מוקדי סיוע
מרכז טיפול
ועוד');

-- Row 25: מוקד CALL לנפש. 5 field(s).
--   להוסיף את מספר הטלפון *8246, שעות פעילות, מייל וקהל יעד (בני משפחה של מתמודדי נפש).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"*8246","org":"מוקד CALL לנפש (קואליציית הארגונים הדתיים למען בריאות הנפש)","email":"office@homiyacbh.org","target":"בני משפחה של מתמודדי נפש","notes":"מתנדבי המוקד מעניקים תמיכה ואוזן קשבת לבני משפחה. שעות: א׳-ה׳ 12:00-24:00, ו׳ 8:00-14:00, מוצאי שבת 20:00-24:00. כולל גם קבוצות תמיכה בוואטסאפ למשפחות מטופלים."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://cbh.org.il/%D7%A7%D7%91%D7%9C%D7%AA-%D7%A2%D7%96%D7%A8%D7%94/. עודכנו: phone, org, email, target, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '25|||תמיכה ואוזן קשבת לבני משפחה למתמודדי נפש'
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'org', '') = 'מוקד CALL לנפש'
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'כולל גם קבוצות תמיכה בוואטסאפ למשפחות מטופלים';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '25|||תמיכה ואוזן קשבת לבני משפחה למתמודדי נפש');

-- Row 26: ידידי נפש (עזר מציון). 4 field(s).
--   להוסיף קהל יעד, ואת קו החירום 1-800-808-100 שנפתח בזמן משבר לאומי.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"כל מי שזקוק לסיוע נפשי מיידי, בכל גיל","phone2":"1-800-808-100","phoneLabel2":"קו חירום (בזמן משבר לאומי)","notes":"תמיכה, ייעוץ, הכוונה וסיוע בזמני מצוקה נפשית. קו דיסקרטי של אנשי מקצוע בבריאות הנפש; אפשר לפנות באופן אנונימי. בשעת חירום או משבר לאומי נפתח קו חירום 24/6: 1-800-808-100."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.ami.org.il/services/mental-counseling. עודכנו: target, phone2, phoneLabel2, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '26|||קו ייעוץ ותמיכה - בימים א-ה בשעות 10:00-13:00 ו-16:00-22:00'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'phone2', '') = ''
  AND COALESCE(public_fields->>'phoneLabel2', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'תמיכה, ייעוץ, הכוונה וסיוע בזמני מצוקה נפשית';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '26|||קו ייעוץ ותמיכה - בימים א-ה בשעות 10:00-13:00 ו-16:00-22:00');

-- Row 30: מרכזי חוסן. 3 field(s).
--   להוסיף קהל יעד (מצוקה על רקע ביטחוני), עלות חינם, ופירוט איך מופנים למרכז לפי מקום המגורים.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"מי שחווים חרדה או מצוקה על רקע ביטחוני","cost":"חינם","notes":"השירות הראשוני דרך *5486, ומשם מפנים למרכז החוסן לפי כתובת המגורים. מי שאין באזורו מרכז חוסן מקבל טיפול במרכז החוסן הארצי. המרכז הארצי פועל בימים א-ה 08:00-20:00, ובזמני חירום 24/7. בצפון אפשר להתקשר ישירות: עברית 04-6900603, ערבית 04-7702649, רוסית 04-7702650, אנגלית 04-7702651. ראו גם [ביטוח לאומי](https://nefesh-il.org/emergency?entry=14&section=helplines)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.gov.il/he/Departments/DynamicCollectors/resilience-centers-list , https://me.health.gov.il/mental-health/therapy-rehabilitation/public-care/community-treatment/resilience-center/ , https://me.health.gov.il/mental-health/therapy-rehabilitation/public-care/community-treatment/treatment-services/. עודכנו: target, cost, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '30|||רשימת מרכזי חוסן ברחבי הארץ'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'המרכז פועל בימים א-ה בין השעות 08:00-20:00, ובזמני חירום פועל 24/7';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '30|||רשימת מרכזי חוסן ברחבי הארץ');

-- Row 39: אגף השיקום, משרד הבטחון. 4 field(s), 3 pin(s), eligibility.
--   לתקן את הטלפון של טירת הכרמל ל-050-3627283, להוסיף את הבית החמישי בבאר יעקב, אזור ועלות (חינם), וכתובות לחמשת הבתים.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone4":"050-3627283","region":"כל הארץ","cost":"חינם","notes":"הבתים הבטוחים הם חלופת אשפוז מיידית ונקודתית למתמודדים עם פוסט טראומה בזמן משבר נפשי ואישי. הבתים נמצאים בתוך בתי חולים, פעילים 24/7, ואפשר לשהות בהם עד 10 ימים, ללא עלות. אפשר להגיע ישירות למיון בבית החולים, בלי הפניה מהאגף. לא מתאים למצבי סיכון גבוה (אובדנות פעילה, פסיכוזה פעילה). ירושלים: 02-6551303 שלוחה 2815 או 050-3682799. תל השומר: 052-6669512. באר יעקב (מרחבים): 08-9258271. ראו גם [\"נפש אחת בישראל\"\n(אגף השיקום, משרד הבטחון)](https://nefesh-il.org/emergency?entry=11&section=emergency)."}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"הבית הבטוח באר שבע","address":"הצדיק מירושלים 2, באר שבע","lat":31.2718683,"lng":34.7840632,"phone":"052-4614896","email":"","sort_order":0},{"label":"הבית הבטוח ירושלים (כפר שאול)","address":"רפאל קצנלבוגן 101, ירושלים","lat":31.7863014,"lng":35.1794489,"phone":"02-6551303","email":"","sort_order":1},{"label":"הבית הבטוח תל השומר","address":"מרכז רפואי שיבא, תל השומר, רמת גן","lat":32.0471842,"lng":34.8452013,"phone":"052-6669512","email":"","sort_order":2}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://shikum.mod.gov.il/medical/mental-therapy/safe_housing , https://shikum.mod.gov.il/medical/hospitalization/safehouse. עודכנו: phone4, region, cost, notes. התאמה: location_mode. סיכות: הצדיק מירושלים 2, באר שבע; רפאל קצנלבוגן 101, ירושלים; מרכז רפואי שיבא, תל השומר, רמת גן.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '39|||בית בטוח לטיפול מיידי - חלופת אשפוז'
  AND COALESCE(public_fields->>'phone4', '') = '052-6669512'
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'הבתים הבטוחים מהווים חלופת אשפוז מיידית ונקודתית למתמודדים עם פוסט טראומה בזמן של משבר נפשי ואישי. ירושלים שלוחה 2815';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('הבית הבטוח באר שבע', 'הצדיק מירושלים 2, באר שבע', 31.2718683, 34.7840632, 0),
  ('הבית הבטוח ירושלים (כפר שאול)', 'רפאל קצנלבוגן 101, ירושלים', 31.7863014, 35.1794489, 1),
  ('הבית הבטוח תל השומר', 'מרכז רפואי שיבא, תל השומר, רמת גן', 32.0471842, 34.8452013, 2)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '39|||בית בטוח לטיפול מיידי - חלופת אשפוז' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral', 'mod_rehab_worker']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '39|||בית בטוח לטיפול מיידי - חלופת אשפוז');

-- Row 42: שרן רפואה עד הבית. 4 field(s), eligibility.
--   להוסיף קהל יעד (משוחררים באישור אגף השיקום), לציין שהשירות חינמי, ולהוסיף שעות מענה בוואטסאפ.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"חיילים וחיילות משוחררים, בהפניה ובאישור אגף השיקום","cost":"חינם, בהפניה ובאישור אגף השיקום","region":"כל הארץ (מקוון)","notes":"ייעוץ פסיכיאטרי בשיחת וידאו עם פסיכיאטר מומחה: מפגש הערכה ראשוני וטיפולי מעקב, בשיתוף אגף השיקום. השירות ניתן בהפניה ובאישור האגף. מענה בוואטסאפ בימים א׳-ה׳ 10:00-16:00."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"recognition":{"btl":"any","mod":"required","moh":"any","rehab_basket":"any"}}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://sharanmedical.co.il/online-psychiatric-consultation-for-idf/. עודכנו: target, cost, region, notes. התאמה: recognition.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '42|||ייעוץ פסיכיאטרי מקוון'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'cost', '') = 'זכאי משרד הבטחון'
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'ייעוץ וטיפולי מעקב בוידאו לחיילים משוחררים באישור אגף השיקום.';

-- Row 44: שרן רפואה עד הבית. Merged into row 43 and removed from the catalogue in index.html.
DELETE FROM directory_card_edits WHERE card_key = '44|||אשפוז בית פסיכיאטרי';

-- Row 60: עמותת בית חם. 4 field(s).
--   להוסיף קהל יעד (מתמודדים ובני משפחה) ולהעביר את המילה "כללי" משדה הטלפון לתווית.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"מתמודדים עם אתגרים בתחום הנפש ובני משפחותיהם","phone":"1599-510-550","phoneLabel":"כללי","notes":"עמותת \"בית חם\" הוקמה במטרה להעניק למתמודדים עם אתגרים בתחום הנפש את התמיכה הטובה ביותר. ראו גם [עמותת בית חם](https://nefesh-il.org/emergency?entry=61&section=helplines)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.bayit-cham.org.il/. עודכנו: target, phone, phoneLabel, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '60|||מידע, ייעוץ ותמיכה
מרכזי טיפול
מרכזי שיקום'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'phone', '') = 'כללי: 1599-510-550'
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'עמותת "בית חם" הוקמה במטרה להעניק למתמודדים עם אתגרים בתחום הנפש את התמיכה הטובה ביותר';

-- Row 61: עמותת בית חם. 6 field(s).
--   לנקות את שדה הטלפון (*9518 עם התווית "מוקד קשובים"), להוסיף את המספר המלא, קהל יעד, מייל, ואת הקווים לגברים ולנשים.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"*9518","phoneLabel":"מוקד קשובים","phone2":"1599-510-550","target":"אנשים שחווים קושי נפשי, לתקופה או באופן נקודתי","email":"tmicha@bch.org.il","notes":"מענה דיסקרטי מאנשי מקצוע בתחום בריאות הנפש. קו לגברים \"אוזן קשבת\" וקו לנשים \"מלב אל לב\"."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.bayit-cham.org.il/%d7%a7%d7%95%d7%95%d7%99-%d7%99%d7%99%d7%a2%d7%95%d7%a5-%d7%a7%d7%a9%d7%95%D7%91%D7%99%D7%9D/. עודכנו: phone, phoneLabel, phone2, target, email, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '61|||מידע, ייעוץ ותמיכה'
  AND COALESCE(public_fields->>'phone', '') = 'מוקד ''קשובים'' 9518*'
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'phone2', '') = ''
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '61|||מידע, ייעוץ ותמיכה');

-- Row 63: הדספייס. 5 field(s), 2 pin(s), eligibility.
--   להוסיף מגבלת גיל 10-25, לפרט את הערים במקום "ערים שונות", לדייק עלות (חלק בהתחייבות קופה), ולהוסיף כתובות לארבעה מרכזים.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"region":"בת ים, ירושלים, קריית שמונה, נתיבות, אשדוד, באר שבע, הקריות, תל אביב-יפו, וגם אונליין","cost":"ללא תשלום ישיר (בחלק מהמרכזים בהתחייבות קופת חולים, טופס 17)","phoneLabel":"מוקד ארצי, א-ה 9:00-17:00","email":"info@headspace.org.il","notes":"נוער וצעירים בגילאי 10-25, הצוות המקצועי שלנו ישמח לעזור לכם להתמודד עם תקופות מאתגרות בחיים בהתערבות רגשית ממוקדת וללא עלות. לא צריך טפסים או הפניה. הדספייס אינו מוקד חירום."}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"הדספייס בת ים","address":"רוטשילד 29, קומה 3, בת ים","lat":32.0266093,"lng":34.743949,"phone":"03-5040900","email":"","sort_order":0},{"label":"הדספייס נתיבות","address":"שדרות ירושלים 18, קומה 1, נתיבות","lat":31.4240677,"lng":34.5980209,"phone":"054-9709753","email":"","sort_order":1}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"age_min":10,"age_max":25,"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://headspace.org.il/ , https://headspace.org.il/%D7%A6%D7%95%D7%A8-%D7%A7%D7%A9%D7%A8/ , https://headspace.org.il/bat-yam/ , https://headspace.org.il/jerusalem/ , https://www.enosh.org.il/%D7%94%D7%93-%D7%A1%D7%A4%D7%99%D7%99%D7%A1/. עודכנו: region, cost, phoneLabel, email, notes. התאמה: age_min, age_max, location_mode. סיכות: רוטשילד 29, קומה 3, בת ים; שדרות ירושלים 18, קומה 1, נתיבות.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '63|||תמיכה לנוער וצעירים'
  AND COALESCE(public_fields->>'region', '') = 'ערים שונות'
  AND COALESCE(public_fields->>'cost', '') = 'חינם'
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'נוער וצעירים בגילאי 10-25, הצוות המקצועי שלנו ישמח לעזור לכם להתמודד עם תקופות מאתגרות בחיים בהתערבות רגשית ממוקדת וללא עלות.';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('הדספייס בת ים', 'רוטשילד 29, קומה 3, בת ים', 32.0266093, 34.743949, 0),
  ('הדספייס נתיבות', 'שדרות ירושלים 18, קומה 1, נתיבות', 31.4240677, 34.5980209, 1)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '63|||תמיכה לנוער וצעירים' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral', 'hmo_form17']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '63|||תמיכה לנוער וצעירים');

-- Row 76: Avnei Chein. 3 field(s).
--   לתקן את מספר הטלפון ל-058-613-6000 ולהוסיף קהל יעד (אנשים במשבר נפשי ומשפחותיהם).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"058-613-6000","target":"People in a mental health crisis and their families","notes":"Crisis support team reachable day or night; helps families navigate welfare, mental health and legal systems. US toll-free: 1-855-928-4437. ראו גם [Avnei Chein](https://nefesh-il.org/emergency?entry=77&section=emergency)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.avneichein.org/services/ , https://www.avneichein.org/emergency-mental-health-resources/. עודכנו: phone, target, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '76|||Crisis Support, Family Support, Family & Sibling Therapy, Legal Support, Mentors and Volunteers, Network of Professionals'
  AND COALESCE(public_fields->>'phone', '') = '058-613-6300'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '76|||Crisis Support, Family Support, Family & Sibling Therapy, Legal Support, Mentors and Volunteers, Network of Professionals');

-- Row 77: Avnei Chein. 1 field(s).
--   להוסיף בהערות שהרשימה נאספה מפרסומים ברשת ולא נבדקה על ידי הארגון (כך כתוב בעמוד עצמו).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"English-language list of emergency mental health resources, compiled by Avnei Chein from public and social-media postings. Avnei Chein states the listings have not been vetted or verified. ראו גם [Avnei Chein](https://nefesh-il.org/emergency?entry=76&section=helplines)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.avneichein.org/emergency-mental-health-resources/. עודכנו: notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '77|||Israel''s Emergency Mental Health Resources During War - Comprehensive list of mental health resources'
  AND COALESCE(public_fields->>'notes', '') = 'Comprehensive English-language directory of emergency mental health resources';

-- Row 200: איגוד מרכזי הסיוע לנפגעות ולנפגעי תקיפה מינית. 1 field(s).
--   להוסיף בהערות את קו הסיוע לחברה הערבית 04-6566813.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"סיוע לחברה הערבית: 04-6566813, וצ׳אט בערבית באתר chatwavo.org. ראו גם [תאיר – מרכז הסיוע לנפגעות ולנפגעי תקיפה מינית](https://nefesh-il.org/treatment?entry=201&section=trauma)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://1202.org.il/. עודכנו: notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '200|||קווי המענה הארציים של ארגון הגג למרכזי הסיוע'
  AND COALESCE(public_fields->>'notes', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '200|||קווי המענה הארציים של ארגון הגג למרכזי הסיוע');

-- Row 214: יחידה לתגובות קרב (צה"ל). 5 field(s), 1 pin(s), eligibility.
--   לתקן שהיחידה מופעלת על ידי אגף השיקום ומיועדת לחיילים משוחררים (לא בשירות פעיל), ולהוסיף קישור, כתובת והערה שאין צורך בהכרה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"היחידה לתגובות קרב (אגף השיקום, משרד הביטחון)","svc":"טיפול נפשי לחיילים משוחררים (סדיר ומילואים) בעקבות לחימה","target":"חיילים משוחררים מסדיר ומילואים, הסובלים ממצוקה בעקבות לחימה או פעילות מבצעית","web":"https://shikum.mod.gov.il/ContactUs/CombatResponse","notes":"טיפול פרטני, זוגי וקבוצתי, ממוקד טראומה. ללא תשלום, בלי צורך בהכרה בנכות, ובלי מגבלת זמן מאז אירוע הלחימה. אפשר לפנות גם בטופס מקוון. אפעל 6, פתח תקווה. חיילים בשירות פעיל: [מערך בריאות הנפש בצה״ל](https://nefesh-il.org/support?entry=10&section=emergency)."}'::jsonb,
    sites = COALESCE(sites, '[]'::jsonb) || '[{"label":"היחידה לתגובות קרב","address":"אפעל 6, פתח תקווה","lat":32.0941265,"lng":34.8472033,"phone":"03-6401400","email":"","sort_order":0}]'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"location_mode":"sites"}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://shikum.mod.gov.il/ContactUs/CombatResponse , https://www.miluim.idf.il/articles-list/%D7%94%D7%99%D7%97%D7%99%D7%93%D7%94-%D7%9C%D7%AA%D7%92%D7%95%D7%91%D7%95%D7%AA-%D7%A7%D7%A8%D7%91. עודכנו: org, svc, target, web, notes. התאמה: location_mode. סיכות: אפעל 6, פתח תקווה.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '214|||סיוע נפשי לחיילים ומילואים'
  AND COALESCE(public_fields->>'org', '') = 'יחידה לתגובות קרב (צה"ל)'
  AND COALESCE(public_fields->>'svc', '') = 'סיוע נפשי לחיילים ומילואים'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'web', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c, (VALUES
  ('היחידה לתגובות קרב', 'אפעל 6, פתח תקווה', 32.0941265, 34.8472033, 0)
) AS v(label, address, lat, lng, sort_order)
WHERE c.card_key = '214|||סיוע נפשי לחיילים ומילואים' AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

-- Row 216: ל"נט. Merged into row 21 and removed from the catalogue in index.html.
DELETE FROM directory_card_edits WHERE card_key = '216|||עד 12 מפגשים טיפוליים פרטניים ללא עלות';

-- Row 218: אגף השיקום — טיפולים רגשיים במימון. 3 field(s), eligibility.
--   להוסיף את תנאי הזכאות (20% נכות או בתהליך הכרה עם אישור), להסיר את "חרבות ברזל" מהשם כי זו זכות קבועה, ולהסביר איך מקבלים התחייבות.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"נכי צה״ל וכוחות הביטחון עם 20% נכות ומעלה (או 10% ומעלה אם הפגיעה הוכרה עד 1995), ומי שבתהליך הכרה וקיבלו אישור לטיפול רפואי","svc":"טיפולים נפשיים במימון אגף השיקום","notes":"טיפול פרטני, זוגי, משפחתי או קבוצתי אצל מטפלים שעובדים עם אגף השיקום, והאגף משלם ישירות למטפל. כדי לקבל התחייבות פונים לעובדת השיקום במחוז. גם מופיע בכרטיס [זכויות שיקום](https://nefesh-il.org/support?entry=12&section=portals)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{"recognition":{"btl":"any","mod":"required","moh":"any","rehab_basket":"any"}}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://shikum.mod.gov.il/medical/treatment/therapy. עודכנו: target, svc, notes. התאמה: recognition.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '218|||טיפולים נפשיים מסובסדים ע"י משרד הביטחון (חרבות ברזל)'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'svc', '') = 'טיפולים נפשיים מסובסדים ע"י משרד הביטחון (חרבות ברזל)'
  AND COALESCE(public_fields->>'notes', '') = 'גם מופיע בכרטיס [זכויות שיקום](https://nefesh-il.org/rights?entry=12&section=rights).';

-- Row 223: מרכז עד קשר. 6 field(s).
--   לתקן את השם ל"קשר עד" ואת הטלפון ל-1111 שלוחה 6 (ולא *6690), ולהוסיף מייל וקהל יעד.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"מרכז \"קשר עד\" (מערך הנפגעים, צה״ל)","phone":"1111","phoneLabel":"מוקד צה״ל, שלוחה 6","email":"kesherad@digital.idf.il","target":"משפחות שכולות, פצועים ונכי צה״ל, מי שנפגעו נפשית בעקבות השירות, ובני משפחותיהם","notes":"מוקד השירות של צה״ל 1111, שלוחה 6. מידע, ליווי ומיצוי זכויות, כולל סיוע בהגשת בקשה להכרה באגף השיקום. לסיוע נפשי דחוף לחיילים: [מערך בריאות הנפש בצה״ל](https://nefesh-il.org/support?entry=10&section=emergency)."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.idf.il/%D7%90%D7%AA%D7%A8%D7%99-%D7%99%D7%97%D7%99%D7%93%D7%95%D7%AA/%D7%9E%D7%A2%D7%A8%D7%9A-%D7%94%D7%A0%D7%A4%D7%92%D7%A2%D7%99%D7%9D/%D7%9E%D7%A8%D7%9B%D7%96-%D7%A7%D7%A9%D7%A8-%D7%A2%D7%93/. עודכנו: org, phone, phoneLabel, email, target, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '223|||סיוע מקצועי לנפגעים בצה"ל ולבני משפחותיהם'
  AND COALESCE(public_fields->>'org', '') = 'מרכז עד קשר'
  AND COALESCE(public_fields->>'phone', '') = '*6690'
  AND COALESCE(public_fields->>'phoneLabel', '') = 'מערך בריאות הנפש'
  AND COALESCE(public_fields->>'email', '') = ''
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'שלוחה 1111.';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '223|||סיוע מקצועי לנפגעים בצה"ל ולבני משפחותיהם');

-- Row 224: מטפלים באהבה. 3 field(s).
--   לתקן שההחזר הוא 1,500 ₪ לכל 10 המפגשים (ולא למפגש) ושהוא מהצבא, ולשנות את דרך ההפניה לפנייה ישירה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"notes":"מטפלים שמציעים 10 מפגשים בסכום שתואם להחזר מהצבא (1,500 ₪ לכל 10 המפגשים), כך שהטיפול מכוסה במלואו בהחזר. רשימת המטפלים בקישור; לבירורים: זהר.","cost":"מכוסה בהחזר מהצבא (1,500 ₪ ל-10 מפגשים)","target":"חיילים ואנשי מילואים"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.mvhr.org.il/%D7%9E%D7%A2%D7%A0%D7%99%D7%9D-%D7%98%D7%99%D7%A4%D7%95%D7%9C%D7%99%D7%99%D7%9D/ , https://www.neshot-miluim-keva.com/%D7%98%D7%99%D7%A4%D7%95%D7%9C-%D7%A8%D7%92%D7%A9%D7%99. עודכנו: notes, cost, target.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '224|||רשת מטפלים מוסמכים לחיילים ומילואים — עד 10 מפגשים מסובסדים'
  AND COALESCE(public_fields->>'notes', '') = 'החזר משרד הביטחון עד תקרת 1500 ₪ למפגש.'
  AND COALESCE(public_fields->>'cost', '') = 'מסובסד'
  AND COALESCE(public_fields->>'target', '') = '';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '224|||רשת מטפלים מוסמכים לחיילים ומילואים — עד 10 מפגשים מסובסדים');

-- Row 225: אור כי יהל. 5 field(s).
--   לתקן את שם השירות ("גזית" הוא שם המשפחה של סרן יהל גזית ז״ל, לא יחידה) לחיילי חטיבת ברק 188, ולהוסיף קהל יעד, קישור להרשמה ומשך הטיפול.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"svc":"טיפול נפשי ללא תשלום לחיילי חטיבת ברק (188)","org":"אור כי יהל (עמותת ברק, חטיבה 188)","target":"חיילי חטיבה 188 בשירות סדיר, בשנת הקבע הראשונה או בשנה הראשונה אחרי השחרור","web":"https://barak-188.com/%D7%9E%D7%99%D7%96%D7%9D-%D7%90%D7%95%D7%A8-%D7%9B%D7%99-%D7%99%D7%94%D7%9C/","notes":"מיזם לזכר סרן יהל גזית ז״ל. טיפול ללא תשלום למשך שנה, בתיאום עם [מערך בריאות הנפש בצה״ל](https://nefesh-il.org/support?entry=10&section=emergency). מי שמתמודדים עם פוסט טראומה, אובדנות או מצבי קיצון ממשיכים לקבל סיוע מהקב״ן. הרשמה בטופס באתר."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://barak-188.com/%D7%9E%D7%99%D7%96%D7%9D-%D7%90%D7%95%D7%A8-%D7%9B%D7%99-%D7%99%D7%94%D7%9C/ , https://www.mvhr.org.il/%D7%9E%D7%A2%D7%A0%D7%99%D7%9D-%D7%98%D7%99%D7%A4%D7%95%D7%9C%D7%99%D7%99%D7%9D/. עודכנו: svc, org, target, web, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '225|||טיפול נפשי ללוחמי גזית/שריון (חטיבה 188) — ללא תשלום'
  AND COALESCE(public_fields->>'svc', '') = 'טיפול נפשי ללוחמי גזית/שריון (חטיבה 188) — ללא תשלום'
  AND COALESCE(public_fields->>'org', '') = 'אור כי יהל'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'web', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'בתיאום עם מערך בריאות הנפש בצה"ל.';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '225|||טיפול נפשי ללוחמי גזית/שריון (חטיבה 188) — ללא תשלום');

-- Row 236: מוקד 118 (משרד הרווחה). 3 field(s).
--   להוסיף קהל יעד ושפות מענה, ולהשלים בהערות שהמוקד סגור ביום כיפור ושיש קו 1218 לגברים נפגעי אלימות במשפחה.
UPDATE directory_card_edits
SET public_fields = public_fields || '{"target":"כל מי שזקוק למידע וסיוע בנושאי רווחה: ילדים ונוער בסיכון, נפגעי אלימות במשפחה, אזרחים ותיקים, אנשים עם מוגבלות ומשפחות בקשיים","languages":"עברית, ערבית, אמהרית, רוסית, אנגלית, צרפתית","notes":"פועל 24/7 כל השנה, חוץ מיום כיפור. אפשר גם 077-9208560, או הודעת טקסט (פנייה שקטה) ל-050-2270118. גברים נפגעי אלימות במשפחה: 1218."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.kolzchut.org.il/he/%D7%9E%D7%95%D7%A7%D7%93_%D7%9E%D7%A9%D7%A8%D7%93_%D7%94%D7%A8%D7%95%D7%95%D7%97%D7%94 , https://www.gov.il/ar/pages/molsa-domestic-violence-protection , https://help.unhcr.org/israel/for-ukrainians/organizations-assisting-refugees-and-asylum-seekers/. עודכנו: target, languages, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '236|||מידע, סיוע והכוונה — 24/7'
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'languages', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'גם 077-9208560 · SMS 050-2270118 · אלימות במשפחה חינם';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '236|||מידע, סיוע והכוונה — 24/7');

-- Row 267: מוקד 105 — המטה הלאומי להגנה על ילדים ברשת. 3 field(s).
--   להוסיף את קו הוואטסאפ הרשמי של מוקד 105 (052-1210105, 24/7).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"whatsapp":"972521210105","whatsappLabel":"וואטסאפ 24/7","notes":"מענה משולב אזרחי-משטרתי בעברית, ערבית ואנגלית. אפשר לפנות 24/7 גם בוואטסאפ 052-1210105 ובטופס מקוון."}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.gov.il/he/departments/units/105_unit , https://www.gov.il/en/pages/whatsapp_105 , https://pop.education.gov.il/hodaot/hadash-bamerchav/moked105/. עודכנו: whatsapp, whatsappLabel, notes.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '267|||דיווח ומענה 24/7 על פגיעות, בריונות, סחיטה ופשיעה נגד ילדים ונוער במרחב המקוון'
  AND COALESCE(public_fields->>'whatsapp', '') = ''
  AND COALESCE(public_fields->>'whatsappLabel', '') = ''
  AND COALESCE(public_fields->>'notes', '') = 'מענה משולב אזרחי-משטרתי בעברית, ערבית ואנגלית';

UPDATE directory_entries
SET referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = (SELECT entry_id FROM directory_card_edits WHERE card_key = '267|||דיווח ומענה 24/7 על פגיעות, בריונות, סחיטה ופשיעה נגד ילדים ונוער במרחב המקוון');

-- Row 281: האגודה לבריאות הציבור. 3 field(s).
--   להוסיף שעות מענה לטלפון הראשי ואת מספר המוקד מחוץ לשעות (077-900-2283).
UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"מענה אנושי 8:00-15:00","phone2":"077-900-2283","phoneLabel2":"מוקד מחוץ לשעות המענה"}'::jsonb,
    eligibility = (COALESCE(eligibility, '{}'::jsonb) || '{}'::jsonb) || jsonb_build_object('internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '16.10.2026: סקירת כרטיסים, נבדק מול https://www.aguda.co.il/service-categories/%d7%a9%d7%99%d7%a7%d7%95%d7%9d-%d7%9c%d7%a0%d7%9b%d7%99-%d7%a6%d7%94%d7%9c-%d7%95%d7%a0%d7%a4%d7%92%d7%a2%d7%99-%d7%a4%d7%a2%d7%95%d7%9c%d7%95%d7%aa-%d7%90%d7%99%d7%91%d7%94/. עודכנו: phoneLabel, phone2, phoneLabel2.', E'\n ')),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '281|||שיקום לנכי צה"ל ונפגעי פעולות איבה — מרכז החממה ותכנית תושייה למשפחות הלומי קרב'
  AND COALESCE(public_fields->>'phoneLabel', '') = ''
  AND COALESCE(public_fields->>'phone2', '') = ''
  AND COALESCE(public_fields->>'phoneLabel2', '') = '';

COMMIT;
