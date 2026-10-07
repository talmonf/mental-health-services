-- Migration 050 (7 Oct 2026)
-- directory_entries + directory_card_edits:
--   294 מזור (הרב שמעון רגובי) — mental-health guidance, portals. Not an ambulance.
--   295 עזרת אחים — subsidized rides, Beit Shemesh to Jerusalem hospitals, transport.
-- Source audit is in eligibility.internal_notes (not painted on the card).
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
    'מזור_הרב_שמעון_רגובי_294',
    'מזור (הרב שמעון רגובי)',
    'הכוונה וליווי למציאת מענה בפסיכיאטריה ובריאות הנפש',
    'portals',
    ARRAY['portals']::text[],
    ARRAY['self_referral']::text[]
  ),
  (
    'עזרת_אחים_295',
    'עזרת אחים',
    'הסעות מסובסדות לבתי חולים מבית שמש לירושלים, אמבולנסים ורכבים מונגשים',
    'transport',
    ARRAY['transport']::text[],
    ARRAY['self_referral']::text[]
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
  '294|||הכוונה וליווי למציאת מענה בפסיכיאטריה ובריאות הנפש',
  294,
  'מזור_הרב_שמעון_רגובי_294',
  '{"org":"מזור (הרב שמעון רגובי)","svc":"הכוונה וליווי למציאת מענה בפסיכיאטריה ובריאות הנפש","target":"פונים ובני משפחות","region":"כל הארץ","cost":"","specialty":"","languages":"","diseases":"","notes":"בראשות מנחם ברקוביץ: הקשבה והתאמה לאנשי מקצוע ולמסגרות בפסיכיאטריה ובריאות הנפש. אגף לטיפול רגשי בהכוונת גולדי רייסנר מלווה גם משפחות במצב רפואי קשה. מענה טלפוני א׳–ה׳ 10:00–15:00; למקרים דחופים נכתב שהצוות זמין 24/7 באותו מספר. משרד: מצדה 7, בני ברק. שונה מהמרכז הרפואי לבריאות הנפש מזור בעכו.","tags":"","whatsapp":"97236351111","whatsappLabel":"","email":"yr@mazormed.org.il","web":"https://mazormed.org.il/%D7%91%D7%A8%D7%99%D7%90%D7%95%D7%AA-%D7%94%D7%A0%D7%A4%D7%A9/","webLabel":"","web2":"https://mazormed.org.il/%D7%A4%D7%A0%D7%99%D7%94-%D7%90%D7%95%D7%A0%D7%9C%D7%99%D7%99%D7%9F/","webLabel2":"פנייה אונליין","add":"","addLabel":"","phone":"03-6351111","phoneLabel":"משרד","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"נבדק 07.10.2026. הקישור שסופק הוא דף בריאות הנפש של ארגון מזור (הרב שמעון רגובי, mazormed.org.il), לא שירות אמבולנס. אין באתר הסעות או אמבולנס מקומי. השירות הקרוב לתחבורה הוא הטסות רפואיות לחו״ל: כ-40 מקרים בשנה בדף ההטסות, וכ-32 בדף הבית. זה ליווי לוגיסטי, לא הסעה בישראל, ולכן לא נוסף כרטיס הסעות. המרכז הרפואי לבריאות הנפש מזור בעכו (משרד הבריאות) הוא גוף אחר; מכרז הסעת אמבולנס למטופליו משנת 2026 אינו שירות לציבור. שעות: דף בריאות הנפש ופוטר הבית א׳–ה׳ 10:00–15:00; דף צור קשר מציין יום ג׳ 10:00–13:00. למקרים דחופים מופיעה שלוחה 4 בדף אחד ושלוחה 5 בדף אחר, ולכן לא פורסמה שלוחה בכרטיס. וואטסאפ באתר: 03-6351111. פקס 03-6351116 לא הועלה לכרטיס."}'::jsonb,
  '[]'::jsonb
),
(
  '295|||הסעות מסובסדות לבתי חולים מבית שמש לירושלים, אמבולנסים ורכבים מונגשים',
  295,
  'עזרת_אחים_295',
  '{"org":"עזרת אחים","svc":"הסעות מסובסדות לבתי חולים מבית שמש לירושלים, אמבולנסים ורכבים מונגשים","target":"חולים, קשישים, נכים ויולדות","region":"בית שמש והסביבה; יעד עיקרי: בתי חולים בירושלים","cost":"מסובסד","specialty":"","languages":"","diseases":"","notes":"הסעות לבתי החולים, לפי הארגון, הן מבית שמש לירושלים. נסיעות לחולים ולמוגבלי תנועה גם באזורים אחרים לפי זמינות, בתיאום של לפחות יום מראש. כולל אמבולנס שבת ליולדות. משרד: הנביא עמוס 1, בית שמש.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://eza.org.il/activities-domain/transportation/","webLabel":"","web2":"https://eza.org.il/our-activities/%D7%94%D7%A1%D7%A2%D7%95%D7%AA-%D7%97%D7%95%D7%9C%D7%99%D7%9D/","webLabel2":"הסעות חולים","add":"","addLabel":"","phone":"1800-999-000","phoneLabel":"הסעות (שלוחה 1)","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"נבדק 07.10.2026. דף התחום (eza.org.il/activities-domain/transportation) אומר הסעות מסובסדות לבתי חולים מבית שמש לירושלים, וגם צי אמבולנסים ורכבים מונגשים ואמבולנס שבת ליולדות. דף הסעות חולים והדף באנגלית (transportation-services) מרחיבים: בית שמש והסביבה וכן אזורים אחרים לפי זמינות; תיאום לפחות יום מראש, 1800-999-000 שלוחה 1. לא כתוב ללא עלות. קרן יוסף (kerenyosef.co.il/community-ambulette) מתארת ארבעה אמבולנסים שתרמה ומופעלים על ידי עזרת אחים, לתושבי בית שמש ורמת בית שמש לבתי החולים הדסה עין כרם, שערי צדק, הדסה הר הצופים ואלי״ן, ללא עלות, עם שעות יציאה קבועות, והזמנה ב-02-9990000. זה מקור של התורם, לא של הארגון, ולכן השעות והחינם לא הועלו לכרטיס. שמשפון מציין גם 02-9990000 וכוכבית 2348 ושעות משרד 07:00–22:00. קשר ישן מציין כתובת נחל לכיש 2. הכתובת באתר העדכני: הנביא עמוס 1. קואורדינטות לפי OSM לבניין. עמותה 580435717."}'::jsonb,
  '[{"label":"בית שמש","address":"הנביא עמוס 1, בית שמש","lat":31.702724,"lng":34.990540,"phone":"1800-999-000","email":"","sort_order":0}]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
VALUES
  (295, 'עזרת_אחים_295', 'בית שמש', 'הנביא עמוס 1, בית שמש', 31.702724, 34.990540, 0)
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

COMMIT;
