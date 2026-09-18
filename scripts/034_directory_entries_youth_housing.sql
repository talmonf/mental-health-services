-- Migration 034 (18 Sep 2026)
-- directory_entries: youth-at-risk housing (rows 284–287).
-- 284 החוט המשולש (youth + local + populations)
-- 285 בית השנטי (youth + local)
-- 286 עמותת יחדיו — קורת גג בראשית (youth + local)
-- 287 אנוש — הלנת חירום (youth + local); distinct from row 6 סל שיקום
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
) VALUES
  (
    'החוט_המשולש_284',
    'החוט המשולש',
    'בית חם, מרחב פתוח והלנת חירום לנוער וצעירים בסיכון — כולל שלטר לצעירות חרדיות',
    'youth',
    ARRAY['youth', 'local', 'populations']::text[]
  ),
  (
    'בית_השנטי_285',
    'בית השנטי',
    'בית חם ומקלט חירום לנוער בסיכון ובסכנת חיים (14–21)',
    'youth',
    ARRAY['youth', 'local']::text[]
  ),
  (
    'עמותת_יחדיו_קורת_גג_בראשית_286',
    'עמותת יחדיו — קורת גג בראשית',
    'קורת גג 24/7 לנוער 12–18 ללא קבלה בירוקרטית — עד 3 חודשים',
    'youth',
    ARRAY['youth', 'local']::text[]
  ),
  (
    'אנוש_הלנת_חירום_287',
    'אנוש — הלנת חירום',
    'קורת גג 24/7 לצעירים 18–25 ללא עורף משפחתי — עד 6 חודשים',
    'youth',
    ARRAY['youth', 'local']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
VALUES
  (284, 'החוט_המשולש_284', 'ירושלים', 'הרברט סמואל 2, ירושלים', 31.7816, 35.21941, 0),
  (285, 'בית_השנטי_285', 'תל אביב', 'נחום גולדמן 5, תל אביב', 32.05922, 34.75991, 0),
  (285, 'בית_השנטי_285', 'ירושלים', 'מדרגות הביקור 2, עין כרם, ירושלים', 31.767637, 35.163903, 1),
  (285, 'בית_השנטי_285', 'מדבר', 'צומת ציפורים, כביש 40, דרומית לשדה בוקר', 30.83561, 34.739881, 2),
  (286, 'עמותת_יחדיו_קורת_גג_בראשית_286', 'באר שבע', 'משה דיין 1, באר שבע', 31.2649, 34.77254, 0),
  (287, 'אנוש_הלנת_חירום_287', 'עומר', 'מרגנית 31, עומר', 31.27529, 34.84821, 0),
  (287, 'אנוש_הלנת_חירום_287', 'קריית חיים', 'הגדוד העברי 58, קריית חיים', 32.82436, 35.06858, 1)
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

COMMIT;
