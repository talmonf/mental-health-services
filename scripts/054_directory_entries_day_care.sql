-- Migration 054 (12 Oct 2026)
-- directory_entries + directory_card_edits + directory_entry_locations:
-- category day_care, אשפוז יום פסיכיאטרי (טיפול יום).
-- New rows 297–304. Row 279 (בית רעים) stays worded as it is and is also listed here.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys,
  referral_codes
) VALUES
  (
    'מעון_ירושלים_המרכז_הירושלמי_לבריאות_הנפש_297',
    'מעון ירושלים (המרכז הירושלמי לבריאות הנפש)',
    'טיפול יום אינטנסיבי למבוגרים — מניעת אשפוז מלא',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['psychiatrist_referral', 'hmo_form17']::text[]
  ),
  (
    'ויניק_טלביה_כללית_298',
    'ויניק טלביה (כללית)',
    'אשפוז יום פסיכיאטרי למבוטחי כללית',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['gp_referral']::text[]
  ),
  (
    'איכילוב_טיפול_יום_נוירופסיכיאטרי_299',
    'איכילוב — טיפול יום נוירופסיכיאטרי',
    'טיפול יום למצבים נוירופסיכיאטריים וסומטיים — לא מסגרת כללית למשבר',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['gp_referral', 'psychiatrist_referral', 'hmo_form17']::text[]
  ),
  (
    'מעייני_הישועה_300',
    'מעייני הישועה',
    'טיפול יום פסיכיאטרי בהפרדה מגדרית — לציבור הדתי והחרדי',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['gp_referral', 'hmo_form17']::text[]
  ),
  (
    'רמב_ם_היחידה_לטיפול_יום_301',
    'רמב״ם — היחידה לטיפול יום',
    'טיפול יום פסיכיאטרי בשני שלבים',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['unknown']::text[]
  ),
  (
    'הלל_יפה_יחידת_טיפול_יום_מבוגרים_302',
    'הלל יפה — יחידת טיפול יום מבוגרים',
    'טיפול יום פסיכיאטרי, חמישה ימים בשבוע',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['psychiatrist_referral', 'hmo_form17']::text[]
  ),
  (
    'כללית_טיפול_יום_מבוגרים_יפו_303',
    'כללית — טיפול יום מבוגרים, יפו',
    'טיפול יום פסיכיאטרי למבוטחי כללית',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['gp_referral']::text[]
  ),
  (
    'רשימות_ארציות_טיפול_יום_פסיכיאטרי_304',
    'רשימות ארציות — טיפול יום פסיכיאטרי',
    'הסבר על השירות, וטבלאות מרכזים שאין להם כרטיס נפרד',
    'day_care',
    ARRAY['day_care']::text[],
    ARRAY['unknown']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

UPDATE directory_entries
SET category_keys = category_keys || ARRAY['day_care']::text[]
WHERE entry_id = 'בית_רעים_האגודה_לבריאות_הציבור_279'
  AND NOT ('day_care' = ANY(category_keys));

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES
(
  '297|||טיפול יום אינטנסיבי למבוגרים — מניעת אשפוז מלא',
  297,
  'מעון_ירושלים_המרכז_הירושלמי_לבריאות_הנפש_297',
  '{"org":"מעון ירושלים (המרכז הירושלמי לבריאות הנפש)","svc":"טיפול יום אינטנסיבי למבוגרים — מניעת אשפוז מלא","target":"מגיל 18, למעט התמכרויות והפרעות אכילה","region":"ארנונה, ירושלים","cost":"טופס 17, קוד L0771","specialty":"","languages":"","diseases":"","notes":"א׳–ה׳ 08:30–15:00, כשלושה חודשים. הפניה מפסיכיאטר; אם יש מטפל בפסיכותרפיה — גם מכתב ממנו. לפי איש צוות: המתנה כ־2–4 חודשים ותלויה במצב; לרוב דיכאון או משבר, במקום אשפוז או לפניו. אינו מתאים כשנדרשת השגחה 24/7, כולל סיכון אובדני פעיל. פונים מכללית מתקבלים פחות, כי לכללית יש מרכז בטלביה. מנהלת: ד״ר יסכה בריס גינת.","tags":"","whatsapp":"","whatsappLabel":"","email":"j.maon@moh.gov.il","web":"https://psjer.org.il/clinics/%D7%94%D7%9E%D7%97%D7%9C%D7%A7%D7%94-%D7%9C%D7%98%D7%99%D7%A4%D7%95%D7%9C-%D7%99%D7%95%D7%9D-%D7%90%D7%99%D7%A0%D7%98%D7%A0%D7%A1%D7%99%D7%91%D7%99/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"02-6732672","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"נבדק 12.10.2026 מול דף מעון ירושלים באתר המרכז הירושלמי (psjer.org.il). כתובת קורא הדורות 24, ארנונה; טלפון 02-6732672; j.maon@moh.gov.il; א׳–ה׳ 08:30–15:00; כשלושה חודשים; מגיל 18; למעט התמכרויות והפרעות אכילה; הפניה מפסיכיאטר ומכתב ממטפל בפסיכותרפיה אם יש; טופס 17 קוד L0771. מנהלת: ד״ר יסכה בריס גינת. המתנה של כ־2–4 חודשים, אי-התאמה כשנדרשת השגחה 24/7 כולל סיכון אובדני פעיל, והקבלה הפחותה של פוני כללית בגלל המרכז בטלביה — לפי איש צוות ב-12.10.2026, לא לפי האתר. האתר עצמו מתאר את השירות לכל הקופות עם טופס 17. קואורדינטה: בניין 24 בקורא הדורות (OSM)."}'::jsonb,
  '[{"label":"ארנונה","address":"קורא הדורות 24, ארנונה, ירושלים","lat":31.7497053,"lng":35.2224201,"phone":"02-6732672","email":"j.maon@moh.gov.il","sort_order":0}]'::jsonb
),
(
  '298|||אשפוז יום פסיכיאטרי למבוטחי כללית',
  298,
  'ויניק_טלביה_כללית_298',
  '{"org":"ויניק טלביה (כללית)","svc":"אשפוז יום פסיכיאטרי למבוטחי כללית","target":"מבוטחי כללית","region":"טלביה, ירושלים","cost":"במסגרת כללית","specialty":"","languages":"","diseases":"","notes":"מרכז בריאות הנפש מבוגרים ע״ש פרופ׳ ויניק. לפי אתר קשר, אשפוז יום ניתן רק לאחר הפניית רופא. מנהל המרפאה: ד״ר אהוד רוזיצקי. דף האשפוז-יום של כללית לא נטען בעת העדכון; הכתובת והטלפון לפי רשומת המרפאה וטבלת מילם.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://www.clalit.co.il/he/your_health/family/mental_health/Pages/day_hospitalization.aspx","webLabel":"אשפוז יום","web2":"https://www.clalit.co.il/he/sefersherut/pages/clinicdetails.aspx?ddeptcode=15530","webLabel2":"רשומת המרפאה","add":"","addLabel":"","phone":"02-5608355","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"נבדק 12.10.2026. דף האשפוז-יום של כללית (day_hospitalization.aspx) נחסם ב-Incapsula ולא נקרא. הכתובת בנימין דישראלי 17 והמנהל ד״ר אהוד רוזיצקי לפי רשומת המרפאה ddeptcode=15530. הטלפון 02-5608355 לפי טבלת מילם ופורטל בריאות הנפש (מחוז ירושלים). אתר קשר: אשפוז יום רק לאחר הפניית רופא. קואורדינטה: ד׳ישראלי בנימין 17, טלביה (OSM)."}'::jsonb,
  '[{"label":"טלביה","address":"בנימין דישראלי 17, טלביה, ירושלים","lat":31.7699805,"lng":35.2199557,"phone":"02-5608355","email":"","sort_order":0}]'::jsonb
),
(
  '299|||טיפול יום למצבים נוירופסיכיאטריים וסומטיים — לא מסגרת כללית למשבר',
  299,
  'איכילוב_טיפול_יום_נוירופסיכיאטרי_299',
  '{"org":"איכילוב — טיפול יום נוירופסיכיאטרי","svc":"טיפול יום למצבים נוירופסיכיאטריים וסומטיים — לא מסגרת כללית למשבר","target":"מי שזקוק למעקב צמוד ממרפאה, בלי אשפוז מלא","region":"תל אביב","cost":"טופס 17, קוד L0822, ל־63 ימי טיפול","specialty":"נוירופסיכיאטריה","languages":"","diseases":"","notes":"עד שלושה חודשים, חמישה ימים בשבוע, 09:00–14:00, בבניין השיקום. הפניה בכתב מגורם בבריאות הנפש, מנוירולוג או מרופא משפחה; אם יש פסיכיאטר מטפל — לצרף מכתב. לא לשימוש פעיל בסמים או אלכוהול, לא לאובדנות פעילה, לא למצב מאני או פסיכוטי סוער, ולא פחות משלושה חודשים אחרי אשפוז מלא.","tags":"","whatsapp":"","whatsappLabel":"","email":"psos-c@tlvmc.gov.il","web":"https://www.tasmc.org.il/unit-index-page/psychiatr/psychiatry-daytreatment/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"03-6973485","phoneLabel":"טיפול יום","phoneShowNumber":true,"phone2":"03-6974707","phoneLabel2":"מרפאה","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"נבדק 12.10.2026 מול דף מחלקת טיפול יום נוירופסיכיאטרית באיכילוב. זו אינה מסגרת כללית למשבר. עד שלושה חודשים, חמישה ימים, 09:00–14:00, בניין השיקום. טופס 17 קוד L0822 ל-63 ימי טיפול. טלפון 03-6973485, מרפאה 03-6974707, psos-c@tlvmc.gov.il. פורטל ישן מציין הנריטה סולד 13; חיפוש הרחוב החזיר את רמת השרון, ולכן הסיכה היא קמפוס איכילוב שכבר במדריך (32.080381, 34.790155)."}'::jsonb,
  '[{"label":"איכילוב","address":"בניין השיקום, המרכז הרפואי תל אביב (איכילוב)","lat":32.080381,"lng":34.790155,"phone":"03-6973485","email":"psos-c@tlvmc.gov.il","sort_order":0}]'::jsonb
),
(
  '300|||טיפול יום פסיכיאטרי בהפרדה מגדרית — לציבור הדתי והחרדי',
  300,
  'מעייני_הישועה_300',
  '{"org":"מעייני הישועה","svc":"טיפול יום פסיכיאטרי בהפרדה מגדרית — לציבור הדתי והחרדי","target":"מי שזקוק לטיפול יומי, בלי לינה ובלי שבת","region":"בני ברק","cost":"כללית ומכבי: הפניה מרופא מטפל. מאוחדת ולאומית: טופס 17. משרד הביטחון: טופס התחייבות","specialty":"","languages":"","diseases":"","notes":"היחידה פועלת בהפרדה מגדרית. טלפון המחלקה לפי טבלת מילם. פרטי המימון בדף היחידה מתייחסים למרפאות החוץ הפסיכיאטריות של המרכז. בלי התחייבות — תעריף בית החולים.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://www.mymc.co.il/main-departments/psychiatric-day-care/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"03-5775417","phoneLabel":"מחלקה","phoneShowNumber":true,"phone2":"03-5771111","phoneLabel2":"מוקד","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"נבדק 12.10.2026 מול דף טיפול היום באתר מעייני הישועה. כתובת בית החולים, בדף ההגעה שלהם: הרב פוברסקי 17, בני ברק. טלפון מוקד 03-5771111. טלפון המחלקה 03-5775417 לפי טבלת מילם, לא בדף היחידה. פסקת המימון בדף מתייחסת למרפאות החוץ הפסיכיאטריות של המרכז. הסיכה היא צומת בית החולים ב-OSM (משה פרדו 17), לא מרכז רחוב פוברסקי בלי מספר."}'::jsonb,
  '[{"label":"בני ברק","address":"הרב פוברסקי 17, בני ברק","lat":32.0850714,"lng":34.8445708,"phone":"03-5775417","email":"","sort_order":0}]'::jsonb
),
(
  '301|||טיפול יום פסיכיאטרי בשני שלבים',
  301,
  'רמב_ם_היחידה_לטיפול_יום_301',
  '{"org":"רמב״ם — היחידה לטיפול יום","svc":"טיפול יום פסיכיאטרי בשני שלבים","target":"","region":"חיפה","cost":"","specialty":"","languages":"","diseases":"","notes":"שלב א׳: שלושה ימים (ב׳, ג׳, ה׳) כ־8–10 שבועות. שלב ב׳: שני ימים (א׳, ד׳) כ־10–12 שבועות. בכל יום 2–3 קבוצות, ארוחת בוקר וצהריים. הטלפון מופיע בטבלת מילם, לא בדף היחידה באתר רמב״ם.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://www.rambam.org.il/departmentsandclinics/mental-health-division/day-care-unit/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"04-8543030","phoneLabel":"לפי טבלת מילם","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"נבדק 12.10.2026 מול דף היחידה לטיפול יום באתר רמב״ם. שני שלבים כמתואר בכרטיס. דף היחידה לא מציין טלפון, הפניה או מימון. 04-8543030 לפי טבלת מילם בלבד. הסיכה היא בניין רמב״ם שכבר במדריך: העלייה השניה 8, בת גלים."}'::jsonb,
  '[{"label":"חיפה","address":"העלייה השניה 8, בת גלים, חיפה","lat":32.833216,"lng":34.985726,"phone":"04-8543030","email":"","sort_order":0}]'::jsonb
),
(
  '302|||טיפול יום פסיכיאטרי, חמישה ימים בשבוע',
  302,
  'הלל_יפה_יחידת_טיפול_יום_מבוגרים_302',
  '{"org":"הלל יפה — יחידת טיפול יום מבוגרים","svc":"טיפול יום פסיכיאטרי, חמישה ימים בשבוע","target":"מגיל 18","region":"חדרה","cost":"","specialty":"","languages":"","diseases":"","notes":"טיפול כוללני: פסיכותרפיה, עבודה סוציאלית, שיקום, ריפוי בעיסוק, אומנויות, DBT ומעקב רפואי. נדרשת הפניה מהפסיכיאטר המטפל או גורם מוסמך אחר בבריאות הנפש, וטופס התחייבות. היחידה בחלק הדרום-מערבי של בית החולים.","tags":"","whatsapp":"","whatsappLabel":"","email":"psycho@hymc.gov.il","web":"https://hymc.org.il/?CategoryID=234","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"04-7744717","phoneLabel":"","phoneShowNumber":true,"phone2":"04-7748588","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"נבדק 12.10.2026 מול עמוד מערך הפסיכיאטריה בהלל יפה (CategoryID=234), פסקת היחידה לטיפול יום מבוגרים. מגיל 18, חמישה ימים, הפניה מפסיכיאטר או גורם מוסמך אחר, וטופס התחייבות. טלפונים 04-7744717 ו-04-7748588, psycho@hymc.gov.il. אין רחוב בדף; הסיכה היא בית החולים הלל יפה בחדרה (OSM), לא נקודה אחרת בעיר ששמה דומה."}'::jsonb,
  '[{"label":"חדרה","address":"מרכז רפואי הלל יפה, חדרה","lat":32.451638,"lng":34.8961587,"phone":"04-7744717","email":"psycho@hymc.gov.il","sort_order":0}]'::jsonb
),
(
  '303|||טיפול יום פסיכיאטרי למבוטחי כללית',
  303,
  'כללית_טיפול_יום_מבוגרים_יפו_303',
  '{"org":"כללית — טיפול יום מבוגרים, יפו","svc":"טיפול יום פסיכיאטרי למבוטחי כללית","target":"לקוחות כללית, מבוגרים","region":"יפו","cost":"פסיכיאטר: השתתפות עצמית רבעונית. פסיכולוג, עובד סוציאלי וסיעוד: ללא תשלום","specialty":"","languages":"","diseases":"","notes":"לפי כל שירות: טיפול פסיכיאטרי, פסיכותרפיה פרטנית וקבוצתית והערכה פסיכודיאגנוסטית, בהפניית רופא. המתנה ממוצעת לאינטייק: כחצי שבוע.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://www.kolsherut.org.il/p/card/c/1b891eb0","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"03-5151125","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"נבדק 12.10.2026 מול כרטיס כל שירות (יפו - טיפול יום מבוגרים, מרפאות בריאות נפש). הרבי מבכרך 5, 03-515-1125, לקוחות כללית, הפניית רופא. אין דף של כללית עצמה למרפאה הזו. הסיכה: הרב מבכרך 5 ביפו (OSM); השם בכרטיס כל שירות הוא הרבי מבכרך."}'::jsonb,
  '[{"label":"יפו","address":"הרבי מבכרך 5, תל אביב-יפו","lat":32.057815,"lng":34.765586,"phone":"03-5151125","email":"","sort_order":0}]'::jsonb
),
(
  '304|||הסבר על השירות, וטבלאות מרכזים שאין להם כרטיס נפרד',
  304,
  'רשימות_ארציות_טיפול_יום_פסיכיאטרי_304',
  '{"org":"רשימות ארציות — טיפול יום פסיכיאטרי","svc":"הסבר על השירות, וטבלאות מרכזים שאין להם כרטיס נפרד","target":"","region":"כל הארץ","cost":"","specialty":"","languages":"","diseases":"","notes":"טיפול יום הוא מסגרת בקהילה, בדרך כלל 3–5 ימים בשבוע, כדי למנוע אשפוז מלא. אשפוז יום הוא המשך קצר באותה מחלקה אחרי אשפוז מלא. זכאות: מכבי https://www.maccabi4u.co.il/eligibilites/64533/?id=1449 ולאומית https://leumit.co.il/mental-health-arena/outpatient-psychiatric-clinics/ . טבלת מילם ופורטל בריאות הנפש מונים גם גהה, שלוותה, קפלן, אברבנאל, ברזילי, סורוקה ומרכזים נוספים, בלי דף תכנית עדכני, ולכן אין להם כרטיס נפרד.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://me.health.gov.il/mental-health/therapy-rehabilitation/public-care/community-treatment/psychiatric-day-care/","webLabel":"משרד הבריאות","web2":"https://www.kolzchut.org.il/he/%D7%9E%D7%A1%D7%92%D7%A8%D7%AA_%D7%98%D7%99%D7%A4%D7%95%D7%9C_%D7%99%D7%95%D7%9D_%D7%9C%D7%9E%D7%AA%D7%9E%D7%95%D7%93%D7%93%D7%99_%D7%A0%D7%A4%D7%A9","webLabel2":"כל זכות","add":"https://www.milam.org.il/%D7%9E%D7%97%D7%9C%D7%A7%D7%95%D7%AA-%D7%98%D7%99%D7%A4%D7%95%D7%9C-%D7%99%D7%95%D7%9D/","addLabel":"טבלת מילם","phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"כרטיס מפנה בלבד, בלי להעתיק שורות מטבלאות. משרד הבריאות (28.4.2026) מבדיל טיפול יום בקהילה מאשפוז יום שאחרי אשפוז מלא. כל זכות מתאר את הזכות. טבלת מילם ופורטל mh-israel מונים מרכזים נוספים (גהה, שלוותה, קפלן, לוד, זיו, העמק, מזור/מזרע, באר שבע, ברזילי, סורוקה, אברבנאל, בארי 5, הצבי 9) בלי דף תכנית עדכני — לא קיבלו כרטיס. מכבי ולאומית מתארות זכאות, לא כתובת."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
VALUES
  (297, 'מעון_ירושלים_המרכז_הירושלמי_לבריאות_הנפש_297', 'ארנונה', 'קורא הדורות 24, ארנונה, ירושלים', 31.7497053, 35.2224201, 0),
  (298, 'ויניק_טלביה_כללית_298', 'טלביה', 'בנימין דישראלי 17, טלביה, ירושלים', 31.7699805, 35.2199557, 0),
  (299, 'איכילוב_טיפול_יום_נוירופסיכיאטרי_299', 'איכילוב', 'בניין השיקום, המרכז הרפואי תל אביב (איכילוב)', 32.080381, 34.790155, 0),
  (300, 'מעייני_הישועה_300', 'בני ברק', 'הרב פוברסקי 17, בני ברק', 32.0850714, 34.8445708, 0),
  (301, 'רמב_ם_היחידה_לטיפול_יום_301', 'חיפה', 'העלייה השניה 8, בת גלים, חיפה', 32.833216, 34.985726, 0),
  (302, 'הלל_יפה_יחידת_טיפול_יום_מבוגרים_302', 'חדרה', 'מרכז רפואי הלל יפה, חדרה', 32.451638, 34.8961587, 0),
  (303, 'כללית_טיפול_יום_מבוגרים_יפו_303', 'יפו', 'הרבי מבכרך 5, תל אביב-יפו', 32.057815, 34.765586, 0)
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

COMMIT;
