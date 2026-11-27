-- Migration 155 (27 Nov 2026)
-- Ministry of Health card wording.
-- Wording approved on 27.11.2026.
-- Row 15 matches the emotional-support list only. Kol Lekulam shares the row and stays as it is.
-- The ministry page for that list did not open. The card points at the same address.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

CREATE TEMP TABLE moh_wording (
  row_id integer NOT NULL,
  unique_row boolean NOT NULL,
  old_key text NOT NULL,
  new_key text NOT NULL,
  fields jsonb NOT NULL,
  en jsonb NOT NULL,
  note text NOT NULL
);

INSERT INTO moh_wording (row_id, unique_row, old_key, new_key, fields, en, note)
VALUES
  (6, true, '6|||שירותי סל שיקום', '6|||שיקום בקהילה לזכאי סל שיקום: דיור, תעסוקה וחברה. במרכז או בקהילה.', '{"org":"אנוש","svc":"שיקום בקהילה לזכאי סל שיקום: דיור, תעסוקה וחברה. במרכז או בקהילה.","target":"זכאי סל שיקום","region":"כל הארץ","cost":"סל שיקום","specialty":"","approaches":"","languages":"","diseases":"","notes":"מילם, למשפחות, בכרטיס נפרד.","meeting":"in_person","web":"https://www.enosh.org.il/","add":"","addLabel":"","phone":"*5873","phoneLabel":"מרכז מידע","phoneShowNumber":false,"phone2":"074-7556155","phoneLabel2":"מרכז מידע","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"phone4":"","phoneLabel4":"","phoneShowNumber4":false,"phone5":"","phoneLabel5":"","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":false,"email":"info@enosh.org.il","emailLabel":"אימייל","emailShowAddress":false}'::jsonb, '{"org":"Enosh","svc":"Community rehabilitation for a person eligible for the rehabilitation basket: housing, employment, and community. At a center or in the community.","target":"A person eligible for the rehabilitation basket","region":"Nationwide","cost":"The rehabilitation basket","notes":"Milam, for families, is on a separate card.","meeting":"in_person","phone":"*5873","phoneLabel":"Information center","phone2":"074-7556155","phoneLabel2":"Information center","phone3":"","phoneLabel3":"","phone4":"","phoneLabel4":"","phone5":"","phoneLabel5":"","phone6":"","phoneLabel6":"","email":"info@enosh.org.il","emailLabel":"Email"}'::jsonb, '27.11.2026: נבדק מול https://www.enosh.org.il/, עמוד יצירת הקשר ומרכז המידע. *5873 ו-074-7556155. המשפט שהמרכז אינו קו חירום לא עלה לכרטיס. הניסוח אושר עם אצוות משרד הבריאות.'),
  (7, true, '7|||שירותי סל שיקום', '7|||דיור מוגן ותעסוקה למתמודדים. בקהילה.', '{"org":"קידום","svc":"דיור מוגן ותעסוקה למתמודדים. בקהילה.","target":"זכאי סל שיקום","region":"כל הארץ","founded":"2002","cost":"סל שיקום","specialty":"","approaches":"","languages":"","diseases":"","notes":"המשרד בקויפמן 6, תל אביב.","meeting":"in_person","web":"https://kidumpro.co.il/","add":"","addLabel":"","phone":"1-800-800-747","phoneLabel":"טלפון","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"phone4":"","phoneLabel4":"","phoneShowNumber4":false,"phone5":"","phoneLabel5":"","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":false}'::jsonb, '{"org":"Kidum","svc":"Protected housing and employment for people coping with a mental illness. In the community.","target":"A person eligible for the rehabilitation basket","region":"Nationwide","founded":"2002","cost":"The rehabilitation basket","notes":"The office is at 6 Kaufman, Tel Aviv.","meeting":"in_person","phone":"1-800-800-747","phoneLabel":"Phone","phone2":"","phoneLabel2":"","phone3":"","phoneLabel3":"","phone4":"","phoneLabel4":"","phone5":"","phoneLabel5":"","phone6":"","phoneLabel6":""}'::jsonb, '27.11.2026: נבדק מול https://kidumpro.co.il/. הוקם 2002. הפקס ירד. העמוד מתאר שיקום בקהילה, בלי מחירון. הניסוח אושר עם אצוות משרד הבריאות.'),
  (8, true, '8|||שירותי סל שיקום', '8|||דיור, תעסוקה, חונכות וסומכות לזכאי סל שיקום. בבית.', '{"org":"ידיד נפש","svc":"דיור, תעסוקה, חונכות וסומכות לזכאי סל שיקום. בבית.","target":"זכאי סל שיקום","region":"כל הארץ","cost":"סל שיקום","specialty":"","approaches":"","languages":"","diseases":"","notes":"גם בית מאזן בבאר שבע. עמית עד הבית הוא ליווי פרטי.","meeting":"in_person","web":"https://yadidnefesh.co.il/","add":"","addLabel":"","phone":"*2091","phoneLabel":"טלפון","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"phone4":"","phoneLabel4":"","phoneShowNumber4":false,"phone5":"","phoneLabel5":"","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":false}'::jsonb, '{"org":"Yadid Nefesh","svc":"Housing, employment, mentoring, and support for a person eligible for the rehabilitation basket. At home.","target":"A person eligible for the rehabilitation basket","region":"Nationwide","cost":"The rehabilitation basket","notes":"Also a balancing home in Beer Sheva. Amit ad Habayit is private accompaniment.","meeting":"in_person","phone":"*2091","phoneLabel":"Phone","phone2":"","phoneLabel2":"","phone3":"","phoneLabel3":"","phone4":"","phoneLabel4":"","phone5":"","phoneLabel5":"","phone6":"","phoneLabel6":""}'::jsonb, '27.11.2026: נבדק מול עמודי החונכות והסומכות באתר ידיד נפש. *2091. הפקס ומספרי הרכזים לא עלו. הניסוח אושר עם אצוות משרד הבריאות.'),
  (9, true, '9|||שירותי סל שיקום', '9|||ליווי בדיור בקהילה ובתעסוקה, לזכאי סל שיקום. בקהילה.', '{"org":"אור לנפש","svc":"ליווי בדיור בקהילה ובתעסוקה, לזכאי סל שיקום. בקהילה.","target":"זכאי סל שיקום","region":"ירושלים, בית שמש, מודיעין, קריית ספר, חשמונאים","cost":"סל שיקום","specialty":"","approaches":"","languages":"","diseases":"","notes":"גם שלוחה חרדית בצפון. גם למי שאינו בסל, ולפונים מחו״ל. המשרד בהצבי 11, ירושלים. גם בוואטסאפ, מהכפתור באתר.","meeting":"in_person","web":"https://orlanefesh.org.il/","add":"","addLabel":"","phone":"02-6223294","phoneLabel":"טלפון","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"phone4":"","phoneLabel4":"","phoneShowNumber4":false,"phone5":"","phoneLabel5":"","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":false,"email":"orlenefesh@bezeqint.net","emailLabel":"אימייל","emailShowAddress":false}'::jsonb, '{"org":"Or Lanefesh","svc":"Accompaniment in community housing and in employment, for a person eligible for the rehabilitation basket. In the community.","target":"A person eligible for the rehabilitation basket","region":"Jerusalem, Beit Shemesh, Modiin, Kiryat Sefer, Hashmonaim","cost":"The rehabilitation basket","notes":"Also a Haredi branch in the north. Also for a person who is not in the basket, and for people calling from abroad. The office is at 11 HaTzvi, Jerusalem. Also on WhatsApp, from the button on the site.","meeting":"in_person","phone":"02-6223294","phoneLabel":"Phone","phone2":"","phoneLabel2":"","phone3":"","phoneLabel3":"","phone4":"","phoneLabel4":"","phone5":"","phoneLabel5":"","phone6":"","phoneLabel6":"","email":"orlenefesh@bezeqint.net","emailLabel":"Email"}'::jsonb, '27.11.2026: נבדק מול עמוד סל השיקום ועמוד יצירת הקשר. השעות לא עלו. אין מספר וואטסאפ מפורסם. הניסוח אושר עם אצוות משרד הבריאות.'),
  (15, false, '15|||מרכזי תמיכה רגשית ונפשית
', '15|||רשימת מרכזי תמיכה רגשית ונפשית.', '{"org":"משרד הבריאות, מינהל בריאות הנפש","svc":"רשימת מרכזי תמיכה רגשית ונפשית.","target":"","region":"","cost":"","specialty":"","approaches":"","languages":"","diseases":"","notes":"מרכזי החוסן, מוקדי הקופות והקווים עצמם בכרטיסים נפרדים.","meeting":"","web":"https://www.gov.il/he/pages/emotional-support-centers","add":"","addLabel":"","phone":"","phoneLabel":"","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"phone4":"","phoneLabel4":"","phoneShowNumber4":false,"phone5":"","phoneLabel5":"","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":false}'::jsonb, '{"org":"Mental Health Division, Ministry of Health","svc":"A list of emotional and mental support centers.","notes":"The resilience centers, the health-fund lines, and the lines themselves are on separate cards.","phone":"","phoneLabel":"","phone2":"","phoneLabel2":"","phone3":"","phoneLabel3":"","phone4":"","phoneLabel4":"","phone5":"","phoneLabel5":"","phone6":"","phoneLabel6":""}'::jsonb, '27.11.2026: עמוד https://www.gov.il/he/pages/emotional-support-centers לא נפתח. ידיעות מ-2026 מפנות ממנו למרכזי החוסן ולמוקדי הקופות, שכבר בכרטיסים נפרדים. קול לכולם באותה שורה לא נגע. הניסוח אושר עם אצוות משרד הבריאות.'),
  (35, true, '35|||אינדקס פסיכולוגים מורשים', '35|||אינדקס פסיכולוגים מורשים.', '{"org":"משרד הבריאות","svc":"אינדקס פסיכולוגים מורשים.","target":"","region":"","cost":"","specialty":"","approaches":"","languages":"","diseases":"","notes":"המאגר מעודכן ל-25.11.2026. המשרד ממליץ לבקש הצגת רישיון מומחה לפני טיפול.","meeting":"","web":"https://registries.health.gov.il/Practitioners/27","add":"","addLabel":"","phone":"","phoneLabel":"","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"phone4":"","phoneLabel4":"","phoneShowNumber4":false,"phone5":"","phoneLabel5":"","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":false}'::jsonb, '{"org":"Ministry of Health","svc":"An index of licensed psychologists.","notes":"The registry was updated on 25.11.2026. The ministry recommends asking to see a specialist license before treatment.","phone":"","phoneLabel":"","phone2":"","phoneLabel2":"","phone3":"","phoneLabel3":"","phone4":"","phoneLabel4":"","phone5":"","phoneLabel5":"","phone6":"","phoneLabel6":""}'::jsonb, '27.11.2026: נבדק מול https://registries.health.gov.il/Practitioners/27, מעודכן 25.11.2026. מקצוע 27 הוא פסיכולוגים. *5400 הוא מוקד המשרד, ולא עלה. הניסוח אושר עם אצוות משרד הבריאות.'),
  (36, true, '36|||אינדקס משרד הבריאות - מהפנטים בעלי רשיון', '36|||אינדקס מהפנטים בעלי רישיון.', '{"org":"משרד הבריאות","svc":"אינדקס מהפנטים בעלי רישיון.","target":"","region":"","cost":"","specialty":"","approaches":"","languages":"","diseases":"","notes":"","meeting":"","web":"https://practitioners.health.gov.il/Hypnotists/901","add":"","addLabel":"","phone":"","phoneLabel":"","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"phone4":"","phoneLabel4":"","phoneShowNumber4":false,"phone5":"","phoneLabel5":"","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":false}'::jsonb, '{"org":"Ministry of Health","svc":"An index of licensed hypnotists.","phone":"","phoneLabel":"","phone2":"","phoneLabel2":"","phone3":"","phoneLabel3":"","phone4":"","phoneLabel4":"","phone5":"","phoneLabel5":"","phone6":"","phoneLabel6":""}'::jsonb, '27.11.2026: עמוד המאגר לא החזיר טקסט. הכתובת היא אינדקס המהפנטים של משרד הבריאות. הניסוח אושר עם אצוות משרד הבריאות.'),
  (52, true, '52|||מרכזי ייעוץ, הכוונה, סיוע והדרכה למשפחות מתמודדים', '52|||ייעוץ, הכוונה וסיוע לבני משפחה של מתמודדי נפש. במרכז.', '{"org":"מילם","svc":"ייעוץ, הכוונה וסיוע לבני משפחה של מתמודדי נפש. במרכז.","target":"בני משפחה של מתמודדי נפש","region":"כל הארץ","cost":"ללא עלות","specialty":"","approaches":"","languages":"","diseases":"","notes":"מופעל על ידי אנוש, במימון ובפיקוח של משרד הבריאות. אין צורך בסל שיקום. יש גם מפגשים מרחוק. אנוש בכרטיס נפרד.","meeting":"in_person","web":"https://www.milam.org.il/","add":"","addLabel":"","phone":"*5873","phoneLabel":"מרכז מידע","phoneShowNumber":false,"phone2":"074-7556155","phoneLabel2":"מרכז מידע","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"phone4":"","phoneLabel4":"","phoneShowNumber4":false,"phone5":"","phoneLabel5":"","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":false,"email":"info@enosh.org.il","emailLabel":"אימייל","emailShowAddress":false}'::jsonb, '{"org":"Milam","svc":"Counseling, guidance, and assistance for family members of people coping with mental illness. At a center.","target":"Family members of people coping with mental illness","region":"Nationwide","cost":"At no cost","notes":"Operated by Enosh, funded and supervised by the Ministry of Health. A rehabilitation basket is not required. There are also remote meetings. Enosh is on a separate card.","meeting":"in_person","phone":"*5873","phoneLabel":"Information center","phone2":"074-7556155","phoneLabel2":"Information center","phone3":"","phoneLabel3":"","phone4":"","phoneLabel4":"","phone5":"","phoneLabel5":"","phone6":"","phoneLabel6":"","email":"info@enosh.org.il","emailLabel":"Email"}'::jsonb, '27.11.2026: נבדק מול https://www.milam.org.il/ ועמוד יצירת הקשר. ללא עלות, בלי סל שיקום. השעות ומספרי הסניפים לא עלו. המשפט שזה אינו קו חירום לא עלה לכרטיס. הניסוח אושר עם אצוות משרד הבריאות.'),
  (62, true, '62|||מרפאות לבריאות הנפש
', '62|||אבחון וטיפול נפשי, בצוות של פסיכיאטרים, פסיכולוגים ועובדים סוציאליים. במרפאה.', '{"org":"מרפאות בית חם","svc":"אבחון וטיפול נפשי, בצוות של פסיכיאטרים, פסיכולוגים ועובדים סוציאליים. במרפאה.","target":"מבוגרים וילדים","region":"ירושלים, בית שמש, בני ברק, אלעד, מעלה אדומים","cost":"בהסדר עם קופות החולים.","specialty":"","approaches":"","languages":"","diseases":"","notes":"גם תוכנית נוויגייט אחרי משבר פסיכוטי ראשון. הכתובת והטלפון של כל סניף בדף המרפאות. קו קשובים והעמותה בכרטיסים נפרדים.","meeting":"in_person","web":"https://www.bayit-cham.org.il/%d7%9e%d7%a8%d7%a4%d7%90%d7%aa-%d7%93%d7%a8%d7%95%d7%a8/","add":"","addLabel":"","phone":"1599-510-550","phoneLabel":"מרפאות","phoneShowNumber":false,"phone2":"*9518","phoneLabel2":"ייעוץ","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"phone4":"","phoneLabel4":"","phoneShowNumber4":false,"phone5":"","phoneLabel5":"","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":false}'::jsonb, '{"org":"Bayit Cham clinics","svc":"Mental-health assessment and treatment, by a team of psychiatrists, psychologists, and social workers. At the clinic.","target":"Adults and children","region":"Jerusalem, Beit Shemesh, Bnei Brak, Elad, Maale Adumim","cost":"By arrangement with the health funds.","notes":"Also the Navigate program after a first psychotic crisis. The address and the phone of each branch are on the clinics page. Keshuviim and the association are on separate cards.","meeting":"in_person","phone":"1599-510-550","phoneLabel":"Clinics","phone2":"*9518","phoneLabel2":"Counseling","phone3":"","phoneLabel3":"","phone4":"","phoneLabel4":"","phone5":"","phoneLabel5":"","phone6":"","phoneLabel6":""}'::jsonb, '27.11.2026: נבדק מול עמוד המרפאות של בית חם. מספרי המנהלים לא עלו. יהודה המכבי 15 מופיע בלי שם עיר. הניסוח אושר עם אצוות משרד הבריאות.'),
  (78, true, '78|||המרכז מעניק רצף טיפולי למגוון הפרעות הנפש, בכל הגילאים, למצבים פסיכוטיים חריפים, מצבים ממושכים עם דגש שיקומי ושירות קהילתי. מערך הטיפול כולל את כל סוגי הטיפולים הביולוגיים המקובלים (תרופות חדישות לסוגיהן, חדר סנוסלן – גרייה רב חושית ונזעי חשמל), טיפול זוגי ומשפחתי, פסיכותראפיה פרטנית וקבוצתית, טיפול באומנות וריפוי בעיסוק.', '78|||בית חולים פסיכיאטרי ממשלתי, וגם מרפאות בקהילה. בבית החולים או במרפאה.', '{"org":"המרכז הירושלמי לבריאות הנפש","svc":"בית חולים פסיכיאטרי ממשלתי, וגם מרפאות בקהילה. בבית החולים או במרפאה.","target":"","region":"ירושלים","cost":"","specialty":"","approaches":"","languages":"","diseases":"","notes":"שני קמפוסים, כפר שאול ואיתנים. כפר שאול פועל משנת 1951. יש גם טיפול בנזעי חשמל.","meeting":"in_person","web":"https://www.psjer.org.il/","add":"","addLabel":"","phone":"1599-50-60-80","phoneLabel":"טלפון","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"phone4":"","phoneLabel4":"","phoneShowNumber4":false,"phone5":"","phoneLabel5":"","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":false}'::jsonb, '{"org":"Jerusalem Mental Health Center","svc":"A government psychiatric hospital, and also community clinics. At the hospital or at a clinic.","region":"Jerusalem","notes":"Two campuses, Kfar Shaul and Eitanim. Kfar Shaul has operated since 1951. There is also electroconvulsive treatment.","meeting":"in_person","phone":"1599-50-60-80","phoneLabel":"Phone","phone2":"","phoneLabel2":"","phone3":"","phoneLabel3":"","phone4":"","phoneLabel4":"","phone5":"","phoneLabel5":"","phone6":"","phoneLabel6":""}'::jsonb, '27.11.2026: נבדק מול https://www.psjer.org.il/. רשימת היישובים לא הייתה בעמוד הבית. שנת 1951 היא של קמפוס כפר שאול, והיא נשארה בהערות. הניסוח אושר עם אצוות משרד הבריאות.'),
  (278, true, '278|||שירותי סל שיקום', '278|||שיקום תעסוקתי, דיור בקהילה וחונכות. במרכז או בקהילה.', '{"org":"האגודה לבריאות הציבור","svc":"שיקום תעסוקתי, דיור בקהילה וחונכות. במרכז או בקהילה.","target":"מתמודדים וזכאי שיקום","region":"כל הארץ","cost":"משרד הבריאות, משרד הרווחה, או משרד הביטחון","specialty":"","approaches":"","languages":"","diseases":"","notes":"המשרד בכפר עציון 27, ירושלים.","meeting":"in_person","web":"https://www.aguda.co.il/service-categories/%d7%a9%d7%99%d7%a7%d7%95%d7%9d-%d7%95%d7%97%d7%95%d7%a0%d7%9b%d7%95%d7%aa/","add":"","addLabel":"","phone":"02-5656900","phoneLabel":"מוקד","phoneShowNumber":false,"phone2":"077-900-2283","phoneLabel2":"מחוץ לשעות","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"phone4":"","phoneLabel4":"","phoneShowNumber4":false,"phone5":"","phoneLabel5":"","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":false}'::jsonb, '{"org":"The Association for Public Health","svc":"Vocational rehabilitation, community housing, and mentoring. At a center or in the community.","target":"People coping with mental illness, and people eligible for rehabilitation","region":"Nationwide","cost":"The Ministry of Health, the Ministry of Welfare, or the Ministry of Defense","notes":"The office is at 27 Kfar Etzion, Jerusalem.","meeting":"in_person","phone":"02-5656900","phoneLabel":"Call center","phone2":"077-900-2283","phoneLabel2":"Outside hours","phone3":"","phoneLabel3":"","phone4":"","phoneLabel4":"","phone5":"","phoneLabel5":"","phone6":"","phoneLabel6":""}'::jsonb, '27.11.2026: נבדק מול עמוד השיקום והחונכות ועמוד יצירת הקשר. 050-3099911 לא היה בעמוד, וירד. השעות לא עלו. הניסוח אושר עם אצוות משרד הבריאות.'),
  (283, true, '283|||שיקום תעסוקתי, תעסוקה נתמכת ויזמות — כולל תוכנית צרכנים נותני שירות', '283|||שיקום תעסוקתי, תעסוקה נתמכת ויזמות. בליווי.', '{"org":"יוזמה דרך הלב","svc":"שיקום תעסוקתי, תעסוקה נתמכת ויזמות. בליווי.","target":"זכאי סל שיקום","region":"כל הארץ","cost":"סל שיקום","specialty":"","approaches":"","languages":"","diseases":"","notes":"תע״ש 20, כפר סבא. רמב״ם 4, באר שבע. גם תוכנית צרכנים נותני שירות.","meeting":"in_person","web":"https://www.yozma4u.co.il/","add":"","addLabel":"","phone":"09-7656475","phoneLabel":"כפר סבא","phoneShowNumber":false,"phone2":"08-6655462","phoneLabel2":"באר שבע","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"phone4":"","phoneLabel4":"","phoneShowNumber4":false,"phone5":"","phoneLabel5":"","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":false}'::jsonb, '{"org":"Yozma Derech Halev","svc":"Vocational rehabilitation, supported employment, and entrepreneurship. With accompaniment.","target":"A person eligible for the rehabilitation basket","region":"Nationwide","cost":"The rehabilitation basket","notes":"20 Taas, Kfar Saba. 4 Rambam, Beer Sheva. Also a program of people who use the service and provide a service.","meeting":"in_person","phone":"09-7656475","phoneLabel":"Kfar Saba","phone2":"08-6655462","phoneLabel2":"Beer Sheva","phone3":"","phoneLabel3":"","phone4":"","phoneLabel4":"","phone5":"","phoneLabel5":"","phone6":"","phoneLabel6":""}'::jsonb, '27.11.2026: נבדק מול https://www.yozma4u.co.il/. נכי צה״ל לא היו בעמוד הבית, וירדו מהקהל. השעות לא עלו. הניסוח אושר עם אצוות משרד הבריאות.');

UPDATE site_audit_entries s
SET card_keys = (
  SELECT COALESCE(array_agg(
    COALESCE((SELECT w.new_key FROM moh_wording w WHERE w.old_key = k), k)
    ORDER BY ord
  ), '{}')
  FROM unnest(s.card_keys) WITH ORDINALITY AS u(k, ord)
)
WHERE EXISTS (
  SELECT 1
  FROM unnest(s.card_keys) k
  JOIN moh_wording w ON w.old_key = k
);

UPDATE directory_card_edits c
SET card_key = w.new_key,
    public_fields = COALESCE(c.public_fields, '{}'::jsonb) || w.fields,
    translations = jsonb_set(
      COALESCE(c.translations, '{}'::jsonb),
      '{en}',
      COALESCE(c.translations->'en', '{}'::jsonb) || w.en,
      true
    ),
    eligibility = jsonb_set(
      COALESCE(c.eligibility, '{}'::jsonb),
      '{internal_notes}',
      to_jsonb(
        CASE
          WHEN COALESCE(c.eligibility->>'internal_notes', '') = '' THEN w.note
          ELSE rtrim(c.eligibility->>'internal_notes') || E'\n\n' || w.note
        END
      ),
      true
    ),
    public_edited_at = now(),
    updated_at = now()
FROM moh_wording w
WHERE c.card_key = w.old_key
   OR (
     w.unique_row
     AND c.row_id = w.row_id
     AND (SELECT count(*) FROM directory_card_edits d WHERE d.row_id = w.row_id) = 1
   );

UPDATE directory_entries e
SET display_name = c.public_fields->>'org',
    description = c.public_fields->>'svc'
FROM directory_card_edits c
JOIN moh_wording w ON w.new_key = c.card_key
WHERE e.entry_id = c.entry_id;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-27-moh-wording',
  DATE '2026-11-27',
  'עודכן הניסוח בכרטיסי משרד הבריאות',
  'בכרטיסי משרד הבריאות נכתב עכשיו מה השירות, ומי פונה.',
  'cards',
  ARRAY[
  '6|||שיקום בקהילה לזכאי סל שיקום: דיור, תעסוקה וחברה. במרכז או בקהילה.',
  '7|||דיור מוגן ותעסוקה למתמודדים. בקהילה.',
  '8|||דיור, תעסוקה, חונכות וסומכות לזכאי סל שיקום. בבית.',
  '9|||ליווי בדיור בקהילה ובתעסוקה, לזכאי סל שיקום. בקהילה.',
  '15|||רשימת מרכזי תמיכה רגשית ונפשית.',
  '35|||אינדקס פסיכולוגים מורשים.',
  '36|||אינדקס מהפנטים בעלי רישיון.',
  '52|||ייעוץ, הכוונה וסיוע לבני משפחה של מתמודדי נפש. במרכז.',
  '62|||אבחון וטיפול נפשי, בצוות של פסיכיאטרים, פסיכולוגים ועובדים סוציאליים. במרפאה.',
  '78|||בית חולים פסיכיאטרי ממשלתי, וגם מרפאות בקהילה. בבית החולים או במרפאה.',
  '278|||שיקום תעסוקתי, דיור בקהילה וחונכות. במרכז או בקהילה.',
  '283|||שיקום תעסוקתי, תעסוקה נתמכת ויזמות. בליווי.'
  ],
  '{}',
  '155_moh_wording.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
