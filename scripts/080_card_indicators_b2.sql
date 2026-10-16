-- Migration 080 (16 Oct 2026)
-- Card indicators, batch 2: values approved by the site owner, from docs/card-indicators-2026-10.md.
-- Only cards whose indicators are still empty are filled, so an admin edit is never overwritten.
-- Requires migration 077. Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- I2-061 · row 59 · זה מגיע לכם - ד"ר גילי תמיר
UPDATE directory_card_edits SET indicators = '{"offers":["info"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '59|||מיצוי זכויות' AND indicators = '{}'::jsonb;

-- I2-062 · row 60 · עמותת בית חם
UPDATE directory_card_edits SET indicators = '{"offers":["info","care","claim","community"],"whole_org":true,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":"eligible"}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '60|||מידע, ייעוץ ותמיכה
מרכזי טיפול
מרכזי שיקום' AND indicators = '{}'::jsonb;
INSERT INTO card_org_links (org_card_key, member_card_key, sort_order)
SELECT o.card_key, m.card_key, 0 FROM directory_card_edits o, directory_card_edits m
WHERE o.card_key = '60|||מידע, ייעוץ ותמיכה
מרכזי טיפול
מרכזי שיקום' AND m.card_key = '61|||מידע, ייעוץ ותמיכה'
ON CONFLICT (org_card_key, member_card_key) DO NOTHING;
INSERT INTO card_org_links (org_card_key, member_card_key, sort_order)
SELECT o.card_key, m.card_key, 1 FROM directory_card_edits o, directory_card_edits m
WHERE o.card_key = '60|||מידע, ייעוץ ותמיכה
מרכזי טיפול
מרכזי שיקום' AND m.card_key = '62|||מרפאות לבריאות הנפש
'
ON CONFLICT (org_card_key, member_card_key) DO NOTHING;

-- I2-063 · row 61 · עמותת בית חם
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '61|||מידע, ייעוץ ותמיכה' AND indicators = '{}'::jsonb;

-- I2-064 · row 62 · עמותת בית חם
UPDATE directory_card_edits SET indicators = '{"offers":["care","claim"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '62|||מרפאות לבריאות הנפש
' AND indicators = '{}'::jsonb;

-- I2-065 · row 63 · הדספייס
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"free","terms":""},{"channel":"hmo","terms":"full"},{"channel":"moh","terms":""}],"referral":["self_referral","hmo_form17"],"referral_source":"השירותים ניתנים ללא תשלום ישיר או באמצעות התחייבות מקופות החולים. לא צריך טפסים או הפניה."}'::jsonb, updated_at = now()
WHERE card_key = '63|||תמיכה לנוער וצעירים' AND indicators = '{}'::jsonb;

-- I2-066 · row 64 · נוער הקואליציה (קואליציית הארגונים הדתיים למען בריאות הנפש)
UPDATE directory_card_edits SET indicators = '{"offers":["community"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '64|||קבוצה חברתית לנערים ונערות מתמודדי ומתמודדות נפש דתיים ודתלשים' AND indicators = '{}'::jsonb;

-- I2-067 · row 65 · מכון למרחב (מרכז טיפולי רב תחומי)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"full"},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '65|||מענה מקצועי מותאם תרבות בתחום בריאות הנפש לאוכלוסיה הדתית - חרדית.' AND indicators = '{}'::jsonb;

-- I2-068 · row 66 · מרכז יה״ל - ייעוץ והכוונה למשפחות
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care","claim","community"],"whole_org":false,"funding":[{"channel":"moh","terms":"full"}],"referral":["self_referral"],"referral_source":"קבלת השירות אינה כרוכה בתשלום ו/או בהפניה מגורם רפואי או אחר."}'::jsonb, updated_at = now()
WHERE card_key = '66|||ייעוץ והכוונה למשפחות בתחום בריאות הנפש · 18:00 - 22:00' AND indicators = '{}'::jsonb;

-- I2-069 · row 67 · איכות בשיקום
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care","claim"],"whole_org":false,"funding":[{"channel":"moh","terms":"eligible"},{"channel":"mod","terms":"eligible"},{"channel":"private","terms":""}],"referral":["rehab_basket_committee","mod_rehab_worker"],"referral_source":"לזכאי סל שיקום או בהפניה ממשרד הביטחון. אישור סל שיקום לתעסוקה נתמכת, הפניה ממשרד הביטחון, או באופן פרטי."}'::jsonb, updated_at = now()
WHERE card_key = '67|||סיוע למתמודדי נפש דרך שילובם בקהילה תוך ליווי מקצועי אישי' AND indicators = '{}'::jsonb;

-- I2-070 · row 68 · בלב ובנפש (עזר מציון)
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","claim"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '68|||סיוע למשפחות של מתמודדי נפש' AND indicators = '{}'::jsonb;

-- I2-071 · row 69 · דיאלוג פתוח בישראל (דפ"י)
UPDATE directory_card_edits SET indicators = '{"offers":["info","navigate"],"whole_org":false,"funding":[{"channel":"moh","terms":"full"},{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":"לצורך פנייה לשירות יש למלא טופס הפנייה ולשלוח אותו לכתובת המייל המופיעה בו"}'::jsonb, updated_at = now()
WHERE card_key = '69|||טיפול משפחתי-מערכתי למצבי משבר' AND indicators = '{}'::jsonb;

-- I2-072 · row 70 · עמך - המרכז הישראלי לתמיכה נפשית וחברתית בניצולי השואה והדור השני
UPDATE directory_card_edits SET indicators = '{"offers":["care","community"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '70|||תמיכה נפשית וחברתית בניצולי השואה והדור השני ' AND indicators = '{}'::jsonb;

-- I2-073 · row 71 · עמותת לשמה
UPDATE directory_card_edits SET indicators = '{"offers":["community"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '71|||לשילוב מתמודדים והעצמה בבריאות הנפש' AND indicators = '{}'::jsonb;

-- I2-074 · row 72 · זה בנפשי
UPDATE directory_card_edits SET indicators = '{"offers":["info","community"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '72|||תמיכה בילדים ונוער המטופלים במרכזי בריאות הנפש' AND indicators = '{}'::jsonb;

-- I2-075 · row 73 · מכון צוהר
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '73|||נתיבי שיקום והחלמה' AND indicators = '{}'::jsonb;

-- I2-076 · row 74 · חברת נתן
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"moh","terms":"eligible"},{"channel":"mod","terms":"eligible"},{"channel":"private","terms":""}],"referral":["rehab_basket_committee","mod_rehab_worker","self_referral"],"referral_source":"ניתן לפנות אלינו: במסגרת סל שיקום - משרד הבריאות; במסגרת אגף השיקום – משרד הבטחון; באופן פרטי (בתקופת תהליך ההכרה לזכאות או באופן קבוע)"}'::jsonb, updated_at = now()
WHERE card_key = '74|||שיקום ובריאות הנפש' AND indicators = '{}'::jsonb;

-- I2-077 · row 76 · Avnei Chein
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '76|||Crisis Support, Family Support, Family & Sibling Therapy, Legal Support, Mentors and Volunteers, Network of Professionals' AND indicators = '{}'::jsonb;

-- I2-078 · row 77 · Avnei Chein
UPDATE directory_card_edits SET indicators = '{"offers":["info"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '77|||Israel''s Emergency Mental Health Resources During War - Comprehensive list of mental health resources' AND indicators = '{}'::jsonb;

-- I2-079 · row 78 · המרכז הירושלמי לבריאות הנפש (כפר שאול-איתנים)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":true,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":""},{"channel":"mod","terms":"eligible"}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '78|||המרכז מעניק רצף טיפולי למגוון הפרעות הנפש, בכל הגילאים, למצבים פסיכוטיים חריפים, מצבים ממושכים עם דגש שיקומי ושירות קהילתי. מערך הטיפול כולל את כל סוגי הטיפולים הביולוגיים המקובלים (תרופות חדישות לסוגיהן, חדר סנוסלן – גרייה רב חושית ונזעי חשמל), טיפול זוגי ומשפחתי, פסיכותראפיה פרטנית וקבוצתית, טיפול באומנות וריפוי בעיסוק.' AND indicators = '{}'::jsonb;
INSERT INTO card_org_links (org_card_key, member_card_key, sort_order)
SELECT o.card_key, m.card_key, 0 FROM directory_card_edits o, directory_card_edits m
WHERE o.card_key = '78|||המרכז מעניק רצף טיפולי למגוון הפרעות הנפש, בכל הגילאים, למצבים פסיכוטיים חריפים, מצבים ממושכים עם דגש שיקומי ושירות קהילתי. מערך הטיפול כולל את כל סוגי הטיפולים הביולוגיים המקובלים (תרופות חדישות לסוגיהן, חדר סנוסלן – גרייה רב חושית ונזעי חשמל), טיפול זוגי ומשפחתי, פסיכותראפיה פרטנית וקבוצתית, טיפול באומנות וריפוי בעיסוק.' AND m.card_key = '297|||טיפול יום אינטנסיבי למבוגרים — מניעת אשפוז מלא'
ON CONFLICT (org_card_key, member_card_key) DO NOTHING;
INSERT INTO card_org_links (org_card_key, member_card_key, sort_order)
SELECT o.card_key, m.card_key, 1 FROM directory_card_edits o, directory_card_edits m
WHERE o.card_key = '78|||המרכז מעניק רצף טיפולי למגוון הפרעות הנפש, בכל הגילאים, למצבים פסיכוטיים חריפים, מצבים ממושכים עם דגש שיקומי ושירות קהילתי. מערך הטיפול כולל את כל סוגי הטיפולים הביולוגיים המקובלים (תרופות חדישות לסוגיהן, חדר סנוסלן – גרייה רב חושית ונזעי חשמל), טיפול זוגי ומשפחתי, פסיכותראפיה פרטנית וקבוצתית, טיפול באומנות וריפוי בעיסוק.' AND m.card_key = '309|||אשפוז יום אחרי אשפוז מלא — הדרך שלך חזרה לקהילה'
ON CONFLICT (org_card_key, member_card_key) DO NOTHING;
INSERT INTO card_org_links (org_card_key, member_card_key, sort_order)
SELECT o.card_key, m.card_key, 2 FROM directory_card_edits o, directory_card_edits m
WHERE o.card_key = '78|||המרכז מעניק רצף טיפולי למגוון הפרעות הנפש, בכל הגילאים, למצבים פסיכוטיים חריפים, מצבים ממושכים עם דגש שיקומי ושירות קהילתי. מערך הטיפול כולל את כל סוגי הטיפולים הביולוגיים המקובלים (תרופות חדישות לסוגיהן, חדר סנוסלן – גרייה רב חושית ונזעי חשמל), טיפול זוגי ומשפחתי, פסיכותראפיה פרטנית וקבוצתית, טיפול באומנות וריפוי בעיסוק.' AND m.card_key = '310|||טיפול יום לנשים עם טראומה מורכבת אחרי פגיעה מינית'
ON CONFLICT (org_card_key, member_card_key) DO NOTHING;

-- I2-080 · row 79 · שרן רפואה עד הבית
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '79|||תוכנית טיפול ביתי ממושך למתמודדים עם מחלת נפש חמורה' AND indicators = '{}'::jsonb;

-- I2-081 · row 80 · מאוחדת
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":["self_referral"],"referral_source":"אין צורך בהפניית רופא: קובעים פגישת מיון במוקד *3833."}'::jsonb, updated_at = now()
WHERE card_key = '80|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה' AND indicators = '{}'::jsonb;

-- I2-082 · row 80 · Amudim
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '80|||Clinical case management for English-speakers in Israel from all walks of life: counseling, referrals to therapists, treatment programs, guidance through the legal process' AND indicators = '{}'::jsonb;

-- I2-083 · row 81 · לאומית
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":""}],"referral":["gp_referral","self_referral"],"referral_source":"אפשר בהפניית רופא, או בפנייה ישירה: מי שלא היה בטיפול בחצי השנה האחרונה קובע תור לתומך בריאות הנפש ב-*507."}'::jsonb, updated_at = now()
WHERE card_key = '81|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה' AND indicators = '{}'::jsonb;

-- I2-084 · row 81 · Relief Resources
UPDATE directory_card_edits SET indicators = '{"offers":["navigate"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '81|||Help finding qualified mental health providers for English-speakers' AND indicators = '{}'::jsonb;

-- I2-085 · row 82 · כל זכות
UPDATE directory_card_edits SET indicators = '{"offers":["info"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '82|||קביעת נכות למתמודדי נפש' AND indicators = '{}'::jsonb;

-- I2-086 · row 83 · כל זכות
UPDATE directory_card_edits SET indicators = '{"offers":["info"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '83|||קצבת שירותים מיוחדים למתמודדי נפש' AND indicators = '{}'::jsonb;

-- I2-087 · row 83 · עזר מציון הסעות
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '83|||הסעות חולים, אמבולנסים לצרכים רפואיים ואירועים משפחתיים, נהגים מתנדבים' AND indicators = '{}'::jsonb;

-- I2-088 · row 84 · כל זכות
UPDATE directory_card_edits SET indicators = '{"offers":["info"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '84|||סל שיקום למתמודדי נפש' AND indicators = '{}'::jsonb;

-- I2-089 · row 84 · לב מלכה
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '84|||סיוע באמבולנסים בהעברת חולים ונכים' AND indicators = '{}'::jsonb;

-- I2-090 · row 85 · כל זכות
UPDATE directory_card_edits SET indicators = '{"offers":["info"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '85|||מדריך מיצוי זכויות למתמודדי נפש ובני משפחותיהם' AND indicators = '{}'::jsonb;

-- I2-091 · row 86 · המלצות ואזהרות על פסיכיאטרים, מטפלים ושירותי בריאות הנפש
UPDATE directory_card_edits SET indicators = '{"offers":["community"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '86|||קבוצה בפייסבוק' AND indicators = '{}'::jsonb;

-- I2-092 · row 87 · ענת אופיר מטיאש
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"supplementary","terms":"partial"},{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '87|||מומחית בהפרעות אכילה/תזונה/כושר/דיאטה, מטפלת בפגועי נפש עם רישיון. בעלות סימלית, חברות ביטוח מחזירות' AND indicators = '{}'::jsonb;

-- I2-093 · row 88 · אימפולס - מרכז קליני אינטגרטיבי
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care"],"whole_org":false,"funding":[{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '88|||מרכז לפסיכותרפיה אינטגרטיבית. תמיכה נפשית, רגשית ורוחנית דרך מגוון רחב של גישות ועל ידי אנשי מקצוע מוסמכים' AND indicators = '{}'::jsonb;

-- I2-094 · row 90 · ME-MENTAL EXPERTS
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '90|||מרכזים לטיפול רגשי' AND indicators = '{}'::jsonb;

-- I2-095 · row 91 · Hakshiva Therapy Clinic - הקשיבה
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '91|||Therapy for teenagers, couples therapy and parenting guidance' AND indicators = '{}'::jsonb;

-- I2-096 · row 92 · חבלי קשר - Hevlei Kesher
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '92|||דיכאון אחרי לידה ועוד, דרך טיפת חלב בירושלים
Support and treatment for Maternal Mental Health through Tipat Halav. Services for mothers and families impacted by perinatal mental health disorders (PMHD) such as postpartum depression' AND indicators = '{}'::jsonb;

-- I2-097 · row 93 · Modi'in Behavioral
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"private","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '93|||CBT, DBT, and Exposure-Based Therapies' AND indicators = '{}'::jsonb;

-- I2-098 · row 94 · המרכז הישראלי להתמכרויות ובריאות הנפש (ICA)
UPDATE directory_card_edits SET indicators = '{"offers":["info","navigate","care"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '94|||מרכז לאומי מוביל לצמצום תופעת ההתמכרויות ונזקיה. טיפול, מידע והכוונה למי שמתמודד עם התמכרות' AND indicators = '{}'::jsonb;

-- I2-099 · row 95 · מרכז גמילה - המרכז ההוליסטי "אחרת"
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '95|||מרכז גמילה הוליסטי לטיפול בהתמכרויות (סמים, אלכוהול, הימורים ועוד) המבוסס על 12 הצעדים וגישות טיפוליות נוספות' AND indicators = '{}'::jsonb;

-- I2-100 · row 96 · חיים של טובה
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care"],"whole_org":false,"funding":[{"channel":"private","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '96|||הכוונה לטיפול הפסיכולוגי המתאים לכם וסבסוד טיפולים' AND indicators = '{}'::jsonb;

-- I2-101 · row 96 · חיים של טובה
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care"],"whole_org":false,"funding":[{"channel":"private","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '96|||הכוונה לטיפול הפסיכולוגי המתאים וסבסוד טיפולים פסיכולוגיים' AND indicators = '{}'::jsonb;

-- I2-102 · row 96 · חיים של טובה
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care"],"whole_org":false,"funding":[{"channel":"private","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '96|||הכוונה לטיפול הפסיכולוגי המתאים לכם, סבסוד טיפולים, חוסן משפחתי. שינוי מפת ההתמודדות המשפחתית והקהילתית במצבי מצוקה אישיים ומשפחתיים.' AND indicators = '{}'::jsonb;

-- I2-103 · row 101 · אפליקציית Rescue
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '101|||אפליקציה חינמית המספקת עזרה ראשונה נפשית ותמיכה מיידית בזמן התקף חרדה, ומלווה את המשתמש עד חזרה הדרגתית לשגרה.' AND indicators = '{}'::jsonb;

-- I2-104 · row 102 · Kav L'Noar (Merchav L'Noar)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"supplementary","terms":"partial"},{"channel":"edu","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '102|||Therapy clinic for teenagers & young adults (11-27) and parents; specializes in Anglo olim; Halachik framework; therapy for individuals, couples and families' AND indicators = '{}'::jsonb;

-- I2-105 · row 102 · VIVID - The Flexible App for Life-Changing Practices
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '102|||אפליקציה אינטראקטיבית לבניית תוכניות תרגול יומי ומעקב לאורך זמן.' AND indicators = '{}'::jsonb;

-- I2-106 · row 103 · המדריך ל-PTSD
UPDATE directory_card_edits SET indicators = '{"offers":["info","care"],"whole_org":false,"funding":[{"channel":"mod","terms":"full"}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '103|||אפליקציה/מדריך דיגיטלי להתמודדות עם PTSD, מטעם אגף השיקום (משרד הביטחון).' AND indicators = '{}'::jsonb;

-- I2-107 · row 104 · מיינדמי (MindMe)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '104|||מרכז פסיכיאטרי וטיפול רגשי: פסיכותרפיה, טיפול קוגניטיבי-התנהגותי (CBT), טיפול זוגי ומשפחתי, פסיכיאטריה ומתן תרופות, EMDR/DBT/NLP, חרדה, דיכאון, טראומה, התמכרויות ועוד' AND indicators = '{}'::jsonb;

-- I2-108 · row 105 · (BrainsWay) TMS - גרייה מגנטית מוחית
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"eligible"},{"channel":"moh","terms":"eligible"},{"channel":"mod","terms":"eligible"},{"channel":"private","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '105|||טיפולי גרייה מוחית (TMS ו-Deep TMS) למגוון מצבים נפשיים ונוירולוגיים. דיכאון מג''ורי בסל לפי תנאים; שיפוי אגף השיקום ל-PTSD בחלק מבתי החולים הציבוריים.' AND indicators = '{}'::jsonb;

-- I2-109 · row 106 · Psychedelic Treatment & Therapy
UPDATE directory_card_edits SET indicators = '{"offers":["info","navigate"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '106|||Access center for psychedelic treatment and therapy.' AND indicators = '{}'::jsonb;

-- I2-110 · row 107 · טיפול פסיכדלי
UPDATE directory_card_edits SET indicators = '{"offers":["info","navigate"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '107|||טיפול פסיכדלי ומידע מקצועי בתחום.' AND indicators = '{}'::jsonb;

-- I2-111 · row 108 · (איכילוב) TMS - גרייה מגנטית מוחית
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"mod","terms":"eligible"},{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":"ניתן לפנות לקבלת טיפול באמצעות מילוי טופס הפנייה המקוון."}'::jsonb, updated_at = now()
WHERE card_key = '108|||טיפול בגרייה מגנטית מוחית (TMS) במרפאה לטיפולים מתקדמים. באותה יחידה גם ECT, אסקטמין ונוירופידבק.' AND indicators = '{}'::jsonb;

-- I2-112 · row 109 · ECT (נזעי חשמל)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":""}],"referral":["psychiatrist_referral"],"referral_source":"הפניה פסיכיאטרית; מימון דרך הקופה והמרכז המטפל."}'::jsonb, updated_at = now()
WHERE card_key = '109|||טיפול ביולוגי תחת הרדמה קצרה במצבים נפשיים חמורים — בעיקר דיכאון קשה, קטטוניה ומצבים דחופים. ניתן בסדרה בבתי חולים פסיכיאטריים ובחטיבות פסיכיאטריות (למשל איכילוב, שלוותה, כפר שאול).' AND indicators = '{}'::jsonb;

-- I2-113 · row 200 · איגוד מרכזי הסיוע לנפגעות ולנפגעי תקיפה מינית
UPDATE directory_card_edits SET indicators = '{"offers":["info","care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '200|||קווי המענה הארציים של ארגון הגג למרכזי הסיוע' AND indicators = '{}'::jsonb;

-- I2-114 · row 201 · תאיר – מרכז הסיוע לנפגעות ולנפגעי תקיפה מינית
UPDATE directory_card_edits SET indicators = '{"offers":["care","community"],"whole_org":false,"funding":[{"channel":"free","terms":""},{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '201|||סיוע וליווי, חינוך ומניעה, קבוצות תמיכה (פרונטלי וזום)' AND indicators = '{}'::jsonb;

-- I2-115 · row 202 · הקואליציה הישראלית לטראומה
UPDATE directory_card_edits SET indicators = '{"offers":["info","care"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '202|||מידע, הכשרות, מוקדי חוסן ושותפות ארצית בטראומה וחוסן (Israel Trauma Coalition)' AND indicators = '{}'::jsonb;

-- I2-116 · row 203 · תלמ
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '203|||רשת ארצית לטיפול פסיכולוגי, אבחון והכשרה — כולל טיפול בטראומה ובמצוקה נפשית.' AND indicators = '{}'::jsonb;

-- I2-117 · row 204 · אדווה ליזר
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '204|||נטורופתיה קלינית — איזון גוף–נפש (כאבים, עייפות, סטרס, עיכול, אכילה רגשית ועוד); קליניקה ומפגשים מקוונים.' AND indicators = '{}'::jsonb;

-- I2-118 · row 205 · רזולוציה
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '205|||יישומים פסיכולוגיים ממוקדים — הערכה ראשונית והתאמת טיפול (פגישות בקליניקה או זום).' AND indicators = '{}'::jsonb;

-- I2-119 · row 206 · מרכז נשימה
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"private","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '206|||מודל נשימה — טיפול מסובסד, רשת מטפלים לטראומה מורכבת וגישת גוף–נפש קהילתית.' AND indicators = '{}'::jsonb;

-- I2-120 · row 207 · משפחות בריאות הנפש
UPDATE directory_card_edits SET indicators = '{"offers":["info","community"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '207|||עמותת בני ובנות משפחה של מתמודדי/ות נפש בישראל. מטרת העמותה היא לפעול למען המתמודדים ולמען משפחותיהם למימוש ולהרחבת זכויות, לטיפול מיטבי, להכלה ולשיקום בקהילה ולהסברה בקרב מקבלי החלטות, בקרב הממסד ובקרב הציבור.' AND indicators = '{}'::jsonb;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-16-card-indicators-batch-2',
    DATE '2026-10-16',
    'סימונים בכרטיסים: קבוצה 2',
    'סומנו 60 כרטיסים (שורות 59–109 ו־200–207): מה יש בכרטיס, האם זה הכרטיס הכללי של הארגון, מימון ודרך ההפניה.',
    'cards',
    ARRAY[
    '59|||מיצוי זכויות',
    '60|||מידע, ייעוץ ותמיכה
מרכזי טיפול
מרכזי שיקום',
    '61|||מידע, ייעוץ ותמיכה',
    '62|||מרפאות לבריאות הנפש
',
    '63|||תמיכה לנוער וצעירים',
    '64|||קבוצה חברתית לנערים ונערות מתמודדי ומתמודדות נפש דתיים ודתלשים',
    '65|||מענה מקצועי מותאם תרבות בתחום בריאות הנפש לאוכלוסיה הדתית - חרדית.',
    '66|||ייעוץ והכוונה למשפחות בתחום בריאות הנפש · 18:00 - 22:00',
    '67|||סיוע למתמודדי נפש דרך שילובם בקהילה תוך ליווי מקצועי אישי',
    '68|||סיוע למשפחות של מתמודדי נפש',
    '69|||טיפול משפחתי-מערכתי למצבי משבר',
    '70|||תמיכה נפשית וחברתית בניצולי השואה והדור השני ',
    '71|||לשילוב מתמודדים והעצמה בבריאות הנפש',
    '72|||תמיכה בילדים ונוער המטופלים במרכזי בריאות הנפש',
    '73|||נתיבי שיקום והחלמה',
    '74|||שיקום ובריאות הנפש',
    '76|||Crisis Support, Family Support, Family & Sibling Therapy, Legal Support, Mentors and Volunteers, Network of Professionals',
    '77|||Israel''s Emergency Mental Health Resources During War - Comprehensive list of mental health resources',
    '78|||המרכז מעניק רצף טיפולי למגוון הפרעות הנפש, בכל הגילאים, למצבים פסיכוטיים חריפים, מצבים ממושכים עם דגש שיקומי ושירות קהילתי. מערך הטיפול כולל את כל סוגי הטיפולים הביולוגיים המקובלים (תרופות חדישות לסוגיהן, חדר סנוסלן – גרייה רב חושית ונזעי חשמל), טיפול זוגי ומשפחתי, פסיכותראפיה פרטנית וקבוצתית, טיפול באומנות וריפוי בעיסוק.',
    '79|||תוכנית טיפול ביתי ממושך למתמודדים עם מחלת נפש חמורה',
    '80|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה',
    '80|||Clinical case management for English-speakers in Israel from all walks of life: counseling, referrals to therapists, treatment programs, guidance through the legal process',
    '81|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה',
    '81|||Help finding qualified mental health providers for English-speakers',
    '82|||קביעת נכות למתמודדי נפש',
    '83|||קצבת שירותים מיוחדים למתמודדי נפש',
    '83|||הסעות חולים, אמבולנסים לצרכים רפואיים ואירועים משפחתיים, נהגים מתנדבים',
    '84|||סל שיקום למתמודדי נפש',
    '84|||סיוע באמבולנסים בהעברת חולים ונכים',
    '85|||מדריך מיצוי זכויות למתמודדי נפש ובני משפחותיהם',
    '86|||קבוצה בפייסבוק',
    '87|||מומחית בהפרעות אכילה/תזונה/כושר/דיאטה, מטפלת בפגועי נפש עם רישיון. בעלות סימלית, חברות ביטוח מחזירות',
    '88|||מרכז לפסיכותרפיה אינטגרטיבית. תמיכה נפשית, רגשית ורוחנית דרך מגוון רחב של גישות ועל ידי אנשי מקצוע מוסמכים',
    '90|||מרכזים לטיפול רגשי',
    '91|||Therapy for teenagers, couples therapy and parenting guidance',
    '92|||דיכאון אחרי לידה ועוד, דרך טיפת חלב בירושלים
Support and treatment for Maternal Mental Health through Tipat Halav. Services for mothers and families impacted by perinatal mental health disorders (PMHD) such as postpartum depression',
    '93|||CBT, DBT, and Exposure-Based Therapies',
    '94|||מרכז לאומי מוביל לצמצום תופעת ההתמכרויות ונזקיה. טיפול, מידע והכוונה למי שמתמודד עם התמכרות',
    '95|||מרכז גמילה הוליסטי לטיפול בהתמכרויות (סמים, אלכוהול, הימורים ועוד) המבוסס על 12 הצעדים וגישות טיפוליות נוספות',
    '96|||הכוונה לטיפול הפסיכולוגי המתאים לכם וסבסוד טיפולים',
    '96|||הכוונה לטיפול הפסיכולוגי המתאים וסבסוד טיפולים פסיכולוגיים',
    '96|||הכוונה לטיפול הפסיכולוגי המתאים לכם, סבסוד טיפולים, חוסן משפחתי. שינוי מפת ההתמודדות המשפחתית והקהילתית במצבי מצוקה אישיים ומשפחתיים.',
    '101|||אפליקציה חינמית המספקת עזרה ראשונה נפשית ותמיכה מיידית בזמן התקף חרדה, ומלווה את המשתמש עד חזרה הדרגתית לשגרה.',
    '102|||Therapy clinic for teenagers & young adults (11-27) and parents; specializes in Anglo olim; Halachik framework; therapy for individuals, couples and families',
    '102|||אפליקציה אינטראקטיבית לבניית תוכניות תרגול יומי ומעקב לאורך זמן.',
    '103|||אפליקציה/מדריך דיגיטלי להתמודדות עם PTSD, מטעם אגף השיקום (משרד הביטחון).',
    '104|||מרכז פסיכיאטרי וטיפול רגשי: פסיכותרפיה, טיפול קוגניטיבי-התנהגותי (CBT), טיפול זוגי ומשפחתי, פסיכיאטריה ומתן תרופות, EMDR/DBT/NLP, חרדה, דיכאון, טראומה, התמכרויות ועוד',
    '105|||טיפולי גרייה מוחית (TMS ו-Deep TMS) למגוון מצבים נפשיים ונוירולוגיים. דיכאון מג''ורי בסל לפי תנאים; שיפוי אגף השיקום ל-PTSD בחלק מבתי החולים הציבוריים.',
    '106|||Access center for psychedelic treatment and therapy.',
    '107|||טיפול פסיכדלי ומידע מקצועי בתחום.',
    '108|||טיפול בגרייה מגנטית מוחית (TMS) במרפאה לטיפולים מתקדמים. באותה יחידה גם ECT, אסקטמין ונוירופידבק.',
    '109|||טיפול ביולוגי תחת הרדמה קצרה במצבים נפשיים חמורים — בעיקר דיכאון קשה, קטטוניה ומצבים דחופים. ניתן בסדרה בבתי חולים פסיכיאטריים ובחטיבות פסיכיאטריות (למשל איכילוב, שלוותה, כפר שאול).',
    '200|||קווי המענה הארציים של ארגון הגג למרכזי הסיוע',
    '201|||סיוע וליווי, חינוך ומניעה, קבוצות תמיכה (פרונטלי וזום)',
    '202|||מידע, הכשרות, מוקדי חוסן ושותפות ארצית בטראומה וחוסן (Israel Trauma Coalition)',
    '203|||רשת ארצית לטיפול פסיכולוגי, אבחון והכשרה — כולל טיפול בטראומה ובמצוקה נפשית.',
    '204|||נטורופתיה קלינית — איזון גוף–נפש (כאבים, עייפות, סטרס, עיכול, אכילה רגשית ועוד); קליניקה ומפגשים מקוונים.',
    '205|||יישומים פסיכולוגיים ממוקדים — הערכה ראשונית והתאמת טיפול (פגישות בקליניקה או זום).',
    '206|||מודל נשימה — טיפול מסובסד, רשת מטפלים לטראומה מורכבת וגישת גוף–נפש קהילתית.',
    '207|||עמותת בני ובנות משפחה של מתמודדי/ות נפש בישראל. מטרת העמותה היא לפעול למען המתמודדים ולמען משפחותיהם למימוש ולהרחבת זכויות, לטיפול מיטבי, להכלה ולשיקום בקהילה ולהסברה בקרב מקבלי החלטות, בקרב הממסד ובקרב הציבור.'
    ],
    '{}',
    '080_card_indicators_b2.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
