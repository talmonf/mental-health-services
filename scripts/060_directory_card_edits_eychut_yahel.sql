-- Migration 060 (15 Oct 2026)
-- directory_card_edits + directory_entry_locations: מרכז יה״ל (row 66)
-- and איכות בשיקום (row 67).
-- Yahel: family counseling, October 7 family support, evening helpline,
-- Jerusalem WhatsApp, and a pin per center that has a street.
-- The association card lists housing, employment, Yahalom, and the family service,
-- with those sites plus the Yahel centers.
-- Kiryat Malachi has no street, so it stays in the notes.
-- House pins: Ashdod, Hadera, Haifa, Jerusalem, Modiin, Petah Tikva.
-- Street pins, because OSM has no house number: Ashkelon, Harish, Kfar Saba,
-- Rishon LeZion, Ramla, and both Holon streets.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_entries
SET display_name = 'מרכז יה״ל - ייעוץ והכוונה למשפחות',
    description = 'ייעוץ והכוונה למשפחות בתחום בריאות הנפש, וליווי לבני משפחה של שורדי מסיבות ה-7.10',
    referral_codes = ARRAY['self_referral']::text[]
WHERE entry_id = 'מרכז_יה_ל_ייעוץ_והכוונה_למשפחות_66'
  AND display_name = 'מרכז יה״ל- ייעוץ והכוונה למשפחות';

UPDATE directory_entries
SET description = 'דיור בקהילה, תעסוקה נתמכת, מרכזי יה״ל למשפחות, קו סיוע ויהלו״ם',
    referral_codes = ARRAY['rehab_basket_committee', 'mod_rehab_worker']::text[]
WHERE entry_id = 'איכות_בשיקום_67'
  AND description = 'סיוע למתמודדי נפש דרך שילובם בקהילה תוך ליווי מקצועי אישי';

UPDATE directory_card_edits
SET public_fields = '{"org":"מרכז יה״ל - ייעוץ והכוונה למשפחות","svc":"ייעוץ והכוונה למשפחות בתחום בריאות הנפש, וליווי לבני משפחה של שורדי מסיבות ה-7.10","target":"בני משפחה של מתמודדי נפש (הורים, בני זוג, אחים, ילדים ואדם משמעותי אחר), וכן בני משפחה של שורדי מסיבות ה-7.10","region":"פריסה ארצית. קריית מלאכי: 08-9333858, בלי כתובת רחוב באתר","cost":"ללא עלות, בלי הפניה","specialty":"","languages":"","diseases":"","notes":"ייעוץ פרטני, קבוצות, הרצאות וסדנאות, מפגש עם בן משפחה מניסיון, ייעוץ משפטי ומועדון משפחות. לבני משפחה של שורדי מסיבות ה-7.10: ייעוץ וליווי רגשי, מקום לשיח, סיוע במיצוי זכויות וכלים להתמודדות, במפגשים פרטניים וקבוצתיים. קו סיוע בערבים 18:00–22:00. ירושלים גם בוואטסאפ. דיור, תעסוקה ויהלו״ם בכרטיס [איכות בשיקום](https://nefesh-il.org/rights?entry=67&section=rehabilitation).","tags":"חרבות ברזל","whatsapp":"972524917126","whatsappLabel":"ירושלים","web":"https://eychut.org.il/","webLabel":"","web2":"https://eychut.org.il/%D7%9E%D7%A8%D7%9B%D7%96-%D7%99%D7%94%D7%B4%D7%9C-%D7%99%D7%99%D7%A2%D7%95%D7%A5-%D7%95%D7%94%D7%9B%D7%95%D7%95%D7%A0%D7%94-%D7%9C%D7%9E%D7%A9%D7%A4%D7%97%D7%95%D7%AA-2/","webLabel2":"מרכז יה״ל","add":"https://www.facebook.com/eychut/","addLabel":"פייסבוק","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"03-9559596","phoneLabel":"קו סיוע בערבים","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
    sites = '[
      {"label":"אשדוד","address":"הרצל 1, אשדוד","lat":31.7934938,"lng":34.6403679,"phone":"08-9333858","email":"Yahela@eychut.org.il","sort_order":0},
      {"label":"אשקלון","address":"ברל כצנלסון 13, אשקלון","lat":31.661716,"lng":34.5874506,"phone":"08-9999229","email":"yahelash@eychut.org.il","sort_order":1},
      {"label":"חדרה","address":"סמטת פלטרין 6, חדרה","lat":32.43693,"lng":34.92021,"phone":"04-6367686","email":"yahelh@eychut.org.il","sort_order":2},
      {"label":"חיפה","address":"שדרות פלי״ם 2, חיפה","lat":32.8167554,"lng":35.0000812,"phone":"04-9994242","email":"yahelhai@eychut.org.il","sort_order":3},
      {"label":"חריש","address":"אלה 2, חריש","lat":32.4645487,"lng":35.0387759,"phone":"04-6367686","email":"yahelh@eychut.org.il","sort_order":4},
      {"label":"ירושלים","address":"יפו 216, ירושלים","lat":31.7890021,"lng":35.2053137,"phone":"02-9999925","email":"yahelj@eychut.org.il","sort_order":5},
      {"label":"כפר סבא","address":"התע״ש 23, אזור התעשייה, כפר סבא","lat":32.1736651,"lng":34.9258729,"phone":"09-7402223","email":"Yahelk@eychut.org.il","sort_order":6},
      {"label":"מודיעין","address":"רא״ל יגאל ידין 53, מודיעין","lat":31.9026163,"lng":35.004662,"phone":"03-7164474","email":"families@eychut.org.il","sort_order":7},
      {"label":"פתח תקווה","address":"זאב אורלוב 77, פתח תקווה","lat":32.0952565,"lng":34.8883409,"phone":"09-7402223","email":"Yahelk@eychut.org.il","sort_order":8},
      {"label":"ראשון לציון","address":"עין הקורא 10, ראשון לציון","lat":31.9659043,"lng":34.8041468,"phone":"03-7164474","email":"families@eychut.org.il","sort_order":9},
      {"label":"רמלה","address":"הרצל 45, רמלה","lat":31.9296838,"lng":34.8703195,"phone":"08-6677458","email":"families@eychut.org.il","sort_order":10}
    ]'::jsonb,
    eligibility = jsonb_set(
      jsonb_set(eligibility, '{location_mode}', '"sites"'),
      '{internal_notes}',
      to_jsonb(
        rtrim(COALESCE(eligibility->>'internal_notes', ''))
        || E'\n\n15.10.2026: נבדק מול eychut.org.il, דף מרכז יה״ל ודף המרכזים. השירות למשפחות ללא עלות ובלי הפניה, בשיתוף משרד הבריאות. קו סיוע בערבים 03-9559596, 18:00–22:00. וואטסאפ ירושלים 052-4917126 נמסר עבור הכרטיס ואינו בדף המרכזים. קריית מלאכי 08-9333858 בלי רחוב, בלי סיכה. סיכות על הבניין: אשדוד הרצל 1, חדרה פלטרין 6, חיפה שדרות פלי״ם 2, ירושלים יפו 216, מודיעין יגאל ידין 53, פתח תקווה זאב אורלוב 77. סיכות על הרחוב, כי אין מספר בית ב-OSM: אשקלון ברל כצנלסון, חריש אלה, כפר סבא התע״ש (קטע אזור התעשייה), ראשון לציון עין הקורא, רמלה שדרות הרצל. פייסבוק העמותה במקום Yahel.Families.'
      )
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '66|||ייעוץ והכוונה למשפחות בתחום בריאות הנפש · 18:00 - 22:00'
  AND public_fields->>'org' = 'מרכז יה״ל- ייעוץ והכוונה למשפחות';

UPDATE directory_card_edits
SET public_fields = '{"org":"איכות בשיקום","svc":"דיור בקהילה, תעסוקה נתמכת, מרכזי יה״ל למשפחות, קו סיוע ויהלו״ם","target":"מתמודדי נפש ובני משפחותיהם. דיור, תעסוקה ויהלו״ם: מגיל 18","region":"פריסה ארצית. קריית מלאכי: 08-9333858, בלי כתובת רחוב באתר","cost":"","specialty":"","languages":"","diseases":"","notes":"הוסטל שיקומי וקהילה תומכת: הנביאים 55 ו-55א, חולון, 03-5585887. דיור מוגן: המשביר 1, חולון, 03-9133099. שניהם מגיל 18, לזכאי סל שיקום או בהפניה ממשרד הביטחון. מרכז איתן: תעסוקה נתמכת להשתלבות בשוק החופשי, המשביר 1, 03-6722128. אישור סל שיקום לתעסוקה נתמכת, הפניה ממשרד הביטחון, או באופן פרטי. יהלו״ם: הכוונה וליווי במיצוי זכויות, כולל טפסים לוועדת סל שיקום, ליווי לפסיכיאטר ותיווך מול המשפחה והרשויות. במשביר 1, 03-5552784 שלוחה 6, ואפרת 052-7301900. הנהלה א׳–ה׳ 09:00–15:30. קו סיוע בערבים 18:00–22:00. מרכזי המשפחות, ליווי לבני משפחה של שורדי מסיבות ה-7.10, ווואטסאפ ירושלים בכרטיס [מרכז יה״ל](https://nefesh-il.org/support?entry=66&section=families).","tags":"","whatsapp":"","whatsappLabel":"","web":"https://eychut.org.il/","webLabel":"","web2":"https://eychut.org.il/centers/","webLabel2":"המרכזים","add":"https://www.facebook.com/eychut/","addLabel":"פייסבוק","email":"info@eychut.org.il","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"03-5552784","phoneLabel":"הנהלה","phoneShowNumber":true,"phone2":"03-9559596","phoneLabel2":"קו סיוע בערבים","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
    sites = '[
      {"label":"אשדוד","address":"הרצל 1, אשדוד","lat":31.7934938,"lng":34.6403679,"phone":"08-9333858","email":"Yahela@eychut.org.il","sort_order":0},
      {"label":"אשקלון","address":"ברל כצנלסון 13, אשקלון","lat":31.661716,"lng":34.5874506,"phone":"08-9999229","email":"yahelash@eychut.org.il","sort_order":1},
      {"label":"חדרה","address":"סמטת פלטרין 6, חדרה","lat":32.43693,"lng":34.92021,"phone":"04-6367686","email":"yahelh@eychut.org.il","sort_order":2},
      {"label":"חיפה","address":"שדרות פלי״ם 2, חיפה","lat":32.8167554,"lng":35.0000812,"phone":"04-9994242","email":"yahelhai@eychut.org.il","sort_order":3},
      {"label":"חריש","address":"אלה 2, חריש","lat":32.4645487,"lng":35.0387759,"phone":"04-6367686","email":"yahelh@eychut.org.il","sort_order":4},
      {"label":"ירושלים","address":"יפו 216, ירושלים","lat":31.7890021,"lng":35.2053137,"phone":"02-9999925","email":"yahelj@eychut.org.il","sort_order":5},
      {"label":"כפר סבא","address":"התע״ש 23, אזור התעשייה, כפר סבא","lat":32.1736651,"lng":34.9258729,"phone":"09-7402223","email":"Yahelk@eychut.org.il","sort_order":6},
      {"label":"מודיעין","address":"רא״ל יגאל ידין 53, מודיעין","lat":31.9026163,"lng":35.004662,"phone":"03-7164474","email":"families@eychut.org.il","sort_order":7},
      {"label":"פתח תקווה","address":"זאב אורלוב 77, פתח תקווה","lat":32.0952565,"lng":34.8883409,"phone":"09-7402223","email":"Yahelk@eychut.org.il","sort_order":8},
      {"label":"ראשון לציון","address":"עין הקורא 10, ראשון לציון","lat":31.9659043,"lng":34.8041468,"phone":"03-7164474","email":"families@eychut.org.il","sort_order":9},
      {"label":"רמלה","address":"הרצל 45, רמלה","lat":31.9296838,"lng":34.8703195,"phone":"08-6677458","email":"families@eychut.org.il","sort_order":10},
      {"label":"דיור מוגן","address":"המשביר 1, חולון","lat":32.0127722,"lng":34.8048098,"phone":"03-9133099","email":"housing@eychut.org.il","sort_order":11},
      {"label":"הוסטל וקהילה תומכת","address":"הנביאים 55 ו-55א, חולון","lat":32.01649,"lng":34.79521,"phone":"03-5585887","email":"hostel@eychut.org.il","sort_order":12},
      {"label":"מרכז איתן","address":"המשביר 1, חולון","lat":32.0127722,"lng":34.8048098,"phone":"03-6722128","email":"dorit.eitan@eychut.org.il","sort_order":13},
      {"label":"הנהלה","address":"המשביר 1, חולון","lat":32.0127722,"lng":34.8048098,"phone":"03-5552784","email":"info@eychut.org.il","sort_order":14}
    ]'::jsonb,
    eligibility = jsonb_set(
      jsonb_set(eligibility, '{location_mode}', '"sites"'),
      '{internal_notes}',
      to_jsonb(
        rtrim(COALESCE(eligibility->>'internal_notes', ''))
        || E'\n\n15.10.2026: נבדק מול דפי הדיור, הקהילה התומכת, התעסוקה הנתמכת, יהלו״ם ודף המרכזים. פסקת אוכלוסיית היעד בדף יהלו״ם חוזרת על טקסט הקהילה התומכת, ולכן הכרטיס משתמש רק בתיאור יחידת ההכוון. הוסטל וקהילה תומכת בנביאים 55, שכונת נווה ארזים. סיכת הנביאים היא על הרחוב בשכונה הזו, בלי מספר בית ב-OSM. סיכת המשביר היא על הרחוב באזור תעשייה ג, כי מספר 1 לא מתויג ויש שני קטעי רחוב. מרכז רפואי ברחוב רפאל איתן אינו מרכז איתן. קריית מלאכי בלי סיכה. מרכזי יה״ל בכרטיס 66.'
      )
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '67|||סיוע למתמודדי נפש דרך שילובם בקהילה תוך ליווי מקצועי אישי'
  AND COALESCE(public_fields->>'phone', '') = '';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT *
FROM (VALUES
  (66, 'מרכז_יה_ל_ייעוץ_והכוונה_למשפחות_66', 'אשדוד', 'הרצל 1, אשדוד', 31.7934938, 34.6403679, 0),
  (66, 'מרכז_יה_ל_ייעוץ_והכוונה_למשפחות_66', 'אשקלון', 'ברל כצנלסון 13, אשקלון', 31.661716, 34.5874506, 1),
  (66, 'מרכז_יה_ל_ייעוץ_והכוונה_למשפחות_66', 'חדרה', 'סמטת פלטרין 6, חדרה', 32.43693, 34.92021, 2),
  (66, 'מרכז_יה_ל_ייעוץ_והכוונה_למשפחות_66', 'חיפה', 'שדרות פלי״ם 2, חיפה', 32.8167554, 35.0000812, 3),
  (66, 'מרכז_יה_ל_ייעוץ_והכוונה_למשפחות_66', 'חריש', 'אלה 2, חריש', 32.4645487, 35.0387759, 4),
  (66, 'מרכז_יה_ל_ייעוץ_והכוונה_למשפחות_66', 'ירושלים', 'יפו 216, ירושלים', 31.7890021, 35.2053137, 5),
  (66, 'מרכז_יה_ל_ייעוץ_והכוונה_למשפחות_66', 'כפר סבא', 'התע״ש 23, אזור התעשייה, כפר סבא', 32.1736651, 34.9258729, 6),
  (66, 'מרכז_יה_ל_ייעוץ_והכוונה_למשפחות_66', 'מודיעין', 'רא״ל יגאל ידין 53, מודיעין', 31.9026163, 35.004662, 7),
  (66, 'מרכז_יה_ל_ייעוץ_והכוונה_למשפחות_66', 'פתח תקווה', 'זאב אורלוב 77, פתח תקווה', 32.0952565, 34.8883409, 8),
  (66, 'מרכז_יה_ל_ייעוץ_והכוונה_למשפחות_66', 'ראשון לציון', 'עין הקורא 10, ראשון לציון', 31.9659043, 34.8041468, 9),
  (66, 'מרכז_יה_ל_ייעוץ_והכוונה_למשפחות_66', 'רמלה', 'הרצל 45, רמלה', 31.9296838, 34.8703195, 10),
  (67, 'איכות_בשיקום_67', 'אשדוד', 'הרצל 1, אשדוד', 31.7934938, 34.6403679, 0),
  (67, 'איכות_בשיקום_67', 'אשקלון', 'ברל כצנלסון 13, אשקלון', 31.661716, 34.5874506, 1),
  (67, 'איכות_בשיקום_67', 'חדרה', 'סמטת פלטרין 6, חדרה', 32.43693, 34.92021, 2),
  (67, 'איכות_בשיקום_67', 'חיפה', 'שדרות פלי״ם 2, חיפה', 32.8167554, 35.0000812, 3),
  (67, 'איכות_בשיקום_67', 'חריש', 'אלה 2, חריש', 32.4645487, 35.0387759, 4),
  (67, 'איכות_בשיקום_67', 'ירושלים', 'יפו 216, ירושלים', 31.7890021, 35.2053137, 5),
  (67, 'איכות_בשיקום_67', 'כפר סבא', 'התע״ש 23, אזור התעשייה, כפר סבא', 32.1736651, 34.9258729, 6),
  (67, 'איכות_בשיקום_67', 'מודיעין', 'רא״ל יגאל ידין 53, מודיעין', 31.9026163, 35.004662, 7),
  (67, 'איכות_בשיקום_67', 'פתח תקווה', 'זאב אורלוב 77, פתח תקווה', 32.0952565, 34.8883409, 8),
  (67, 'איכות_בשיקום_67', 'ראשון לציון', 'עין הקורא 10, ראשון לציון', 31.9659043, 34.8041468, 9),
  (67, 'איכות_בשיקום_67', 'רמלה', 'הרצל 45, רמלה', 31.9296838, 34.8703195, 10),
  (67, 'איכות_בשיקום_67', 'דיור מוגן', 'המשביר 1, חולון', 32.0127722, 34.8048098, 11),
  (67, 'איכות_בשיקום_67', 'הוסטל וקהילה תומכת', 'הנביאים 55 ו-55א, חולון', 32.01649, 34.79521, 12),
  (67, 'איכות_בשיקום_67', 'מרכז איתן', 'המשביר 1, חולון', 32.0127722, 34.8048098, 13),
  (67, 'איכות_בשיקום_67', 'הנהלה', 'המשביר 1, חולון', 32.0127722, 34.8048098, 14)
) AS v(row_id, entry_id, label, address, lat, lng, sort_order)
WHERE EXISTS (
  SELECT 1 FROM directory_card_edits
  WHERE card_key = '66|||ייעוץ והכוונה למשפחות בתחום בריאות הנפש · 18:00 - 22:00'
    AND public_fields->>'whatsapp' = '972524917126'
)
AND NOT EXISTS (
  SELECT 1 FROM directory_entry_locations WHERE row_id = 66 AND label = 'אשדוד'
)
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

COMMIT;
