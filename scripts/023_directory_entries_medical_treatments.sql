-- Migration 023 (Aug 2026)
-- directory_entries: medical treatments subsection + geocoded clinic sites.
-- Moves TMS/ECT/psychedelic from treatments_others to treatments_medical.
-- New rows 268–275. Stella (268) also listed under trauma.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- Moved existing cards: others → medical
UPDATE directory_entries
SET
  description = 'טיפולי גרייה מוחית (TMS ו-Deep TMS) למגוון מצבים נפשיים ונוירולוגיים. דיכאון מג''ורי בסל לפי תנאים; שיפוי אגף השיקום ל-PTSD בחלק מבתי החולים הציבוריים.',
  category_keys = ARRAY['treatments', 'treatments_medical']::text[]
WHERE entry_id = 'tms_deep_tms_105';

UPDATE directory_entries
SET
  description = 'טיפול בגרייה מגנטית מוחית (TMS) במרפאה לטיפולים מתקדמים. באותה יחידה גם ECT, אסקטמין ונוירופידבק.',
  category_keys = ARRAY['treatments', 'treatments_medical']::text[]
WHERE entry_id IN ('tms_גרייה_מגנטית_מוחית_108', 'איכילוב_tms_גרייה_מגנטית_מוחית_108');

UPDATE directory_entries
SET
  description = 'טיפול ביולוגי תחת הרדמה קצרה במצבים נפשיים חמורים — בעיקר דיכאון קשה, קטטוניה ומצבים דחופים. ניתן בסדרה בבתי חולים פסיכיאטריים ובחטיבות פסיכיאטריות (למשל איכילוב, שלוותה, כפר שאול).',
  category_keys = ARRAY['treatments', 'treatments_medical']::text[]
WHERE entry_id = 'ect_נזעי_חשמל_109';

UPDATE directory_entries
SET category_keys = ARRAY['treatments', 'treatments_medical']::text[]
WHERE entry_id IN ('psychedelic_treatment_therapy_106', 'psychedelic_therapy_107');

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
) VALUES
  (
    'sgb_סטלה_ישראל_268',
    'SGB — סטלה ישראל',
    'הליך רפואי קצר (Stellate Ganglion Block): שתי זריקות הרדמה מקומית בצידי הצוואר תחת אולטרסאונד, להקלה על תסמינים פיזיים של פוסט־טראומה, חרדה ודיכאון. מיועד לשילוב עם טיפול רגשי.',
    'treatments',
    ARRAY['treatments', 'treatments_medical', 'trauma']::text[]
  ),
  (
    'prism_גרייה_עצמית_לפוסט_טראומה_269',
    'Prism — גרייה עצמית לפוסט טראומה',
    'טיפול EEG לא פולשני (GrayMatters Health) לאימון ויסות פעילות מוחית הקשורה לפוסט־טראומה, ללא חשיפה לטראומה. מאושר FDA ו־אמ"ר; מוכר לאגף השיקום למטופלים זכאים. רשימת מרכזים באתר (שיבא, איכילוב, ברזילי, מעלה הכרמל, בתי הלוחם ועוד).',
    'treatments',
    ARRAY['treatments', 'treatments_medical']::text[]
  ),
  (
    'אסקטמין_spravato_ספראבטו_270',
    'אסקטמין / Spravato (ספראבטו)',
    'תרסיס אף של אסקטמין לדיכאון מג''ורי עמיד. בסל הבריאות (מ-2020) למבוגרים שלא הגיבו לשני קווי טיפול משתי קבוצות פרמקולוגיות, בשילוב SSRI/SNRI. ניתן רק במרפאה מורשית תחת השגחה.',
    'treatments',
    ARRAY['treatments', 'treatments_medical']::text[]
  ),
  (
    'קטמיינד_ketamind_עירוי_קטמין_271',
    'קטמיינד (KetaMind) — עירוי קטמין',
    'מרפאה פסיכיאטרית מקבוצת Stella Israel: עירוי קטמין במינון נמוך בהשגחה רפואית לדיכאון, חרדה ופוסט־טראומה.',
    'treatments',
    ARRAY['treatments', 'treatments_medical']::text[]
  ),
  (
    'keter_health_kap_272',
    'Keter Health — KAP',
    'Ketamine-assisted psychotherapy in Jerusalem: psychiatrist and KAP therapist (mainly IM ketamine with preparation and integration) for treatment-resistant depression, PTSD and anxiety.',
    'treatments',
    ARRAY['treatments', 'treatments_medical']::text[]
  ),
  (
    'tdcs_המרכז_הרפואי_הרצוג_273',
    'tDCS — המרכז הרפואי הרצוג',
    'גרייה מוחית בזרם ישר חלש (tDCS) במרפאה לגרייה מוחית בהרצוג. לא פולשני; למצבים פסיכיאטריים ונוירולוגיים לפי הערכה רפואית. באותה מרפאה גם Deep TMS לדיכאון מג''ורי (טופס 17).',
    'treatments',
    ARRAY['treatments', 'treatments_medical']::text[]
  ),
  (
    'vns_גירוי_העצב_התועה_274',
    'VNS — גירוי העצב התועה',
    'השתלת קוצב המגרה את עצב הואגוס לדיכאון קשה עמיד לטיפול. בישראל: הערכה ביחידה לגרייה מוחית בלב השרון; ההשתלה בנוירוכירורגיה תפקודית באיכילוב. מוגבל, דורש הפניה פסיכיאטרית.',
    'treatments',
    ARRAY['treatments', 'treatments_medical']::text[]
  ),
  (
    'dbs_גירוי_מוחי_עמוק_ocd_עמיד_275',
    'DBS — גירוי מוחי עמוק (OCD עמיד)',
    'הליך נוירוכירורגי להשתלת אלקטרודות וקוצב מוחי במקרי OCD חמורים ועמידים לטיפול. ניתן במספר מרכזים בודדים (למשל רמב"ם). אינו בסל הבריאות; רק באישור מיוחד של משרד הבריאות או במחקר.',
    'treatments',
    ARRAY['treatments', 'treatments_medical']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
VALUES
  (268, 'sgb_סטלה_ישראל_268', 'מדיקה רמת החייל', 'הברזל 28, רמת החייל, תל אביב', 32.106894, 34.833155, 0),
  (268, 'sgb_סטלה_ישראל_268', 'אלישע חיפה', 'יאיר כ"ץ 12, חיפה', 32.800885, 34.992364, 1),
  (270, 'אסקטמין_spravato_ספראבטו_270', 'איכילוב', 'בית החולים איכילוב, תל אביב', 32.080381, 34.790155, 0),
  (271, 'קטמיינד_ketamind_עירוי_קטמין_271', 'מדיקה רמת החייל', 'הברזל 28, רמת החייל, תל אביב', 32.106894, 34.833155, 0),
  (271, 'קטמיינד_ketamind_עירוי_קטמין_271', 'אלישע חיפה', 'יאיר כ"ץ 12, חיפה', 32.800885, 34.992364, 1),
  (272, 'keter_health_kap_272', 'ירושלים', 'Keter Health, ירושלים', 31.778847, 35.225786, 0),
  (273, 'tdcs_המרכז_הרפואי_הרצוג_273', 'הרצוג ירושלים', 'המרכז הרפואי הרצוג, גבעת שאול, ירושלים', 31.791119, 35.193102, 0),
  (274, 'vns_גירוי_העצב_התועה_274', 'לב השרון', 'מרכז רפואי לב השרון', 32.328618, 34.856625, 0),
  (274, 'vns_גירוי_העצב_התועה_274', 'איכילוב', 'בית החולים איכילוב, תל אביב', 32.080381, 34.790155, 1),
  (275, 'dbs_גירוי_מוחי_עמוק_ocd_עמיד_275', 'רמב"ם חיפה', 'העלייה השניה 8, בת גלים, חיפה', 32.833216, 34.985726, 0)
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

COMMIT;
