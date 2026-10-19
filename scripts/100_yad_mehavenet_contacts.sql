-- Migration 100 (19 Oct 2026)
-- יד מכוונת notes keep only the extra-rights sentence. Appointment hours and
-- the Sakhnin landmark move onto the site, where the map shows them.
-- 099 is already the data-city portal, so this is 100.
-- The UPDATE applies only while the notes are still the paragraph from 098.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'notes', 'מרכזי ירושלים, פתח תקווה, אשדוד, באר שבע וחולון מטפלים גם במיצוי זכויות מול משרד הבריאות (סל שיקום), רשות המיסים (פטור ממס הכנסה), הרשות המקומית (הנחה בארנונה) ומשרד הבינוי והשיכון (סיוע בשכר דירה).'
    ),
    sites = (
      SELECT jsonb_agg(
        CASE elem->>'label'
          WHEN 'טבריה' THEN elem || jsonb_build_object('note', 'בתיאום מראש, יום ראשון 9:00–12:30')
          WHEN 'קריית שמונה' THEN elem || jsonb_build_object('note', 'בתיאום מראש, יום חמישי 9:00–12:30')
          WHEN 'כרמיאל' THEN elem || jsonb_build_object('note', 'בתיאום מראש, יום חמישי 9:00–13:00')
          WHEN 'סכנין' THEN elem || jsonb_build_object('note', 'יום שני 9:00–14:00. ליד בניין ההסתדרות')
          ELSE elem
        END
        ORDER BY ord
      )
      FROM jsonb_array_elements(sites) WITH ORDINALITY AS t(elem, ord)
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '4|||ייעוץ והכנה בחינם לוועדה הרפואית'
  AND COALESCE(public_fields->>'notes', '') = 'מרכזי ירושלים, פתח תקווה, אשדוד, באר שבע וחולון מטפלים גם במיצוי זכויות מול משרד הבריאות (סל שיקום), רשות המיסים (פטור ממס הכנסה), הרשות המקומית (הנחה בארנונה) ומשרד הבינוי והשיכון (סיוע בשכר דירה). טבריה: בתיאום מראש, יום ראשון 9:00–12:30. קריית שמונה: בתיאום מראש, יום חמישי 9:00–12:30. כרמיאל: בתיאום מראש, יום חמישי 9:00–13:00. סכנין: יום שני 9:00–14:00, ליד בניין ההסתדרות. דוא״ל: אשדוד MerkazyAS@femi.com · באר שבע ymbsheva@amalgroup.co.il · חולון MerkazyHO@femi.com · חיפה Yadhaifa@mediton.co.il · ירושלים merkazye@femi.com · נצרת ynazareth@femi.com · חדרה yadmhadera@ors-siud.co.il · טבריה, צפת, קריית שמונה וכרמיאל yadzefat@mediton.co.il · פתח תקווה merkazym@femi.com · סכנין m.7okok.sakhnin@gmail.com.'
  AND jsonb_array_length(sites) = 13;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-19-yad-mehavenet-notes',
    DATE '2026-10-19',
    'הערות יד מכוונת',
    'בהערות של יד מכוונת נשאר המשפט על חמשת המרכזים שמטפלים גם בסל שיקום, פטור ממס, ארנונה וסיוע בשכר דירה. שעות המרכזים שנפתחים בתיאום, ו«ליד בניין ההסתדרות» בסכנין, מופיעות ליד הכתובת במפה. המיילים ירדו מההערות.',
    'cards',
    ARRAY['4|||ייעוץ והכנה בחינם לוועדה הרפואית'],
    '{}',
    '100_yad_mehavenet_contacts.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-19-branch-region-contacts',
    DATE '2026-10-19',
    'סניפים בלי אזור כפול',
    'כשהאזור הוא בדיוק רשימת הסניפים, שורת האזור לא מוצגת. לסניפים עם מיילים שונים יש כפתור דוא״ל אחד, ולסניפים עם טלפונים שונים יש כפתור טלפון אחד. מספר של השירות כולו נשאר כפתור נפרד.',
    'ui',
    ARRAY[
      '4|||ייעוץ והכנה בחינם לוועדה הרפואית',
      '203|||רשת ארצית לטיפול פסיכולוגי, אבחון והכשרה — כולל טיפול בטראומה ובמצוקה נפשית.',
      '287|||קורת גג 24/7 לצעירים 18–25 ללא עורף משפחתי — עד 6 חודשים',
      '330|||טיפול יום באבן יהודה וביבנה'
    ],
    '{}',
    '100_yad_mehavenet_contacts.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
