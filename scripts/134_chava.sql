-- Migration 134 (13 Nov 2026)
-- מרכז חוה (row 783): Sheba's reproductive psychiatry unit at Tel Hashomer.
-- One card, under מרפאות בריאות הנפש, אשפוז יום, אשפוז, and חלופות אשפוז.
-- Row 645 stays the unlisted Ministry of Health clinic listing and is not linked.
-- The Hebrew page is the source. The English page is real, so the card is listed
-- in English, and its English wording follows the Hebrew page.
-- The directions page names gates and turns, not a street, so there is no pin.
-- Audit wording approved with the plan on 13.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'מרכז_חוה_783',
  'מרכז חוה',
  'יחידה לפסיכיאטריה של הפריון',
  'mh_clinics',
  ARRAY['mh_clinics', 'day_care', 'hospitalization', 'alternatives']::text[],
  ARRAY['self_referral', 'hmo_form17', 'gp_referral', 'psychiatrist_referral']::text[]
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
  '783|||יחידה לפסיכיאטריה של הפריון',
  783,
  'מרכז_חוה_783',
  $card783${"org":"מרכז חוה","svc":"יחידה לפסיכיאטריה של הפריון","target":"נשים בהריון, ועד שנה אחרי לידה (פנייה עד ארבעה חודשים מהלידה). אחרי אובדן הריון משבוע 20: פנייה עד ארבעה חודשים, וטיפול עד שנה. גם ייעוץ חד-פעמי לפני הריון, וליווי פסיכיאטרי לנשים עם אנדומטריוזיס שמטופלות במרפאת האנדומטריוזיס בשיבא","region":"תל השומר","cost":"טופס 17, או תשלום פרטי לפי תעריפי משרד הבריאות","specialty":"פסיכיאטריה של הפריון","languages":"","diseases":"","notes":"פנייה בטופס באתר, ואחר כך שאלון ב-SMS. מילוי השאלון אינו מבטיח קבלה. פגישת הערכה, ואז התאמה של סוג הטיפול. אובדן הריון לפני שבוע 20 מופנה ל[מרכז בדרכך](https://www.sheba.co.il/gynecology/clinics/bedarkech-center) בשיבא. במרפאה: מעקב פסיכיאטרי, טיפול פסיכולוגי, התערבות זוגית, ליווי סוציאלי וטיפול קבוצתי. המרפאה בבניין הפסיכיאטריה. מזכירות א׳–ה׳ 07:00–16:00, מענה טלפוני 08:00–13:00. [יחידת טיפול יום אם-תינוק](https://www.sheba.co.il/pregnancy/clinics/mother-baby-intensive-therapy-unit): עד שנה אחרי הלידה, א׳, ג׳ וה׳ 10:00–15:00. בא׳ ובה׳ עם התינוק, בג׳ בלי. קומה 1−, מתחת למלון שי-לב, ליד חדר הכושר. [מחלקת אשפוז דיאדי אם-תינוק](https://www.sheba.co.il/pregnancy/departments/mother-baby-hospitalization-department): נשים בשליש השלישי, או עד ארבעה חודשים אחרי הלידה, עם פסיכוזה אחרי לידה, משבר נפשי או דיכאון חמור. האשפוז בלי להיפרד מהתינוק. ביתן 37, מול בית החולים השיקומי. מ-1.9.2023 מבוטחות כל הקופות, מכל הארץ, זכאיות לאשפוז פסיכיאטרי בשיבא. גם [אשפוז בית פסיכיאטרי מקוון](https://www.sheba.co.il/beyond/clinics/pregnancy-post-partum-home-psychiatric-hospitalization), [מפגש מקוון להכנה רגשית ללידה ולהורות](https://www.sheba.co.il/pregnancy/courses/online-meeting-emotional-preparation-birth-and-parenthood) (התאריך יפורסם), ו[מרפאת נגה](https://www.sheba.co.il/gynecology/clinics/menopause-psychiatry-noga-clinic) לנשים בגיל המעבר ולתסמונת קדם-וסתית. אין רחוב באתר, ולכן אין מפה.","tags":"","whatsapp":"","whatsappLabel":"","email":"mirp.hava@sheba.gov.il","emailLabel":"אימייל","emailShowAddress":false,"email2":"mirp.hava@sheba.health.gov.il","emailLabel2":"טיפול יום","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://www.sheba.co.il/pregnancy/clinics/chava-center-mental-health-for-women","webLabel":"","web2":"https://www.sheba.co.il/general/forms/contact-chava-center","webLabel2":"פנייה","add":"","addLabel":"","add2":"","addLabel2":"","add3":"","addLabel3":"","phone":"03-5303352","phoneLabel":"מזכירות","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}$card783$::jsonb,
  $elig783${"age_min":null,"age_max":null,"sex":"female","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"13.11.2026: נבדק מול https://www.sheba.co.il/pregnancy/clinics/chava-center-mental-health-for-women , https://www.sheba.co.il/en/pregnancy/clinics/chava-center-mental-health-for-women , https://www.sheba.co.il/pregnancy/clinics/chava-clinic , https://www.sheba.co.il/pregnancy/clinics/mother-baby-intensive-therapy-unit , https://www.sheba.co.il/pregnancy/departments/mother-baby-hospitalization-department , https://www.sheba.co.il/general/forms/contact-chava-center ו-https://www.sheba.co.il/general/directions-clinics/directions-psychiatry . העמוד באנגלית קיים, ולכן יש en ב-site_languages. נוסח הכרטיס באנגלית לפי העמוד בעברית. העמוד באנגלית עדיין כותב עד שישה חודשים אחרי לידה, ומציין 03-5305915 כמענה קולי של הפסיכולוגית האחראית. שני אלה לא על הכרטיס. מייל המרכז: mirp.hava@sheba.gov.il. דף טיפול היום מפרסם mirp.hava@sheba.health.gov.il, והוא כפתור טיפול יום. דף ההגעה לבניין הפסיכיאטריה מתאר שערים ופניות, בלי רחוב, ולכן אין סיכה. טיפול היום ומחלקת האשפוז מתוארים כקומה וביתן בקמפוס, לא כרחוב. כרטיס 645 הוא רשומת מאגר המרפאות, ולא קושר. דף BEYOND באנגלית (https://beyond-en.sheba.co.il/199276) מתאר החזר למכבי, ללאומית ולמאוחדת או תשלום פרטי, ועד שישה חודשים. זה לא הועתק לכרטיס, כי לא מופיע בעמוד העברי של המרכז."}$elig783$::jsonb,
  '[]'::jsonb,
  $ind783${"offers":["care"],"whole_org":true,"funding":[{"channel":"hmo","terms":""},{"channel":"private","terms":""}],"referral":["self_referral","hmo_form17","gp_referral","psychiatrist_referral"],"referral_source":"פנייה בטופס באתר, ואחר כך שאלון ב-SMS. אחרי זימון לפגישת היכרות: טופס 17. הפניה מרופא משפחה, מרופא נשים או מאיש מקצוע בקופה יכולה לסייע. למחלקת האשפוז גם מפסיכיאטר, מרופא ילדים או מאחות טיפת חלב","ownership":"hospital","app":""}$ind783$::jsonb,
  $en783${"en":{"org":"Chava Center","svc":"Reproductive psychiatry unit","phoneLabel":"Secretary","emailLabel":"Email","emailLabel2":"Day treatment","webLabel2":"Inquiry","target":"Women in pregnancy, and up to a year after birth (apply within four months of the birth). After a pregnancy loss from week 20: apply within four months, with treatment for up to a year. Also a one-time consultation before pregnancy, and psychiatric follow-up for women with endometriosis who are treated at Sheba's endometriosis clinic","region":"Tel Hashomer","cost":"Form 17, or private payment at Ministry of Health rates","specialty":"Reproductive psychiatry","notes":"Apply on the form on the website, then a questionnaire by SMS. Filling in the questionnaire does not guarantee a place. An assessment meeting follows, and the kind of care is matched then. A pregnancy loss before week 20 is referred to [the Bedarkech center at Sheba](https://www.sheba.co.il/gynecology/clinics/bedarkech-center). At the clinic: psychiatric follow-up, psychological treatment, couples work, social support, and group therapy. The clinic is in the psychiatry building. The office is open Sunday to Thursday, 07:00–16:00, and the phone is answered 08:00–13:00. [Mother-baby day unit](https://www.sheba.co.il/pregnancy/clinics/mother-baby-intensive-therapy-unit): up to a year after birth, on Sunday, Tuesday, and Thursday, 10:00–15:00. Sunday and Thursday with the baby, Tuesday without. Floor −1, under the Shi-Lev hotel, next to the gym. [Mother-baby inpatient unit](https://www.sheba.co.il/pregnancy/departments/mother-baby-hospitalization-department): women in the third trimester, or up to four months after birth, with postpartum psychosis, a mental-health crisis, or severe depression. Hospitalization does not separate the mother from the baby. Pavilion 37, opposite the rehabilitation hospital. Since 1 September 2023, members of all health funds, from anywhere in the country, are entitled to psychiatric hospitalization at Sheba. Also [online psychiatric home hospitalization](https://www.sheba.co.il/beyond/clinics/pregnancy-post-partum-home-psychiatric-hospitalization), an [online meeting to prepare for birth and parenthood](https://www.sheba.co.il/pregnancy/courses/online-meeting-emotional-preparation-birth-and-parenthood) (the date will be published), and the [Noga clinic](https://www.sheba.co.il/gynecology/clinics/menopause-psychiatry-noga-clinic) for women in menopause and with premenstrual syndrome. No street is published, so there is no map."}}$en783$::jsonb,
  '{"he":{"web":"https://www.sheba.co.il/pregnancy/clinics/chava-center-mental-health-for-women","web2":"https://www.sheba.co.il/general/forms/contact-chava-center"},"en":{"web":"https://www.sheba.co.il/en/pregnancy/clinics/chava-center-mental-health-for-women"}}'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-13-chava',
  DATE '2026-11-13',
  'נוסף מרכז חוה',
  'יחידה לפסיכיאטריה של הפריון בשיבא, תל השומר, לנשים בהריון, אחרי לידה ואחרי אובדן הריון. בכרטיס יש מרפאה, טיפול יום אם-תינוק, אשפוז בית מקוון ומחלקת אשפוז עם התינוק. הכרטיס מופיע במרפאות, בטיפול יום, באשפוז ובחלופות אשפוז. יש אתר בעברית ובאנגלית, טופס פנייה, מזכירות ואימייל. אין מפה, כי באתר פורסמו בניינים בקמפוס ולא רחוב.',
  'cards',
  ARRAY['783|||יחידה לפסיכיאטריה של הפריון'],
  '{}',
  '134_chava.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
