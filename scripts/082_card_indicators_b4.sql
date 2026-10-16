-- Migration 082 (16 Oct 2026)
-- Card indicators, batch 4: values approved by the site owner, from docs/card-indicators-2026-10.md.
-- Only cards whose indicators are still empty are filled, so an admin edit is never overwritten.
-- Requires migration 077. Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

-- I4-181 · row 270 · אסקטמין / Spravato (ספראבטו)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"eligible"},{"channel":"moh","terms":"eligible"}],"referral":["psychiatrist_referral","hmo_form17"],"referral_source":"נדרש מרשם פסיכיאטר ואישור הקופה."}'::jsonb, updated_at = now()
WHERE card_key = '270|||תרסיס אף של אסקטמין לדיכאון מג''ורי עמיד. בסל הבריאות (מ-2020) למבוגרים שלא הגיבו לשני קווי טיפול משתי קבוצות פרמקולוגיות, בשילוב SSRI/SNRI. ניתן רק במרפאה מורשית תחת השגחה.' AND indicators = '{}'::jsonb;

-- I4-182 · row 271 · קטמיינד (KetaMind) — עירוי קטמין
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":"במידה שהינך מעוניין בטיפול או בפרטים נוספים על התהליך, בבקשה תמלא את הטופס בקישור ונחזור אליך בהקדם."}'::jsonb, updated_at = now()
WHERE card_key = '271|||מרפאה פסיכיאטרית מקבוצת Stella Israel: עירוי קטמין במינון נמוך בהשגחה רפואית לדיכאון, חרדה ופוסט־טראומה.' AND indicators = '{}'::jsonb;

-- I4-183 · row 272 · Keter Health — KAP
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":"Start Your Process / Free Consultation — פנייה ישירה דרך האתר; הערכה פסיכיאטרית במרפאה."}'::jsonb, updated_at = now()
WHERE card_key = '272|||Ketamine-assisted psychotherapy in Jerusalem: psychiatrist and KAP therapist (mainly IM ketamine with preparation and integration) for treatment-resistant depression, PTSD and anxiety.' AND indicators = '{}'::jsonb;

-- I4-184 · row 273 · tDCS — המרכז הרפואי הרצוג
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"eligible"},{"channel":"moh","terms":"eligible"}],"referral":["psychiatrist_referral","hmo_form17"],"referral_source":"זכאים כנגד טופס 17 מקופת החולים... לאחר הפנייה של הרופא המטפל – פסיכיאטר או נוירולוג."}'::jsonb, updated_at = now()
WHERE card_key = '273|||גרייה מוחית בזרם ישר חלש (tDCS) במרפאה לגרייה מוחית בהרצוג. לא פולשני; למצבים פסיכיאטריים ונוירולוגיים לפי הערכה רפואית. באותה מרפאה גם Deep TMS לדיכאון מג''ורי (טופס 17).' AND indicators = '{}'::jsonb;

-- I4-185 · row 274 · VNS — גירוי העצב התועה
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":""}],"referral":["psychiatrist_referral","hmo_form17"],"referral_source":"לכל פנייה יש לצרף מכתב הפניה מפסיכיאטר מטפל וטופס 17 מהקופה."}'::jsonb, updated_at = now()
WHERE card_key = '274|||השתלת קוצב המגרה את עצב הואגוס לדיכאון קשה עמיד לטיפול. בישראל: הערכה ביחידה לגרייה מוחית בלב השרון; ההשתלה בנוירוכירורגיה תפקודית באיכילוב. מוגבל, דורש הפניה פסיכיאטרית.' AND indicators = '{}'::jsonb;

-- I4-186 · row 275 · DBS — גירוי מוחי עמוק (OCD עמיד)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":["psychiatrist_referral"],"referral_source":"ההפניה להערכה ברמב״ם מהפסיכיאטר המטפל."}'::jsonb, updated_at = now()
WHERE card_key = '275|||הליך נוירוכירורגי להשתלת אלקטרודות וקוצב מוחי במקרי OCD חמורים ועמידים לטיפול. ניתן במספר מרכזים בודדים (למשל רמב"ם). אינו בסל הבריאות; רק באישור מיוחד של משרד הבריאות או במחקר.' AND indicators = '{}'::jsonb;

-- I4-187 · row 276 · מעגלי נפש
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":"קבע מפגש של חצי שעה עם אחד מהרבנים שלנו."}'::jsonb, updated_at = now()
WHERE card_key = '276|||ייעוץ הלכתי ורוחני למתמודדים ולבני משפחה — רבנים ורבניות שעברו הכשרה בבריאות הנפש (לא טיפול קליני)' AND indicators = '{}'::jsonb;

-- I4-188 · row 277 · מתייעצים עם מטפלים מוסמכים
UPDATE directory_card_edits SET indicators = '{"offers":["community"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '277|||קבוצה בפייסבוק' AND indicators = '{}'::jsonb;

-- I4-189 · row 278 · האגודה לבריאות הציבור
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"moh","terms":"eligible"},{"channel":"mod","terms":"eligible"},{"channel":"welfare","terms":"eligible"}],"referral":["rehab_basket_committee"],"referral_source":"המוכרים כזכאים לשירות על ידי משרד הבריאות, אגף השיקום של משרד הרווחה ומשרד הביטחון."}'::jsonb, updated_at = now()
WHERE card_key = '278|||שירותי סל שיקום' AND indicators = '{}'::jsonb;

-- I4-190 · row 279 · בית רעים (האגודה לבריאות הציבור)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"full"},{"channel":"moh","terms":""},{"channel":"mod","terms":"eligible"},{"channel":"private","terms":""}],"referral":["psychiatrist_referral","hmo_form17","mod_rehab_worker","self_referral"],"referral_source":"מקופות החולים – מכתב הפנייה מפסיכיאטר וטופס 17; ממשרד הביטחון: הפנייה ממשרד הביטחון ומכתב מפסיכיאטר; באופן פרטי: פנייה טלפונית."}'::jsonb, updated_at = now()
WHERE card_key = '279|||טיפול יום פסיכיאטרי — חלופת אשפוז למבוגרים במצבי משבר' AND indicators = '{}'::jsonb;

-- I4-191 · row 280 · מרפאת הנגב (האגודה לבריאות הציבור)
UPDATE directory_card_edits SET indicators = '{"offers":["care","claim"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":""}],"referral":["gp_referral"],"referral_source":"הפנייה למרפאה ניתן לקבל מרופא.ת המשפחה דרך קופת החולים."}'::jsonb, updated_at = now()
WHERE card_key = '280|||טיפול נפשי מרפאתי — הערכה פסיכיאטרית, טיפול תרופתי ופסיכותרפיה' AND indicators = '{}'::jsonb;

-- I4-192 · row 281 · האגודה לבריאות הציבור
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"mod","terms":"eligible"},{"channel":"btl","terms":"eligible"}],"referral":["mod_rehab_worker","nii_referral"],"referral_source":"הפניה דרך עובדות השיקום של משרד הביטחון או ביטוח לאומי (פעולות איבה)."}'::jsonb, updated_at = now()
WHERE card_key = '281|||שיקום לנכי צה"ל ונפגעי פעולות איבה — מרכז החממה ותכנית תושייה למשפחות הלומי קרב' AND indicators = '{}'::jsonb;

-- I4-193 · row 282 · מרכז צ׳ויס (CHOICE)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '282|||מרכז יום לנוער וצעירים (12–35) על רצף הטראומה וההתמכרות — אבחון, טיפול פרטני וקבוצתי וליווי שיקומי' AND indicators = '{}'::jsonb;

-- I4-194 · row 283 · יוזמה דרך הלב
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"moh","terms":"eligible"},{"channel":"mod","terms":"eligible"}],"referral":["rehab_basket_committee","mod_rehab_worker"],"referral_source":"זכאי סל שיקום; נכי צה\"ל (באישור עובד השיקום)"}'::jsonb, updated_at = now()
WHERE card_key = '283|||שיקום תעסוקתי, תעסוקה נתמכת ויזמות — כולל תוכנית צרכנים נותני שירות' AND indicators = '{}'::jsonb;

-- I4-195 · row 284 · החוט המשולש
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral","court_or_welfare"],"referral_source":"פנייה עצמית או דרך רווחה."}'::jsonb, updated_at = now()
WHERE card_key = '284|||בית חם, מרחב פתוח והלנת חירום לנוער וצעירים בסיכון — כולל שלטר לצעירות חרדיות' AND indicators = '{}'::jsonb;

-- I4-196 · row 285 · בית השנטי
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '285|||בית חם ומקלט חירום לנוער בסיכון ובסכנת חיים (14–21)' AND indicators = '{}'::jsonb;

-- I4-197 · row 286 · עמותת יחדיו — קורת גג בראשית
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"פנייה עצמית או הפניית גורם חיצוני."}'::jsonb, updated_at = now()
WHERE card_key = '286|||קורת גג 24/7 לנוער 12–18 ללא קבלה בירוקרטית — עד 3 חודשים' AND indicators = '{}'::jsonb;

-- I4-198 · row 287 · אנוש — הלנת חירום
UPDATE directory_card_edits SET indicators = '{"offers":["care","claim"],"whole_org":false,"funding":[{"channel":"welfare","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '287|||קורת גג 24/7 לצעירים 18–25 ללא עורף משפחתי — עד 6 חודשים' AND indicators = '{}'::jsonb;

-- I4-199 · row 288 · עו״ס יתד
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care","claim"],"whole_org":false,"funding":[{"channel":"welfare","terms":"eligible"}],"referral":["self_referral","court_or_welfare"],"referral_source":"הפניה גם דרך המחלקה לשירותים חברתיים. מי שמעוניין ממלא שאלון באתר יתד."}'::jsonb, updated_at = now()
WHERE card_key = '288|||עובד/ת סוציאלי/ת בתוכנית יתד — ליווי צעירים וצעירות (18–25/26) במצבי חיים מורכבים' AND indicators = '{}'::jsonb;

-- I4-200 · row 289 · בית משלך (חכמת נשים)
UPDATE directory_card_edits SET indicators = '{"offers":["care","claim"],"whole_org":false,"funding":[{"channel":"welfare","terms":""}],"referral":["court_or_welfare"],"referral_source":"נערות דרך חסות הנוער (CRM); צעירות בדו״ח סוציאלי מהמחלקה לשירותים חברתיים."}'::jsonb, updated_at = now()
WHERE card_key = '289|||רשת הוסטלים לנערות וצעירות במצבי סיכון — ראשון לציון; גישה מודעת טראומה' AND indicators = '{}'::jsonb;

-- I4-201 · row 290 · חכמת נשים
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":"יצירת קשר: 050-4080498"}'::jsonb, updated_at = now()
WHERE card_key = '290|||קליניקה לטיפול בנשים ובנערות — פסיכותרפיה, פגיעות מיניות, הפרעות אכילה, דיכאון אחרי לידה ואלימות ביחסים' AND indicators = '{}'::jsonb;

-- I4-202 · row 291 · נויגייט (NAVIGATE)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":"פרטי כל מרפאה באתר"}'::jsonb, updated_at = now()
WHERE card_key = '291|||תוכנית טיפול קהילתית מוקדמת לצעירים אחרי אפיזודה פסיכוטית ראשונה' AND indicators = '{}'::jsonb;

-- I4-203 · row 292 · בדרכי (מרחבים, באר יעקב)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '292|||מחלקה פתוחה לאשפוז בטראומה מורכבת — כולל נפגעי 7 באוקטובר ובני משפחותיהם' AND indicators = '{}'::jsonb;

-- I4-204 · row 293 · לצידך (מרחבים, באר יעקב)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"eligible"},{"channel":"moh","terms":""}],"referral":["hmo_form17"],"referral_source":"טופס 17 — כללית ומאוחדת"}'::jsonb, updated_at = now()
WHERE card_key = '293|||מחלקה פתוחה לנשים עם פוסט־טראומה מורכבת והפרעות אכילה' AND indicators = '{}'::jsonb;

-- I4-205 · row 294 · מזור (הרב שמעון רגובי)
UPDATE directory_card_edits SET indicators = '{"offers":["navigate"],"whole_org":false,"funding":[],"referral":["self_referral"],"referral_source":"גם כשקשה למצוא את המילים, אפשר להתחיל בפנייה אחת."}'::jsonb, updated_at = now()
WHERE card_key = '294|||הכוונה וליווי למציאת מענה בפסיכיאטריה ובריאות הנפש' AND indicators = '{}'::jsonb;

-- I4-206 · row 295 · עזרת אחים
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"private","terms":""}],"referral":["self_referral"],"referral_source":"במוקד ניתן להזמין מקום לנסיעה."}'::jsonb, updated_at = now()
WHERE card_key = '295|||הסעות מסובסדות לבתי חולים מבית שמש לירושלים, אמבולנסים ורכבים מונגשים' AND indicators = '{}'::jsonb;

-- I4-207 · row 296 · עמותת גוונים
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"moh","terms":"eligible"}],"referral":["self_referral","rehab_basket_committee"],"referral_source":"מוקד *9913. מכינת הד: גילאי 18–28, זכאי סל שיקום"}'::jsonb, updated_at = now()
WHERE card_key = '296|||תעסוקה נתמכת, מועדון חברתי באשקלון, מכינת הד, דיור מוגן לבודדים / ליווי, וסייעים בחינוך' AND indicators = '{}'::jsonb;

-- I4-208 · row 297 · מעון ירושלים (המרכז הירושלמי לבריאות הנפש)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":""}],"referral":["gp_referral","hmo_form17","psychiatrist_referral"],"referral_source":"מכתב הפנייה מרופא/ה מטפל/ת (בעדיפות גבוהה מפסיכיאטר/ית), וטופס 17 מקופת החולים, קוד L0771."}'::jsonb, updated_at = now()
WHERE card_key = '297|||טיפול יום אינטנסיבי למבוגרים — מניעת אשפוז מלא' AND indicators = '{}'::jsonb;

-- I4-209 · row 298 · ויניק טלביה (כללית)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":""}],"referral":["gp_referral"],"referral_source":"אשפוז יום ניתן רק לאחר הפניית רופא."}'::jsonb, updated_at = now()
WHERE card_key = '298|||אשפוז יום פסיכיאטרי למבוטחי כללית' AND indicators = '{}'::jsonb;

-- I4-210 · row 299 · איכילוב — טיפול יום נוירופסיכיאטרי
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":""}],"referral":["gp_referral","psychiatrist_referral","hmo_form17"],"referral_source":"טופס 17, קוד L0822. הפניה מגורם בבריאות הנפש, מנוירולוג או מרופא משפחה; אם יש פסיכיאטר מטפל — לצרף מכתב."}'::jsonb, updated_at = now()
WHERE card_key = '299|||טיפול יום למצבים נוירופסיכיאטריים וסומטיים — לא מסגרת כללית למשבר' AND indicators = '{}'::jsonb;

-- I4-211 · row 300 · מעייני הישועה
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":""},{"channel":"mod","terms":"eligible"},{"channel":"private","terms":""}],"referral":["gp_referral","hmo_form17"],"referral_source":"חברי כללית ומכבי: הפניה מהרופא המטפל/רופא המשפחה. מאוחדת ולאומית: טופס 17. משרד הביטחון: טופס התחייבות."}'::jsonb, updated_at = now()
WHERE card_key = '300|||טיפול יום פסיכיאטרי בהפרדה מגדרית — לציבור הדתי והחרדי' AND indicators = '{}'::jsonb;

-- I4-212 · row 301 · רמב״ם — היחידה לטיפול יום
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '301|||טיפול יום פסיכיאטרי בשני שלבים' AND indicators = '{}'::jsonb;

-- I4-213 · row 302 · הלל יפה — יחידת טיפול יום מבוגרים
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":["psychiatrist_referral","hmo_form17"],"referral_source":"לצורך קבלה ליחידה נדרשת הפניה מהפסיכיאטר המטפל, או גורם טיפולי מוסמך אחר מתחום בריאות הנפש, וכן טופס התחייבות."}'::jsonb, updated_at = now()
WHERE card_key = '302|||טיפול יום פסיכיאטרי, חמישה ימים בשבוע' AND indicators = '{}'::jsonb;

-- I4-214 · row 303 · כללית — טיפול יום מבוגרים, יפו
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":["gp_referral"],"referral_source":"הטיפול מיועד ללקוחות כללית עם אבחנה או חשד לאבחנה נפשית, וניתן בהפניית רופא."}'::jsonb, updated_at = now()
WHERE card_key = '303|||טיפול יום פסיכיאטרי למבוטחי כללית' AND indicators = '{}'::jsonb;

-- I4-215 · row 304 · רשימות ארציות — טיפול יום פסיכיאטרי
UPDATE directory_card_edits SET indicators = '{"offers":["info","navigate"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":["psychiatrist_referral","hmo_form17"],"referral_source":"צריך לפנות לגורם המטפל, פסיכיאטר או מטפל בבריאות הנפש, שיפיק מכתב הפניה. אם טיפול היום לא ניתן ישירות על ידי הקופה, יש לקבל טופס 17."}'::jsonb, updated_at = now()
WHERE card_key = '304|||הסבר על השירות, וטבלאות מרכזים שאין להם כרטיס נפרד' AND indicators = '{}'::jsonb;

-- I4-216 · row 305 · האגף לבריאות הנפש (עזר מציון)
UPDATE directory_card_edits SET indicators = '{"offers":["care","community"],"whole_org":true,"funding":[{"channel":"moh","terms":""}],"referral":["self_referral","rehab_basket_committee"],"referral_source":"שיקום תעסוקתי ותעסוקה בשוק החופשי: זכאי סל שיקום. מרכז ייעוץ למשפחות מסובסד על ידי משרד הבריאות: 12 פגישות חינם."}'::jsonb, updated_at = now()
WHERE card_key = '305|||שיקום תעסוקתי, תעסוקה נתמכת, פנאי ומרכזי משפחות למתמודדי נפש מגיל 18' AND indicators = '{}'::jsonb;
INSERT INTO card_org_links (org_card_key, member_card_key, sort_order)
SELECT o.card_key, m.card_key, 0 FROM directory_card_edits o, directory_card_edits m
WHERE o.card_key = '305|||שיקום תעסוקתי, תעסוקה נתמכת, פנאי ומרכזי משפחות למתמודדי נפש מגיל 18' AND m.card_key = '26|||קו ייעוץ ותמיכה - בימים א-ה בשעות 10:00-13:00 ו-16:00-22:00'
ON CONFLICT (org_card_key, member_card_key) DO NOTHING;
INSERT INTO card_org_links (org_card_key, member_card_key, sort_order)
SELECT o.card_key, m.card_key, 1 FROM directory_card_edits o, directory_card_edits m
WHERE o.card_key = '305|||שיקום תעסוקתי, תעסוקה נתמכת, פנאי ומרכזי משפחות למתמודדי נפש מגיל 18' AND m.card_key = '68|||סיוע למשפחות של מתמודדי נפש'
ON CONFLICT (org_card_key, member_card_key) DO NOTHING;

-- I4-217 · row 306 · שלו — שיקום וטיפול
UPDATE directory_card_edits SET indicators = '{"offers":["navigate","care"],"whole_org":true,"funding":[{"channel":"moh","terms":"eligible"},{"channel":"welfare","terms":"eligible"}],"referral":["rehab_basket_committee"],"referral_source":"עברת ועדה לסל שיקום? נסייע לך לבחור ולהגיע לשירות המיטבי עבורך. תעסוקה נתמכת: סל שיקום ושירותי רווחה."}'::jsonb, updated_at = now()
WHERE card_key = '306|||סל שיקום, דיור, תעסוקה וסיוע להורים מתמודדים' AND indicators = '{}'::jsonb;
INSERT INTO card_org_links (org_card_key, member_card_key, sort_order)
SELECT o.card_key, m.card_key, 0 FROM directory_card_edits o, directory_card_edits m
WHERE o.card_key = '306|||סל שיקום, דיור, תעסוקה וסיוע להורים מתמודדים' AND m.card_key = '307|||ליווי ממוקד הורות להורים המתמודדים עם קשיים נפשיים'
ON CONFLICT (org_card_key, member_card_key) DO NOTHING;

-- I4-218 · row 307 · ציפור הנפש
UPDATE directory_card_edits SET indicators = '{"offers":["care","community"],"whole_org":false,"funding":[{"channel":"moh","terms":"eligible"}],"referral":["rehab_basket_committee"],"referral_source":"ניתן אל מול אישור ועדת סל שיקום לדיור מוגן."}'::jsonb, updated_at = now()
WHERE card_key = '307|||ליווי ממוקד הורות להורים המתמודדים עם קשיים נפשיים' AND indicators = '{}'::jsonb;

-- I4-219 · row 308 · מרכזי ייעוץ למשפחות
UPDATE directory_card_edits SET indicators = '{"offers":["info","navigate","care","claim","community"],"whole_org":false,"funding":[{"channel":"moh","terms":"full"}],"referral":["self_referral"],"referral_source":"כל אחד ואחת יכולים לפנות אל מרכז יעוץ ותמיכה למשפחות מתמודדי נפש, ללא עלות וללא צורך בהכרה או אישור מוקדם, גם אם אין זכאות לסל שיקום."}'::jsonb, updated_at = now()
WHERE card_key = '308|||רשימת מרכזי הייעוץ למשפחות בקהילה ובבתי החולים' AND indicators = '{}'::jsonb;

-- I4-220 · row 309 · כפר שאול — אשפוז יום
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '309|||אשפוז יום אחרי אשפוז מלא — הדרך שלך חזרה לקהילה' AND indicators = '{}'::jsonb;

-- I4-221 · row 310 · לוטוס (כפר שאול)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":["psychiatrist_referral","hmo_form17"],"referral_source":"הפנייה מפסיכיאטר בקהילה מששת החודשים האחרונים, וטופס התחייבות (טופס 17) למנוי אבחוני (קוד L0771) לאינטייק."}'::jsonb, updated_at = now()
WHERE card_key = '310|||טיפול יום לנשים עם טראומה מורכבת אחרי פגיעה מינית' AND indicators = '{}'::jsonb;

-- I4-222 · row 311 · קפלן — טיפול יום פסיכיאטרי
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":["hmo_form17"],"referral_source":"טופס 17"}'::jsonb, updated_at = now()
WHERE card_key = '311|||מחלקת טיפול יום, כחודש וחצי בממוצע' AND indicators = '{}'::jsonb;

-- I4-223 · row 312 · גהה — מחלקה ח׳
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '312|||טיפול יום למבוגרים' AND indicators = '{}'::jsonb;

-- I4-224 · row 313 · חופים (איכילוב)
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '313|||מחלקה לטיפול יום פסיכיאטרי לילדים ולנוער' AND indicators = '{}'::jsonb;

-- I4-225 · row 314 · הדסה — טיפול יום ואשפוז יום
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '314|||טיפול יום לקטינים באתיופיה, ואשפוז יום בעין כרם' AND indicators = '{}'::jsonb;

-- I4-226 · row 315 · ברזילי — טיפול יום
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '315|||טיפול יום ואשפוז יום למבוגרים, וטיפול יום לקטינים בבית ספר שקד' AND indicators = '{}'::jsonb;

-- I4-227 · row 316 · זיו — טיפול יום
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '316|||טיפול יום ואשפוז יום' AND indicators = '{}'::jsonb;

-- I4-228 · row 317 · מזרע — טיפול יום
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '317|||טיפול יום למבוגרים' AND indicators = '{}'::jsonb;

-- I4-229 · row 318 · העמק — טיפול יום
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '318|||טיפול יום ואשפוז יום למבוגרים' AND indicators = '{}'::jsonb;

-- I4-230 · row 319 · האנגלי בנצרת — אשפוז יום
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '319|||אשפוז יום למבוגרים' AND indicators = '{}'::jsonb;

-- I4-231 · row 320 · נהריה — אשפוז יום
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '320|||אשפוז יום לקטינים' AND indicators = '{}'::jsonb;

-- I4-232 · row 321 · באר שבע — טיפול יום
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '321|||טיפול יום למבוגרים במרכז לבריאות הנפש' AND indicators = '{}'::jsonb;

-- I4-233 · row 322 · סורוקה — טיפול יום
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '322|||טיפול יום למבוגרים' AND indicators = '{}'::jsonb;

-- I4-234 · row 323 · באר יעקב — טיפול יום
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '323|||טיפול יום למבוגרים' AND indicators = '{}'::jsonb;

-- I4-235 · row 324 · שלוותה — טיפול יום
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '324|||טיפול יום למבוגרים ואשפוז יום' AND indicators = '{}'::jsonb;

-- I4-236 · row 325 · שניידר — אשפוז יום
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '325|||אשפוז יום לקטינים' AND indicators = '{}'::jsonb;

-- I4-237 · row 326 · אברבנאל — טיפול יום
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '326|||טיפול יום למבוגרים' AND indicators = '{}'::jsonb;

-- I4-238 · row 327 · בארי — טיפול יום
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"partial"},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '327|||טיפול יום למבוגרים של כללית' AND indicators = '{}'::jsonb;

-- I4-239 · row 328 · שיבא — אשפוז יום
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":""},{"channel":"moh","terms":""}],"referral":[],"referral_source":""}'::jsonb, updated_at = now()
WHERE card_key = '328|||אשפוז יום במחלקת ילדים' AND indicators = '{}'::jsonb;

-- I4-240 · row 329 · בית דניאלה
UPDATE directory_card_edits SET indicators = '{"offers":["care"],"whole_org":false,"funding":[{"channel":"hmo","terms":"full"},{"channel":"moh","terms":""}],"referral":["psychiatrist_referral","hmo_form17"],"referral_source":"לקבל הפניה מרופא/ה פסיכיאטר; להגיש בקשת התחייבות למכבי; בכפוף לאישור מקדים של פסיכיאטר מחוזי"}'::jsonb, updated_at = now()
WHERE card_key = '329|||טיפול יום לנוער, בשיבולים ובצור הדסה' AND indicators = '{}'::jsonb;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-16-card-indicators-batch-4',
    DATE '2026-10-16',
    'סימונים בכרטיסים: קבוצה 4',
    'סומנו 60 כרטיסים (שורות 270–329): מה יש בכרטיס, האם זה הכרטיס הכללי של הארגון, מימון ודרך ההפניה.',
    'cards',
    ARRAY[
    '270|||תרסיס אף של אסקטמין לדיכאון מג''ורי עמיד. בסל הבריאות (מ-2020) למבוגרים שלא הגיבו לשני קווי טיפול משתי קבוצות פרמקולוגיות, בשילוב SSRI/SNRI. ניתן רק במרפאה מורשית תחת השגחה.',
    '271|||מרפאה פסיכיאטרית מקבוצת Stella Israel: עירוי קטמין במינון נמוך בהשגחה רפואית לדיכאון, חרדה ופוסט־טראומה.',
    '272|||Ketamine-assisted psychotherapy in Jerusalem: psychiatrist and KAP therapist (mainly IM ketamine with preparation and integration) for treatment-resistant depression, PTSD and anxiety.',
    '273|||גרייה מוחית בזרם ישר חלש (tDCS) במרפאה לגרייה מוחית בהרצוג. לא פולשני; למצבים פסיכיאטריים ונוירולוגיים לפי הערכה רפואית. באותה מרפאה גם Deep TMS לדיכאון מג''ורי (טופס 17).',
    '274|||השתלת קוצב המגרה את עצב הואגוס לדיכאון קשה עמיד לטיפול. בישראל: הערכה ביחידה לגרייה מוחית בלב השרון; ההשתלה בנוירוכירורגיה תפקודית באיכילוב. מוגבל, דורש הפניה פסיכיאטרית.',
    '275|||הליך נוירוכירורגי להשתלת אלקטרודות וקוצב מוחי במקרי OCD חמורים ועמידים לטיפול. ניתן במספר מרכזים בודדים (למשל רמב"ם). אינו בסל הבריאות; רק באישור מיוחד של משרד הבריאות או במחקר.',
    '276|||ייעוץ הלכתי ורוחני למתמודדים ולבני משפחה — רבנים ורבניות שעברו הכשרה בבריאות הנפש (לא טיפול קליני)',
    '277|||קבוצה בפייסבוק',
    '278|||שירותי סל שיקום',
    '279|||טיפול יום פסיכיאטרי — חלופת אשפוז למבוגרים במצבי משבר',
    '280|||טיפול נפשי מרפאתי — הערכה פסיכיאטרית, טיפול תרופתי ופסיכותרפיה',
    '281|||שיקום לנכי צה"ל ונפגעי פעולות איבה — מרכז החממה ותכנית תושייה למשפחות הלומי קרב',
    '282|||מרכז יום לנוער וצעירים (12–35) על רצף הטראומה וההתמכרות — אבחון, טיפול פרטני וקבוצתי וליווי שיקומי',
    '283|||שיקום תעסוקתי, תעסוקה נתמכת ויזמות — כולל תוכנית צרכנים נותני שירות',
    '284|||בית חם, מרחב פתוח והלנת חירום לנוער וצעירים בסיכון — כולל שלטר לצעירות חרדיות',
    '285|||בית חם ומקלט חירום לנוער בסיכון ובסכנת חיים (14–21)',
    '286|||קורת גג 24/7 לנוער 12–18 ללא קבלה בירוקרטית — עד 3 חודשים',
    '287|||קורת גג 24/7 לצעירים 18–25 ללא עורף משפחתי — עד 6 חודשים',
    '288|||עובד/ת סוציאלי/ת בתוכנית יתד — ליווי צעירים וצעירות (18–25/26) במצבי חיים מורכבים',
    '289|||רשת הוסטלים לנערות וצעירות במצבי סיכון — ראשון לציון; גישה מודעת טראומה',
    '290|||קליניקה לטיפול בנשים ובנערות — פסיכותרפיה, פגיעות מיניות, הפרעות אכילה, דיכאון אחרי לידה ואלימות ביחסים',
    '291|||תוכנית טיפול קהילתית מוקדמת לצעירים אחרי אפיזודה פסיכוטית ראשונה',
    '292|||מחלקה פתוחה לאשפוז בטראומה מורכבת — כולל נפגעי 7 באוקטובר ובני משפחותיהם',
    '293|||מחלקה פתוחה לנשים עם פוסט־טראומה מורכבת והפרעות אכילה',
    '294|||הכוונה וליווי למציאת מענה בפסיכיאטריה ובריאות הנפש',
    '295|||הסעות מסובסדות לבתי חולים מבית שמש לירושלים, אמבולנסים ורכבים מונגשים',
    '296|||תעסוקה נתמכת, מועדון חברתי באשקלון, מכינת הד, דיור מוגן לבודדים / ליווי, וסייעים בחינוך',
    '297|||טיפול יום אינטנסיבי למבוגרים — מניעת אשפוז מלא',
    '298|||אשפוז יום פסיכיאטרי למבוטחי כללית',
    '299|||טיפול יום למצבים נוירופסיכיאטריים וסומטיים — לא מסגרת כללית למשבר',
    '300|||טיפול יום פסיכיאטרי בהפרדה מגדרית — לציבור הדתי והחרדי',
    '301|||טיפול יום פסיכיאטרי בשני שלבים',
    '302|||טיפול יום פסיכיאטרי, חמישה ימים בשבוע',
    '303|||טיפול יום פסיכיאטרי למבוטחי כללית',
    '304|||הסבר על השירות, וטבלאות מרכזים שאין להם כרטיס נפרד',
    '305|||שיקום תעסוקתי, תעסוקה נתמכת, פנאי ומרכזי משפחות למתמודדי נפש מגיל 18',
    '306|||סל שיקום, דיור, תעסוקה וסיוע להורים מתמודדים',
    '307|||ליווי ממוקד הורות להורים המתמודדים עם קשיים נפשיים',
    '308|||רשימת מרכזי הייעוץ למשפחות בקהילה ובבתי החולים',
    '309|||אשפוז יום אחרי אשפוז מלא — הדרך שלך חזרה לקהילה',
    '310|||טיפול יום לנשים עם טראומה מורכבת אחרי פגיעה מינית',
    '311|||מחלקת טיפול יום, כחודש וחצי בממוצע',
    '312|||טיפול יום למבוגרים',
    '313|||מחלקה לטיפול יום פסיכיאטרי לילדים ולנוער',
    '314|||טיפול יום לקטינים באתיופיה, ואשפוז יום בעין כרם',
    '315|||טיפול יום ואשפוז יום למבוגרים, וטיפול יום לקטינים בבית ספר שקד',
    '316|||טיפול יום ואשפוז יום',
    '317|||טיפול יום למבוגרים',
    '318|||טיפול יום ואשפוז יום למבוגרים',
    '319|||אשפוז יום למבוגרים',
    '320|||אשפוז יום לקטינים',
    '321|||טיפול יום למבוגרים במרכז לבריאות הנפש',
    '322|||טיפול יום למבוגרים',
    '323|||טיפול יום למבוגרים',
    '324|||טיפול יום למבוגרים ואשפוז יום',
    '325|||אשפוז יום לקטינים',
    '326|||טיפול יום למבוגרים',
    '327|||טיפול יום למבוגרים של כללית',
    '328|||אשפוז יום במחלקת ילדים',
    '329|||טיפול יום לנוער, בשיבולים ובצור הדסה'
    ],
    '{}',
    '082_card_indicators_b4.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
