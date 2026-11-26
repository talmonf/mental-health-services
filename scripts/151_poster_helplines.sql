-- Migration 151 (26 Nov 2026)
-- Two helplines from the national suicide-prevention aid sheet that were not on the site.
-- לחיות – לנפש תדרשנו (row 787): listening and referral for the Haredi public.
-- One card, under קווי סיוע and under אוכלוסיות מיוחדות.
-- The office is in Ashdod. The help is by phone, nationwide, so there is no pin.
-- https://lichyot.org/ has no English page, so the card is listed in Hebrew.
-- English wording is stored for a direct link.
-- מוקד משרד העלייה והקליטה לסיוע ותמיכה נפשית לעולים (row 788): short psychotherapy for olim.
-- One card, under קווי סיוע and under אוכלוסיות מיוחדות. No address, so no pin.
-- The Hebrew gov.il page was blocked from this network. The Hebrew name follows כל זכות,
-- which cites that page. The English name and the service facts follow the English gov.il
-- page, updated 11.10.2026.
-- לצדכם was on the same sheet and is not added. Most of its work is legal advocacy.
-- The audit wording was approved by the owner on 26 Nov 2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'לחיות_לנפש_תדרשנו_787',
  'לחיות – לנפש תדרשנו',
  'הקשבה והכוונה לפסיכותרפיה או לטיפול פסיכיאטרי. בטלפון.',
  'helplines',
  ARRAY['helplines', 'populations']::text[],
  ARRAY['self_referral']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (
  card_key, row_id, entry_id, public_fields, eligibility, sites, indicators, translations, site_languages
) VALUES (
  '787|||הקשבה והכוונה לפסיכותרפיה או לטיפול פסיכיאטרי. בטלפון.',
  787,
  'לחיות_לנפש_תדרשנו_787',
  $card787${"org":"לחיות – לנפש תדרשנו","svc":"הקשבה והכוונה לפסיכותרפיה או לטיפול פסיכיאטרי. בטלפון.","target":"הציבור החרדי","region":"כל הארץ","cost":"","specialty":"","languages":"עברית","diseases":"","notes":"שונה מ[מטיבת״א](https://nefesh-il.org/emergency?entry=24&section=helplines). שלוחה לגברים, שלוחה לנשים, ושלוחה 3 להדרכה במצב דחוף. המשרד ביוסי בר חלפתא 7, אשדוד.","tags":"","whatsapp":"","whatsappLabel":"","email":"info@lichyot.org","emailLabel":"אימייל","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://lichyot.org/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","add2":"","addLabel2":"","add3":"","addLabel3":"","phone":"074-780-0380","phoneLabel":"טלפון","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true,"founded":"","approaches":"","meeting":""}$card787$::jsonb,
  $elig787${"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"26.11.2026: נבדק מול https://lichyot.org/ ו-https://lichyot.org/s-o-s-for-emergency/ . שם העמותה באתר: לחיות – לנפש תדרשנו, ע״ר 580466662. אין עמוד באנגלית. המספר באתר כתוב 0747-800-380, כלומר 074-780-0380. בגיליון של לאומית מופיע 074-7800380, אותו מספר. אין מחיר באתר, ולכן עלות ריקה. מוקד מקשיבים: הקשבה, שלוחות גברים ונשים. הכוונה למטפלים רגשיים, לפסיכולוגים ולפסיכיאטרים. שלוחה 3 היא הדרכה מעשית במצב דחוף, לא הפניה למטפל. האתר כותב שההקשבה ושהשלוחה הדחופה פעילות 24/6, ובאותו עמוד גם ״24 שעות ביממה״. השעות לא על הכרטיס. הקהל שפורסם לשלוחה הדחופה: הציבור החרדי. המשרד: יוסי בר חלפתא 7, אשדוד, 7765116. אין סיכה, כי המענה בטלפון. מייל info@lichyot.org. כפתור אחד לטלפון וכפתור אחד למייל, בלי המספר וכתובת המייל על הכפתור. meeting ריק: אין מרפאה ואין זום."}$elig787$::jsonb,
  '[]'::jsonb,
  $ind787${"offers":["navigate","care"],"whole_org":true,"funding":[],"referral":["self_referral"],"referral_source":"מתקשרים ל-074-780-0380. שלוחה לגברים, שלוחה לנשים, ושלוחה 3 למצב דחוף.","ownership":"nonprofit","app":""}$ind787$::jsonb,
  $en787${"en":{"org":"Lichyot — Lanefesh Tidreshenu","svc":"Listening, and referral to psychotherapy or psychiatric treatment. By phone.","phoneLabel":"Phone","emailLabel":"Email","target":"The Haredi public","region":"Nationwide","languages":"Hebrew","notes":"Distinct from [Metivta](https://nefesh-il.org/emergency?entry=24&section=helplines). An extension for men, an extension for women, and extension 3 for guidance in an urgent situation. The office is at 7 Yossi Bar Chalafta, Ashdod."}}$en787$::jsonb,
  '{"he":{"web":"https://lichyot.org/"}}'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'מוקד_הסיוע_הנפשי_לעולים_788',
  'מוקד משרד העלייה והקליטה לסיוע ותמיכה נפשית לעולים',
  'פסיכותרפיה קצרה, עד חמישה מפגשים, וגם תמיכה נפשית. בטלפון.',
  'helplines',
  ARRAY['helplines', 'populations']::text[],
  ARRAY['self_referral']::text[]
)
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys,
  referral_codes = EXCLUDED.referral_codes;

INSERT INTO directory_card_edits (
  card_key, row_id, entry_id, public_fields, eligibility, sites, indicators, translations, site_languages
) VALUES (
  '788|||פסיכותרפיה קצרה, עד חמישה מפגשים, וגם תמיכה נפשית. בטלפון.',
  788,
  'מוקד_הסיוע_הנפשי_לעולים_788',
  $card788${"org":"מוקד משרד העלייה והקליטה לסיוע ותמיכה נפשית לעולים","svc":"פסיכותרפיה קצרה, עד חמישה מפגשים, וגם תמיכה נפשית. בטלפון.","target":"עולים מגיל 18","region":"כל הארץ","cost":"חינם","specialty":"","languages":"אמהרית, רוסית, אנגלית, צרפתית, ספרדית","diseases":"","notes":"מופעל עם [ער״ן](https://nefesh-il.org/emergency?entry=20&section=helplines). אין הגבלה על מספר השנים בארץ. מחוץ לשעות הפעילות אפשר להשאיר הודעה.","tags":"","whatsapp":"","whatsappLabel":"","email":"","emailLabel":"","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://www.gov.il/he/pages/emotional-assistance-and-support-hotline-center-for-new-olim","webLabel":"","web2":"https://www.gov.il/en/pages/emotional-assistance-and-support-hotline-center-for-new-olim","webLabel2":"English","add":"","addLabel":"","add2":"","addLabel2":"","add3":"","addLabel3":"","phone":"*3201","phoneLabel":"טלפון","phoneShowNumber":false,"phone2":"","phoneLabel2":"","phoneShowNumber2":true,"phone3":"","phoneLabel3":"","phoneShowNumber3":true,"phone4":"","phoneLabel4":"","phoneShowNumber4":true,"phone5":"","phoneLabel5":"","phoneShowNumber5":true,"phone6":"","phoneLabel6":"","phoneShowNumber6":true,"founded":"","approaches":"","meeting":""}$card788$::jsonb,
  $elig788${"age_min":18,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"26.11.2026: העמוד העברי ב-gov.il נחסם ברשת הזו (Cloudflare). נבדק מול https://www.gov.il/en/pages/emotional-assistance-and-support-hotline-center-for-new-olim , עודכן 11.10.2026, ומול https://www.kolzchut.org.il/he/מוקד_משרד_העלייה_והקליטה_לסיוע_ותמיכה_נפשית_לעולים שמפנה לעמוד המשרד. השם העברי הוא כותרת כל זכות. השם האנגלי הוא כותרת העמוד הממשלתי. טלפון *3201. שפות: אמהרית, רוסית, אנגלית, צרפתית, ספרדית. עולים מגיל 18, בלי הגבלה על שנות השהייה בארץ. עד 5 מפגשים, על ידי אנשי מקצוע עם תואר שני טיפולי, בליווי ער״ן. א׳–ה׳ 16:00–21:00, לא בערבי חג ובחגים. מחוץ לשעות אפשר להשאיר הודעה. השעות לא על הכרטיס. חינם, לפי כל זכות. מוקד המידע הכללי של המשרד, *2994 ו-03-9733333, אינו הקו הנפשי ולא על הכרטיס. בעמוד משרד הבריאות מופיע גם *3207 ברשימת קווים של 24/7, ובפירוט באותו עמוד המספר הוא *3201. על הכרטיס רק *3201. כל זכות מציינת גם צ׳אט. העמוד האנגלי המעודכן מתאר טלפון, בלי כתובת צ׳אט, ולכן אין צ׳אט על הכרטיס. אין כתובת ואין סיכה. meeting ריק: המפגש בטלפון."}$elig788$::jsonb,
  '[]'::jsonb,
  $ind788${"offers":["care"],"whole_org":true,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"מתקשרים ל-*3201. אין הפניה.","ownership":"government","app":""}$ind788$::jsonb,
  $en788${"en":{"org":"Emotional Assistance and Support Hotline Center for New Olim","svc":"Short psychotherapy, up to five sessions, and also emotional support. By phone.","phoneLabel":"Phone","webLabel2":"English","target":"Olim aged 18 and over","region":"Nationwide","cost":"Free","languages":"Amharic, Russian, English, French, Spanish","notes":"Operated with [ERAN](https://nefesh-il.org/emergency?entry=20&section=helplines). There is no limit on how many years the person has been in the country. Outside opening hours a caller can leave a message.","web":"https://www.gov.il/en/pages/emotional-assistance-and-support-hotline-center-for-new-olim","web2":"https://www.gov.il/he/pages/emotional-assistance-and-support-hotline-center-for-new-olim"}}$en788$::jsonb,
  '{"he":{"web":"https://www.gov.il/he/pages/emotional-assistance-and-support-hotline-center-for-new-olim"},"en":{"web":"https://www.gov.il/en/pages/emotional-assistance-and-support-hotline-center-for-new-olim"}}'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-26-poster-helplines',
  DATE '2026-11-26',
  'נוספו קו לחיות – לנפש תדרשנו וקו הסיוע לעולים',
  'בקווי סיוע נוסף קו ההקשבה לחיות – לנפש תדרשנו, לציבור החרדי, וקו הסיוע הנפשי לעולים של משרד העלייה והקליטה. שניהם גם באוכלוסיות מיוחדות.',
  'cards',
  ARRAY[
  '787|||הקשבה והכוונה לפסיכותרפיה או לטיפול פסיכיאטרי. בטלפון.',
  '788|||פסיכותרפיה קצרה, עד חמישה מפגשים, וגם תמיכה נפשית. בטלפון.'
  ],
  '{}',
  '151_poster_helplines.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
