-- Migration 001
-- directory_entries: treatments subsections + title updates
-- Note: this file mirrors the previously used migration content.

BEGIN;

UPDATE directory_entries
SET category_keys = ARRAY['moh', 'hospitalization', 'alternatives', 'rehabilitation', 'treatments', 'treatments_psychiatry']::text[]
WHERE entry_id = 'המרכז_הירושלמי_לבריאות_הנפש_כפר_שאול_איתנים_78';

UPDATE directory_entries
SET category_keys = ARRAY['mod', 'therapists', 'treatments', 'treatments_psychiatry']::text[]
WHERE entry_id = 'שרן_רפואה_עד_הבית_42';

UPDATE directory_entries
SET category_keys = ARRAY['treatments', 'treatments_psychiatry', 'local']::text[]
WHERE entry_id = 'מיינדמי_mindme_104';

UPDATE directory_entries
SET category_keys = ARRAY['hmo', 'therapists', 'treatments', 'treatments_therapy']::text[]
WHERE entry_id = 'שרן_רפואה_עד_הבית_46';

UPDATE directory_entries
SET category_keys = ARRAY['rehabilitation', 'treatments', 'treatments_therapy']::text[]
WHERE entry_id = 'דיאלוג_פתוח_בישראל_דפ_י_69';

UPDATE directory_entries
SET category_keys = ARRAY['therapists', 'treatments', 'treatments_therapy']::text[]
WHERE entry_id = 'איט_ה_האגודה_הישראלית_לטיפול_קוגניטיבי_התנהגותי_cbt_50';

UPDATE directory_entries
SET category_keys = ARRAY['therapists', 'treatments', 'treatments_therapy', 'trauma']::text[]
WHERE entry_id = 'טיפול_סומטי_somatic_experiencing_51';

UPDATE directory_entries
SET category_keys = ARRAY['helplines', 'treatments', 'treatments_therapy', 'youth']::text[]
WHERE entry_id = 'הדספייס_63';

UPDATE directory_entries
SET category_keys = ARRAY['therapists', 'treatments', 'treatments_therapy', 'populations']::text[]
WHERE entry_id = 'מכון_למרחב_מרכז_טיפולי_רב_תחומי_65';

UPDATE directory_entries
SET category_keys = ARRAY['treatments', 'treatments_therapy', 'youth', 'populations']::text[]
WHERE entry_id = 'kav_l_noar_merchav_l_noar_102';

UPDATE directory_entries
SET category_keys = ARRAY['treatments', 'treatments_therapy']::text[]
WHERE entry_id = 'חיים_של_טובה_96';

UPDATE directory_entries
SET category_keys = ARRAY['treatments', 'treatments_others']::text[]
WHERE entry_id IN ('מהפנטים_36', 'המרכז_הישראלי_להתמכרויות_89');

UPDATE directory_entries
SET
  display_name = '(BrainsWay) TMS - גרייה מגנטית מוחית',
  description = 'טיפולי גרייה מוחית (TMS ו-Deep TMS) למגוון מצבים נפשיים ונוירולוגיים.',
  primary_category = 'treatments',
  category_keys = ARRAY['treatments', 'treatments_others']::text[]
WHERE entry_id = 'tms_deep_tms_105';

UPDATE directory_entries
SET
  display_name = 'Psychedelic Treatment & Therapy',
  description = 'מרכז גישה לטיפול ותרפיה פסיכדלית.',
  primary_category = 'treatments',
  category_keys = ARRAY['treatments', 'treatments_others']::text[]
WHERE entry_id = 'psychedelic_treatment_therapy_106';

UPDATE directory_entries
SET
  display_name = 'Psychedelic Therapy',
  description = 'טיפול פסיכדלי ומידע מקצועי בתחום.',
  primary_category = 'treatments',
  category_keys = ARRAY['treatments', 'treatments_others']::text[]
WHERE entry_id = 'psychedelic_therapy_107';

UPDATE directory_entries
SET
  display_name = '(איכילוב) TMS - גרייה מגנטית מוחית',
  description = 'טיפול בגרייה מגנטית מוחית (TMS) במסגרת מרפאה פסיכיאטרית.',
  primary_category = 'treatments',
  category_keys = ARRAY['treatments', 'treatments_others']::text[]
WHERE entry_id = 'tms_גרייה_מגנטית_מוחית_108';

UPDATE directory_entries
SET
  display_name = 'ECT (נזעי חשמל)',
  description = 'מידע על טיפול בנזעי חשמל (ECT) במסגרת פסיכיאטרית.',
  primary_category = 'treatments',
  category_keys = ARRAY['treatments', 'treatments_others']::text[]
WHERE entry_id = 'ect_נזעי_חשמל_109';

COMMIT;
