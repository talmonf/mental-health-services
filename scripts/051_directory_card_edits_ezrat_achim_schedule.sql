-- Migration 051 (7 Oct 2026)
-- directory_card_edits: עזרת אחים (row 295).
-- Point visitors to the website for departure times (they change), and add the
-- *2348 line, from the organization's own page
-- (eza.org.il/our-activities/הסעות-לבתי-חולים).
-- Touches notes, the two phone lines, and the primary link. Other admin edits stay.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'notes',
      'לשעות היציאה מבית שמש לירושלים ובחזרה יש לבדוק באתר. לכל נסיעה מסלול שונה בהלוך ובחזור, והפרטים מתעדכנים במוקד. מוקד טלפוני 8:00–19:00 ב-1800-999-000 שלוחה 1. מערכת ממוחשבת *2348 עונה 24 שעות: מידע על המסלול והזמנת מקום. ההסעות במסלול הקבוע הן למטופלים ולמבקרים, במחיר מסובסד. נסיעות לחולים ולמוגבלי תנועה גם באזורים אחרים לפי זמינות, בתיאום של לפחות יום מראש. כולל אמבולנס שבת ליולדות. משרד: הנביא עמוס 1, בית שמש.',
      'phoneLabel', 'הסעות 8:00–19:00 (שלוחה 1)',
      'phone2', '*2348',
      'phoneLabel2', 'מערכת ממוחשבת (24 שעות)',
      'phoneShowNumber2', true,
      'web', 'https://eza.org.il/our-activities/%D7%94%D7%A1%D7%A2%D7%95%D7%AA-%D7%9C%D7%91%D7%AA%D7%99-%D7%97%D7%95%D7%9C%D7%99%D7%9D/',
      'webLabel', 'הסעות לבתי חולים'
    ),
    eligibility = jsonb_set(
      eligibility,
      '{internal_notes}',
      to_jsonb(
        rtrim(COALESCE(eligibility->>'internal_notes', ''))
        || E'\n\nעדכון 07.10.2026 מדף הארגון הסעות לבתי חולים (eza.org.il/our-activities/הסעות-לבתי-חולים): בדף מופיעות שעות יציאה, אך הן לא פורסמו בכרטיס כי הן משתנות. בכרטיס נכתב לבדוק את השעות באתר. לכל נסיעה מסלול שונה. מוקד 1800-999-000 שלוחה 1 בין 8:00–19:00. מערכת ממוחשבת *2348 עונה 24 שעות למידע על המסלול ולהזמנת מקום. הדף מציין מחיר מסובסד, מסלולים קבועים בכל יום, למטופלים ולמבקרים. שעות קרן יוסף גם הן לא פורסמו. הקישור הראשי בכרטיס הוחלף לדף לוח הנסיעות; דף הסעות חולים נשאר כקישור שני.'
      )
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '295|||הסעות מסובסדות לבתי חולים מבית שמש לירושלים, אמבולנסים ורכבים מונגשים'
  AND position('יש לבדוק באתר' IN COALESCE(public_fields->>'notes', '')) = 0;

COMMIT;
