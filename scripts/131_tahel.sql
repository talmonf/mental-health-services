-- Migration 131 (10 Nov 2026)
-- תהל (row 781): the religious and Haredi crisis center of the Association of Rape
-- Crisis Centers. One card, shown under טראומה and under קווי סיוע.
-- The office is in Jerusalem; only a post box was published, so there is no pin.
-- https://1202.org.il/tahel/en/ returns 404, and the about page under /en/ is still
-- Hebrew, so the card is listed in Hebrew. English wording is stored for a direct link.
-- The association card (row 200) gains one sentence naming תהל. The Arabic-line
-- sentence and the link to תאיר stay.
-- Audit wording approved with the plan on 10.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO directory_entries (
  entry_id, display_name, description, primary_category, category_keys, referral_codes
) VALUES (
  'תהל_מרכז_הסיוע_הדתי_חרדי_781',
  'תהל – מרכז הסיוע הדתי־חרדי',
  'סיוע וליווי לנפגעות ולנפגעי תקיפה מינית ואלימות במשפחה',
  'trauma',
  ARRAY['trauma', 'helplines']::text[],
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
  '781|||סיוע וליווי לנפגעות ולנפגעי תקיפה מינית ואלימות במשפחה',
  781,
  'תהל_מרכז_הסיוע_הדתי_חרדי_781',
  $card781${"org":"תהל – מרכז הסיוע הדתי־חרדי","svc":"סיוע וליווי לנפגעות ולנפגעי תקיפה מינית ואלימות במשפחה","target":"נפגעות ונפגעי תקיפה מינית ואלימות במשפחה בחברה הדתית והחרדית, ובני משפחותיהם","region":"כל הארץ","cost":"ליווי משפטי ללא עלות","specialty":"","languages":"עברית","diseases":"","notes":"מרכז הסיוע של [איגוד מרכזי הסיוע](https://nefesh-il.org/emergency?entry=200&section=helplines) לחברה הדתית והחרדית. המשרד בירושלים, והמענה לכל הארץ. קבוצות תמיכה והפניה לטיפול. טופס באתר אינו למענה דחוף. לטלפון כשר: *2511 לנשים, 02-5328000 לגברים, 02-6730002 לקו החם, ו-052-346-8541 לפגיעות טקסיות (גם וואטסאפ). 1202, 1203, הצ׳אט והוואטסאפ של קולמילה בכרטיס של האיגוד. אין רחוב באתר, ולכן אין מפה.","tags":"","whatsapp":"972523468541","whatsappLabel":"פגיעות טקסיות","email":"office@crisiscenter.org.il","emailLabel":"אימייל","emailShowAddress":false,"email2":"","emailLabel2":"","emailShowAddress2":false,"email3":"","emailLabel3":"","emailShowAddress3":false,"web":"https://1202.org.il/tahel/","webLabel":"","web2":"","webLabel2":"","add":"","addLabel":"","add2":"","addLabel2":"","add3":"","addLabel3":"","phone":"*2511","phoneLabel":"נשים","phoneShowNumber":false,"phone2":"02-5328000","phoneLabel2":"גברים","phoneShowNumber2":false,"phone3":"02-6730002","phoneLabel3":"קו חם","phoneShowNumber3":false,"phone4":"052-346-8541","phoneLabel4":"פגיעות טקסיות","phoneShowNumber4":false,"phone5":"02-6726847","phoneLabel5":"משרד","phoneShowNumber5":false,"phone6":"","phoneLabel6":"","phoneShowNumber6":true}$card781$::jsonb,
  '{"age_min":null,"age_max":null,"sex":"any","location_mode":"any","regions":[],"diagnoses":[],"presenting_problems":[],"recognition":{"btl":"any","moh":"any","mod":"any","rehab_basket":"any"},"internal_notes":"10.11.2026: נבדק מול https://1202.org.il/tahel/ , https://1202.org.il/tahel/about-us/ , https://1202.org.il/tahel/contact-us/ ו-https://1202.org.il/en/contact-us/ . https://1202.org.il/tahel/en/ מחזיר 404. https://1202.org.il/tahel/en/about-us/ כותרת באנגלית והגוף בעברית, ולכן אין עמוד באנגלית. כתובת שפורסמה: ת.ד. 53503, מיקוד 910502, ירושלים. אין רחוב ואין סיכה. ע״ר 580229979. פקס באתר תהל: 02-6726210. ברשימת האיגוד באנגלית הפקס הוא 02-6241942, הפקס של מרכז ירושלים, ולא הועתק. מרכז קול (1210) מודפס בדף יצירת הקשר ואינו תהל. האתר הישן crisiscenter.org.il מציין שעות וואטסאפ ביום שלישי, tahel@crisiscenter.org.il ופייסבוק. האתר הנוכחי מפרסם office@crisiscenter.org.il ואינו חוזר על השעות, ולכן אלה לא על הכרטיס. 1202, 1203 וקולמילה נשארים בכרטיס האיגוד."}'::jsonb,
  '[]'::jsonb,
  '{"offers":["care","community"],"whole_org":true,"funding":[{"channel":"free","terms":""}],"referral":["self_referral"],"referral_source":"פנייה בקו הסיוע, בטלפון המשרד או באימייל. טופס באתר אינו למענה דחוף","ownership":"nonprofit","app":""}'::jsonb,
  $en781${"en":{"org":"Tahel Crisis Center","svc":"Support and accompaniment for people affected by sexual assault and domestic violence","phoneLabel":"Women","phoneLabel2":"Men","phoneLabel3":"Hotline","phoneLabel4":"Ritual abuse","phoneLabel5":"Office","whatsappLabel":"Ritual abuse","emailLabel":"Email","target":"People in religious and Haredi society who have experienced sexual assault or domestic violence, and their families","region":"Nationwide","cost":"Legal accompaniment at no charge","languages":"Hebrew","notes":"The crisis center of the [Association of Rape Crisis Centers](https://nefesh-il.org/emergency?entry=200&section=helplines) for religious and Haredi society. The office is in Jerusalem, and the help is nationwide. Support groups and referral to care. The form on the website is not for urgent help. For a kosher phone: *2511 for women, 02-5328000 for men, 02-6730002 for the hotline, and 052-346-8541 for ritual abuse (also WhatsApp). 1202, 1203, and the Kolmila chat and WhatsApp are on the association's card. No street is published, so there is no map."}}$en781$::jsonb,
  '{"he":{"web":"https://1202.org.il/tahel/"}}'::jsonb
)
ON CONFLICT (card_key) DO NOTHING;

UPDATE directory_card_edits
SET public_fields = jsonb_set(
      public_fields,
      '{notes}',
      to_jsonb(
        CASE
          WHEN COALESCE(public_fields->>'notes', '') LIKE '%entry=781%'
            THEN public_fields->>'notes'
          WHEN btrim(COALESCE(public_fields->>'notes', '')) = ''
            THEN $he200$סיוע לחברה הערבית: 04-6566813, וצ׳אט בערבית באתר chatwavo.org. ראו גם [תאיר – מרכז הסיוע לנפגעות ולנפגעי תקיפה מינית](https://nefesh-il.org/treatment?entry=201&section=trauma). הקווים לחברה הדתית והחרדית הם של [תהל – מרכז הסיוע הדתי־חרדי](https://nefesh-il.org/treatment?entry=781&section=trauma).$he200$
          ELSE rtrim(public_fields->>'notes') || ' ' || $he200b$הקווים לחברה הדתית והחרדית הם של [תהל – מרכז הסיוע הדתי־חרדי](https://nefesh-il.org/treatment?entry=781&section=trauma).$he200b$
        END
      )
    ),
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en,notes}',
      to_jsonb(
        CASE
          WHEN COALESCE(translations#>>'{en,notes}', '') LIKE '%entry=781%'
            THEN translations#>>'{en,notes}'
          WHEN btrim(COALESCE(translations#>>'{en,notes}', '')) = ''
            THEN $en200$Help for Arab society: 04-6566813, and an Arabic chat at chatwavo.org. See also [Tair — the crisis center for people who have been sexually assaulted](https://nefesh-il.org/treatment?entry=201&section=trauma). The lines for the religious and Haredi community are [Tahel Crisis Center](https://nefesh-il.org/treatment?entry=781&section=trauma).$en200$
          ELSE rtrim(translations#>>'{en,notes}') || ' ' || $en200b$The lines for the religious and Haredi community are [Tahel Crisis Center](https://nefesh-il.org/treatment?entry=781&section=trauma).$en200b$
        END
      ),
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '200|||קווי המענה הארציים של ארגון הגג למרכזי הסיוע';

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-10-tahel',
  DATE '2026-11-10',
  'נוסף כרטיס של מרכז הסיוע תהל',
  'מרכז הסיוע של איגוד מרכזי הסיוע לחברה הדתית והחרדית, לפגיעה מינית ולאלימות במשפחה. הכרטיס מופיע תחת טראומה ותחת קווי סיוע. המשרד בירושלים, והמענה לכל הארץ. בכרטיס יש אתר, קווי סיוע, משרד, אימייל ווואטסאפ לפגיעות טקסיות. אין מפה, כי באתר פורסמה רק תיבת דואר. בכרטיס של האיגוד נוסף קישור לתהל. האתר בעברית, ולכן הכרטיס מופיע בעברית.',
  'cards',
  ARRAY[
    '781|||סיוע וליווי לנפגעות ולנפגעי תקיפה מינית ואלימות במשפחה',
    '200|||קווי המענה הארציים של ארגון הגג למרכזי הסיוע'
  ],
  '{}',
  '131_tahel.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
