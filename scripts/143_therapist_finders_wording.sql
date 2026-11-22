-- Migration 143 (22 Nov 2026)
-- Therapist-finder wording. Row 51 stays unchanged: the directory did not load.
-- Rows 30 and 81 are shared with other organizations. Those cards are matched
-- by the old card_key, and unique_row is false, so the other organization is left as it is.
-- Wording approved on 22.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

CREATE TEMP TABLE therapist_wording (
  row_id integer NOT NULL,
  unique_row boolean NOT NULL,
  old_key text NOT NULL,
  new_key text NOT NULL,
  fields jsonb NOT NULL,
  en jsonb NOT NULL,
  note text NOT NULL
) ON COMMIT DROP;

INSERT INTO therapist_wording (row_id, unique_row, old_key, new_key, fields, en, note) VALUES
  (30, false, '30|||אינדקס מטפלים (כולל פסיכיאטרים)', '30|||אינדקס מטפלים מוסמכים: פסיכולוגים, פסיכותרפיסטים, עובדים סוציאליים קליניים ופסיכיאטרים.', '{"org":"על הספה","svc":"אינדקס מטפלים מוסמכים: פסיכולוגים, פסיכותרפיסטים, עובדים סוציאליים קליניים ופסיכיאטרים.","target":"","region":"כל הארץ","founded":"2008","meeting":"","cost":"","specialty":"","approaches":"","notes":"אפשר לסנן גם לפי מפגש פרונטלי או אונליין. המטפלים עוברים בדיקת תעודות.","phone":"","phoneLabel":"","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"whatsapp":"","whatsappLabel":""}'::jsonb, '{"org":"Al Hasapa","svc":"An index of licensed therapists: psychologists, psychotherapists, clinical social workers, and psychiatrists.","region":"Nationwide","founded":"2008","notes":"The list can also be filtered by an in-person or online meeting. Certificates are checked."}'::jsonb, '22.11.2026: נבדק מול https://www.alhasapa.co.il/. הניסוח אושר עם אצוות איתור המטפלים.'),
  (31, true, '31|||אינדקס מטפלים (כולל פסיכיאטרים)', '31|||אינדקס מטפלים ממקצועות בריאות הנפש, עם רישיון או חברות באיגוד.', '{"org":"פסיכולוגיה עברית","svc":"אינדקס מטפלים ממקצועות בריאות הנפש, עם רישיון או חברות באיגוד.","target":"","region":"","founded":"2002","meeting":"","cost":"","specialty":"","approaches":"","notes":"עמותה. אפשר גם לשלוח פנייה אנונימית לטיפול.","phone":"","phoneLabel":"","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"email":"mail@hebpsy.net","emailLabel":"אימייל","emailShowAddress":false,"email2":"hebpsy.support@gmail.com","emailLabel2":"תמיכה","emailShowAddress2":false,"whatsapp":"","whatsappLabel":""}'::jsonb, '{"org":"Hebrew Psychology","svc":"An index of mental-health professionals with a license or membership in an association.","founded":"2002","notes":"A nonprofit. An anonymous inquiry about treatment can also be sent.","emailLabel":"Email","emailLabel2":"Support"}'::jsonb, '22.11.2026: נבדק מול https://www.hebpsy.net/. הניסוח אושר עם אצוות איתור המטפלים.'),
  (32, true, '32|||אינדקס מטפלים (כולל פסיכיאטרים)', '32|||אינדקס מטפלים שנבדקו מול תעודות, רישיונות והכשרות.', '{"org":"בטיפולנט","svc":"אינדקס מטפלים שנבדקו מול תעודות, רישיונות והכשרות.","target":"","region":"","founded":"2009","meeting":"","cost":"","specialty":"","approaches":"","notes":"באתר גם כתבות, מאמרים ומידע על קווי חירום ומסגרות.","phone":"04-6764071","phoneLabel":"שירות לקוחות","phoneShowNumber":false,"phone2":"052-6876125","phoneLabel2":"שירות לקוחות","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"whatsapp":"","whatsappLabel":""}'::jsonb, '{"org":"Betipulnet","svc":"An index of therapists checked against certificates, licenses, and training.","founded":"2009","notes":"The site also has articles and information on emergency lines and services.","phoneLabel":"Customer service","phoneLabel2":"Customer service"}'::jsonb, '22.11.2026: נבדק מול https://www.betipulnet.co.il/. הניסוח אושר עם אצוות איתור המטפלים.'),
  (33, true, '33|||אינדקס פסיכיאטרים', '33|||אינדקס פסיכיאטרים עם חוות דעת של מטופלים.', '{"org":"MedReviews","svc":"אינדקס פסיכיאטרים עם חוות דעת של מטופלים.","target":"","region":"","founded":"","meeting":"","cost":"","specialty":"","approaches":"","notes":"הפרופיל נכתב על ידי הרופא. אפשר לסנן גם לפי ייעוץ אונליין.","phone":"","phoneLabel":"","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"email":"info@medreviews.co.il","emailLabel":"אימייל","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"whatsapp":"","whatsappLabel":""}'::jsonb, '{"org":"MedReviews","svc":"An index of psychiatrists with patient reviews.","notes":"The doctor writes the profile. The list can also be filtered by an online consultation.","emailLabel":"Email"}'::jsonb, '22.11.2026: נבדק מול https://www.medreviews.co.il/. הניסוח אושר עם אצוות איתור המטפלים.'),
  (34, true, '34|||אינדקס פסיכיאטרים', '34|||אינדקס פסיכיאטרים פרטיים.', '{"org":"אינפומד","svc":"אינדקס פסיכיאטרים פרטיים.","target":"","region":"","founded":"","meeting":"","cost":"","specialty":"","approaches":"","notes":"","phone":"","phoneLabel":"","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"whatsapp":"","whatsappLabel":""}'::jsonb, '{"org":"Infomed","svc":"An index of private psychiatrists."}'::jsonb, '22.11.2026: נבדק מול https://www.infomed.co.il/. הניסוח אושר עם אצוות איתור המטפלים.'),
  (37, true, '37|||אינדקס מטפלים', '37|||אינדקס מטפלים קליניים עם תואר שני טיפולי: פסיכולוגים, עובדים סוציאליים, מטפלים באמצעות אמנויות וקרימינולוגים קליניים.', '{"org":"רקליני","svc":"אינדקס מטפלים קליניים עם תואר שני טיפולי: פסיכולוגים, עובדים סוציאליים, מטפלים באמצעות אמנויות וקרימינולוגים קליניים.","target":"","region":"","founded":"","meeting":"","cost":"","specialty":"","approaches":"","notes":"","phone":"","phoneLabel":"","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"whatsapp":"","whatsappLabel":""}'::jsonb, '{"org":"Raclini","svc":"An index of clinical therapists with a therapeutic master''s degree: psychologists, social workers, arts therapists, and clinical criminologists."}'::jsonb, '22.11.2026: נבדק מול https://www.raclini.co.il/. הניסוח אושר עם אצוות איתור המטפלים.'),
  (41, true, '41|||ייעוץ פסיכיאטרי מקוון', '41|||ייעוץ פסיכיאטרי פרטי: אבחון וטיפול תרופתי. בזום.', '{"org":"שרן רפואה עד הבית","svc":"ייעוץ פסיכיאטרי פרטי: אבחון וטיפול תרופתי. בזום.","target":"מבוגרים","region":"","founded":"","meeting":"online","cost":"פרטי. אפשר לבדוק החזר מביטוח פרטי.","specialty":"חרדה, הפרעת הסתגלות, דיכאון, פוסט־טראומה, אוטיזם, הנמכה קוגניטיבית, חשד לדמנציה","approaches":"","notes":"פגישה תוך 48 שעות. חוות דעת נשלחת למייל כשיש צורך. חוות דעת גם לבית או אונליין, לביטוח לאומי, לסל שיקום, לאפוטרופסות, לצה״ל ולמוסד אקדמי. לא כולל משפט פלילי, ולא קנאביס רפואי לפוסט־טראומה. מרשם בדואר אקספרס.","phone":"1-700-508-586","phoneLabel":"מוקד","phoneShowNumber":false,"phone2":"03-7545928","phoneLabel2":"הזמנה","phoneShowNumber2":false,"phone3":"03-7545938","phoneLabel3":"תמיכה","phoneShowNumber3":false,"email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"whatsapp":"","whatsappLabel":""}'::jsonb, '{"org":"Sharan Medicine to Your Home","svc":"Private psychiatric consultation: assessment and medication. On Zoom.","target":"Adults","cost":"Private. Reimbursement from private insurance can be checked.","specialty":"Anxiety, adjustment disorder, depression, post-trauma, autism, cognitive decline, suspected dementia","notes":"A meeting within 48 hours. An opinion is sent by email when one is needed. Opinions are also given at home or online, for the National Insurance Institute, the rehabilitation basket, guardianship, the IDF, and an academic institution. Not for a criminal court, and not medical cannabis for post-trauma. A prescription is sent by express mail.","phoneLabel":"Information line","phoneLabel2":"Booking","phoneLabel3":"Support"}'::jsonb, '22.11.2026: נבדק מול https://sharanmedical.co.il/psychiatric-consultation-at-home/. הניסוח אושר עם אצוות איתור המטפלים.'),
  (46, true, '46|||פסיכותרפיה מקוונת', '46|||פסיכותרפיה על ידי עובדים סוציאליים קליניים. בזום.', '{"org":"שרן רפואה עד הבית","svc":"פסיכותרפיה על ידי עובדים סוציאליים קליניים. בזום.","target":"מבוגרים","region":"כל הארץ","founded":"","meeting":"online","cost":"ללא תשלום למבוטחי כללית ומאוחדת, אחרי הפניה ואישור הקופה. גם פרטי.","specialty":"","approaches":"","notes":"הפניה מרופא משפחה או מפסיכיאטר מטפל. בגוף הדף: עד 30 מפגשים. בשאלות הנפוצות: עד 15 למבוטחי הקופה, עם אפשרות להמשך באישור. בפרטי אין תקרה.","phone":"03-7545938","phoneLabel":"שאלות","phoneShowNumber":false,"phone2":"1-700-508-586","phoneLabel2":"מוקד","phoneShowNumber2":false,"phone3":"03-7545928","phoneLabel3":"מוקד","phoneShowNumber3":false,"email":"nefesh@med-trix.com","emailLabel":"אימייל","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"whatsapp":"","whatsappLabel":""}'::jsonb, '{"org":"Sharan Medicine to Your Home","svc":"Psychotherapy by clinical social workers. On Zoom.","target":"Adults","region":"Nationwide","cost":"Free for Clalit and Meuhedet members, after a referral and approval by the fund. Also private.","notes":"Referral from a family doctor or the treating psychiatrist. The page says up to 30 sessions. The FAQ says up to 15 for fund members, with continuation if approved. Private care has no cap.","phoneLabel":"Questions","phoneLabel2":"Information line","phoneLabel3":"Information line","emailLabel":"Email"}'::jsonb, '22.11.2026: נבדק מול https://sharanmedical.co.il/online-therapy/. הניסוח אושר עם אצוות איתור המטפלים.'),
  (49, true, '49|||התאגדות המטפלים הדתיים', '49|||אינדקס מטפלים לציבור הדתי והאמוני: פסיכולוגים, עובדים סוציאליים, מטפלים באומנויות, ומטפלים זוגיים ומשפחתיים.', '{"org":"טל הנפש","svc":"אינדקס מטפלים לציבור הדתי והאמוני: פסיכולוגים, עובדים סוציאליים, מטפלים באומנויות, ומטפלים זוגיים ומשפחתיים.","target":"הציבור הדתי והאמוני","region":"כל הארץ","founded":"","meeting":"","cost":"","specialty":"","approaches":"","notes":"כל מטפל עובר ראיון ובדיקת תעודות. התנאי למאגר הוא יראת שמיים, מקצועיות וניסיון, ומחיר הוגן. באתר גם מאגר סדנאות.","phone":"","phoneLabel":"","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"whatsapp":"972559952701","whatsappLabel":"וואטסאפ"}'::jsonb, '{"org":"Tal HaNefesh","svc":"An index of therapists for the religious and faith community: psychologists, social workers, arts therapists, and couple and family therapists.","target":"The religious and faith community","region":"Nationwide","notes":"Each therapist is interviewed and their certificates are checked. Listing requires religious commitment, professional training and experience, and a fair fee. The site also has a workshop list.","whatsappLabel":"WhatsApp"}'::jsonb, '22.11.2026: נבדק מול https://www.indextal.co.il/about. הניסוח אושר עם אצוות איתור המטפלים.'),
  (50, true, '50|||אינדקס מטפלים', '50|||אינדקס מטפלי CBT ומדריכי CBT.', '{"org":"איט״ה — האגודה הישראלית לטיפול קוגניטיבי התנהגותי","svc":"אינדקס מטפלי CBT ומדריכי CBT.","target":"","region":"כל הארץ","founded":"1980","meeting":"","cost":"","specialty":"","approaches":"CBT","notes":"עמותה, חברה ב־EABCT. חבר מומחה הוא בעל תואר שני ורישיון במקצוע טיפולי, אחרי הכשרת CBT מוכרת.","phone":"052-3257005","phoneLabel":"טלפון","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"email":"itacbtisrael@gmail.com","emailLabel":"אימייל","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"whatsapp":"","whatsappLabel":""}'::jsonb, '{"org":"ITA — the Israeli Association for Cognitive Behavioral Therapy","svc":"An index of CBT therapists and CBT supervisors.","region":"Nationwide","founded":"1980","approaches":"CBT","notes":"A nonprofit, and a member of the EABCT. An expert member has a second degree and a treatment license, after recognized CBT training.","phoneLabel":"Phone","emailLabel":"Email"}'::jsonb, '22.11.2026: נבדק מול https://itacbt.co.il/therapists-index/. הניסוח אושר עם אצוות איתור המטפלים.'),
  (81, false, '81|||Help finding qualified mental health providers for English-speakers', '81|||הכוונה למטפלים בתחום בריאות הנפש, לקהילה היהודית.', '{"org":"Relief Resources","svc":"הכוונה למטפלים בתחום בריאות הנפש, לקהילה היהודית.","target":"הקהילה היהודית","region":"ירושלים","founded":"","meeting":"","cost":"","specialty":"","approaches":"","languages":"","notes":"עמותה. המשרד בישראל מפנה למטפלים שנבדקו. למי שגר מחוץ למשרד יש גם סיוע מרחוק.","phone":"077-360-9070","phoneLabel":"טלפון","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"email":"israel@reliefhelp.org","emailLabel":"אימייל","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"whatsapp":"","whatsappLabel":""}'::jsonb, '{"org":"Relief Resources","svc":"Referral to mental-health therapists, for the Jewish community.","target":"The Jewish community","region":"Jerusalem","notes":"A nonprofit. The Israel office refers to therapists who have been checked. People who do not live near the office can also get help remotely.","phoneLabel":"Phone","emailLabel":"Email"}'::jsonb, '22.11.2026: נבדק מול https://www.reliefhelp.org/. הניסוח אושר עם אצוות איתור המטפלים.'),
  (88, true, '88|||מרכז לפסיכותרפיה אינטגרטיבית. תמיכה נפשית, רגשית ורוחנית דרך מגוון רחב של גישות ועל ידי אנשי מקצוע מוסמכים', '88|||מרכז קליני: פסיכותרפיה אינטגרטיבית, וגם ליווי פסיכיאטרי.', '{"org":"אימפולס","svc":"מרכז קליני: פסיכותרפיה אינטגרטיבית, וגם ליווי פסיכיאטרי.","target":"","region":"כל הארץ","founded":"2019","meeting":"","cost":"","specialty":"דיכאון, חרדה, הפרעות אכילה, OCD, אבל ואובדן","approaches":"דינמי, גופני, מיינדפולנס, CBT, יונגיאני, האקומי, התמקדות","notes":"אינטייק, ואז התאמת מטפל. אינטגרציה של התנסויות פסיכדליות קודמות. המרכז לא נותן טיפול בחומרים.","phone":"055-3191140","phoneLabel":"טלפון","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"email":"impulse.psych@gmail.com","emailLabel":"אימייל","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"whatsapp":"","whatsappLabel":""}'::jsonb, '{"org":"Impulse","svc":"A clinical center: integrative psychotherapy, and also psychiatric follow-up.","region":"Nationwide","founded":"2019","specialty":"Depression, anxiety, eating disorders, OCD, grief and loss","approaches":"Dynamic, body-oriented, mindfulness, CBT, Jungian, Hakomi, focusing","notes":"An intake, then a match with a therapist. Integration of earlier psychedelic experiences. The center does not provide substances.","phoneLabel":"Phone","emailLabel":"Email"}'::jsonb, '22.11.2026: נבדק מול https://impulseclinics.com/. הניסוח אושר עם אצוות איתור המטפלים.'),
  (96, true, '96|||הכוונה לטיפול הפסיכולוגי המתאים לכם וסבסוד טיפולים', '96|||הכוונה לטיפול פסיכולוגי, וסבסוד טיפול פרטני, זוגי ומשפחתי.', '{"org":"חיים של טובה","svc":"הכוונה לטיפול פסיכולוגי, וסבסוד טיפול פרטני, זוגי ומשפחתי.","target":"משפחות","region":"","founded":"2012","meeting":"","cost":"סבסוד למי שאין ביכולתו לממן, מקרן של תרומות.","specialty":"","approaches":"","notes":"עמותה. גם הרצאות לקהילה.","phone":"","phoneLabel":"","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"email":"hst.org.il@gmail.com","emailLabel":"אימייל","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"whatsapp":"972585720770","whatsappLabel":"וואטסאפ"}'::jsonb, '{"org":"Chaim Shel Tova","svc":"Referral to psychological treatment, and a subsidy for individual, couples, and family therapy.","target":"Families","founded":"2012","cost":"A subsidy for someone who cannot pay, from a donation fund.","notes":"A nonprofit. Also lectures for the community.","emailLabel":"Email","whatsappLabel":"WhatsApp"}'::jsonb, '22.11.2026: נבדק מול https://hst.org.il/. הניסוח אושר עם אצוות איתור המטפלים.'),
  (205, true, '205|||יישומים פסיכולוגיים ממוקדים — הערכה ראשונית והתאמת טיפול (פגישות בקליניקה או זום).', '205|||מרכז ליישומים פסיכולוגיים: ייעוץ פסיכיאטרי וגם טיפול פסיכולוגי. במרפאה, ולעיתים גם אונליין.', '{"org":"רזולוציה","svc":"מרכז ליישומים פסיכולוגיים: ייעוץ פסיכיאטרי וגם טיפול פסיכולוגי. במרפאה, ולעיתים גם אונליין.","target":"","region":"תל אביב","founded":"","meeting":"both","cost":"","specialty":"חרדה, דיכאון, הפרעת קשב, OCD, טראומה","approaches":"דינמי, CBT, DBT","notes":"שיחת היכרות עם אחד או שניים מהצוות, ואז תוכנית ממוקדת לזמן שנקבע מראש. הברזל 11, תל אביב.","phone":"03-6919961","phoneLabel":"טלפון","phoneShowNumber":false,"phone2":"052-2507867","phoneLabel2":"טלפון","phoneShowNumber2":false,"phone3":"052-4337006","phoneLabel3":"טלפון","phoneShowNumber3":false,"email":"info@resolution.co.il","emailLabel":"אימייל","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"whatsapp":"","whatsappLabel":""}'::jsonb, '{"org":"Resolution","svc":"A center for psychological applications: psychiatric consultation and also psychological treatment. At the clinic, and sometimes also online.","region":"Tel Aviv","specialty":"Anxiety, depression, ADHD, OCD, trauma","approaches":"Dynamic therapy, CBT, DBT","notes":"An introductory conversation with one or two of the staff, then a time-limited plan. 11 HaBarzel St, Tel Aviv.","phoneLabel":"Phone","phoneLabel2":"Phone","phoneLabel3":"Phone","emailLabel":"Email"}'::jsonb, '22.11.2026: נבדק מול https://www.resolution.co.il/. הניסוח אושר עם אצוות איתור המטפלים.');

-- glossary_card_links.card_key and the organization-member keys follow
-- directory_card_edits.card_key through ON UPDATE CASCADE.
-- site_audit_entries.card_keys is a plain array, so it is rewritten first.
-- The rewrite matches the old card_key, not the row number.

UPDATE site_audit_entries s
SET card_keys = (
  SELECT COALESCE(array_agg(
    COALESCE((SELECT w.new_key FROM therapist_wording w WHERE w.old_key = k), k)
    ORDER BY ord
  ), '{}')
  FROM unnest(s.card_keys) WITH ORDINALITY AS u(k, ord)
)
WHERE EXISTS (
  SELECT 1
  FROM unnest(s.card_keys) k
  JOIN therapist_wording w ON w.old_key = k
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
FROM therapist_wording w
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
JOIN therapist_wording w ON w.new_key = c.card_key
WHERE e.entry_id = c.entry_id;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-22-therapist-finders-wording',
  DATE '2026-11-22',
  'עודכן הניסוח באיתור מטפלים',
  'בכרטיסי איתור המטפלים נכתב עכשיו מה השירות, ואיך נפגשים כשיש מפגש.',
  'cards',
  ARRAY[
  '30|||אינדקס מטפלים מוסמכים: פסיכולוגים, פסיכותרפיסטים, עובדים סוציאליים קליניים ופסיכיאטרים.',
  '31|||אינדקס מטפלים ממקצועות בריאות הנפש, עם רישיון או חברות באיגוד.',
  '32|||אינדקס מטפלים שנבדקו מול תעודות, רישיונות והכשרות.',
  '33|||אינדקס פסיכיאטרים עם חוות דעת של מטופלים.',
  '34|||אינדקס פסיכיאטרים פרטיים.',
  '37|||אינדקס מטפלים קליניים עם תואר שני טיפולי: פסיכולוגים, עובדים סוציאליים, מטפלים באמצעות אמנויות וקרימינולוגים קליניים.',
  '41|||ייעוץ פסיכיאטרי פרטי: אבחון וטיפול תרופתי. בזום.',
  '46|||פסיכותרפיה על ידי עובדים סוציאליים קליניים. בזום.',
  '49|||אינדקס מטפלים לציבור הדתי והאמוני: פסיכולוגים, עובדים סוציאליים, מטפלים באומנויות, ומטפלים זוגיים ומשפחתיים.',
  '50|||אינדקס מטפלי CBT ומדריכי CBT.',
  '81|||הכוונה למטפלים בתחום בריאות הנפש, לקהילה היהודית.',
  '88|||מרכז קליני: פסיכותרפיה אינטגרטיבית, וגם ליווי פסיכיאטרי.',
  '96|||הכוונה לטיפול פסיכולוגי, וסבסוד טיפול פרטני, זוגי ומשפחתי.',
  '205|||מרכז ליישומים פסיכולוגיים: ייעוץ פסיכיאטרי וגם טיפול פסיכולוגי. במרפאה, ולעיתים גם אונליין.'
  ],
  '{}',
  '143_therapist_finders_wording.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
