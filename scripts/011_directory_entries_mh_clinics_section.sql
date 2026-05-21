-- Migration 011 (May 2026)
-- directory_entries: מרפאות בריאות הנפש (mh_clinics) as sibling to קופות חולים (hmo)
-- Kupot portal rows stay in hmo; clinic networks get mh_clinics; חרבות ברזל trauma rows aligned

BEGIN;

-- Four kupot: mental-health portals only under hmo
UPDATE directory_entries
SET primary_category = 'hmo',
    category_keys = ARRAY['hmo']::text[]
WHERE entry_id IN (
  'כללית_28',
  'מכבי_29',
  'מאוחדת_80',
  'לאומית_81'
);

-- Clinic networks and related providers under mh_clinics (keep existing keys)
UPDATE directory_entries
SET category_keys = array_cat(category_keys, ARRAY['mh_clinics']::text[])
WHERE entry_id IN (
  'עמותת_בית_חם_62',
  'המרכז_הירושלמי_לבריאות_הנפש_כפר_שאול_איתנים_78',
  'הדספייס_63',
  'מכון_למרחב_מרכז_טיפולי_רב_תחומי_65',
  'me_mental_experts_90'
)
AND NOT ('mh_clinics' = ANY(category_keys));

-- חרבות ברזל clinic programs: trauma + mh_clinics (not hmo)
UPDATE directory_entries
SET category_keys = ARRAY['trauma', 'mh_clinics']::text[]
WHERE entry_id IN (
  'קמה_מרפאת_כללית_221',
  'שיב_א_המרפאה_הלאומית_226'
);

-- חרבות ברזל kupot helpline: trauma + helplines only
UPDATE directory_entries
SET category_keys = array_remove(category_keys, 'hmo')
WHERE entry_id = 'קווי_תמיכה_נפשית_קופות_חולים_חרבות_ברזל_243'
AND 'hmo' = ANY(category_keys);

COMMIT;
