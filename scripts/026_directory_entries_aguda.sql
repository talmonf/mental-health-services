-- Migration 026 (3 Sep 2026)
-- directory_entries: האגודה לבריאות הציבור — 5 cards (rows 278–282).
-- 278 שיקום וחונכות / סל שיקום (moh + rehabilitation)
-- 279 בית רעים נתניה (mh_clinics)
-- 280 מרפאת הנגב אופקים (mh_clinics)
-- 281 שיקום לנכי צה"ל (mod)
-- 282 מרכז CHOICE (trauma)
-- Replaces the earlier combined Dror/Yizhar listing for row 278 (if that draft was applied).
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

DELETE FROM directory_entry_locations WHERE row_id = 278;

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
) VALUES
  (
    'האגודה_לבריאות_הציבור_278',
    'האגודה לבריאות הציבור',
    'שירותי סל שיקום',
    'rehabilitation',
    ARRAY['rehabilitation', 'moh']::text[]
  ),
  (
    'בית_רעים_האגודה_לבריאות_הציבור_279',
    'בית רעים (האגודה לבריאות הציבור)',
    'טיפול יום פסיכיאטרי — חלופת אשפוז למבוגרים במצבי משבר',
    'mh_clinics',
    ARRAY['mh_clinics']::text[]
  ),
  (
    'מרפאת_הנגב_האגודה_לבריאות_הציבור_280',
    'מרפאת הנגב (האגודה לבריאות הציבור)',
    'טיפול נפשי מרפאתי — הערכה פסיכיאטרית, טיפול תרופתי ופסיכותרפיה',
    'mh_clinics',
    ARRAY['mh_clinics']::text[]
  ),
  (
    'האגודה_לבריאות_הציבור_281',
    'האגודה לבריאות הציבור',
    'שיקום לנכי צה"ל ונפגעי פעולות איבה — מרכז החממה ותכנית תושייה למשפחות הלומי קרב',
    'mod',
    ARRAY['mod']::text[]
  ),
  (
    'מרכז_צ_ויס_choice_282',
    'מרכז צ׳ויס (CHOICE)',
    'מרכז יום לנוער וצעירים (12–35) על רצף הטראומה וההתמכרות — אבחון, טיפול פרטני וקבוצתי וליווי שיקומי',
    'trauma',
    ARRAY['trauma']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
VALUES
  (279, 'בית_רעים_האגודה_לבריאות_הציבור_279', 'נתניה', 'גיבורי ישראל 24, אזור התעשייה פולג, נתניה', 32.279985, 34.860483, 0),
  (280, 'מרפאת_הנגב_האגודה_לבריאות_הציבור_280', 'אופקים', 'הרצל 37, אופקים', 31.308109, 34.620207, 0),
  (282, 'מרכז_צ_ויס_choice_282', 'בני ברק', 'מגדלי V Tower, בר־כוכבא 23, קומה 5, בני ברק', 32.094072, 34.823239, 0)
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

COMMIT;
