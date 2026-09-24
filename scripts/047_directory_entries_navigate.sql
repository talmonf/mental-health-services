-- Migration 047 (24 Sep 2026)
-- directory_entries + directory_card_edits: נויגייט (NAVIGATE), row 291.
-- Sites live on directory_card_edits.sites (admin-editable, not painted on the card)
-- and are mirrored into directory_entry_locations for the baked map fallback.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

ALTER TABLE directory_card_edits
  ADD COLUMN IF NOT EXISTS sites jsonb NOT NULL DEFAULT '[]'::jsonb;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'directory_card_edits_sites_array'
      AND conrelid = 'directory_card_edits'::regclass
  ) THEN
    ALTER TABLE directory_card_edits
      ADD CONSTRAINT directory_card_edits_sites_array
      CHECK (jsonb_typeof(sites) = 'array');
  END IF;
END $$;

COMMENT ON COLUMN directory_card_edits.sites IS
  'Physical sites for the map chooser and nearby search. Not painted on the card. A sites-only save does not move public_edited_at.';

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys,
  referral_codes
) VALUES (
  'נויגייט_navigate_291',
  'נויגייט (NAVIGATE)',
  'תוכנית טיפול קהילתית מוקדמת לצעירים אחרי אפיזודה פסיכוטית ראשונה',
  'mh_clinics',
  ARRAY['mh_clinics', 'youth', 'families']::text[],
  ARRAY['self_referral']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '291|||תוכנית טיפול קהילתית מוקדמת לצעירים אחרי אפיזודה פסיכוטית ראשונה',
  291,
  'נויגייט_navigate_291',
  '{"org":"נויגייט (NAVIGATE)","svc":"תוכנית טיפול קהילתית מוקדמת לצעירים אחרי אפיזודה פסיכוטית ראשונה","target":"צעירים שחווים אפיזודה או משבר פסיכוטי ראשון","region":"מרפאות ברחבי הארץ","cost":"","specialty":"התערבות מוקדמת בפסיכוזה","languages":"","diseases":"","notes":"אמבולטורית ורב-צוותית (פסיכיאטר, פסיכותרפיה, שיקום תעסוקה והשכלה, ליווי משפחתי), לפי מודל NAVIGATE. פרטי כל מרפאה באתר. מרפאת בת ים פועלת בהדספייס (כרטיס נפרד).","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://www.navigateisrael.com/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":18,"age_max":40,"sex":"any","location_mode":"sites","regions":[],"diagnoses":["אפיזודה פסיכוטית ראשונה"],"presenting_problems":["משבר פסיכוטי ראשון"],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"גיל 18–40 ומשך של כשנתיים לפי סיכום העורך; דף הבית של נויגייט לא מציין את הטווח או את משך התוכנית. למרפאת באר יעקב (מרחבים) אין טלפון באתר. קואורדינטות: שלוותה, גהה ובני ציון לפי בניין; בת ים לפי רחוב רוטשילד; קריית יובל, לב השרון (פרדס חנה-כרכור) ומזור (עכו) לפי מרכז היישוב או השכונה."}'::jsonb,
  '[
    {"label":"הוד השרון","address":"המרכז לבריאות הנפש שלוותה, עליית הנוער, הוד השרון","lat":32.15486,"lng":34.898352,"phone":"09-7478050","email":"kerenyuz@clalit.org.il","sort_order":0},
    {"label":"באר יעקב","address":"מרפאת המרכז הרפואי מרחבים, באר יעקב","lat":31.935925,"lng":34.829972,"phone":"","email":"","sort_order":1},
    {"label":"ירושלים","address":"המרפאה הקהילתית לבריאות הנפש, קריית יובל, ירושלים","lat":31.76436,"lng":35.175045,"phone":"02-6435378","email":"yovel.y@moh.gov.il","sort_order":2},
    {"label":"פתח תקווה","address":"המרכז לבריאות הנפש גהה, הלסינקי 1, פתח תקווה","lat":32.089107,"lng":34.864914,"phone":"03-9258258","email":"a.clinic@clalit.org.il","sort_order":3},
    {"label":"חיפה","address":"המרכז הרפואי בני ציון, חיפה","lat":32.806072,"lng":34.992414,"phone":"04-8359661","email":"adi.kuntz@b-zion.org.il","sort_order":4},
    {"label":"בת ים","address":"הדספייס, רוטשילד 29, בת ים","lat":32.027094,"lng":34.746965,"phone":"03-9136555","email":"info@headspace.org.il","sort_order":5},
    {"label":"השרון","address":"מרפאת מרכז רפואי לב השרון, פרדס חנה-כרכור","lat":32.474996,"lng":34.975139,"phone":"09-8981242","email":"Michalh@lev-hasharon.co.il","sort_order":6},
    {"label":"עכו","address":"מרפאת חוץ, מרכז רפואי לבריאות הנפש מזור, עכו","lat":32.928173,"lng":35.075638,"phone":"04-9954778","email":"rozanna@mazor.health.gov.il","sort_order":7}
  ]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entry_locations (row_id, entry_id, label, address, lat, lng, sort_order)
VALUES
  (291, 'נויגייט_navigate_291', 'הוד השרון', 'המרכז לבריאות הנפש שלוותה, עליית הנוער, הוד השרון', 32.15486, 34.898352, 0),
  (291, 'נויגייט_navigate_291', 'באר יעקב', 'מרפאת המרכז הרפואי מרחבים, באר יעקב', 31.935925, 34.829972, 1),
  (291, 'נויגייט_navigate_291', 'ירושלים', 'המרפאה הקהילתית לבריאות הנפש, קריית יובל, ירושלים', 31.76436, 35.175045, 2),
  (291, 'נויגייט_navigate_291', 'פתח תקווה', 'המרכז לבריאות הנפש גהה, הלסינקי 1, פתח תקווה', 32.089107, 34.864914, 3),
  (291, 'נויגייט_navigate_291', 'חיפה', 'המרכז הרפואי בני ציון, חיפה', 32.806072, 34.992414, 4),
  (291, 'נויגייט_navigate_291', 'בת ים', 'הדספייס, רוטשילד 29, בת ים', 32.027094, 34.746965, 5),
  (291, 'נויגייט_navigate_291', 'השרון', 'מרפאת מרכז רפואי לב השרון, פרדס חנה-כרכור', 32.474996, 34.975139, 6),
  (291, 'נויגייט_navigate_291', 'עכו', 'מרפאת חוץ, מרכז רפואי לבריאות הנפש מזור, עכו', 32.928173, 35.075638, 7)
ON CONFLICT (row_id, label) DO UPDATE SET
  entry_id = EXCLUDED.entry_id,
  address = EXCLUDED.address,
  lat = EXCLUDED.lat,
  lng = EXCLUDED.lng,
  sort_order = EXCLUDED.sort_order;

COMMIT;
