-- Migration 137 (19 Nov 2026)
-- IsraClinic (row 784): a private psychiatric clinic in Tel Aviv and online.
-- One card, under מרפאות בריאות הנפש and טיפולים → פסיכיאטריה.
-- Pin: ברודצקי 43, תל אביב, 6905234. OSM node 2079182578.
-- Hebrew israclinic.org, English psy.clinic, Russian israclinic.com.
-- Audit wording approved with the plan on 19.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'israclinic_784',
  'IsraClinic',
  'אבחון וטיפול תרופתי, וגם פסיכותרפיה, במרפאה או בזום',
  'mh_clinics',
  ARRAY['mh_clinics', 'treatments']::text[],
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
  '784|||מרפאה פסיכיאטרית פרטית: אבחון וטיפול תרופתי, וגם פסיכותרפיה. במרפאה או בזום.',
  784,
  'israclinic_784',
  $card784${"org":"IsraClinic","svc":"מרפאה פסיכיאטרית פרטית: אבחון וטיפול תרופתי, וגם פסיכותרפיה. במרפאה או בזום.","target":"מבוגרים","region":"תל אביב","cost":"פרטי. אין חיוב ישיר לקופה. אפשר לקבל מסמכים להחזר מביטוח. בירור ראשוני ללא עלות.","specialty":"דיכאון, חרדה, התקפי פאניקה, OCD, פוסט־טראומה (כולל מלחמה ושירות), דו־קוטבית, סכיזופרניה והפרעה סכיזואפקטיבית, הפרעות אישיות (כולל גבולית), קשב במבוגרים, תחלואה כפולה, כאב כרוני, פסיכיאטריה בגיל המבוגר","languages":"עברית, רוסית, אנגלית","diseases":"","notes":"גם טיפול זוגי, קבוצתי והדרכת משפחה. אחרי ייעוץ יש חודש מעקב. חוות דעת לביטוח לאומי, לצה״ל או לאגף השיקום היא תהליך נפרד. בהפרעות אכילה מפנים הלאה. מגיל 17 וחצי אפשר לפנות בהסכמת הורים או אפוטרופוס.","tags":"","whatsapp":"972587707173","whatsappLabel":"וואטסאפ","email":"info@israclinic.org","emailLabel":"עברית","emailShowAddress":false,"email2":"info@psy.clinic","emailLabel2":"אנגלית","emailShowAddress2":false,"email3":"info@israclinic.com","emailLabel3":"רוסית","emailShowAddress3":false,"web":"https://israclinic.org/","webLabel":"","web2":"https://israclinic.org/treatment-at-israclinic","webLabel2":"איך מתנהל הטיפול","add":"https://psy.clinic/treatment-at-israclinic/services_and_prices_israclinic","addLabel":"מחירון","add2":"https://t.me/israclinic_bot","addLabel2":"טלגרם","add3":"","addLabel3":"","phone":"03-375-1819","phoneLabel":"עברית","phoneShowNumber":false,"phone2":"03-375-1370","phoneLabel2":"אנגלית","phoneShowNumber2":false,"phone3":"077-556-5790","phoneLabel3":"רוסית","phoneShowNumber3":false,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true,"founded":"2005","approaches":"CBT, טיפול דינמי, EMDR, DBT, סכמה תרפיה, TFP, טיפול תמיכתי, ERP, מיינדפולנס, טיפול באומנות, מציאות מדומה ופסיכודרמה","meeting":"both"}$card784$::jsonb,
  $elig784${"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":["דיכאון","חרדה","התקפי פאניקה","OCD","פוסט־טראומה","דו־קוטבית","סכיזופרניה","הפרעה סכיזואפקטיבית","הפרעות אישיות","קשב במבוגרים","תחלואה כפולה","כאב כרוני"],"presenting_problems":["דיכאון","חרדה","התקפי פאניקה","OCD","פוסט־טראומה","דו־קוטבית","סכיזופרניה","הפרעה סכיזואפקטיבית","הפרעות אישיות","קשב במבוגרים","תחלואה כפולה","כאב כרוני"],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"19.11.2026: נבדק מול https://israclinic.org/ , https://israclinic.org/treatment-at-israclinic , https://israclinic.org/psychiatry-in-israel , https://israclinic.org/psychotherapy-in-israel/psychotherapy-in-israclinic , https://israclinic.org/contacts , https://psy.clinic/ , https://psy.clinic/contacts , https://psy.clinic/treatment-at-israclinic/services_and_prices_israclinic ו-https://www.israclinic.com/lechenie-v-israclinic/contacts/ . שלושה אתרים של אותה מרפאה: עברית israclinic.org (03-375-1819, info@israclinic.org), אנגלית psy.clinic (03-375-1370, info@psy.clinic), רוסית israclinic.com (077-556-5790, info@israclinic.com). בדף הקשר בעברית גם וואטסאפ https://wa.me/972587707173 , טלגרם https://t.me/israclinic_bot ווייבר viber://pa?chatURI=israclinic-isr . קו לרוסיה +7 495 148 72 72 מפורסם באתר הרוסי. ru@israclinic.com ו-crm@israclinic.com לא על הכרטיס. שעות בכרטיס לפי דף הקשר בעברית, כולל סגור ביום שלישי. דפי הקשר באנגלית וברוסית כותבים א׳–ה׳ בלי לציין שלישי. עמוד הטלמדיסין בעברית עדיין מציין 03-3751370, וזה קו האנגלית. מחירון רק באתר האנגלי, ינואר 2026. אומנות ומציאות מדומה במרפאה בלבד, וה-MOXO המלא הוא 1,600 ₪ בתוספת עלות התרופה. עמוד הטיפול בעברית, אוקטובר 2026: פסיכיאטריה של מבוגרים, מגיל 17 וחצי בהסכמת הורים, והפרעות אכילה מופנות הלאה. באתר האנגלי יש ביוגרפיה של ליהי גבעול להדרכת הורים ולטיפול רגשי בילדים ובמתבגרים, ומחירון ה-MOXO כותב גם ילדים ומתבגרים. זה לא על הכרטיס. ידיעה באתר הרוסי על מעבר זמני לאונליין בגלל נזק לבניין: https://www.israclinic.com/useful-information/medical-news/klinika-israclinic-vremenno-priostanavlivaet-ocnyi-priem/ . דף הקשר בעברית מפרסם קבלה פרונטלית בברודצקי 43, ולכן הידיעה לא על הכרטיס. סיכה: OSM node 2079182578, ברודצקי 43. המיקוד באתר 6905234. ב-OSM המיקוד 6946032, ולא הועתק. 19.11.2026, בעל האתר: השם בכרטיס הוא IsraClinic, כמו באתר עצמו. בלי מחירון, בלי שעות פתיחה, ובלי משפט על מוקד חירום. וייבר לא על הכרטיס. קו +7 לרוסיה לא על הכרטיס, כי «רוסיה» ליד «רוסית» לא ברור. הטלפונים והמיילים נפתחים מרשימה אחת."}$elig784$::jsonb,
  '[{"label":"תל אביב","address":"ברודצקי 43, תל אביב, 6905234","lat":32.111776,"lng":34.797624,"phone":"","email":"","note":"","sort_order":0}]'::jsonb,
  $ind784${"offers":["care"],"whole_org":true,"funding":[{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":"אין צורך בהפניה מקופת החולים. בירור ראשוני ללא עלות.","ownership":"private","app":""}$ind784$::jsonb,
  $en784${"en":{"org":"IsraClinic","svc":"Private psychiatric clinic: assessment and medication, and also psychotherapy. At the clinic or on Zoom.","target":"Adults","region":"Tel Aviv","cost":"Private. The clinic does not bill a health fund directly. Documents can be provided for an insurance reimbursement. A first inquiry is free.","specialty":"Depression, anxiety, panic attacks, OCD, post-trauma (including war and military service), bipolar disorder, schizophrenia and schizoaffective disorder, personality disorders (including borderline), adult ADHD, dual diagnosis, chronic pain, psychiatry in older age","languages":"Hebrew, Russian, English","notes":"Also couples therapy, group therapy, and family guidance. After a consultation there is a month of follow-up. An opinion for the National Insurance Institute, the IDF, or the Ministry of Defense rehabilitation department is a separate process. Eating disorders are referred elsewhere. From age 17 and a half, a person can apply with a parent or guardian's consent.","phoneLabel":"Hebrew","phoneLabel2":"English","phoneLabel3":"Russian","emailLabel":"Hebrew","emailLabel2":"English","emailLabel3":"Russian","web":"https://psy.clinic/","web2":"https://psy.clinic/treatment-at-israclinic/About-IsraClinic","webLabel2":"How treatment works","add":"https://psy.clinic/treatment-at-israclinic/services_and_prices_israclinic","addLabel":"Prices","addLabel2":"Telegram","whatsappLabel":"WhatsApp","siteLabels":["Tel Aviv"],"siteAddresses":["43 Brodetsky St, Tel Aviv, 6905234"],"founded":"2005","approaches":"CBT, dynamic therapy, EMDR, DBT, schema therapy, TFP, supportive therapy, ERP, mindfulness, art therapy, virtual reality, and psychodrama."}}$en784$::jsonb,
  '{"he":{"web":"https://israclinic.org/","web2":"https://israclinic.org/treatment-at-israclinic","add":"https://psy.clinic/treatment-at-israclinic/services_and_prices_israclinic"},"en":{"web":"https://psy.clinic/","web2":"https://psy.clinic/treatment-at-israclinic/About-IsraClinic","add":"https://psy.clinic/treatment-at-israclinic/services_and_prices_israclinic"},"ru":{"web":"https://www.israclinic.com/"}}'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
SELECT c.row_id, c.entry_id, v.label, v.address, v.lat, v.lng, v.sort_order
FROM directory_card_edits c
JOIN (
  VALUES
    (784, 'תל אביב', 'ברודצקי 43, תל אביב, 6905234', 32.111776::float8, 34.797624::float8, 0)
) AS v(row_id, label, address, lat, lng, sort_order)
  ON v.row_id = c.row_id
WHERE c.card_key = '784|||מרפאה פסיכיאטרית פרטית: אבחון וטיפול תרופתי, וגם פסיכותרפיה. במרפאה או בזום.'
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-19-israclinic',
  DATE '2026-11-19',
  'נוסף IsraClinic',
  'מרפאה פסיכיאטרית פרטית בתל אביב, ברחוב ברודצקי 43, וגם אונליין. אבחון, טיפול ומעקב בעברית, ברוסית ובאנגלית, למבוגרים ומגיל 17 וחצי. הכרטיס במרפאות בריאות הנפש ובפסיכיאטריה.',
  'cards',
  ARRAY['784|||מרפאה פסיכיאטרית פרטית: אבחון וטיפול תרופתי, וגם פסיכותרפיה. במרפאה או בזום.'],
  '{}',
  '137_israclinic.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
