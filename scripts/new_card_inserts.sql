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

