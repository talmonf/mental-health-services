-- Migration 053 (12 Oct 2026)
-- directory_card_edits: עמותת גוונים (row 296).
-- Replace the service list with the five services named by the organization:
-- תעסוקה נתמכת, מועדון חברתי באשקלון, מכינת הד, דיור מוגן לבודדים / ליווי, סייעים בחינוך.
-- The message spelled ליווי as לויין; the card uses ליווי.
-- card_key follows the new svc so the catalog and the row still match.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_entries
SET description = 'תעסוקה נתמכת, מועדון חברתי באשקלון, מכינת הד, דיור מוגן לבודדים / ליווי, וסייעים בחינוך'
WHERE entry_id = 'עמותת_גוונים_296';

UPDATE directory_card_edits
SET
  card_key = '296|||תעסוקה נתמכת, מועדון חברתי באשקלון, מכינת הד, דיור מוגן לבודדים / ליווי, וסייעים בחינוך',
  public_fields = public_fields || jsonb_build_object(
    'svc', 'תעסוקה נתמכת, מועדון חברתי באשקלון, מכינת הד, דיור מוגן לבודדים / ליווי, וסייעים בחינוך',
    'target', 'מכינת הד: גילאי 18–28, זכאי סל שיקום. דיור מוגן לבודדים: מגבלה נפשית',
    'region', 'מכינת הד: לוד, יוקנעם, עפולה, שדרות, טירת כרמל. מועדון חברתי: אשקלון. דיור מוגן לבודדים: אשקלון, קריית מלאכי והסביבה',
    'notes', 'מוקד *9913. מכינת הד: גילאי 18–28, זכאי סל שיקום, במספר סניפים, שנה עד 5 שנים. מטה: הרקפת 6, שדרות.'
  ),
  eligibility = jsonb_set(
    eligibility,
    '{internal_notes}',
    to_jsonb(
      rtrim(COALESCE(eligibility->>'internal_notes', ''))
      || E'\n\nעדכון 12.10.2026 לפי הודעת המנהל בגוונים. השירותים בכרטיס הם רק: תעסוקה נתמכת; מועדון חברתי (באשקלון); מכינת הד (מספר סניפים); דיור מוגן לבודדים / לויין; סייעים בחינוך. לויין נרשם כליווי. הוסרו מהכרטיס מרכז התעסוקה, גוונים בקפה, והמשפט על תכניות למוגבלות פיזית, חושית, שכלית-התפתחותית ואוטיזם. פירוט הגיל, סל השיקום והסניפים של מכינת הד, ופירוט הדיור המוגן, נשארו כפי שנבדקו באתר באותו יום.'
    )
  ),
  public_edited_at = now(),
  updated_at = now()
WHERE row_id = 296
  AND card_key = '296|||דיור ותעסוקה לצעירים עם מגבלה נפשית — כולל זכאי סל שיקום';

COMMIT;
