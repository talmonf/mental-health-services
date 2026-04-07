-- Inserts for newly added directory_entries cards.
-- Each time new cards are added, append the corresponding INSERT(s) to this file.

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
)
VALUES
  ('vivid_the_flexible_app_for_life_changing_practices_102', 'VIVID - The Flexible App for Life-Changing Practices', 'אפליקציה אינטראקטיבית לבניית תוכניות תרגול יומי ומעקב לאורך זמן.', 'anxiety_apps', ARRAY['anxiety_apps']::text[]);

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
)
VALUES
  ('המדריך_ל_ptsd_103', 'המדריך ל-PTSD', 'אפליקציה/מדריך דיגיטלי להתמודדות עם PTSD, מטעם אגף השיקום (משרד הביטחון).', 'anxiety_apps', ARRAY['anxiety_apps']::text[]);

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
)
VALUES
  ('מיינדמי_mindme_104', 'מיינדמי (MindMe)', 'מרכז פסיכיאטרי וטיפול רגשי: פסיכותרפיה, טיפול קוגניטיבי-התנהגותי (CBT), טיפול זוגי ומשפחתי, פסיכיאטריה ומתן תרופות, EMDR/DBT/NLP, חרדה, דיכאון, טראומה, התמכרויות ועוד', 'treatments', ARRAY['treatments', 'local']::text[]);

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
)
VALUES
  ('brainsway_105', '(BrainsWay) TMS - גרייה מגנטית מוחית', 'טיפולי גרייה מוחית (TMS ו-Deep TMS) למגוון מצבים נפשיים ונוירולוגיים.', 'treatments', ARRAY['treatments', 'treatments_others', 'tms']::text[]);

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
)
VALUES
  ('acpt_israel_access_center_for_psychedelic_treatment_and_ther_106', 'Psychedelic Treatment & Therapy', 'מרכז גישה לטיפול ותרפיה פסיכדלית.', 'treatments', ARRAY['treatments', 'treatments_others', 'psychedelics']::text[]);

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
)
VALUES
  ('psycircle_107', 'Psychedelic Therapy', 'טיפול פסיכדלי ומידע מקצועי בתחום.', 'treatments', ARRAY['treatments', 'treatments_others', 'psychedelics']::text[]);

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
)
VALUES
  ('איכילוב_תל_השומר_גרייה_מגנטית_מוחית_108', '(איכילוב) TMS - גרייה מגנטית מוחית', 'טיפול בגרייה מגנטית מוחית (TMS) במסגרת מרפאה פסיכיאטרית.', 'treatments', ARRAY['treatments', 'treatments_others', 'tms']::text[]);

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
)
VALUES
  ('ect_נזעי_חשמל_109', 'ECT (נזעי חשמל)', 'מידע על טיפול בנזעי חשמל (ECT) במסגרת פסיכיאטרית.', 'treatments', ARRAY['treatments', 'treatments_others', 'ect']::text[]);

