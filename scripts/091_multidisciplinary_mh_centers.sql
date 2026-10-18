-- Migration 091 (18 Oct 2026)
-- Multidisciplinary mental-health centers from the 18.10.2026 spreadsheet.
-- New cards 345-355, updates to the live text of cards 62, 70, 203 and 300,
-- approved glossary links for term multidisciplinary_center, and the audit log.
-- An UPDATE applies only when the fields it changes still hold the expected text,
-- so a later admin edit is not overwritten.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;
INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES
('מרכז_גוני_345', 'מרכז גוני', 'מרכז טיפול ואבחון רב-תחומי לפרט ולמשפחה', 'mh_clinics', ARRAY['mh_clinics']::text[], ARRAY['self_referral']::text[]),
('מרכז_ד_ר_טל_346', 'מרכז ד״ר טל', 'מרכז לתמיכה רגשית ונפשית', 'mh_clinics', ARRAY['mh_clinics']::text[], ARRAY['self_referral']::text[]),
('הכח_לשנות_347', 'הכח לשנות', 'מכון לאבחון ולייעוץ, מגיל הרך עד מבוגרים', 'mh_clinics', ARRAY['mh_clinics']::text[], ARRAY['self_referral']::text[]),
('קשת_רפואה_348', 'קשת רפואה', 'מרכז מומחים רב-תחומי, כולל מרכז נווה להפרעות אכילה', 'mh_clinics', ARRAY['mh_clinics']::text[], ARRAY['self_referral']::text[]),
('המכון_להפרעות_אכילה_ע_ש_אפרת_צוק_רעות_349', 'המכון להפרעות אכילה ע״ש אפרת צוק (רעות)', 'טיפול בהפרעות אכילה — טיפול יום למבוגרים וטיפול אמבולטורי', 'mh_clinics', ARRAY['mh_clinics', 'nutrition']::text[], ARRAY['hmo_form17', 'mod_rehab_worker', 'self_referral']::text[]),
('fym_350', 'FYM', 'מרפאה רב-תחומית לבריאות הנפש', 'mh_clinics', ARRAY['mh_clinics']::text[], ARRAY['self_referral']::text[]),
('א_עד_ת_351', 'א׳ עד ת׳', 'מרכז פסיכולוגי-חינוכי לילדים ולנוער', 'mh_clinics', ARRAY['mh_clinics']::text[], ARRAY['self_referral']::text[]),
('מכון_דביר_352', 'מכון דביר', 'מכון לבריאות התנהגותית, עם צוות דובר אנגלית', 'mh_clinics', ARRAY['mh_clinics']::text[], ARRAY['self_referral']::text[]),
('חוף_הגליל_353', 'חוף הגליל', 'מרכז לטיפול בילד, במבוגר ובמשפחה', 'mh_clinics', ARRAY['mh_clinics']::text[], ARRAY['self_referral']::text[]),
('תחנת_העמקים_354', 'תחנת העמקים', 'טיפול נפשי לילדים, לנוער ולמבוגרים', 'mh_clinics', ARRAY['mh_clinics']::text[], ARRAY['self_referral']::text[]),
('מעייני_הישועה_מרפאה_לדוברי_אנגלית_355', 'מעייני הישועה — מרפאה לדוברי אנגלית', 'מרפאה לבריאות הנפש לדוברי אנגלית', 'mh_clinics', ARRAY['mh_clinics']::text[], ARRAY['gp_referral', 'hmo_form17', 'mod_rehab_worker']::text[])
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '345|||מרכז טיפול ואבחון רב-תחומי לפרט ולמשפחה',
  345,
  'מרכז_גוני_345',
  '{"org":"מרכז גוני","svc":"מרכז טיפול ואבחון רב-תחומי לפרט ולמשפחה","target":"מגיל הרך עד מבוגרים","region":"ענתות 11, צהלה, תל אביב","cost":"","specialty":"","languages":"","diseases":"","notes":"צוות של פסיכיאטרים למבוגרים ולילדים ולנוער, פסיכולוגים, פסיכותרפיסטים ועובדים סוציאליים קליניים, וגם מטפלות באמנות. מטפלים בין השאר בחרדה, OCD, דיכאון, טראומה, משברים, ויסות רגשי, אוטיזם, קשב, הפרעות אכילה והתמכרויות אצל ילדים ונוער, דיכאון וטראומה אחרי לידה, והדרכת הורים. מוצעת שיחת ייעוץ ראשונית ללא עלות. מי משלם על הטיפול לא צוין באתר.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://gonicenter.co.il/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"058-7993988","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"18.10.2026: נבדק מול https://gonicenter.co.il/ לפי גיליון המרכזים הרב-צוותיים. שיחת ייעוץ ראשונית ללא עלות; מי משלם על הטיפול לא צוין. סיכה: ענתות 11, צהלה."}'::jsonb,
  '[{"label":"צהלה","address":"ענתות 11, צהלה, תל אביב","lat":32.125403,"lng":34.82762,"phone":"058-7993988","email":"","sort_order":0}]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;
INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
VALUES
(345, 'מרכז_גוני_345', 'צהלה', 'ענתות 11, צהלה, תל אביב', 32.125403, 34.82762, 0)
ON CONFLICT (row_id, label) DO NOTHING;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '346|||מרכז לתמיכה רגשית ונפשית',
  346,
  'מרכז_ד_ר_טל_346',
  '{"org":"מרכז ד״ר טל","svc":"מרכז לתמיכה רגשית ונפשית","target":"ילדים, נוער ומבוגרים","region":"תל אביב (רמת אביב), ירושלים, חיפה, וגם אונליין","cost":"","specialty":"","languages":"","diseases":"","notes":"צוות של פסיכיאטרים, פסיכולוגים, פסיכותרפיסטים (כולל CBT) ועובדים סוציאליים קליניים. מטפלים בין השאר בחרדה ו-OCD, דיכאון (כולל דיכאון עמיד, עם טיפול בקטמין), הפרעה דו-קוטבית, התמכרויות, ADHD, לקויות למידה, אוטיזם, PTSD, הפרעות אכילה, אבל, וזוגיות ומשפחה. כתובות רחוב ומי משלם לא צוינו באתר.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://www.drtal.co.il/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"18.10.2026: נבדק מול https://www.drtal.co.il/ . אין כתובת רחוב באתר, ולכן אין סיכה. מי משלם לא צוין."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '347|||מכון לאבחון ולייעוץ, מגיל הרך עד מבוגרים',
  347,
  'הכח_לשנות_347',
  '{"org":"הכח לשנות","svc":"מכון לאבחון ולייעוץ, מגיל הרך עד מבוגרים","target":"מגיל שנתיים בערך עד מבוגרים","region":"יוסף לישנסקי 27, ראשון לציון","cost":"","specialty":"","languages":"","diseases":"","notes":"צוות של פסיכיאטרים למבוגרים ולילדים ולנוער, פסיכותרפיסטים, מרפאים בעיסוק, דיאטניות קליניות ועובדים סוציאליים, וגם קלינאיות תקשורת, נוירולוג התפתחותי ומאמני כושר טיפולי. מטפלים בין השאר בחרדה, דיכאון, OCD, PTSD וטראומה מינית, הפרעות אכילה, התמכרויות, הפרעות אישיות, ADHD, לקויות למידה, אוטיזם ועיכוב התפתחותי. באתר מופיעים סמלי ביטוח לאומי ומשרד הביטחון, בלי פירוט מי משלם.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://leshanot.co.il/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"072-3341926","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"18.10.2026: נבדק מול https://leshanot.co.il/ . סמלי ביטוח לאומי ומשרד הביטחון באתר, בלי פירוט. סיכה: יוסף לישנסקי 27, ראשון לציון."}'::jsonb,
  '[{"label":"ראשון לציון","address":"יוסף לישנסקי 27, ראשון לציון","lat":31.9954114,"lng":34.7668962,"phone":"072-3341926","email":"","sort_order":0}]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;
INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
VALUES
(347, 'הכח_לשנות_347', 'ראשון לציון', 'יוסף לישנסקי 27, ראשון לציון', 31.9954114, 34.7668962, 0)
ON CONFLICT (row_id, label) DO NOTHING;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '348|||מרכז מומחים רב-תחומי, כולל מרכז נווה להפרעות אכילה',
  348,
  'קשת_רפואה_348',
  '{"org":"קשת רפואה","svc":"מרכז מומחים רב-תחומי, כולל מרכז נווה להפרעות אכילה","target":"כל הגילאים","region":"צור 1, מבשרת ציון","cost":"פרטי, עם החזר מחברות ביטוח לפי תנאי הפוליסה","specialty":"הפרעות אכילה","languages":"","diseases":"","notes":"המרכז כולל גם תחומי רפואה גופנית. בצוות פסיכיאטריות, כולל פסיכיאטרית ילדים ונוער, פסיכולוגים קליניים, פסיכותרפיסטית CBT, עובדות סוציאליות ודיאטניות קליניות. התמחות בהפרעות אכילה (אנורקסיה, בולימיה, אכילה כפייתית ורגשית), וגם טראומה, חרדה, דיכאון, OCD, ADHD והפרעות בתקופת הלידה.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://keshet-refua.co.il/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"073-3214111","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"18.10.2026: נבדק מול https://keshet-refua.co.il/ . הסיכה על הרחוב: מספר הבית לא נמצא במפת OSM, ולכן הנקודה היא על הרחוב ולא על הבניין."}'::jsonb,
  '[{"label":"מבשרת ציון","address":"צור 1, מבשרת ציון","lat":31.7874576,"lng":35.1374646,"phone":"073-3214111","email":"","sort_order":0}]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;
INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
VALUES
(348, 'קשת_רפואה_348', 'מבשרת ציון', 'צור 1, מבשרת ציון', 31.7874576, 35.1374646, 0)
ON CONFLICT (row_id, label) DO NOTHING;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '349|||טיפול בהפרעות אכילה — טיפול יום למבוגרים וטיפול אמבולטורי',
  349,
  'המכון_להפרעות_אכילה_ע_ש_אפרת_צוק_רעות_349',
  '{"org":"המכון להפרעות אכילה ע״ש אפרת צוק (רעות)","svc":"טיפול בהפרעות אכילה — טיפול יום למבוגרים וטיפול אמבולטורי","target":"טיפול יום מגיל 18, וגם טיפול אמבולטורי","region":"שדרות החייל 2, תל אביב","cost":"טיפול אמבולטורי דרך קופות החולים, צה״ל ומשרד הביטחון. הדרכת הורים וטיפול משפחתי: פרטי","specialty":"הפרעות אכילה","languages":"","diseases":"","notes":"מכון במרכז הרפואי רעות, בלי כוונת רווח. מיועד להפרעות אכילה: אנורקסיה, בולימיה ואכילה כפייתית, וגם להשמנה לפני ניתוח בריאטרי או אחריו. בצוות פסיכיאטר, פסיכולוגים קליניים ושיקומיים, דיאטניות קליניות ואחות בטיפול היום, וגם מטפלים בתנועה ובאמנויות והדרכת הורים.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://www.reuth-mc.org.il/en/clinics/the-institute-for-treatment-of-eating-disorders/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"03-5081000","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"18.10.2026: נבדק מול דף המכון באתר רעות. טיפול יום למבוגרים 18+. הסיכה היא מיקום בית החולים רעות במפה."}'::jsonb,
  '[{"label":"תל אביב","address":"המרכז הרפואי רעות, שדרות החייל 2, תל אביב","lat":32.0562458,"lng":34.7903821,"phone":"03-5081000","email":"","sort_order":0}]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;
INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
VALUES
(349, 'המכון_להפרעות_אכילה_ע_ש_אפרת_צוק_רעות_349', 'תל אביב', 'המרכז הרפואי רעות, שדרות החייל 2, תל אביב', 32.0562458, 34.7903821, 0)
ON CONFLICT (row_id, label) DO NOTHING;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '350|||מרפאה רב-תחומית לבריאות הנפש',
  350,
  'fym_350',
  '{"org":"FYM","svc":"מרפאה רב-תחומית לבריאות הנפש","target":"ילדים, נוער ומבוגרים","region":"רעננה, חיפה וראש פינה","cost":"","specialty":"","languages":"","diseases":"","notes":"צוות של פסיכיאטרים, פסיכולוגים קליניים, פסיכותרפיסטים (CBT), עובדות סוציאליות קליניות ודיאטנית קלינית, וגם מטפלים בהבעה ויצירה. מטפלים בין השאר בדיכאון, PTSD וטראומה, הערכת סיכון אובדני, חרדה, הפרעות אכילה, אוטיזם ו-ADHD, וגם בחוות דעת פסיכיאטריות. כתובות רחוב ומי משלם לא צוינו באתר.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://fym-clinic.co.il/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"09-7444484","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"18.10.2026: נבדק מול https://fym-clinic.co.il/ . אין כתובת רחוב באתר, ולכן אין סיכה. מי משלם לא צוין."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '351|||מרכז פסיכולוגי-חינוכי לילדים ולנוער',
  351,
  'א_עד_ת_351',
  '{"org":"א׳ עד ת׳","svc":"מרכז פסיכולוגי-חינוכי לילדים ולנוער","target":"ילדים ונוער","region":"סוקולוב 48, קומה 4, רמת השרון","cost":"","specialty":"","languages":"","diseases":"","notes":"בצוות פסיכולוגים חינוכיים וקליניים, עובדות סוציאליות ומרפא בעיסוק, וגם מטפלת באמנות ומאבחנת לקויות למידה. הפסיכיאטר הרשום הוא מתמחה בפסיכיאטריה של הילד והמתבגר, לא מומחה. מטפלים בין השאר בלקויות למידה, ADHD, ויסות רגשי והתנהגותי, מורכבויות התפתחותיות וטראומה. מי משלם לא צוין באתר.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://www.alef-tav.co/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"054-9656545","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"18.10.2026: נבדק מול https://www.alef-tav.co/ . ילדים ונוער בלבד. הפסיכיאטר הרשום הוא מתמחה, לא מומחה. הסיכה על הרחוב: מספר הבית לא נמצא במפת OSM, ולכן הנקודה היא על הרחוב ולא על הבניין."}'::jsonb,
  '[{"label":"רמת השרון","address":"סוקולוב 48, רמת השרון","lat":32.1445961,"lng":34.8379308,"phone":"054-9656545","email":"","sort_order":0}]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;
INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
VALUES
(351, 'א_עד_ת_351', 'רמת השרון', 'סוקולוב 48, רמת השרון', 32.1445961, 34.8379308, 0)
ON CONFLICT (row_id, label) DO NOTHING;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '352|||מכון לבריאות התנהגותית, עם צוות דובר אנגלית',
  352,
  'מכון_דביר_352',
  '{"org":"מכון דביר","svc":"מכון לבריאות התנהגותית, עם צוות דובר אנגלית","target":"מבוגרים, מתבגרים בוגרים וסטודנטים. תוכנית אינטנסיבית לנשים מגיל 18","region":"ירושלים (דרך בית לחם 16), בית שמש ורעננה","cost":"","specialty":"DBT","languages":"עברית, אנגלית","diseases":"","notes":"צוות דובר אנגלית. מתמחה ב-DBT: חוסר ויסות רגשי, פגיעה עצמית ואובדנות, התנהגויות אימפולסיביות והתמכרותיות, אכילה לא מווסתת, הפרעת אישיות גבולית, PTSD מורכב, דיכאון, חרדה ו-OCD. בצוות פסיכיאטרים, פסיכולוגים ועובדים סוציאליים. מי משלם לא צוין באתר.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://machondvir.org/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"02-6252527","phoneLabel":"","phoneShowNumber":true,"phone2":"09-7772527","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"18.10.2026: נבדק מול https://machondvir.org/ . כתובת ירושלים לפי אתר Beineinu (דרך בית לחם 16). בית שמש ורעננה בלי רחוב, ולכן סיכה רק בירושלים. הסיכה על הרחוב: מספר הבית לא נמצא במפת OSM, ולכן הנקודה היא על הרחוב ולא על הבניין."}'::jsonb,
  '[{"label":"ירושלים","address":"דרך בית לחם 16, ירושלים","lat":31.7513148,"lng":35.2182209,"phone":"02-6252527","email":"","sort_order":0}]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;
INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
VALUES
(352, 'מכון_דביר_352', 'ירושלים', 'דרך בית לחם 16, ירושלים', 31.7513148, 35.2182209, 0)
ON CONFLICT (row_id, label) DO NOTHING;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '353|||מרכז לטיפול בילד, במבוגר ובמשפחה',
  353,
  'חוף_הגליל_353',
  '{"org":"חוף הגליל","svc":"מרכז לטיפול בילד, במבוגר ובמשפחה","target":"כל הגילאים, כולל מרכז ענבר לגילאי 18–25 ומרכז יסמין למבוגרים","region":"משרדים במושב רגבה. גם משגב, קריית מוצקין וכרמיאל","cost":"בתשלום. הסדר עם כללית לגילאי 3–6 בהתפתחות הילד, ומוכר כספק של כללית ולאומית ברפורמת בריאות הנפש","specialty":"","languages":"","diseases":"","notes":"עמותה של קיבוצי הגליל המערבי, פועלת מ-1978. בצוות פסיכיאטרים, פסיכולוגים ועובדים סוציאליים קליניים, וגם מטפלים באמנות וקלינאית תקשורת. יש יחידת חרדה, טיפול בטראומה מינית למבוגרים, מענה למשבר ולסיכון בצעירים, אבחון אוטיזם, לקויות למידה, קשיים רגשיים וחברתיים, וטיפול זוגי ומשפחתי. הרכב הצוות לפי מאגר «קשר», והאתר עצמו לא מפרט אותו.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://hofhagalil.co.il/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"04-9922091","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"18.10.2026: נבדק מול https://hofhagalil.co.il/ . הרכב הצוות לפי מאגר קשר, לא פורט באתר העמותה. אין כתובת רחוב, ולכן אין סיכה."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '354|||טיפול נפשי לילדים, לנוער ולמבוגרים',
  354,
  'תחנת_העמקים_354',
  '{"org":"תחנת העמקים","svc":"טיפול נפשי לילדים, לנוער ולמבוגרים","target":"ילדים, נוער ומבוגרים","region":"צומת תל יוסף, ליד המועצה האזורית","cost":"בתשלום. מימון חלקי אפשרי לפי זכאות ממשרדי הרווחה, ממשרד הביטחון ומקופות (כללית מושלם, מכבי)","specialty":"","languages":"","diseases":"","notes":"עמותה שהוקמה על ידי מועצות אזוריות בעמק, עם כ-60 אנשי מקצוע: פסיכיאטר, פסיכולוגים (רובם קליניים) ועובדים סוציאליים. מטפלים בין השאר במשברי חיים, לחץ, חרדה, פוסט-טראומה, אובדן, הפרעות התפתחותיות, אוטיזם והפרעות אכילה. המידע לפי מאגר «קשר». האתר לא נטען בבדיקה, וייתכן שהפירוט אינו עדכני.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"http://www.psy.org.il","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"04-6533333","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"18.10.2026: המידע לפי מאגר קשר. האתר http://www.psy.org.il לא נטען, וייתכן שהפירוט אינו עדכני. אין רחוב, ולכן אין סיכה."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '355|||מרפאה לבריאות הנפש לדוברי אנגלית',
  355,
  'מעייני_הישועה_מרפאה_לדוברי_אנגלית_355',
  '{"org":"מעייני הישועה — מרפאה לדוברי אנגלית","svc":"מרפאה לבריאות הנפש לדוברי אנגלית","target":"מבוגרים","region":"מרכז רפואי מעייני הישועה, בני ברק, מחלקת בריאות הנפש, קומה 1","cost":"כללית ומכבי: בהפניה. מאוחדת ולאומית: טופס 17. משרד הביטחון: טופס התחייבות. ביטוחים פרטיים בהסדר. בלי התחייבות: לפי מחירון בית החולים","specialty":"","languages":"אנגלית","diseases":"","notes":"בית חולים פרטי בלי כוונת רווח. בצוות פסיכיאטרים, פסיכולוגים ועובדים סוציאליים. נפרד מ[טיפול היום](https://nefesh-il.org/treatment?entry=300&section=day_care).","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://www.mymc.co.il/en/clinics/mental-health-clinic-for-english-speakers-2/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"sites","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"18.10.2026: נבדק מול דף המרפאה לדוברי אנגלית באתר מעייני הישועה. הסיכה היא כתובת בית החולים שכבר על כרטיס טיפול היום (300). גילאים לא צוינו באתר; הצוות מתואר כמרפאת מבוגרים."}'::jsonb,
  '[{"label":"בני ברק","address":"הרב פוברסקי 17, בני ברק","lat":32.0850714,"lng":34.8445708,"phone":"","email":"","sort_order":0}]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;
INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
VALUES
(355, 'מעייני_הישועה_מרפאה_לדוברי_אנגלית_355', 'בני ברק', 'הרב פוברסקי 17, בני ברק', 32.0850714, 34.8445708, 0)
ON CONFLICT (row_id, label) DO NOTHING;

-- Row 62, if the 16.10 review text is still in place: add the team, the HMO arrangement,
-- Ashdod and Ofakim, and the sexual-trauma clinics. Do not replace the audience or the pins.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'ירושלים, בית שמש, בני ברק, אלעד, מודיעין עילית, אשדוד ואופקים',
      'cost', 'הסדר עם כל קופות החולים. עלות למטופל לא צוינה באתר.',
      'notes', 'מיועד בעיקר למגזר הדתי-חרדי. בצוות פסיכיאטרים, פסיכולוגים ועובדים סוציאליים קליניים, וגם מאבחנים ויועצים. יש מרכזי טיפול לנפגעי ולנפגעות טראומה מינית מהמגזר הדתי-חרדי. משרדי העמותה: כהנמן 72, בני ברק.'
    ),
    eligibility = COALESCE(eligibility, '{}'::jsonb) || jsonb_build_object(
      'internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '18.10.2026: עודכן לפי גיליון המרכזים הרב-צוותיים, מול https://www.bayit-cham.org.il/ . נוסף הצוות, ההסדר עם הקופות, אשדוד ואופקים, ומרכזי הטראומה המינית. עלות למטופל לא צוינה באתר.', E'\n ')
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 62
  AND COALESCE(public_fields->>'target', '') = 'מבוגרים וילדים'
  AND COALESCE(public_fields->>'region', '') = 'ירושלים, בית שמש, בני ברק, אלעד, מודיעין עילית'
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

-- Row 62, if the review has not been applied and the catalog text is still empty.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'target', 'מבוגרים וילדים',
      'region', 'ירושלים, בית שמש, בני ברק, אלעד, מודיעין עילית, אשדוד ואופקים',
      'cost', 'הסדר עם כל קופות החולים. עלות למטופל לא צוינה באתר.',
      'notes', 'מיועד בעיקר למגזר הדתי-חרדי. בצוות פסיכיאטרים, פסיכולוגים ועובדים סוציאליים קליניים, וגם מאבחנים ויועצים. יש מרכזי טיפול לנפגעי ולנפגעות טראומה מינית מהמגזר הדתי-חרדי. משרדי העמותה: כהנמן 72, בני ברק.'
    ),
    eligibility = COALESCE(eligibility, '{}'::jsonb) || jsonb_build_object(
      'internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '18.10.2026: עודכן לפי גיליון המרכזים הרב-צוותיים, מול https://www.bayit-cham.org.il/ . נוסף הצוות, ההסדר עם הקופות, והמרפאות. עלות למטופל לא צוינה באתר.', E'\n ')
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 62
  AND COALESCE(public_fields->>'target', '') = ''
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

-- Row 70, reviewed text: add the phone, the rest of who pays, and the team caveat.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'phone', '02-6250634',
      'phoneShowNumber', true,
      'cost', 'במסגרת הסדרים עם קופות החולים, או טיפול פרטי במחיר מסובסד. גם ביטוח לאומי, משרד הביטחון, ועידת התביעות לניצולים, אחת מתשע, הלל ומוסדות אקדמיים.',
      'notes', 'בצוות פסיכולוגים, עובדים סוציאליים קליניים ופסיכותרפיסטים, וגם מטפלים באמנויות. פסיכיאטר יש רק בחלק מהסניפים, וכדאי לבדוק מול הסניף. ראו גם [עמ"ך](https://nefesh-il.org/treatment?entry=212&section=trauma).'
    ),
    eligibility = COALESCE(eligibility, '{}'::jsonb) || jsonb_build_object(
      'internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '18.10.2026: עודכן לפי גיליון המרכזים הרב-צוותיים, מול https://www.amcha.org/ . נוסף הטלפון 02-6250634, מי משלם, והערה שפסיכיאטר יש רק בחלק מהסניפים.', E'\n ')
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 70
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'target', '') = 'ניצולי שואה והדור השני, וגם נפגעי טראומה, חרדה ואובדן ובני משפחותיהם, חיילי מילואים, ילדים ובני נוער'
  AND COALESCE(public_fields->>'region', '') = 'כל הארץ (סניפים מנהריה עד באר שבע)'
  AND COALESCE(public_fields->>'cost', '') = 'במסגרת הסדרים עם קופות החולים, או טיפול פרטי מסובסד'
  AND COALESCE(public_fields->>'notes', '') = 'ראו גם [עמ"ך](https://nefesh-il.org/treatment?entry=212&section=trauma).';

-- Row 70, catalog text, if the review has not been applied.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'phone', '02-6250634',
      'phoneShowNumber', true,
      'region', 'כל הארץ (סניפים מנהריה עד באר שבע)',
      'cost', 'במסגרת הסדרים עם קופות החולים, או טיפול פרטי במחיר מסובסד. גם ביטוח לאומי, משרד הביטחון, ועידת התביעות לניצולים, אחת מתשע, הלל ומוסדות אקדמיים.',
      'notes', 'בצוות פסיכולוגים, עובדים סוציאליים קליניים ופסיכותרפיסטים, וגם מטפלים באמנויות. פסיכיאטר יש רק בחלק מהסניפים, וכדאי לבדוק מול הסניף.'
    ),
    eligibility = COALESCE(eligibility, '{}'::jsonb) || jsonb_build_object(
      'internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '18.10.2026: עודכן לפי גיליון המרכזים הרב-צוותיים, מול https://www.amcha.org/ . נוסף הטלפון, מי משלם, והצוות. פסיכיאטר יש רק בחלק מהסניפים.', E'\n ')
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 70
  AND COALESCE(public_fields->>'phone', '') = ''
  AND COALESCE(public_fields->>'region', '') = ''
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'notes', '') = '';

-- Row 203, reviewed text: keep the helpline note, add the clinic team, payment, and Ra'anana.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'כל הארץ. סניף ברעננה: אחוזה 301, ועוד סניפים',
      'cost', 'לפי מחירון לשעת טיפול, בלי צורך בחברות. סבסוד חלקי למשפחות מאמצות ומאומצים.',
      'notes', 'תלם מפעילה את שיחות התמיכה הטלפוניות של מכבי (*3028) ושל לאומית (072-2000272). פרטים בכרטיס [קווי התמיכה של קופות החולים](https://nefesh-il.org/support?entry=243&section=trauma). בצוות הטיפול פסיכיאטרים לילדים ולמבוגרים (כולל פסיכיאטר שמתמחה ב-ADHD), פסיכולוגים קליניים וחינוכיים ועובדים סוציאליים, וגם מטפלים באמנות. מטפלים בין השאר בלקויות למידה, בקשב וריכוז ובקשיים נפשיים. הפירוט לפי מאגר «קשר», והאתר לא נטען בבדיקה, וייתכן שאינו עדכני.'
    ),
    sites = CASE WHEN COALESCE(sites, '[]'::jsonb) = '[]'::jsonb
      THEN '[{"label":"רעננה","address":"אחוזה 301, רעננה","lat":32.1825932,"lng":34.8655222,"phone":"074-7292600","email":"","sort_order":0}]'::jsonb
      ELSE sites END,
    eligibility = COALESCE(eligibility, '{}'::jsonb) || jsonb_build_object(
      'internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '18.10.2026: עודכן לפי גיליון המרכזים הרב-צוותיים. הפירוט לפי מאגר קשר; האתר לא נטען. נוספו הצוות, מי משלם, ואחוזה 301 ברעננה. קווי התמיכה נשארו. הסיכה על רחוב אחוזה, כי מספר הבית לא נמצא במפה.', E'\n ')
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 203
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'region', '') = 'כל הארץ'
  AND COALESCE(public_fields->>'notes', '') = 'תלם מפעילה את שיחות התמיכה הטלפוניות של מכבי (*3028) ושל לאומית (072-2000272). פרטים בכרטיס [קווי התמיכה של קופות החולים](https://nefesh-il.org/support?entry=243&section=trauma).';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, 'רעננה', 'אחוזה 301, רעננה', 32.1825932, 34.8655222, 0
FROM directory_card_edits c
WHERE c.row_id = 203
  AND c.entry_id IS NOT NULL
ON CONFLICT (row_id, label) DO NOTHING;

-- Row 203, catalog text, if the review has not been applied. Keep the existing helpline phones.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'כל הארץ. סניף ברעננה: אחוזה 301, ועוד סניפים',
      'cost', 'לפי מחירון לשעת טיפול, בלי צורך בחברות. סבסוד חלקי למשפחות מאמצות ומאומצים.',
      'notes', 'קווי תמיכה נפשית בחרבות ברזל — פרטים נוספים באתר. בצוות הטיפול פסיכיאטרים לילדים ולמבוגרים (כולל פסיכיאטר שמתמחה ב-ADHD), פסיכולוגים קליניים וחינוכיים ועובדים סוציאליים, וגם מטפלים באמנות. מטפלים בין השאר בלקויות למידה, בקשב וריכוז ובקשיים נפשיים. הפירוט לפי מאגר «קשר», והאתר לא נטען בבדיקה, וייתכן שאינו עדכני.'
    ),
    sites = CASE WHEN COALESCE(sites, '[]'::jsonb) = '[]'::jsonb
      THEN '[{"label":"רעננה","address":"אחוזה 301, רעננה","lat":32.1825932,"lng":34.8655222,"phone":"074-7292600","email":"","sort_order":0}]'::jsonb
      ELSE sites END,
    eligibility = COALESCE(eligibility, '{}'::jsonb) || jsonb_build_object(
      'internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '18.10.2026: עודכן לפי גיליון המרכזים הרב-צוותיים. הפירוט לפי מאגר קשר; האתר לא נטען. נוספו הצוות, מי משלם, ואחוזה 301 ברעננה. קווי החירום נשארו.', E'\n ')
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE row_id = 203
  AND COALESCE(public_fields->>'cost', '') = ''
  AND COALESCE(public_fields->>'region', '') = 'כל הארץ'
  AND COALESCE(public_fields->>'notes', '') = 'קווי תמיכה נפשית בחרבות ברזל — פרטים נוספים באתר.';

-- Row 300: a short cross-link to the English-speaking clinic. The day-care card stays as it is.
UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'notes', 'היחידה פועלת בהפרדה מגדרית. טלפון המחלקה לפי טבלת מילם. פרטי המימון בדף היחידה מתייחסים למרפאות החוץ הפסיכיאטריות של המרכז. בלי התחייבות — תעריף בית החולים. המרפאה לדוברי אנגלית: [מרפאה לדוברי אנגלית](https://nefesh-il.org/treatment?entry=355&section=mh_clinics).'
    ),
    eligibility = COALESCE(eligibility, '{}'::jsonb) || jsonb_build_object(
      'internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '18.10.2026: נוסף קישור למרפאה לדוברי אנגלית (שורה 355).', E'\n ')
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '300|||טיפול יום פסיכיאטרי בהפרדה מגדרית — לציבור הדתי והחרדי'
  AND COALESCE(public_fields->>'notes', '') = 'היחידה פועלת בהפרדה מגדרית. טלפון המחלקה לפי טבלת מילם. פרטי המימון בדף היחידה מתייחסים למרפאות החוץ הפסיכיאטריות של המרכז. בלי התחייבות — תעריף בית החולים.';

INSERT INTO glossary_card_links (term_key, card_key, status, matched_text)
VALUES
('multidisciplinary_center', '345|||מרכז טיפול ואבחון רב-תחומי לפרט ולמשפחה', 'approved', 'מרכז גוני'),
('multidisciplinary_center', '346|||מרכז לתמיכה רגשית ונפשית', 'approved', 'מרכז ד״ר טל'),
('multidisciplinary_center', '347|||מכון לאבחון ולייעוץ, מגיל הרך עד מבוגרים', 'approved', 'הכח לשנות'),
('multidisciplinary_center', '348|||מרכז מומחים רב-תחומי, כולל מרכז נווה להפרעות אכילה', 'approved', 'קשת רפואה'),
('multidisciplinary_center', '349|||טיפול בהפרעות אכילה — טיפול יום למבוגרים וטיפול אמבולטורי', 'approved', 'המכון להפרעות אכילה ע״ש אפרת צוק (רעות)'),
('multidisciplinary_center', '350|||מרפאה רב-תחומית לבריאות הנפש', 'approved', 'FYM'),
('multidisciplinary_center', '351|||מרכז פסיכולוגי-חינוכי לילדים ולנוער', 'approved', 'א׳ עד ת׳'),
('multidisciplinary_center', '352|||מכון לבריאות התנהגותית, עם צוות דובר אנגלית', 'approved', 'מכון דביר'),
('multidisciplinary_center', '353|||מרכז לטיפול בילד, במבוגר ובמשפחה', 'approved', 'חוף הגליל'),
('multidisciplinary_center', '354|||טיפול נפשי לילדים, לנוער ולמבוגרים', 'approved', 'תחנת העמקים'),
('multidisciplinary_center', '355|||מרפאה לבריאות הנפש לדוברי אנגלית', 'approved', 'מעייני הישועה — מרפאה לדוברי אנגלית')
ON CONFLICT (term_key, card_key) DO UPDATE SET
  status = 'approved',
  reviewed_at = now()
WHERE glossary_card_links.status IS DISTINCT FROM 'rejected';

-- Rows 62, 70, and 203 already exist. Copy the stored card_key. Row 62's key
-- contains a line break, so a typed copy of it does not match.
DO $$
BEGIN
  IF (SELECT count(DISTINCT row_id) FROM directory_card_edits WHERE row_id IN (62, 70, 203)) <> 3 THEN
    RAISE EXCEPTION 'directory_card_edits is missing row 62, 70, or 203';
  END IF;
END $$;

INSERT INTO glossary_card_links (term_key, card_key, status, matched_text)
SELECT 'multidisciplinary_center', c.card_key, 'approved', v.matched_text
FROM (VALUES
  (62, 'עמותת בית חם'),
  (70, 'עמך'),
  (203, 'תלם')
) AS v(row_id, matched_text)
JOIN directory_card_edits c ON c.row_id = v.row_id
ON CONFLICT (term_key, card_key) DO UPDATE SET
  status = 'approved',
  reviewed_at = now()
WHERE glossary_card_links.status IS DISTINCT FROM 'rejected';

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, term_keys, card_keys, migration)
VALUES
  (
    '2026-10-18-multidisciplinary-center',
    DATE '2026-10-18',
    'מונח חדש: מרכז רב-צוותי לבריאות הנפש',
    'נוסף למילון מונח על מרכז לבריאות הנפש עם גישה כוללנית וצוות רב-תחומי. מתחת למונח מופיעה רשימת המרכזים שעונים על ההגדרה.',
    'glossary',
    ARRAY['multidisciplinary_center'],
    '{}',
    '091_multidisciplinary_mh_centers.sql'
  ),
  (
    '2026-10-18-multidisciplinary-center-cards',
    DATE '2026-10-18',
    'מרכזים רב-צוותיים לבריאות הנפש',
    'נוספו כרטיסים למרכזים רב-צוותיים שלא היו במדריך, ועודכנו הכרטיסים של בית חם, עמך ותלם לפי אותה רשימה.',
    'cards',
    '{}',
    ARRAY[
    '345|||מרכז טיפול ואבחון רב-תחומי לפרט ולמשפחה',
    '346|||מרכז לתמיכה רגשית ונפשית',
    '347|||מכון לאבחון ולייעוץ, מגיל הרך עד מבוגרים',
    '348|||מרכז מומחים רב-תחומי, כולל מרכז נווה להפרעות אכילה',
    '349|||טיפול בהפרעות אכילה — טיפול יום למבוגרים וטיפול אמבולטורי',
    '350|||מרפאה רב-תחומית לבריאות הנפש',
    '351|||מרכז פסיכולוגי-חינוכי לילדים ולנוער',
    '352|||מכון לבריאות התנהגותית, עם צוות דובר אנגלית',
    '353|||מרכז לטיפול בילד, במבוגר ובמשפחה',
    '354|||טיפול נפשי לילדים, לנוער ולמבוגרים',
    '355|||מרפאה לבריאות הנפש לדוברי אנגלית',
    (SELECT c.card_key FROM directory_card_edits c WHERE c.row_id = 62 ORDER BY c.id LIMIT 1),
    (SELECT c.card_key FROM directory_card_edits c WHERE c.row_id = 70 ORDER BY c.id LIMIT 1),
    (SELECT c.card_key FROM directory_card_edits c WHERE c.row_id = 203 ORDER BY c.id LIMIT 1)
    ],
    '091_multidisciplinary_mh_centers.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
