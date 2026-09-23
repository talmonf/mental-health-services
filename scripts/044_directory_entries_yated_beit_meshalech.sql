-- Migration 044 (23 Sep 2026)
-- directory_entries: עו״ס יתד, בית משלך, חכמת נשים (rows 288–290).
-- 288 עו״ס יתד (youth) — distinct from row 227 יתד (משרד הרווחה)
-- 289 בית משלך (youth + local)
-- 290 חכמת נשים (trauma + therapists)
-- 041–043 are already used; this is the next number.
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
    'עו_ס_יתד_288',
    'עו״ס יתד',
    'עובד/ת סוציאלי/ת בתוכנית יתד — ליווי צעירים וצעירות (18–25/26) במצבי חיים מורכבים',
    'youth',
    ARRAY['youth']::text[]
  ),
  (
    'בית_משלך_חכמת_נשים_289',
    'בית משלך (חכמת נשים)',
    'רשת הוסטלים לנערות וצעירות במצבי סיכון — ראשון לציון; גישה מודעת טראומה',
    'youth',
    ARRAY['youth', 'local']::text[]
  ),
  (
    'חכמת_נשים_290',
    'חכמת נשים',
    'קליניקה לטיפול בנשים ובנערות — פסיכותרפיה, פגיעות מיניות, הפרעות אכילה, דיכאון אחרי לידה ואלימות ביחסים',
    'trauma',
    ARRAY['trauma', 'therapists']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

COMMIT;
