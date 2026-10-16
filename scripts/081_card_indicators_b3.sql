-- Migration 081 (16 Oct 2026)
-- Card indicators, batch 3: values approved by the site owner, from docs/card-indicators-2026-10.md.
-- Only cards whose indicators are still empty are filled, so an admin edit is never overwritten.
-- Requires migration 077. Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- I3-121 · row 208 · ענת רוסמן
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '208|||מנחה ומלווה משפחות למתמודדי נפש' AND indicators = '{}'::jsonb;

-- I3-122 · row 210 · מטיב (המרכז הישראלי לפסיכוטראומה)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"מוזמנים לפנות, להעביר ולהפנות: shir@metiv.org, ווטסאפ: 02-5952240"}'::jsonb, updated_at = now()
WHERE card_key = '210|||טיפול ארצי ללא עלות לטווח ארוך בטראומה' AND indicators = '{}'::jsonb;

-- I3-123 · row 211 · רטורנו — חוות חוסן
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"mod","terms":"eligible"}],"referral":["self_referral"],"referral_source":"בסבסוד מלא של אגף השיקום מטעם משרד הבטחון למתאימים. השאר/י פרטים ונחזור אליכם"}'::jsonb, updated_at = now()
WHERE card_key = '211|||טיפול, ליווי ושיקום לפוסט-טראומה (בהכרה או לאחר אבחון) — חוות במושב שמש' AND indicators = '{}'::jsonb;

-- I3-124 · row 212 · עמ"ך
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"מוזמנים לפנות לסניפים שלנו"}'::jsonb, updated_at = now()
WHERE card_key = '212|||טיפוליים מפגשים ללא עלות בצפון (פרונטלי או מקוון)' AND indicators = '{}'::jsonb;

-- I3-125 · row 213 · מבצע הקשב
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":"למידע נוסף ופנייה: https://www.hakshev.com/"}'::jsonb, updated_at = now()
WHERE card_key = '213|||עזרה ראשונה נפשית לנפגעי חרבות ברזל — עד 10 מפגשים' AND indicators = '{}'::jsonb;

-- I3-126 · row 214 · היחידה לתגובות קרב (אגף השיקום, משרד הביטחון)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"mod","terms":"full"}],"referral":["self_referral"],"referral_source":"הטיפול ניתן ללא תשלום, ללא צורך בהכרה בנכות או בהוכחה כלשהי. ניתן לפנות אלינו תמיד"}'::jsonb, updated_at = now()
WHERE card_key = '214|||סיוע נפשי לחיילים ומילואים' AND indicators = '{}'::jsonb;

-- I3-127 · row 215 · מכון הקבע
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"מהשנה השלישית בקבע: הפניה מתבצעת באופן עצמאי ודיסקרטי; בשנתיים הראשונות דרך קב\"ן היחידה"}'::jsonb, updated_at = now()
WHERE card_key = '215|||סיוע נפשי ללא עלות לאנשי קבע ומשפחותיהם' AND indicators = '{}'::jsonb;

-- I3-128 · row 217 · מרכז לטראומה וחוסן — אוניברסיטת ת"א
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":"אתם מוזמנים לפנות לאבחון וקבלת טיפול בקליניקה"}'::jsonb, updated_at = now()
WHERE card_key = '217|||קליניקה לטיפול בפוסט-טראומה (מילואים/משוחררים — תשלום סמלי)' AND indicators = '{}'::jsonb;

-- I3-129 · row 218 · אגף השיקום — טיפולים רגשיים במימון
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"mod","terms":"eligible"}],"referral":["mod_rehab_worker"],"referral_source":"לצורך קבלת התחייבות וסיוע בבחירת מטפל מתאים יש לפנות לעובדת השיקום במחוז שלך"}'::jsonb, updated_at = now()
WHERE card_key = '218|||טיפולים נפשיים מסובסדים ע"י משרד הביטחון (חרבות ברזל)' AND indicators = '{}'::jsonb;

-- I3-130 · row 219 · מרחב נשימה בעמק
UPDATE directory_card_edits SET indicators = '{"offers":["care","community"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"חינם (נדרש רישום מוקדם)"}'::jsonb, updated_at = now()
WHERE card_key = '219|||תוכנית טיפול לפוסט-טראומה — מושב משק פרזון (רישום מוקדם)' AND indicators = '{}'::jsonb;

-- I3-131 · row 220 · קליניקה לטיפול זוגי ב-PTSD (בר אילן)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"הטיפול הוא חלק ממחקר קליני וניתן ללא עלות. לטופס הפנייה"}'::jsonb, updated_at = now()
WHERE card_key = '220|||CBT זוגי במחקר — 15 מפגשים בזום' AND indicators = '{}'::jsonb;

-- I3-132 · row 221 · קמה — מרפאה לטראומה ואובדן (שלוותה, כללית)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"full"},{"channel":"moh","terms":"full"}],"referral":["gp_referral","hmo_form17"],"referral_source":"ללא עלות, בהפניה מרופא משפחה וטופס 17 (כל הקופות)"}'::jsonb, updated_at = now()
WHERE card_key = '221|||טיפול ממוקד טראומה למשרתי/מילואימניקים משוחררים (מלחמה/אובדן)' AND indicators = '{}'::jsonb;

-- I3-133 · row 222 · אדוות להחלמה (בר אילן)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"מעוניינים בקבלת טיפול? למילוי טופס פנייה ואנו נחזור אליכם"}'::jsonb, updated_at = now()
WHERE card_key = '222|||טיפול קצר לילדי מילואימניקים 3-12 ומשפחות' AND indicators = '{}'::jsonb;

-- I3-134 · row 223 · מרכז "קשר עד" (מערך הנפגעים, צה״ל)
UPDATE directory_card_edits SET indicators = '{"offers":["info","navigate","claim"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"הכתובת לכל הפניות אל מערך הנפגעים; מוקד 1111 שלוחה 6. סיוע בהגשת בקשה להכרה בזכות נכה אל מול אגף השיקום"}'::jsonb, updated_at = now()
WHERE card_key = '223|||סיוע מקצועי לנפגעים בצה"ל ולבני משפחותיהם' AND indicators = '{}'::jsonb;

-- I3-135 · row 224 · מטפלים באהבה
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"10 מפגשים בסכום שתואם להחזר מהצבא (1,500 ₪), כך שהטיפול מכוסה במלואו. לבירורים: זהר 052-7014283"}'::jsonb, updated_at = now()
WHERE card_key = '224|||רשת מטפלים מוסמכים לחיילים ומילואים — עד 10 מפגשים מסובסדים' AND indicators = '{}'::jsonb;

-- I3-136 · row 225 · אור כי יהל (עמותת ברק, חטיבה 188)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"טיפול ללא תשלום למשך שנה. חיילים המעוניינים לקבל את השירות נרשמים בקישור"}'::jsonb, updated_at = now()
WHERE card_key = '225|||טיפול נפשי ללוחמי גזית/שריון (חטיבה 188) — ללא תשלום' AND indicators = '{}'::jsonb;

-- I3-137 · row 226 · שיב"א — המרפאה הלאומית
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"btl","terms":"full"}],"referral":["self_referral"],"referral_source":"מוזמנים לפנות למרפאה הלאומית של שיבא BEYOND, ללא עלות, במימון הביטוח הלאומי"}'::jsonb, updated_at = now()
WHERE card_key = '226|||עד 12 מפגשים טיפול רגשי ללא עלות' AND indicators = '{}'::jsonb;

-- I3-138 · row 227 · יתד (משרד הרווחה)
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care","claim"],"whole_org":true,"funding":[{"channel":"welfare","terms":"eligible"}],"referral":["court_or_welfare"],"referral_source":"הפניה דרך מחלקה לשירותים חברתיים"}'::jsonb, updated_at = now()
WHERE card_key = '227|||שירותים חברתיים לצעירים 18-27' AND indicators = '{}'::jsonb;
INSERT INTO card_org_links (org_card_key, member_card_key, sort_order)
SELECT o.card_key, m.card_key, 0 FROM directory_card_edits o, directory_card_edits m
WHERE o.card_key = '227|||שירותים חברתיים לצעירים 18-27' AND m.card_key = '288|||עובד/ת סוציאלי/ת בתוכנית יתד — ליווי צעירים וצעירות (18–25/26) במצבי חיים מורכבים'
ON CONFLICT (org_card_key, member_card_key) DO NOTHING;

-- I3-139 · row 228 · חוות מרפא רשפון
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":true,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '228|||טיפול, ליווי ושיקום — רשפון' AND indicators = '{}'::jsonb;

-- I3-140 · row 229 · משאבים — מרכז גליל
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"btl","terms":"full"}],"referral":["self_referral"],"referral_source":"פנו אלינו. המענים ללא עלות, במסגרת נוהל חרדה במימון הביטוח הלאומי"}'::jsonb, updated_at = now()
WHERE card_key = '229|||מוקד סיוע רגשי מרחוק (מגיל 12) — עברית, ערבית, רוסית, אנגלית' AND indicators = '{}'::jsonb;

-- I3-141 · row 230 · חיבוק ברזל (רטורנו)
UPDATE directory_card_edits SET indicators = '{"offers":["care","community"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"התוכנית בסבסוד מלא וללא עלות. מוזמנים לקבל מגוון טיפולים אישיים וקבוצתיים"}'::jsonb, updated_at = now()
WHERE card_key = '230|||תמיכה רגשית לצעירים 17-27 בחוות שמש — ללא עלות' AND indicators = '{}'::jsonb;

-- I3-142 · row 231 · משרד הרווחה — שירותי התמכרויות
UPDATE directory_card_edits SET indicators = '{"offers":["navigate"],"whole_org":false,"funding":[{"channel":"welfare","terms":""}],"referral":["self_referral","court_or_welfare"],"referral_source":"נאשמים עם התנהגות עבריינית ומצוקה המופנים מבתי משפט קהילתיים. טלפון 072-3741814"}'::jsonb, updated_at = now()
WHERE card_key = '231|||ייעוץ והפניה — חברתי-ביטחוני' AND indicators = '{}'::jsonb;

-- I3-143 · row 232 · תחנות ציבוריות — טיפול זוגי ומשפחתי
UPDATE directory_card_edits SET indicators = '{"offers":["navigate"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":"רשימת תחנות לפי אזורים, לכל תחנה טלפון. בפיקוח השירות לרווחת הפרט והמשפחה"}'::jsonb, updated_at = now()
WHERE card_key = '232|||מאגר תחנות לטיפול זוגי' AND indicators = '{}'::jsonb;

-- I3-144 · row 233 · ארנה איזון
UPDATE directory_card_edits SET indicators = '{"offers":["care","claim","community"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '233|||סיוע וטיפול לשורדי המסיבות בנובה — הרצליה' AND indicators = '{}'::jsonb;

-- I3-145 · row 234 · לב בטוח (SafeHeart)
UPDATE directory_card_edits SET indicators = '{"offers":["care","community"],"whole_org":false,"funding":[{"channel":"moh","terms":"full"},{"channel":"btl","terms":"full"}],"referral":["self_referral"],"referral_source":"מזמינים את מי שהיה במסיבות העוטף לקבל תמיכה ללא עלות. להרשמה לטיפול לחצו כאן"}'::jsonb, updated_at = now()
WHERE card_key = '234|||טיפול עומק לפצועי נובה — לפחות 24 מפגשים' AND indicators = '{}'::jsonb;

-- I3-146 · row 235 · לב השרון
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '235|||טיפול ממוקד בטראומה לשורדי מסיבות — מרכז רפואי + מסיבות בדרום' AND indicators = '{}'::jsonb;

-- I3-147 · row 236 · מוקד 118 (משרד הרווחה)
UPDATE directory_card_edits SET indicators = '{"offers":["info","navigate","care","claim"],"whole_org":false,"funding":[{"channel":"welfare","terms":"full"}],"referral":["self_referral"],"referral_source":"אפשר לפנות בטלפון 118 (שיחת חינם) או בהודעת טקסט ל-050-2270118"}'::jsonb, updated_at = now()
WHERE card_key = '236|||מידע, סיוע והכוונה — 24/7' AND indicators = '{}'::jsonb;

-- I3-148 · row 237 · הותיר אחריו חבר.ה
UPDATE directory_card_edits SET indicators = '{"offers":["care","community"],"whole_org":false,"funding":[{"channel":"mod","terms":"eligible"}],"referral":["self_referral"],"referral_source":"צרו קשר בטלפון 077-770-3166. העמותה נתמכת על ידי משרד הבטחון"}'::jsonb, updated_at = now()
WHERE card_key = '237|||טיפול לבני זוג שאיבדו בן/בת במהלך שירות (מלחמה, תאונה, מחלה, התאבדות)' AND indicators = '{}'::jsonb;

-- I3-149 · row 238 · אגף משפחות, הנצחה ומורשת (משרד הביטחון)
UPDATE directory_card_edits SET indicators = '{"offers":["care","community"],"whole_org":false,"funding":[{"channel":"mod","terms":"eligible"}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '238|||טיפול קבוצתי/זוגי/פרטני לשכולים ואחים/יתומים/אלמנות' AND indicators = '{}'::jsonb;

-- I3-150 · row 239 · אל"ה — מרכז להתמודדות עם אבדן
UPDATE directory_card_edits SET indicators = '{"offers":["care","community"],"whole_org":true,"funding":[],"referral":["self_referral"],"referral_source":"לתיאום טיפול: 1-800-800-440, או הודעה בוואטסאפ למספר 050-6644000"}'::jsonb, updated_at = now()
WHERE card_key = '239|||טיפול פרטני, זוגי, משפחתי וייעוץ פסיכיאטרי' AND indicators = '{}'::jsonb;

-- I3-151 · row 240 · מאגר מענים — ילדים ונוער (חרבות ברזל)
UPDATE directory_card_edits SET indicators = '{"offers":["info","navigate"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '240|||קישורים למטה להגנה, על"ם, מצמיחים, בית בטוח לנוער, נע"ן, עמותת ל.מ.ה, עמ"י ועוד' AND indicators = '{}'::jsonb;

-- I3-152 · row 241 · יחידה להתערבות במשבר — מרכז רפואי העמק (כללית)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"full"}],"referral":["self_referral","gp_referral","psychiatrist_referral","hmo_form17"],"referral_source":"לרוב דרך חדרי מיון, אפשר גם דרך רופאי משפחה, פסיכיאטרים או יועצים חינוכיים, ואף לפנות ישירות. הטיפול מחייב התחייבות (טופס 17) מקופת החולים."}'::jsonb, updated_at = now()
WHERE card_key = '241|||טיפול משפחתי אינטנסיבי לילדים 6-18' AND indicators = '{}'::jsonb;

-- I3-153 · row 242 · מענים לקהילה הגאה (חרבות ברזל)
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care","community"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"קו הקשב \"יש עם מי לדבר\" מציע אוזן קשבת, מידע ותמיכה לכלל חברות וחברי הקהילה, בני משפחה וחברים"}'::jsonb, updated_at = now()
WHERE card_key = '242|||קו סיוע וקישורים — להט"ב, הורים, דתיים, נוער' AND indicators = '{}'::jsonb;

-- I3-154 · row 243 · קווי תמיכה נפשית — קופות חולים (חרבות ברזל)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"full"}],"referral":["self_referral"],"referral_source":"מכבי: מגיל 14, 3 שיחות פעמיים בשנה, בלי הפניה."}'::jsonb, updated_at = now()
WHERE card_key = '243|||3 שיחות טיפוליות מקוונות ללא עלות' AND indicators = '{}'::jsonb;

-- I3-155 · row 244 · סל שיקום
UPDATE directory_card_edits SET indicators = '{"offers":["info","navigate"],"whole_org":false,"funding":[{"channel":"moh","terms":"eligible"}],"referral":["rehab_basket_committee"],"referral_source":"בדיקת זכאות, הגשת בקשה, ועדת סל שיקום בוחנת את הבקשה, ואז בחירת שירות וספק"}'::jsonb, updated_at = now()
WHERE card_key = '244|||מידע, זכויות ואיתור ספקי שירות בסל שיקום' AND indicators = '{}'::jsonb;

-- I3-156 · row 245 · רפואה ושמחה
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"מוקד ההזמנות זמין בימי חול 08:00-15:00; מומלץ לתאם מוקדם ככל האפשר, לרוב עד בוקר היום שלפני הנסיעה"}'::jsonb, updated_at = now()
WHERE card_key = '245|||שירותי אמבולנס ללא תשלום להסעת חולים, נכים ומוגבלים לטיפולים, בדיקות ושמחות' AND indicators = '{}'::jsonb;

-- I3-157 · row 246 · עזרה למרפא
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"לתיאום הזמנה באמבולנס: משרדי האגודה 03-5777000 שלוחה 5, ביתר השעות מוקד ארצי"}'::jsonb, updated_at = now()
WHERE card_key = '246|||שירותי אמבולנס להסעת חולים, נכים ומוגבלים לטיפולים, בדיקות ואירועים משפחתיים' AND indicators = '{}'::jsonb;

-- I3-158 · row 247 · מרכז קשרים
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":"יצירת קשר להכוונה ראשונית ללא התחייבות, ללא עלות וללא צורך בהזדהות"}'::jsonb, updated_at = now()
WHERE card_key = '247|||טיפול בהתמכרויות התנהגותיות (מין, פורנו, הימורים, אוכל, קשרים, מסכים) ותמיכה מערכתית לבני משפחה ובני זוג — טיפול, קבוצות ותוכנית 12 הצעדים' AND indicators = '{}'::jsonb;

-- I3-159 · row 248 · עמותת אפשר — יחידה להתמכרויות
UPDATE directory_card_edits SET indicators = '{"offers":["info","care"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":"טלפון ישיר ליחידה 03-6733228; קו חם לנפגעי הימורים 1-700-500-888"}'::jsonb, updated_at = now()
WHERE card_key = '248|||טיפול בנפגעי אלכוהול, הימורים והתמכרויות התנהגותיות נוספות — למכורים ולבני משפחותיהם; הסברה ומניעה' AND indicators = '{}'::jsonb;

-- I3-160 · row 249 · רטורנו — גמילה מהתמכרויות
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '249|||אשפוזית, טיפול יום וקהילות טיפוליות לגמילה ושיקום; מותאם גם לאוכלוסייה דתית וחרדית; מפוקח ע״י משרדי הבריאות והרווחה' AND indicators = '{}'::jsonb;

-- I3-161 · row 250 · דרך אחרת
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '250|||מרכז ברישיון משרד הבריאות לטיפול בהתמכרויות — בית מאזן לתחלואה כפולה, מרפאת יום, גמילה ותמיכה למשפחות; בשיתוף קופות החולים' AND indicators = '{}'::jsonb;

-- I3-162 · row 251 · נר-אנון ישראל
UPDATE directory_card_edits SET indicators = '{"offers":["care","community"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"התמכרות אצל בן משפחה או חבר? לתמיכה חינם וקישור לקבוצות נר אנון. שמרו על ראש פתוח ובואו לכמה שיותר פגישות."}'::jsonb, updated_at = now()
WHERE card_key = '251|||קבוצות עזרה עצמית אנונימיות (12 צעדים) למשפחות וחברים של מכורים לסמים' AND indicators = '{}'::jsonb;

-- I3-163 · row 252 · אל-אנון ישראל
UPDATE directory_card_edits SET indicators = '{"offers":["care","community"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '252|||קבוצות תמיכה אנונימיות (12 צעדים) למשפחות וחברים של אנשים הסובלים מאלכוהוליזם — פרונטלי וזום' AND indicators = '{}'::jsonb;

-- I3-164 · row 253 · א.א. אלכוהוליסטים אנונימיים
UPDATE directory_card_edits SET indicators = '{"offers":["care","community"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"הצטרף למרחב בטוח שבו אנו חולקים ניסיון, כוח ותקווה כדי להשתחרר מהדחף לשתות. התוכנית חינמית לחלוטין."}'::jsonb, updated_at = now()
WHERE card_key = '253|||קבוצות עזרה עצמית אנונימיות (12 צעדים) לאנשים הסובלים מבעיית שתייה' AND indicators = '{}'::jsonb;

-- I3-165 · row 254 · עמותת נוה מלכישוע
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":"קו חם מאויש 24/7 כולל סופי שבוע"}'::jsonb, updated_at = now()
WHERE card_key = '254|||כפר ומרכז לטיפול בהתמכרויות — גמילה פיזית, קהילות טיפוליות לנוער/צעירים/בגירים/נשים; בפיקוח משרדי הרווחה והבריאות' AND indicators = '{}'::jsonb;

-- I3-166 · row 255 · מפה לנפש
UPDATE directory_card_edits SET indicators = '{"offers":["info","navigate"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '255|||מפה ומאגר מענים טיפוליים ונפשיים בישראל לילדים, נוער ומבוגרים' AND indicators = '{}'::jsonb;

-- I3-167 · row 256 · עמותת על"ם
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care","community"],"whole_org":false,"funding":[{"channel":"welfare","terms":""},{"channel":"btl","terms":""}],"referral":["self_referral"],"referral_source":"הצוות והמתנדבים של עלם דיגיטל זמינים א''-ה'' 19:00-24:00 בצ''אט אנונימי בוואטסאפ"}'::jsonb, updated_at = now()
WHERE card_key = '256|||איתור, ליווי וטיפול בנוער וצעירים במצבי סיכון — בקהילה, ברחוב ובמרחב הדיגיטלי' AND indicators = '{}'::jsonb;

-- I3-168 · row 257 · עמותת אל-סם
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":"העמותה מעניקה את שירותיה לכל דורש ללא תנאי קבלה. במידה ויש צורך, עלות הטיפול מסובסדת על ידי העמותה."}'::jsonb, updated_at = now()
WHERE card_key = '257|||ייעוץ וטיפול לנוער וצעירים עד גיל 24 ולהוריהם בנושאי סמים, אלכוהול והתמכרויות' AND indicators = '{}'::jsonb;

-- I3-169 · row 258 · כנפיים של קרמבו
UPDATE directory_card_edits SET indicators = '{"offers":["community"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '258|||תנועת נוער משלבת לילדים עם ובלי צרכים מיוחדים — שילוב חברתי מלא ושוויוני' AND indicators = '{}'::jsonb;

-- I3-170 · row 259 · איגי — ארגון הנוער הגאה
UPDATE directory_card_edits SET indicators = '{"offers":["community"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"הקבוצות נפגשות פעם בשבוע ומתאימות לכל מי שרוצה, בארון ומחוצה לו, ללא תשלום."}'::jsonb, updated_at = now()
WHERE card_key = '259|||תנועת נוער וצעירים להט"ב — קבוצות חברתיות ותמיכה בעשרות יישובים' AND indicators = '{}'::jsonb;

-- I3-171 · row 260 · חוש"ן — חינוך ושינוי
UPDATE directory_card_edits SET indicators = '{"offers":["info"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '260|||הסברה וסדנאות בבתי ספר ובמסגרות נוער למניעת להט"בופוביה ולתמיכה בנוער להט"ב' AND indicators = '{}'::jsonb;

-- I3-172 · row 261 · בשביל החיים
UPDATE directory_card_edits SET indicators = '{"offers":["info","care","community"],"whole_org":false,"funding":[{"channel":"welfare","terms":""}],"referral":["self_referral"],"referral_source":"לפניה למרכזי הסיוע בשיחה או בוואטסאפ: 054-4493113"}'::jsonb, updated_at = now()
WHERE card_key = '261|||מניעת אובדנות ותמיכה במשפחות שכולות לאחר התאבדות או מוות פתאומי' AND indicators = '{}'::jsonb;

-- I3-173 · row 262 · עמותת עוצמה
UPDATE directory_card_edits SET indicators = '{"offers":["info","claim","community"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"אם אתם בני משפחה של מתמודדי נפש ורוצים לפעול לשיפור המצב – נשמח לצרף אתכם לעמותת עוצמה"}'::jsonb, updated_at = now()
WHERE card_key = '262|||פורום ארצי של בני משפחה של מתמודדי נפש — תמיכה, מיצוי זכויות, סנגור והפחתת סטיגמה' AND indicators = '{}'::jsonb;

-- I3-174 · row 263 · המסע שלנו
UPDATE directory_card_edits SET indicators = '{"offers":["info","navigate","claim","community"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"פעילות דיסקרטית בקבוצת פייסבוק ובקבוצת וואטסאפ למידע, היוועצות ותמיכה הדדית של הורים"}'::jsonb, updated_at = now()
WHERE card_key = '263|||פורום משפחות המתמודדות עם הפרעות אכילה — קבוצות תמיכה, מידע על זכויות וסנגור' AND indicators = '{}'::jsonb;

-- I3-175 · row 264 · IAED — העמותה הישראלית להפרעות אכילה
UPDATE directory_card_edits SET indicators = '{"offers":["info","navigate"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '264|||מידע לציבור ולמשפחות, מפת מסגרות טיפול ואינדקס מטפלים בהפרעות אכילה' AND indicators = '{}'::jsonb;

-- I3-176 · row 265 · אלו"ט
UPDATE directory_card_edits SET indicators = '{"offers":["info","care","claim","community"],"whole_org":false,"funding":[{"channel":"free","terms":""},{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":"קו תמיכה רגשי מהורים להורים ללא תשלום. מיצוי זכויות ב-*5922 ללא תשלום."}'::jsonb, updated_at = now()
WHERE card_key = '265|||ליווי ילדים ובוגרים על הרצף האוטיסטי ומשפחותיהם — זכויות, מרכזי משפחה ותמיכה' AND indicators = '{}'::jsonb;

-- I3-177 · row 266 · עמותת מיט"ב
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '266|||מרכז רב-תחומי לייעוץ, טיפול וחינוך בקהילה — ילדים, מתבגרים ומבוגרים; כולל יחידת קשב' AND indicators = '{}'::jsonb;

-- I3-178 · row 267 · מוקד 105 — המטה הלאומי להגנה על ילדים ברשת
UPDATE directory_card_edits SET indicators = '{"offers":["info","navigate","care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"ילדים, בני נוער, הוריהם וצוותי החינוך יכולים לפנות למוקד ולקבל מענה מידי. המוקד פועל 24/7."}'::jsonb, updated_at = now()
WHERE card_key = '267|||דיווח ומענה 24/7 על פגיעות, בריונות, סחיטה ופשיעה נגד ילדים ונוער במרחב המקוון' AND indicators = '{}'::jsonb;

-- I3-179 · row 268 · SGB — סטלה ישראל
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"mod","terms":"eligible"},{"channel":"private","terms":""}],"referral":["self_referral","psychiatrist_referral"],"referral_source":"נדרשת אבחנה של פסיכיאטר. עלות שני הטיפולים אחרי סבסוד כ-4,000 ש\"ח; סבסוד נוסף אם האבחנה קשורה למשרד הביטחון או לנפגעי חרבות ברזל."}'::jsonb, updated_at = now()
WHERE card_key = '268|||הליך רפואי קצר (Stellate Ganglion Block): שתי זריקות הרדמה מקומית בצידי הצוואר תחת אולטרסאונד, להקלה על תסמינים פיזיים של פוסט־טראומה, חרדה ודיכאון. מיועד לשילוב עם טיפול רגשי.' AND indicators = '{}'::jsonb;

-- I3-180 · row 269 · Prism — גרייה עצמית לפוסט טראומה
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care"],"whole_org":false,"funding":[{"channel":"mod","terms":"eligible"}],"referral":["self_referral"],"referral_source":"השאירו פרטים ונציג יחזור לתיאום. לשימוש באמצעות מרשם בלבד. מי שאינו מוכר במשרד הביטחון פונה ישירות למרכז הטיפול."}'::jsonb, updated_at = now()
WHERE card_key = '269|||טיפול EEG לא פולשני (GrayMatters Health) לאימון ויסות פעילות מוחית הקשורה לפוסט־טראומה, ללא חשיפה לטראומה. מאושר FDA ו־אמ"ר; מוכר לאגף השיקום למטופלים זכאים. רשימת מרכזים באתר (שיבא, איכילוב, ברזילי, מעלה הכרמל, בתי הלוחם ועוד).' AND indicators = '{}'::jsonb;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-16-card-indicators-batch-3',
    DATE '2026-10-16',
    'סימונים בכרטיסים: קבוצה 3',
    'סומנו 60 כרטיסים (שורות 208–269): מה יש בכרטיס, האם זה הכרטיס הכללי של הארגון, מימון ודרך ההפניה.',
    'cards',
    ARRAY[
    '208|||מנחה ומלווה משפחות למתמודדי נפש',
    '210|||טיפול ארצי ללא עלות לטווח ארוך בטראומה',
    '211|||טיפול, ליווי ושיקום לפוסט-טראומה (בהכרה או לאחר אבחון) — חוות במושב שמש',
    '212|||טיפוליים מפגשים ללא עלות בצפון (פרונטלי או מקוון)',
    '213|||עזרה ראשונה נפשית לנפגעי חרבות ברזל — עד 10 מפגשים',
    '214|||סיוע נפשי לחיילים ומילואים',
    '215|||סיוע נפשי ללא עלות לאנשי קבע ומשפחותיהם',
    '217|||קליניקה לטיפול בפוסט-טראומה (מילואים/משוחררים — תשלום סמלי)',
    '218|||טיפולים נפשיים מסובסדים ע"י משרד הביטחון (חרבות ברזל)',
    '219|||תוכנית טיפול לפוסט-טראומה — מושב משק פרזון (רישום מוקדם)',
    '220|||CBT זוגי במחקר — 15 מפגשים בזום',
    '221|||טיפול ממוקד טראומה למשרתי/מילואימניקים משוחררים (מלחמה/אובדן)',
    '222|||טיפול קצר לילדי מילואימניקים 3-12 ומשפחות',
    '223|||סיוע מקצועי לנפגעים בצה"ל ולבני משפחותיהם',
    '224|||רשת מטפלים מוסמכים לחיילים ומילואים — עד 10 מפגשים מסובסדים',
    '225|||טיפול נפשי ללוחמי גזית/שריון (חטיבה 188) — ללא תשלום',
    '226|||עד 12 מפגשים טיפול רגשי ללא עלות',
    '227|||שירותים חברתיים לצעירים 18-27',
    '228|||טיפול, ליווי ושיקום — רשפון',
    '229|||מוקד סיוע רגשי מרחוק (מגיל 12) — עברית, ערבית, רוסית, אנגלית',
    '230|||תמיכה רגשית לצעירים 17-27 בחוות שמש — ללא עלות',
    '231|||ייעוץ והפניה — חברתי-ביטחוני',
    '232|||מאגר תחנות לטיפול זוגי',
    '233|||סיוע וטיפול לשורדי המסיבות בנובה — הרצליה',
    '234|||טיפול עומק לפצועי נובה — לפחות 24 מפגשים',
    '235|||טיפול ממוקד בטראומה לשורדי מסיבות — מרכז רפואי + מסיבות בדרום',
    '236|||מידע, סיוע והכוונה — 24/7',
    '237|||טיפול לבני זוג שאיבדו בן/בת במהלך שירות (מלחמה, תאונה, מחלה, התאבדות)',
    '238|||טיפול קבוצתי/זוגי/פרטני לשכולים ואחים/יתומים/אלמנות',
    '239|||טיפול פרטני, זוגי, משפחתי וייעוץ פסיכיאטרי',
    '240|||קישורים למטה להגנה, על"ם, מצמיחים, בית בטוח לנוער, נע"ן, עמותת ל.מ.ה, עמ"י ועוד',
    '241|||טיפול משפחתי אינטנסיבי לילדים 6-18',
    '242|||קו סיוע וקישורים — להט"ב, הורים, דתיים, נוער',
    '243|||3 שיחות טיפוליות מקוונות ללא עלות',
    '244|||מידע, זכויות ואיתור ספקי שירות בסל שיקום',
    '245|||שירותי אמבולנס ללא תשלום להסעת חולים, נכים ומוגבלים לטיפולים, בדיקות ושמחות',
    '246|||שירותי אמבולנס להסעת חולים, נכים ומוגבלים לטיפולים, בדיקות ואירועים משפחתיים',
    '247|||טיפול בהתמכרויות התנהגותיות (מין, פורנו, הימורים, אוכל, קשרים, מסכים) ותמיכה מערכתית לבני משפחה ובני זוג — טיפול, קבוצות ותוכנית 12 הצעדים',
    '248|||טיפול בנפגעי אלכוהול, הימורים והתמכרויות התנהגותיות נוספות — למכורים ולבני משפחותיהם; הסברה ומניעה',
    '249|||אשפוזית, טיפול יום וקהילות טיפוליות לגמילה ושיקום; מותאם גם לאוכלוסייה דתית וחרדית; מפוקח ע״י משרדי הבריאות והרווחה',
    '250|||מרכז ברישיון משרד הבריאות לטיפול בהתמכרויות — בית מאזן לתחלואה כפולה, מרפאת יום, גמילה ותמיכה למשפחות; בשיתוף קופות החולים',
    '251|||קבוצות עזרה עצמית אנונימיות (12 צעדים) למשפחות וחברים של מכורים לסמים',
    '252|||קבוצות תמיכה אנונימיות (12 צעדים) למשפחות וחברים של אנשים הסובלים מאלכוהוליזם — פרונטלי וזום',
    '253|||קבוצות עזרה עצמית אנונימיות (12 צעדים) לאנשים הסובלים מבעיית שתייה',
    '254|||כפר ומרכז לטיפול בהתמכרויות — גמילה פיזית, קהילות טיפוליות לנוער/צעירים/בגירים/נשים; בפיקוח משרדי הרווחה והבריאות',
    '255|||מפה ומאגר מענים טיפוליים ונפשיים בישראל לילדים, נוער ומבוגרים',
    '256|||איתור, ליווי וטיפול בנוער וצעירים במצבי סיכון — בקהילה, ברחוב ובמרחב הדיגיטלי',
    '257|||ייעוץ וטיפול לנוער וצעירים עד גיל 24 ולהוריהם בנושאי סמים, אלכוהול והתמכרויות',
    '258|||תנועת נוער משלבת לילדים עם ובלי צרכים מיוחדים — שילוב חברתי מלא ושוויוני',
    '259|||תנועת נוער וצעירים להט"ב — קבוצות חברתיות ותמיכה בעשרות יישובים',
    '260|||הסברה וסדנאות בבתי ספר ובמסגרות נוער למניעת להט"בופוביה ולתמיכה בנוער להט"ב',
    '261|||מניעת אובדנות ותמיכה במשפחות שכולות לאחר התאבדות או מוות פתאומי',
    '262|||פורום ארצי של בני משפחה של מתמודדי נפש — תמיכה, מיצוי זכויות, סנגור והפחתת סטיגמה',
    '263|||פורום משפחות המתמודדות עם הפרעות אכילה — קבוצות תמיכה, מידע על זכויות וסנגור',
    '264|||מידע לציבור ולמשפחות, מפת מסגרות טיפול ואינדקס מטפלים בהפרעות אכילה',
    '265|||ליווי ילדים ובוגרים על הרצף האוטיסטי ומשפחותיהם — זכויות, מרכזי משפחה ותמיכה',
    '266|||מרכז רב-תחומי לייעוץ, טיפול וחינוך בקהילה — ילדים, מתבגרים ומבוגרים; כולל יחידת קשב',
    '267|||דיווח ומענה 24/7 על פגיעות, בריונות, סחיטה ופשיעה נגד ילדים ונוער במרחב המקוון',
    '268|||הליך רפואי קצר (Stellate Ganglion Block): שתי זריקות הרדמה מקומית בצידי הצוואר תחת אולטרסאונד, להקלה על תסמינים פיזיים של פוסט־טראומה, חרדה ודיכאון. מיועד לשילוב עם טיפול רגשי.',
    '269|||טיפול EEG לא פולשני (GrayMatters Health) לאימון ויסות פעילות מוחית הקשורה לפוסט־טראומה, ללא חשיפה לטראומה. מאושר FDA ו־אמ"ר; מוכר לאגף השיקום למטופלים זכאים. רשימת מרכזים באתר (שיבא, איכילוב, ברזילי, מעלה הכרמל, בתי הלוחם ועוד).'
    ],
    '{}',
    '081_card_indicators_b3.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
