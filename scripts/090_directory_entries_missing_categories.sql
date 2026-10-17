-- Migration 090 (16 Oct 2026)
-- directory_entries: a category row for the three Sharan services that were never
-- inserted (rows 41, 43, 47) and for the medical-treatment cards (rows 105–109).
-- Older TMS and psychedelic ids are moved onto the id the card already stores.
-- חיים של טובה: the therapists card keeps חיים_של_טובה_96. The therapy card
-- becomes row 343 and the families card becomes row 344, each with its own entry.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- An older row keeps its history when the card's current id is still free.
UPDATE directory_entries SET entry_id = 'brainsway_tms_גרייה_מגנטית_מוחית_105'
WHERE entry_id = (
  SELECT entry_id FROM directory_entries
  WHERE entry_id IN ('tms_deep_tms_105', 'brainsway_105')
  ORDER BY entry_id
  LIMIT 1
)
  AND NOT EXISTS (SELECT 1 FROM directory_entries WHERE entry_id = 'brainsway_tms_גרייה_מגנטית_מוחית_105');

UPDATE directory_entries SET entry_id = 'psychedelic_treatment_therapy_106'
WHERE entry_id = 'acpt_israel_access_center_for_psychedelic_treatment_and_ther_106'
  AND NOT EXISTS (SELECT 1 FROM directory_entries WHERE entry_id = 'psychedelic_treatment_therapy_106');

UPDATE directory_entries SET entry_id = 'טיפול_פסיכדלי_107'
WHERE entry_id = (
  SELECT entry_id FROM directory_entries
  WHERE entry_id IN ('psychedelic_therapy_107', 'psycircle_107')
  ORDER BY entry_id
  LIMIT 1
)
  AND NOT EXISTS (SELECT 1 FROM directory_entries WHERE entry_id = 'טיפול_פסיכדלי_107');

UPDATE directory_entries SET entry_id = 'איכילוב_tms_גרייה_מגנטית_מוחית_108'
WHERE entry_id = (
  SELECT entry_id FROM directory_entries
  WHERE entry_id IN ('tms_גרייה_מגנטית_מוחית_108', 'איכילוב_תל_השומר_גרייה_מגנטית_מוחית_108')
  ORDER BY entry_id
  LIMIT 1
)
  AND NOT EXISTS (SELECT 1 FROM directory_entries WHERE entry_id = 'איכילוב_tms_גרייה_מגנטית_מוחית_108');

UPDATE directory_entry_locations SET entry_id = 'brainsway_tms_גרייה_מגנטית_מוחית_105'
WHERE entry_id IN ('tms_deep_tms_105', 'brainsway_105');
UPDATE directory_entry_locations SET entry_id = 'psychedelic_treatment_therapy_106'
WHERE entry_id = 'acpt_israel_access_center_for_psychedelic_treatment_and_ther_106';
UPDATE directory_entry_locations SET entry_id = 'טיפול_פסיכדלי_107'
WHERE entry_id IN ('psychedelic_therapy_107', 'psycircle_107');
UPDATE directory_entry_locations SET entry_id = 'איכילוב_tms_גרייה_מגנטית_מוחית_108'
WHERE entry_id IN ('tms_גרייה_מגנטית_מוחית_108', 'איכילוב_תל_השומר_גרייה_מגנטית_מוחית_108');

UPDATE directory_card_edits SET entry_id = 'brainsway_tms_גרייה_מגנטית_מוחית_105', updated_at = now()
WHERE row_id = 105 AND entry_id IS DISTINCT FROM 'brainsway_tms_גרייה_מגנטית_מוחית_105';
UPDATE directory_card_edits SET entry_id = 'psychedelic_treatment_therapy_106', updated_at = now()
WHERE row_id = 106 AND entry_id IS DISTINCT FROM 'psychedelic_treatment_therapy_106';
UPDATE directory_card_edits SET entry_id = 'טיפול_פסיכדלי_107', updated_at = now()
WHERE row_id = 107 AND entry_id IS DISTINCT FROM 'טיפול_פסיכדלי_107';
UPDATE directory_card_edits SET entry_id = 'איכילוב_tms_גרייה_מגנטית_מוחית_108', updated_at = now()
WHERE row_id = 108 AND entry_id IS DISTINCT FROM 'איכילוב_tms_גרייה_מגנטית_מוחית_108';
UPDATE directory_card_edits SET entry_id = 'ect_נזעי_חשמל_109', updated_at = now()
WHERE row_id = 109 AND entry_id IS DISTINCT FROM 'ect_נזעי_חשמל_109';
UPDATE directory_card_edits SET entry_id = 'שרן_רפואה_עד_הבית_41', updated_at = now()
WHERE card_key = '41|||ייעוץ פסיכיאטרי מקוון' AND entry_id IS DISTINCT FROM 'שרן_רפואה_עד_הבית_41';
UPDATE directory_card_edits SET entry_id = 'שרן_רפואה_עד_הבית_43', updated_at = now()
WHERE card_key = '43|||אשפוז בית פסיכיאטרי' AND entry_id IS DISTINCT FROM 'שרן_רפואה_עד_הבית_43';
UPDATE directory_card_edits SET entry_id = 'שרן_רפואה_עד_הבית_47', updated_at = now()
WHERE card_key = '47|||פסיכותרפיה מקוונת' AND entry_id IS DISTINCT FROM 'שרן_רפואה_עד_הבית_47';

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES
(
  'שרן_רפואה_עד_הבית_41',
  'שרן רפואה עד הבית',
  'ייעוץ פסיכיאטרי מקוון',
  'therapists',
  ARRAY['therapists', 'treatments', 'treatments_psychiatry']::text[],
  ARRAY['self_referral']::text[]
),
(
  'שרן_רפואה_עד_הבית_43',
  'שרן רפואה עד הבית',
  'אשפוז בית פסיכיאטרי',
  'alternatives',
  ARRAY['alternatives']::text[],
  ARRAY['self_referral']::text[]
),
(
  'שרן_רפואה_עד_הבית_47',
  'שרן רפואה עד הבית',
  'פסיכותרפיה מקוונת',
  'treatments',
  ARRAY['treatments', 'treatments_therapy']::text[],
  ARRAY['self_referral']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  primary_category = CASE
    WHEN directory_entries.primary_category IS NULL OR btrim(directory_entries.primary_category) = ''
    THEN EXCLUDED.primary_category ELSE directory_entries.primary_category END,
  category_keys = CASE
    WHEN directory_entries.category_keys IS NULL OR cardinality(directory_entries.category_keys) = 0
    THEN EXCLUDED.category_keys ELSE directory_entries.category_keys END,
  referral_codes = COALESCE(directory_entries.referral_codes, EXCLUDED.referral_codes);

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys
) VALUES
(
  'brainsway_tms_גרייה_מגנטית_מוחית_105',
  '(BrainsWay) TMS - גרייה מגנטית מוחית',
  'טיפולי גרייה מוחית (TMS ו-Deep TMS) למגוון מצבים נפשיים ונוירולוגיים. דיכאון מג''ורי בסל לפי תנאים; שיפוי אגף השיקום ל-PTSD בחלק מבתי החולים הציבוריים.',
  'treatments',
  ARRAY['treatments', 'treatments_medical']::text[]
),
(
  'psychedelic_treatment_therapy_106',
  'Psychedelic Treatment & Therapy',
  'Access center for psychedelic treatment and therapy.',
  'treatments',
  ARRAY['treatments', 'treatments_medical']::text[]
),
(
  'טיפול_פסיכדלי_107',
  'טיפול פסיכדלי',
  'טיפול פסיכדלי ומידע מקצועי בתחום.',
  'treatments',
  ARRAY['treatments', 'treatments_medical']::text[]
),
(
  'איכילוב_tms_גרייה_מגנטית_מוחית_108',
  '(איכילוב) TMS - גרייה מגנטית מוחית',
  'טיפול בגרייה מגנטית מוחית (TMS) במרפאה לטיפולים מתקדמים. באותה יחידה גם ECT, אסקטמין ונוירופידבק.',
  'treatments',
  ARRAY['treatments', 'treatments_medical']::text[]
),
(
  'ect_נזעי_חשמל_109',
  'ECT (נזעי חשמל)',
  'טיפול ביולוגי תחת הרדמה קצרה במצבים נפשיים חמורים — בעיקר דיכאון קשה, קטטוניה ומצבים דחופים. ניתן בסדרה בבתי חולים פסיכיאטריים ובחטיבות פסיכיאטריות (למשל איכילוב, שלוותה, כפר שאול).',
  'treatments',
  ARRAY['treatments', 'treatments_medical']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  primary_category = CASE
    WHEN directory_entries.primary_category IS NULL OR btrim(directory_entries.primary_category) = ''
    THEN EXCLUDED.primary_category ELSE directory_entries.primary_category END,
  category_keys = CASE
    WHEN directory_entries.category_keys IS NULL
      OR cardinality(directory_entries.category_keys) = 0
      OR directory_entries.category_keys <@ ARRAY['treatments', 'treatments_others']::text[]
    THEN EXCLUDED.category_keys ELSE directory_entries.category_keys END;

-- חיים של טובה. Row 96 stays the therapists card. The other two cards leave that entry.
INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES
(
  'חיים_של_טובה_96',
  'חיים של טובה',
  'הכוונה לטיפול הפסיכולוגי המתאים לכם וסבסוד טיפולים',
  'therapists',
  ARRAY['therapists']::text[],
  ARRAY['self_referral']::text[]
),
(
  'חיים_של_טובה_343',
  'חיים של טובה',
  'הכוונה לטיפול הפסיכולוגי המתאים וסבסוד טיפולים פסיכולוגיים',
  'treatments',
  ARRAY['treatments', 'treatments_therapy']::text[],
  ARRAY['self_referral']::text[]
),
(
  'חיים_של_טובה_344',
  'חיים של טובה',
  'הכוונה לטיפול הפסיכולוגי המתאים לכם, סבסוד טיפולים, חוסן משפחתי. שינוי מפת ההתמודדות המשפחתית והקהילתית במצבי מצוקה אישיים ומשפחתיים.',
  'families',
  ARRAY['families']::text[],
  ARRAY['self_referral']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = COALESCE(directory_entries.referral_codes, EXCLUDED.referral_codes);

UPDATE directory_card_edits
SET row_id = 343,
    card_key = '343|||הכוונה לטיפול הפסיכולוגי המתאים וסבסוד טיפולים פסיכולוגיים',
    entry_id = 'חיים_של_טובה_343',
    updated_at = now()
WHERE card_key = '96|||הכוונה לטיפול הפסיכולוגי המתאים וסבסוד טיפולים פסיכולוגיים';

UPDATE directory_card_edits
SET row_id = 344,
    card_key = '344|||הכוונה לטיפול הפסיכולוגי המתאים לכם, סבסוד טיפולים, חוסן משפחתי. שינוי מפת ההתמודדות המשפחתית והקהילתית במצבי מצוקה אישיים ומשפחתיים.',
    entry_id = 'חיים_של_טובה_344',
    updated_at = now()
WHERE card_key = '96|||הכוונה לטיפול הפסיכולוגי המתאים לכם, סבסוד טיפולים, חוסן משפחתי. שינוי מפת ההתמודדות המשפחתית והקהילתית במצבי מצוקה אישיים ומשפחתיים.';

COMMIT;
