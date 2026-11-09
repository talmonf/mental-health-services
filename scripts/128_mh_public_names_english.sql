-- Migration 128 (9 Nov 2026)
-- Public clinics, day treatment, and psychiatric hospitals from migration 102.
-- A title that was a street, a neighborhood, a city, or an age group is now the
-- health fund or the mental-health center, and the city. The street stays on the map.
-- Phone buttons say טלפון and no longer print the number. English wording is in
-- translations.en. An English website address already stored is left in place.
-- Register as [ ] in database_updates_master.sql; do not mark [x].
--
-- Left as filed because gov.il/.../yaffo-yaffo is not proof of the operator (21):
-- 362 אזור - ילדים ונוער - | אזור | yaffo-yaffo is not treated as the operator
-- 368 אריאל - מבוגרים | אריאל | yaffo-yaffo is not treated as the operator
-- 427 הרצלייה - ילדים ונוער | הרצליה | yaffo-yaffo is not treated as the operator
-- 428 הרצלייה - מבוגרים | הרצליה | yaffo-yaffo is not treated as the operator
-- 429 הרצלייה - מבוגרים- מעקב | הרצליה | yaffo-yaffo is not treated as the operator
-- 438 חולון - ילדים ונוער | חולון | yaffo-yaffo is not treated as the operator
-- 439 חולון - מבוגרים | חולון | yaffo-yaffo is not treated as the operator
-- 603 פ"ת - ילדים ונוער | פתח תקוה | yaffo-yaffo is not treated as the operator
-- 604 פ"ת - מבוגרים | פתח תקוה | yaffo-yaffo is not treated as the operator
-- 605 פ"ת - מבוגרים- שחף | פתח תקוה | yaffo-yaffo is not treated as the operator
-- 666 הארבעה-מרכז לטפול פסיכולוגי - ילדים | תל אביב | yaffo-yaffo is not treated as the operator
-- 667 הארבעה-מרכז לטפול פסיכולוגי - מבוגרים | תל אביב | yaffo-yaffo is not treated as the operator
-- 668 יפו - טיפול יום מבוגרים | תל אביב | yaffo-yaffo is not treated as the operator
-- 669 יפו - ילדים ונוער | תל אביב | yaffo-yaffo is not treated as the operator
-- 670 יפו - ילדים ונוער לקויי שמיעה (לקו"ש) | תל אביב | yaffo-yaffo is not treated as the operator
-- 671 יפו - מבוגרים | תל אביב | yaffo-yaffo is not treated as the operator
-- 672 יפו - מבוגרים תחלואה כפולה | תל אביב | yaffo-yaffo is not treated as the operator
-- 673 יפו - פסיכוגריאטריה | תל אביב | yaffo-yaffo is not treated as the operator
-- 674 יפו – מבוגרים לקוי שמיעה (לקו"ש) | תל אביב | yaffo-yaffo is not treated as the operator
-- 675 יפו – מבוגרים- מעקב | תל אביב | yaffo-yaffo is not treated as the operator
-- 678 פלוטקין ת"א (יפו) | תל אביב | yaffo-yaffo is not treated as the operator
-- Left as filed because the operator could not be read from the website and the payer line (5):
-- 689 טיפול יום – לוד | לוד | no fund or named center on the website
-- 690 טיפול יום – נתניה (בניין רעים) | נתניה | no fund or named center on the website
-- 692 טיפול יום – מרכז קהילתי לבריאות הנפש יפו | יפו | no fund or named center on the website
-- 696 טיפול יום – באר שבע | באר שבע | no fund or named center on the website
-- 739 אשפוז פסיכיאטרי – מרכז רפואי הרצליה | הרצליה | no website and no single fund on the payer line

BEGIN;

UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"מאוחדת, אום אל פחם"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Umm al-Fahm","svc":"Multidisciplinary mental health clinic","target":"Children and youth, adults","region":"Umm al-Fahm","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Meuhedet, Umm al-Fahm"],"siteAddresses":["Umm al-Fahm"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '358|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, אום אל פחם'
WHERE entry_id = 'אום_אל_פחם_358';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית, אום אל פחם"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Umm al-Fahm","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Umm al-Fahm","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: mall Al-Haram - main, Umm al-Fahm.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '359|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, אום אל פחם'
WHERE entry_id = 'בריאות_הנפש_אום_אל_פאחם_359';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Tiferet Beit Cham - Aom Al-Pacham","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Umm al-Fahm","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Nonprofit — a provider under contract with a health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: Tiferet Beit Cham. Address: neighborhood Al-Iyun, Umm al-Fahm.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '360|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"phoneLabel2":"טלפון","phoneShowNumber2":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Public Health Association Ofakim","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Ofakim","cost":"Health basket — Clalit, Maccabi, and Leumit members (referral from the fund; quarterly co-payment)","specialty":"a compulsory-treatment clinic","notes":"Ownership: External provider under contract with a health fund (ownership not stated). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: Public Health Association. Treatment methods: cbt,dbt, treatment trauma-focused including emdr.","phoneLabel":"Phone","phoneLabel2":"Phone","siteLabels":["Public Health Association Ofakim"],"siteAddresses":["14 Herzl, Ofakim"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '361|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-5151125","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: מרכז ממשלתי לבריאות הנפש (משרד הבריאות). הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. שיטות טיפול: דינמי, דיאדי, קבוצתי, משפחתי,CBT. מקור: מאגר מרפאות בריאות הנפש של משרד הבריאות, עדכון 28.12.2025. שלוחה 44."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Azor - children and youth -","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Azor","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"behavior disorders in children, children growing up in families with many difficulties","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Extension 44. Treatment methods: dynamic, dyadic, group, family,CBT.","phoneLabel":"Phone","siteLabels":["Azor - children and youth -"],"siteAddresses":["73 Masha Sharat, Azor"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '362|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, אילת"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Eilat","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Eilat","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Eilat"],"siteAddresses":["310 Shashat HaYmim, Eilat"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '363|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, אילת'
WHERE entry_id = 'אילת_363';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"clinic HaDekel- mental health center - Eilat","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Eilat","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 3 Petan, ground floor, building Sha''ar HaIr Beit HaDekel, Eilat.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '364|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, אלעד"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Elad","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Elad","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Elad"],"siteAddresses":["94 Yehuda HaNasi, Elad"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '365|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, אלעד'
WHERE entry_id = 'אלעד_365';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"1599-510-550","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: עמותה (מלכ\"ר) – ספק בהסדר קופה. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מפעיל: בית חם. מקור: מאגר מרפאות בריאות הנפש של משרד הבריאות, עדכון 28.12.2025. כתובת: רחוב פנחס בן יאיר 3, אלעד. שלוחה 2."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"clinic Beit Cham Elad","svc":"Multidisciplinary mental health clinic","target":"Children and youth, adults","region":"Elad","cost":"Health basket — Maccabi, Meuhedet, Leumit, and Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Nonprofit — a provider under contract with a health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: Beit Cham. Address: 3 street Pinchas Ben Yair, Elad. Extension 2.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '366|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, אפרת"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Efrat","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Efrat","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Shad David HaMelekh, Efrat.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '367|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, אפרת'
WHERE entry_id = 'אפרת_367';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Ariel - adults","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ariel","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: CBT group EMDR, DBT.","phoneLabel":"Phone","siteLabels":["Ariel - adults"],"siteAddresses":["5 Yehuda, Ariel"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '368|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, אשדוד"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Ashdod","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Ashdod","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Ashdod"],"siteAddresses":["4 Avan Azar, Ashdod"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '369|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, אשדוד'
WHERE entry_id = 'אבן_עזרא_369';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי — מבוגרים, אשדוד"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi — adults, Ashdod","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ashdod","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Maccabi — adults, Ashdod"],"siteAddresses":["7 Kanarat, Ashdod"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '370|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי — מבוגרים, אשדוד'
WHERE entry_id = 'אשדוד_יא_מבוגרים_370';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — ילדים ונוער, אשדוד"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — children and youth, Ashdod","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Ashdod","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Clalit — children and youth, Ashdod"],"siteAddresses":["6 Yitzhak Shada, Ashdod"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '371|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — ילדים ונוער, אשדוד'
WHERE entry_id = 'אשדוד_ילדים_ונוער_371';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — מבוגרים, אשדוד"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — adults, Ashdod","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ashdod","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Clalit — adults, Ashdod"],"siteAddresses":["6 Yitzhak Shada, Ashdod"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '372|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — מבוגרים, אשדוד'
WHERE entry_id = 'אשדוד_מבוגרים_372';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי — ילדים ונוער, אשדוד"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi — children and youth, Ashdod","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Ashdod","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Maccabi — children and youth, Ashdod"],"siteAddresses":["15 Rashavi, Ashdod"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '373|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי — ילדים ונוער, אשדוד'
WHERE entry_id = 'אשדוד_רשב_י_ילדים_373';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Beit Cham - Ashdod","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Ashdod","cost":"Health basket — Clalit, Maccabi, Meuhedet, and Leumit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Nonprofit — a provider under contract with a health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: Beit Cham. Address: 15 Rach Yehuda HaMaccabi, Ashdod. Treatment methods: all kinds of treatment.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '374|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"08-8687527","phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Tsipor HaNefesh Ashdod- Rasakav","svc":"Multidisciplinary mental health clinic","target":"Children and youth, adults","region":"Ashdod","cost":"Health basket — Leumit members (referral from the fund; quarterly co-payment)","specialty":"eating disorders","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: cbt; cbt.dbt.","phoneLabel":"Phone","siteLabels":["Tsipor HaNefesh Ashdod- Rasakav"],"siteAddresses":["22 Echad HaAm, Ashdod"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '375|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, אשדוד"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Ashdod","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Ashdod","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Ashdod"],"siteAddresses":["3 Ykinaton, Ashdod"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '376|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, אשדוד'
WHERE entry_id = 'רב_מקצועית_376';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"מאוחדת — ילדים ונוער, אשדוד"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet — children and youth, Ashdod","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Ashdod","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Meuhedet — children and youth, Ashdod"],"siteAddresses":["41 Rogozin, Ashdod"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '377|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת — ילדים ונוער, אשדוד'
WHERE entry_id = 'רוגוזין_377';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת — מבוגרים, ילדים ונוער, אשקלון"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet — adults, children, and youth, Ashkelon","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Ashkelon","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet — adults, children, and youth, Ashkelon"],"siteAddresses":["11 HaGavora, Ashkelon"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '378|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת — מבוגרים, ילדים ונוער, אשקלון'
WHERE entry_id = 'הגבורה_378';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"mental health clinic Ashkelon (Barzilai)","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Ashkelon","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: HaHistadrut 2 Ashkelon (Bavaniin Barzilai Hospital).","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '379|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת — מבוגרים, אשקלון"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet — adults, Ashkelon","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ashkelon","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet — adults, Ashkelon"],"siteAddresses":["6 Akasodos, Ashkelon"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '380|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת — מבוגרים, אשקלון'
WHERE entry_id = 'נווה_דקלים_380';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת — ילדים ונוער, אשקלון"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet — children and youth, Ashkelon","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Ashkelon","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet — children and youth, Ashkelon"],"siteAddresses":["5 Kivots Galoiot, Ashkelon"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '381|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת — ילדים ונוער, אשקלון'
WHERE entry_id = 'קיבוץ_גלויות_381';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית, באקה אל ע''רביה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Baqa al-Gharbiyye","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Baqa al-Gharbiyye","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: street main, Baqa al-Gharbiyye.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '382|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, באקה אל ע''רביה'
WHERE entry_id = 'בריאות_הנפש_ילדים_באקה_אל_ע_רביה_382';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Asaf HaRof - mental health clinic","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Be''er Yaakov","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"treatment Bacholim Am chronic medical problems","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: dynamic.","phoneLabel":"Phone","siteLabels":["Asaf HaRof - mental health clinic"],"siteAddresses":["Tsarifin, Be''er Yaakov"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '383|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"באר יעקב, בית החולים באר יעקב"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Be''er Yaakov, Be''er Yaakov hospital","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Be''er Yaakov hospital","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Be''er Yaakov hospital. Treatment methods: group treatment, individual Vadayaydi dynamic, CBT.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '384|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'באר יעקב, בית החולים באר יעקב'
WHERE entry_id = 'מבוגרים_באר_יעקב_384';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי — מבוגרים, ילדים ונוער, באר שבע"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi — adults, children, and youth, Be''er Sheva","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Be''er Sheva","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","specialty":"eating disorders","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 30 Yohana Zivotinasaki, Be''er Sheva.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '385|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי — מבוגרים, ילדים ונוער, באר שבע'
WHERE entry_id = 'באר_שבע_הפרעות_אכילה_נוער_ומבוגרים_385';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי — מבוגרים, באר שבע"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi — adults, Be''er Sheva","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Be''er Sheva","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Maccabi — adults, Be''er Sheva"],"siteAddresses":["31 Beit Al, Be''er Sheva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '386|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי — מבוגרים, באר שבע'
WHERE entry_id = 'באר_שבע_ט_מבוגרים_386';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי — ילדים ונוער, באר שבע"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi — children and youth, Be''er Sheva","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Be''er Sheva","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Maccabi — children and youth, Be''er Sheva"],"siteAddresses":["2 HaRav Herzog, Be''er Sheva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '387|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי — ילדים ונוער, באר שבע'
WHERE entry_id = 'באר_שבע_יא_נוער_ומתבגרים_387';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, באר שבע"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Be''er Sheva","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Be''er Sheva","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Be''er Sheva"],"siteAddresses":["Be''er Sheva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '388|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, באר שבע'
WHERE entry_id = 'לב_הסיטי_388';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"המרכז לבריאות הנפש באר שבע — מבוגרים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Be''er Sheva Mental Health Center — adults","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Be''er Sheva","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"rehabilitation, treatment Bahafaraot Shina, treatment Bataraoma Vafosat-trauma, dual diagnosis","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: group, CBT.","phoneLabel":"Phone","siteLabels":["Be''er Sheva Mental Health Center — adults"],"siteAddresses":["2 HaTzadik miYerushalayim, Be''er Sheva, Be''er Sheva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '389|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'המרכז לבריאות הנפש באר שבע — מבוגרים'
WHERE entry_id = 'מבוגרים_389';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"המרכז לבריאות הנפש באר שבע — ילדים ונוער"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Be''er Sheva Mental Health Center — children and youth","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Be''er Sheva","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"a response to a range of conditions emotional/mental Liladim Batavakh Giliim 6 - 18, assessment veTreatment Rav Marakhati Bamasagarat ''''day treatment'''', an opinion Mashafatit","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: treatment Rafoai,psychotherapy individual, parent guidance, group Bamasagarat ''''day treatment'''', treatment supportive Bamarafat Makav, CBT.","phoneLabel":"Phone","siteLabels":["Be''er Sheva Mental Health Center — children and youth"],"siteAddresses":["13 Wolfson, Be''er Sheva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '390|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'המרכז לבריאות הנפש באר שבע — ילדים ונוער'
WHERE entry_id = 'מרפאת_ילדים_ונוער_מרכז_טל_390';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Soroka-day treatment eating disorders","svc":"Multidisciplinary mental health clinic","target":"Youth day treatment","region":"Be''er Sheva","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Soroka-day treatment eating disorders"],"siteAddresses":["151 Rager, Be''er Sheva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '391|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Soroka-day treatment adults","svc":"Multidisciplinary mental health clinic","target":"Adult day treatment","region":"Be''er Sheva","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Soroka-day treatment adults"],"siteAddresses":["151 Rager, Be''er Sheva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '392|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Soroka-Marafaot-children","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Be''er Sheva","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Soroka-Marafaot-children"],"siteAddresses":["151 Rager, Be''er Sheva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '393|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Soroka-Marafaot-adults","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Be''er Sheva","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Soroka-Marafaot-adults"],"siteAddresses":["151 Rager, Be''er Sheva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '394|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Soroka-clinic eating disorders","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Be''er Sheva","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Soroka-clinic eating disorders"],"siteAddresses":["151 Rager, Be''er Sheva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '395|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"המרכז לבריאות הנפש באר שבע — פסיכוגריאטריה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Be''er Sheva Mental Health Center — psychogeriatrics","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Be''er Sheva","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"HaTaravoiot Miochadot: 1. an opinion Laminoi Afotarofos 2. an opinion Kalinit Lahagashat Chok Siaod 3. an opinion Lahatamat Masagarat 4. HaGasha veHaTsag","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: there is a support group for family members- no waiting list - immediate admission.","phoneLabel":"Phone","siteLabels":["Be''er Sheva Mental Health Center — psychogeriatrics"],"siteAddresses":["2 HaTzadik miYerushalayim, Be''er Sheva, Be''er Sheva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '396|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'המרכז לבריאות הנפש באר שבע — פסיכוגריאטריה'
WHERE entry_id = 'שם_המרפאה_פסיכוגריאטריה_396';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"שער מנשה, בי\"ח שער מנשה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Sha''ar Menashe, Sha''ar Menashe hospital","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Sha''ar Menashe hospital","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"CBT","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Hospital Sha''ar Menashe, Sha''ar Menashe hospital.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '397|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'שער מנשה, בי"ח שער מנשה'
WHERE entry_id = 'מרפאה_לברה_נ_עירון_מבוגרים_397';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית, צמוד למרפאת בית שאן ג''"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, next to Beit She''an clinic C","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"next to Beit She''an clinic C","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 27 Jerusalem HaBira, next to Beit She''an clinic C.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '398|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, צמוד למרפאת בית שאן ג'''
WHERE entry_id = 'מרכז_בריאות_הנפש_בית_שאן_398';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, בית שמש"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Beit Shemesh","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Beit Shemesh","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Beit Shemesh"],"siteAddresses":["36 HaRakafat, Beit Shemesh"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '399|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, בית שמש'
WHERE entry_id = 'הגבעה_399';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"המרכז הירושלמי לבריאות הנפש — ילדים ונוער, בית שמש"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jerusalem Mental Health Center — children and youth, Beit Shemesh","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Beit Shemesh","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: a parents group,couples therapy, family, parent guidance, CBT, crisis intervention.","phoneLabel":"Phone","siteLabels":["Jerusalem Mental Health Center — children and youth, Beit Shemesh"],"siteAddresses":["6 Arlozorov, Beit Shemesh"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '400|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'המרכז הירושלמי לבריאות הנפש — ילדים ונוער, בית שמש'
WHERE entry_id = 'ילדים_ונוער_בית_שמש_400';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"המרכז הירושלמי לבריאות הנפש — מבוגרים, בית שמש"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jerusalem Mental Health Center — adults, Beit Shemesh","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Beit Shemesh","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: Zogi Vamishafachati.","phoneLabel":"Phone","siteLabels":["Jerusalem Mental Health Center — adults, Beit Shemesh"],"siteAddresses":["6 Arlozorov, Beit Shemesh"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '401|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'המרכז הירושלמי לבריאות הנפש — מבוגרים, בית שמש'
WHERE entry_id = 'מבוגרים_בית_שמש_401';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — מבוגרים, בית שמש"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — adults, Beit Shemesh","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Beit Shemesh","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 1 Sderot Ygal Alon, center Big, Beit Shemesh. Treatment methods: dynamic therapy Arokh, treatment Bin Ayshi short-term, couples therapy, CBT.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '402|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — מבוגרים, בית שמש'
WHERE entry_id = 'מרכז_לבריאות_הנפש_למבוגרים_בית_שמש_402';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — ילדים ונוער, בית שמש"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — children and youth, Beit Shemesh","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Beit Shemesh","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 1 Sderot Ygal Alon, floor 3, Beit Shemesh. Treatment methods: dynamic therapy,parent guidance,crisis intervention,psychiatric follow-up-medication,treatment CBT.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '403|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — ילדים ונוער, בית שמש'
WHERE entry_id = 'מרכז_לבריאות_לנפש_לילדים_בית_שמש_403';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Beit Cham - Beit Shemesh","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Beit Shemesh","cost":"Health basket — Clalit, Maccabi, Meuhedet, and Leumit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Nonprofit — a provider under contract with a health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: Beit Cham. Treatment methods: psychiatric treatment Pasikhologi Varagashi. dynamic. psychotherapy,parent guidance,the rehabilitation basket,treatment CBT.","phoneLabel":"Phone","siteLabels":["Beit Cham - Beit Shemesh"],"siteAddresses":["6 Nahar HaYarden, Beit Shemesh"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '404|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת — מבוגרים, ילדים ונוער, ביתר"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet — adults, children, and youth, Beitar","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Beitar","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: HaRan, Beitar.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '405|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת — מבוגרים, ילדים ונוער, ביתר'
WHERE entry_id = 'הרן_405';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת — מבוגרים, ביתר"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet — adults, Beitar","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Beitar","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 1 Yshamach Israel, Beitar.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '406|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת — מבוגרים, ביתר'
WHERE entry_id = 'התמרים_406';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Bari-mental health - Bnei Brak","svc":"Multidisciplinary mental health clinic","target":"Adult day treatment, adults","region":"Bnei Brak","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Bari-mental health - Bnei Brak"],"siteAddresses":["5 Bari, Bnei Brak"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '407|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"mental health children and youth - Bnei Brak (Maiini HaYshoaa)","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Bnei Brak","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"treatment Bahafaraot Akhila, people affected by sexual assault, encopresis","notes":"Ownership: Public nonprofit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: individual psychotherapy, group psychotherapy, family therapy, Tifoli CBT, art therapy, music therapy, psychological assessment, assessment P.","phoneLabel":"Phone","siteLabels":["mental health children and youth - Bnei Brak (Maiini HaYshoaa)"],"siteAddresses":["17 Povarasaki, Bnei Brak"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '408|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"mental health adults - Bnei Brak (Maiini HaYshoaa)","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Bnei Brak","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"treatment Bahafaraot Akhila, an anxiety clinic, clinic Lanafagai Takifa, psychogeriatrics, treatment Bamavogarim Al Ratsaf Aasd","notes":"Ownership: Public nonprofit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: individual psychotherapy, group psychotherapy, family therapy, couples counseling, Tifoli CBT, art therapy, music therapy, assessment Pasikholav.","phoneLabel":"Phone","siteLabels":["mental health adults - Bnei Brak (Maiini HaYshoaa)"],"siteAddresses":["17 Povarasaki, Bnei Brak"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '409|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, בני ברק"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Bnei Brak","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Bnei Brak","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 4 HaRav Ya''akov Lanad, Bnei Brak.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '410|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, בני ברק'
WHERE entry_id = 'מרום_שיר_410';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Beit Cham - Bnei Brak","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Bnei Brak","cost":"Health basket — Clalit, Maccabi, Meuhedet, and Leumit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Nonprofit — a provider under contract with a health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: Beit Cham.","phoneLabel":"Phone","siteLabels":["Beit Cham - Bnei Brak"],"siteAddresses":["72 Kahanaman, Bnei Brak"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '411|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-5552620","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: מרכז ממשלתי לבריאות הנפש (משרד הבריאות). הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: מאגר מרפאות בריאות הנפש של משרד הבריאות, עדכון 28.12.2025. שלוחה 1."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Abarbanel - day treatment adults","svc":"Multidisciplinary mental health clinic","target":"Adult day treatment","region":"Bat Yam","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Extension 1.","phoneLabel":"Phone","siteLabels":["Abarbanel - day treatment adults"],"siteAddresses":["Kakal 15 Bat-Ym, Bat Yam"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '412|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-5552620","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: מרכז ממשלתי לבריאות הנפש (משרד הבריאות). הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: מאגר מרפאות בריאות הנפש של משרד הבריאות, עדכון 28.12.2025. שלוחה 1."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Abarbanel - day treatment youth","svc":"Multidisciplinary mental health clinic","target":"Youth day treatment","region":"Bat Yam","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Extension 1.","phoneLabel":"Phone","siteLabels":["Abarbanel - day treatment youth"],"siteAddresses":["Kakal 15 Bat-Ym, Bat Yam"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '413|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Yoseftal","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Bat Yam","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Yoseftal"],"siteAddresses":["82 Yoseftal, Bat Yam"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '414|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-5552620","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: מרכז ממשלתי לבריאות הנפש (משרד הבריאות). הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. שיטות טיפול: טיפול פסיכיאטרי - תרופתי ומעקב רופא; פסיכותרפיה פרטנית וקבוצתית במגוון שיטות; סל שיקום; פסיכיאטריה משפטית; טיפול זוגי; ה. מקור: מאגר מרפאות בריאות הנפש של משרד הבריאות, עדכון 28.12.2025. שלוחה 1."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"clinic Bat-Ym adults, center Barahan Ash I. Abarbanel","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Bat Yam","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"Ychidat anxiety disorders; Ychidat Bikori Vatifoli Beit; psychotherapy Aynatanasivit Lahafaraot Kashot; Ychida Kariminologit - HaArakhot Masokhanot, Ti","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Extension 1. Treatment methods: psychiatric treatment - medication Vamakav Rof; individual psychotherapy Vakavotsatit Bamagavan Shitot; the rehabilitation basket; forensic psychiatry; couples therapy; A.","phoneLabel":"Phone","siteLabels":["clinic Bat-Ym adults, center Barahan Ash I. Abarbanel"],"siteAddresses":["Kakal 15 Bat-Ym, Bat Yam"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '415|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"clinic children and youth \"Nitzanim, Hospital \"Abarbanel","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Bat Yam","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"Kiimot Tat Ychadot HaMatamachot Batachomim HaBaym: 1. an attention-disorder unit, HaYchida Lavachon veTreatment Bahafaraot attention including assessment Mamochashav (Rak Lafi Hats","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: individual treatment Liladim and youth including Baorinatatsiia Danamit,,treatment CBT, parent guidance, group treatment Liladim Valahorim, treatment Bamatsaot Mashach.","phoneLabel":"Phone","siteLabels":["clinic children and youth \"Nitzanim, Hospital \"Abarbanel"],"siteAddresses":["Kakal 15 Bat Yam"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '416|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, גבעת שמואל"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Givat Shmuel","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Givat Shmuel","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Givat Shmuel"],"siteAddresses":["31 Yoni Netanyahu, Givat Shmuel"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '417|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, גבעת שמואל'
WHERE entry_id = 'הגבעה_417';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית, דימונה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Dimona","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Dimona","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 1 Layaon Baranahiim, Dimona. Treatment methods: dynamic + short-term, cbt, crisis intervention.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '418|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, דימונה'
WHERE entry_id = 'דימונה_418';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, דלית אל כרמל"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Daliyat al-Karmel","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Daliyat al-Karmel","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Rach main, Daliyat al-Karmel.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '419|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, דלית אל כרמל'
WHERE entry_id = 'דלית_אל_כרמל_419';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, הוד השרון"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Hod HaSharon","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Hod HaSharon","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Yehushoa Ben Gamal 25 B, Hod HaSharon.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '420|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, הוד השרון'
WHERE entry_id = 'הוד_השרון_420';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Shalvata-day treatment adults","svc":"Multidisciplinary mental health clinic","target":"Adult day treatment","region":"Hod HaSharon","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Shalvata-day treatment adults"],"siteAddresses":["13 Aliit HaNoar, Hod HaSharon"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '421|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Shalvata-Marafaot-children","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Hod HaSharon","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Shalvata-Marafaot-children"],"siteAddresses":["13 Aliit HaNoar, Hod HaSharon"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '422|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Shalvata-Marafaot-adults","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Hod HaSharon","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Shalvata-Marafaot-adults"],"siteAddresses":["13 Aliit HaNoar, Hod HaSharon"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '423|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, הרצליה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Herzliya","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Herzliya","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 8 Shad Ya''akov Lanatsat, Herzliya.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '424|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, הרצליה'
WHERE entry_id = 'הרצליה_424';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"09-9528450","phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי — ילדים ונוער, הרצליה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi — children and youth, Herzliya","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Herzliya","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Maccabi — children and youth, Herzliya"],"siteAddresses":["HaSharon 7 Herzliya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '425|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי — ילדים ונוער, הרצליה'
WHERE entry_id = 'הרצליה_ילדים_ונוער_425';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"09-9528461","phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי — מבוגרים, הרצליה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi — adults, Herzliya","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Herzliya","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: women''s mental health.","phoneLabel":"Phone","siteLabels":["Maccabi — adults, Herzliya"],"siteAddresses":["HaSharon 7 Herzliya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '426|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי — מבוגרים, הרצליה'
WHERE entry_id = 'הרצליה_מבוגרים_426';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Herzliya - children and youth","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Herzliya","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: medication, individual, dynamic, CBT family, parent guidance.","phoneLabel":"Phone","siteLabels":["Herzliya - children and youth"],"siteAddresses":["2 HaDar, Herzliya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '427|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Herzliya - adults","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Herzliya","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"group/ ACT,DBT Kavotsat Tsairim Gil HaShalishi Kavotsat Somatiim veHaTaroganiot veTreatment Banafagaot sexual assault","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: medication, individual (dynamic, CBT, schema therapy, 12 steps),preparation for a rehabilitation basket.","phoneLabel":"Phone","siteLabels":["Herzliya - adults"],"siteAddresses":["2 HaDar, Herzliya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '428|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Herzliya - adults- Makav","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Herzliya","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"Kavotsat Matamodadim Tsairim","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: medication, individual, Yaots Lamashafachot veHaTamat Tokhaniot HaTaravot Marakhatiot Am Rafaratoar Gorami rehabilitation veHaKana Lasali rehabilitation.","phoneLabel":"Phone","siteLabels":["Herzliya - adults- Makav"],"siteAddresses":["2 HaDar, Herzliya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '429|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית, הרצליה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Herzliya","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Herzliya","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 10 HaRi HaGolan, Herzliya.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '430|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, הרצליה'
WHERE entry_id = 'מרכז_בריאות_בנפש_ילדים_ונוער_הרצליה_430';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Beit Cham - Zikhron Ya''akov","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Zikhron Ya''akov","cost":"Health basket — Clalit, Maccabi, Meuhedet, and Leumit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Nonprofit — a provider under contract with a health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: Beit Cham. Address: 62 Rach HaMiisadim, Zikhron Ya''akov.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '431|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"04-6304835","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים ממשלתי. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. שיטות טיפול: טיפול פסיכותרפויטי פרטני דינמי/אינטגרטיבי; התערבות במשבר; CBT; טיפול זוגי; טיפול שיקומי; טיפול במוזיקה; טיפול קבוצתי; הפ. מקור: מאגר מרפאות בריאות הנפש של משרד הבריאות, עדכון 28.12.2025. כתובת: רחוב השלום, חדרה. שלוחה 6.","org":"הלל יפה, חדרה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Hillel Yaffe, Hadera","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Hadera","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"treatment B PTSD (including EMDR, PE); treatment Banafagai Min","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: street HaShalom, Hadera. Extension 6. Treatment methods: treatment Pasikhotarafoiti individual dynamic/Aynatagarativi; crisis intervention; CBT; couples therapy; treatment rehabilitative; music therapy; group treatment; Haf.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '432|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'הלל יפה, חדרה'
WHERE entry_id = 'ברה_ן_מבוגרים_432';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, חדרה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Hadera","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Hadera","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Hadera"],"siteAddresses":["21 Herzl, Hadera"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '433|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, חדרה'
WHERE entry_id = 'חדרה_433';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"04-6304835","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים ממשלתי. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: מאגר מרפאות בריאות הנפש של משרד הבריאות, עדכון 28.12.2025. כתובת: רחוב השלום, חדרה. שלוחה 6.","org":"הלל יפה, חדרה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Hillel Yaffe, Hadera","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Hadera","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"psychogeriatric assessment; treatment Pasikhotarafi individual Vakavotsati; treatment B PTSD","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: street HaShalom, Hadera. Extension 6.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '434|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'הלל יפה, חדרה'
WHERE entry_id = 'יחידה_פסיכוגריאטרית_434';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — ילדים ונוער, חדרה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — children and youth, Hadera","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Hadera","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Clalit — children and youth, Hadera"],"siteAddresses":["70 Sderot Rothschild, Hadera"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '435|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — ילדים ונוער, חדרה'
WHERE entry_id = 'מרכז_בריאות_הנפש_ילדים_ונוער_חדרה_435';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"כללית — מבוגרים, חדרה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — adults, Hadera","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Hadera","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Clalit — adults, Hadera"],"siteAddresses":["70 Sderot Rothschild, Hadera"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '436|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — מבוגרים, חדרה'
WHERE entry_id = 'מרכז_בריאות_הנפש_מבוגרים_חדרה_436';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"04-6337099","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים ממשלתי. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. שיטות טיפול: הדרכת הורים, טיפול דיאדי, פסיכותרפיה פרטנים לסוגיהם, טיפול באומנות, טיפול ומעקב פסיכיאטרי. מקור: מאגר מרפאות בריאות הנפש של משרד הבריאות, עדכון 28.12.2025. כתובת: הנשיא 2 פינת רמבם 26, חדרה. שלוחה 4.","org":"הלל יפה — ילדים ונוער"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Hillel Yaffe — children and youth","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Hadera","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"Matafalim Bamagavan Rachav Maod Shal HaHafaraot","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 26 HaNasi 2 Pinat Ramavam, Hadera. Extension 4. Treatment methods: parent guidance, dyadic therapy, psychotherapy Paratanim Lasogiham, art therapy, treatment Vamakav psychiatric.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '437|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'הלל יפה — ילדים ונוער'
WHERE entry_id = 'תחנה_לבריאות_הנפש_ילדים_ונוער_437';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Holon - children and youth","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Holon","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"families with many difficulties","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: individual treatment group parent guidance treatment HaVara Ylad treatment Bahavaa therapeutic mentoring CBT treatment Mamokad Vamogaval Bazaman.","phoneLabel":"Phone","siteLabels":["Holon - children and youth"],"siteAddresses":["34A Tarzav, Holon"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '438|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Holon - adults","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Holon","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"Ychida Latifol Banashim Am Dagash Al pregnancy, fertility Valida","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: individual treatment group CBT dynamic Katsar Vamamoshakh veTreatment Mamokad Miidi Lamatsavi Mashavar case management (CM ) Vasal rehabilitation veTreatment Bahavaa.","phoneLabel":"Phone","siteLabels":["Holon - adults"],"siteAddresses":["34A Tarzav, Holon"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '439|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, חולון"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Holon","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Holon","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Holon"],"siteAddresses":["45 Kogal, Holon"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '440|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, חולון'
WHERE entry_id = 'קוגל_440';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, חיפה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Haifa","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Haifa","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 3 Samolanasaki, Haifa.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '441|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, חיפה'
WHERE entry_id = 'אחוזה_441';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — ילדים ונוער, חיפה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — children and youth, Haifa","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Haifa","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Clalit — children and youth, Haifa"],"siteAddresses":["18 HaNeviim, Haifa"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '442|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — ילדים ונוער, חיפה'
WHERE entry_id = 'ארמון_מרפאה_לטיפול_בילד_ובנוער_חיפה_442';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת — מבוגרים, חיפה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet — adults, Haifa","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Haifa","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet — adults, Haifa"],"siteAddresses":["5 Chasan Shokari, Haifa"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '443|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת — מבוגרים, חיפה'
WHERE entry_id = 'בית_מאי_443';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Bani Tsion - mental health clinic","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Haifa","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"people affected by sexual assault, a gender clinic (Taranasaganadarim), clinic bariatric, psychogeriatrics","notes":"Ownership: Municipal-government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: CBT, EMDR, family therapy.","phoneLabel":"Phone","siteLabels":["Bani Tsion - mental health clinic"],"siteAddresses":["47 Golomav, Haifa"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '444|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, חיפה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Haifa","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Haifa","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 6 Sam Atalit, Haifa.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '445|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, חיפה'
WHERE entry_id = 'הדר_445';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי — מבוגרים, חיפה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi — adults, Haifa","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Haifa","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Maccabi — adults, Haifa"],"siteAddresses":["73 Herzl, Haifa"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '446|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי — מבוגרים, חיפה'
WHERE entry_id = 'חיפה_הדר_מבוגרים_446';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי, חיפה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi, Haifa","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Haifa","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","specialty":"eating disorders","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Maccabi, Haifa"],"siteAddresses":["54 Shamacha Golan, Haifa"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '447|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי, חיפה'
WHERE entry_id = 'חיפה_הפרעות_אכילה_ילדים_447';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי, חיפה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi, Haifa","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Haifa","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: family,individual,dyadic,CBT,group,Tarafia Amanot.","phoneLabel":"Phone","siteLabels":["Maccabi, Haifa"],"siteAddresses":["54 Shamacha Golan, Haifa"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '448|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי, חיפה'
WHERE entry_id = 'חיפה_ילדים_ונוער_448';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"טירת הכרמל, חיפה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Tirat Carmel, Haifa","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Haifa","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"assessments Vatifolim ASD, crisis intervention, therapeutic mentoring","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: HaArakha Rashonit (intake) Vavaniit Takhanit treatment Kolalanit individual treatment Bamatsaot Mashachak Av Shichot (Af Gil HaYlad Vatsarakhiv) parent guidance T.","phoneLabel":"Phone","siteLabels":["Tirat Carmel, Haifa"],"siteAddresses":["7 Echad HaAm, Haifa"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '449|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'טירת הכרמל, חיפה'
WHERE entry_id = 'חיפה_תחנה_לטיפול_בילד_בנוער_ובמשפחה_449';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"day treatment psychiatric Ramavam","svc":"Multidisciplinary mental health clinic","target":"Adult day treatment","region":"Haifa","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Rach Afaron 1 Haifa. Treatment methods: CBT, DBT, PE, EMDR, Kavotsot Loisot Ragashi, movement therapy, art therapy, occupational therapy, Kavotsat Afiia, Kativa Yotsarat.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '450|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — מבוגרים, חיפה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — adults, Haifa","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Haifa","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 26 Yitzhak Ytsiv, floor 2, Kiryat Chiim, Haifa.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '451|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — מבוגרים, חיפה'
WHERE entry_id = 'מרבך_מרכז_בריאות_הנפש_קרית_חיים_451';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — מבוגרים, חיפה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — adults, Haifa","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Haifa","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Clalit — adults, Haifa"],"siteAddresses":["52 Tsahal, Kiryat Aliazar, Haifa"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '452|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — מבוגרים, חיפה'
WHERE entry_id = 'מרכז_בריאות_הנפש_קרית_אליעזר_452';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — ילדים ונוער, חיפה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — children and youth, Haifa","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Haifa","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 14 Dav Paromar, Haifa.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '453|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — ילדים ונוער, חיפה'
WHERE entry_id = 'מרפאה_לטיפול_בילד_ובנוער_קרית_שמואל_453';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"clinic psychiatric Ramavam children and youth","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Haifa","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"Gof-Nafash, early childhood,","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Rach Afaron 1 Haifa. Treatment methods: dynamic, parent guidance, CBT.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '454|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"clinic psychiatric Ramavam adults","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Haifa","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"eating disorders, anxiety disorders, psychogeriatrics, Ministry of Defense disabled veterans, Pasikhozot Amidot","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Rach Afaron 1 Haifa. Treatment methods: dynamic therapy short-term, CBT, DBT, PE, EMDR, Kavotsot Loisot Ragashi, Kavotsot Lahatamodadot Am Machala veHaChalama, Kavotsat Matofali Lafonakas, Dayat.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '455|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת — ילדים ונוער, חיפה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet — children and youth, Haifa","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Haifa","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 5 Aynatsaranatsional, Haifa.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '456|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת — ילדים ונוער, חיפה'
WHERE entry_id = 'נו_ש_456';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"זיו, טבריה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Ziv, Tiberias","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Tiberias","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Ziv, Tiberias"],"siteAddresses":["Tiberias"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '457|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'זיו, טבריה'
WHERE entry_id = 'בריאות_הנפש_טבריה_457';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — ילדים ונוער, טבריה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — children and youth, Tiberias","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Tiberias","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","specialty":"treatment Lagil HaRakh. Avoda Shitofit Am Makhon HaTafatachot HaYlad.","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: family therapy Vadayadi- veTreatment B-CBT.","phoneLabel":"Phone","siteLabels":["Clalit — children and youth, Tiberias"],"siteAddresses":["10 Moran, Tiberias"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '458|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — ילדים ונוער, טבריה'
WHERE entry_id = 'בריאות_הנפש_ילדים_טבריה_458';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, טבריה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Tiberias","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Tiberias","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Tiberias"],"siteAddresses":["1 Alachadif, Tiberias"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '459|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, טבריה'
WHERE entry_id = 'טבריה_459';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — מבוגרים, טבריה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — adults, Tiberias","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Tiberias","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 38 Alachadif, opposite Masharad HaPanim, Tiberias. Treatment methods: group treatment Lanashim Am anxiety disorders Vadikhaon- cbt, dbt.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '460|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — מבוגרים, טבריה'
WHERE entry_id = 'מרכז_בריאות_הנפש_טבריה_460';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית, טייבה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Tayibe","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Tayibe","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Gashar Lashalom, Tayibe.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '461|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, טייבה'
WHERE entry_id = 'בריאות_הנפש_ילדים_טייבה_461';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Gazalala","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Tira","cost":"Health basket — Clalit and Leumit members (referral from the fund; quarterly co-payment)","notes":"Ownership: External provider under contract with a health fund (ownership not stated). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: Gazalala. Address: Kavish 24 HaMazarachi, Tira. Treatment methods: group treatment V- CBT."}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '462|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"center Lin","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Tira","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","notes":"Ownership: External provider under contract with a health fund (ownership not stated). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: center Lin.","siteLabels":["center Lin"],"siteAddresses":["Tarak Avad Alachi, Tira"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '463|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"טירת הכרמל"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Tirat Carmel","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Tirat Carmel","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"Makav Valivi Matofalim Batsavim Shal a court Tifoli Marafati Kafoi. clinic psychogeriatric day treatment Lamatofim Kashim Latsorakh Maniat Ashafozi","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: psychiatric follow-up veTreatment HaTarofati intake Rav Makatsoai Kavalat Matofalim Shal CRISIS Lal Tor Matan an opinion for the courts Tifolim Parataniim( B.","phoneLabel":"Phone","siteLabels":["Tirat Carmel"],"siteAddresses":["17 HaAla, Tirat Carmel"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '464|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'טירת הכרמל'
WHERE entry_id = 'מרפאה_מבוגרים_מרכז_רפואי_לברה_נ_מעלה_הכרמל_464';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"טירת הכרמל"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Tirat Carmel","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Tirat Carmel","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"psychogeriatrics (Tat-Ychida Shal clinic HaMavogarim)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Tirat Carmel"],"siteAddresses":["17 HaAla, Tirat Carmel"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '465|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'טירת הכרמל'
WHERE entry_id = 'מרפאה_פסיכוגריאטריה_מרכז_רפואי_לברה_נ_מעלה_הכרמל_465';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"טירת הכרמל — ילדים ונוער"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Tirat Carmel — children and youth","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Tirat Carmel","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"Ychida Latifol Biladim Vamatavagarim deaf people Vakhavadi Shamiaa( assessment, HaArakha, treatment Biladim veHaVarim, Matan a response Liladim Shamoaim Lahorim HaRashim,","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: intake Rav Makatsoai Badikat Mion Bashaot Bokar a psychiatric evaluation Vachachot Dat for the courts psychiatric follow-up veTreatment HaTarofati Yaots Pasikhayatar.","phoneLabel":"Phone","siteLabels":["Tirat Carmel — children and youth"],"siteAddresses":["17 HaAla, Tirat Carmel"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '466|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'טירת הכרמל — ילדים ונוער'
WHERE entry_id = 'מרפאת_ילדים_ונוער_מרכז_רפואי_לברה_נ_מעלה_הכרמל_466';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — ילדים ונוער, יבנה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — children and youth, Yavne","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Yavne","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Clalit — children and youth, Yavne"],"siteAddresses":["6 HaDekel, Yavne"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '467|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — ילדים ונוער, יבנה'
WHERE entry_id = 'יבנה_ילדים_467';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — מבוגרים, יבנה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — adults, Yavne","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Yavne","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Clalit — adults, Yavne"],"siteAddresses":["6 HaDekel, Yavne"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '468|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — מבוגרים, יבנה'
WHERE entry_id = 'יבנה_מבוגרים_468';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"באר יעקב, יבנה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Be''er Yaakov, Yavne","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Yavne","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: group treatment veTreatment individual dynamic.","phoneLabel":"Phone","siteLabels":["Be''er Yaakov, Yavne"],"siteAddresses":["16 HaAoran, Yavne"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '469|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'באר יעקב, יבנה'
WHERE entry_id = 'מבוגרים_יבנה_469';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית, יקנעם"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Yokneam","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Yokneam","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Clalit, Yokneam"],"siteAddresses":["44 HaAoranim, Yokneam"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '470|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, יקנעם'
WHERE entry_id = 'יקנעם_470';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Tsipor HaNefesh-clinic Yokanam","svc":"Multidisciplinary mental health clinic","target":"Children and youth, adults","region":"Yokneam","cost":"Health basket — Leumit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 20 HaRadofim, Yokneam.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '471|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Jerusalem"],"siteAddresses":["21 Patachia, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '472|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, ירושלים'
WHERE entry_id = 'ארזי_הבירה_472';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Jerusalem"],"siteAddresses":["208 Jaffa, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '473|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, ירושלים'
WHERE entry_id = 'בית_אגד_473';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת — מבוגרים, ילדים ונוער, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet — adults, children, and youth, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Jerusalem","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet — adults, children, and youth, Jerusalem"],"siteAddresses":["35 HaPasaga, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '474|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת — מבוגרים, ילדים ונוער, ירושלים'
WHERE entry_id = 'בית_וגן_474';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Barazil Talavia-mental health center - Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: dynamic therapy Arokh, treatment Bamashavar, couples therapy, CBT.","phoneLabel":"Phone","siteLabels":["Barazil Talavia-mental health center - Jerusalem"],"siteAddresses":["34 Barazil, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '475|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Adult day treatment","region":"Jerusalem","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","specialty":"clinic Aynatanasivit","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: treatment crisis intervention, psychotherapy dynamic, Aos, rehabilitation, family intervention, bibliotherapy, Aomanot, Tanoaa, anxiety Bakavotsot, DBT, medication treatment.","phoneLabel":"Phone","siteLabels":["Clalit, Jerusalem"],"siteAddresses":["34 Barazil, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '476|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, ירושלים'
WHERE entry_id = 'ברזיל_טיפול_יום_ירושלים_476';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Jerusalem"],"siteAddresses":["800 Tsavia veYitzhak, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '477|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, ירושלים'
WHERE entry_id = 'גילה_477';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Jerusalem"],"siteAddresses":["2 Beitar, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '478|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, ירושלים'
WHERE entry_id = 'הטיילת_478';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"המרכז הירושלמי לבריאות הנפש — ילדים ונוער"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jerusalem Mental Health Center — children and youth","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Jerusalem","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"early childhood","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: family, dyadic, Tarayadi, short-term Mamokad Ychasi HaVara-Ylad.","phoneLabel":"Phone","siteLabels":["Jerusalem Mental Health Center — children and youth"],"siteAddresses":["17 Marakhos, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '479|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'המרכז הירושלמי לבריאות הנפש — ילדים ונוער'
WHERE entry_id = 'היחידה_לגיל_הרך_479';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"המרכז הירושלמי לבריאות הנפש, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jerusalem Mental Health Center","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"addictions Vatachaloaa Kafola","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Jerusalem Mental Health Center"],"siteAddresses":["19 Yd Charotsim, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '480|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'המרכז הירושלמי לבריאות הנפש, ירושלים'
WHERE entry_id = 'המכון_לטיפול_בבעיות_סמים_ותחלואה_כפולה_480';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"הדסה, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Hadassah, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Jerusalem","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"treatment Bagil HaRakh,HaParaot Takashorat, trauma Bagil HaRakh, attention-deficit disorder, behavior disorders","notes":"Ownership: Hadassah hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: individual,dyadic,parent guidance,medication follow-up, assessment.","phoneLabel":"Phone","siteLabels":["Hadassah, Jerusalem"],"siteAddresses":["Hadassah Ain Karam, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '481|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'הדסה, ירושלים'
WHERE entry_id = 'המרפאה_לגיל_הרך_481';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"הדסה, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Hadassah, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Jerusalem","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"eating disorders","notes":"Ownership: Hadassah hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Hadassah, Jerusalem"],"siteAddresses":["Hadassah Ain Karam, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '482|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'הדסה, ירושלים'
WHERE entry_id = 'המרפאה_להפרעות_אכילה_482';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"הדסה, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Hadassah, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Jerusalem","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Hadassah hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Hadassah, Jerusalem"],"siteAddresses":["Hadassah Ain Karam, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '483|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'הדסה, ירושלים'
WHERE entry_id = 'המרפאה_להתערבות_במשבר_483';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"הדסה, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Hadassah, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Jerusalem","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"children Shanachashafav Layroai trauma","notes":"Ownership: Hadassah hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: psychotherapy trauma-focused, DBT group, CBT.","phoneLabel":"Phone","siteLabels":["Hadassah, Jerusalem"],"siteAddresses":["Hadassah Ain Karam, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '484|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'הדסה, ירושלים'
WHERE entry_id = 'המרפאה_לילדים_ומתבגרים_לאחר_טראומה_484';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"הדסה, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Hadassah, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Jerusalem","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"ADHD, behavior disorders,","notes":"Ownership: Hadassah hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: individual,parent guidance, dyadic, CBT,family.","phoneLabel":"Phone","siteLabels":["Hadassah, Jerusalem"],"siteAddresses":["Hadassah Ain Karam, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '485|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'הדסה, ירושלים'
WHERE entry_id = 'המרפאה_למתבגרים_6_18_485';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — מבוגרים, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — adults, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: dynamic therapy Arokh, treatment Bin Ayshi short-term, couples therapy, CBT.","phoneLabel":"Phone","siteLabels":["Clalit — adults, Jerusalem"],"siteAddresses":["Sha''ar HaPrachim, HaIr HaAtika, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '486|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — מבוגרים, ירושלים'
WHERE entry_id = 'העיר_העתיקה_מרפאה_לבריאות_הנפש_מבוגרים_ירושלים_486';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת — ילדים ונוער, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet — children and youth, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Jerusalem","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet — children and youth, Jerusalem"],"siteAddresses":["36 Alihav Koran, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '487|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת — ילדים ונוער, ירושלים'
WHERE entry_id = 'הר_חומה_487';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Vinik Talavia - mental health center adults - Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Binyamin Disharali 17 neighborhood Talavia, Jerusalem.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '488|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Adult day treatment","region":"Jerusalem","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 17 Binyamin Disharali, neighborhood Talavia, Jerusalem. Treatment methods: treatment crisis intervention, psychotherapy dynamic, Aos, rehabilitation, family intervention, bibliotherapy, Aomanot, Tanoaa, anxiety Bakavotsot, DBT, medication treatment.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '489|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, ירושלים'
WHERE entry_id = 'ויניק_טיפול_יום_מבוגרים_ירושלים_489';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"המרכז הירושלמי לבריאות הנפש — ילדים ונוער"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jerusalem Mental Health Center — children and youth","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Jerusalem","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"therapeutic mentoring","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: family, dyadic, dynamic, parent guidance, cbt, dbt.","phoneLabel":"Phone","siteLabels":["Jerusalem Mental Health Center — children and youth"],"siteAddresses":["36 Yanosh Koratsak, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '490|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'המרכז הירושלמי לבריאות הנפש — ילדים ונוער'
WHERE entry_id = 'ילדים_ונוער_ק_יובל_490';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Jerusalem"],"siteAddresses":["2 Ychazakal, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '491|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, ירושלים'
WHERE entry_id = 'כיכר_השבת_491';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"המרכז הירושלמי לבריאות הנפש, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jerusalem Mental Health Center","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Jerusalem Mental Health Center"],"siteAddresses":["HaNorit, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '492|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'המרכז הירושלמי לבריאות הנפש, ירושלים'
WHERE entry_id = 'מבוגרים_הנורית_פרוייקט_י_ש_492';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"adults Kfar Shaul","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"forensic psychiatry, treatment Batsav Latamakh","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Hospital Kfar Shaul, Jerusalem. Treatment methods: family.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '493|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"המרכז הירושלמי לבריאות הנפש, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jerusalem Mental Health Center","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: treatment Bamashavar psychotic Rashon, crisis intervention, an anxiety team, couples therapy Vamashafachati, Tifolim Aorakhi Tavach including DBT Vasakhama Tifolim Kavotsat.","phoneLabel":"Phone","siteLabels":["Jerusalem Mental Health Center"],"siteAddresses":["36 Yanosh Koratsak, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '494|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'המרכז הירושלמי לבריאות הנפש, ירושלים'
WHERE entry_id = 'מבוגרים_ק_יובל_494';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"המרכז הירושלמי לבריאות הנפש, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jerusalem Mental Health Center","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"treatment Baokhalosia HaAravit- East Jerusalem","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Hospital Kfar Shaul, Jerusalem. Treatment methods: crisis intervention, couples therapy Vamashafachati,CBT, DBT, applying to the rehabilitation basket.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '495|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'המרכז הירושלמי לבריאות הנפש, ירושלים'
WHERE entry_id = 'מבוגרים_שייח_ג_ראח_מזרח_ירושלים_495';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"המרכז הירושלמי לבריאות הנפש, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jerusalem Mental Health Center","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: DBT CBT crisis intervention couples therapy sexual assault HaKana veHaGasha Lasal rehabilitation.","phoneLabel":"Phone","siteLabels":["Jerusalem Mental Health Center"],"siteAddresses":["31 Shalom Yehuda, Aranona, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '496|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'המרכז הירושלמי לבריאות הנפש, ירושלים'
WHERE entry_id = 'מבוגרים_שלום_יהודה_496';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"המרכז הירושלמי לבריאות הנפש, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jerusalem Mental Health Center","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"treatment Bahafarat Ayshiot Gavolit, crisis intervention","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: CBT,DBT, dynamic therapy individual Vakavotsati.","phoneLabel":"Phone","siteLabels":["Jerusalem Mental Health Center"],"siteAddresses":["24 Kor HaDorot, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '497|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'המרכז הירושלמי לבריאות הנפש, ירושלים'
WHERE entry_id = 'מרכז_לטיפול_יום_אינטנסיבי_497';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"clinic children and youth - Hadassah","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Jerusalem","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Hadassah hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["clinic children and youth - Hadassah"],"siteAddresses":["Hadassah Ain Karam, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '498|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"clinic adults - Hadassah","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"eating disorders; women''s mental health (postpartum depression / pregnancy, pregnancy loss, anxiety Vadikhaon Saviv Tifoli fertility); clinic Noir","notes":"Ownership: Hadassah hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: individual treatment dynamic / supportive; CBT; group treatment; couples therapy; crisis intervention.","phoneLabel":"Phone","siteLabels":["clinic adults - Hadassah"],"siteAddresses":["Hadassah Ain Karam, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '499|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Mashamar HaAm Talavia - Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Jerusalem","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: dynamic therapy,parent guidance,crisis intervention,psychiatric follow-up-medication,treatment CBT.","phoneLabel":"Phone","siteLabels":["Mashamar HaAm Talavia - Jerusalem"],"siteAddresses":["126 Derekh Chavaron, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '500|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Jerusalem"],"siteAddresses":["115 Magali HaRim Loin, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '501|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, ירושלים'
WHERE entry_id = 'סנהדריה_501';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Beit Cham - Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Jerusalem","cost":"Health basket — Clalit, Maccabi, Meuhedet, and Leumit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Nonprofit — a provider under contract with a health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: Beit Cham. Address: King Gorag 16 B, Jerusalem. Treatment methods: psychiatric treatment Pasikhologi Varagashi. dynamic. psychotherapy,parent guidance,the rehabilitation basket, psychotherapy,treatment CBT.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '502|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Panim Mayrot","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Panim Mayrot"],"siteAddresses":["16 Panim Mayrot, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '503|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Shad Masha Diin 106 - mall HaPasaga, Jerusalem.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '504|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, ירושלים'
WHERE entry_id = 'פסגת_זאב_504';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Tsipor HaNefesh-Masilat Ysharim","svc":"Multidisciplinary mental health clinic","target":"Children and youth, adults","region":"Jerusalem","cost":"Health basket — Leumit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Tsipor HaNefesh-Masilat Ysharim"],"siteAddresses":["3 Taromafalador, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '505|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Aorogavai 3 A, Jerusalem.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '506|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, ירושלים'
WHERE entry_id = 'קרית_יובל_506';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Jerusalem"],"siteAddresses":["19 Yramihav, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '507|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, ירושלים'
WHERE entry_id = 'רוממה_507';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת — ילדים ונוער, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet — children and youth, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Jerusalem","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet — children and youth, Jerusalem"],"siteAddresses":["mall Ramot, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '508|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת — ילדים ונוער, ירושלים'
WHERE entry_id = 'רמות_508';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Jerusalem"],"siteAddresses":["Piir Van Pasan, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '509|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, ירושלים'
WHERE entry_id = 'שיח_גראח_509';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — ילדים ונוער, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — children and youth, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Jerusalem","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 5 Kalaramon Ganav, neighborhood Shiikh Garach, Jerusalem. Treatment methods: psychiatric treatment- medication, psychotherapy, parent guidance.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '510|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — ילדים ונוער, ירושלים'
WHERE entry_id = 'שייך_גראח_המרפאה_לבריאות_הנפש_ילדים_ירושלים_510';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, ירושלים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 19 Shamai, Beit Rotashatiin, Jerusalem.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '511|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, ירושלים'
WHERE entry_id = 'שמאי_511';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Tavan north Jerusalem (Herzog)","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Jerusalem","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Public nonprofit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Shamaon Chakham 16 (Kavish Bar Aylan), Jerusalem. Treatment methods: dynamic psychotherapy, CBT, group treatment Latsairim, crisis intervention.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '512|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Tavan north Jerusalem (Herzog) Liladim and youth","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Jerusalem","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"treatment Bafasikhoza Rashona; treatment B ADHD","notes":"Ownership: Public nonprofit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Shamaon Chakham 16 (Kavish Bar Aylan), Jerusalem. Treatment methods: individual treatment, parent guidance, CBT, group treatment.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '513|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"המרכז הירושלמי לבריאות הנפש — ילדים ונוער"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jerusalem Mental Health Center — children and youth","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Jerusalem","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"CPP Lataraoma Bagil HaRakh, Avoda Aynatanasivit Am families Bahan HaHorot HaYna Batsal Machalat Nafash, Momachiot Bavoda Am ASD","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: dyadic, family, CBT.","phoneLabel":"Phone","siteLabels":["Jerusalem Mental Health Center — children and youth"],"siteAddresses":["2 HaChish, Katamon, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '514|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'המרכז הירושלמי לבריאות הנפש — ילדים ונוער'
WHERE entry_id = 'תחנת_אילן_לטיפול_בילד_ובנוער_החי_ש_ירושלים_514';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Tiferet Beit Cham - East Jerusalem","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"East Jerusalem","cost":"Health basket — Clalit and Maccabi members (referral from the fund; quarterly co-payment)","specialty":"HaTaravot Lafagiaot Miniot","notes":"Ownership: Nonprofit — a provider under contract with a health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: Tiferet Beit Cham. Address: 2 street Avav Aoviida, East Jerusalem. Treatment methods: Aos, parent guidance, rehabilitation.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '515|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, ירכא"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Yarka","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Yarka","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Rach main, Yarka.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '516|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, ירכא'
WHERE entry_id = 'ירכא_516';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"center Lin","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Kfar Bara","cost":"Health basket — Clalit and Maccabi members (referral from the fund; quarterly co-payment)","notes":"Ownership: External provider under contract with a health fund (ownership not stated). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: center Lin. Address: 2 Tsalach Aladin, Kfar Bara.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '517|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, כפר כנא"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Kfar Kanna","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Kfar Kanna","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Rach main, Kfar Kanna.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '518|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, כפר כנא'
WHERE entry_id = 'כפר_כנא_518';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית, כפר סבא"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Kfar Saba","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Kfar Saba","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Clalit, Kfar Saba"],"siteAddresses":["2 Sderot Menachem Begin, Kfar Saba"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '519|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, כפר סבא'
WHERE entry_id = 'שכונת_אליעזר_מרכז_בריאות_הנפש_מבוגרים_כפר_סבא_519';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Shalvata-day treatment youth","svc":"Multidisciplinary mental health clinic","target":"Youth day treatment","region":"Kfar Saba","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Shalvata-day treatment youth"],"siteAddresses":["1 Matsada, Kfar Saba"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '520|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"מאוחדת, כפר קרע"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Kfar Qara","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Kfar Qara","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Rach HaMoatsa HaMakomit, Kfar Qara."}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '521|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, כפר קרע'
WHERE entry_id = 'כפר_קרע_521';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, כפר-סבא"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Kfar Saba","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Kfar Saba","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Kfar Saba"],"siteAddresses":["20 HaMiisadim, Kfar Saba"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '522|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, כפר-סבא'
WHERE entry_id = 'כפר_סבא_522';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, כרמיאל"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Karmiel","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Karmiel","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Karmiel"],"siteAddresses":["16 Beit HaKaram, Karmiel"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '523|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, כרמיאל'
WHERE entry_id = 'כרמיאל_523';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מזור, כרמיאל"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Mazor, Karmiel","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Karmiel","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Mazor, Karmiel"],"siteAddresses":["31 HaBaroshim, Karmiel"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '524|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מזור, כרמיאל'
WHERE entry_id = 'תחנה_לטיפול_בילד_ובנוער_כרמיאל_524';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Talam-Karmiel","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Karmiel","cost":"Health basket — Leumit members (referral from the fund; quarterly co-payment)","notes":"Ownership: External provider under contract with a health fund (ownership not stated). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: Talam. Treatment methods: couples therapy, family, parent guidance, T. short-term, CBT.","siteLabels":["Talam-Karmiel"],"siteAddresses":["33 Nashayai Israel, Karmiel"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '525|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"באר יעקב — ילדים ונוער, לוד"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Be''er Yaakov — children and youth, Lod","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Lod","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: individual, group veHaDarakhat parents.","phoneLabel":"Phone","siteLabels":["Be''er Yaakov — children and youth, Lod"],"siteAddresses":["15 Av Hillel Silavar, Lod"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '526|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'באר יעקב — ילדים ונוער, לוד'
WHERE entry_id = 'ילדים_ונוער_לוד_526';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"באר יעקב — מבוגרים, לוד"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Be''er Yaakov — adults, Lod","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Lod","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"post-trauma /DBT/health HaAysha","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: individual dynamic/ CBT/PE / DBT.","phoneLabel":"Phone","siteLabels":["Be''er Yaakov — adults, Lod"],"siteAddresses":["15 Av Hillel Silavar, Lod"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '527|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'באר יעקב — מבוגרים, לוד'
WHERE entry_id = 'מבוגרים_לוד_527';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, מבשרת ציון"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Mevaseret Zion","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Mevaseret Zion","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Mevaseret Zion"],"siteAddresses":["2 Charamon, Mevaseret Zion"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '528|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, מבשרת ציון'
WHERE entry_id = 'חרמון_528';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"זיו — מבוגרים, מג''אר"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Ziv — adults, Maghar","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Maghar","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: neighborhood Manasora, Maghar. Treatment methods: psychotherapy individual Dinamit long-term, crisis intervention, CBT.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '529|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'זיו — מבוגרים, מג''אר'
WHERE entry_id = 'בריאות_הנפש_מג_אר_529';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"זיו — ילדים ונוער, מג''אר"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Ziv — children and youth, Maghar","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Maghar","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Ziv — children and youth, Maghar"],"siteAddresses":["Maghar"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '530|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'זיו — ילדים ונוער, מג''אר'
WHERE entry_id = 'בריאות_הנפש_מג_אר_ילדים_ונוער_530';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"זיו — מבוגרים, מג''דל שמס"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Ziv — adults, Majdal Shams","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Majdal Shams","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: opposite Tachanat Dalak Tarak, Majdal Shams. Treatment methods: psychiatric follow-up.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '531|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'זיו — מבוגרים, מג''דל שמס'
WHERE entry_id = 'בריאות_הנפש_מג_דל_שמס_531';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"זיו — ילדים ונוער, מג''דל שמס"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Ziv — children and youth, Majdal Shams","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Majdal Shams","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Ziv — children and youth, Majdal Shams"],"siteAddresses":["Majdal Shams"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '532|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'זיו — ילדים ונוער, מג''דל שמס'
WHERE entry_id = 'בריאות_הנפש_מג_דל_שמס_ילדים_ונוער_532';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"mental health center - Migdal HaEmek","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Migdal HaEmek","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["mental health center - Migdal HaEmek"],"siteAddresses":["2 HaAla, Migdal HaEmek"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '533|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, מודיעין"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Modi''in","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Modi''in","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Modi''in"],"siteAddresses":["16 Lev HaIr, Modi''in"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '534|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, מודיעין'
WHERE entry_id = 'לב_העיר_534';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"באר יעקב, מודיעין"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Be''er Yaakov, Modi''in","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Modi''in","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: group treatment veTreatment individual dynamic, CBT.","phoneLabel":"Phone","siteLabels":["Be''er Yaakov, Modi''in"],"siteAddresses":["center Masachari \"Lev Re''ut\", Modi''in"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '535|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'באר יעקב, מודיעין'
WHERE entry_id = 'מבוגרים_מודיעין_535';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית, מודיעין"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Modi''in","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Modi''in","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: floor 5.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '536|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, מודיעין'
WHERE entry_id = 'מודיעין_ילדים_ונוער_536';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי, מודיעין ."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi, Modi''in","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Modi''in","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Maccabi, Modi''in"],"siteAddresses":["53 Amak Dotan, Modi''in"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '537|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי, מודיעין .'
WHERE entry_id = 'מודיעין_ילדים_ונוער_537';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, מודיעין"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Modi''in","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Modi''in","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Modi''in"],"siteAddresses":["6 Shamoal HaNavay, Modi''in"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '538|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, מודיעין'
WHERE entry_id = 'שמשוני_538';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Talam Modi''in","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Modi''in","cost":"Health basket — Leumit members (referral from the fund; quarterly co-payment)","notes":"Ownership: External provider under contract with a health fund (ownership not stated). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: Talam. Address: center Masachari Rananim, Modi''in."}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '539|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי, מודיעין עילית"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi, Modi''in Illit","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Modi''in Illit","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Avani Nazar 46 Modi''in Illit..","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '540|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי, מודיעין עילית'
WHERE entry_id = 'מודיעין_ילדים_ונוער_540';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Beit Cham - Modi''in Illit","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Modi''in Illit","cost":"Health basket — Clalit, Maccabi, Meuhedet, and Leumit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Nonprofit — a provider under contract with a health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: Beit Cham. Address: Rach HaShala, Modi''in Illit.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '541|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, מודיעין עילית"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Modi''in Illit","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Modi''in Illit","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 46 Avani Nazar, Modi''in Illit.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '542|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, מודיעין עילית'
WHERE entry_id = 'קריית_ספר_542';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Marakam-Har Chavaron","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Meitarim","cost":"Health basket — Leumit members (referral from the fund; quarterly co-payment)","specialty":"Rav Makatsoait Varav Tachomit","notes":"Ownership: External provider under contract with a health fund (ownership not stated). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: Marakam.","siteLabels":["Marakam-Har Chavaron"],"siteAddresses":["Meitarim"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '543|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"המרכז הירושלמי לבריאות הנפש — ילדים ונוער, מעלה אדומים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jerusalem Mental Health Center — children and youth, Ma''ale Adumim","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Ma''ale Adumim","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 5 HaTsalatsal, Ma''ale Adumim. Treatment methods: group psychotherapy Vafaratanit, dyadic therapy, parent guidance, psychiatric treatment, CBT.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '544|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'המרכז הירושלמי לבריאות הנפש — ילדים ונוער, מעלה אדומים'
WHERE entry_id = 'ילדים_מעלה_אדומים_544';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת — מבוגרים, ילדים ונוער, מעלה אדומים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet — adults, children, and youth, Ma''ale Adumim","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Ma''ale Adumim","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 5 Kikhar Yelom, Ma''ale Adumim.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '545|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת — מבוגרים, ילדים ונוער, מעלה אדומים'
WHERE entry_id = 'כיכר_יהלום_545';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"המרכז הירושלמי לבריאות הנפש — מבוגרים, מעלה אדומים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jerusalem Mental Health Center — adults, Ma''ale Adumim","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ma''ale Adumim","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"therapeutic mentoring","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 5 HaTsalatsal, Ma''ale Adumim. Treatment methods: dynamic-CBT-crisis intervention-HaKana veHaGasha Lasal rehabilitation.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '546|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'המרכז הירושלמי לבריאות הנפש — מבוגרים, מעלה אדומים'
WHERE entry_id = 'מבוגרים_מעלה_אדומים_546';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת — מבוגרים, מעלה אדומים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet — adults, Ma''ale Adumim","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ma''ale Adumim","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 5 Derekh Kadam, Ma''ale Adumim.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '547|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת — מבוגרים, מעלה אדומים'
WHERE entry_id = 'קניון_547';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"כללית, מעלות"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Ma''alot","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ma''alot","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Clalit, Ma''alot"],"siteAddresses":["Ma''alot"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '548|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, מעלות'
WHERE entry_id = 'מעלות_548';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, מעלות"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Ma''alot","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Ma''alot","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Ma''alot"],"siteAddresses":["18 Jerusalem, Ma''alot"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '549|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, מעלות'
WHERE entry_id = 'מעלות_549';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"מזור, מעלות"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Mazor, Ma''alot","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Ma''alot","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Mazor, Ma''alot"],"siteAddresses":["Ma''alot"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '550|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מזור, מעלות'
WHERE entry_id = 'תחנה_לטפול_בילד_ובנוער_מעלות_550';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"כללית, אזור תעסוקה משגב (תרדיון)"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Misgav industrial zone (Teradion)","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Misgav industrial zone (Teradion)","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","specialty":"eating disorders","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Misgav industrial zone (Teradion). Treatment methods: CBT."}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '551|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, אזור תעסוקה משגב (תרדיון)'
WHERE entry_id = 'משגב_551';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מזור — מבוגרים, נהריה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Mazor — adults, Nahariya","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Nahariya","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: CBT/ individual psychotherapy/Pasakhiogarayataria/group treatment/family therapy/couples therapy / Makav Pasikhosotsayali/ treatment rehabilitative/Tasatim Pasikhod.","phoneLabel":"Phone","siteLabels":["Mazor — adults, Nahariya"],"siteAddresses":["42 Weizmann, Nahariya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '552|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מזור — מבוגרים, נהריה'
WHERE entry_id = 'מרפאה_לברה_נ_מבוגרים_נהריה_552';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מזור — ילדים ונוער, נהריה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Mazor — children and youth, Nahariya","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Nahariya","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Mazor — children and youth, Nahariya"],"siteAddresses":["42 Weizmann, Nahariya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '553|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מזור — ילדים ונוער, נהריה'
WHERE entry_id = 'מרפאה_לטפול_בילד_ובנוער_נהריה_553';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"לאומית, נהריה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Leumit, Nahariya","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Nahariya","cost":"Health basket — Leumit members (referral from the fund; quarterly co-payment)","specialty":"Rav Makatsoait Varav Tachomit","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Leumit, Nahariya"],"siteAddresses":["27 HaGaton, Nahariya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '554|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'לאומית, נהריה'
WHERE entry_id = 'נהריה_554';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, נהריה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Nahariya","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Nahariya","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Nahariya"],"siteAddresses":["64 Herzl, Nahariya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '555|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, נהריה'
WHERE entry_id = 'נהריה_555';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"AMCHA-Nahariya","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Nahariya","cost":"Health basket — Leumit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Nonprofit — a provider under contract with a health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: AMCHA.","siteLabels":["AMCHA-Nahariya"],"siteAddresses":["18 Lochami HaGataot, Nahariya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '556|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Shay-Al-Nahariya","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Nahariya","cost":"Health basket — Leumit members (referral from the fund; quarterly co-payment)","notes":"Ownership: External provider under contract with a health fund (ownership not stated). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Shay-Al-Nahariya"],"siteAddresses":["42 Lotos, Nahariya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '557|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, נחף"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Nahf","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Nahf","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Nahf"],"siteAddresses":["Nahf"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '558|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, נחף'
WHERE entry_id = 'נחף_558';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"באר יעקב — ילדים ונוער, בית החולים נס ציונה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Be''er Yaakov — children and youth, Ness Ziona hospital","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Ness Ziona hospital","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Ness Ziona hospital. Treatment methods: individual, group veHaDarakhat parents.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '559|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'באר יעקב — ילדים ונוער, בית החולים נס ציונה'
WHERE entry_id = 'ילדים_ונוער_נס_ציונה_559';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"באר יעקב — מבוגרים, בית החולים נס ציונה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Be''er Yaakov — adults, Ness Ziona hospital","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ness Ziona hospital","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"dual diagnosis","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Ness Ziona hospital. Treatment methods: individual dynamic short-term, CBT.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '560|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'באר יעקב — מבוגרים, בית החולים נס ציונה'
WHERE entry_id = 'מבוגרים_נס_ציונה_560';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, נס ציונה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Ness Ziona","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Ness Ziona","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 53 Ayrosim, Ness Ziona.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '561|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, נס ציונה'
WHERE entry_id = 'קניותר_561';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"המשפחה הקדושה — מבוגרים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Holy Family Hospital — adults","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Nazareth","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"Pasikhayataria Clalit, psychogeriatrics","notes":"Ownership: Mission hospital (nonprofit). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: T.D. Treatment methods: individual treatment/Zogi/family, CBT, grief processing, PTSD, rehabilitative. 11, Nazareth.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '562|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'המשפחה הקדושה — מבוגרים'
WHERE entry_id = 'מרפאה_לבריאות_הנפש_בי_ח_נצרת_562';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"המשפחה הקדושה — ילדים ונוער"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Holy Family Hospital — children and youth","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Nazareth","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Mission hospital (nonprofit). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: T.D. Treatment methods: treatment Pasikhologi Liladim. 11, Nazareth.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '563|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'המשפחה הקדושה — ילדים ונוער'
WHERE entry_id = 'מרפאה_לבריאות_הנפש_בי_ח_נצרת_מענא_לילדים_ונוער_563';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, נצרת"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Nazareth","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Nazareth","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Nazareth"],"siteAddresses":["Marag Avan Aamar, Nazareth"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '564|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, נצרת'
WHERE entry_id = 'נצרת_564';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — מבוגרים, נצרת עילית"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — adults, Nazareth Illit","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Nazareth Illit","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 14 Sderot Ma''ale Yitzhak, floor 1, Nazareth Illit.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '565|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — מבוגרים, נצרת עילית'
WHERE entry_id = 'מרכז_בריאות_הנפש_נצרת_עילית_565';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — ילדים ונוער, נצרת עילית"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — children and youth, Nazareth Illit","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Nazareth Illit","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 14 Sderot Ma''ale Yitzhak, floor 1, Nazareth Illit.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '566|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — ילדים ונוער, נצרת עילית'
WHERE entry_id = 'מרכז_בריאות_הנפש_לילדים_נצרת_עילית_566';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, נצרת עילית"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Nazareth Illit","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Nazareth Illit","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Nazareth Illit"],"siteAddresses":["18 Atzmon, Nazareth Illit"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '567|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, נצרת עילית'
WHERE entry_id = 'נצרת_עילית_567';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Public Health Association Netanya","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Netanya","cost":"Health basket — Clalit and Leumit members (referral from the fund; quarterly co-payment)","specialty":"day hospitalization","notes":"Ownership: External provider under contract with a health fund (ownership not stated). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: Public Health Association.","phoneLabel":"Phone","siteLabels":["Public Health Association Netanya"],"siteAddresses":["24 Giborei Israel, Netanya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '568|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, נתניה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Netanya","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Netanya","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Netanya"],"siteAddresses":["3 Yehuda Perach, Netanya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '569|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, נתניה'
WHERE entry_id = 'הפרח_569';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"לב השרון — ילדים ונוער"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Lev Hasharon — children and youth","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Netanya","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: individual, group, family, CBT, EMDR, DBT.","phoneLabel":"Phone","siteLabels":["Lev Hasharon — children and youth"],"siteAddresses":["2 HaTzoran, Netanya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '570|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'לב השרון — ילדים ונוער'
WHERE entry_id = 'ילדים_נתניה_570';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"לב השרון — מבוגרים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Lev Hasharon — adults","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Netanya","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"intake Dachof,psychotherapy Dachofa,group treatment Miidi,eating disorders, addictions, Kavotsa supportive Lamatofalim Mamoshakhim, Kavotsa supportive","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: cbt,dbt,emdr,dynamic.","phoneLabel":"Phone","siteLabels":["Lev Hasharon — adults"],"siteAddresses":["2 HaTzoran, Netanya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '571|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'לב השרון — מבוגרים'
WHERE entry_id = 'מבוגרים_נתניה_571';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"09-8924271","phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי, נתניה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi, Netanya","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Netanya","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Shad Binyamin 21 Netanya.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '572|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי, נתניה'
WHERE entry_id = 'נתניה_מרכז_ילדים_ונוער_572';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"AMCHA-Netanya","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Netanya","cost":"Health basket — Leumit members (referral from the fund; quarterly co-payment)","specialty":"Rav Tachomi","notes":"Ownership: Nonprofit — a provider under contract with a health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: AMCHA.","siteLabels":["AMCHA-Netanya"],"siteAddresses":["4 Smilansky, Netanya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '573|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, נתניה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Netanya","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Netanya","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Netanya"],"siteAddresses":["6 Amnon veTamar, Netanya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '574|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, נתניה'
WHERE entry_id = 'פולג_574';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"09-8607222","phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Tsipor HaNefesh Netanya Lev HaIr","svc":"Multidisciplinary mental health clinic","target":"Children and youth, adults","region":"Netanya","cost":"Health basket — Leumit members (referral from the fund; quarterly co-payment)","specialty":"Rav Makatsoait Varav Tachomit","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: all kinds of intervention.","phoneLabel":"Phone","siteLabels":["Tsipor HaNefesh Netanya Lev HaIr"],"siteAddresses":["17 Shtamper, Netanya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '575|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת — ילדים ונוער, נתניה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet — children and youth, Netanya","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Netanya","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet — children and youth, Netanya"],"siteAddresses":["16 Remez, Netanya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '576|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת — ילדים ונוער, נתניה'
WHERE entry_id = 'רמז_576';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"09-8869474","phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי, נתניה ק. השרון"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi, Netanya, Kiryat Hasharon","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Netanya, Kiryat Hasharon","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","specialty":"eating disorders","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Shad Lantos Tom 26 Netanya, Netanya K. HaSharon.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '577|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי, נתניה ק. השרון'
WHERE entry_id = 'נתניה_קרית_השרון_577';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, סחנין"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Sakhnin","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Sakhnin","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: HaIr HaAtika, Sakhnin.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '578|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, סחנין'
WHERE entry_id = 'סחנין_578';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, עוספיה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Isfiya","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Isfiya","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Rach main, Isfiya.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '579|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, עוספיה'
WHERE entry_id = 'עוספיה_579';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"clinic Makav-Mazara","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Acre","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["clinic Makav-Mazara"],"siteAddresses":["Acre"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '580|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מזור, עכו"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Mazor, Acre","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Acre","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"treatment Bahafaraot Ayshiot Gavolit. rehabilitation.treatment Bamatofali the Ministry of Defense","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: CBT/dynamic therapy/treatment Makhavan rehabilitation veHaChalama. group treatment/ DBT/treatment Bamashafacha/ PE.","phoneLabel":"Phone","siteLabels":["Mazor, Acre"],"siteAddresses":["31 Taromafalador, Acre"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '581|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מזור, עכו'
WHERE entry_id = 'מרפאת_מבוגרים_עכו_581';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, עכו"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Acre","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Acre","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Acre"],"siteAddresses":["39 Ben Ami, Acre"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '582|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, עכו'
WHERE entry_id = 'עכו_582';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"HaAmak - mental health center-Day treatment — Afula","svc":"Multidisciplinary mental health clinic","target":"Adult day treatment","region":"Afula","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["HaAmak - mental health center-Day treatment — Afula"],"siteAddresses":["21 Rabin, Afula"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '583|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"HaAmak-clinic children and youth","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Afula","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["HaAmak-clinic children and youth"],"siteAddresses":["21 Rabin, Afula"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '584|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"HaAmak-clinic adults","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Afula","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["HaAmak-clinic adults"],"siteAddresses":["21 Rabin, Afula"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '585|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית, עפולה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Afula","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Afula","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 1 Yehusha Chanakin, floor 3, Afula.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '586|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, עפולה'
WHERE entry_id = 'מרכז_בריאות_הנפש_עפולה_586';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, עפולה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Afula","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Afula","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 5 Kahalat Tsion, Afula.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '587|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, עפולה'
WHERE entry_id = 'עפולה_587';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, עראבה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Arraba","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Arraba","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Rach main, Arraba.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '588|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, עראבה'
WHERE entry_id = 'עראבה_588';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית, ערד"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Arad","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Arad","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","specialty":"Batokhanit HaTamakadot Bafivaromayalagia","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: dynamic Katsar+Arokh,Koganitivi, cbt.","phoneLabel":"Phone","siteLabels":["Clalit, Arad"],"siteAddresses":["Tsim Sanatar, Arad"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '589|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, ערד'
WHERE entry_id = 'מרכז_בריאות_הנפש_ערד_589';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי, ערד"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi, Arad","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Arad","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Maccabi, Arad"],"siteAddresses":["13 Shamaon, Arad"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '590|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי, ערד'
WHERE entry_id = 'ערד_שלוחה_מבוגרים_590';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"clinic Marakam","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Otniel","cost":"Health basket — Maccabi and Leumit members (referral from the fund; quarterly co-payment)","specialty":"Rav Makatsoait Varav Tachomit","notes":"Ownership: External provider under contract with a health fund (ownership not stated). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: Marakam.","phoneLabel":"Phone","siteLabels":["clinic Marakam"],"siteAddresses":["Otniel"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '591|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — מבוגרים, ילדים ונוער, פ\"ת"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — adults, children, and youth, Petah Tikva","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Petah Tikva","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","specialty":"assessment veTreatment - HaParat attention","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 23 HaHistadrut, Petah Tikva. Treatment methods: art therapy, CBT; parent guidance Kavotit / Pakatanit, a parents workshop, Sadanat children, art therapy,.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '592|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — מבוגרים, ילדים ונוער, פ"ת'
WHERE entry_id = 'יחידה_להפרעות_קשב_592';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — מבוגרים, פ\"ת"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — adults, Petah Tikva","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Petah Tikva","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 7 Avaraham Taviv, Petah Tikva.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '593|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — מבוגרים, פ"ת'
WHERE entry_id = 'מרפאה_פסיכוגריאטרית_מחנה_יהודה_593';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, פרדס חנה-כרכור"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Pardes Hanna-Karkur","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Pardes Hanna-Karkur","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Pardes Hanna-Karkur"],"siteAddresses":["99 HaDakalim, Pardes Hanna-Karkur"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '594|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, פרדס חנה-כרכור'
WHERE entry_id = 'פרדס_חנה_594';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"adults Lev Hasharon","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Pardesiya","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"psychogeriatrics,","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Hospital Lev Hasharon, Pardesiya. Treatment methods: CBT,DBT, Zogi, family.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '595|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"מאוחדת — ילדים ונוער, פתח תקוה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet — children and youth, Petah Tikva","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Petah Tikva","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Meuhedet — children and youth, Petah Tikva"],"siteAddresses":["3 Rafal Aytan, Petah Tikva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '596|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת — ילדים ונוער, פתח תקוה'
WHERE entry_id = 'אם_המושבות_החדשה_596';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Geha-day treatment adults","svc":"Multidisciplinary mental health clinic","target":"Adult day treatment","region":"Petah Tikva","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Geha-day treatment adults"],"siteAddresses":["1 HaLasinaki, Petah Tikva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '597|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Geha-day treatment youth","svc":"Multidisciplinary mental health clinic","target":"Youth day treatment","region":"Petah Tikva","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Geha-day treatment youth"],"siteAddresses":["1 HaLasinaki, Petah Tikva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '598|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Geha-Marafaot-children","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Petah Tikva","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Geha-Marafaot-children"],"siteAddresses":["1 HaLasinaki, Petah Tikva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '599|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Geha-Marafaot-adults","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Petah Tikva","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Geha-Marafaot-adults"],"siteAddresses":["1 HaLasinaki, Petah Tikva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '600|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, פתח תקוה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Petah Tikva","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Petah Tikva","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Petah Tikva"],"siteAddresses":["1 Rishon LeZion, Petah Tikva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '601|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, פתח תקוה'
WHERE entry_id = 'התקווה_601';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, פתח תקוה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Petah Tikva","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Petah Tikva","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Petah Tikva"],"siteAddresses":["19 Noradav, Petah Tikva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '602|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, פתח תקוה'
WHERE entry_id = 'נורדאו_602';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Petah Tikva - children and youth","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Petah Tikva","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"a parents workshop Loisot Ragashi, Kavotsot Dayadiot","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: dynamic, CBT, group, treatment Baomanoiot, parent guidance.","phoneLabel":"Phone","siteLabels":["Petah Tikva - children and youth"],"siteAddresses":["3 Zosia Shafigal, Petah Tikva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '603|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Petah Tikva - adults","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Petah Tikva","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"psychogeriatrics, Sadanat anxiety, treatment Mini, couples therapy/family, trauma Minit","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: dynamic, CBT, group, DBT, EMDR.","phoneLabel":"Phone","siteLabels":["Petah Tikva - adults"],"siteAddresses":["31 Echad HaAm, Petah Tikva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '604|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Petah Tikva - adults- Shachaf","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Petah Tikva","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"treatment Bahafaraot Nafashiot Kashot","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: supportive, Makav Vanihol Makara, dynamic, group, art therapy.","phoneLabel":"Phone","siteLabels":["Petah Tikva - adults- Shachaf"],"siteAddresses":["3 Zosia Shafigal, Petah Tikva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '605|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Schneider-clinic Katinim","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Petah Tikva","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Schneider-clinic Katinim"],"siteAddresses":["14 Kaplan, Petah Tikva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '606|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"phoneLabel2":"טלפון","phoneShowNumber2":false,"org":"זיו — מבוגרים"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Ziv — adults","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Safed","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"eating disorders, clinic Makav, treatment Balafonakas, treatment Bacharada, treatment Bahafarat Ayshiot Gavolit","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 5 HaNarita Solad, Safed. Treatment methods: psychotherapy individual Dinamit short-term/Arokh; CBT, DBT, EMDR, crisis intervention, treatment Bahafaraot Akhila, Kavotsot Lachar hospitalization.","phoneLabel":"Phone","phoneLabel2":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '607|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'זיו — מבוגרים'
WHERE entry_id = 'בריאות_הנפש_צפת_607';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"זיו, צפת"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Ziv, Safed","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Safed","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Ziv, Safed"],"siteAddresses":["Ramavam, Safed"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '608|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'זיו, צפת'
WHERE entry_id = 'בריאות_הנפש_צפת_הגיל_הרך_608';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"זיו, צפת"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Ziv, Safed","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Safed","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Ziv, Safed"],"siteAddresses":["Ramavam, Safed"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '609|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'זיו, צפת'
WHERE entry_id = 'בריאות_הנפש_צפת_ילדים_ונוער_609';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, צפת"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Safed","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Safed","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Safed"],"siteAddresses":["6 Weizmann, Safed"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '610|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, צפת'
WHERE entry_id = 'צפת_610';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית, קלנסווה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Qalansawe","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Qalansawe","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: street HaDoar, Qalansawe.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '611|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, קלנסווה'
WHERE entry_id = 'מרכז_בריאות_הנפש_קלנסואה_611';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"04-6969641","phoneLabel":"טלפון","phoneShowNumber":false,"phone2":"04-6969646","phoneLabel2":"טלפון","phoneShowNumber2":false,"org":"זיו, קצרין"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Ziv, Katzrin","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Katzrin","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Lashakhat HaRavacha, Katzrin. Treatment methods: psychotherapy individual Dinamit short-term/Arokh, crisis intervention, CBT, EMDR.","phoneLabel":"Phone","phoneLabel2":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '612|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'זיו, קצרין'
WHERE entry_id = 'בריאות_הנפש_קצרין_612';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, קריית גת"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Kiryat Gat","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Kiryat Gat","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Kiryat Gat"],"siteAddresses":["178 Malakhi Israel, Kiryat Gat"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '613|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, קריית גת'
WHERE entry_id = 'מלכי_ישראל_613';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — מבוגרים, קריית מלאכי"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — adults, Kiryat Malakhi","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Kiryat Malakhi","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 2 HaNegev, Kiryat Malakhi.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '614|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — מבוגרים, קריית מלאכי'
WHERE entry_id = 'קריית_מלאכי_מבוגרים_614';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — ילדים ונוער, קריית מלאכי"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — children and youth, Kiryat Malakhi","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Kiryat Malakhi","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 14 HaMag, Kiryat Malakhi.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '615|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — ילדים ונוער, קריית מלאכי'
WHERE entry_id = 'קרית_מלאכי_ילדים_ונוער_615';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, קרית ארבע"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Kiryat Arba","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Kiryat Arba","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: Kalav Ben Yfona, Kiryat Arba.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '616|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, קרית ארבע'
WHERE entry_id = 'קרית_ארבע_616';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"טירת הכרמל, קרית אתא"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Tirat Carmel, Kiryat Ata","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Kiryat Ata","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"Shalocha Shal clinic HaYladim Shal Ma''ale HaCarmel","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: intake Rav Makatsoai psychiatric follow-up veTreatment HaTarofati Tifolim Parataniim HaTaravot Tifolit Mashafachatit including parent guidance Livi Sotsayali L.","phoneLabel":"Phone","siteLabels":["Tirat Carmel, Kiryat Ata"],"siteAddresses":["1 Alavaz, Kiryat Ata"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '617|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'טירת הכרמל, קרית אתא'
WHERE entry_id = 'צוות_ילדים_ונוער_ק_אתא_617';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"ברזילי, קרית גת"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Barzilai, Kiryat Gat","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Kiryat Gat","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"psychogeriatrics","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Barzilai, Kiryat Gat"],"siteAddresses":["HaAtzmaut 68 Kiryat Gat"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '618|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'ברזילי, קרית גת'
WHERE entry_id = 'מרפאת_בריאות_הנפש_קריית_גת_618';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי, קרית מוצקין"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi, Kiryat Motzkin","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Kiryat Motzkin","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Maccabi, Kiryat Motzkin"],"siteAddresses":["271 Derekh Acre, Kiryat Motzkin"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '619|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי, קרית מוצקין'
WHERE entry_id = 'קרית_מוצקין_מבוגרים_619';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"זיו, קרית שמונה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Ziv, Kiryat Shmona","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Kiryat Shmona","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Ziv, Kiryat Shmona"],"siteAddresses":["Kiryat Shmona"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '620|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'זיו, קרית שמונה'
WHERE entry_id = 'בריאות_הנפש_קרית_שמונה_620';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית, קרית שמונה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Kiryat Shmona","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Kiryat Shmona","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 7 Aliit HaNoar, floor A, Matanas Ashakhol, Kiryat Shmona.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '621|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, קרית שמונה'
WHERE entry_id = 'מרכז_בריאות_הנפש_קרית_שמונה_621';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי, ראשון לציון"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi, Rishon LeZion","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Rishon LeZion","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","specialty":"Kalali, health HaAysha","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Maccabi, Rishon LeZion"],"siteAddresses":["10 HaShira HaAvarit, Rishon LeZion"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '622|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי, ראשון לציון'
WHERE entry_id = 'הקראדו_מבוגרים_622';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, ראשון לציון"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Rishon LeZion","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Rishon LeZion","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Rishon LeZion"],"siteAddresses":["52 Herzl, Rishon LeZion"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '623|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, ראשון לציון'
WHERE entry_id = 'מרכז_העיר_623';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת — מבוגרים, ראשון לציון"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet — adults, Rishon LeZion","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Rishon LeZion","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet — adults, Rishon LeZion"],"siteAddresses":["4 Kafach, Rishon LeZion"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '624|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת — מבוגרים, ראשון לציון'
WHERE entry_id = 'נאות_שקמה_624';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, ראשון לציון"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Rishon LeZion","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Rishon LeZion","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Rishon LeZion"],"siteAddresses":["31 Pik, Rishon LeZion"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '625|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, ראשון לציון'
WHERE entry_id = 'קדמת_ראשון_625';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי, ראשון לציון"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi, Rishon LeZion","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Rishon LeZion","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Maccabi, Rishon LeZion"],"siteAddresses":["3 Shamoal Sharir, Rishon LeZion"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '626|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי, ראשון לציון'
WHERE entry_id = 'שרירא_מבוגרים_626';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — ילדים ונוער, ראשל\"צ"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — children and youth, Rishon LeZion","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Rishon LeZion","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 4 Zalaman Shanayaor, Rishon LeZion.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '627|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — ילדים ונוער, ראשל"צ'
WHERE entry_id = 'ראשל_צ_ילדים_627';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — מבוגרים, ראשל\"צ"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — adults, Rishon LeZion","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Rishon LeZion","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 4 Zalaman Shanayaor, Rishon LeZion.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '628|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — מבוגרים, ראשל"צ'
WHERE entry_id = 'ראשל_צ_מבוגרים_628';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית, רהט"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Rahat","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Rahat","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 2 neighborhood 8 Beit, Rahat. Treatment methods: dynamic + short-term +Arokh veTreatment HaTanahagoti.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '629|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, רהט'
WHERE entry_id = 'מרכז_בריאות_הנפש_רהט_629';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת — מבוגרים, ילדים ונוער, רחובות"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet — adults, children, and youth, Rehovot","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Rehovot","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet — adults, children, and youth, Rehovot"],"siteAddresses":["4 Binyamin, Rehovot"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '630|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת — מבוגרים, ילדים ונוער, רחובות'
WHERE entry_id = 'בנימין_4_630';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"באר יעקב — ילדים ונוער, פארק המדע רחובות"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Be''er Yaakov — children and youth, Rehovot Science Park","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Rehovot Science Park","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"children and youth including HaGil HaRakh","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 10 Oppenheimer, Rehovot Science Park. Treatment methods: group treatment, individual Vadayadi dynamic, CBT.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '631|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'באר יעקב — ילדים ונוער, פארק המדע רחובות'
WHERE entry_id = 'ילדים_ונוער_רחובות_631';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"באר יעקב — מבוגרים, פארק המדע רחובות"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Be''er Yaakov — adults, Rehovot Science Park","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Rehovot Science Park","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 10 Oppenheimer, Rehovot Science Park. Treatment methods: couples therapy, family, group, dynamic, DBT,PE,CBT,EMDR.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '632|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'באר יעקב — מבוגרים, פארק המדע רחובות'
WHERE entry_id = 'מבוגרים_רחובות_632';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת — מבוגרים, רחובות"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet — adults, Rehovot","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Rehovot","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 11 Rozanasaki, Rehovot.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '633|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת — מבוגרים, רחובות'
WHERE entry_id = 'מכון_שיקום_633';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת — ילדים ונוער, רחובות"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet — children and youth, Rehovot","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Rehovot","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet — children and youth, Rehovot"],"siteAddresses":["182 Herzl, Rehovot"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '634|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת — ילדים ונוער, רחובות'
WHERE entry_id = 'מרפאת_מתבגרים_634';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Kaplan-Day treatment — adults","svc":"Multidisciplinary mental health clinic","target":"Adult day treatment","region":"Rehovot","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Kaplan-Day treatment — adults"],"siteAddresses":["Pasataranak, Rehovot"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '635|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Kaplan-clinic adults","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Rehovot","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Kaplan-clinic adults"],"siteAddresses":["Pasataranak, Rehovot"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '636|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי, רחובות"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi, Rehovot","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Rehovot","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Maccabi, Rehovot"],"siteAddresses":["1 Shoshan Aria, Rehovot"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '637|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי, רחובות'
WHERE entry_id = 'רחובות_שלוחה_ילדים_637';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, רמלה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Ramla","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ramla","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Ramla"],"siteAddresses":["59 Herzl, Ramla"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '638|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, רמלה'
WHERE entry_id = 'הרצל_638';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"באר יעקב, רמלה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Be''er Yaakov, Ramla","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ramla","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Be''er Yaakov, Ramla"],"siteAddresses":["11 Yitzhak Shada, Ramla"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '639|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'באר יעקב, רמלה'
WHERE entry_id = 'מבוגרים_רמלה_639';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"שיבא, רמת גן"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Sheba, Ramat Gan","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ramat Gan","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Sheba, Ramat Gan"],"siteAddresses":["1 Amak HaAla, Ramat Gan"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '640|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'שיבא, רמת גן'
WHERE entry_id = 'מרפאה_כללית_640';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"שיבא, רמת גן"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Sheba, Ramat Gan","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ramat Gan","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"eating disorders","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Sheba, Ramat Gan"],"siteAddresses":["1 Amak HaAla, Ramat Gan"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '641|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'שיבא, רמת גן'
WHERE entry_id = 'מרפאה_להפרעות_אכילה_641';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"mental health clinic Bnei Brak (Sheba)","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ramat Gan","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"Aokhalosiia Charadit","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["mental health clinic Bnei Brak (Sheba)"],"siteAddresses":["1 Amak HaAla, Ramat Gan"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '642|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"שיבא, רמת גן"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Sheba, Ramat Gan","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ramat Gan","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"HaParat attention Vaotizam","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Sheba, Ramat Gan"],"siteAddresses":["1 Amak HaAla, Ramat Gan"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '643|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'שיבא, רמת גן'
WHERE entry_id = 'מרפאת_התפתחות_הפרעות_קשב_ואוטיזם_643';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"שיבא, רמת גן"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Sheba, Ramat Gan","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ramat Gan","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"psychogeriatrics","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Sheba, Ramat Gan"],"siteAddresses":["1 Amak HaAla, Ramat Gan"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '644|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'שיבא, רמת גן'
WHERE entry_id = 'מרפאת_זיכרון_ופסיכוגריאטריה_644';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"שיבא, רמת גן"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Sheba, Ramat Gan","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ramat Gan","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"health Nafashit women","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Sheba, Ramat Gan"],"siteAddresses":["1 Amak HaAla, Ramat Gan"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '645|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'שיבא, רמת גן'
WHERE entry_id = 'מרפאת_חווה_בריאות_נפשית_לנשים_645';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"שיבא, רמת גן"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Sheba, Ramat Gan","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ramat Gan","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Sheba, Ramat Gan"],"siteAddresses":["1 Amak HaAla, Ramat Gan"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '646|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'שיבא, רמת גן'
WHERE entry_id = 'מרפאת_טיפול_מרפאתי_כפוי_646';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"שיבא — ילדים ונוער, רמת גן"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Sheba — children and youth, Ramat Gan","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Ramat Gan","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Sheba — children and youth, Ramat Gan"],"siteAddresses":["1 Amak HaAla, Ramat Gan"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '647|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'שיבא — ילדים ונוער, רמת גן'
WHERE entry_id = 'מרפאת_ילדים_ונוער_תל_השומר_647';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"שיבא, רמת גן"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Sheba, Ramat Gan","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ramat Gan","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"Nakhi Masharad HaBitachon","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Sheba, Ramat Gan"],"siteAddresses":["1 Amak HaAla, Ramat Gan"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '648|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'שיבא, רמת גן'
WHERE entry_id = 'מרפאת_משרד_הביטחון_648';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"שיבא, רמת גן"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Sheba, Ramat Gan","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ramat Gan","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Sheba, Ramat Gan"],"siteAddresses":["1 Amak HaAla, Ramat Gan"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '649|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'שיבא, רמת גן'
WHERE entry_id = 'מרפאת_נזעי_חשמל_649';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"שיבא, רמת גן"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Sheba, Ramat Gan","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ramat Gan","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"Matofalim Batifol Pasikhologi","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Sheba, Ramat Gan"],"siteAddresses":["1 Amak HaAla, Ramat Gan"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '650|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'שיבא, רמת גן'
WHERE entry_id = 'מרפאת_פסיכולוגים_650';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"שיבא, רמת גן"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Sheba, Ramat Gan","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ramat Gan","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"Mikod Basovalim Masakhizofarania","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Sheba, Ramat Gan"],"siteAddresses":["1 Amak HaAla, Ramat Gan"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '651|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'שיבא, רמת גן'
WHERE entry_id = 'מרפאת_שחר_מבוגרים_651';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי, רמת גן"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi, Ramat Gan","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ramat Gan","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","specialty":"psychogeriatrics, Tifolim Bagil HaShalishi","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Maccabi, Ramat Gan"],"siteAddresses":["4 Aora, Ramat Gan"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '652|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי, רמת גן'
WHERE entry_id = 'רמת_גן_מבוגרים_652';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"09-8869474","phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי, רמת השרון"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi, Ramat HaSharon","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Ramat HaSharon","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","specialty":"eating disorders","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Maccabi, Ramat HaSharon"],"siteAddresses":["HaNatsach 3 Ramat HaSharon"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '653|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי, רמת השרון'
WHERE entry_id = 'רמת_השרון_מבוגרים_וילדים_653';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, רמת-גן"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Ramat Gan","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Ramat Gan","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Ramat Gan"],"siteAddresses":["6 Natan, Ramat Gan"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '654|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, רמת-גן'
WHERE entry_id = 'ר_ג_654';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית, רעות"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Re''ut","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Re''ut","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Clalit, Re''ut"],"siteAddresses":["Sderot Aomarim, Re''ut"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '655|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, רעות'
WHERE entry_id = 'רעות_מודיעין_מכבים_מבוגרים_655';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית, רעננה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Ra''anana","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Ra''anana","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Clalit, Ra''anana"],"siteAddresses":["7 HaNotarim, Ra''anana"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '656|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, רעננה'
WHERE entry_id = 'הנוטרים_בריאות_הנפש_רעננה_656';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, רעננה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Ra''anana","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ra''anana","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Meuhedet, Ra''anana"],"siteAddresses":["34 Jerusalem, Ra''anana"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '657|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, רעננה'
WHERE entry_id = 'רעננה_657';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"09-7470777","phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי, רעננה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi, Ra''anana","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Ra''anana","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Maccabi, Ra''anana"],"siteAddresses":["Achoza 124 Ra''anana"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '658|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי, רעננה'
WHERE entry_id = 'רעננה_מבוגרים_658';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"ברזילי, שדרות"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Barzilai, Sderot","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Sderot","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Barzilai, Sderot"],"siteAddresses":["Yitzhak Ben Tsavi 35 Sderot"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '659|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'ברזילי, שדרות'
WHERE entry_id = 'מרפאת_בריאות_הנפש_שדרות_659';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, שוהם"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Shoham","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Shoham","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 30 Amak Aylon, Shoham.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '660|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, שוהם'
WHERE entry_id = 'עמק_אילון_660';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"מאוחדת, שפרעם"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Shefa-Amr","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth","region":"Shefa-Amr","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: neighborhood Vadi Sakiia, Shefa-Amr."}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '661|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, שפרעם'
WHERE entry_id = 'שפרעם_661';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"כללית — ילדים ונוער, שפרעם"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — children and youth, Shefa-Amr","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Shefa-Amr","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Clalit — children and youth, Shefa-Amr"],"siteAddresses":["Shefa-Amr"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '662|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — ילדים ונוער, שפרעם'
WHERE entry_id = 'שפרעם_ילדים_ונוער_662';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית — מבוגרים, שפרעם"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit — adults, Shefa-Amr","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Shefa-Amr","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Clalit — adults, Shefa-Amr"],"siteAddresses":["Alamotaran Chagar, Shefa-Amr"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '663|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית — מבוגרים, שפרעם'
WHERE entry_id = 'שפרעם_מבוגרים_663';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Tiferet Beit Cham - Shefa-Amr","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Shefa-Amr","cost":"Health basket — Clalit and Leumit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Nonprofit — a provider under contract with a health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Operator: Tiferet Beit Cham. Address: building HaHistadrut, Shefa-Amr.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '664|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Ichilov - Day treatment — adults","svc":"Multidisciplinary mental health clinic","target":"Adult day treatment","region":"Tel Aviv","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"Motamat Latsorakh HaAyshi. L Makavalim eating disorders (Ayn Miomanot Vayn Tsavat Nadarash)","notes":"Ownership: Municipal-government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 13 HaNarayata Salad, Tel Aviv. Treatment methods: Chalifa Ayshit Af HaTsorakh.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '665|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"phoneLabel2":"טלפון","phoneShowNumber2":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"HaAravaa-center Latafol Pasikhologi - children","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Tel Aviv","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"families Batsimot Sakhasokh Gavoha (Paridot, Giroshin), Maoravot Ravacha, treatment Baokhalosiia Yichodit:Palitim","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: dynamic, family, Marakhati (parent guidance),CBT (biofeedback).","phoneLabel":"Phone","phoneLabel2":"Phone","siteLabels":["HaAravaa-center Latafol Pasikhologi - children"],"siteAddresses":["16 HaAravaa, Tel Aviv"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '666|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"phoneLabel2":"טלפון","phoneShowNumber2":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"HaAravaa-center Latafol Pasikhologi - adults","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Tel Aviv","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"Charadat Bachinot, Dachiinot, treatment Baokhalosiot Miochadot (Aravim, Palitim), post-trauma","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: dynamic, Avachoni, group, Zogi, CBT (biofeedback).","phoneLabel":"Phone","phoneLabel2":"Phone","siteLabels":["HaAravaa-center Latafol Pasikhologi - adults"],"siteAddresses":["16 HaAravaa, Tel Aviv"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '667|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-5151125","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: מרכז ממשלתי לבריאות הנפש (משרד הבריאות). הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. שיטות טיפול: טיפול פרטני, CBT, טיפול משפחתי, קבוצתי טיפול במוזיקה. מקור: מאגר מרפאות בריאות הנפש של משרד הבריאות, עדכון 28.12.2025. שלוחה 44."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jaffa - day treatment adults","svc":"Multidisciplinary mental health clinic","target":"Adult day treatment","region":"Tel Aviv","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"HaParaot Ayshiot Vaod","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Extension 44. Treatment methods: individual treatment, CBT, family therapy, group music therapy.","phoneLabel":"Phone","siteLabels":["Jaffa - day treatment adults"],"siteAddresses":["HaRavi Mavakharakh 5 Tel Aviv-Yafo"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '668|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-5151125","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: מרכז ממשלתי לבריאות הנפש (משרד הבריאות). הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. שיטות טיפול: דינמי, דיאדי, קבוצתי, משפחתי,CBT. מקור: מאגר מרפאות בריאות הנפש של משרד הבריאות, עדכון 28.12.2025. שלוחה 44."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jaffa - children and youth","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Tel Aviv","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"behavior disorders in children, children growing up in families with many difficulties","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Extension 44. Treatment methods: dynamic, dyadic, group, family,CBT.","phoneLabel":"Phone","siteLabels":["Jaffa - children and youth"],"siteAddresses":["HaRavi Mavakharakh 5 Tel Aviv-Yafo"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '669|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-5151125","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: מרכז ממשלתי לבריאות הנפש (משרד הבריאות). הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. שיטות טיפול: דינמי, דיאדי, קבוצתי, משפחתי,CBT. מקור: מאגר מרפאות בריאות הנפש של משרד הבריאות, עדכון 28.12.2025. שלוחה 44."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jaffa - children and youth people with a hearing impairment (hearing impairment)","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Tel Aviv","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"behavior disorders in children, children growing up in families with many difficulties","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Extension 44. Treatment methods: dynamic, dyadic, group, family,CBT.","phoneLabel":"Phone","siteLabels":["Jaffa - children and youth people with a hearing impairment (hearing impairment)"],"siteAddresses":["HaRavi Mavakharakh 5 Tel Aviv-Yafo"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '670|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jaffa - adults","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Tel Aviv","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"Ychida Mashafatit- Chavad, women affected by sexual assault (Bahakama) treatment Dachof psychiatric","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Jaffa - adults"],"siteAddresses":["HaRavi Mavakharakh 5 Tel Aviv-Yafo"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '671|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-5151125","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: מרכז ממשלתי לבריאות הנפש (משרד הבריאות). הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: מאגר מרפאות בריאות הנפש של משרד הבריאות, עדכון 28.12.2025. שלוחה 44."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jaffa - adults dual diagnosis","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Tel Aviv","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"treatment Banafagai Samim + T. Nafashit","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Extension 44.","phoneLabel":"Phone","siteLabels":["Jaffa - adults dual diagnosis"],"siteAddresses":["HaRavi Mavakharakh 5 Tel Aviv-Yafo"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '672|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jaffa - psychogeriatrics","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Tel Aviv","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"Moadonit Lakashishim Shal Mataymim Lamoadonim Bakahila, HaTaravot Pasikhochinokhit Lamashafachot Shal Choli Alatsahiimar","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: psychotherapy supportive Dinamit VCBT.","phoneLabel":"Phone","siteLabels":["Jaffa - psychogeriatrics"],"siteAddresses":["HaRavi Mavakharakh 5 Tel Aviv-Yafo"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '673|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-5151125","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: מרכז ממשלתי לבריאות הנפש (משרד הבריאות). הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: מאגר מרפאות בריאות הנפש של משרד הבריאות, עדכון 28.12.2025. שלוחה 44."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jaffa – adults hearing impairment (hearing impairment)","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Tel Aviv","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"treatment Balakoi Shamiaa+ Matoragaman Lashafat Simanim","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Extension 44.","phoneLabel":"Phone","siteLabels":["Jaffa – adults hearing impairment (hearing impairment)"],"siteAddresses":["HaRavi Mavakharakh 5 Tel Aviv-Yafo"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '674|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Jaffa – adults- Makav","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Tel Aviv","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"treatment Bavali Tachaloaa Nafashit Kasha including Chasari Tovana Lamatsavam.","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: case management, psychotherapy supportive, CBT, Dinamit,psychiatric follow-up,HaArakha HaKana veHaGasha Lasal rehabilitation,Achot Kashar Am a hospital,Palot Lashifav.","phoneLabel":"Phone","siteLabels":["Jaffa – adults- Makav"],"siteAddresses":["HaRavi Mavakharakh 5 Tel Aviv-Yafo"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '675|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"clinic psychiatric Liladim and youth (Ichilov)","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Tel Aviv","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Municipal-government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Treatment methods: individual psychotherapy; parent guidance; family therapy.","phoneLabel":"Phone","siteLabels":["clinic psychiatric Liladim and youth (Ichilov)"],"siteAddresses":["10 Dafana, Tel Aviv"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '676|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"clinic psychiatric medical center Tel Aviv Ash Sorasaki (Ichilov)","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Tel Aviv","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","specialty":"Bamarafaa Magavan Ychidot Momachim: Barahan Asha including Am-Tinok, treatment Matogavar, DBT, trauma Akotit, treatment Banakhi Tsahal, anxiety, Zogi-Mashafachat","notes":"Ownership: Municipal-government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 13 HaNarayata Salad, Tel Aviv. Treatment methods: individual Bamagavan Shitot (CBT, Mamokad trauma, dynamic Katsar, dynamic Arokh, supportive) group Bamagavan Shitot (CBT, DBT, Vakhan HaLaa).","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '677|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-5151125","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: מרכז ממשלתי לבריאות הנפש (משרד הבריאות). הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: מאגר מרפאות בריאות הנפש של משרד הבריאות, עדכון 28.12.2025. שלוחה 44."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Plotkin Tel Aviv (Jaffa)","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Tel Aviv","cost":"Health basket — members of all health funds (referral from the fund; quarterly co-payment)","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Extension 44.","phoneLabel":"Phone","siteLabels":["Plotkin Tel Aviv (Jaffa)"],"siteAddresses":["32 Makor Chiim, Tel Aviv"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '678|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי — מבוגרים, תל אביב"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi — adults, Tel Aviv","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Tel Aviv","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","specialty":"treatment Bahafaraot anxiety, treatment Bamatsavi depression, treatment Basali rehabilitation.; treatment Kahilati, treatment Pasikhologi Am Dagashim Sotsayaliim, treatment Basali rehabilitation.","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Maccabi — adults, Tel Aviv"],"siteAddresses":["7 HaShala, Tel Aviv"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '679|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי — מבוגרים, תל אביב'
WHERE entry_id = 'תל_אביב_מבוגרים_679';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מכבי — ילדים ונוער, תל אביב"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Maccabi — children and youth, Tel Aviv","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Tel Aviv","cost":"Health basket — Maccabi members (referral from the fund; quarterly co-payment)","specialty":"attention, anxiety,","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","phoneLabel":"Phone","siteLabels":["Maccabi — children and youth, Tel Aviv"],"siteAddresses":["7 HaShala, Tel Aviv"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '680|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מכבי — ילדים ונוער, תל אביב'
WHERE entry_id = 'תל_אביב_ילדים_680';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"mental health Lagil HaRakh Ramat Chen","svc":"Multidisciplinary mental health clinic","target":"Children and youth","region":"Tel Aviv-Yafo","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 9 HaTsavi, ground floor, Tel Aviv-Yafo.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '681|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"כללית, תל אביב יפו"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Clalit, Tel Aviv-Yafo","svc":"Multidisciplinary mental health clinic","target":"Adults, children and youth, adult day treatment","region":"Tel Aviv-Yafo","cost":"Health basket — Clalit members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 9 HaTsavi, Ramat Chen, Tel Aviv-Yafo.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '682|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'כללית, תל אביב יפו'
WHERE entry_id = 'המרכז_לבריאות_הנפש_ע_ש_בריל_תל_אביב_682';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"org":"מאוחדת, תל-אביב"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Tel Aviv","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Tel Aviv","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.","siteLabels":["Meuhedet, Tel Aviv"],"siteAddresses":["14 Panakas, Tel Aviv"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '683|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, תל-אביב'
WHERE entry_id = 'פנקס_683';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"מאוחדת, תל-אביב"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Meuhedet, Tel Aviv","svc":"Multidisciplinary mental health clinic","target":"Adults","region":"Tel Aviv","cost":"Health basket — Meuhedet members (referral from the fund; quarterly co-payment)","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health mental-health clinic registry, updated 28.12.2025. Address: 3 Shafarinatsak, Tel Aviv.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '684|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_entries
SET display_name = 'מאוחדת, תל-אביב'
WHERE entry_id = 'שפרינצ_ק_684';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"08-6745510","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים ממשלתי. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — Shaked School (Barzilai Hospital)","svc":"Psychiatric day treatment","region":"Ashkelon","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day treatment — Shaked School (Barzilai Hospital)"],"siteAddresses":["3 HaHistadrut, Ashkelon"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '685|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"04-6828475","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים ממשלתי. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. כתובת: בית החולים זיו, ת.ד 1008, צפת. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — Ziv","svc":"Psychiatric day treatment","region":"Safed","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Address: Hospital Ziv, P.O. Box 1008, Safed. Check the admission policy with the center beforehand.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '686|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"04-9559655","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: מרכז ממשלתי לבריאות הנפש (משרד הבריאות). הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — Mazara","svc":"Psychiatric day treatment","region":"Acre","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day treatment — Mazara"],"siteAddresses":["37 Taromafalador, Acre"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '687|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"04-8543030","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים ממשלתי. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — Ramavam","svc":"Psychiatric day treatment","region":"Haifa","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day treatment — Ramavam"],"siteAddresses":["P.O. Box 9602, Haifa"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '688|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"08-9150208","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: לא צוין. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — Lod","svc":"Psychiatric day treatment","region":"Lod","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Not stated. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day treatment — Lod"],"siteAddresses":["4 Modi''in, Lod"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '689|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"09-8851290","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: לא צוין. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. כתובת: גיבורי ישראל 24, בניין רעים, נתניה. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — Netanya (building Re''im)","svc":"Psychiatric day treatment","region":"Netanya","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Not stated. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Address: 24 Giborei Israel, building Re''im, Netanya. Check the admission policy with the center beforehand.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '690|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-5552626","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: מרכז ממשלתי לבריאות הנפש (משרד הבריאות). הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — Abarbanel","svc":"Psychiatric day treatment","region":"Bat Yam","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day treatment — Abarbanel"],"siteAddresses":["15 Karan there is, Bat Yam"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '691|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-5151088","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: מרכז ממשלתי לבריאות הנפש (משרד הבריאות). הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — community mental health center Jaffa","svc":"Psychiatric day treatment","region":"Jaffa","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day treatment — community mental health center Jaffa"],"siteAddresses":["5 HaRavi Mavakharakh, Jaffa"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '692|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-6974703","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים עירוני-ממשלתי. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. כתובת: בניין שיקום, הנריטה סולד 13, תל אביב. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — Sorasaki (Ichilov)","svc":"Psychiatric day treatment","region":"Tel Aviv","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Municipal-government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Address: building rehabilitation, 13 HaNarita Solad, Tel Aviv. Check the admission policy with the center beforehand.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '693|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"02-6732672","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: מרכז ממשלתי לבריאות הנפש (משרד הבריאות). הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — Eitanim / Kfar Shaul","svc":"Psychiatric day treatment","region":"Jerusalem","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day treatment — Eitanim / Kfar Shaul"],"siteAddresses":["24 Kor HaDorot, Aranona, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '694|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"02-6234892","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים – הדסה. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — Hadassah","svc":"Psychiatric day treatment","region":"Jerusalem","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Hadassah hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day treatment — Hadassah"],"siteAddresses":["6A Ethiopia, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '695|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"08-6401697","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: מרכז ממשלתי לבריאות הנפש (משרד הבריאות). הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — Be''er Sheva","svc":"Psychiatric day treatment","region":"Be''er Sheva","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Government mental-health center (Ministry of Health). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day treatment — Be''er Sheva"],"siteAddresses":["2 HaTzadik miYerushalayim, Be''er Sheva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '696|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"08-6745103","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים ממשלתי. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. כתובת: בית החולים ברזילי, אשקלון. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — Barzilai","svc":"Psychiatric day treatment","region":"Ashkelon","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Address: Hospital Barzilai, Ashkelon. Check the admission policy with the center beforehand.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '697|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"04-6426061","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים של כללית. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — HaAmak","svc":"Psychiatric day treatment","region":"Afula","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day treatment — HaAmak"],"siteAddresses":["Sderot Yitzhak Rabin, Afula"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '698|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"08-6400351","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים של כללית. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — Soroka","svc":"Psychiatric day treatment","region":"Be''er Sheva","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day treatment — Soroka"],"siteAddresses":["P.O. Box 151, Be''er Sheva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '699|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"08-9441670","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים של כללית. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — Kaplan","svc":"Psychiatric day treatment","region":"Rehovot","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day treatment — Kaplan"],"siteAddresses":["1 Pasataranak, Rehovot"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '700|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-9258258","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים של כללית. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — Geha","svc":"Psychiatric day treatment","region":"Petah Tikva","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day treatment — Geha"],"siteAddresses":["1 HaLasinaki, Petah Tikva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '701|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"09-7478555","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים של כללית. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — Shalvata","svc":"Psychiatric day treatment","region":"Hod HaSharon","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day treatment — Shalvata"],"siteAddresses":["13 Aliit HaNoar, Hod HaSharon"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '702|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-6714700","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: קופת חולים. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — Bari","svc":"Psychiatric day treatment","region":"Bnei Brak","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day treatment — Bari"],"siteAddresses":["5 Bari, Bnei Brak"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '703|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-5720808","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: קופת חולים. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. כתובת: הצבי 9, רמת חן, תל אביב. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — mental health center Ramat Chen","svc":"Psychiatric day treatment","region":"Tel Aviv","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Address: 9 HaTsavi, Ramat Chen, Tel Aviv. Check the admission policy with the center beforehand.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '704|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"02-5608355","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: קופת חולים. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. כתובת: דישראלי 17, ירושלים. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day treatment — Talavia","svc":"Psychiatric day treatment","region":"Jerusalem","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Health fund. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Address: 17 Disharali, Jerusalem. Check the admission policy with the center beforehand.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '705|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"04-6028817","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים מיסיון (מלכ\"ר). הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. כתובת: ת.ד 11, נצרת. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day hospitalization — Hospital HaAnagali Banatsarat","svc":"Psychiatric day hospitalization","region":"Nazareth","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Mission hospital (nonprofit). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Address: P.O. Box 11, Nazareth. Check the admission policy with the center beforehand.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '706|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"04-9107460","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים ממשלתי. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. כתובת: ת.ד 21, נהריה. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day hospitalization — HaMarakhaz HaRafoai Lagalil HaMaravi","svc":"Psychiatric day hospitalization","region":"Nahariya","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Address: P.O. Box 21, Nahariya. Check the admission policy with the center beforehand.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '707|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"04-6494351","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים של כללית. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day hospitalization — HaAmak","svc":"Psychiatric day hospitalization","region":"Afula","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day hospitalization — HaAmak"],"siteAddresses":["Sderot Yitzhak Rabin, Afula"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '708|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"04-6828067","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים ממשלתי. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. כתובת: הרמב\"ם, ת.ד 1008, צפת. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day hospitalization — Ziv","svc":"Psychiatric day hospitalization","region":"Safed","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Address: HaRamavam, P.O. Box 1008, Safed. Check the admission policy with the center beforehand.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '709|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"04-7773036","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים ממשלתי. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. כתובת: בניין ישן (מנדלסון), קומה 2, חיפה. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day hospitalization — Ramavam","svc":"Psychiatric day hospitalization","region":"Haifa","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Address: building old (Manadalason), floor 2, Haifa. Check the admission policy with the center beforehand.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '710|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-9258258","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים של כללית. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day hospitalization — Geha","svc":"Psychiatric day hospitalization","region":"Petah Tikva","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day hospitalization — Geha"],"siteAddresses":["1 HaLasinaki, Petah Tikva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '711|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"09-7478532","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים של כללית. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day hospitalization — Shalvata","svc":"Psychiatric day hospitalization","region":"Hod HaSharon","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day hospitalization — Shalvata"],"siteAddresses":["13 Aliit HaNoar, Hod HaSharon"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '712|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-9253617","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים של כללית. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day hospitalization — Schneider","svc":"Psychiatric day hospitalization","region":"Petah Tikva","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day hospitalization — Schneider"],"siteAddresses":["14 Kaplan, Petah Tikva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '713|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"03-5302466","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים ממשלתי. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. כתובת: בית החולים שיבא, תל השומר. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day hospitalization — Sheba","svc":"Psychiatric day hospitalization","region":"Tel HaShomer","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Address: Hospital Sheba, Tel HaShomer. Check the admission policy with the center beforehand.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '714|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"02-6777183","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים – הדסה. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. כתובת: קרית הדסה, ירושלים. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day hospitalization — Hadassah Ain Karam","svc":"Psychiatric day hospitalization","region":"Jerusalem","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Hadassah hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Address: Kiryat Hadassah, Jerusalem. Check the admission policy with the center beforehand.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '715|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phone":"08-6745398","phoneLabel":"טלפון","phoneShowNumber":false,"notes":"סוג בעלות: בית חולים ממשלתי. הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו. מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023. יש לבדוק מראש את מדיניות הקבלה מול המרכז."}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Day hospitalization — Barzilai","svc":"Psychiatric day hospitalization","region":"Ashkelon","cost":"Health basket — with prior approval from the health fund (form 17); quarterly co-payment","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health day-treatment and day-hospitalization list, 2023. Check the admission policy with the center beforehand.","phoneLabel":"Phone","siteLabels":["Day hospitalization — Barzilai"],"siteAddresses":["2 HaHistadrut, Ashkelon"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '716|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Sheba","svc":"Psychiatric hospitalization","region":"Ramat Gan","cost":"Public — through the health funds (health basket)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments.","phoneLabel":"Phone","siteLabels":["Psychiatric hospitalization — Sheba"],"siteAddresses":["Tal-HaShomar, Ramat Gan"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '717|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Ramavam","svc":"Psychiatric hospitalization","region":"Haifa","cost":"Public — through the health funds (health basket)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: 8 Rach HaAlia, Bat Galim, Haifa.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '718|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Shamir (Asaf HaRof)","svc":"Psychiatric hospitalization","region":"Be''er Yaakov","cost":"Public — through the health funds (health basket)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments.","phoneLabel":"Phone","siteLabels":["Psychiatric hospitalization — Shamir (Asaf HaRof)"],"siteAddresses":["Tsarifin, Be''er Yaakov"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '719|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Wolfson","svc":"Psychiatric hospitalization","region":"Holon","cost":"Public — through the health funds (health basket)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: 62 Rach HaLochamim, Holon.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '720|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Ziv","svc":"Psychiatric hospitalization","region":"Safed","cost":"Public — through the health funds (health basket)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments.","phoneLabel":"Phone","siteLabels":["Psychiatric hospitalization — Ziv"],"siteAddresses":["Derekh HaRamavam, Safed"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '721|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Hillel Yaffe","svc":"Psychiatric hospitalization","region":"Hadera","cost":"Public — through the health funds (health basket)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments.","phoneLabel":"Phone","siteLabels":["Psychiatric hospitalization — Hillel Yaffe"],"siteAddresses":["Kavish HaChof, Hadera"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '722|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"המרכז הרפואי לגליל, נהריה"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Galilee Medical Center, Nahariya","svc":"Psychiatric hospitalization","region":"Nahariya","cost":"Public — through the health funds (health basket)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments.","phoneLabel":"Phone","siteLabels":["Galilee Medical Center, Nahariya"],"siteAddresses":["Shad Ben Tsavi, Nahariya"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '723|||אשפוז פסיכיאטרי';

UPDATE directory_entries
SET display_name = 'המרכז הרפואי לגליל, נהריה'
WHERE entry_id = 'אשפוז_פסיכיאטרי_המרכז_הרפואי_לגליל_נהריה_723';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Barzilai","svc":"Psychiatric hospitalization","region":"Ashkelon","cost":"Public — through the health funds (health basket)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: 2 Rach HaHistadrut, Ashkelon.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '724|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Poria","svc":"Psychiatric hospitalization","region":"Tiberias","cost":"Public — through the health funds (health basket)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: Ramat Poria, Tiberias.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '725|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Sorasaki (Ichilov)","svc":"Psychiatric hospitalization","region":"Tel Aviv-Yafo","cost":"Public — through the health funds (health basket)","notes":"Ownership: Municipal-government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: 6 Rach Weizmann, Tel Aviv-Yafo.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '726|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Bani Tsion","svc":"Psychiatric hospitalization","region":"Haifa","cost":"Public — through the health funds (health basket)","notes":"Ownership: Municipal-government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: 47 Rach Golomav, Haifa.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '727|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Soroka","svc":"Psychiatric hospitalization","region":"Be''er Sheva","cost":"Public — through the health funds (health basket)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments.","phoneLabel":"Phone","siteLabels":["Psychiatric hospitalization — Soroka"],"siteAddresses":["Shad Ben Gurion, Be''er Sheva"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '728|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Meir","svc":"Psychiatric hospitalization","region":"Kfar Saba","cost":"Public — through the health funds (health basket)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: 59 Rach Tasharanichovasaki, Kfar Saba.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '729|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Kaplan","svc":"Psychiatric hospitalization","region":"Rehovot","cost":"Public — through the health funds (health basket)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: Derekh Pasataranak, Tsomat Bilav, Rehovot.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '730|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — HaMarakhazi Bamak","svc":"Psychiatric hospitalization","region":"Afula","cost":"Public — through the health funds (health basket)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments.","phoneLabel":"Phone","siteLabels":["Psychiatric hospitalization — HaMarakhazi Bamak"],"siteAddresses":["21 Shad Yitzhak Rabin, Afula"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '731|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Hadassah Ain Karam","svc":"Psychiatric hospitalization","region":"Jerusalem","cost":"Public — through the health funds (health basket)","notes":"Ownership: Hadassah hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: Kiryat Hadassah, Jerusalem.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '732|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Hadassah Har HaTsofim","svc":"Psychiatric hospitalization","region":"Jerusalem","cost":"Public — through the health funds (health basket)","notes":"Ownership: Hadassah hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments.","phoneLabel":"Phone","siteLabels":["Psychiatric hospitalization — Hadassah Har HaTsofim"],"siteAddresses":["Har HaTsofim, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '733|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — HaSakoti (Hospital HaAnagali)","svc":"Psychiatric hospitalization","region":"Nazareth","cost":"Public — through the health funds (health basket)","notes":"Ownership: Mission hospital (nonprofit). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: T.D. 11, Nazareth.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '734|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Sanat Vinasanat","svc":"Psychiatric hospitalization","region":"Nazareth","cost":"Public — through the health funds (health basket)","notes":"Ownership: Mission hospital (nonprofit). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: Rach Paolos HaShishi, Nazareth.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '735|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — HaMashafacha HaKadosha","svc":"Psychiatric hospitalization","region":"Nazareth","cost":"Public — through the health funds (health basket)","notes":"Ownership: Mission hospital (nonprofit). The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: Rach Namasaoi, Nazareth.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '736|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Shari Tsadak","svc":"Psychiatric hospitalization","region":"Jerusalem","cost":"Public — through the health funds (health basket)","notes":"Ownership: Public nonprofit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: Rach Shamoal Biit, Jerusalem.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '737|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Maiini HaYshoaa","svc":"Psychiatric hospitalization","region":"Bnei Brak","cost":"Public — through the health funds (health basket)","notes":"Ownership: Public nonprofit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: 17 Rach Sharat, Bnei Brak.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '738|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — medical center Herzliya","svc":"Psychiatric hospitalization","region":"Herzliya","cost":"Not stated (private hospital)","notes":"Ownership: Private hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: 7 Ramot Ym, Herzliya.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '739|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Schneider","svc":"Psychiatric hospitalization","region":"Petah Tikva","cost":"Public — through the health funds (health basket)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: 14 Rach Kaplan, Petah Tikva.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '740|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Sha''ar Menashe","svc":"Psychiatric hospitalization","region":"Sha''ar Menashe","cost":"Public — through the health funds (health basket)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: D.N. Chafar, Sha''ar Menashe.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '741|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Yehuda Abarbanel","svc":"Psychiatric hospitalization","region":"Bat Yam","cost":"Public — through the health funds (health basket)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: 51 Sderot Kakal, Bat Yam.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '742|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Mazor","svc":"Psychiatric hospitalization","region":"Acre","cost":"Public — through the health funds (health basket)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: neighborhood HaKaram, D.N. Asharat, Acre.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '743|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"באר יעקב"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Be''er Yaakov","svc":"Psychiatric hospitalization","region":"Be''er Yaakov","cost":"Public — through the health funds (health basket)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: T.D. 1, Be''er Yaakov.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '744|||אשפוז פסיכיאטרי';

UPDATE directory_entries
SET display_name = 'באר יעקב'
WHERE entry_id = 'אשפוז_פסיכיאטרי_מרחבים_באר_יעקב_נס_ציונה_744';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Lev Hasharon","svc":"Psychiatric hospitalization","region":"Netanya","cost":"Public — through the health funds (health basket)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: T.D. 90000, Netanya.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '745|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"טירת הכרמל, טירת כרמל"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Tirat Carmel","svc":"Psychiatric hospitalization","region":"Tirat Carmel","cost":"Public — through the health funds (health basket)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments.","phoneLabel":"Phone","siteLabels":["Tirat Carmel"],"siteAddresses":["17 HaAla, Tirat Carmel"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '746|||אשפוז פסיכיאטרי';

UPDATE directory_entries
SET display_name = 'טירת הכרמל, טירת כרמל'
WHERE entry_id = 'אשפוז_פסיכיאטרי_מעלה_הכרמל_746';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false,"org":"המרכז לבריאות הנפש באר שבע"}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Be''er Sheva Mental Health Center","svc":"Psychiatric hospitalization","region":"Be''er Sheva","cost":"Public — through the health funds (health basket)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: 2 Rach HaTzadik miYerushalayim, Be''er Sheva.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '747|||אשפוז פסיכיאטרי';

UPDATE directory_entries
SET display_name = 'המרכז לבריאות הנפש באר שבע'
WHERE entry_id = 'אשפוז_פסיכיאטרי_המרכז_לבריאות_הנפש_באר_שבע_747';

UPDATE directory_card_edits
SET public_fields = public_fields || '{}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — HaMarakhaz HaYroshalami mental health (Kfar Shaul, Eitanim)","svc":"Psychiatric hospitalization","region":"Jerusalem","cost":"Public — through the health funds (health basket)","notes":"Ownership: Government hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: Atar Kfar Shaul, Atar Eitanim, Jerusalem."}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '748|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Geha","svc":"Psychiatric hospitalization","region":"Petah Tikva","cost":"Public — through the health funds (health basket)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: Rach HaLasinaki, Petah Tikva.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '749|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Shalvata","svc":"Psychiatric hospitalization","region":"Hod HaSharon","cost":"Public — through the health funds (health basket)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: Rach Aliit HaNoar, Hod HaSharon.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '750|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Aylanit","svc":"Psychiatric hospitalization","region":"Pardes Hanna-Karkur","cost":"Not stated (private hospital)","notes":"Ownership: Private hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: 1 Rach HaNarakis, Pardes Hanna-Karkur.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '751|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — Herzog","svc":"Psychiatric hospitalization","region":"Jerusalem","cost":"Public — through the health funds (health basket)","notes":"Ownership: Public nonprofit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments.","phoneLabel":"Phone","siteLabels":["Psychiatric hospitalization — Herzog"],"siteAddresses":["Givat Shaul, Jerusalem"]}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '752|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — rehabilitation Loinashatiin","svc":"Psychiatric hospitalization","region":"Ra''anana","cost":"Public — through the health funds (health basket)","notes":"Ownership: Clalit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: 278 Rach Achoza, Ra''anana.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '753|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET public_fields = public_fields || '{"phoneLabel":"טלפון","phoneShowNumber":false}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"org":"Psychiatric hospitalization — ALYN","svc":"Psychiatric hospitalization","region":"Jerusalem","cost":"Public — through the health funds (health basket)","notes":"Ownership: Public nonprofit hospital. The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic. Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments. Address: Rach Shamarihav Loin, Kiryat Yoval, Jerusalem.","phoneLabel":"Phone"}'::jsonb,
      true
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '754|||אשפוז פסיכיאטרי';

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-09-public-clinic-names',
  DATE '2026-11-09',
  'שמות הקופה או המרכז על הכרטיסים הציבוריים',
  'במרפאות, בטיפול היום ובאשפוז מרשימות משרד הבריאות, כרטיס שהשם שלו היה רחוב, שכונה, עיר או קבוצת גיל נקרא עכשיו על שם הקופה או המרכז לבריאות הנפש, והעיר. הרחוב נשאר במפה. כפתור הטלפון אומר «טלפון» בלי המספר. באנגלית הנוסח של הכרטיסים האלה באנגלית.',
  'cards',
  ARRAY['358|||מרפאה רב-צוותית לבריאות הנפש', '359|||מרפאה רב-צוותית לבריאות הנפש', '360|||מרפאה רב-צוותית לבריאות הנפש', '361|||מרפאה רב-צוותית לבריאות הנפש', '362|||מרפאה רב-צוותית לבריאות הנפש', '363|||מרפאה רב-צוותית לבריאות הנפש', '364|||מרפאה רב-צוותית לבריאות הנפש', '365|||מרפאה רב-צוותית לבריאות הנפש', '366|||מרפאה רב-צוותית לבריאות הנפש', '367|||מרפאה רב-צוותית לבריאות הנפש', '368|||מרפאה רב-צוותית לבריאות הנפש', '369|||מרפאה רב-צוותית לבריאות הנפש', '370|||מרפאה רב-צוותית לבריאות הנפש', '371|||מרפאה רב-צוותית לבריאות הנפש', '372|||מרפאה רב-צוותית לבריאות הנפש', '373|||מרפאה רב-צוותית לבריאות הנפש', '374|||מרפאה רב-צוותית לבריאות הנפש', '375|||מרפאה רב-צוותית לבריאות הנפש', '376|||מרפאה רב-צוותית לבריאות הנפש', '377|||מרפאה רב-צוותית לבריאות הנפש', '378|||מרפאה רב-צוותית לבריאות הנפש', '379|||מרפאה רב-צוותית לבריאות הנפש', '380|||מרפאה רב-צוותית לבריאות הנפש', '381|||מרפאה רב-צוותית לבריאות הנפש', '382|||מרפאה רב-צוותית לבריאות הנפש', '383|||מרפאה רב-צוותית לבריאות הנפש', '384|||מרפאה רב-צוותית לבריאות הנפש', '385|||מרפאה רב-צוותית לבריאות הנפש', '386|||מרפאה רב-צוותית לבריאות הנפש', '387|||מרפאה רב-צוותית לבריאות הנפש', '388|||מרפאה רב-צוותית לבריאות הנפש', '389|||מרפאה רב-צוותית לבריאות הנפש', '390|||מרפאה רב-צוותית לבריאות הנפש', '391|||מרפאה רב-צוותית לבריאות הנפש', '392|||מרפאה רב-צוותית לבריאות הנפש', '393|||מרפאה רב-צוותית לבריאות הנפש', '394|||מרפאה רב-צוותית לבריאות הנפש', '395|||מרפאה רב-צוותית לבריאות הנפש', '396|||מרפאה רב-צוותית לבריאות הנפש', '397|||מרפאה רב-צוותית לבריאות הנפש', '398|||מרפאה רב-צוותית לבריאות הנפש', '399|||מרפאה רב-צוותית לבריאות הנפש', '400|||מרפאה רב-צוותית לבריאות הנפש', '401|||מרפאה רב-צוותית לבריאות הנפש', '402|||מרפאה רב-צוותית לבריאות הנפש', '403|||מרפאה רב-צוותית לבריאות הנפש', '404|||מרפאה רב-צוותית לבריאות הנפש', '405|||מרפאה רב-צוותית לבריאות הנפש', '406|||מרפאה רב-צוותית לבריאות הנפש', '407|||מרפאה רב-צוותית לבריאות הנפש', '408|||מרפאה רב-צוותית לבריאות הנפש', '409|||מרפאה רב-צוותית לבריאות הנפש', '410|||מרפאה רב-צוותית לבריאות הנפש', '411|||מרפאה רב-צוותית לבריאות הנפש', '412|||מרפאה רב-צוותית לבריאות הנפש', '413|||מרפאה רב-צוותית לבריאות הנפש', '414|||מרפאה רב-צוותית לבריאות הנפש', '415|||מרפאה רב-צוותית לבריאות הנפש', '416|||מרפאה רב-צוותית לבריאות הנפש', '417|||מרפאה רב-צוותית לבריאות הנפש', '418|||מרפאה רב-צוותית לבריאות הנפש', '419|||מרפאה רב-צוותית לבריאות הנפש', '420|||מרפאה רב-צוותית לבריאות הנפש', '421|||מרפאה רב-צוותית לבריאות הנפש', '422|||מרפאה רב-צוותית לבריאות הנפש', '423|||מרפאה רב-צוותית לבריאות הנפש', '424|||מרפאה רב-צוותית לבריאות הנפש', '425|||מרפאה רב-צוותית לבריאות הנפש', '426|||מרפאה רב-צוותית לבריאות הנפש', '427|||מרפאה רב-צוותית לבריאות הנפש', '428|||מרפאה רב-צוותית לבריאות הנפש', '429|||מרפאה רב-צוותית לבריאות הנפש', '430|||מרפאה רב-צוותית לבריאות הנפש', '431|||מרפאה רב-צוותית לבריאות הנפש', '432|||מרפאה רב-צוותית לבריאות הנפש', '433|||מרפאה רב-צוותית לבריאות הנפש', '434|||מרפאה רב-צוותית לבריאות הנפש', '435|||מרפאה רב-צוותית לבריאות הנפש', '436|||מרפאה רב-צוותית לבריאות הנפש', '437|||מרפאה רב-צוותית לבריאות הנפש', '438|||מרפאה רב-צוותית לבריאות הנפש', '439|||מרפאה רב-צוותית לבריאות הנפש', '440|||מרפאה רב-צוותית לבריאות הנפש', '441|||מרפאה רב-צוותית לבריאות הנפש', '442|||מרפאה רב-צוותית לבריאות הנפש', '443|||מרפאה רב-צוותית לבריאות הנפש', '444|||מרפאה רב-צוותית לבריאות הנפש', '445|||מרפאה רב-צוותית לבריאות הנפש', '446|||מרפאה רב-צוותית לבריאות הנפש', '447|||מרפאה רב-צוותית לבריאות הנפש', '448|||מרפאה רב-צוותית לבריאות הנפש', '449|||מרפאה רב-צוותית לבריאות הנפש', '450|||מרפאה רב-צוותית לבריאות הנפש', '451|||מרפאה רב-צוותית לבריאות הנפש', '452|||מרפאה רב-צוותית לבריאות הנפש', '453|||מרפאה רב-צוותית לבריאות הנפש', '454|||מרפאה רב-צוותית לבריאות הנפש', '455|||מרפאה רב-צוותית לבריאות הנפש', '456|||מרפאה רב-צוותית לבריאות הנפש', '457|||מרפאה רב-צוותית לבריאות הנפש', '458|||מרפאה רב-צוותית לבריאות הנפש', '459|||מרפאה רב-צוותית לבריאות הנפש', '460|||מרפאה רב-צוותית לבריאות הנפש', '461|||מרפאה רב-צוותית לבריאות הנפש', '462|||מרפאה רב-צוותית לבריאות הנפש', '463|||מרפאה רב-צוותית לבריאות הנפש', '464|||מרפאה רב-צוותית לבריאות הנפש', '465|||מרפאה רב-צוותית לבריאות הנפש', '466|||מרפאה רב-צוותית לבריאות הנפש', '467|||מרפאה רב-צוותית לבריאות הנפש', '468|||מרפאה רב-צוותית לבריאות הנפש', '469|||מרפאה רב-צוותית לבריאות הנפש', '470|||מרפאה רב-צוותית לבריאות הנפש', '471|||מרפאה רב-צוותית לבריאות הנפש', '472|||מרפאה רב-צוותית לבריאות הנפש', '473|||מרפאה רב-צוותית לבריאות הנפש', '474|||מרפאה רב-צוותית לבריאות הנפש', '475|||מרפאה רב-צוותית לבריאות הנפש', '476|||מרפאה רב-צוותית לבריאות הנפש', '477|||מרפאה רב-צוותית לבריאות הנפש', '478|||מרפאה רב-צוותית לבריאות הנפש', '479|||מרפאה רב-צוותית לבריאות הנפש', '480|||מרפאה רב-צוותית לבריאות הנפש', '481|||מרפאה רב-צוותית לבריאות הנפש', '482|||מרפאה רב-צוותית לבריאות הנפש', '483|||מרפאה רב-צוותית לבריאות הנפש', '484|||מרפאה רב-צוותית לבריאות הנפש', '485|||מרפאה רב-צוותית לבריאות הנפש', '486|||מרפאה רב-צוותית לבריאות הנפש', '487|||מרפאה רב-צוותית לבריאות הנפש', '488|||מרפאה רב-צוותית לבריאות הנפש', '489|||מרפאה רב-צוותית לבריאות הנפש', '490|||מרפאה רב-צוותית לבריאות הנפש', '491|||מרפאה רב-צוותית לבריאות הנפש', '492|||מרפאה רב-צוותית לבריאות הנפש', '493|||מרפאה רב-צוותית לבריאות הנפש', '494|||מרפאה רב-צוותית לבריאות הנפש', '495|||מרפאה רב-צוותית לבריאות הנפש', '496|||מרפאה רב-צוותית לבריאות הנפש', '497|||מרפאה רב-צוותית לבריאות הנפש', '498|||מרפאה רב-צוותית לבריאות הנפש', '499|||מרפאה רב-צוותית לבריאות הנפש', '500|||מרפאה רב-צוותית לבריאות הנפש', '501|||מרפאה רב-צוותית לבריאות הנפש', '502|||מרפאה רב-צוותית לבריאות הנפש', '503|||מרפאה רב-צוותית לבריאות הנפש', '504|||מרפאה רב-צוותית לבריאות הנפש', '505|||מרפאה רב-צוותית לבריאות הנפש', '506|||מרפאה רב-צוותית לבריאות הנפש', '507|||מרפאה רב-צוותית לבריאות הנפש', '508|||מרפאה רב-צוותית לבריאות הנפש', '509|||מרפאה רב-צוותית לבריאות הנפש', '510|||מרפאה רב-צוותית לבריאות הנפש', '511|||מרפאה רב-צוותית לבריאות הנפש', '512|||מרפאה רב-צוותית לבריאות הנפש', '513|||מרפאה רב-צוותית לבריאות הנפש', '514|||מרפאה רב-צוותית לבריאות הנפש', '515|||מרפאה רב-צוותית לבריאות הנפש', '516|||מרפאה רב-צוותית לבריאות הנפש', '517|||מרפאה רב-צוותית לבריאות הנפש', '518|||מרפאה רב-צוותית לבריאות הנפש', '519|||מרפאה רב-צוותית לבריאות הנפש', '520|||מרפאה רב-צוותית לבריאות הנפש', '521|||מרפאה רב-צוותית לבריאות הנפש', '522|||מרפאה רב-צוותית לבריאות הנפש', '523|||מרפאה רב-צוותית לבריאות הנפש', '524|||מרפאה רב-צוותית לבריאות הנפש', '525|||מרפאה רב-צוותית לבריאות הנפש', '526|||מרפאה רב-צוותית לבריאות הנפש', '527|||מרפאה רב-צוותית לבריאות הנפש', '528|||מרפאה רב-צוותית לבריאות הנפש', '529|||מרפאה רב-צוותית לבריאות הנפש', '530|||מרפאה רב-צוותית לבריאות הנפש', '531|||מרפאה רב-צוותית לבריאות הנפש', '532|||מרפאה רב-צוותית לבריאות הנפש', '533|||מרפאה רב-צוותית לבריאות הנפש', '534|||מרפאה רב-צוותית לבריאות הנפש', '535|||מרפאה רב-צוותית לבריאות הנפש', '536|||מרפאה רב-צוותית לבריאות הנפש', '537|||מרפאה רב-צוותית לבריאות הנפש', '538|||מרפאה רב-צוותית לבריאות הנפש', '539|||מרפאה רב-צוותית לבריאות הנפש', '540|||מרפאה רב-צוותית לבריאות הנפש', '541|||מרפאה רב-צוותית לבריאות הנפש', '542|||מרפאה רב-צוותית לבריאות הנפש', '543|||מרפאה רב-צוותית לבריאות הנפש', '544|||מרפאה רב-צוותית לבריאות הנפש', '545|||מרפאה רב-צוותית לבריאות הנפש', '546|||מרפאה רב-צוותית לבריאות הנפש', '547|||מרפאה רב-צוותית לבריאות הנפש', '548|||מרפאה רב-צוותית לבריאות הנפש', '549|||מרפאה רב-צוותית לבריאות הנפש', '550|||מרפאה רב-צוותית לבריאות הנפש', '551|||מרפאה רב-צוותית לבריאות הנפש', '552|||מרפאה רב-צוותית לבריאות הנפש', '553|||מרפאה רב-צוותית לבריאות הנפש', '554|||מרפאה רב-צוותית לבריאות הנפש', '555|||מרפאה רב-צוותית לבריאות הנפש', '556|||מרפאה רב-צוותית לבריאות הנפש', '557|||מרפאה רב-צוותית לבריאות הנפש', '558|||מרפאה רב-צוותית לבריאות הנפש', '559|||מרפאה רב-צוותית לבריאות הנפש', '560|||מרפאה רב-צוותית לבריאות הנפש', '561|||מרפאה רב-צוותית לבריאות הנפש', '562|||מרפאה רב-צוותית לבריאות הנפש', '563|||מרפאה רב-צוותית לבריאות הנפש', '564|||מרפאה רב-צוותית לבריאות הנפש', '565|||מרפאה רב-צוותית לבריאות הנפש', '566|||מרפאה רב-צוותית לבריאות הנפש', '567|||מרפאה רב-צוותית לבריאות הנפש', '568|||מרפאה רב-צוותית לבריאות הנפש', '569|||מרפאה רב-צוותית לבריאות הנפש', '570|||מרפאה רב-צוותית לבריאות הנפש', '571|||מרפאה רב-צוותית לבריאות הנפש', '572|||מרפאה רב-צוותית לבריאות הנפש', '573|||מרפאה רב-צוותית לבריאות הנפש', '574|||מרפאה רב-צוותית לבריאות הנפש', '575|||מרפאה רב-צוותית לבריאות הנפש', '576|||מרפאה רב-צוותית לבריאות הנפש', '577|||מרפאה רב-צוותית לבריאות הנפש', '578|||מרפאה רב-צוותית לבריאות הנפש', '579|||מרפאה רב-צוותית לבריאות הנפש', '580|||מרפאה רב-צוותית לבריאות הנפש', '581|||מרפאה רב-צוותית לבריאות הנפש', '582|||מרפאה רב-צוותית לבריאות הנפש', '583|||מרפאה רב-צוותית לבריאות הנפש', '584|||מרפאה רב-צוותית לבריאות הנפש', '585|||מרפאה רב-צוותית לבריאות הנפש', '586|||מרפאה רב-צוותית לבריאות הנפש', '587|||מרפאה רב-צוותית לבריאות הנפש', '588|||מרפאה רב-צוותית לבריאות הנפש', '589|||מרפאה רב-צוותית לבריאות הנפש', '590|||מרפאה רב-צוותית לבריאות הנפש', '591|||מרפאה רב-צוותית לבריאות הנפש', '592|||מרפאה רב-צוותית לבריאות הנפש', '593|||מרפאה רב-צוותית לבריאות הנפש', '594|||מרפאה רב-צוותית לבריאות הנפש', '595|||מרפאה רב-צוותית לבריאות הנפש', '596|||מרפאה רב-צוותית לבריאות הנפש', '597|||מרפאה רב-צוותית לבריאות הנפש', '598|||מרפאה רב-צוותית לבריאות הנפש', '599|||מרפאה רב-צוותית לבריאות הנפש', '600|||מרפאה רב-צוותית לבריאות הנפש', '601|||מרפאה רב-צוותית לבריאות הנפש', '602|||מרפאה רב-צוותית לבריאות הנפש', '603|||מרפאה רב-צוותית לבריאות הנפש', '604|||מרפאה רב-צוותית לבריאות הנפש', '605|||מרפאה רב-צוותית לבריאות הנפש', '606|||מרפאה רב-צוותית לבריאות הנפש', '607|||מרפאה רב-צוותית לבריאות הנפש', '608|||מרפאה רב-צוותית לבריאות הנפש', '609|||מרפאה רב-צוותית לבריאות הנפש', '610|||מרפאה רב-צוותית לבריאות הנפש', '611|||מרפאה רב-צוותית לבריאות הנפש', '612|||מרפאה רב-צוותית לבריאות הנפש', '613|||מרפאה רב-צוותית לבריאות הנפש', '614|||מרפאה רב-צוותית לבריאות הנפש', '615|||מרפאה רב-צוותית לבריאות הנפש', '616|||מרפאה רב-צוותית לבריאות הנפש', '617|||מרפאה רב-צוותית לבריאות הנפש', '618|||מרפאה רב-צוותית לבריאות הנפש', '619|||מרפאה רב-צוותית לבריאות הנפש', '620|||מרפאה רב-צוותית לבריאות הנפש', '621|||מרפאה רב-צוותית לבריאות הנפש', '622|||מרפאה רב-צוותית לבריאות הנפש', '623|||מרפאה רב-צוותית לבריאות הנפש', '624|||מרפאה רב-צוותית לבריאות הנפש', '625|||מרפאה רב-צוותית לבריאות הנפש', '626|||מרפאה רב-צוותית לבריאות הנפש', '627|||מרפאה רב-צוותית לבריאות הנפש', '628|||מרפאה רב-צוותית לבריאות הנפש', '629|||מרפאה רב-צוותית לבריאות הנפש', '630|||מרפאה רב-צוותית לבריאות הנפש', '631|||מרפאה רב-צוותית לבריאות הנפש', '632|||מרפאה רב-צוותית לבריאות הנפש', '633|||מרפאה רב-צוותית לבריאות הנפש', '634|||מרפאה רב-צוותית לבריאות הנפש', '635|||מרפאה רב-צוותית לבריאות הנפש', '636|||מרפאה רב-צוותית לבריאות הנפש', '637|||מרפאה רב-צוותית לבריאות הנפש', '638|||מרפאה רב-צוותית לבריאות הנפש', '639|||מרפאה רב-צוותית לבריאות הנפש', '640|||מרפאה רב-צוותית לבריאות הנפש', '641|||מרפאה רב-צוותית לבריאות הנפש', '642|||מרפאה רב-צוותית לבריאות הנפש', '643|||מרפאה רב-צוותית לבריאות הנפש', '644|||מרפאה רב-צוותית לבריאות הנפש', '645|||מרפאה רב-צוותית לבריאות הנפש', '646|||מרפאה רב-צוותית לבריאות הנפש', '647|||מרפאה רב-צוותית לבריאות הנפש', '648|||מרפאה רב-צוותית לבריאות הנפש', '649|||מרפאה רב-צוותית לבריאות הנפש', '650|||מרפאה רב-צוותית לבריאות הנפש', '651|||מרפאה רב-צוותית לבריאות הנפש', '652|||מרפאה רב-צוותית לבריאות הנפש', '653|||מרפאה רב-צוותית לבריאות הנפש', '654|||מרפאה רב-צוותית לבריאות הנפש', '655|||מרפאה רב-צוותית לבריאות הנפש', '656|||מרפאה רב-צוותית לבריאות הנפש', '657|||מרפאה רב-צוותית לבריאות הנפש', '658|||מרפאה רב-צוותית לבריאות הנפש', '659|||מרפאה רב-צוותית לבריאות הנפש', '660|||מרפאה רב-צוותית לבריאות הנפש', '661|||מרפאה רב-צוותית לבריאות הנפש', '662|||מרפאה רב-צוותית לבריאות הנפש', '663|||מרפאה רב-צוותית לבריאות הנפש', '664|||מרפאה רב-צוותית לבריאות הנפש', '665|||מרפאה רב-צוותית לבריאות הנפש', '666|||מרפאה רב-צוותית לבריאות הנפש', '667|||מרפאה רב-צוותית לבריאות הנפש', '668|||מרפאה רב-צוותית לבריאות הנפש', '669|||מרפאה רב-צוותית לבריאות הנפש', '670|||מרפאה רב-צוותית לבריאות הנפש', '671|||מרפאה רב-צוותית לבריאות הנפש', '672|||מרפאה רב-צוותית לבריאות הנפש', '673|||מרפאה רב-צוותית לבריאות הנפש', '674|||מרפאה רב-צוותית לבריאות הנפש', '675|||מרפאה רב-צוותית לבריאות הנפש', '676|||מרפאה רב-צוותית לבריאות הנפש', '677|||מרפאה רב-צוותית לבריאות הנפש', '678|||מרפאה רב-צוותית לבריאות הנפש', '679|||מרפאה רב-צוותית לבריאות הנפש', '680|||מרפאה רב-צוותית לבריאות הנפש', '681|||מרפאה רב-צוותית לבריאות הנפש', '682|||מרפאה רב-צוותית לבריאות הנפש', '683|||מרפאה רב-צוותית לבריאות הנפש', '684|||מרפאה רב-צוותית לבריאות הנפש', '685|||טיפול יום פסיכיאטרי', '686|||טיפול יום פסיכיאטרי', '687|||טיפול יום פסיכיאטרי', '688|||טיפול יום פסיכיאטרי', '689|||טיפול יום פסיכיאטרי', '690|||טיפול יום פסיכיאטרי', '691|||טיפול יום פסיכיאטרי', '692|||טיפול יום פסיכיאטרי', '693|||טיפול יום פסיכיאטרי', '694|||טיפול יום פסיכיאטרי', '695|||טיפול יום פסיכיאטרי', '696|||טיפול יום פסיכיאטרי', '697|||טיפול יום פסיכיאטרי', '698|||טיפול יום פסיכיאטרי', '699|||טיפול יום פסיכיאטרי', '700|||טיפול יום פסיכיאטרי', '701|||טיפול יום פסיכיאטרי', '702|||טיפול יום פסיכיאטרי', '703|||טיפול יום פסיכיאטרי', '704|||טיפול יום פסיכיאטרי', '705|||טיפול יום פסיכיאטרי', '706|||אשפוז יום פסיכיאטרי', '707|||אשפוז יום פסיכיאטרי', '708|||אשפוז יום פסיכיאטרי', '709|||אשפוז יום פסיכיאטרי', '710|||אשפוז יום פסיכיאטרי', '711|||אשפוז יום פסיכיאטרי', '712|||אשפוז יום פסיכיאטרי', '713|||אשפוז יום פסיכיאטרי', '714|||אשפוז יום פסיכיאטרי', '715|||אשפוז יום פסיכיאטרי', '716|||אשפוז יום פסיכיאטרי', '717|||אשפוז פסיכיאטרי', '718|||אשפוז פסיכיאטרי', '719|||אשפוז פסיכיאטרי', '720|||אשפוז פסיכיאטרי', '721|||אשפוז פסיכיאטרי', '722|||אשפוז פסיכיאטרי', '723|||אשפוז פסיכיאטרי', '724|||אשפוז פסיכיאטרי', '725|||אשפוז פסיכיאטרי', '726|||אשפוז פסיכיאטרי', '727|||אשפוז פסיכיאטרי', '728|||אשפוז פסיכיאטרי', '729|||אשפוז פסיכיאטרי', '730|||אשפוז פסיכיאטרי', '731|||אשפוז פסיכיאטרי', '732|||אשפוז פסיכיאטרי', '733|||אשפוז פסיכיאטרי', '734|||אשפוז פסיכיאטרי', '735|||אשפוז פסיכיאטרי', '736|||אשפוז פסיכיאטרי', '737|||אשפוז פסיכיאטרי', '738|||אשפוז פסיכיאטרי', '739|||אשפוז פסיכיאטרי', '740|||אשפוז פסיכיאטרי', '741|||אשפוז פסיכיאטרי', '742|||אשפוז פסיכיאטרי', '743|||אשפוז פסיכיאטרי', '744|||אשפוז פסיכיאטרי', '745|||אשפוז פסיכיאטרי', '746|||אשפוז פסיכיאטרי', '747|||אשפוז פסיכיאטרי', '748|||אשפוז פסיכיאטרי', '749|||אשפוז פסיכיאטרי', '750|||אשפוז פסיכיאטרי', '751|||אשפוז פסיכיאטרי', '752|||אשפוז פסיכיאטרי', '753|||אשפוז פסיכיאטרי', '754|||אשפוז פסיכיאטרי']::text[],
  '{}',
  '128_mh_public_names_english.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
