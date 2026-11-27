-- Migration 154 (27 Nov 2026)
-- הקליניקה ברוטשילד (row 789): a private clinic on Rothschild Boulevard, Tel Aviv, and online.
-- One card, under טיפולים → טיפול רגשי and טיפולים → פסיכיאטריה.
-- Pin: שדרות רוטשילד 11, תל אביב. OSM node 2078977760.
-- rothschild-clinic.com and shenkinclinic.com are the same Hebrew site.
-- Audit wording approved with the plan on 27.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'הקליניקה_ברוטשילד_789',
  'הקליניקה ברוטשילד',
  'פסיכותרפיה, וגם אבחון וטיפול תרופתי, במרפאה או בזום',
  'treatments',
  ARRAY['treatments']::text[],
  ARRAY['self_referral']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (
  card_key, row_id, entry_id, public_fields, eligibility, sites, indicators, translations, site_languages
) VALUES (
  '789|||מרפאה פרטית: פסיכותרפיה, וגם אבחון וטיפול תרופתי. במרפאה או בזום.',
  789,
  'הקליניקה_ברוטשילד_789',
  $card789${"org":"הקליניקה ברוטשילד","svc":"מרפאה פרטית: פסיכותרפיה, וגם אבחון וטיפול תרופתי. במרפאה או בזום.","target":"ילדים מגיל שלוש, נוער ומבוגרים","region":"תל אביב","founded":"","meeting":"both","cost":"פרטי. גם מסלול מוזל למתמודדי נפש ולמי שידם אינה משגת.","specialty":"חרדה, דיכאון, טראומה, אוטיזם, התמכרויות","approaches":"טיפול דינמי, CBT, DBT, EMDR, טיפול באומנויות, טיפול זוגי, טיפול משפחתי, טיפול קבוצתי, טיפול דיאדי, הדרכת הורים","languages":"","diseases":"","notes":"גם ליווי בבית, בגינה או בבית קפה, במקביל לטיפול או בנפרד. גם ייעוץ תעסוקתי. פנייה בטופס באתר, ושיחת היכרות תוך יום עסקים. במסלול המוזל הטיפול אצל מתמחים, בהדרכה, או בשיתוף עמותות.","tags":"","whatsapp":"","whatsappLabel":"","email":"ShenkinClinic@gmail.com","emailLabel":"אימייל","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://www.rothschild-clinic.com/","webLabel":"","web2":"https://www.rothschild-clinic.com/סוגי-הטיפול","webLabel2":"סוגי הטיפול","add":"https://www.facebook.com/shenkinclinic","addLabel":"פייסבוק","add2":"","addLabel2":"","add3":"","addLabel3":"","phone":"050-5623026","phoneLabel":"עמית","phoneShowNumber":false,"phone2":"052-2686771","phoneLabel2":"קרין","phoneShowNumber2":false,"phone3":"054-6551544","phoneLabel3":"אורטל","phoneShowNumber3":false,"phone4":"052-5252980","phoneLabel4":"נועה","phoneShowNumber4":false,"phone5":"","phoneLabel5":"","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":false}$card789$::jsonb,
  $elig789${"age_min":3,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":["חרדה","דיכאון","טראומה","אוטיזם","התמכרויות"],"presenting_problems":["חרדה","דיכאון","טראומה","אוטיזם","התמכרויות"],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"27.11.2026: נבדק מול https://www.rothschild-clinic.com/ , https://www.rothschild-clinic.com/אודות , https://www.rothschild-clinic.com/services-4 , https://www.rothschild-clinic.com/סוגי-הטיפול , https://www.rothschild-clinic.com/דברו-איתנו ו-https://shenkinclinic.com/ . shenkinclinic.com הוא אותו אתר. השם בכרטיס הוא הקליניקה ברוטשילד, כמו בכותרות בעברית. שם העסק ב-Wix הוא SheinkinClinic, דף הפייסבוק הוא facebook.com/shenkinclinic, ונושא המייל הוא «היי קליניקה בשינקין». אלה לא על הכרטיס. הטקסט הגלוי ליד המייל הוא info@SheinkinClinic.com, והקישור עצמו הוא mailto:ShenkinClinic@gmail.com. בכרטיס רק הכתובת שהקישור פותח. אייקון הוואטסאפ באתר הוא קישור tel:0525252980 של נועה, לא wa.me, ולכן אין כפתור וואטסאפ. טלפונים מדף «דברו איתנו»: עמית 050-5623026, קרין 052-2686771, אורטל 054-6551544, נועה 052-5252980. בפוטר של דף הבית רק נועה וקרין. פסיכיאטר בצוות: ד״ר רפאל מררוס, טיפול תרופתי למבוגרים. עמודי השירות לא מונים פסיכיאטריה כשירות נפרד. גיל שלוש מעמוד סוגי הטיפול. עמוד «למי הטיפול מתאים» כותב אוטיזם בתפקוד גבוה, ועמוד סוגי הטיפול כותב את הספקטרום לכל גווניו. בכרטיס: אוטיזם. טיפול דיאדי מתואר עד גיל 6, ולא על הכרטיס. אין שנת הקמה, אין מחירון ואין שעות. האתר כותב טיפול מקוון, לא את המילה זום. סיכה: OSM node 2078977760, שדרות רוטשילד 11. התגית ב-OSM היא רוטשילד, בלי «שדרות». אין כתובת בשינקין באתר, ולכן אין סיכה שנייה. 27.11.2026: נוסח היומן אושר עם התוכנית."}$elig789$::jsonb,
  '[{"label":"תל אביב","address":"שדרות רוטשילד 11, תל אביב","lat":32.063137,"lng":34.770399,"phone":"","email":"","note":"","sort_order":0}]'::jsonb,
  $ind789${"offers":["care"],"whole_org":true,"funding":[{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":"פנייה בטופס באתר, ושיחת היכרות תוך יום עסקים.","ownership":"private","app":""}$ind789$::jsonb,
  $en789${"en":{"org":"RothschildClinic","svc":"Private clinic: psychotherapy, and also assessment and medication. At the clinic or on Zoom.","target":"Children from age three, teens, and adults","region":"Tel Aviv","cost":"Private. Also a reduced-fee track for people living with mental illness and for people who cannot pay the full fee.","specialty":"Anxiety, depression, trauma, autism, addictions","languages":"","notes":"Also accompaniment at home, in a garden, or in a cafe, alongside therapy or on its own. Also career counseling. Apply on the form on the website, and an introductory call within one business day. On the reduced-fee track, the therapy is with trainees, under supervision, or through partnerships with nonprofits.","phoneLabel":"Amit","phoneLabel2":"Karin","phoneLabel3":"Ortal","phoneLabel4":"Noa","emailLabel":"Email","webLabel2":"Kinds of therapy","addLabel":"Facebook","siteLabels":["Tel Aviv"],"siteAddresses":["11 Sderot Rothschild, Tel Aviv"],"approaches":"Dynamic therapy, CBT, DBT, EMDR, arts therapies, couples therapy, family therapy, group therapy, dyadic therapy, and parent guidance"}}$en789$::jsonb,
  '{"he":{"web":"https://www.rothschild-clinic.com/","web2":"https://www.rothschild-clinic.com/סוגי-הטיפול","add":"https://www.facebook.com/shenkinclinic"}}'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c
JOIN (
  VALUES
    (789, 'תל אביב', 'שדרות רוטשילד 11, תל אביב', 32.063137::float8, 34.770399::float8, 0)
) AS v(row_id, label, address, lat, lng, sort_order)
  ON v.row_id = c.row_id
WHERE c.card_key = '789|||מרפאה פרטית: פסיכותרפיה, וגם אבחון וטיפול תרופתי. במרפאה או בזום.'
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-27-rothschild-clinic',
  DATE '2026-11-27',
  'נוסף הקליניקה ברוטשילד',
  'מרפאה פרטית בתל אביב, בשדרות רוטשילד 11, וגם בזום. פסיכותרפיה, וגם אבחון וטיפול תרופתי, לילדים מגיל שלוש, לנוער ולמבוגרים. הכרטיס בטיפול רגשי ובפסיכיאטריה.',
  'cards',
  ARRAY['789|||מרפאה פרטית: פסיכותרפיה, וגם אבחון וטיפול תרופתי. במרפאה או בזום.'],
  '{}',
  '154_rothschild_clinic.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
