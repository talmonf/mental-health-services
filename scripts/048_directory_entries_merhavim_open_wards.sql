-- Migration 048 (29 Sep 2026)
-- directory_entries + directory_card_edits: מחלקות פתוחות במרחבים באר יעקב.
-- 292 בדרכי — טראומה מורכבת (hospitalization + trauma; חרבות ברזל)
-- 293 לצידך — נשים, טראומה מורכבת והפרעות אכילה (hospitalization + trauma + nutrition)
-- Sites live on directory_card_edits.sites (admin-editable, not painted on the card)
-- and are mirrored into directory_entry_locations for the baked map fallback.
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
    'בדרכי_מרחבים_באר_יעקב_292',
    'בדרכי (מרחבים, באר יעקב)',
    'מחלקה פתוחה לאשפוז בטראומה מורכבת — כולל נפגעי 7 באוקטובר ובני משפחותיהם',
    'hospitalization',
    ARRAY['hospitalization', 'trauma']::text[],
    ARRAY['unknown']::text[]
  ),
  (
    'לצידך_מרחבים_באר_יעקב_293',
    'לצידך (מרחבים, באר יעקב)',
    'מחלקה פתוחה לנשים עם פוסט־טראומה מורכבת והפרעות אכילה',
    'hospitalization',
    ARRAY['hospitalization', 'trauma', 'nutrition']::text[],
    ARRAY['hmo_form17']::text[]
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
  '292|||מחלקה פתוחה לאשפוז בטראומה מורכבת — כולל נפגעי 7 באוקטובר ובני משפחותיהם',
  292,
  'בדרכי_מרחבים_באר_יעקב_292',
  '{"org":"בדרכי (מרחבים, באר יעקב)","svc":"מחלקה פתוחה לאשפוז בטראומה מורכבת — כולל נפגעי 7 באוקטובר ובני משפחותיהם","target":"מי שחוו את המלחמה מקרוב ובני משפחותיהם; גם מי שחוו התעללות בעבר ובהתדרדרות בעקבות מצב החירום","region":"באר יעקב; על-אזורית","cost":"","specialty":"טראומה מורכבת","languages":"","diseases":"","notes":"מחלקה פתוחה במרחבים באר יעקב, בניהול ד״ר דפנה ערמון. הוקמה אחרי 7 באוקטובר. צוות רב־מקצועי (פסיכיאטריה, פסיכולוגיה, עבודה סוציאלית, ביבליותרפיה, טיפול באמנויות). מענה ארוך טווח. מחלקת לצידך בכרטיס נפרד (שורה 293).","tags":"חרבות ברזל","whatsapp":"","whatsappLabel":"","email":"","web":"https://www.gov.il/he/departments/units/my-way-beerness","webLabel":"","web2":"https://www.gov.il/he/departments/mental-health-center-beer-yaacov-ness-ziona","webLabel2":"מרחבים","add":"https://www.facebook.com/merhavimbeerness","addLabel":"פייסבוק","phone":"08-9258241","phoneLabel":"מרכזייה","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":["פוסט־טראומה מורכבת"],"presenting_problems":["טראומה מלחמה","התעללות בעבר"],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"דפי gov.il של המחלקה ושל מרחבים נחסמו ב-Cloudflare בזמן העריכה (29.09.2026); הטקסט הציבורי לפי תיאור המחלקה שסופק ולפי דף גיוס coing. לא צוין מסלול הפניה או מימון במקור — לא סומן טופס 17. הטלפון 08-9258241 הוא מרכזיית מרחבים (sherut-kal), לא קו ישיר למחלקה. גיל 18+ לפי קמפוס מבוגרים בבאר יעקב, לא צוין במקור. ד״ר דפנה ערמון מנהלת. הוקמה אחרי 7 באוקטובר; הצוות הוקצה תחילה גם לפניות מרפאתיות סביב המלחמה. קואורדינטות כמו מרפאת מרחבים בכרטיס נויגייט."}'::jsonb,
  '[{"label":"באר יעקב","address":"המרכז הרפואי מרחבים, באר יעקב","lat":31.935925,"lng":34.829972,"phone":"08-9258241","email":"","sort_order":0}]'::jsonb
),
(
  '293|||מחלקה פתוחה לנשים עם פוסט־טראומה מורכבת והפרעות אכילה',
  293,
  'לצידך_מרחבים_באר_יעקב_293',
  '{"org":"לצידך (מרחבים, באר יעקב)","svc":"מחלקה פתוחה לנשים עם פוסט־טראומה מורכבת והפרעות אכילה","target":"נשים מגיל 18","region":"באר יעקב; מקבלת מכל הארץ","cost":"טופס 17 — כללית ומאוחדת","specialty":"טראומה מינית, הפרעות אכילה","languages":"","diseases":"","notes":"מחלקה פתוחה בהסכמה, בפיקוח משרד הבריאות, בניהול ד״ר ענבל שלומי וד״ר דפנה ערמון. היחידה בארץ שמטפלת בטראומה מינית ובהפרעות אכילה תחת קורת גג אחת. גם מרפאת המשך בבאר יעקב וטיפול יום בקמפוס נס ציונה. מחלקת בדרכי בכרטיס נפרד (שורה 292).","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://www.gov.il/he/departments/units/department-by-your-side","webLabel":"","web2":"https://www.iaed.org.il/treatment_center/1004/","webLabel2":"IAED","add":"https://www.facebook.com/merhavimbeerness","addLabel":"פייסבוק","phone":"08-9258391","phoneLabel":"מזכירות","phoneShowNumber":true,"phone2":"08-9258241","phoneLabel2":"מרכזייה","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"female","location_mode":"sites","regions":[],"diagnoses":["פוסט־טראומה מורכבת","הפרעות אכילה"],"presenting_problems":["טראומה מינית","הפרעות אכילה"],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"IAED 1004 (אשפוז+יום) ו-1005 (מרפאת המשך) — כרטיס אחד לרצף, לא כרטיס נפרד למרפאה. מימון לפי IAED: כללית ומאוחדת, טופס 17; לא צוינו מכבי/לאומית. טלפון 08-9258391 לפי בטיפולנט (לא ב-IAED ולא ב-gov.il). 08-9258241 מרכזייה. ויקיפדיה/המכלול: מחלקה פתוחה לאשפוזים ארוכי טווח לנשים שחוו אירועים טראומטיים, עם ובלי סימפטומים של הפרעות אכילה. IAED: בקרוב מחלקה אקוטית — לא צוין כשירות קיים. טיפול יום בקמפוס נס ציונה בלי נקודת מפה נפרדת (אין כתובת רחוב). קואורדינטות כמו מרפאת מרחבים בכרטיס נויגייט."}'::jsonb,
  '[{"label":"באר יעקב","address":"המרכז הרפואי מרחבים, באר יעקב","lat":31.935925,"lng":34.829972,"phone":"08-9258391","email":"","sort_order":0}]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
VALUES
  (292, 'בדרכי_מרחבים_באר_יעקב_292', 'באר יעקב', 'המרכז הרפואי מרחבים, באר יעקב', 31.935925, 34.829972, 0),
  (293, 'לצידך_מרחבים_באר_יעקב_293', 'באר יעקב', 'המרכז הרפואי מרחבים, באר יעקב', 31.935925, 34.829972, 0)
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

COMMIT;
