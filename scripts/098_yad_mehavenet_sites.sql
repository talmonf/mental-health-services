-- Migration 098 (19 Oct 2026)
-- יד מכוונת (row 4) becomes a multi-address card from the National Insurance
-- centers list. Glossary links for btl, medical_committee, and guidance_service
-- are approved. Audit wording approved with the plan on 19.10.2026.
-- The UPDATE applies only while the card still has the expected region, website,
-- and empty notes, so a later admin edit is not overwritten.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'region', 'אשדוד, באר שבע, חולון, חיפה, ירושלים, נצרת, חדרה, טבריה, פתח תקווה, צפת, קריית שמונה, כרמיאל, סכנין',
      'notes', 'מרכזי ירושלים, פתח תקווה, אשדוד, באר שבע וחולון מטפלים גם במיצוי זכויות מול משרד הבריאות (סל שיקום), רשות המיסים (פטור ממס הכנסה), הרשות המקומית (הנחה בארנונה) ומשרד הבינוי והשיכון (סיוע בשכר דירה). טבריה: בתיאום מראש, יום ראשון 9:00–12:30. קריית שמונה: בתיאום מראש, יום חמישי 9:00–12:30. כרמיאל: בתיאום מראש, יום חמישי 9:00–13:00. סכנין: יום שני 9:00–14:00, ליד בניין ההסתדרות. דוא״ל: אשדוד MerkazyAS@femi.com · באר שבע ymbsheva@amalgroup.co.il · חולון MerkazyHO@femi.com · חיפה Yadhaifa@mediton.co.il · ירושלים merkazye@femi.com · נצרת ynazareth@femi.com · חדרה yadmhadera@ors-siud.co.il · טבריה, צפת, קריית שמונה וכרמיאל yadzefat@mediton.co.il · פתח תקווה merkazym@femi.com · סכנין m.7okok.sakhnin@gmail.com.',
      'webLabel', 'יד מכוונת',
      'web2', 'https://www.btl.gov.il/snifim/Pages/ResimaYaMecavenet.aspx',
      'webLabel2', 'רשימת המרכזים',
      'add', 'https://www.kolzchut.org.il/he/%D7%99%D7%93_%D7%9E%D7%9B%D7%95%D7%95%D7%A0%D7%AA_-_%D7%99%D7%99%D7%A2%D7%95%D7%A5_%D7%95%D7%94%D7%9B%D7%95%D7%95%D7%A0%D7%94_%D7%97%D7%99%D7%A0%D7%9D_%D7%9C%D7%95%D7%95%D7%A2%D7%93%D7%95%D7%AA_%D7%A8%D7%A4%D7%95%D7%90%D7%99%D7%95%D7%AA_%D7%A9%D7%9C_%D7%94%D7%91%D7%99%D7%98%D7%95%D7%97_%D7%94%D7%9C%D7%90%D7%95%D7%9E%D7%99',
      'addLabel', 'כל זכות'
    ),
    sites = '[
      {"label":"אשדוד","address":"שדרות ירושלים 18, קומה 1, חדר 122, אשדוד","lat":31.7913877,"lng":34.6498448,"phone":"","email":"MerkazyAS@femi.com","sort_order":0},
      {"label":"באר שבע","address":"שדרות יצחק רגר 11, קומה 3, מגדל 7, באר שבע","lat":31.2597921,"lng":34.7982013,"phone":"","email":"ymbsheva@amalgroup.co.il","sort_order":1},
      {"label":"חולון","address":"המשביר 1, קומה 2, חולון","lat":32.0127722,"lng":34.8048098,"phone":"","email":"MerkazyHO@femi.com","sort_order":2},
      {"label":"חיפה","address":"דוד אלעזר 10, בניין אלמוג, קומה 4, חיפה","lat":32.806172,"lng":34.9566845,"phone":"","email":"Yadhaifa@mediton.co.il","sort_order":3},
      {"label":"ירושלים","address":"יפו 97, בניין כלל, קומה 16, ירושלים","lat":31.7841441,"lng":35.2146792,"phone":"","email":"merkazye@femi.com","sort_order":4},
      {"label":"נצרת","address":"יוחנן פאולוס השישי 53, קומה 4, נצרת","lat":32.7030839,"lng":35.2995677,"phone":"","email":"ynazareth@femi.com","sort_order":5},
      {"label":"חדרה","address":"אחד העם 9, בניין קורן 2, קומה 4, חדרה","lat":32.4359443,"lng":34.9159363,"phone":"","email":"yadmhadera@ors-siud.co.il","sort_order":6},
      {"label":"טבריה","address":"הגלבוע 1, טבריה","lat":32.787859,"lng":35.5386177,"phone":"","email":"yadzefat@mediton.co.il","sort_order":7},
      {"label":"פתח תקווה","address":"מוטה גור 5, פארק אולימפיה, קומה 3, פתח תקווה","lat":32.0947753,"lng":34.8641768,"phone":"","email":"merkazym@femi.com","sort_order":8},
      {"label":"צפת","address":"החרמון 1, צפת","lat":32.962478,"lng":35.5145941,"phone":"","email":"yadzefat@mediton.co.il","sort_order":9},
      {"label":"קריית שמונה","address":"שדרות תל חי, מרכז מסחרי, קריית שמונה","lat":33.2236087,"lng":35.5757074,"phone":"","email":"yadzefat@mediton.co.il","sort_order":10},
      {"label":"כרמיאל","address":"הכבאי 3, כרמיאל","lat":32.9227593,"lng":35.305666,"phone":"","email":"yadzefat@mediton.co.il","sort_order":11},
      {"label":"סכנין","address":"שכונה מערבית 42, סכנין","lat":32.8638052,"lng":35.3023184,"phone":"","email":"m.7okok.sakhnin@gmail.com","sort_order":12}
    ]'::jsonb,
    eligibility = COALESCE(eligibility, '{}'::jsonb) || jsonb_build_object(
      'location_mode', 'sites',
      'internal_notes', ltrim(rtrim(COALESCE(eligibility->>'internal_notes', '')) || E'\n\n' || '19.10.2026: נבדק מול https://www.btl.gov.il/snifim/Pages/ResimaYaMecavenet.aspx. נוספו 13 מרכזים. הסיכה באשדוד, בנצרת, בטבריה, בקריית שמונה ובכרמיאל היא על הרחוב, כי מספר הבית לא נמצא כבניין במפה. הסיכה בפתח תקווה היא על פארק אולימפיה. הסיכה בסכנין היא על היישוב, כי «שכונה מערבית 42» לא נמצאה במפה. פקסים לא פורסמו בכרטיס.', E'\n ')
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '4|||ייעוץ והכנה בחינם לוועדה הרפואית'
  AND COALESCE(public_fields->>'region', '') = 'כל הארץ'
  AND COALESCE(public_fields->>'web', '') = 'https://www.btl.gov.il/snifim/Pages/yadMechavenet1.aspx'
  AND COALESCE(public_fields->>'notes', '') = '';

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
VALUES
  (4, 'יד_מכוונת_4', 'אשדוד', 'שדרות ירושלים 18, קומה 1, חדר 122, אשדוד', 31.7913877, 34.6498448, 0),
  (4, 'יד_מכוונת_4', 'באר שבע', 'שדרות יצחק רגר 11, קומה 3, מגדל 7, באר שבע', 31.2597921, 34.7982013, 1),
  (4, 'יד_מכוונת_4', 'חולון', 'המשביר 1, קומה 2, חולון', 32.0127722, 34.8048098, 2),
  (4, 'יד_מכוונת_4', 'חיפה', 'דוד אלעזר 10, בניין אלמוג, קומה 4, חיפה', 32.806172, 34.9566845, 3),
  (4, 'יד_מכוונת_4', 'ירושלים', 'יפו 97, בניין כלל, קומה 16, ירושלים', 31.7841441, 35.2146792, 4),
  (4, 'יד_מכוונת_4', 'נצרת', 'יוחנן פאולוס השישי 53, קומה 4, נצרת', 32.7030839, 35.2995677, 5),
  (4, 'יד_מכוונת_4', 'חדרה', 'אחד העם 9, בניין קורן 2, קומה 4, חדרה', 32.4359443, 34.9159363, 6),
  (4, 'יד_מכוונת_4', 'טבריה', 'הגלבוע 1, טבריה', 32.787859, 35.5386177, 7),
  (4, 'יד_מכוונת_4', 'פתח תקווה', 'מוטה גור 5, פארק אולימפיה, קומה 3, פתח תקווה', 32.0947753, 34.8641768, 8),
  (4, 'יד_מכוונת_4', 'צפת', 'החרמון 1, צפת', 32.962478, 35.5145941, 9),
  (4, 'יד_מכוונת_4', 'קריית שמונה', 'שדרות תל חי, מרכז מסחרי, קריית שמונה', 33.2236087, 35.5757074, 10),
  (4, 'יד_מכוונת_4', 'כרמיאל', 'הכבאי 3, כרמיאל', 32.9227593, 35.305666, 11),
  (4, 'יד_מכוונת_4', 'סכנין', 'שכונה מערבית 42, סכנין', 32.8638052, 35.3023184, 12)
ON CONFLICT (row_id, label) DO NOTHING;

INSERT INTO glossary_card_links (term_key, card_key, status, matched_text)
SELECT v.term_key, c.card_key, 'approved', v.matched_text
FROM directory_card_edits c
JOIN (VALUES
  ('btl', 'יד מכוונת'),
  ('medical_committee', 'יד מכוונת'),
  ('guidance_service', 'יד מכוונת')
) AS v(term_key, matched_text) ON true
WHERE c.row_id = 4
ON CONFLICT (term_key, card_key) DO UPDATE SET
  status = 'approved',
  matched_text = EXCLUDED.matched_text,
  reviewed_at = now()
WHERE glossary_card_links.status IS DISTINCT FROM 'rejected';

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-19-yad-mehavenet-sites',
    DATE '2026-10-19',
    'כתובות מרכזי יד מכוונת',
    'בכרטיס «יד מכוונת» מופיעות עכשיו הכתובות של המרכזים, עם מפה לכל עיר. יש שלושה כפתורי אתר: דף יד מכוונת, רשימת המרכזים, וכל זכות. בכרטיס גם שעות המרכזים שנפתחים רק בתיאום, והמייל של כל מרכז.',
    'cards',
    ARRAY['4|||ייעוץ והכנה בחינם לוועדה הרפואית'],
    '{}',
    '098_yad_mehavenet_sites.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-19-glossary-phone-labels',
    DATE '2026-10-19',
    'טלפונים במילון',
    'בכרטיס «ביטוח לאומי» נוסף הטלפון *2496 עם הכיתוב יד מכוונת, ולטלפון *6050 נוסף הכיתוב ביטוח לאומי. הכרטיס מפנה לכרטיס יד מכוונת. בכרטיס «ועדה רפואית» הוסר כפתור הטלפון, ובמקומו יש קישור לכרטיס יד מכוונת. בכרטיס «אגף השיקום» לכל כפתור טלפון יש שם: מוקד אגף השיקום, ונפש אחת. בכרטיס «יד מכוונת» במילון יש שני כפתורי אתר: לדף השירות ולרשימת המרכזים.',
    'glossary',
    ARRAY['4|||ייעוץ והכנה בחינם לוועדה הרפואית'],
    ARRAY['btl', 'medical_committee', 'mod_rehab', 'guidance_service'],
    '098_yad_mehavenet_sites.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-19-glossary-paragraphs',
    DATE '2026-10-19',
    'פסקאות בכרטיסי המילון',
    'הטקסט בכל כרטיסי המילון מחולק עכשיו לפסקאות, כדי שיהיה קל יותר לקרוא אותו.',
    'glossary',
    '{}',
    ARRAY['disability','sharam','nursing','rehab_basket','medical_committee','rights_utilization','guidance_service','cbt','somatic','emdr','therapy','psychodynamic','group_therapy','couples_therapy','family_therapy','art_therapy','occupational_therapy','hypnosis','online_therapy','tms','ect','sgb','prism','spravato','tdcs','vns','dbs','psychiatrist','psychologist','social_worker','art_therapist','occupational_therapist_prof','hospitalization','voluntary_hosp','involuntary_hosp','psychiatric_order','day_hosp','home_hosp','balancing_homes','safe_house','crisis_team','supported_housing','rehab_club','vocational_rehab','community_support','rehabilitation','hmo','clalit','maccabi','meuhedet','leumit','ptsd','cptsd','depression','anxiety','eating_disorders','bipolar','schizophrenia','ocd','adhd','mental_health_clinic','multidisciplinary_center','psychiatric_er','resilience_center','helpline','mental_support','day_treatment','form17','btl','moh','mod_rehab','family_doctor','rehab_committee','supported_employment','hostel','open_closed_ward','sexual_trauma','medication','eran','postpartum_depression','health_basket','trauma','family_support','addictions','alternatives'],
    '098_yad_mehavenet_sites.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
