-- Migration 010 (May 2026)
-- directory_entries: חרבות ברזל orgs — patches after 009 was applied
-- 1. מטיב (210): remove emergency from category_keys (not under עזרה דחופה)
-- 2. Strip "לפי החוברת" wording from descriptions inserted by 009

BEGIN;

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
) VALUES
  (
    'מטיב_המרכז_הישראלי_לפסיכוטראומה_210',
    'מטיב (המרכז הישראלי לפסיכוטראומה)',
    'טיפול ארצי ללא עלות לטווח ארוך בטראומה',
    'trauma',
    ARRAY['trauma', 'helplines']::text[]
  ),
  (
    'מבצע_הקשב_213',
    'מבצע הקשב',
    'עזרה ראשונה נפשית לנפגעי חרבות ברזל — עד 10 מפגשים',
    'trauma',
    ARRAY['trauma', 'helplines']::text[]
  ),
  (
    'תחנות_ציבוריות_טיפול_זוגי_ומשפחתי_232',
    'תחנות ציבוריות — טיפול זוגי ומשפחתי',
    'מאגר תחנות לטיפול זוגי',
    'trauma',
    ARRAY['trauma']::text[]
  ),
  (
    'קווי_תמיכה_נפשית_קופות_חולים_חרבות_ברזל_243',
    'קווי תמיכה נפשית — קופות חולים (חרבות ברזל)',
    '3 שיחות טיפוליות מקוונות ללא עלות',
    'hmo',
    ARRAY['hmo', 'trauma', 'helplines']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

COMMIT;
