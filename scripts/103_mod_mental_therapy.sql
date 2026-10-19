-- Migration 103 (19 Oct 2026)
-- שירותי טיפול ושיקום נפשי של אגף השיקום (rows 755–769).
-- 101 and 102 were already used, so this is 103 rather than the number in the plan.
-- Audit wording approved with the plan on 19.10.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'אגף_השיקום_טיפול_ושיקום_נפשי_755',
  'אגף השיקום, משרד הבטחון',
  'עמוד השירותים לטיפול ושיקום נפשי',
  'portals',
  ARRAY['portals', 'mod']::text[],
  ARRAY['unknown']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '755|||עמוד השירותים לטיפול ושיקום נפשי',
  755,
  'אגף_השיקום_טיפול_ושיקום_נפשי_755',
  '{"org":"אגף השיקום, משרד הבטחון","svc":"עמוד השירותים לטיפול ושיקום נפשי","target":"מי שהוכרו כנכי צה״ל, או נמצאים בתהליך הכרה, בשל פגיעה נפשית או פוסט טראומה","region":"כל הארץ","cost":"","specialty":"","languages":"","diseases":"","notes":"עמוד המרכז של אגף השיקום: טיפול, ליווי, מסגרות שהייה ועזרה מיידית. אינו קו סיוע. [נפש אחת](https://nefesh-il.org/emergency?entry=11&section=emergency), [בית בטוח](https://nefesh-il.org/emergency?entry=39&section=emergency), [המדריך ל-PTSD](https://nefesh-il.org/emergency?entry=103&section=anxiety_apps), [היחידה לתגובות קרב](https://nefesh-il.org/rights?entry=214&section=mod) ו[טיפולים רגשיים במימון](https://nefesh-il.org/rights?entry=218&section=mod) בכרטיסים נפרדים.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://shikum.mod.gov.il/medical/mental-therapy","webLabel":"","web2":"https://shikum.mod.gov.il/medical/mental-therapy/main-services-guide","webLabel2":"מדריך שירותים","add":"https://myshikum.mod.gov.il/suppliers/therapy","addLabel":"איתור מטפלים","phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"19.10.2026: נבדק מול https://shikum.mod.gov.il/medical/mental-therapy ."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'תכנית_עמית_756',
  'תכנית עמית (משרד הביטחון)',
  'טיפולים, ספורט וסדנאות בחינם למשוחררי מלחמת חרבות ברזל',
  'mod',
  ARRAY['mod', 'trauma']::text[],
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
  '756|||טיפולים, ספורט וסדנאות בחינם למשוחררי מלחמת חרבות ברזל',
  756,
  'תכנית_עמית_756',
  '{"org":"תכנית עמית (משרד הביטחון)","svc":"טיפולים, ספורט וסדנאות בחינם למשוחררי מלחמת חרבות ברזל","target":"משוחררי סדיר ומילואים לפי תנאי התוכנית, מ-7.10.2023","region":"כל הארץ","cost":"חינם","specialty":"","languages":"","diseases":"","notes":"12 מפגשי טיפול נפשי, וגם ספורט, רפואה משלימה וסדנאות, עד 31.12.2027. מצטרפים באפליקציה. לטלפון כשר: *5261. עד 31.12.2025: מילואים מעל 30 יום, או סדיר שהשתחרר, מאז 7.10.2023. מ-1.1.2026 התנאים באתר, כולל מילואים לוחמים של 50 יום. מי שהוכר או בתהליך הכרה על פציעה במלחמה מקבל את הטיפול הנפשי דרך האגף. שונה מ[רפואה משלימה](https://nefesh-il.org/rights?entry=765&section=mod).","tags":"חרבות ברזל","whatsapp":"","whatsappLabel":"","email":"","web":"https://tochnitamit.mod.gov.il/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"*5261","phoneLabel":"מוקד","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"19.10.2026: נבדק מול https://tochnitamit.mod.gov.il/ ."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'מדריך_לפני_הכרה_757',
  'אגף השיקום, משרד הבטחון',
  'מדריך מענים נפשיים למי שטרם הגיש בקשה להכרה',
  'portals',
  ARRAY['portals', 'mod']::text[],
  ARRAY['unknown']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '757|||מדריך מענים נפשיים למי שטרם הגיש בקשה להכרה',
  757,
  'מדריך_לפני_הכרה_757',
  '{"org":"אגף השיקום, משרד הבטחון","svc":"מדריך מענים נפשיים למי שטרם הגיש בקשה להכרה","target":"מי שטרם הגיש לאגף בקשה להכרה בנכות, וזקוק לתמיכה","region":"כל הארץ","cost":"","specialty":"","languages":"","diseases":"","notes":"רוב המענים בדף ניתנים על ידי גורמים שאינם האגף. טיפול שיקומי של האגף ניתן למי שהגיש בקשה להכרה וקיבל אישור מקצין התגמולים. [היחידה לתגובות קרב](https://nefesh-il.org/rights?entry=214&section=mod), [תכנית עמית](https://nefesh-il.org/rights?entry=756&section=mod), [המדריך ל-PTSD](https://nefesh-il.org/emergency?entry=103&section=anxiety_apps) ו[מרכזי חוסן](https://nefesh-il.org/emergency?entry=30&section=emergency) בכרטיסים נפרדים.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://shikum.mod.gov.il/medical/mental-therapy/before-recognition","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"19.10.2026: נבדק מול https://shikum.mod.gov.il/medical/mental-therapy/before-recognition ."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'צוות_מתן_758',
  'אגף השיקום, משרד הבטחון',
  'צוות התערבות מתן לשעת משבר',
  'mod',
  ARRAY['mod', 'emergency', 'alternatives']::text[],
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
  '758|||צוות התערבות מתן לשעת משבר',
  758,
  'צוות_מתן_758',
  '{"org":"אגף השיקום, משרד הבטחון","svc":"צוות התערבות מתן לשעת משבר","target":"נכי ונכות צה״ל, ומי שנמצאים בתהליך הכרה","region":"כל הארץ","cost":"","specialty":"","languages":"","diseases":"","notes":"צוות בריאות הנפש שמגיע עד הבית בתוך שעתיים, 24/7, בפריסה ארצית. מופעל אחרי פנייה ל[נפש אחת](https://nefesh-il.org/emergency?entry=11&section=emergency) ולפי הערכה, או דרך עובדת השיקום. מענה נקודתי, לא טיפול קבוע.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://shikum.mod.gov.il/medical/mental-therapy/matan","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"*8944","phoneLabel":"נפש אחת","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"19.10.2026: נבדק מול https://shikum.mod.gov.il/medical/mental-therapy/matan ."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'כלב_סיוע_759',
  'אגף השיקום, משרד הבטחון',
  'כלב סיוע להתמודדות עם פוסט טראומה',
  'mod',
  ARRAY['mod', 'trauma']::text[],
  ARRAY['mod_rehab_worker']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '759|||כלב סיוע להתמודדות עם פוסט טראומה',
  759,
  'כלב_סיוע_759',
  '{"org":"אגף השיקום, משרד הבטחון","svc":"כלב סיוע להתמודדות עם פוסט טראומה","target":"מי שהוכר בגלל פוסט טראומה, עם 20% נכות לפחות (או 10% אם ההכרה עד 31.12.1995)","region":"כל הארץ","cost":"במימון אגף השיקום","specialty":"","languages":"","diseases":"PTSD","notes":"הכלב מזהה עלייה בחרדה, מסייע בהתקף ומעיר מסיוט. הוא נשאר בבעלות הספק. פונים למחלקת השיקום במחוז. אחרי קבלה משולם 396 ₪ בחודש להוצאות הכלב. אין החזר על כלב שנרכש באופן עצמאי.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://shikum.mod.gov.il/medical/hospitalization/service-dog","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"required","rehab_basket":"any"},"internal_notes":"19.10.2026: נבדק מול https://shikum.mod.gov.il/medical/hospitalization/service-dog ."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'חוות_שיקומיות_760',
  'אגף השיקום, משרד הבטחון',
  'חוות שיקומיות לפוסט טראומה',
  'mod',
  ARRAY['mod', 'rehabilitation']::text[],
  ARRAY['mod_rehab_worker']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '760|||חוות שיקומיות לפוסט טראומה',
  760,
  'חוות_שיקומיות_760',
  '{"org":"אגף השיקום, משרד הבטחון","svc":"חוות שיקומיות לפוסט טראומה","target":"מי שהוכר על מצב נפשי, או מי שאובחן עם תסמיני פוסט טראומה ועדיין לא השלים הכרה","region":"כרמיאל, רמת גן, סתריה, נתיב הל״ה, תל מונד, צור הדסה, בית שמש, עין יעל, ירושלים, להב","cost":"","specialty":"","languages":"","diseases":"PTSD","notes":"תוכנית עד 6 חודשים, מהבוקר עד אחר הצהריים. ההצטרפות דרך עובדת השיקום במחוז. [רטורנו — חוות חוסן](https://nefesh-il.org/treatment?entry=211&section=trauma) היא אחת החוות, בכרטיס נפרד.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://shikum.mod.gov.il/rehabilitation/vocational/farms-therapy","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"19.10.2026: נבדק מול https://shikum.mod.gov.il/rehabilitation/vocational/farms-therapy ."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'בית_מעגן_761',
  'אגף השיקום, משרד הבטחון',
  'בית מעבר בית מעגן',
  'mod',
  ARRAY['mod', 'alternatives']::text[],
  ARRAY['mod_rehab_worker']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '761|||בית מעבר בית מעגן',
  761,
  'בית_מעגן_761',
  '{"org":"אגף השיקום, משרד הבטחון","svc":"בית מעבר בית מעגן","target":"נכי ונכות צה״ל עם פוסט טראומה, במשבר פסיכו-סוציאלי, שזקוקים למסגרת תומכת זמנית","region":"חופית","cost":"חינם","specialty":"","languages":"","diseases":"PTSD","notes":"עד 10 אנשים, עד 3 חודשים, ואחר כך ליווי עד 3 חודשים. פנסיון מלא. אינו חלופת אשפוז, ולא מתאים לאובדנות פעילה, לפסיכוזה פעילה או לשימוש בחומרים. התחייבות מעובדת השיקום. מופעל על ידי שני בקהילה. הרחוב לא פורסם.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://shikum.mod.gov.il/medical/mental-therapy/maavar_housing","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"required","rehab_basket":"any"},"internal_notes":"19.10.2026: נבדק מול https://shikum.mod.gov.il/medical/mental-therapy/maavar_housing ."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'בית_מאזן_אגף_השיקום_762',
  'אגף השיקום, משרד הבטחון',
  'בית מאזן בקהילה — מניעת אשפוז',
  'mod',
  ARRAY['mod', 'alternatives']::text[],
  ARRAY['mod_rehab_worker']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '762|||בית מאזן בקהילה — מניעת אשפוז',
  762,
  'בית_מאזן_אגף_השיקום_762',
  '{"org":"אגף השיקום, משרד הבטחון","svc":"בית מאזן בקהילה — מניעת אשפוז","target":"נכי צה״ל במשבר נפשי. בתים ייעודיים למי שהוכר או קיבל הכרה עקרונית. בתים כלליים למי שבתהליך וטרם קיבל הכרה עקרונית","region":"רחובות, באר שבע, תל אביב, הרצליה, מטע, לוד, ירושלים, כפר יונה, חדרה, קיסריה, קריית אתא, כרמיאל, מגדל העמק, סוואעד חמירה, הרדוף, יבנה, אבן יהודה, בני דרור","cost":"חינם","specialty":"","languages":"","diseases":"","notes":"עד 3 חודשים, עד 12 אנשים, באישור הרופא המחוזי. לא מתאים לאובדנות פעילה, לפסיכוזה פעילה או לשימוש בחומרים. בתים ייעודיים לנכי צה״ל: בית שחר ברחובות ובית יהב בבאר שבע (הרחוב לא פורסם). הכתובות של הבתים הכלליים בדף. [בתים מאזנים](https://nefesh-il.org/treatment?entry=53&section=alternatives) ו[בית בטוח](https://nefesh-il.org/treatment?entry=39&section=alternatives) בכרטיסים נפרדים.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://shikum.mod.gov.il/medical/mental-therapy/balancing-house","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"19.10.2026: נבדק מול https://shikum.mod.gov.il/medical/mental-therapy/balancing-house ."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'קבוצות_טיפוליות_אגף_השיקום_763',
  'אגף השיקום, משרד הבטחון',
  'קבוצות טיפוליות לנכי צה״ל ולבני משפחה',
  'mod',
  ARRAY['mod', 'rehabilitation']::text[],
  ARRAY['mod_rehab_worker']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '763|||קבוצות טיפוליות לנכי צה״ל ולבני משפחה',
  763,
  'קבוצות_טיפוליות_אגף_השיקום_763',
  '{"org":"אגף השיקום, משרד הבטחון","svc":"קבוצות טיפוליות לנכי צה״ל ולבני משפחה","target":"מי שהוכרו כנכי צה״ל, והורים, בני זוג וילדים","region":"כל הארץ","cost":"","specialty":"","languages":"","diseases":"","notes":"מפגש שבועי. חלק מהקבוצות משלבות פעילות בחוץ, מותאמת גם לנכות פיזית. הרישום במערכת הקבוצות, ושאלות ליועצת הקבוצות במחוז. המיילים בדף.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://shikum.mod.gov.il/rehabilitation/vocational/group-therapy","webLabel":"","web2":"","webLabel2":"","add":"https://shikum.mod.gov.il/groups","addLabel":"רשימת הקבוצות","phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"required","rehab_basket":"any"},"internal_notes":"19.10.2026: נבדק מול https://shikum.mod.gov.il/rehabilitation/vocational/group-therapy ."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'חונכות_אישית_אגף_השיקום_764',
  'אגף השיקום, משרד הבטחון',
  'חונכות אישית לשיקום בבית ובקהילה',
  'mod',
  ARRAY['mod', 'rehabilitation']::text[],
  ARRAY['mod_rehab_worker']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '764|||חונכות אישית לשיקום בבית ובקהילה',
  764,
  'חונכות_אישית_אגף_השיקום_764',
  '{"org":"אגף השיקום, משרד הבטחון","svc":"חונכות אישית לשיקום בבית ובקהילה","target":"20% נכות לפחות על פגיעה נפשית או פגיעת ראש, או 100% ומעלה על כל פגיעה","region":"כל הארץ","cost":"","specialty":"","languages":"","diseases":"","notes":"ליווי אישי למיומנות חברתית, ללימודים, לתעסוקה ולשמירה על תפקוד. פונים קודם לעובדת השיקום, גם אם אחר כך פונים לספק. רשימת הספקים בדף. זו חונכות של אגף השיקום, לא [חונכות של סל שיקום](https://nefesh-il.org/rights?entry=278&section=moh).","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://shikum.mod.gov.il/rehabilitation/vocational/tutoring","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"required","rehab_basket":"any"},"internal_notes":"19.10.2026: נבדק מול https://shikum.mod.gov.il/rehabilitation/vocational/tutoring ."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'רפואה_משלימה_Shikum_Me_765',
  'אגף השיקום, משרד הבטחון',
  'טיפולי רפואה משלימה באפליקציית Shikum.Me',
  'mod',
  ARRAY['mod']::text[],
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
  '765|||טיפולי רפואה משלימה באפליקציית Shikum.Me',
  765,
  'רפואה_משלימה_Shikum_Me_765',
  '{"org":"אגף השיקום, משרד הבטחון","svc":"טיפולי רפואה משלימה באפליקציית Shikum.Me","target":"20% נכות לפחות על פוסט טראומה, פגיעה נפשית או פגיעת ראש (או 10% אם ההכרה לפני 31.12.1995), או נכות מיוחדת 100%+","region":"כל הארץ","cost":"6,600 ₪ לשנה קלנדרית","specialty":"","languages":"","diseases":"","notes":"הסכום נטען באפליקציה ולא עובר לשנה הבאה. בחירת המטפל באחריות הפונה. המוקד בימים א׳–ה׳ 08:00–20:00, וביום ו׳ 08:00–12:00. מי שקיבל טיפולים ב-2025 יכול להגיש קבלות עד 31.12.2026, עד 6,600 ₪, וזה גורע את הסכום מהאפליקציה.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://shikum.mod.gov.il/medical/treatment/alternative","webLabel":"","web2":"","webLabel2":"","add":"https://shikumme.co.il/","addLabel":"האפליקציה","phone":"074-7174830","phoneLabel":"מוקד האפליקציה","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"required","rehab_basket":"any"},"internal_notes":"19.10.2026: נבדק מול https://shikum.mod.gov.il/medical/treatment/alternative ."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'טיפול_נפשי_למשפחה_766',
  'אגף השיקום, משרד הבטחון',
  'טיפול נפשי לבני משפחה',
  'mod',
  ARRAY['mod', 'families']::text[],
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
  '766|||טיפול נפשי לבני משפחה',
  766,
  'טיפול_נפשי_למשפחה_766',
  '{"org":"אגף השיקום, משרד הבטחון","svc":"טיפול נפשי לבני משפחה","target":"הורים, בן או בת זוג, וילדים מגיל 7 עד 30, של מי שהוכר על פוסט טראומה, פגיעה נפשית או פגיעת ראש","region":"כל הארץ","cost":"החזר עד 384 ₪ למפגש","specialty":"","languages":"","diseases":"","notes":"שעת טיפול בשבוע אצל מטפל מוסמך, כשיש 20% נכות לפחות (או 10% בהכרה לפני 1996) או נכות מיוחדת 100%+. ילדים עד 18 יכולים לקבל במקום זה החזר על רפואה משלימה דרך קופת החולים. בהכרה עקרונית: 12 מפגשים, ואחים מגיל 7 עד 18 רק במכונים שבהסדר. [נט״ל](https://nefesh-il.org/emergency?entry=21&section=helplines) הוא אחד המכונים.","tags":"","whatsapp":"","whatsappLabel":"","email":"shikum_mokedtipulim@mod.gov.il","web":"https://shikum.mod.gov.il/family/support/therapy","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"required","rehab_basket":"any"},"internal_notes":"19.10.2026: נבדק מול https://shikum.mod.gov.il/family/support/therapy ."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'טיפול_בתפקוד_האינטימי_767',
  'אגף השיקום, משרד הבטחון',
  'טיפול בתפקוד האינטימי',
  'mod',
  ARRAY['mod']::text[],
  ARRAY['mod_rehab_worker']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '767|||טיפול בתפקוד האינטימי',
  767,
  'טיפול_בתפקוד_האינטימי_767',
  '{"org":"אגף השיקום, משרד הבטחון","svc":"טיפול בתפקוד האינטימי","target":"פגיעה מוכרת בתפקוד המיני, או 30% נכות נפשית או פוסט טראומה לצמיתות או לשלוש שנים, או 40% על פגיעת ראש","region":"כל הארץ","cost":"במימון אגף השיקום","specialty":"","languages":"","diseases":"","notes":"אצל מטפלים מוסמכים, בלי עירום ובלי מגע אינטימי. מתחילים בהתחייבות למרפאה בבית חולים, דרך האזור האישי או מרפאת המחוז. ויאגרה או סיאליס: עד 8 כדורים בחודש דרך האגף.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://shikum.mod.gov.il/medical/treatment/intimacy-therapy","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"19.10.2026: נבדק מול https://shikum.mod.gov.il/medical/treatment/intimacy-therapy ."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'הבראה_פגיעה_נפשית_768',
  'אגף השיקום, משרד הבטחון',
  'הבראה למתמודדים עם פגיעה נפשית',
  'mod',
  ARRAY['mod']::text[],
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
  '768|||הבראה למתמודדים עם פגיעה נפשית',
  768,
  'הבראה_פגיעה_נפשית_768',
  '{"org":"אגף השיקום, משרד הבטחון","svc":"הבראה למתמודדים עם פגיעה נפשית","target":"מי שנקבעה לו נכות נפשית","region":"כל הארץ","cost":"במימון אגף השיקום","specialty":"","languages":"","diseases":"","notes":"השלמה למענק ההבראה השנתי, לשהייה במלון שבהסדר. אי אפשר להמיר את התוספת לכסף. מ-10% עד 29% נכות נפשית ההשלמה היא עד 5 ימים, ומ-30% עד 49% עד 7 ימים, לפי אחוז הנכות הכוללת. מ-50% אין תוספת, כי מענק ההבראה כבר מכסה 11 ימים. הבראה אחרי אשפוז, בית מאזן או בית בטוח היא זכאות נפרדת, בתוך חודשיים מהשחרור, לפי החלטת הרופא המחוזי.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://shikum.mod.gov.il/medical/relaxation/mental","webLabel":"","web2":"","webLabel2":"","add":"https://shikum.mod.gov.il/medical/relaxation/hospitalization","addLabel":"הבראה לאחר אשפוז","phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"required","rehab_basket":"any"},"internal_notes":"19.10.2026: נבדק מול https://shikum.mod.gov.il/medical/relaxation/mental ."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'טיפולים_חדשניים_פוסט_טראומה_769',
  'אגף השיקום, משרד הבטחון',
  'טיפולים חדשניים להקלה בפוסט טראומה',
  'mod',
  ARRAY['mod', 'trauma']::text[],
  ARRAY['mod_rehab_worker']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (card_key, row_id, entry_id, public_fields, eligibility, sites)
VALUES (
  '769|||טיפולים חדשניים להקלה בפוסט טראומה',
  769,
  'טיפולים_חדשניים_פוסט_טראומה_769',
  '{"org":"אגף השיקום, משרד הבטחון","svc":"טיפולים חדשניים להקלה בפוסט טראומה","target":"מי שמטופל באגף השיקום על פוסט טראומה, כשטיפולים מקובלים לא הספיקו","region":"כל הארץ","cost":"במימון אגף השיקום","specialty":"Prism, Deep TMS","languages":"","diseases":"PTSD","notes":"התחייבות אחרי המלצה מרופא מומחה למרפאת המחוז. בדף: Prism, 15 מפגשים, ו-Deep TMS של BrainsWay, 20 עד 30 מפגשים. [Prism](https://nefesh-il.org/treatment?entry=269&section=treatments) ו[גרייה מגנטית](https://nefesh-il.org/treatment?entry=105&section=treatments) בכרטיסים נפרדים.","tags":"","whatsapp":"","whatsappLabel":"","email":"","web":"https://shikum.mod.gov.il/medical/treatment/ptsd","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","phone":"","phoneLabel":"","phoneShowNumber":true,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}'::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"required","rehab_basket":"any"},"internal_notes":"19.10.2026: נבדק מול https://shikum.mod.gov.il/medical/treatment/ptsd ."}'::jsonb,
  '[]'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-10-19-mod-mental-therapy',
  DATE '2026-10-19',
  'שירותי טיפול ושיקום נפשי של אגף השיקום',
  'נוסף העמוד המרכז של אגף השיקום לטיפול ושיקום נפשי, ונוספו כרטיסים נפרדים לתכניות שמופיעות בו ועדיין לא היו באתר: תכנית עמית, מדריך למי שטרם הגיש בקשה להכרה, צוות מתן, כלב סיוע, חוות שיקומיות, בית מעגן, בית מאזן, קבוצות טיפוליות, חונכות אישית, רפואה משלימה, טיפול נפשי למשפחה, טיפול בתפקוד האינטימי, הבראה וטיפולים חדשניים.',
  'cards',
  ARRAY[
  '755|||עמוד השירותים לטיפול ושיקום נפשי',
  '756|||טיפולים, ספורט וסדנאות בחינם למשוחררי מלחמת חרבות ברזל',
  '757|||מדריך מענים נפשיים למי שטרם הגיש בקשה להכרה',
  '758|||צוות התערבות מתן לשעת משבר',
  '759|||כלב סיוע להתמודדות עם פוסט טראומה',
  '760|||חוות שיקומיות לפוסט טראומה',
  '761|||בית מעבר בית מעגן',
  '762|||בית מאזן בקהילה — מניעת אשפוז',
  '763|||קבוצות טיפוליות לנכי צה״ל ולבני משפחה',
  '764|||חונכות אישית לשיקום בבית ובקהילה',
  '765|||טיפולי רפואה משלימה באפליקציית Shikum.Me',
  '766|||טיפול נפשי לבני משפחה',
  '767|||טיפול בתפקוד האינטימי',
  '768|||הבראה למתמודדים עם פגיעה נפשית',
  '769|||טיפולים חדשניים להקלה בפוסט טראומה'
  ],
  '{}',
  '103_mod_mental_therapy.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
