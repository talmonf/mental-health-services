-- Migration 079 (16 Oct 2026)
-- Card indicators, batch 1: values approved by the site owner, from docs/card-indicators-2026-10.md.
-- Only cards whose indicators are still empty are filled, so an admin edit is never overwritten.
-- Requires migration 077. Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- I1-001 · row 1 · ביטוח לאומי
UPDATE directory_card_edits SET indicators = '{"offers":["info","claim"],"whole_org":false,"funding":[{"channel":"btl","terms":"eligible"}],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '1|||קצבת נכות למתמודדי נפש' AND indicators = '{}'::jsonb;

-- I1-002 · row 2 · ביטוח לאומי
UPDATE directory_card_edits SET indicators = '{"offers":["info","claim"],"whole_org":false,"funding":[{"channel":"btl","terms":"eligible"}],"referral":["self_referral"],"referral_source":"הגשת תביעה, בצירוף המסמכים הנדרשים"}'::jsonb, updated_at = now()
WHERE card_key = '2|||שירותים מיוחדים (שר"מ)' AND indicators = '{}'::jsonb;

-- I1-003 · row 3 · ביטוח לאומי
UPDATE directory_card_edits SET indicators = '{"offers":["info","claim"],"whole_org":false,"funding":[{"channel":"btl","terms":"eligible"}],"referral":["self_referral"],"referral_source":"יש למלא תביעה לקצבת סיעוד ולצרף מסמכים רפואיים ותלושי שכר"}'::jsonb, updated_at = now()
WHERE card_key = '3|||קצבת סיעוד' AND indicators = '{}'::jsonb;

-- I1-004 · row 4 · יד מכוונת
UPDATE directory_card_edits SET indicators = '{"offers":["claim"],"whole_org":false,"funding":[{"channel":"btl","terms":"full"}],"referral":["self_referral"],"referral_source":"לקביעת פגישה חייגו *2496"}'::jsonb, updated_at = now()
WHERE card_key = '4|||ייעוץ והכנה בחינם לוועדה הרפואית' AND indicators = '{}'::jsonb;

-- I1-005 · row 5 · משרד הבריאות
UPDATE directory_card_edits SET indicators = '{"offers":["care","claim"],"whole_org":false,"funding":[{"channel":"moh","terms":"eligible"}],"referral":["rehab_basket_committee"],"referral_source":"טופס בקשה לסל שיקום (עצמאית או בעזרת איש מקצוע בקופת החולים), ואחר כך ועדת שיקום אזורית"}'::jsonb, updated_at = now()
WHERE card_key = '5|||סל שיקום' AND indicators = '{}'::jsonb;

-- I1-006 · row 6 · אנוש
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"moh","terms":"eligible"}],"referral":["rehab_basket_committee"],"referral_source":"target: זכאי סל שיקום"}'::jsonb, updated_at = now()
WHERE card_key = '6|||שירותי סל שיקום' AND indicators = '{}'::jsonb;

-- I1-007 · row 7 · קידום
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"moh","terms":"eligible"}],"referral":["rehab_basket_committee"],"referral_source":"target: זכאי סל שיקום"}'::jsonb, updated_at = now()
WHERE card_key = '7|||שירותי סל שיקום' AND indicators = '{}'::jsonb;

-- I1-008 · row 8 · ידיד נפש
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"moh","terms":"eligible"},{"channel":"mod","terms":"eligible"},{"channel":"private","terms":""}],"referral":["rehab_basket_committee"],"referral_source":"target: זכאי סל שיקום ממשרד הבריאות או ממשרד הביטחון; יש גם שירות פרטי"}'::jsonb, updated_at = now()
WHERE card_key = '8|||שירותי סל שיקום' AND indicators = '{}'::jsonb;

-- I1-009 · row 9 · אור לנפש
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"moh","terms":"eligible"}],"referral":["rehab_basket_committee"],"referral_source":"target: זכאי סל שיקום"}'::jsonb, updated_at = now()
WHERE card_key = '9|||שירותי סל שיקום' AND indicators = '{}'::jsonb;

-- I1-010 · row 10 · מערך בריאות הנפש בצה״ל
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"מוקד מקול הלב *6690 שלוחה 4, זמין 24/7 לחיילים בסדיר ובמילואים"}'::jsonb, updated_at = now()
WHERE card_key = '10|||קבלת סיוע נפשי מיידי' AND indicators = '{}'::jsonb;

-- I1-011 · row 11 · "נפש אחת בישראל" (אגף השיקום, משרד הבטחון)
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care"],"whole_org":false,"funding":[{"channel":"mod","terms":"eligible"}],"referral":["self_referral"],"referral_source":"ניתן לקיים שיחה אנונימית; הסיוע ללא עלות וללא אישורים או בירוקרטיה"}'::jsonb, updated_at = now()
WHERE card_key = '11|||קו המעניק תמיכה נפשית ראשונית' AND indicators = '{}'::jsonb;

-- I1-012 · row 12 · אגף השיקום, משרד הבטחון
UPDATE directory_card_edits SET indicators = '{"offers":["info"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '12|||זכויות למתמודדים עם פגיעה נפשית' AND indicators = '{}'::jsonb;

-- I1-013 · row 13 · בנפש בריאה - משרד הבריאות
UPDATE directory_card_edits SET indicators = '{"offers":["info","navigate"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '13|||קווי סיוע והכוונה' AND indicators = '{}'::jsonb;

-- I1-014 · row 14 · ביטוח לאומי
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care"],"whole_org":false,"funding":[{"channel":"moh","terms":"eligible"},{"channel":"btl","terms":"eligible"}],"referral":["self_referral"],"referral_source":"קו חירום לנפגעי טרור; רשימת מרכזי החוסן לפי אזור"}'::jsonb, updated_at = now()
WHERE card_key = '14|||רשימת מוקדי הטיפול ומרכזי החוסן' AND indicators = '{}'::jsonb;

-- I1-015 · row 15 · מוקד "קול לכולם" - משרד החינוך
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care"],"whole_org":false,"funding":[{"channel":"edu","terms":""}],"referral":["self_referral"],"referral_source":"ניתן להתקשר ל-6312* או לפתוח פנייה אנונימית בטופס"}'::jsonb, updated_at = now()
WHERE card_key = '15|||מוקד סיוע רגשי-חברתי להורים ולתלמידים' AND indicators = '{}'::jsonb;

-- I1-016 · row 15 · משרד הבריאות, מינהל בריאות הנפש
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '15|||מרכזי תמיכה רגשית ונפשית
' AND indicators = '{}'::jsonb;

-- I1-017 · row 16 · פורטל בריאות הנפש בישראל
UPDATE directory_card_edits SET indicators = '{"offers":["info","navigate"],"whole_org":true,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '16|||שירותים למתמודד
אינדקס מטפלים
פורומים
ועוד ועוד' AND indicators = '{}'::jsonb;

-- I1-018 · row 17 · החלמה - הנגשת מידע למתמודד נפש ומשפחתו
UPDATE directory_card_edits SET indicators = '{"offers":["info"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '17|||' AND indicators = '{}'::jsonb;

-- I1-019 · row 18 · GET HELP Israel
UPDATE directory_card_edits SET indicators = '{"offers":["info","navigate"],"whole_org":true,"funding":[{"channel":"free","terms":""},{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":"האתר חינם; הטיפול אצל המטפלים בתשלום, בפנייה ישירה"}'::jsonb, updated_at = now()
WHERE card_key = '18|||Provides English-speakers with access to verified mental health specialists as well as resources and information on navigating the mental health system in Israel' AND indicators = '{}'::jsonb;

-- I1-020 · row 19 · בטיפולנט
UPDATE directory_card_edits SET indicators = '{"offers":["info","navigate"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '19|||אינדקס שירותים למענה נפשי וטיפול בפוסט-טראומה' AND indicators = '{}'::jsonb;

-- I1-021 · row 20 · עמותת ער"ן (עזרה ראשונה נפשית)
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":"הפנייה אנונימית; השירות לכלל הציבור בכל גיל"}'::jsonb, updated_at = now()
WHERE card_key = '20|||קו סיוע והכוונה' AND indicators = '{}'::jsonb;

-- I1-022 · row 21 · נט"ל (נפגעי טראומה על רקע לאומי)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"קו הסיוע של נט״ל זמין 24/7"}'::jsonb, updated_at = now()
WHERE card_key = '21|||תמיכה נפשית ותעסוקתית לנפגעי טראומה ממלחמה וטרור' AND indicators = '{}'::jsonb;

-- I1-023 · row 21 · רי"ל - הרשת הישראלית לחוסן
UPDATE directory_card_edits SET indicators = '{"offers":["info"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '21|||רשת לאומית לחוסן נפשי המאפשרת יצירת כלים אינטראקטיביים מותאמים לקהלי יעד שונים' AND indicators = '{}'::jsonb;

-- I1-024 · row 22 · סיוע והקשבה ברשת (סהר)
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"צ''אט אנונימי וחינמי; שתפו רק את מה שמתאים לכם"}'::jsonb, updated_at = now()
WHERE card_key = '22|||קו סיוע והכוונה' AND indicators = '{}'::jsonb;

-- I1-025 · row 23 · סיוע והקשבה ברשת (סהר)
UPDATE directory_card_edits SET indicators = '{"offers":["navigate"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '23|||אינדקס שירותים' AND indicators = '{}'::jsonb;

-- I1-026 · row 24 · מטיבת"א (מרכז טיפול יעוץ במשפחה תורני)
UPDATE directory_card_edits SET indicators = '{"offers":["info","navigate","care"],"whole_org":true,"funding":[],"referral":["self_referral"],"referral_source":"לסיוע חייגו *2837; פנייה בטלפון או במוקד"}'::jsonb, updated_at = now()
WHERE card_key = '24|||מוקדי סיוע
מרכז טיפול
ועוד' AND indicators = '{}'::jsonb;

-- I1-027 · row 25 · מוקד CALL לנפש (קואליציית הארגונים הדתיים למען בריאות הנפש)
UPDATE directory_card_edits SET indicators = '{"offers":["care","community"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":"מוקד *8246 לבני משפחה; פנייה גם במייל"}'::jsonb, updated_at = now()
WHERE card_key = '25|||תמיכה ואוזן קשבת לבני משפחה למתמודדי נפש' AND indicators = '{}'::jsonb;

-- I1-028 · row 26 · ידידי נפש (עזר מציון)
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":"אינכם חייבים להזדהות; הקו נותן מענה גם לפניות אנונימיות"}'::jsonb, updated_at = now()
WHERE card_key = '26|||קו ייעוץ ותמיכה - בימים א-ה בשעות 10:00-13:00 ו-16:00-22:00' AND indicators = '{}'::jsonb;

-- I1-029 · row 27 · רגיש לי
UPDATE directory_card_edits SET indicators = '{"offers":["navigate"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '27|||אינדקס שירותים למתמודדי נפש' AND indicators = '{}'::jsonb;

-- I1-030 · row 28 · כללית
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":["gp_referral"],"referral_source":"מסובסד עם המלצה מרופא משפחה"}'::jsonb, updated_at = now()
WHERE card_key = '28|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה' AND indicators = '{}'::jsonb;

-- I1-031 · row 29 · מכבי
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":["self_referral"],"referral_source":"אין צורך בהפניית רופא: פונים למרפאה בטופס מקוון, והצוות חוזר תוך 5 ימי עבודה."}'::jsonb, updated_at = now()
WHERE card_key = '29|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה' AND indicators = '{}'::jsonb;

-- I1-032 · row 30 · מרכזי חוסן
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care"],"whole_org":false,"funding":[{"channel":"free","terms":""},{"channel":"moh","terms":""},{"channel":"btl","terms":""}],"referral":["self_referral"],"referral_source":"השירות הראשוני דרך *5486, ומשם מפנים למרכז החוסן לפי כתובת המגורים."}'::jsonb, updated_at = now()
WHERE card_key = '30|||רשימת מרכזי חוסן ברחבי הארץ' AND indicators = '{}'::jsonb;

-- I1-033 · row 30 · על הספה
UPDATE directory_card_edits SET indicators = '{"offers":["navigate"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '30|||אינדקס מטפלים (כולל פסיכיאטרים)' AND indicators = '{}'::jsonb;

-- I1-034 · row 31 · פסיכולוגיה עברית
UPDATE directory_card_edits SET indicators = '{"offers":["navigate"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '31|||אינדקס מטפלים (כולל פסיכיאטרים)' AND indicators = '{}'::jsonb;

-- I1-035 · row 32 · בטיפולנט
UPDATE directory_card_edits SET indicators = '{"offers":["navigate"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '32|||אינדקס מטפלים (כולל פסיכיאטרים)' AND indicators = '{}'::jsonb;

-- I1-036 · row 33 · MEDREVIEWS
UPDATE directory_card_edits SET indicators = '{"offers":["navigate"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '33|||אינדקס פסיכיאטרים' AND indicators = '{}'::jsonb;

-- I1-037 · row 34 · אינפומד
UPDATE directory_card_edits SET indicators = '{"offers":["navigate"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"supplementary","terms":"partial"},{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '34|||אינדקס פסיכיאטרים' AND indicators = '{}'::jsonb;

-- I1-038 · row 35 · משרד הבריאות
UPDATE directory_card_edits SET indicators = '{"offers":["navigate"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '35|||אינדקס פסיכולוגים מורשים' AND indicators = '{}'::jsonb;

-- I1-039 · row 36 · משרד הבריאות
UPDATE directory_card_edits SET indicators = '{"offers":["navigate"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '36|||אינדקס משרד הבריאות - מהפנטים בעלי רשיון' AND indicators = '{}'::jsonb;

-- I1-040 · row 37 · רקליני - הבית לטיפולים קליניים
UPDATE directory_card_edits SET indicators = '{"offers":["navigate"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '37|||אינדקס מטפלים' AND indicators = '{}'::jsonb;

-- I1-041 · row 38 · בתי חולים פסיכיאטריים ומחלקות פסיכיאטריות בבתי חולים כלליים
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":""}],"referral":["self_referral","gp_referral","psychiatrist_referral"],"referral_source":"ההפניה לחדר מיון ניתנת לרוב על ידי רופא המשפחה או הגורם המטפל בבריאות הנפש, או בהגעה עצמאית."}'::jsonb, updated_at = now()
WHERE card_key = '38|||אשפוז פסיכיאטרי' AND indicators = '{}'::jsonb;

-- I1-042 · row 39 · אגף השיקום, משרד הבטחון
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"free","terms":""},{"channel":"mod","terms":"eligible"}],"referral":["self_referral"],"referral_source":"אפשר להגיע ישירות למיון בבית החולים ללא צורך בהתחייבות (הפניה רפואית) מהאגף."}'::jsonb, updated_at = now()
WHERE card_key = '39|||בית בטוח לטיפול מיידי - חלופת אשפוז' AND indicators = '{}'::jsonb;

-- I1-043 · row 40 · שרן רפואה עד הבית
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '40|||צוות משבר (חלופה לחדר מיון)' AND indicators = '{}'::jsonb;

-- I1-044 · row 41 · שרן רפואה עד הבית
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":"שירות פרטי. פגישה עם פסיכיאטר ב-Zoom תוך 48 שעות ממועד הפנייה."}'::jsonb, updated_at = now()
WHERE card_key = '41|||ייעוץ פסיכיאטרי מקוון' AND indicators = '{}'::jsonb;

-- I1-045 · row 42 · שרן רפואה עד הבית
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"free","terms":""},{"channel":"mod","terms":"eligible"}],"referral":["mod_rehab_worker"],"referral_source":"השירות ניתן ללא תשלום, בהפניה ובאישור האגף."}'::jsonb, updated_at = now()
WHERE card_key = '42|||ייעוץ פסיכיאטרי מקוון' AND indicators = '{}'::jsonb;

-- I1-046 · row 43 · שרן רפואה עד הבית
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"full"},{"channel":"moh","terms":""},{"channel":"private","terms":""}],"referral":["self_referral","gp_referral","hmo_form17","psychiatrist_referral"],"referral_source":"ללא תשלום בהפניה של קופת החולים. פונים לרופא המשפחה, לפסיכיאטר המטפל או לפסיכיאטר בחדר המיון. אם אין אישור, אפשר באופן פרטי."}'::jsonb, updated_at = now()
WHERE card_key = '43|||אשפוז בית פסיכיאטרי' AND indicators = '{}'::jsonb;

-- I1-047 · row 45 · שרן רפואה עד הבית
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":"שירות פרטי"}'::jsonb, updated_at = now()
WHERE card_key = '45|||הקול שבפנים – טיפול ביתי לצעירים במצבי משבר נפשי' AND indicators = '{}'::jsonb;

-- I1-048 · row 46 · שרן רפואה עד הבית
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"full"},{"channel":"private","terms":""}],"referral":["self_referral","gp_referral","hmo_form17","psychiatrist_referral"],"referral_source":"ההפניה ניתנת על ידי רופא משפחה או פסיכיאטר מטפל, ומותנית באישור הקופה. השירות ניתן גם באופן פרטי."}'::jsonb, updated_at = now()
WHERE card_key = '46|||פסיכותרפיה מקוונת' AND indicators = '{}'::jsonb;

-- I1-049 · row 47 · שרן רפואה עד הבית
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"mod","terms":"eligible"}],"referral":["mod_rehab_worker"],"referral_source":"זכאי משרד הבטחון"}'::jsonb, updated_at = now()
WHERE card_key = '47|||פסיכותרפיה מקוונת' AND indicators = '{}'::jsonb;

-- I1-050 · row 48 · צבר רפואה
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":""}],"referral":["psychiatrist_referral"],"referral_source":"לבירור התאמה יש לפנות לגורם המטפל בקהילה או בבית החולים לבריאות הנפש."}'::jsonb, updated_at = now()
WHERE card_key = '48|||אשפוז בית פסיכיאטרי' AND indicators = '{}'::jsonb;

-- I1-051 · row 49 · טל הנפש
UPDATE directory_card_edits SET indicators = '{"offers":["navigate"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '49|||התאגדות המטפלים הדתיים' AND indicators = '{}'::jsonb;

-- I1-052 · row 50 · איט"ה האגודה הישראלית לטיפול קוגניטיבי התנהגותי - CBT
UPDATE directory_card_edits SET indicators = '{"offers":["navigate"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '50|||אינדקס מטפלים' AND indicators = '{}'::jsonb;

-- I1-053 · row 51 · טיפול סומטי Somatic Experiencing
UPDATE directory_card_edits SET indicators = '{"offers":["navigate"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '51|||אינדקס מטפלים' AND indicators = '{}'::jsonb;

-- I1-054 · row 52 · מילם (מרכז ייעוץ למשפחות מתמודדים)
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care","claim","community"],"whole_org":false,"funding":[{"channel":"free","terms":""},{"channel":"moh","terms":""}],"referral":["self_referral"],"referral_source":"צרו איתנו קשר ובואו להכיר."}'::jsonb, updated_at = now()
WHERE card_key = '52|||מרכזי ייעוץ, הכוונה, סיוע והדרכה למשפחות מתמודדים' AND indicators = '{}'::jsonb;

-- I1-055 · row 53 · בתים מאזנים
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":["gp_referral","hmo_form17","psychiatrist_referral"],"referral_source":"ממומן בטופס 17 עם השתתפות עצמית של כמה עשרות שקלים. פונים לצוות המטפל בקופה, או לרופא המשפחה אם לא טופלתם בעבר."}'::jsonb, updated_at = now()
WHERE card_key = '53|||חלופת אשפוז' AND indicators = '{}'::jsonb;

-- I1-056 · row 54 · מתייעצים עם פסיכולוגים ופסיכותרפיסטים
UPDATE directory_card_edits SET indicators = '{"offers":["community"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '54|||קבוצה בפייסבוק' AND indicators = '{}'::jsonb;

-- I1-057 · row 55 · מטפלים וטיפולים
UPDATE directory_card_edits SET indicators = '{"offers":["community"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '55|||קבוצה בפייסבוק' AND indicators = '{}'::jsonb;

-- I1-058 · row 56 · CPTSD - פוסט טראומה מורכבת
UPDATE directory_card_edits SET indicators = '{"offers":["community"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '56|||קבוצה בפייסבוק' AND indicators = '{}'::jsonb;

-- I1-059 · row 57 · מדברים על סל שיקום
UPDATE directory_card_edits SET indicators = '{"offers":["community"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '57|||קבוצה בפייסבוק' AND indicators = '{}'::jsonb;

-- I1-060 · row 58 · ייעוץ פסיכולוגי - שאלות למטפלים פסיכולוגים
UPDATE directory_card_edits SET indicators = '{"offers":["community"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '58|||קבוצה בפייסבוק' AND indicators = '{}'::jsonb;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-16-card-indicators-batch-1',
    DATE '2026-10-16',
    'סימונים בכרטיסים: קבוצה 1',
    'סומנו 60 כרטיסים (שורות 1–58): מה יש בכרטיס, האם זה הכרטיס הכללי של הארגון, מימון ודרך ההפניה.',
    'cards',
    ARRAY[
    '1|||קצבת נכות למתמודדי נפש',
    '2|||שירותים מיוחדים (שר"מ)',
    '3|||קצבת סיעוד',
    '4|||ייעוץ והכנה בחינם לוועדה הרפואית',
    '5|||סל שיקום',
    '6|||שירותי סל שיקום',
    '7|||שירותי סל שיקום',
    '8|||שירותי סל שיקום',
    '9|||שירותי סל שיקום',
    '10|||קבלת סיוע נפשי מיידי',
    '11|||קו המעניק תמיכה נפשית ראשונית',
    '12|||זכויות למתמודדים עם פגיעה נפשית',
    '13|||קווי סיוע והכוונה',
    '14|||רשימת מוקדי הטיפול ומרכזי החוסן',
    '15|||מוקד סיוע רגשי-חברתי להורים ולתלמידים',
    '15|||מרכזי תמיכה רגשית ונפשית
',
    '16|||שירותים למתמודד
אינדקס מטפלים
פורומים
ועוד ועוד',
    '17|||',
    '18|||Provides English-speakers with access to verified mental health specialists as well as resources and information on navigating the mental health system in Israel',
    '19|||אינדקס שירותים למענה נפשי וטיפול בפוסט-טראומה',
    '20|||קו סיוע והכוונה',
    '21|||תמיכה נפשית ותעסוקתית לנפגעי טראומה ממלחמה וטרור',
    '21|||רשת לאומית לחוסן נפשי המאפשרת יצירת כלים אינטראקטיביים מותאמים לקהלי יעד שונים',
    '22|||קו סיוע והכוונה',
    '23|||אינדקס שירותים',
    '24|||מוקדי סיוע
מרכז טיפול
ועוד',
    '25|||תמיכה ואוזן קשבת לבני משפחה למתמודדי נפש',
    '26|||קו ייעוץ ותמיכה - בימים א-ה בשעות 10:00-13:00 ו-16:00-22:00',
    '27|||אינדקס שירותים למתמודדי נפש',
    '28|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה',
    '29|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה',
    '30|||רשימת מרכזי חוסן ברחבי הארץ',
    '30|||אינדקס מטפלים (כולל פסיכיאטרים)',
    '31|||אינדקס מטפלים (כולל פסיכיאטרים)',
    '32|||אינדקס מטפלים (כולל פסיכיאטרים)',
    '33|||אינדקס פסיכיאטרים',
    '34|||אינדקס פסיכיאטרים',
    '35|||אינדקס פסיכולוגים מורשים',
    '36|||אינדקס משרד הבריאות - מהפנטים בעלי רשיון',
    '37|||אינדקס מטפלים',
    '38|||אשפוז פסיכיאטרי',
    '39|||בית בטוח לטיפול מיידי - חלופת אשפוז',
    '40|||צוות משבר (חלופה לחדר מיון)',
    '41|||ייעוץ פסיכיאטרי מקוון',
    '42|||ייעוץ פסיכיאטרי מקוון',
    '43|||אשפוז בית פסיכיאטרי',
    '45|||הקול שבפנים – טיפול ביתי לצעירים במצבי משבר נפשי',
    '46|||פסיכותרפיה מקוונת',
    '47|||פסיכותרפיה מקוונת',
    '48|||אשפוז בית פסיכיאטרי',
    '49|||התאגדות המטפלים הדתיים',
    '50|||אינדקס מטפלים',
    '51|||אינדקס מטפלים',
    '52|||מרכזי ייעוץ, הכוונה, סיוע והדרכה למשפחות מתמודדים',
    '53|||חלופת אשפוז',
    '54|||קבוצה בפייסבוק',
    '55|||קבוצה בפייסבוק',
    '56|||קבוצה בפייסבוק',
    '57|||קבוצה בפייסבוק',
    '58|||קבוצה בפייסבוק'
    ],
    '{}',
    '079_card_indicators_b1.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
