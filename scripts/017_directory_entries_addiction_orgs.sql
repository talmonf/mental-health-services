-- Migration 017 (Aug 2026)
-- directory_entries: addiction & family-of-addict organizations (rows 247–253)
-- Dual-listed under addictions + families where relevant.
-- entry_id slugs match generate_directory_entries_sql.js.

BEGIN;

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
) VALUES
  (
    'מרכז_קשרים_247',
    'מרכז קשרים',
    'טיפול בהתמכרויות התנהגותיות (מין, פורנו, הימורים, אוכל, קשרים, מסכים) ותמיכה מערכתית לבני משפחה ובני זוג — טיפול, קבוצות ותוכנית 12 הצעדים',
    'addictions',
    ARRAY['addictions', 'families']::text[]
  ),
  (
    'עמותת_אפשר_יחידה_להתמכרויות_248',
    'עמותת אפשר — יחידה להתמכרויות',
    'טיפול בנפגעי אלכוהול, הימורים והתמכרויות התנהגותיות נוספות — למכורים ולבני משפחותיהם; הסברה ומניעה',
    'addictions',
    ARRAY['addictions', 'families']::text[]
  ),
  (
    'רטורנו_גמילה_מהתמכרויות_249',
    'רטורנו — גמילה מהתמכרויות',
    'אשפוזית, טיפול יום וקהילות טיפוליות לגמילה ושיקום; מותאם גם לאוכלוסייה דתית וחרדית; מפוקח ע״י משרדי הבריאות והרווחה',
    'addictions',
    ARRAY['addictions']::text[]
  ),
  (
    'דרך_אחרת_250',
    'דרך אחרת',
    'מרכז ברישיון משרד הבריאות לטיפול בהתמכרויות — בית מאזן לתחלואה כפולה, מרפאת יום, גמילה ותמיכה למשפחות; בשיתוף קופות החולים',
    'addictions',
    ARRAY['addictions', 'families']::text[]
  ),
  (
    'נר_אנון_ישראל_251',
    'נר-אנון ישראל',
    'קבוצות עזרה עצמית אנונימיות (12 צעדים) למשפחות וחברים של מכורים לסמים',
    'addictions',
    ARRAY['addictions', 'families']::text[]
  ),
  (
    'אל_אנון_ישראל_252',
    'אל-אנון ישראל',
    'קבוצות תמיכה אנונימיות (12 צעדים) למשפחות וחברים של אנשים הסובלים מאלכוהוליזם — פרונטלי וזום',
    'addictions',
    ARRAY['addictions', 'families']::text[]
  ),
  (
    'א_א_אלכוהוליסטים_אנונימיים_253',
    'א.א. אלכוהוליסטים אנונימיים',
    'קבוצות עזרה עצמית אנונימיות (12 צעדים) לאנשים הסובלים מבעיית שתייה',
    'addictions',
    ARRAY['addictions']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

COMMIT;
