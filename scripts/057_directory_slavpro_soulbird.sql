-- Migration 057 (14 Oct 2026)
-- directory_card_edits: בית משלך (row 289) — shorter notes, name-only phone buttons,
-- and three name-only email buttons.
-- directory_entries + directory_card_edits: שלו (row 306) and ציפור הנפש (row 307).
-- ציפור הנפש has no published address: קרן היסוד 27 is the Jerusalem office only.
-- Other offices stay in the region text until street addresses are added as sites.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'notes', 'טיפול, קורת גג, ארוחות, לימודים, הכשרה, מיצוי זכויות ותעסוקה. הפניה: נערות דרך חסות הנוער (CRM); צעירות בדו״ח סוציאלי מהמחלקה לשירותים חברתיים. הלינה הזמנית לבוגרות פנימיות או חסרות עורף. סמלים: 12948, 12926, 218394. בניהול חכמת נשים וחברת [שלו](https://nefesh-il.org/rights?entry=306&section=rehabilitation).',
      'phoneShowNumber', false,
      'phoneShowNumber2', false,
      'phoneShowNumber3', false,
      'email', 'morh@slavpro.co.il',
      'emailLabel', 'מור הרפז · צעירות',
      'emailShowAddress', false,
      'email2', 'shanis@slavpro.co.il',
      'emailLabel2', 'שני ארוך · נערות',
      'emailShowAddress2', false,
      'email3', 'tzipin@wtc-anatgur.co.il',
      'emailLabel3', 'ציפי נחשון גליק',
      'emailShowAddress3', false
    ),
    eligibility = jsonb_set(
      eligibility,
      '{internal_notes}',
      to_jsonb(
        rtrim(COALESCE(eligibility->>'internal_notes', ''))
        || E'\n\n14.10.2026: קוצרו ההערות (הגילאים כבר בלמי). שלושת הטלפונים מציגים שם בלי מספר. נוספו שלושה כפתורי דוא״ל בלי הכתובת על הכפתור.'
      )
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '289|||רשת הוסטלים לנערות וצעירות במצבי סיכון — ראשון לציון; גישה מודעת טראומה'
  AND COALESCE(public_fields->>'email2', '') = '';

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys,
  referral_codes
) VALUES
(
  'שלו_שיקום_וטיפול_306',
  'שלו — שיקום וטיפול',
  'סל שיקום, דיור, תעסוקה וסיוע להורים מתמודדים',
  'rehabilitation',
  ARRAY['rehabilitation', 'families', 'youth']::text[],
  ARRAY['self_referral', 'rehab_basket_committee']::text[]
),
(
  'ציפור_הנפש_307',
  'ציפור הנפש',
  'ליווי ממוקד הורות להורים המתמודדים עם קשיים נפשיים',
  'rehabilitation',
  ARRAY['rehabilitation', 'families']::text[],
  ARRAY['rehab_basket_committee']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES
(
  '306|||סל שיקום, דיור, תעסוקה וסיוע להורים מתמודדים',
  306,
  'שלו_שיקום_וטיפול_306',
  '{"org":"שלו — שיקום וטיפול","svc":"סל שיקום, דיור, תעסוקה וסיוע להורים מתמודדים","target":"אנשים המתמודדים עם מגבלות, נכויות ומשברי חיים","region":"","cost":"","specialty":"","languages":"","diseases":"","notes":"הוסטל וקהילה תומכת, דיור מוגן, פתרונות תעסוקה, דיור לצעירים וסיוע להורים. [בית משלך](https://nefesh-il.org/support?entry=289&section=youth) בכרטיס נפרד. [ציפור הנפש](https://nefesh-il.org/rights?entry=307&section=rehabilitation) בכרטיס נפרד.","tags":"","whatsapp":"","whatsappLabel":"","web":"https://slavpro.co.il/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","email":"info@slavpro.co.il","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"1599-504949","phoneLabel":"מוקד","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"נבדק 14.10.2026 מול slavpro.co.il. מטה: המלאכה 21, פארק אפק, ראש העין. טלפון 1599-504949, info@slavpro.co.il. השירותים כוללים סל שיקום, הוסטל וקהילה תומכת, דיור מוגן, תעסוקה, דיור לצעירים וסיוע להורים. בית משלך נשאר בכרטיס 289. ציפור הנפש בכרטיס 307. לא הוצמד מיקום למפה — הכתובת היא מטה."}'::jsonb,
  '[]'::jsonb
),
(
  '307|||ליווי ממוקד הורות להורים המתמודדים עם קשיים נפשיים',
  307,
  'ציפור_הנפש_307',
  '{"org":"ציפור הנפש","svc":"ליווי ממוקד הורות להורים המתמודדים עם קשיים נפשיים","target":"הורים לילדים בכל הגילאים, המתמודדים עם בעיות נפשיות","region":"ירושלים, השרון, תל אביב, השפלה, אשדוד, חדרה, הצפון, באר שבע","cost":"במימון משרד הבריאות לזכאי סל שיקום","specialty":"","languages":"","diseases":"","notes":"ליווי פרטני, דיאדי ועם הילדים, קבוצות הורים, מפגשי שיח ומעגל אמהות אחרי לידה. ניתן אל מול אישור ועדת סל שיקום לדיור מוגן. מופעל על ידי [שלו](https://nefesh-il.org/rights?entry=306&section=rehabilitation).","tags":"","whatsapp":"","whatsappLabel":"","web":"https://www.soulbird.co.il/","webLabel":"","web2":"https://www.soulbird.co.il/about-page/","webLabel2":"אודות","add":"","addLabel":"","email":"soulbird@slavpro.co.il","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"phone":"1599-502120","phoneLabel":"מוקד","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"required"},"internal_notes":"נבדק 14.10.2026 מול soulbird.co.il/about-page. ליווי הורות להורים המתמודדים, בפיקוח ובמימון משרד הבריאות, אל מול אישור ועדת סל שיקום לדיור מוגן. טלפון 1599-502120, soulbird@slavpro.co.il. שלוחות בדף האודות: הנהלה 1, שרון 2, תל אביב 3, שפלה 4, ירושלים 5, אשדוד 6, חדרה 7, צפון 8, באר שבע 9. כתובת ירושלים קרן היסוד 27 (OSM house node) לא פורסמה בכרטיס, כי היא של משרד ירושלים בלבד. שאר כתובות הרחוב עדיין לא פורסמו — לא להוסיף סיכות ריקות. מופעל על ידי שלו, כרטיס 306."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

COMMIT;
