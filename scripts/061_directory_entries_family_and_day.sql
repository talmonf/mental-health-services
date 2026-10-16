-- Migration 061 (16 Oct 2026)
-- Family counseling list, psychiatric day treatment from the October 2026 workbook,
-- and sexual-trauma units at Shaar Menashe, Lev Hasharon, and Ichilov Magen.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES
  (
    'מרכזי_ייעוץ_למשפחות_308',
    'מרכזי ייעוץ למשפחות',
    'רשימת מרכזי הייעוץ למשפחות בקהילה ובבתי החולים',
    'families',
    ARRAY['families']::text[],
    ARRAY['self_referral']::text[]
  ),
  (
    'כפר_שאול_אשפוז_יום_309',
    'כפר שאול — אשפוז יום',
    'אשפוז יום אחרי אשפוז מלא — הדרך שלך חזרה לקהילה',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['unknown']::text[]
  ),
  (
    'לוטוס_כפר_שאול_310',
    'לוטוס (כפר שאול)',
    'טיפול יום לנשים עם טראומה מורכבת אחרי פגיעה מינית',
    'day_care',
    ARRAY['day_care', 'trauma']::text[],
    ARRAY['hmo_form17', 'psychiatrist_referral']::text[]
  ),
  (
    'קפלן_טיפול_יום_פסיכיאטרי_311',
    'קפלן — טיפול יום פסיכיאטרי',
    'מחלקת טיפול יום, כחודש וחצי בממוצע',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['hmo_form17']::text[]
  ),
  (
    'גהה_מחלקה_ח_312',
    'גהה — מחלקה ח׳',
    'טיפול יום למבוגרים',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['psychiatrist_referral', 'hmo_form17']::text[]
  ),
  (
    'חופים_איכילוב_313',
    'חופים (איכילוב)',
    'מחלקה לטיפול יום פסיכיאטרי לילדים ולנוער',
    'day_care',
    ARRAY['day_care', 'youth']::text[],
    ARRAY['unknown']::text[]
  ),
  (
    'הדסה_טיפול_יום_ואשפוז_יום_314',
    'הדסה — טיפול יום ואשפוז יום',
    'טיפול יום לקטינים באתיופיה, ואשפוז יום בעין כרם',
    'day_care',
    ARRAY['day_care', 'youth']::text[],
    ARRAY['unknown']::text[]
  ),
  (
    'ברזילי_טיפול_יום_315',
    'ברזילי — טיפול יום',
    'טיפול יום ואשפוז יום למבוגרים, וטיפול יום לקטינים בבית ספר שקד',
    'day_care',
    ARRAY['day_care', 'youth']::text[],
    ARRAY['unknown']::text[]
  ),
  (
    'זיו_טיפול_יום_316',
    'זיו — טיפול יום',
    'טיפול יום ואשפוז יום',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['unknown']::text[]
  ),
  (
    'מזרע_טיפול_יום_317',
    'מזרע — טיפול יום',
    'טיפול יום למבוגרים',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['unknown']::text[]
  ),
  (
    'העמק_טיפול_יום_318',
    'העמק — טיפול יום',
    'טיפול יום ואשפוז יום למבוגרים',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['unknown']::text[]
  ),
  (
    'האנגלי_בנצרת_אשפוז_יום_319',
    'האנגלי בנצרת — אשפוז יום',
    'אשפוז יום למבוגרים',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['unknown']::text[]
  ),
  (
    'נהריה_אשפוז_יום_320',
    'נהריה — אשפוז יום',
    'אשפוז יום לקטינים',
    'day_care',
    ARRAY['day_care', 'youth']::text[],
    ARRAY['unknown']::text[]
  ),
  (
    'באר_שבע_טיפול_יום_321',
    'באר שבע — טיפול יום',
    'טיפול יום למבוגרים במרכז לבריאות הנפש',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['unknown']::text[]
  ),
  (
    'סורוקה_טיפול_יום_322',
    'סורוקה — טיפול יום',
    'טיפול יום למבוגרים',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['unknown']::text[]
  ),
  (
    'באר_יעקב_טיפול_יום_323',
    'באר יעקב — טיפול יום',
    'טיפול יום למבוגרים',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['unknown']::text[]
  ),
  (
    'שלוותה_טיפול_יום_324',
    'שלוותה — טיפול יום',
    'טיפול יום למבוגרים ואשפוז יום',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['unknown']::text[]
  ),
  (
    'שניידר_אשפוז_יום_325',
    'שניידר — אשפוז יום',
    'אשפוז יום לקטינים',
    'day_care',
    ARRAY['day_care', 'youth']::text[],
    ARRAY['unknown']::text[]
  ),
  (
    'אברבנאל_טיפול_יום_326',
    'אברבנאל — טיפול יום',
    'טיפול יום למבוגרים',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['unknown']::text[]
  ),
  (
    'בארי_טיפול_יום_327',
    'בארי — טיפול יום',
    'טיפול יום למבוגרים של כללית',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['unknown']::text[]
  ),
  (
    'שיבא_אשפוז_יום_328',
    'שיבא — אשפוז יום',
    'אשפוז יום במחלקת ילדים',
    'day_care',
    ARRAY['day_care', 'youth']::text[],
    ARRAY['unknown']::text[]
  ),
  (
    'בית_דניאלה_329',
    'בית דניאלה',
    'טיפול יום לנוער, בשיבולים ובצור הדסה',
    'day_care',
    ARRAY['day_care', 'youth']::text[],
    ARRAY['hmo_form17']::text[]
  ),
  (
    'איזון_נפש_330',
    'איזון נפש',
    'טיפול יום באבן יהודה וביבנה',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['hmo_form17']::text[]
  ),
  (
    'קידום_השביל_חולון_331',
    'קידום השביל (חולון)',
    'טיפול יום לנשים אחרי בית מאזן להפרעות אכילה',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['hmo_form17']::text[]
  ),
  (
    'מסאחה_חמרה_332',
    'מסאחה (חמרה)',
    'טיפול יום למבוגרים',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['hmo_form17']::text[]
  ),
  (
    'גשר_לתקווה_כרמיאל_333',
    'גשר לתקווה (כרמיאל)',
    'טיפול יום למבוגרים עם הפרעות אכילה',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['hmo_form17']::text[]
  ),
  (
    'רגעים_מגדל_העמק_334',
    'רגעים (מגדל העמק)',
    'טיפול יום למבוגרים',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['hmo_form17']::text[]
  ),
  (
    'אופק_רם_עכו_335',
    'אופק רם (עכו)',
    'טיפול יום למבוגרים',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['hmo_form17']::text[]
  ),
  (
    'מעיין_הנפש_קריית_אתא_336',
    'מעיין הנפש (קריית אתא)',
    'טיפול יום למבוגרים',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['hmo_form17']::text[]
  ),
  (
    'קרני_שמש_337',
    'קרני שמש',
    'טיפול יום לילדים ולנוער',
    'day_care',
    ARRAY['day_care', 'youth']::text[],
    ARRAY['hmo_form17']::text[]
  ),
  (
    'מרפאת_עירון_שער_מנשה_338',
    'מרפאת עירון (שער מנשה)',
    'מרפאת חוץ לבריאות הנפש, ליד שער בית החולים',
    'mh_clinics',
    ARRAY['mh_clinics']::text[],
    ARRAY['gp_referral']::text[]
  ),
  (
    'שער_מנשה_אשפוז_יום_339',
    'שער מנשה — אשפוז יום',
    'מחלקת אשפוז יום לטיפול אינטנסיבי או אחרי אשפוז מלא',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['psychiatrist_referral']::text[]
  ),
  (
    'שער_מנשה_טראומה_מינית_340',
    'שער מנשה — טראומה מינית',
    'אשפוז ממוקד, מרפאה וטיפול יום לנפגעי ולנפגעות טראומה מינית',
    'hospitalization',
    ARRAY['hospitalization', 'day_care', 'trauma']::text[],
    ARRAY['psychiatrist_referral', 'hmo_form17']::text[]
  ),
  (
    'לב_השרון_טראומה_מינית_341',
    'לב השרון — טראומה מינית',
    'אשפוז ממוקד ל-16 יום, וטיפול יום במרכז עוגן',
    'hospitalization',
    ARRAY['hospitalization', 'day_care', 'trauma']::text[],
    ARRAY['hmo_form17']::text[]
  ),
  (
    'מגן_איכילוב_342',
    'מגן (איכילוב)',
    'יחידת אשפוז לנשים אחרי פגיעה מינית',
    'hospitalization',
    ARRAY['hospitalization', 'trauma']::text[],
    ARRAY['psychiatrist_referral']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES
(
  '308|||רשימת מרכזי הייעוץ למשפחות בקהילה ובבתי החולים',
  308,
  'מרכזי_ייעוץ_למשפחות_308',
  '{"org":"מרכזי ייעוץ למשפחות","svc":"רשימת מרכזי הייעוץ למשפחות בקהילה ובבתי החולים","target":"בני משפחה של מתמודדי נפש","region":"כל הארץ","cost":"חינם, בלי אישור סל שיקום","specialty":"","languages":"","diseases":"","notes":"השירות חינם וללא אישור מוקדם של סל שיקום. הרשימה הרשמית כוללת מרכזים בקהילה ובבתי חולים.\n\nבקהילה, בין השאר: [מילם](https://nefesh-il.org/support?entry=52&section=families), [יה״ל](https://nefesh-il.org/support?entry=66&section=families) ו[עוגן בעזר מציון](https://nefesh-il.org/rights?entry=305&section=rehabilitation). ברשימה גם סראי סראב, תכלת בית חם ומעגלים (קידום).\n\nבבתי חולים: כפר שאול 02-6551576, באר שבע 08-6401516, אברבנאל 03-5552733, שיבא 03-5308415, מעייני הישועה 073-3398099, באר יעקב 08-9258339, שלוותה 09-7470375, גהה 03-9258223, לב השרון 09-8981278, מזור 04-9559640, שער מנשה 04-6278888.\n\nבשער מנשה, [מרפאת עירון](https://nefesh-il.org/treatment?entry=338&section=mh_clinics), [אשפוז היום](https://nefesh-il.org/treatment?entry=339&section=day_care) ו[המערך לטראומה מינית](https://nefesh-il.org/treatment?entry=340&section=hospitalization) הם כרטיסים נפרדים.","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.gov.il/he/departments/dynamiccollectors/smtl-families-center","webLabel":"רשימת המרכזים","web2":"https://me.health.gov.il/mental-health/therapy-rehabilitation/rehabilitation/rehabilitation-basket/family-counseling-centers/","webLabel2":"משרד הבריאות","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. מאגר data.gov.il mtl-families-centers, עודכן 15.10.2026, 45 רשומות. כמעט בלי רחוב, ולכן בלי סיכות. לא פורסמו 07-47139999 (סראי סראב ירושלים) ו-05-35920445 (רהט). שער מנשה בלי עיר במאגר, טלפון 04-6278888. מספר בני ברק במאגר 073-3956218; בכרטיס 305 נשאר 073-3956128 לפי דיווח צוות מ-15.10.2026."}'::jsonb,
  '[]'::jsonb
),
(
  '309|||אשפוז יום אחרי אשפוז מלא — הדרך שלך חזרה לקהילה',
  309,
  'כפר_שאול_אשפוז_יום_309',
  '{"org":"כפר שאול — אשפוז יום","svc":"אשפוז יום אחרי אשפוז מלא — הדרך שלך חזרה לקהילה","target":"מגיל 18, לרוב אחרי אשפוז מלא","region":"כפר שאול, ירושלים","cost":"","specialty":"","languages":"","diseases":"","notes":"א׳–ה׳ 08:30–15:00, כ־25 מטופלים. הדף אינו מציין טופס 17 או קופת חולים, ואינו נותן רחוב. נפרד מ[מעון ירושלים](https://nefesh-il.org/treatment?entry=297&section=day_care).","tags":"","whatsapp":"","whatsappLabel":"","web":"https://psjer.org.il/clinics/%d7%90%d7%a9%d7%a4%d7%95%d7%96-%d7%99%d7%95%d7%9d/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","email":"mariel.goldberg@moh.gov.il","emailLabel":"","emailShowAddress":false,"email2":"tsafrir.L@moh.gov.il","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"02-6551303","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. נבדק מול דף אשפוז יום באתר המרכז הירושלמי. הסיכה היא קמפוס כפר שאול שכבר במדריך."}'::jsonb,
  '[{"label":"כפר שאול","address":"המרכז הירושלמי לבריאות הנפש, כפר שאול","lat":31.786614,"lng":35.177992,"phone":"02-6551303","email":"mariel.goldberg@moh.gov.il","sort_order":0}]'::jsonb
),
(
  '310|||טיפול יום לנשים עם טראומה מורכבת אחרי פגיעה מינית',
  310,
  'לוטוס_כפר_שאול_310',
  '{"org":"לוטוס (כפר שאול)","svc":"טיפול יום לנשים עם טראומה מורכבת אחרי פגיעה מינית","target":"נשים עם טראומה מורכבת על רקע פגיעה מינית","region":"כפר שאול, ירושלים","cost":"טופס 17, קוד L0771, לאינטייק","specialty":"טראומה מינית","languages":"","diseases":"","notes":"16 שבועות, א׳ ב׳ ו־ד׳ 08:00–15:00. נדרשים טיפול רציף בקהילה, בלי אובדנות פעילה, מוטיבציה לצמצם פגיעה עצמית, ומגורים יציבים. אחראית: מירב אחימן-מלכין. פניות: אפרת אינדורסקי. זה טיפול יום, לא אשפוז.","tags":"","whatsapp":"","whatsappLabel":"","web":"https://psjer.org.il/clinics/%d7%9c%d7%95%d7%98%d7%95%d7%a1/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","email":"Lotus@moh.gov.il","emailLabel":"","emailShowAddress":false,"email2":"merav.achiman@moh.gov.il","emailLabel2":"אחראית","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"02-6551303","phoneLabel":"שלוחה 2790","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"female","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. נבדק מול דף לוטוס באתר המרכז הירושלמי. הדף אינו מציין גיל מינימום."}'::jsonb,
  '[{"label":"כפר שאול","address":"המרכז הירושלמי לבריאות הנפש, כפר שאול","lat":31.786614,"lng":35.177992,"phone":"02-6551303","email":"Lotus@moh.gov.il","sort_order":0}]'::jsonb
),
(
  '311|||מחלקת טיפול יום, כחודש וחצי בממוצע',
  311,
  'קפלן_טיפול_יום_פסיכיאטרי_311',
  '{"org":"קפלן — טיפול יום פסיכיאטרי","svc":"מחלקת טיפול יום, כחודש וחצי בממוצע","target":"מגיל 18 עד 70, ניידים","region":"רחובות","cost":"","specialty":"","languages":"","diseases":"","notes":"כ־20 מטופלים, שהות ממוצעת כחודש וחצי, א׳–ה׳ 08:00–14:30, ביתנים 20 ו־22. הדף אומר שמטופלים מכל הארץ ומכל הקופות. הכותרת אומרת בלי טופס 17, וגוף הדף אומר בכפוף לטופס 17. לאמת מול המחלקה.","tags":"","whatsapp":"","whatsappLabel":"","web":"https://hospitals.clalit.co.il/kaplan/he/med_units/psychiatric_care/Pages/psychiatric_day_care.aspx","webLabel":"","web2":"https://www.mh-israel.co.il/Article/43/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_מרכז","webLabel2":"פורטל בריאות הנפש","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"08-9441670","phoneLabel":"","phoneShowNumber":true,"phone2":"08-9441233","phoneLabel2":"אחיות","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":70,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. הסתירה על טופס 17 היא כפי שתועדה בדף קפלן ב-13.10.2026 בקובץ המקור. לא נפתח מחדש בדפדפן בזמן הכתיבה; הקישור הוא דף המחלקה."}'::jsonb,
  '[{"label":"רחובות","address":"בית חולים קפלן, רחובות","lat":31.87213,"lng":34.81648,"phone":"08-9441670","email":"","sort_order":0}]'::jsonb
),
(
  '312|||טיפול יום למבוגרים',
  312,
  'גהה_מחלקה_ח_312',
  '{"org":"גהה — מחלקה ח׳","svc":"טיפול יום למבוגרים","target":"מגיל 18, מי שמסוגל להגיע מדי יום","region":"פתח תקווה","cost":"","specialty":"","languages":"","diseases":"","notes":"הלסינקי 1, קומה 1־ בבניין האשפוז. אין הגבלה לפי אזור או קופת חולים, בכפוף למקום פנוי. מרכז הייעוץ למשפחות בגהה הוא [כרטיס נפרד](https://nefesh-il.org/support?entry=308&section=families).","tags":"","whatsapp":"","whatsappLabel":"","web":"https://hospitals.clalit.co.il/geha/he/med/mature/Pages/hdept.aspx","webLabel":"","web2":"https://www.mh-israel.co.il/Article/43/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_מרכז","webLabel2":"פורטל בריאות הנפש","add":"","addLabel":"","email":"departmenth@clalit.org.il","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"03-9258258","phoneLabel":"","phoneShowNumber":true,"phone2":"050-6191024","phoneLabel2":"פניות","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. לפי דף מחלקה ח׳ באתר גהה, כפי שנקרא לקובץ המקור ב-13.10.2026. הסיכה: הלסינקי 1, שכבר במדריך."}'::jsonb,
  '[{"label":"פתח תקווה","address":"הלסינקי 1, פתח תקווה","lat":32.089107,"lng":34.864914,"phone":"03-9258258","email":"departmenth@clalit.org.il","sort_order":0}]'::jsonb
),
(
  '313|||מחלקה לטיפול יום פסיכיאטרי לילדים ולנוער',
  313,
  'חופים_איכילוב_313',
  '{"org":"חופים (איכילוב)","svc":"מחלקה לטיפול יום פסיכיאטרי לילדים ולנוער","target":"ילדים ונוער","region":"תל אביב","cost":"","specialty":"ילדים ונוער","languages":"","diseases":"","notes":"אבחון וטיפול נפשי, כולל טיפול תרופתי לפי הצורך. המקור הוא מסמך ההסכמה של איכילוב, לא דף מחלקה. נפרד מ[טיפול היום הנוירופסיכיאטרי](https://nefesh-il.org/treatment?entry=299&section=day_care). טלפון לא מופיע במסמך.","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.tasmc.org.il/media/ggzdwfvx/hascama_div.pdf","webLabel":"מסמך הסכמה","web2":"","webLabel2":"","add":"","addLabel":"","email":"psych-dc@tlvmc.gov.il","emailLabel":"מזכירות","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. שורת חופים בקובץ המקור, סטטוס נבדק בדף המוסד, והקישור הוא PDF. אם המסמך אינו מתאר תכנית פעילה, הכרטיס עדיין מפנה אליו."}'::jsonb,
  '[{"label":"תל אביב","address":"רבקה זיו 3, תל אביב","lat":32.0795029,"lng":34.7867419,"phone":"","email":"psych-dc@tlvmc.gov.il","sort_order":0}]'::jsonb
),
(
  '314|||טיפול יום לקטינים באתיופיה, ואשפוז יום בעין כרם',
  314,
  'הדסה_טיפול_יום_ואשפוז_יום_314',
  '{"org":"הדסה — טיפול יום ואשפוז יום","svc":"טיפול יום לקטינים באתיופיה, ואשפוז יום בעין כרם","target":"קטינים באתיופיה; כל הגילאים בעין כרם","region":"ירושלים","cost":"","specialty":"","languages":"","diseases":"","notes":"הפרטים מפורטל בריאות הנפש, בלי תאריך. לאמת בטלפון. שתי נקודות של הדסה: טיפול יום לקטינים ברחוב אתיופיה 6א, ואשפוז יום בעין כרם.","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.mh-israel.co.il/Article/49/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_ירושלים","webLabel":"פורטל בריאות הנפש","web2":"","webLabel2":"","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"02-6234892","phoneLabel":"אתיופיה · קטינים","phoneShowNumber":true,"phone2":"02-6777183","phoneLabel2":"עין כרם","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. שתי שורות פורטל אוחדו לכרטיס אחד כי שתיהן הדסה."}'::jsonb,
  '[{"label":"אתיופיה","address":"אתיופיה 6, ירושלים","lat":31.7844136,"lng":35.221026,"phone":"02-6234892","email":"","sort_order":0},{"label":"עין כרם","address":"הדסה עין כרם, ירושלים","lat":31.7649565,"lng":35.1500168,"phone":"02-6777183","email":"","sort_order":1}]'::jsonb
),
(
  '315|||טיפול יום ואשפוז יום למבוגרים, וטיפול יום לקטינים בבית ספר שקד',
  315,
  'ברזילי_טיפול_יום_315',
  '{"org":"ברזילי — טיפול יום","svc":"טיפול יום ואשפוז יום למבוגרים, וטיפול יום לקטינים בבית ספר שקד","target":"מבוגרים בבית החולים; קטינים בבית ספר שקד","region":"אשקלון","cost":"","specialty":"","languages":"","diseases":"","notes":"הפרטים מפורטל בריאות הנפש, בלי תאריך. לאמת בטלפון. מבוגרים: טיפול יום ואשפוז יום בברזילי. קטינים: בית ספר שקד, ההסתדרות 3.","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.mh-israel.co.il/Article/40/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_דרום","webLabel":"פורטל בריאות הנפש","web2":"","webLabel2":"","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"08-6745103","phoneLabel":"מבוגרים","phoneShowNumber":true,"phone2":"08-6745510","phoneLabel2":"שקד · קטינים","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. שתי שורות פורטל של ברזילי אוחדו."}'::jsonb,
  '[{"label":"אשקלון","address":"מרכז רפואי ברזילי, אשקלון","lat":31.6620786,"lng":34.5593019,"phone":"08-6745103","email":"","sort_order":0},{"label":"שקד","address":"ההסתדרות 3, אשקלון","lat":31.6558924,"lng":34.5582856,"phone":"08-6745510","email":"","sort_order":1}]'::jsonb
),
(
  '316|||טיפול יום ואשפוז יום',
  316,
  'זיו_טיפול_יום_316',
  '{"org":"זיו — טיפול יום","svc":"טיפול יום ואשפוז יום","target":"כל הגילאים","region":"צפת","cost":"","specialty":"","languages":"","diseases":"","notes":"הפרטים מפורטל בריאות הנפש, בלי תאריך. לאמת בטלפון.","tags":"","whatsapp":"","whatsappLabel":"","web":"http://ziv.org.il","webLabel":"","web2":"https://www.mh-israel.co.il/Article/41/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_צפון","webLabel2":"פורטל בריאות הנפש","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"04-6828475","phoneLabel":"","phoneShowNumber":true,"phone2":"04-6828067","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. פורטל, מחוז צפון."}'::jsonb,
  '[{"label":"צפת","address":"מרכז רפואי זיו, צפת","lat":32.9540333,"lng":35.4925033,"phone":"04-6828475","email":"","sort_order":0}]'::jsonb
),
(
  '317|||טיפול יום למבוגרים',
  317,
  'מזרע_טיפול_יום_317',
  '{"org":"מזרע — טיפול יום","svc":"טיפול יום למבוגרים","target":"מבוגרים","region":"עכו","cost":"","specialty":"","languages":"","diseases":"","notes":"הפרטים מפורטל בריאות הנפש, בלי תאריך. לאמת בטלפון.","tags":"","whatsapp":"","whatsappLabel":"","web":"http://mazra.org.il","webLabel":"","web2":"https://www.mh-israel.co.il/Article/41/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_צפון","webLabel2":"פורטל בריאות הנפש","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"04-9559655","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. פורטל. כתובת טרומפלדור 37, עכו."}'::jsonb,
  '[{"label":"עכו","address":"טרומפלדור 37, עכו","lat":32.9260824,"lng":35.0746226,"phone":"04-9559655","email":"","sort_order":0}]'::jsonb
),
(
  '318|||טיפול יום ואשפוז יום למבוגרים',
  318,
  'העמק_טיפול_יום_318',
  '{"org":"העמק — טיפול יום","svc":"טיפול יום ואשפוז יום למבוגרים","target":"מבוגרים","region":"עפולה","cost":"","specialty":"","languages":"","diseases":"","notes":"הפרטים מפורטל בריאות הנפש, בלי תאריך. לאמת בטלפון. בפורטל השורה מופיעה גם תחת מרכז לטיפול יום של כללית.","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.mh-israel.co.il/Article/41/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_צפון","webLabel":"פורטל בריאות הנפש","web2":"","webLabel2":"","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"04-6426061","phoneLabel":"","phoneShowNumber":true,"phone2":"04-6494351","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. פורטל. שדרות יצחק רבין, עפולה."}'::jsonb,
  '[{"label":"עפולה","address":"בית חולים העמק, עפולה","lat":32.62214,"lng":35.31783,"phone":"04-6426061","email":"","sort_order":0}]'::jsonb
),
(
  '319|||אשפוז יום למבוגרים',
  319,
  'האנגלי_בנצרת_אשפוז_יום_319',
  '{"org":"האנגלי בנצרת — אשפוז יום","svc":"אשפוז יום למבוגרים","target":"מבוגרים","region":"נצרת","cost":"","specialty":"","languages":"","diseases":"","notes":"הפרטים מפורטל בריאות הנפש, בלי תאריך. לאמת בטלפון.","tags":"","whatsapp":"","whatsappLabel":"","web":"http://nazhosp.com","webLabel":"","web2":"https://www.mh-israel.co.il/Article/41/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_צפון","webLabel2":"פורטל בריאות הנפש","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"04-6028817","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. פורטל. הסיכה היא תחנת אוטובוס בשם בית חולים אנגלי, כי בניין בית החולים לא חזר כאובייקט נפרד ב-OSM."}'::jsonb,
  '[{"label":"נצרת","address":"בית החולים האנגלי, נצרת","lat":32.70168,"lng":35.29187,"phone":"04-6028817","email":"","sort_order":0}]'::jsonb
),
(
  '320|||אשפוז יום לקטינים',
  320,
  'נהריה_אשפוז_יום_320',
  '{"org":"נהריה — אשפוז יום","svc":"אשפוז יום לקטינים","target":"קטינים","region":"נהריה","cost":"","specialty":"","languages":"","diseases":"","notes":"הפרטים מפורטל בריאות הנפש, בלי תאריך. לאמת בטלפון.","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.mh-israel.co.il/Article/41/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_צפון","webLabel":"פורטל בריאות הנפש","web2":"","webLabel2":"","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"04-9850494","phoneLabel":"","phoneShowNumber":true,"phone2":"04-9850495","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":17,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. פורטל. בית החולים לגליל."}'::jsonb,
  '[{"label":"נהריה","address":"המרכז הרפואי לגליל, נהריה","lat":33.0100224,"lng":35.1169063,"phone":"04-9850494","email":"","sort_order":0}]'::jsonb
),
(
  '321|||טיפול יום למבוגרים במרכז לבריאות הנפש',
  321,
  'באר_שבע_טיפול_יום_321',
  '{"org":"באר שבע — טיפול יום","svc":"טיפול יום למבוגרים במרכז לבריאות הנפש","target":"מבוגרים","region":"באר שבע","cost":"","specialty":"","languages":"","diseases":"","notes":"הפרטים מפורטל בריאות הנפש, בלי תאריך. לאמת בטלפון.","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.mh-israel.co.il/Article/40/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_דרום","webLabel":"פורטל בריאות הנפש","web2":"","webLabel2":"","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"08-6401697","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. פורטל. הצדיק מירושלים 2."}'::jsonb,
  '[{"label":"באר שבע","address":"הצדיק מירושלים 2, באר שבע","lat":31.2736264,"lng":34.7913423,"phone":"08-6401697","email":"","sort_order":0}]'::jsonb
),
(
  '322|||טיפול יום למבוגרים',
  322,
  'סורוקה_טיפול_יום_322',
  '{"org":"סורוקה — טיפול יום","svc":"טיפול יום למבוגרים","target":"מבוגרים","region":"באר שבע","cost":"","specialty":"","languages":"","diseases":"","notes":"הפרטים מפורטל בריאות הנפש, בלי תאריך. לאמת בטלפון. בפורטל השורה מופיעה גם תחת מרכז לטיפול יום של כללית.","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.mh-israel.co.il/Article/40/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_דרום","webLabel":"פורטל בריאות הנפש","web2":"","webLabel2":"","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"08-6400351","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. פורטל."}'::jsonb,
  '[{"label":"באר שבע","address":"בית חולים סורוקה, באר שבע","lat":31.25821,"lng":34.80093,"phone":"08-6400351","email":"","sort_order":0}]'::jsonb
),
(
  '323|||טיפול יום למבוגרים',
  323,
  'באר_יעקב_טיפול_יום_323',
  '{"org":"באר יעקב — טיפול יום","svc":"טיפול יום למבוגרים","target":"מבוגרים","region":"לוד","cost":"","specialty":"","languages":"","diseases":"","notes":"הפרטים מפורטל בריאות הנפש, בלי תאריך. לאמת בטלפון. השם בפורטל הוא באר יעקב, והכתובת הרשומה היא מודיעין 4 בלוד.","tags":"","whatsapp":"","whatsappLabel":"","web":"http://www.beer-ness.co.il","webLabel":"","web2":"https://www.mh-israel.co.il/Article/43/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_מרכז","webLabel2":"פורטל בריאות הנפש","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"08-9150208","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. פורטל. לא אוחד עם לצידך, שזו מחלקה אחרת."}'::jsonb,
  '[{"label":"לוד","address":"מודיעין 4, לוד","lat":31.9545379,"lng":34.8916536,"phone":"08-9150208","email":"","sort_order":0}]'::jsonb
),
(
  '324|||טיפול יום למבוגרים ואשפוז יום',
  324,
  'שלוותה_טיפול_יום_324',
  '{"org":"שלוותה — טיפול יום","svc":"טיפול יום למבוגרים ואשפוז יום","target":"מבוגרים בטיפול יום; כל הגילאים באשפוז יום","region":"הוד השרון","cost":"","specialty":"","languages":"","diseases":"","notes":"הפרטים מפורטל בריאות הנפש, בלי תאריך. לאמת בטלפון. בפורטל השורה מופיעה גם תחת מרכזי טיפול יום של כללית. מרכז הייעוץ למשפחות בשלוותה הוא [כרטיס נפרד](https://nefesh-il.org/support?entry=308&section=families).","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.mh-israel.co.il/Article/43/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_מרכז","webLabel":"פורטל בריאות הנפש","web2":"","webLabel2":"","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"09-7478555","phoneLabel":"","phoneShowNumber":true,"phone2":"09-7478532","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. פורטל. עליית הנוער 13. הסיכה שכבר במדריך."}'::jsonb,
  '[{"label":"הוד השרון","address":"עליית הנוער 13, הוד השרון","lat":32.15486,"lng":34.898352,"phone":"09-7478555","email":"","sort_order":0}]'::jsonb
),
(
  '325|||אשפוז יום לקטינים',
  325,
  'שניידר_אשפוז_יום_325',
  '{"org":"שניידר — אשפוז יום","svc":"אשפוז יום לקטינים","target":"קטינים","region":"פתח תקווה","cost":"","specialty":"","languages":"","diseases":"","notes":"הפרטים מפורטל בריאות הנפש, בלי תאריך. לאמת בטלפון.","tags":"","whatsapp":"","whatsappLabel":"","web":"http://www.schneider.org.il","webLabel":"","web2":"https://www.mh-israel.co.il/Article/43/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_מרכז","webLabel2":"פורטל בריאות הנפש","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"03-9253617","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":17,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. פורטל. קפלן 14, פתח תקווה."}'::jsonb,
  '[{"label":"פתח תקווה","address":"קפלן 14, פתח תקווה","lat":32.08799,"lng":34.86763,"phone":"03-9253617","email":"","sort_order":0}]'::jsonb
),
(
  '326|||טיפול יום למבוגרים',
  326,
  'אברבנאל_טיפול_יום_326',
  '{"org":"אברבנאל — טיפול יום","svc":"טיפול יום למבוגרים","target":"מבוגרים","region":"בת ים","cost":"","specialty":"","languages":"","diseases":"","notes":"הפרטים מפורטל בריאות הנפש, בלי תאריך. לאמת בטלפון.","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.mh-israel.co.il/Article/48/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_תל_אביב","webLabel":"פורטל בריאות הנפש","web2":"","webLabel2":"","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"03-5552626","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. פורטל. קרן קיימת 15, בת ים."}'::jsonb,
  '[{"label":"בת ים","address":"קרן קיימת 15, בת ים","lat":32.023541,"lng":34.7560712,"phone":"03-5552626","email":"","sort_order":0}]'::jsonb
),
(
  '327|||טיפול יום למבוגרים של כללית',
  327,
  'בארי_טיפול_יום_327',
  '{"org":"בארי — טיפול יום","svc":"טיפול יום למבוגרים של כללית","target":"מבוגרים","region":"בני ברק","cost":"","specialty":"","languages":"","diseases":"","notes":"הפרטים מפורטל בריאות הנפש, בלי תאריך. לאמת בטלפון. בפורטל: מרכז לטיפול יום של כללית, בארי 5.","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.mh-israel.co.il/Article/48/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_תל_אביב","webLabel":"פורטל בריאות הנפש","web2":"","webLabel2":"","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"03-6714700","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. פורטל."}'::jsonb,
  '[{"label":"בני ברק","address":"בארי 5, בני ברק","lat":32.0778659,"lng":34.828837,"phone":"03-6714700","email":"","sort_order":0}]'::jsonb
),
(
  '328|||אשפוז יום במחלקת ילדים',
  328,
  'שיבא_אשפוז_יום_328',
  '{"org":"שיבא — אשפוז יום","svc":"אשפוז יום במחלקת ילדים","target":"כל הגילאים, לפי הפורטל; המיקום הרשום הוא בניין הילדים","region":"תל השומר","cost":"","specialty":"","languages":"","diseases":"","notes":"הפרטים מפורטל בריאות הנפש, בלי תאריך. לאמת בטלפון.","tags":"","whatsapp":"","whatsappLabel":"","web":"http://rehabilitation.sheba.co.il/Psychiatric_Division/","webLabel":"","web2":"https://www.mh-israel.co.il/Article/48/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_תל_אביב","webLabel2":"פורטל בריאות הנפש","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"03-5302466","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. פורטל. הסיכה היא קמפוס שיבא."}'::jsonb,
  '[{"label":"תל השומר","address":"מרכז רפואי שיבא, תל השומר","lat":32.051486,"lng":34.83906,"phone":"03-5302466","email":"","sort_order":0}]'::jsonb
),
(
  '329|||טיפול יום לנוער, בשיבולים ובצור הדסה',
  329,
  'בית_דניאלה_329',
  '{"org":"בית דניאלה","svc":"טיפול יום לנוער, בשיבולים ובצור הדסה","target":"נוער, גילאי 14–18","region":"מושב שיבולים וצור הדסה","cost":"בלי עלות למבוטחי מכבי, לפי דף הזכאות","specialty":"","languages":"","diseases":"","notes":"לפי דף הזכאות של מכבי לטיפול יום. הדף אינו מציין אם קופות אחרות מתקבלות. אותו מפעיל בשני יישובים. שיבולים: הגפן 27. צור הדסה: השמורה 1. הרחובות לא נמצאו במפה, ולכן אין סיכה.","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.maccabi4u.co.il/eligibilites/64533/","webLabel":"מכבי","web2":"","webLabel2":"","add":"","addLabel":"","email":"kupot@beitdaniella.org","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"055-5515788","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":14,"age_max":18,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. שתי שורות מכבי, אותו טלפון ואותו מייל. אוחדו."}'::jsonb,
  '[]'::jsonb
),
(
  '330|||טיפול יום באבן יהודה וביבנה',
  330,
  'איזון_נפש_330',
  '{"org":"איזון נפש","svc":"טיפול יום באבן יהודה וביבנה","target":"מבוגרים. אבן יהודה: גם תחלואה כפולה, אחרי בית מאזן בית ההדרים","region":"אבן יהודה ויבנה","cost":"בלי עלות למבוטחי מכבי, לפי דף הזכאות","specialty":"","languages":"","diseases":"","notes":"לפי דף הזכאות של מכבי לטיפול יום. הדף אינו מציין אם קופות אחרות מתקבלות. אבן יהודה (בית ההדרים) מיועדת גם למי שסיים תכנית בבית מאזן בית ההדרים. יבנה (עוגנים) למבוגרים. בשני המקומות אותו מייל, ולכן כרטיס אחד.","tags":"","whatsapp":"972515566074","whatsappLabel":"יבנה","web":"https://www.maccabi4u.co.il/eligibilites/64533/","webLabel":"מכבי","web2":"","webLabel2":"","add":"","addLabel":"","email":"office@izunefesh.com","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"073-3746877","phoneLabel":"אבן יהודה","phoneShowNumber":true,"phone2":"08-9574666","phoneLabel2":"יבנה","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. אוחדו כי office@izunefesh.com משותף. אם יתברר שמדובר בשני מפעילים, יש לפצל."}'::jsonb,
  '[{"label":"אבן יהודה","address":"מכבי 10, אבן יהודה","lat":32.2741078,"lng":34.89345,"phone":"073-3746877","email":"office@izunefesh.com","sort_order":0},{"label":"יבנה","address":"הסירה 6, יבנה","lat":31.8622324,"lng":34.7391566,"phone":"08-9574666","email":"office@izunefesh.com","sort_order":1}]'::jsonb
),
(
  '331|||טיפול יום לנשים אחרי בית מאזן להפרעות אכילה',
  331,
  'קידום_השביל_חולון_331',
  '{"org":"קידום השביל (חולון)","svc":"טיפול יום לנשים אחרי בית מאזן להפרעות אכילה","target":"נשים שסיימו תכנית בבית מאזן השביל להפרעות אכילה","region":"חולון","cost":"בלי עלות למבוטחי מכבי, לפי דף הזכאות","specialty":"הפרעות אכילה","languages":"","diseases":"","notes":"לפי דף הזכאות של מכבי לטיפול יום. הדף אינו מציין אם קופות אחרות מתקבלות.","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.maccabi4u.co.il/eligibilites/64533/","webLabel":"מכבי","web2":"","webLabel2":"","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"054-8689359","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"female","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. דף מכבי. תמר 25, חולון."}'::jsonb,
  '[{"label":"חולון","address":"תמר 25, חולון","lat":32.0056226,"lng":34.782394,"phone":"054-8689359","email":"","sort_order":0}]'::jsonb
),
(
  '332|||טיפול יום למבוגרים',
  332,
  'מסאחה_חמרה_332',
  '{"org":"מסאחה (חמרה)","svc":"טיפול יום למבוגרים","target":"מבוגרים","region":"חמרה","cost":"בלי עלות למבוטחי מכבי, לפי דף הזכאות","specialty":"","languages":"","diseases":"","notes":"לפי דף הזכאות של מכבי לטיפול יום. הדף אינו מציין אם קופות אחרות מתקבלות. רחוב סוועאד, חמרה. היישוב לא נמצא במפה, ולכן אין סיכה.","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.maccabi4u.co.il/eligibilites/64533/","webLabel":"מכבי","web2":"","webLabel2":"","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"053-4872986","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. דף מכבי. רחוב סוועאד, חמרה."}'::jsonb,
  '[]'::jsonb
),
(
  '333|||טיפול יום למבוגרים עם הפרעות אכילה',
  333,
  'גשר_לתקווה_כרמיאל_333',
  '{"org":"גשר לתקווה (כרמיאל)","svc":"טיפול יום למבוגרים עם הפרעות אכילה","target":"מבוגרים עם הפרעות אכילה","region":"כרמיאל","cost":"בלי עלות למבוטחי מכבי, לפי דף הזכאות","specialty":"הפרעות אכילה","languages":"","diseases":"","notes":"לפי דף הזכאות של מכבי לטיפול יום. הדף אינו מציין אם קופות אחרות מתקבלות. הטלפון משמש גם לוואטסאפ.","tags":"","whatsapp":"972503983888","whatsappLabel":"וואטסאפ","web":"https://www.maccabi4u.co.il/eligibilites/64533/","webLabel":"מכבי","web2":"","webLabel2":"","add":"","addLabel":"","email":"pniyot@homeforhope.co.il","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"050-3983888","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. דף מכבי. צה״ל 82א, כרמיאל."}'::jsonb,
  '[{"label":"כרמיאל","address":"צה״ל 82, כרמיאל","lat":32.9186,"lng":35.3059,"phone":"050-3983888","email":"pniyot@homeforhope.co.il","sort_order":0}]'::jsonb
),
(
  '334|||טיפול יום למבוגרים',
  334,
  'רגעים_מגדל_העמק_334',
  '{"org":"רגעים (מגדל העמק)","svc":"טיפול יום למבוגרים","target":"מבוגרים","region":"מגדל העמק","cost":"בלי עלות למבוטחי מכבי, לפי דף הזכאות","specialty":"","languages":"","diseases":"","notes":"לפי דף הזכאות של מכבי לטיפול יום. הדף אינו מציין אם קופות אחרות מתקבלות.","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.maccabi4u.co.il/eligibilites/64533/","webLabel":"מכבי","web2":"","webLabel2":"","add":"","addLabel":"","email":"team@regaim-home.com","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"050-5504444","phoneLabel":"","phoneShowNumber":true,"phone2":"054-6387794","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. דף מכבי. קרן היסוד 44."}'::jsonb,
  '[{"label":"מגדל העמק","address":"קרן היסוד 44, מגדל העמק","lat":32.6721551,"lng":35.2440569,"phone":"050-5504444","email":"team@regaim-home.com","sort_order":0}]'::jsonb
),
(
  '335|||טיפול יום למבוגרים',
  335,
  'אופק_רם_עכו_335',
  '{"org":"אופק רם (עכו)","svc":"טיפול יום למבוגרים","target":"מבוגרים","region":"עכו","cost":"בלי עלות למבוטחי מכבי, לפי דף הזכאות","specialty":"","languages":"","diseases":"","notes":"לפי דף הזכאות של מכבי לטיפול יום. הדף אינו מציין אם קופות אחרות מתקבלות. קניון עזריאלי, קומה 4.","tags":"","whatsapp":"972546887776","whatsappLabel":"וואטסאפ","web":"https://www.maccabi4u.co.il/eligibilites/64533/","webLabel":"מכבי","web2":"","webLabel2":"","add":"","addLabel":"","email":"info@ofekram.co.il","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"04-6702222","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. דף מכבי."}'::jsonb,
  '[{"label":"עכו","address":"קניון עזריאלי, עכו","lat":32.9231043,"lng":35.0813703,"phone":"04-6702222","email":"info@ofekram.co.il","sort_order":0}]'::jsonb
),
(
  '336|||טיפול יום למבוגרים',
  336,
  'מעיין_הנפש_קריית_אתא_336',
  '{"org":"מעיין הנפש (קריית אתא)","svc":"טיפול יום למבוגרים","target":"מבוגרים","region":"קריית אתא","cost":"בלי עלות למבוטחי מכבי, לפי דף הזכאות","specialty":"","languages":"","diseases":"","notes":"לפי דף הזכאות של מכבי לטיפול יום. הדף אינו מציין אם קופות אחרות מתקבלות. דרך חיפה 37. מספר הבית לא נמצא במפה, ולכן אין סיכה.","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.maccabi4u.co.il/eligibilites/64533/","webLabel":"מכבי","web2":"","webLabel2":"","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"055-5622590","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. דף מכבי. דרך חיפה 37."}'::jsonb,
  '[]'::jsonb
),
(
  '337|||טיפול יום לילדים ולנוער',
  337,
  'קרני_שמש_337',
  '{"org":"קרני שמש","svc":"טיפול יום לילדים ולנוער","target":"ילדים ונוער, גילאי 12–18","region":"ארז 11; היישוב לא צוין","cost":"בלי עלות למבוטחי מכבי, לפי דף הזכאות","specialty":"","languages":"","diseases":"","notes":"לפי דף הזכאות של מכבי לטיפול יום. הדף אינו מציין אם קופות אחרות מתקבלות. בדף לא צוינו היישוב והטלפון, ולכן אין סיכה במפה.","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.maccabi4u.co.il/eligibilites/64533/","webLabel":"מכבי","web2":"","webLabel2":"","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":12,"age_max":18,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. דף מכבי. ארז 11 בלי יישוב ובלי טלפון. בלי סיכה."}'::jsonb,
  '[]'::jsonb
),
(
  '338|||מרפאת חוץ לבריאות הנפש, ליד שער בית החולים',
  338,
  'מרפאת_עירון_שער_מנשה_338',
  '{"org":"מרפאת עירון (שער מנשה)","svc":"מרפאת חוץ לבריאות הנפש, ליד שער בית החולים","target":"פונים למרפאת חוץ","region":"שער מנשה, ליד שער בית החולים","cost":"","specialty":"","languages":"","diseases":"","notes":"המרפאה יושבת מחוץ למרכז, ליד השער וציר התחבורה הציבורית. יש בה מעקב רפואי, סיעודי, סוציאלי ופסיכולוגי, וגם טיפול יום מרפאתי. המרפאה לטראומה מינית יושבת כאן ומתוארת ב[מערך לטראומה מינית](https://nefesh-il.org/treatment?entry=340&section=hospitalization). מחלקת האשפוז-יום הנפרדת: [אשפוז יום](https://nefesh-il.org/treatment?entry=339&section=day_care). מרכז הייעוץ למשפחות: [הרשימה](https://nefesh-il.org/support?entry=308&section=families).","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.shaar-menashe.org/?ArticleID=157&CategoryID=178","webLabel":"","web2":"https://www.shaar-menashe.org/?CategoryID=156","webLabel2":"מחלקות המרכז","add":"","addLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. דף מרפאת עירון ודף המחלקות באתר שער מנשה. לא נמצא טלפון נפרד למרפאה הכללית. הסיכה היא קמפוס שער מנשה."}'::jsonb,
  '[{"label":"שער מנשה","address":"המרכז לבריאות הנפש שער מנשה","lat":32.44713,"lng":35.0157,"phone":"","email":"","sort_order":0}]'::jsonb
),
(
  '339|||מחלקת אשפוז יום לטיפול אינטנסיבי או אחרי אשפוז מלא',
  339,
  'שער_מנשה_אשפוז_יום_339',
  '{"org":"שער מנשה — אשפוז יום","svc":"מחלקת אשפוז יום לטיפול אינטנסיבי או אחרי אשפוז מלא","target":"מי שזקוק לטיפול אינטנסיבי, או להמשך אחרי אשפוז מלא","region":"שער מנשה","cost":"","specialty":"","languages":"","diseases":"","notes":"מנהלת: ד״ר אלמה פרנקל. במתחם המרכז הקהילתי. נדרשים שיתוף פעולה, יכולת להגיע 3–5 פעמים בשבוע, ומצב שמאפשר תכנית רב-שלבית, בלי תלות עכשווית באלכוהול או בחומרים פסיכו-אקטיביים. המענה לנפגעי טראומה מינית בתוך טיפול היום מתואר ב[מערך לטראומה מינית](https://nefesh-il.org/treatment?entry=340&section=day_care).","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.shaar-menashe.org/?ArticleID=237&CategoryID=156","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","email":"iris@sm.health.gov.il","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"04-6278111","phoneLabel":"משרד","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. דף מחלקת אשפוז יום, ArticleID=237. זו היחידה הכללית, לא רק מסלול הטראומה."}'::jsonb,
  '[{"label":"שער מנשה","address":"המרכז לבריאות הנפש שער מנשה","lat":32.44713,"lng":35.0157,"phone":"04-6278111","email":"iris@sm.health.gov.il","sort_order":0}]'::jsonb
),
(
  '340|||אשפוז ממוקד, מרפאה וטיפול יום לנפגעי ולנפגעות טראומה מינית',
  340,
  'שער_מנשה_טראומה_מינית_340',
  '{"org":"שער מנשה — טראומה מינית","svc":"אשפוז ממוקד, מרפאה וטיפול יום לנפגעי ולנפגעות טראומה מינית","target":"נשים וגברים מגיל 18, שנמצאים בטיפול בקהילה","region":"שער מנשה; מקבל מכל הארץ","cost":"","specialty":"טראומה מינית","languages":"","diseases":"","notes":"רצף אחד: אשפוז ממוקד של עד שבועיים במחלקה פתוחה מעורבת, מרפאה ב[מרפאת עירון](https://nefesh-il.org/treatment?entry=338&section=mh_clinics), וטיפול יום (לפחות שלושה ימים, 08:00–14:00) בתוך [מחלקת האשפוז-יום](https://nefesh-il.org/treatment?entry=339&section=day_care). אשפוז ממוקד: עו״ס רתם קציר, פקס 04-6278005, ואחר כך בדיקה במיון. טיפול יום: עו״ס לירון שפינדלר, 04-6278111 או 04-6278112, טופס 17. כל זכות מונה גם מיטות לנפגעות טראומה מינית ברמב״ם, בברזילי, בזיו, בבאר שבע ובכפר שאול, בלי דף יחידה עדכני. [הרשימה](https://www.kolzchut.org.il/he/אשפוז_פסיכיאטרי_לנפגעות_תקיפה_מינית). גם [לצידך](https://nefesh-il.org/treatment?entry=293&section=hospitalization).","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.shaar-menashe.org/?ArticleID=267&CategoryID=156","webLabel":"","web2":"https://www.kolzchut.org.il/he/מרכזי_יום_ומרפאות_לטיפול_נפש_בנפגעות_תקיפה_מינית","webLabel2":"כל זכות · טיפול יום","add":"https://www.kolzchut.org.il/he/אשפוז_פסיכיאטרי_לנפגעות_תקיפה_מינית","addLabel":"כל זכות · אשפוז","email":"rotemk@sm.health.gov.il","emailLabel":"אשפוז ממוקד","emailShowAddress":false,"email2":"liron@sm.haelth.gov.il","emailLabel2":"טיפול יום","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"04-6278723","phoneLabel":"רכזת המערך","phoneShowNumber":true,"phone2":"04-6278112","phoneLabel2":"טיפול יום","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. נקרא דף המערך ArticleID=267. כתובת המייל של טיפול היום מפורסמת בדף כ-liron@sm.haelth.gov.il, כולל האיות haelth. אשפוז ממוקד: rotemk@sm.health.gov.il."}'::jsonb,
  '[{"label":"שער מנשה","address":"המרכז לבריאות הנפש שער מנשה","lat":32.44713,"lng":35.0157,"phone":"04-6278723","email":"rotemk@sm.health.gov.il","sort_order":0}]'::jsonb
),
(
  '341|||אשפוז ממוקד ל-16 יום, וטיפול יום במרכז עוגן',
  341,
  'לב_השרון_טראומה_מינית_341',
  '{"org":"לב השרון — טראומה מינית","svc":"אשפוז ממוקד ל-16 יום, וטיפול יום במרכז עוגן","target":"מגיל 18, בטיפול פרטני בקהילה","region":"לב השרון","cost":"","specialty":"טראומה מינית","languages":"","diseases":"","notes":"אשפוז ממוקד ומתוכנן ל-16 יום, במחלקת נשים פתוחה או במחלקה פתוחה מעורבת, לייצוב במשבר. מנהל התכנית: ד״ר עדיאל דורון. מנהלת המערך: עו״ס עמליה בן משה. טיפול היום של עוגן, וטיפול יום להפרעות אכילה וטראומה במרפאת המבוגרים בנתניה, רשומים בכל זכות בלי כתובת נפרדת, ולכן סיכה אחת. נפרד מ[התכנית לשורדי מסיבות](https://nefesh-il.org/treatment?entry=235&section=trauma). כל זכות מונה גם מיטות לנפגעות טראומה מינית ברמב״ם, בברזילי, בזיו, בבאר שבע ובכפר שאול, בלי דף יחידה עדכני. [הרשימה](https://www.kolzchut.org.il/he/אשפוז_פסיכיאטרי_לנפגעות_תקיפה_מינית).","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.lev-hasharon.co.il/?ward=%D7%9E%D7%A2%D7%A8%D7%9A-%D7%9C%D7%98%D7%99%D7%A4%D7%95%D7%9C-%D7%91%D7%98%D7%A8%D7%90%D7%95%D7%9E%D7%94-%D7%9E%D7%99%D7%A0%D7%99%D7%AA","webLabel":"המערך","web2":"https://www.lev-hasharon.co.il/?clinic=%D7%90%D7%A9%D7%A4%D7%95%D7%96-%D7%9E%D7%9E%D7%95%D7%A7%D7%93-%D7%9C%D7%A0%D7%A4%D7%92%D7%A2%D7%95%D7%AA-%D7%98%D7%A8%D7%90%D7%95%D7%9E%D7%94-%D7%9E%D7%99%D7%A0%D7%99%D7%AA","webLabel2":"אשפוז ממוקד","add":"https://www.kolzchut.org.il/he/מרכזי_יום_ומרפאות_לטיפול_נפש_בנפגעות_תקיפה_מינית","addLabel":"כל זכות · טיפול יום","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"09-8980429","phoneLabel":"מערך","phoneShowNumber":true,"phone2":"09-8980427","phoneLabel2":"טלפקס","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. דפי המערך והאשפוז הממוקד באתר לב השרון, ושורות 41–42 בקובץ (כל זכות). לא נמצאה כתובת נפרדת למרפאה בנתניה, ולכן אין סיכה שנייה. לא בשימוש הקואורדינטה 32.328618, 34.856625. חיפוש Nominatim לשם בית החולים החזיר את המועצה האזורית לב השרון ליד צור משה (32.30011, 34.91353) ונדחה. הסיכה היא מרפאת לב השרון בפרדס חנה-כרכור שכבר במדריך (32.474996, 34.975139)."}'::jsonb,
  '[{"label":"פרדס חנה-כרכור","address":"המרכז לבריאות הנפש לב השרון, פרדס חנה-כרכור","lat":32.474996,"lng":34.975139,"phone":"09-8980429","email":"","sort_order":0}]'::jsonb
),
(
  '342|||יחידת אשפוז לנשים אחרי פגיעה מינית',
  342,
  'מגן_איכילוב_342',
  '{"org":"מגן (איכילוב)","svc":"יחידת אשפוז לנשים אחרי פגיעה מינית","target":"נשים מגיל 18, מכל הארץ, שנמצאות בטיפול","region":"תל אביב","cost":"","specialty":"טראומה מינית","languages":"","diseases":"","notes":"ארבע מיטות בתוך המחלקה הפסיכיאטרית הפתוחה. שהות עד שלושה שבועות, מרצון, עם מקום מגורים קבוע לחזור אליו. לא לשימוש לרעה בחומרים, לא להפרעת אכילה שדורשת מחלקה ייעודית, ולא למצב שדורש מחלקה סגורה. יצירת קשר דרך הטופס בדף היחידה. כל זכות מונה גם מיטות לנפגעות טראומה מינית ברמב״ם, בברזילי, בזיו, בבאר שבע ובכפר שאול, בלי דף יחידה עדכני. [הרשימה](https://www.kolzchut.org.il/he/אשפוז_פסיכיאטרי_לנפגעות_תקיפה_מינית). גם [לצידך](https://nefesh-il.org/treatment?entry=293&section=hospitalization).","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.tasmc.org.il/health/psychiatry/magen/","webLabel":"","web2":"","webLabel2":"","add":"https://www.kolzchut.org.il/he/אשפוז_פסיכיאטרי_לנפגעות_תקיפה_מינית","addLabel":"כל זכות","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"female","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"16.10.2026. נקרא דף מגן באתר איכילוב, מעודכן 26.11.2024. הדף אינו מציין טלפון. הסיכה היא קמפוס איכילוב."}'::jsonb,
  '[{"label":"איכילוב","address":"המרכז הרפואי תל אביב (איכילוב)","lat":32.080381,"lng":34.790155,"phone":"","email":"","sort_order":0}]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
VALUES
  (309, 'כפר_שאול_אשפוז_יום_309', 'כפר שאול', 'המרכז הירושלמי לבריאות הנפש, כפר שאול', 31.786614, 35.177992, 0),
  (310, 'לוטוס_כפר_שאול_310', 'כפר שאול', 'המרכז הירושלמי לבריאות הנפש, כפר שאול', 31.786614, 35.177992, 0),
  (312, 'גהה_מחלקה_ח_312', 'פתח תקווה', 'הלסינקי 1, פתח תקווה', 32.089107, 34.864914, 0),
  (313, 'חופים_איכילוב_313', 'תל אביב', 'רבקה זיו 3, תל אביב', 32.0795029, 34.7867419, 0),
  (314, 'הדסה_טיפול_יום_ואשפוז_יום_314', 'אתיופיה', 'אתיופיה 6, ירושלים', 31.7844136, 35.221026, 0),
  (314, 'הדסה_טיפול_יום_ואשפוז_יום_314', 'עין כרם', 'הדסה עין כרם, ירושלים', 31.7649565, 35.1500168, 1),
  (315, 'ברזילי_טיפול_יום_315', 'אשקלון', 'מרכז רפואי ברזילי, אשקלון', 31.6620786, 34.5593019, 0),
  (315, 'ברזילי_טיפול_יום_315', 'שקד', 'ההסתדרות 3, אשקלון', 31.6558924, 34.5582856, 1),
  (316, 'זיו_טיפול_יום_316', 'צפת', 'מרכז רפואי זיו, צפת', 32.9540333, 35.4925033, 0),
  (317, 'מזרע_טיפול_יום_317', 'עכו', 'טרומפלדור 37, עכו', 32.9260824, 35.0746226, 0),
  (320, 'נהריה_אשפוז_יום_320', 'נהריה', 'המרכז הרפואי לגליל, נהריה', 33.0100224, 35.1169063, 0),
  (321, 'באר_שבע_טיפול_יום_321', 'באר שבע', 'הצדיק מירושלים 2, באר שבע', 31.2736264, 34.7913423, 0),
  (322, 'סורוקה_טיפול_יום_322', 'באר שבע', 'בית חולים סורוקה, באר שבע', 31.25821, 34.80093, 0),
  (323, 'באר_יעקב_טיפול_יום_323', 'לוד', 'מודיעין 4, לוד', 31.9545379, 34.8916536, 0),
  (324, 'שלוותה_טיפול_יום_324', 'הוד השרון', 'עליית הנוער 13, הוד השרון', 32.15486, 34.898352, 0),
  (326, 'אברבנאל_טיפול_יום_326', 'בת ים', 'קרן קיימת 15, בת ים', 32.023541, 34.7560712, 0),
  (327, 'בארי_טיפול_יום_327', 'בני ברק', 'בארי 5, בני ברק', 32.0778659, 34.828837, 0),
  (328, 'שיבא_אשפוז_יום_328', 'תל השומר', 'מרכז רפואי שיבא, תל השומר', 32.051486, 34.83906, 0),
  (330, 'איזון_נפש_330', 'אבן יהודה', 'מכבי 10, אבן יהודה', 32.2741078, 34.89345, 0),
  (330, 'איזון_נפש_330', 'יבנה', 'הסירה 6, יבנה', 31.8622324, 34.7391566, 1),
  (331, 'קידום_השביל_חולון_331', 'חולון', 'תמר 25, חולון', 32.0056226, 34.782394, 0),
  (334, 'רגעים_מגדל_העמק_334', 'מגדל העמק', 'קרן היסוד 44, מגדל העמק', 32.6721551, 35.2440569, 0),
  (335, 'אופק_רם_עכו_335', 'עכו', 'קניון עזריאלי, עכו', 32.9231043, 35.0813703, 0),
  (311, 'קפלן_טיפול_יום_פסיכיאטרי_311', 'רחובות', 'בית חולים קפלן, רחובות', 31.87213, 34.81648, 0),
  (318, 'העמק_טיפול_יום_318', 'עפולה', 'בית חולים העמק, עפולה', 32.62214, 35.31783, 0),
  (319, 'האנגלי_בנצרת_אשפוז_יום_319', 'נצרת', 'בית החולים האנגלי, נצרת', 32.70168, 35.29187, 0),
  (325, 'שניידר_אשפוז_יום_325', 'פתח תקווה', 'קפלן 14, פתח תקווה', 32.08799, 34.86763, 0),
  (333, 'גשר_לתקווה_כרמיאל_333', 'כרמיאל', 'צה״ל 82, כרמיאל', 32.9186, 35.3059, 0),
  (338, 'מרפאת_עירון_שער_מנשה_338', 'שער מנשה', 'המרכז לבריאות הנפש שער מנשה', 32.44713, 35.0157, 0),
  (339, 'שער_מנשה_אשפוז_יום_339', 'שער מנשה', 'המרכז לבריאות הנפש שער מנשה', 32.44713, 35.0157, 0),
  (340, 'שער_מנשה_טראומה_מינית_340', 'שער מנשה', 'המרכז לבריאות הנפש שער מנשה', 32.44713, 35.0157, 0),
  (341, 'לב_השרון_טראומה_מינית_341', 'פרדס חנה-כרכור', 'המרכז לבריאות הנפש לב השרון, פרדס חנה-כרכור', 32.474996, 34.975139, 0),
  (342, 'מגן_איכילוב_342', 'איכילוב', 'המרכז הרפואי תל אביב (איכילוב)', 32.080381, 34.790155, 0)
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'svc', 'הסבר על טיפול יום ועל אשפוז יום, וקישור לרשימות הארציות',
      'notes', 'טיפול יום הוא מסגרת בקהילה, בדרך כלל 3–5 ימים בשבוע, כדי למנוע אשפוז מלא. אשפוז יום הוא המשך קצר באותה מחלקה אחרי אשפוז מלא. זכאות: מכבי https://www.maccabi4u.co.il/eligibilites/64533/?id=1449 ולאומית https://leumit.co.il/mental-health-arena/outpatient-psychiatric-clinics/ . למרכזים עצמם יש כרטיס נפרד בקטגוריה זו.'
    ),
    eligibility = jsonb_set(
      eligibility,
      '{internal_notes}',
      to_jsonb(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n16.10.2026: נוספו כרטיסים למרכזים שההערה הקודמת אמרה שאין להם כרטיס. הכרטיס נשאר הסבר על השירות וקישור לרשימות.')
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '304|||הסבר על השירות, וטבלאות מרכזים שאין להם כרטיס נפרד';

UPDATE directory_card_edits
SET public_fields = public_fields
      || jsonb_build_object(
           'notes', rtrim(COALESCE(public_fields->>'notes', '')) || ' הרשימה הרשמית של מרכזי הייעוץ, בקהילה ובבתי חולים: [מרכזי ייעוץ למשפחות](https://nefesh-il.org/support?entry=308&section=families).'
         )
      || CASE WHEN COALESCE(public_fields->>'web2', '') = ''
           THEN jsonb_build_object(
             'web2', 'https://www.gov.il/he/departments/dynamiccollectors/smtl-families-center',
             'webLabel2', 'רשימת המרכזים'
           )
           ELSE '{}'::jsonb END,
    eligibility = jsonb_set(eligibility, '{internal_notes}', to_jsonb(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n16.10.2026: קישור לרשימת משרד הבריאות ולכרטיס 308. בלי סיכות חדשות.')),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 52
  AND COALESCE(public_fields->>'notes', '') NOT LIKE '%entry=308%';

UPDATE directory_card_edits
SET public_fields = public_fields
      || jsonb_build_object(
           'notes', rtrim(COALESCE(public_fields->>'notes', '')) || ' הרשימה הרשמית של מרכזי הייעוץ, בקהילה ובבתי חולים: [מרכזי ייעוץ למשפחות](https://nefesh-il.org/support?entry=308&section=families).'
         )
      || CASE WHEN COALESCE(public_fields->>'web2', '') = ''
           THEN jsonb_build_object(
             'web2', 'https://www.gov.il/he/departments/dynamiccollectors/smtl-families-center',
             'webLabel2', 'רשימת המרכזים'
           )
           ELSE '{}'::jsonb END,
    eligibility = jsonb_set(eligibility, '{internal_notes}', to_jsonb(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n16.10.2026: קישור לרשימת משרד הבריאות ולכרטיס 308. הסיכות הקיימות לא שונו.')),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 66
  AND COALESCE(public_fields->>'notes', '') NOT LIKE '%entry=308%';

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'notes', rtrim(COALESCE(public_fields->>'notes', '')) || ' הרשימה הרשמית של מרכזי הייעוץ למשפחות: [מרכזי ייעוץ למשפחות](https://nefesh-il.org/support?entry=308&section=families).'
    ),
    eligibility = jsonb_set(eligibility, '{internal_notes}', to_jsonb(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n16.10.2026: מאגר משרד הבריאות מציג לבני ברק 073-3956218. נשאר המספר שנמסר על ידי צוות ב-15.10.2026, 073-3956128. לא נוספה סיכה.')),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 305
  AND COALESCE(public_fields->>'notes', '') NOT LIKE '%entry=308%';

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'notes', rtrim(COALESCE(public_fields->>'notes', '')) || ' אשפוז ממוקד לנפגעי טראומה מינית גם ב[שער מנשה](https://nefesh-il.org/treatment?entry=340&section=hospitalization) וב[לב השרון](https://nefesh-il.org/treatment?entry=341&section=hospitalization), ויחידת [מגן](https://nefesh-il.org/treatment?entry=342&section=hospitalization) באיכילוב.'
    ),
    eligibility = jsonb_set(eligibility, '{internal_notes}', to_jsonb(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n16.10.2026: קישור ליחידות האשפוז הממוקד החדשות.')),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 293
  AND COALESCE(public_fields->>'notes', '') NOT LIKE '%entry=340%';

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'notes', rtrim(COALESCE(public_fields->>'notes', '')) || ' המערך לטראומה מינית בלב השרון, כולל עוגן ואשפוז ממוקד, בכרטיס [נפרד](https://nefesh-il.org/treatment?entry=341&section=trauma).'
    ),
    eligibility = jsonb_set(eligibility, '{internal_notes}', to_jsonb(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n16.10.2026: קישור לכרטיס 341. כרטיס זה נשאר תכנית שורדי המסיבות.')),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 235
  AND COALESCE(public_fields->>'notes', '') NOT LIKE '%entry=341%';

COMMIT;
