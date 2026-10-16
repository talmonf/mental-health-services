-- Migration 083 (16 Oct 2026)
-- Card indicators, batch 5: values approved by the site owner, from docs/card-indicators-2026-10.md.
-- Only cards whose indicators are still empty are filled, so an admin edit is never overwritten.
-- Requires migration 077. Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- I5-241 · row 330 · איזון נפש
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"full"},{"channel":"moh","terms":""}],"referral":["psychiatrist_referral","hmo_form17"],"referral_source":"לקבל הפניה מרופא/ה פסיכיאטר; להגיש בקשת התחייבות למכבי; בכפוף לאישור מקדים של פסיכיאטר מחוזי"}'::jsonb, updated_at = now()
WHERE card_key = '330|||טיפול יום באבן יהודה וביבנה' AND indicators = '{}'::jsonb;

-- I5-242 · row 331 · קידום השביל (חולון)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"full"},{"channel":"moh","terms":""}],"referral":["psychiatrist_referral","hmo_form17"],"referral_source":"לקבל הפניה מרופא/ה פסיכיאטר; להגיש בקשת התחייבות למכבי; בכפוף לאישור מקדים של פסיכיאטר מחוזי"}'::jsonb, updated_at = now()
WHERE card_key = '331|||טיפול יום לנשים אחרי בית מאזן להפרעות אכילה' AND indicators = '{}'::jsonb;

-- I5-243 · row 332 · מסאחה (חמרה)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"full"},{"channel":"moh","terms":""}],"referral":["psychiatrist_referral","hmo_form17"],"referral_source":"לקבל הפניה מרופא/ה פסיכיאטר; להגיש בקשת התחייבות למכבי; בכפוף לאישור מקדים של פסיכיאטר מחוזי"}'::jsonb, updated_at = now()
WHERE card_key = '332|||טיפול יום למבוגרים' AND indicators = '{}'::jsonb;

-- I5-244 · row 333 · גשר לתקווה (כרמיאל)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"full"},{"channel":"moh","terms":""}],"referral":["psychiatrist_referral","hmo_form17"],"referral_source":"לקבל הפניה מרופא/ה פסיכיאטר; להגיש בקשת התחייבות למכבי; בכפוף לאישור מקדים של פסיכיאטר מחוזי"}'::jsonb, updated_at = now()
WHERE card_key = '333|||טיפול יום למבוגרים עם הפרעות אכילה' AND indicators = '{}'::jsonb;

-- I5-245 · row 334 · רגעים (מגדל העמק)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"full"},{"channel":"moh","terms":""}],"referral":["psychiatrist_referral","hmo_form17"],"referral_source":"לקבל הפניה מרופא/ה פסיכיאטר; להגיש בקשת התחייבות למכבי; בכפוף לאישור מקדים של פסיכיאטר מחוזי"}'::jsonb, updated_at = now()
WHERE card_key = '334|||טיפול יום למבוגרים' AND indicators = '{}'::jsonb;

-- I5-246 · row 335 · אופק רם (עכו)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"full"},{"channel":"moh","terms":""}],"referral":["psychiatrist_referral","hmo_form17"],"referral_source":"לקבל הפניה מרופא/ה פסיכיאטר; להגיש בקשת התחייבות למכבי; בכפוף לאישור מקדים של פסיכיאטר מחוזי"}'::jsonb, updated_at = now()
WHERE card_key = '335|||טיפול יום למבוגרים' AND indicators = '{}'::jsonb;

-- I5-247 · row 336 · מעיין הנפש (קריית אתא)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"full"},{"channel":"moh","terms":""}],"referral":["psychiatrist_referral","hmo_form17"],"referral_source":"לקבל הפניה מרופא/ה פסיכיאטר; להגיש בקשת התחייבות למכבי; בכפוף לאישור מקדים של פסיכיאטר מחוזי"}'::jsonb, updated_at = now()
WHERE card_key = '336|||טיפול יום למבוגרים' AND indicators = '{}'::jsonb;

-- I5-248 · row 337 · קרני שמש
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"full"},{"channel":"moh","terms":""}],"referral":["psychiatrist_referral","hmo_form17"],"referral_source":"לקבל הפניה מרופא/ה פסיכיאטר; להגיש בקשת התחייבות למכבי; בכפוף לאישור מקדים של פסיכיאטר מחוזי"}'::jsonb, updated_at = now()
WHERE card_key = '337|||טיפול יום לילדים ולנוער' AND indicators = '{}'::jsonb;

-- I5-249 · row 338 · מרפאת עירון (שער מנשה)
UPDATE directory_card_edits SET indicators = '{"offers":["care","claim"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":""}],"referral":["self_referral","gp_referral"],"referral_source":"הפניה מגורם תוך מוסדי, מגורם בקהילה, או עצמית; פניה ראשונה: מכתב הפניה מרופא משפחה + בדיקות דם בפקס"}'::jsonb, updated_at = now()
WHERE card_key = '338|||מרפאת חוץ לבריאות הנפש, ליד שער בית החולים' AND indicators = '{}'::jsonb;

-- I5-250 · row 339 · שער מנשה — אשפוז יום
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"full"},{"channel":"moh","terms":""}],"referral":["psychiatrist_referral","hmo_form17"],"referral_source":"קבלת מטופלים ממרפאות בריאות הנפש; נדרש טופס 17 למסגרת טיפול יום מבוגרים בשער מנשה, והפניה ע\"י הפסיכיאטר המטפל בקהילה"}'::jsonb, updated_at = now()
WHERE card_key = '339|||מחלקת אשפוז יום לטיפול אינטנסיבי או אחרי אשפוז מלא' AND indicators = '{}'::jsonb;

-- I5-251 · row 340 · שער מנשה — טראומה מינית
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"full"},{"channel":"moh","terms":""}],"referral":["psychiatrist_referral","hmo_form17"],"referral_source":"אשפוז ממוקד: הפנייה ע\"י הגורם המטפל בקהילה. טיפול יום: נדרש טופס 17 והפניה ע\"י הפסיכיאטר המטפל בקהילה"}'::jsonb, updated_at = now()
WHERE card_key = '340|||אשפוז ממוקד, מרפאה וטיפול יום לנפגעי ולנפגעות טראומה מינית' AND indicators = '{}'::jsonb;

-- I5-252 · row 341 · לב השרון — טראומה מינית
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"full"},{"channel":"moh","terms":""}],"referral":["hmo_form17"],"referral_source":"על הגורם המטפל לשלוח מנוי אבחוני (שתי פגישות) מקופת החולים; ההפניה דרך הגורמים המטפלים בקהילה"}'::jsonb, updated_at = now()
WHERE card_key = '341|||אשפוז ממוקד ל-16 יום, וטיפול יום במרכז עוגן' AND indicators = '{}'::jsonb;

-- I5-253 · row 342 · מגן (איכילוב)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '342|||יחידת אשפוז לנשים אחרי פגיעה מינית' AND indicators = '{}'::jsonb;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-16-card-indicators-batch-5',
    DATE '2026-10-16',
    'סימונים בכרטיסים: קבוצה 5',
    'סומנו 13 כרטיסים (שורות 330–342): מה יש בכרטיס, האם זה הכרטיס הכללי של הארגון, מימון ודרך ההפניה.',
    'cards',
    ARRAY[
    '330|||טיפול יום באבן יהודה וביבנה',
    '331|||טיפול יום לנשים אחרי בית מאזן להפרעות אכילה',
    '332|||טיפול יום למבוגרים',
    '333|||טיפול יום למבוגרים עם הפרעות אכילה',
    '334|||טיפול יום למבוגרים',
    '335|||טיפול יום למבוגרים',
    '336|||טיפול יום למבוגרים',
    '337|||טיפול יום לילדים ולנוער',
    '338|||מרפאת חוץ לבריאות הנפש, ליד שער בית החולים',
    '339|||מחלקת אשפוז יום לטיפול אינטנסיבי או אחרי אשפוז מלא',
    '340|||אשפוז ממוקד, מרפאה וטיפול יום לנפגעי ולנפגעות טראומה מינית',
    '341|||אשפוז ממוקד ל-16 יום, וטיפול יום במרכז עוגן',
    '342|||יחידת אשפוז לנשים אחרי פגיעה מינית'
    ],
    '{}',
    '083_card_indicators_b5.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
