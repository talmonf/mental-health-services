-- Migration 003 (May 2026)
-- directory_entries: new resources from index.html — איגוד 1202, תאיר, קואליציה לטראומה, תלמ, אדווה ליזר, רזולוציה, מרכז נשימה
-- Applies only rows added in DATA (entry_id slugs match generate_directory_entries_sql.js).

BEGIN;

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
) VALUES
  ('איגוד_מרכזי_הסיוע_לנפגעות_ולנפגעי_תקיפה_מינית_200', 'איגוד מרכזי הסיוע לנפגעות ולנפגעי תקיפה מינית', 'קווי המענה הארציים של ארגון הגג למרכזי הסיוע', 'helplines', ARRAY['helplines']::text[]),
  ('הקואליציה_הישראלית_לטראומה_202', 'הקואליציה הישראלית לטראומה', 'מידע, הכשרות, מוקדי חוסן ושותפות ארצית בטראומה וחוסן (Israel Trauma Coalition)', 'portals', ARRAY['portals', 'trauma']::text[]),
  ('תאיר_מרכז_הסיוע_לנפגעות_ולנפגעי_תקיפה_מינית_201', 'תאיר – מרכז הסיוע לנפגעות ולנפגעי תקיפה מינית', 'סיוע וליווי, חינוך ומניעה, קבוצות תמיכה (פרונטלי וזום)', 'trauma', ARRAY['trauma']::text[]),
  ('תלמ_203', 'תלמ', 'רשת ארצית לטיפול פסיכולוגי, אבחון והכשרה — כולל טיפול בטראומה ובמצוקה נפשית.', 'trauma', ARRAY['trauma']::text[]),
  ('אדווה_ליזר_204', 'אדווה ליזר', 'נטורופתיה קלינית — איזון גוף–נפש (כאבים, עייפות, סטרס, עיכול, אכילה רגשית ועוד); קליניקה ומפגשים מקוונים.', 'nutrition', ARRAY['nutrition']::text[]),
  ('רזולוציה_205', 'רזולוציה', 'יישומים פסיכולוגיים ממוקדים — הערכה ראשונית והתאמת טיפול (פגישות בקליניקה או זום).', 'therapists', ARRAY['therapists']::text[]),
  ('מרכז_נשימה_206', 'מרכז נשימה', 'מודל נשימה — טיפול מסובסד, רשת מטפלים לטראומה מורכבת וגישת גוף–נפש קהילתית.', 'trauma', ARRAY['trauma']::text[])
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

COMMIT;
