-- Migration 161 (28 Nov 2026)
-- Facebook-group card wording.
-- Wording approved on 28.11.2026. No audit entry.
-- Row 57, the rehabilitation-basket group, stays as it is.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

CREATE TEMP TABLE facebook_wording (
  row_id integer NOT NULL,
  unique_row boolean NOT NULL,
  old_key text NOT NULL,
  new_key text NOT NULL,
  fields jsonb NOT NULL,
  en jsonb NOT NULL,
  note text NOT NULL
);

INSERT INTO facebook_wording (row_id, unique_row, old_key, new_key, fields, en, note)
VALUES
  (54, true, '54|||קבוצה בפייסבוק', '54|||קבוצה בפייסבוק לפנייה אנונימית, ולקבלת עצות והמלצות ממטפלים מוסמכים.', '{"org":"טיפול נפשי, המלצות על מטפלים","svc":"קבוצה בפייסבוק לפנייה אנונימית, ולקבלת עצות והמלצות ממטפלים מוסמכים.","target":"מי שמחפש טיפול נפשי","region":"","cost":"","specialty":"","approaches":"","languages":"","diseases":"","notes":"הקבוצה נוסדה ומנוהלת על ידי איילת אלדן.","meeting":"","web":"https://www.facebook.com/groups/126155017096546/","phone":"","phoneLabel":"","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"phone4":"","phoneLabel4":"","phoneShowNumber4":false,"phone5":"","phoneLabel5":"","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":false}'::jsonb, '{"org":"Mental Care, Therapist Recommendations","svc":"A Facebook group for an anonymous request, and for advice and recommendations from licensed therapists.","target":"A person looking for mental-health care","notes":"The group was founded and is run by Ayelet Eldan.","phone":"","phoneLabel":"","phone2":"","phoneLabel2":"","phone3":"","phoneLabel3":"","phone4":"","phoneLabel4":"","phone5":"","phoneLabel5":"","phone6":"","phoneLabel6":""}'::jsonb, '28.11.2026: נבדק מול עמוד האודות. השם בקבוצה הוא טיפול נפשי, המלצות על מטפלים, איילת אלדן. הפנייה אנונימית, והתשובות ממטפלים מוסמכים. הניסוח אושר עם אצוות קבוצות הפייסבוק.'),
  (55, true, '55|||קבוצה בפייסבוק', '55|||קבוצה בפייסבוק לשיתוף יכולות וכלים שמביאים מזור: ריפוי, אמנות, מוזיקה, צליל וצבע.', '{"org":"מטפלים וטיפולים","svc":"קבוצה בפייסבוק לשיתוף יכולות וכלים שמביאים מזור: ריפוי, אמנות, מוזיקה, צליל וצבע.","target":"","region":"","cost":"","specialty":"","approaches":"","languages":"","diseases":"","notes":"","meeting":"","web":"https://www.facebook.com/groups/metaplim/","phone":"","phoneLabel":"","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"phone4":"","phoneLabel4":"","phoneShowNumber4":false,"phone5":"","phoneLabel5":"","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":false}'::jsonb, '{"org":"Therapists and Treatments","svc":"A Facebook group for sharing abilities and tools that bring relief: healing, art, music, sound, and color.","phone":"","phoneLabel":"","phone2":"","phoneLabel2":"","phone3":"","phoneLabel3":"","phone4":"","phoneLabel4":"","phone5":"","phoneLabel5":"","phone6":"","phoneLabel6":""}'::jsonb, '28.11.2026: נבדק מול עמוד האודות. התיאור שפורסם נקטע אחרי ספרו לעולם, והקטע הזה לא עלה. הניסוח אושר עם אצוות קבוצות הפייסבוק.'),
  (58, true, '58|||קבוצה בפייסבוק', '58|||קבוצה מקצועית בפייסבוק לשאלות ולדיון עם פסיכולוגים ואנשי טיפול. על התמודדות עם קושי נפשי.', '{"org":"ייעוץ פסיכולוגי - שאלות למטפלים פסיכולוגים","svc":"קבוצה מקצועית בפייסבוק לשאלות ולדיון עם פסיכולוגים ואנשי טיפול. על התמודדות עם קושי נפשי.","target":"","region":"","cost":"","specialty":"","approaches":"","languages":"","diseases":"","notes":"","meeting":"","web":"https://www.facebook.com/groups/emotional.support.forum/","phone":"","phoneLabel":"","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"phone4":"","phoneLabel4":"","phoneShowNumber4":false,"phone5":"","phoneLabel5":"","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":false}'::jsonb, '{"org":"Psychological Consultation, Questions for Psychologists","svc":"A professional Facebook group for questions and discussion with psychologists and care professionals. On coping with a mental difficulty.","phone":"","phoneLabel":"","phone2":"","phoneLabel2":"","phone3":"","phoneLabel3":"","phone4":"","phoneLabel4":"","phone5":"","phoneLabel5":"","phone6":"","phoneLabel6":""}'::jsonb, '28.11.2026: נבדק מול עמוד האודות. בתיאור המקורי כתוב קשים נפשיים, ועל הכרטיס זה קושי נפשי. הניסוח אושר עם אצוות קבוצות הפייסבוק.'),
  (86, true, '86|||קבוצה בפייסבוק', '86|||קבוצה בפייסבוק. ההמלצות והאזהרות מניסיון אישי.', '{"org":"המלצות ואזהרות על פסיכיאטרים, מטפלים ושירותי בריאות הנפש","svc":"קבוצה בפייסבוק. ההמלצות והאזהרות מניסיון אישי.","target":"","region":"","cost":"","specialty":"","approaches":"","languages":"","diseases":"","notes":"","meeting":"","web":"https://www.facebook.com/groups/1225241461655254/","phone":"","phoneLabel":"","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"phone4":"","phoneLabel4":"","phoneShowNumber4":false,"phone5":"","phoneLabel5":"","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":false}'::jsonb, '{"org":"Recommendations and Warnings about Psychiatrists, Therapists, and Mental-Health Services","svc":"A Facebook group. The recommendations and warnings are from personal experience.","phone":"","phoneLabel":"","phone2":"","phoneLabel2":"","phone3":"","phoneLabel3":"","phone4":"","phoneLabel4":"","phone5":"","phoneLabel5":"","phone6":"","phoneLabel6":""}'::jsonb, '28.11.2026: נבדק מול עמוד האודות. כל התיאור שפורסם הוא מניסיון אישי. הניסוח אושר עם אצוות קבוצות הפייסבוק.'),
  (277, true, '277|||קבוצה בפייסבוק', '277|||קבוצה בפייסבוק לשאלות, להתייעצות ולהמלצה על מטפל. על טיפול רגשי.', '{"org":"מתייעצים עם מטפלים מוסמכים","svc":"קבוצה בפייסבוק לשאלות, להתייעצות ולהמלצה על מטפל. על טיפול רגשי.","target":"","region":"","cost":"","specialty":"","approaches":"","languages":"","diseases":"","notes":"בקבוצה עובדים סוציאליים, פסיכולוגים ואנשי טיפול.","meeting":"","web":"https://www.facebook.com/groups/1734809967609705/","phone":"","phoneLabel":"","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":false,"phone3":"","phoneLabel3":"","phoneShowNumber3":false,"phone4":"","phoneLabel4":"","phoneShowNumber4":false,"phone5":"","phoneLabel5":"","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":false}'::jsonb, '{"org":"Consulting Licensed Therapists","svc":"A Facebook group for questions, consultation, and a recommendation of a therapist. On emotional care.","notes":"The group includes social workers, psychologists, and care professionals.","phone":"","phoneLabel":"","phone2":"","phoneLabel2":"","phone3":"","phoneLabel3":"","phone4":"","phoneLabel4":"","phone5":"","phoneLabel5":"","phone6":"","phoneLabel6":""}'::jsonb, '28.11.2026: נבדק מול עמוד האודות. מטפלים באומנויות והמילה ציבורית לא מופיעים בתיאור שפורסם, וירדו. הניסוח אושר עם אצוות קבוצות הפייסבוק.');

UPDATE site_audit_entries s
SET card_keys = (
  SELECT COALESCE(array_agg(
    COALESCE((SELECT w.new_key FROM facebook_wording w WHERE w.old_key = k), k)
    ORDER BY ord
  ), '{}')
  FROM unnest(s.card_keys) WITH ORDINALITY AS u(k, ord)
)
WHERE EXISTS (
  SELECT 1
  FROM unnest(s.card_keys) k
  JOIN facebook_wording w ON w.old_key = k
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
FROM facebook_wording w
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
JOIN facebook_wording w ON w.new_key = c.card_key
WHERE e.entry_id = c.entry_id;

COMMIT;
