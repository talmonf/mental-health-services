-- Migration 124 (8 Nov 2026)
-- The languages in which each card's own website pages exist, and the address of each page.
-- English lists a card only when English is marked, and the website button opens that page.
-- A language menu that only points at a homepage is not treated as a translation of a deeper page.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

ALTER TABLE directory_card_edits
  ADD COLUMN IF NOT EXISTS site_languages jsonb NOT NULL DEFAULT '{}'::jsonb;

COMMENT ON COLUMN directory_card_edits.site_languages IS
  'Languages in which this card''s own pages exist. Keys are language codes. Values map website buttons to the URL in that language. Hebrew wording stays in public_fields.';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.btl.gov.il/ZcuyotAsdience/MitmoddiNefesh/Pages/default.aspx"}}'::jsonb
WHERE card_key = '1|||קצבת נכות למתמודדי נפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.btl.gov.il/benefits/Attendance_Allowance/Pages/default.aspx"}}'::jsonb
WHERE card_key = '2|||שירותים מיוחדים (שר"מ)';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.btl.gov.il/benefits/Long_Term_Care/Pages/default.aspx","add":"https://www.kolzchut.org.il/he/%D7%92%D7%9E%D7%9C%D7%AA_%D7%A1%D7%99%D7%A2%D7%95%D7%93"},"ar":{"add":"https://www.kolzchut.org.il/ar/%D9%85%D8%AE%D8%B5%D8%B5%D8%A7%D8%AA_%D8%A7%D9%84%D8%AA%D9%85%D8%B1%D9%8A%D8%B6"},"ru":{"add":"https://www.kolzchut.org.il/ru/%D0%9F%D0%BE%D1%81%D0%BE%D0%B1%D0%B8%D0%B5_%D0%BF%D0%BE_%D1%83%D1%85%D0%BE%D0%B4%D1%83"}}'::jsonb
WHERE card_key = '3|||קצבת סיעוד';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.btl.gov.il/snifim/Pages/yadMechavenet1.aspx"}}'::jsonb
WHERE card_key = '4|||ייעוץ והכנה בחינם לוועדה הרפואית';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/service/rehabilitation-support-package","add":"https://www.kolzchut.org.il/he/%D7%A1%D7%9C_%D7%A9%D7%99%D7%A7%D7%95%D7%9D_%D7%9C%D7%9E%D7%AA%D7%9E%D7%95%D7%93%D7%93%D7%99_%D7%A0%D7%A4%D7%A9"},"ar":{"add":"https://www.kolzchut.org.il/ar/%D8%B3%D9%84%D8%A9_%D8%AA%D8%A3%D9%87%D9%8A%D9%84_%D9%84%D9%84%D9%85%D8%B5%D8%A7%D8%A8%D9%8A%D9%86_%D9%86%D9%81%D8%B3%D9%8A%D8%A7"},"ru":{"add":"https://www.kolzchut.org.il/ru/%D0%9A%D0%BE%D1%80%D0%B7%D0%B8%D0%BD%D0%B0_%D1%80%D0%B5%D0%B0%D0%B1%D0%B8%D0%BB%D0%B8%D1%82%D0%B0%D1%86%D0%B8%D0%B8_%D0%B4%D0%BB%D1%8F_%D1%81%D1%82%D1%80%D0%B0%D0%B4%D0%B0%D1%8E%D1%89%D0%B8%D1%85_%D0%BF%D1%81%D0%B8%D1%85%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B8%D0%BC%D0%B8_%D1%80%D0%B0%D1%81%D1%81%D1%82%D1%80%D0%BE%D0%B9%D1%81%D1%82%D0%B2%D0%B0%D0%BC%D0%B8"}}'::jsonb
WHERE card_key = '5|||סל שיקום';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.enosh.org.il/"},"en":{"web":"https://www.enosh.org.il/english/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.enosh.org.il/english/"}'::jsonb,
      true
    )
WHERE card_key = '6|||שירותי סל שיקום';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://kidumpro.co.il/"}}'::jsonb
WHERE card_key = '7|||שירותי סל שיקום';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://yadidnefesh.co.il/"}}'::jsonb
WHERE card_key = '8|||שירותי סל שיקום';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://orlanefesh.org.il/"}}'::jsonb
WHERE card_key = '9|||שירותי סל שיקום';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '10|||קבלת סיוע נפשי מיידי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/ContactUs/helpline"}}'::jsonb
WHERE card_key = '11|||קו המעניק תמיכה נפשית ראשונית';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/rights/injury-type/mental","add":"https://shikum.mod.gov.il/medical/treatment/therapy#3"}}'::jsonb
WHERE card_key = '12|||זכויות למתמודדים עם פגיעה נפשית';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://me.health.gov.il/mental-health/"},"en":{"web":"https://me.health.gov.il/en/mental-health/"},"ru":{"web":"https://me.health.gov.il/ru/mental-health/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://me.health.gov.il/en/mental-health/"}'::jsonb,
      true
    )
WHERE card_key = '13|||קווי סיוע והכוונה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.btl.gov.il/HaravotBarzel1/Harada_HB/Pages/MrkaziHosenResima.aspx"}}'::jsonb
WHERE card_key = '14|||רשימת מוקדי הטיפול ומרכזי החוסן';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '15|||מוקד סיוע רגשי-חברתי להורים ולתלמידים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/emotional-support-centers"}}'::jsonb
WHERE card_key = '15|||מרכזי תמיכה רגשית ונפשית
';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mh-israel.co.il/"}}'::jsonb
WHERE card_key = '16|||שירותים למתמודד
אינדקס מטפלים
פורומים
ועוד ועוד';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '17|||';

UPDATE directory_card_edits
SET site_languages = '{"en":{"web":"https://gethelpisrael.com/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://gethelpisrael.com/"}'::jsonb,
      true
    )
WHERE card_key = '18|||Provides English-speakers with access to verified mental health specialists as well as resources and information on navigating the mental health system in Israel';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.betipulnet.co.il/articles/%D7%97%D7%A8%D7%93%D7%94_%D7%95%D7%A4%D7%95%D7%A1%D7%98_%D7%98%D7%A8%D7%90%D7%95%D7%9E%D7%94_%D7%A2%D7%9C_%D7%A8%D7%A7%D7%A2_%D7%9C%D7%90%D7%95%D7%9E%D7%99/"}}'::jsonb
WHERE card_key = '19|||אינדקס שירותים למענה נפשי וטיפול בפוסט-טראומה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.eran.org.il/"},"en":{"web":"https://en.eran.org.il/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://en.eran.org.il/"}'::jsonb,
      true
    )
WHERE card_key = '20|||קו סיוע והכוונה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.natal.org.il/"},"en":{"web":"https://www.natal.org.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.natal.org.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '21|||תמיכה נפשית ותעסוקתית לנפגעי טראומה ממלחמה וטרור';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.ril.org.il/"}}'::jsonb
WHERE card_key = '21|||רשת לאומית לחוסן נפשי המאפשרת יצירת כלים אינטראקטיביים מותאמים לקהלי יעד שונים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://sahar.org.il/"},"en":{"web":"https://sahar.org.il/en/"},"ar":{"web":"https://sahar.org.il/arabic/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://sahar.org.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '22|||קו סיוע והכוונה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://sahar.org.il/%d7%9e%d7%90%d7%92%d7%a8-%d7%90%d7%a8%d7%92%d7%95%d7%a0%d7%99-%d7%a1%d7%99%d7%95%d7%a2/"}}'::jsonb
WHERE card_key = '23|||אינדקס שירותים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://metivta.org.il/"},"en":{"web":"https://metivta.org.il/english/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://metivta.org.il/english/"}'::jsonb,
      true
    )
WHERE card_key = '24|||מוקדי סיוע
מרכז טיפול
ועוד';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://cbh.org.il/%D7%A7%D7%91%D7%9C%D7%AA-%D7%A2%D7%96%D7%A8%D7%94/"}}'::jsonb
WHERE card_key = '25|||תמיכה ואוזן קשבת לבני משפחה למתמודדי נפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.ami.org.il/services/mental-counseling"}}'::jsonb
WHERE card_key = '26|||קו ייעוץ ותמיכה - בימים א-ה בשעות 10:00-13:00 ו-16:00-22:00';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.ragish.li/"}}'::jsonb
WHERE card_key = '27|||אינדקס שירותים למתמודדי נפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il/he/your_health/family/mental_health/Pages/default.aspx"}}'::jsonb
WHERE card_key = '28|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il/eligibilites/2062/","add":"https://www.maccabi4u.co.il/31276/digital-services/info/information_mental_health/"},"ar":{"web":"https://www.maccabi4u.co.il/ar/main-arabic/arabic/","add":"https://www.maccabi4u.co.il/ar/main-arabic/arabic/"}}'::jsonb
WHERE card_key = '29|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/Departments/DynamicCollectors/resilience-centers-list"}}'::jsonb
WHERE card_key = '30|||רשימת מרכזי חוסן ברחבי הארץ';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.alhasapa.co.il/"}}'::jsonb
WHERE card_key = '30|||אינדקס מטפלים (כולל פסיכיאטרים)';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.hebpsy.net/pl.asp"}}'::jsonb
WHERE card_key = '31|||אינדקס מטפלים (כולל פסיכיאטרים)';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.betipulnet.co.il/profileUser/profileLists.aspx"}}'::jsonb
WHERE card_key = '32|||אינדקס מטפלים (כולל פסיכיאטרים)';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.medreviews.co.il/search/psychiatry"}}'::jsonb
WHERE card_key = '33|||אינדקס פסיכיאטרים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.infomed.co.il/expertsresults/psychiatry/all_subspecialities/all_areas/"}}'::jsonb
WHERE card_key = '34|||אינדקס פסיכיאטרים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://practitioners.health.gov.il/Practitioners/27"}}'::jsonb
WHERE card_key = '35|||אינדקס פסיכולוגים מורשים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://practitioners.health.gov.il/Hypnotists/901"}}'::jsonb
WHERE card_key = '36|||אינדקס משרד הבריאות - מהפנטים בעלי רשיון';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.raclini.co.il/"}}'::jsonb
WHERE card_key = '37|||אינדקס מטפלים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/Departments/DynamicCollectors/hospitals_psyc?skip=0"}}'::jsonb
WHERE card_key = '38|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/medical/mental-therapy/safe_housing","add":"https://shikum.mod.gov.il/medical/hospitalization/safehouse#1"}}'::jsonb
WHERE card_key = '39|||בית בטוח לטיפול מיידי - חלופת אשפוז';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '40|||צוות משבר (חלופה לחדר מיון)';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://sharanmedical.co.il/psychiatric-consultation-at-home/"}}'::jsonb
WHERE card_key = '41|||ייעוץ פסיכיאטרי מקוון';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://sharanmedical.co.il/online-psychiatric-consultation-for-idf/"}}'::jsonb
WHERE card_key = '42|||ייעוץ פסיכיאטרי מקוון';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://sharanmedical.co.il/psychiatric-home-hospitalization/"}}'::jsonb
WHERE card_key = '43|||אשפוז בית פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://sharanmedical.co.il/voiceover/"}}'::jsonb
WHERE card_key = '45|||הקול שבפנים – טיפול ביתי לצעירים במצבי משבר נפשי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://sharanmedical.co.il/online-therapy/"}}'::jsonb
WHERE card_key = '46|||פסיכותרפיה מקוונת';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '47|||פסיכותרפיה מקוונת';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.sabarhealth.co.il/%d7%a4%d7%a1%d7%99%d7%9b%d7%99%d7%90%d7%98%d7%a8%d7%99%d7%94-%d7%91%d7%91%d7%99%d7%aa/"}}'::jsonb
WHERE card_key = '48|||אשפוז בית פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.indextal.co.il/"}}'::jsonb
WHERE card_key = '49|||התאגדות המטפלים הדתיים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://itacbt.co.il/therapists-index/"}}'::jsonb
WHERE card_key = '50|||אינדקס מטפלים';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '51|||אינדקס מטפלים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.milam.org.il/"}}'::jsonb
WHERE card_key = '52|||מרכזי ייעוץ, הכוונה, סיוע והדרכה למשפחות מתמודדים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/Departments/DynamicCollectors/ballancing-homes-db?skip=0","add":"https://me.health.gov.il/mental-health/therapy-rehabilitation/public-care/community-treatment/balancing-homes/"},"en":{"add":"https://me.health.gov.il/en/mental-health/therapy-rehabilitation/public-care/community-treatment/balancing-homes/"},"ru":{"add":"https://me.health.gov.il/ru/mental-health/therapy-rehabilitation/public-care/community-treatment/balancing-homes/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"add":"https://me.health.gov.il/en/mental-health/therapy-rehabilitation/public-care/community-treatment/balancing-homes/"}'::jsonb,
      true
    )
WHERE card_key = '53|||חלופת אשפוז';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '54|||קבוצה בפייסבוק';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '55|||קבוצה בפייסבוק';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '56|||קבוצה בפייסבוק';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '57|||קבוצה בפייסבוק';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '58|||קבוצה בפייסבוק';

UPDATE directory_card_edits
SET site_languages = '{"he":{"add":"https://www.kan.org.il/content/kan/kan-b/p-10067/"}}'::jsonb
WHERE card_key = '59|||מיצוי זכויות';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.bayit-cham.org.il/"}}'::jsonb
WHERE card_key = '60|||מידע, ייעוץ ותמיכה
מרכזי טיפול
מרכזי שיקום';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.bayit-cham.org.il/%d7%a7%d7%95%d7%95%d7%99-%d7%99%d7%99%d7%a2%d7%95%d7%a5-%d7%a7%d7%a9%d7%95%D7%91%D7%99%D7%9D/"},"en":{"web":"https://www.bayit-cham.org.il/en/kashuvim/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.bayit-cham.org.il/en/kashuvim/"}'::jsonb,
      true
    )
WHERE card_key = '61|||מידע, ייעוץ ותמיכה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.bayit-cham.org.il/%d7%9e%d7%a8%d7%a4%d7%90%d7%aa-%d7%93%d7%a8%d7%95%d7%a8/"},"en":{"web":"https://www.bayit-cham.org.il/en/dror-english/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.bayit-cham.org.il/en/dror-english/"}'::jsonb,
      true
    )
WHERE card_key = '62|||מרפאות לבריאות הנפש
';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://headspace.org.il/"},"en":{"web":"https://headspace.org.il/english/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://headspace.org.il/english/"}'::jsonb,
      true
    )
WHERE card_key = '63|||תמיכה לנוער וצעירים';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '64|||קבוצה חברתית לנערים ונערות מתמודדי ומתמודדות נפש דתיים ודתלשים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.lamerchav.org.il/"}}'::jsonb
WHERE card_key = '65|||מענה מקצועי מותאם תרבות בתחום בריאות הנפש לאוכלוסיה הדתית - חרדית.';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://eychut.org.il/%d7%9e%d7%a8%d7%9b%d7%96-%d7%99%d7%94%d7%b4%d7%9c-%d7%99%d7%99%d7%a2%d7%95%d7%a5-%d7%95%d7%94%d7%9b%d7%95%d7%95%d7%a0%d7%94-%d7%9c%d7%9e%d7%a9%d7%a4%d7%97%d7%95%d7%aa-2/"}}'::jsonb
WHERE card_key = '66|||ייעוץ והכוונה למשפחות בתחום בריאות הנפש · 18:00 - 22:00';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://eychut.org.il/"}}'::jsonb
WHERE card_key = '67|||סיוע למתמודדי נפש דרך שילובם בקהילה תוך ליווי מקצועי אישי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.ami.org.il/services"}}'::jsonb
WHERE card_key = '68|||סיוע למשפחות של מתמודדי נפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://opendialogue.co.il/therapy/"}}'::jsonb
WHERE card_key = '69|||טיפול משפחתי-מערכתי למצבי משבר';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.amcha.org/"}}'::jsonb
WHERE card_key = '70|||תמיכה נפשית וחברתית בניצולי השואה והדור השני ';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.lishma.co.il/"}}'::jsonb
WHERE card_key = '71|||לשילוב מתמודדים והעצמה בבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.zebenafshi.com/"}}'::jsonb
WHERE card_key = '72|||תמיכה בילדים ונוער המטופלים במרכזי בריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.machon-tzohar.com/"}}'::jsonb
WHERE card_key = '73|||נתיבי שיקום והחלמה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://nathan.co.il/%d7%a9%d7%99%d7%a7%d7%95%d7%9d-%d7%95%d7%91%d7%a8%d7%99%d7%90%d7%95%d7%aa-%d7%94%d7%a0%d7%a4%d7%a9/"}}'::jsonb
WHERE card_key = '74|||שיקום ובריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"en":{"web":"https://www.avneichein.org/services/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.avneichein.org/services/"}'::jsonb,
      true
    )
WHERE card_key = '76|||Crisis Support, Family Support, Family & Sibling Therapy, Legal Support, Mentors and Volunteers, Network of Professionals';

UPDATE directory_card_edits
SET site_languages = '{"en":{"web":"https://www.avneichein.org/emergency-mental-health-resources/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.avneichein.org/emergency-mental-health-resources/"}'::jsonb,
      true
    )
WHERE card_key = '77|||Israel''s Emergency Mental Health Resources During War - Comprehensive list of mental health resources';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.psjer.org.il/"}}'::jsonb
WHERE card_key = '78|||המרכז מעניק רצף טיפולי למגוון הפרעות הנפש, בכל הגילאים, למצבים פסיכוטיים חריפים, מצבים ממושכים עם דגש שיקומי ושירות קהילתי. מערך הטיפול כולל את כל סוגי הטיפולים הביולוגיים המקובלים (תרופות חדישות לסוגיהן, חדר סנוסלן – גרייה רב חושית ונזעי חשמל), טיפול זוגי ומשפחתי, פסיכותראפיה פרטנית וקבוצתית, טיפול באומנות וריפוי בעיסוק.';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '79|||תוכנית טיפול ביתי ממושך למתמודדים עם מחלת נפש חמורה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il/%D7%9E%D7%90%D7%95%D7%97%D7%93%D7%AA-%D7%9C%D7%A0%D7%A4%D7%A9/"}}'::jsonb
WHERE card_key = '80|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה';

UPDATE directory_card_edits
SET site_languages = '{"en":{"web":"https://amudim.org.il/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://amudim.org.il/"}'::jsonb,
      true
    )
WHERE card_key = '80|||Clinical case management for English-speakers in Israel from all walks of life: counseling, referrals to therapists, treatment programs, guidance through the legal process';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.leumit.co.il/mental-health-arena/"},"en":{"web":"https://www.leumit.co.il/en/mental-health-arena/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.leumit.co.il/en/mental-health-arena/"}'::jsonb,
      true
    )
WHERE card_key = '81|||מרפאות בריאות הנפש - פסיכיאטר ופסיכותרפיה';

UPDATE directory_card_edits
SET site_languages = '{"en":{"web":"https://www.reliefhelp.org/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.reliefhelp.org/"}'::jsonb,
      true
    )
WHERE card_key = '81|||Help finding qualified mental health providers for English-speakers';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.kolzchut.org.il/he/%D7%A7%D7%91%D7%99%D7%A2%D7%AA_%D7%A0%D7%9B%D7%95%D7%AA_%D7%9C%D7%9E%D7%AA%D7%9E%D7%95%D7%93%D7%93%D7%99_%D7%A0%D7%A4%D7%A9"},"ar":{"web":"https://www.kolzchut.org.il/ar/%D8%AA%D8%AD%D8%AF%D9%8A%D8%AF_%D8%A7%D9%84%D8%A7%D8%B9%D8%A7%D9%82%D8%A9_%D9%84%D9%84%D9%85%D8%B5%D8%A7%D8%A8%D9%8A%D9%86_%D8%A8%D8%A7%D9%84%D8%A3%D9%85%D8%B1%D8%A7%D8%B6_%D8%A7%D9%84%D9%86%D9%81%D8%B3%D9%8A%D8%A9"},"ru":{"web":"https://www.kolzchut.org.il/ru/%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5_%D0%B8%D0%BD%D0%B2%D0%B0%D0%BB%D0%B8%D0%B4%D0%BD%D0%BE%D1%81%D1%82%D0%B8_%D0%B4%D0%BB%D1%8F_%D1%81%D1%82%D1%80%D0%B0%D0%B4%D0%B0%D1%8E%D1%89%D0%B8%D1%85_%D0%BF%D1%81%D0%B8%D1%85%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B8%D0%BC%D0%B8_%D1%80%D0%B0%D1%81%D1%81%D1%82%D1%80%D0%BE%D0%B9%D1%81%D1%82%D0%B2%D0%B0%D0%BC%D0%B8"}}'::jsonb
WHERE card_key = '82|||קביעת נכות למתמודדי נפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.kolzchut.org.il/he/%D7%A7%D7%A6%D7%91%D7%AA_%D7%A9%D7%99%D7%A8%D7%95%D7%AA%D7%99%D7%9D_%D7%9E%D7%99%D7%95%D7%97%D7%93%D7%99%D7%9D"},"ar":{"web":"https://www.kolzchut.org.il/ar/%D9%85%D8%AE%D8%B5%D8%B5%D8%A7%D8%AA_%D8%A7%D9%84%D8%AE%D8%AF%D9%85%D8%A7%D8%AA_%D8%A7%D9%84%D8%AE%D8%A7%D8%B5%D9%91%D8%A9"},"ru":{"web":"https://www.kolzchut.org.il/ru/%D0%9F%D0%BE%D1%81%D0%BE%D0%B1%D0%B8%D0%B5_%D0%BF%D0%BE_%D0%BE%D1%81%D0%BE%D0%B1%D1%8B%D0%BC_%D1%83%D1%81%D0%BB%D1%83%D0%B3%D0%B0%D0%BC"}}'::jsonb
WHERE card_key = '83|||קצבת שירותים מיוחדים למתמודדי נפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.ami.org.il/services/ambulances"}}'::jsonb
WHERE card_key = '83|||הסעות חולים, אמבולנסים לצרכים רפואיים ואירועים משפחתיים, נהגים מתנדבים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.kolzchut.org.il/he/%D7%A1%D7%9C_%D7%A9%D7%99%D7%A7%D7%95%D7%9D_%D7%9C%D7%9E%D7%AA%D7%9E%D7%95%D7%93%D7%93%D7%99_%D7%A0%D7%A4%D7%A9"},"ar":{"web":"https://www.kolzchut.org.il/ar/%D8%B3%D9%84%D8%A9_%D8%AA%D8%A3%D9%87%D9%8A%D9%84_%D9%84%D9%84%D9%85%D8%B5%D8%A7%D8%A8%D9%8A%D9%86_%D9%86%D9%81%D8%B3%D9%8A%D8%A7"},"ru":{"web":"https://www.kolzchut.org.il/ru/%D0%9A%D0%BE%D1%80%D0%B7%D0%B8%D0%BD%D0%B0_%D1%80%D0%B5%D0%B0%D0%B1%D0%B8%D0%BB%D0%B8%D1%82%D0%B0%D1%86%D0%B8%D0%B8_%D0%B4%D0%BB%D1%8F_%D1%81%D1%82%D1%80%D0%B0%D0%B4%D0%B0%D1%8E%D1%89%D0%B8%D1%85_%D0%BF%D1%81%D0%B8%D1%85%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B8%D0%BC%D0%B8_%D1%80%D0%B0%D1%81%D1%81%D1%82%D1%80%D0%BE%D0%B9%D1%81%D1%82%D0%B2%D0%B0%D0%BC%D0%B8"}}'::jsonb
WHERE card_key = '84|||סל שיקום למתמודדי נפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://levmalka.org.il/"},"en":{"web":"https://levmalka.org.il/en/home/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://levmalka.org.il/en/home/"}'::jsonb,
      true
    )
WHERE card_key = '84|||סיוע באמבולנסים בהעברת חולים ונכים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.kolzchut.org.il/he/%D7%9E%D7%93%D7%A8%D7%99%D7%9A_%D7%9E%D7%99%D7%A6%D7%95%D7%99_%D7%96%D7%9B%D7%95%D7%99%D7%95%D7%AA_%D7%9C%D7%9E%D7%AA%D7%9E%D7%95%D7%93%D7%93%D7%99_%D7%A0%D7%A4%D7%A9_%D7%95%D7%91%D7%A0%D7%99_%D7%9E%D7%A9%D7%A4%D7%97%D7%95%D7%AA%D7%99%D7%94%D7%9D"},"ar":{"web":"https://www.kolzchut.org.il/ar/%D8%AF%D9%84%D9%8A%D9%84_%D8%A7%D8%B3%D8%AA%D9%86%D9%81%D8%A7%D8%AF_%D8%A7%D9%84%D8%AD%D9%82%D9%88%D9%82_%D9%84%D9%84%D9%85%D8%B5%D8%A7%D8%A8%D9%8A%D9%86_%D9%86%D9%81%D8%B3%D9%8A%D8%A7_%D9%88%D8%A3%D8%A8%D9%86%D8%A7%D8%A1_%D8%B9%D8%A7%D8%A6%D9%84%D8%A7%D8%AA%D9%87%D9%85"},"ru":{"web":"https://www.kolzchut.org.il/ru/%D0%A0%D1%83%D0%BA%D0%BE%D0%B2%D0%BE%D0%B4%D1%81%D1%82%D0%B2%D0%BE_%D0%BF%D0%BE_%D1%80%D0%B5%D0%B0%D0%BB%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D0%B8_%D0%BF%D1%80%D0%B0%D0%B2_%D0%B4%D0%BB%D1%8F_%D0%BB%D1%8E%D0%B4%D0%B5%D0%B9_%D1%81_%D0%BF%D1%81%D0%B8%D1%85%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B8%D0%BC%D0%B8_%D0%B8_%D0%BA%D0%BE%D0%B3%D0%BD%D0%B8%D1%82%D0%B8%D0%B2%D0%BD%D1%8B%D0%BC%D0%B8_%D1%80%D0%B0%D1%81%D1%81%D1%82%D1%80%D0%BE%D0%B9%D1%81%D1%82%D0%B2%D0%B0%D0%BC%D0%B8_%D0%B8_%D0%B8%D1%85_%D1%81%D0%B5%D0%BC%D0%B5%D0%B9"}}'::jsonb
WHERE card_key = '85|||מדריך מיצוי זכויות למתמודדי נפש ובני משפחותיהם';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '86|||קבוצה בפייסבוק';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.fiteat.com"}}'::jsonb
WHERE card_key = '87|||מומחית בהפרעות אכילה/תזונה/כושר/דיאטה, מטפלת בפגועי נפש עם רישיון. בעלות סימלית, חברות ביטוח מחזירות';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://impulseclinics.com/"}}'::jsonb
WHERE card_key = '88|||מרכז לפסיכותרפיה אינטגרטיבית. תמיכה נפשית, רגשית ורוחנית דרך מגוון רחב של גישות ועל ידי אנשי מקצוע מוסמכים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://mexp.co.il/"}}'::jsonb
WHERE card_key = '90|||מרכזים לטיפול רגשי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hakshiva.org/therapy-clinic/#","add":"https://hakshiva.org/he/%d7%a7%d7%9c%d7%99%d7%a0%d7%99%d7%a7%d7%94-%d7%98%d7%99%d7%a4%d7%95%d7%9c%d7%99%d7%aa/"}}'::jsonb
WHERE card_key = '91|||Therapy for teenagers, couples therapy and parenting guidance';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hevleikesher.org/he/%D7%97%D7%91%D7%9C%D7%99-%D7%A7%D7%A9%D7%A8-%D7%93%D7%A3-%D7%94%D7%91%D7%99%D7%AA/","add":"https://www.jerusalem.muni.il/he/residents/earlychildhood/messeges/knot-ropes/"},"en":{"web2":"https://hevleikesher.org/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web2":"https://hevleikesher.org/"}'::jsonb,
      true
    )
WHERE card_key = '92|||דיכאון אחרי לידה ועוד, דרך טיפת חלב בירושלים
Support and treatment for Maternal Mental Health through Tipat Halav. Services for mothers and families impacted by perinatal mental health disorders (PMHD) such as postpartum depression';

UPDATE directory_card_edits
SET site_languages = '{"en":{"web":"https://www.modiinbehavioral.com/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.modiinbehavioral.com/"}'::jsonb,
      true
    )
WHERE card_key = '93|||CBT, DBT, and Exposure-Based Therapies';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://ica.org.il/"}}'::jsonb
WHERE card_key = '94|||מרכז לאומי מוביל לצמצום תופעת ההתמכרויות ונזקיה. טיפול, מידע והכוונה למי שמתמודד עם התמכרות';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hacheret.com/"}}'::jsonb
WHERE card_key = '95|||מרכז גמילה הוליסטי לטיפול בהתמכרויות (סמים, אלכוהול, הימורים ועוד) המבוסס על 12 הצעדים וגישות טיפוליות נוספות';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hst.org.il/"}}'::jsonb
WHERE card_key = '96|||הכוונה לטיפול הפסיכולוגי המתאים לכם וסבסוד טיפולים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://rescueanxietyapp.org/"}}'::jsonb
WHERE card_key = '101|||אפליקציה חינמית המספקת עזרה ראשונה נפשית ותמיכה מיידית בזמן התקף חרדה, ומלווה את המשתמש עד חזרה הדרגתית לשגרה.';

UPDATE directory_card_edits
SET site_languages = '{"en":{"web":"https://kavlnoar.org/jerusalem-clinic","add":"https://kavlnoar.org/beit-shemesh-clinic"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://kavlnoar.org/jerusalem-clinic","add":"https://kavlnoar.org/beit-shemesh-clinic"}'::jsonb,
      true
    )
WHERE card_key = '102|||Therapy clinic for teenagers & young adults (11-27) and parents; specializes in Anglo olim; Halachik framework; therapy for individuals, couples and families';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.vivid.me/"}}'::jsonb
WHERE card_key = '102|||אפליקציה אינטראקטיבית לבניית תוכניות תרגול יומי ומעקב לאורך זמן.';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/medical/mental-therapy/ptsd-app"}}'::jsonb
WHERE card_key = '103|||אפליקציה/מדריך דיגיטלי להתמודדות עם PTSD, מטעם אגף השיקום (משרד הביטחון).';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://mindme.co.il/"}}'::jsonb
WHERE card_key = '104|||מרכז פסיכיאטרי וטיפול רגשי: פסיכותרפיה, טיפול קוגניטיבי-התנהגותי (CBT), טיפול זוגי ומשפחתי, פסיכיאטריה ומתן תרופות, EMDR/DBT/NLP, חרדה, דיכאון, טראומה, התמכרויות ועוד';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://brainsway.co.il/treatments/","add":"https://brainsway.co.il/find-clinic/"}}'::jsonb
WHERE card_key = '105|||טיפולי גרייה מוחית (TMS ו-Deep TMS) למגוון מצבים נפשיים ונוירולוגיים. דיכאון מג''ורי בסל לפי תנאים; שיפוי אגף השיקום ל-PTSD בחלק מבתי החולים הציבוריים.';

UPDATE directory_card_edits
SET site_languages = '{"en":{"web":"https://acptisrael.com/en/access-center-for-psychedelic-treatment-and-therapy/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://acptisrael.com/en/access-center-for-psychedelic-treatment-and-therapy/"}'::jsonb,
      true
    )
WHERE card_key = '106|||Access center for psychedelic treatment and therapy.';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://psycircle.co.il/psychedelic-therapy/"}}'::jsonb
WHERE card_key = '107|||טיפול פסיכדלי ומידע מקצועי בתחום.';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.tasmc.org.il/unit-index-page/psychiatr/psychiatry-clinic/brain-magnetic-stimulation/"}}'::jsonb
WHERE card_key = '108|||טיפול בגרייה מגנטית מוחית (TMS) במרפאה לטיפולים מתקדמים. באותה יחידה גם ECT, אסקטמין ונוירופידבק.';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/BlobFolder/reports/ect-electroconvulsive-therapy/he/units_governmental_health_centers_ect-electroconvulsive-therapy-ac.pdf","add":"https://www.tasmc.org.il/unit-index-page/psychiatr/psychiatry-clinic/brain-magnetic-stimulation/"}}'::jsonb
WHERE card_key = '109|||טיפול ביולוגי תחת הרדמה קצרה במצבים נפשיים חמורים — בעיקר דיכאון קשה, קטטוניה ומצבים דחופים. ניתן בסדרה בבתי חולים פסיכיאטריים ובחטיבות פסיכיאטריות (למשל איכילוב, שלוותה, כפר שאול).';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://1202.org.il/","add":"https://1202kolmila.org.il/"},"en":{"web":"https://1202.org.il/en/"},"ar":{"web":"https://1202.org.il/ar/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://1202.org.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '200|||קווי המענה הארציים של ארגון הגג למרכזי הסיוע';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.tair-1202.org/","add":"https://www.tair-1202.org/support-groups"}}'::jsonb
WHERE card_key = '201|||סיוע וליווי, חינוך ומניעה, קבוצות תמיכה (פרונטלי וזום)';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://israeltraumacoalition.org/"},"en":{"web":"https://israeltraumacoalition.org/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://israeltraumacoalition.org/en/"}'::jsonb,
      true
    )
WHERE card_key = '202|||מידע, הכשרות, מוקדי חוסן ושותפות ארצית בטראומה וחוסן (Israel Trauma Coalition)';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.telem.org.il/"}}'::jsonb
WHERE card_key = '203|||רשת ארצית לטיפול פסיכולוגי, אבחון והכשרה — כולל טיפול בטראומה ובמצוקה נפשית.';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://adva-lieser.co.il"}}'::jsonb
WHERE card_key = '204|||נטורופתיה קלינית — איזון גוף–נפש (כאבים, עייפות, סטרס, עיכול, אכילה רגשית ועוד); קליניקה ומפגשים מקוונים.';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.resolution.co.il/"}}'::jsonb
WHERE card_key = '205|||יישומים פסיכולוגיים ממוקדים — הערכה ראשונית והתאמת טיפול (פגישות בקליניקה או זום).';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://neshima-ptsd.co.il/%d7%9e%d7%95%d7%93%d7%9c-%d7%a0%d7%a9%d7%99%d7%9e%d7%94/"}}'::jsonb
WHERE card_key = '206|||מודל נשימה — טיפול מסובסד, רשת מטפלים לטראומה מורכבת וגישת גוף–נפש קהילתית.';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mishpachot.org/"}}'::jsonb
WHERE card_key = '207|||עמותת בני ובנות משפחה של מתמודדי/ות נפש בישראל. מטרת העמותה היא לפעול למען המתמודדים ולמען משפחותיהם למימוש ולהרחבת זכויות, לטיפול מיטבי, להכלה ולשיקום בקהילה ולהסברה בקרב מקבלי החלטות, בקרב הממסד ובקרב הציבור.';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '208|||מנחה ומלווה משפחות למתמודדי נפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://metiv.org.il/"}}'::jsonb
WHERE card_key = '210|||טיפול ארצי ללא עלות לטווח ארוך בטראומה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.retorno.org.il/"}}'::jsonb
WHERE card_key = '211|||טיפול, ליווי ושיקום לפוסט-טראומה (בהכרה או לאחר אבחון) — חוות במושב שמש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.amok.org.il/"}}'::jsonb
WHERE card_key = '212|||טיפוליים מפגשים ללא עלות בצפון (פרונטלי או מקוון)';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.hakshev.com/"}}'::jsonb
WHERE card_key = '213|||עזרה ראשונה נפשית לנפגעי חרבות ברזל — עד 10 מפגשים';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '214|||סיוע נפשי לחיילים ומילואים';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '215|||סיוע נפשי ללא עלות לאנשי קבע ומשפחותיהם';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://people.socsci.tau.ac.il/mu/traumaresilience"}}'::jsonb
WHERE card_key = '217|||קליניקה לטיפול בפוסט-טראומה (מילואים/משוחררים — תשלום סמלי)';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/medical/treatment/therapy#3"}}'::jsonb
WHERE card_key = '218|||טיפולים נפשיים מסובסדים ע"י משרד הביטחון (חרבות ברזל)';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '219|||תוכנית טיפול לפוסט-טראומה — מושב משק פרזון (רישום מוקדם)';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.biu.ac.il/"}}'::jsonb
WHERE card_key = '220|||CBT זוגי במחקר — 15 מפגשים בזום';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '221|||טיפול ממוקד טראומה למשרתי/מילואימניקים משוחררים (מלחמה/אובדן)';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '222|||טיפול קצר לילדי מילואימניקים 3-12 ומשפחות';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '223|||סיוע מקצועי לנפגעים בצה"ל ולבני משפחותיהם';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://docs.google.com/spreadsheets/d/1ogTWzHK96WYWpxjwRFSI6ReZqnRE1wBRi0kAc_4RrWA/edit?usp=sharing"}}'::jsonb
WHERE card_key = '224|||רשת מטפלים מוסמכים לחיילים ומילואים — עד 10 מפגשים מסובסדים';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '225|||טיפול נפשי ללוחמי גזית/שריון (חטיבה 188) — ללא תשלום';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.shiba.org.il/"}}'::jsonb
WHERE card_key = '226|||עד 12 מפגשים טיפול רגשי ללא עלות';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '227|||שירותים חברתיים לצעירים 18-27';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://healingspace.co.il/"}}'::jsonb
WHERE card_key = '228|||טיפול, ליווי ושיקום — רשפון';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://forms.gle/3i4Zw5Wu3dHk2AqH8"}}'::jsonb
WHERE card_key = '229|||מוקד סיוע רגשי מרחוק (מגיל 12) — עברית, ערבית, רוסית, אנגלית';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.retorno.org.il/"}}'::jsonb
WHERE card_key = '230|||תמיכה רגשית לצעירים 17-27 בחוות שמש — ללא עלות';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '231|||ייעוץ והפניה — חברתי-ביטחוני';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://tinyurl.com/mv7zdka2"}}'::jsonb
WHERE card_key = '232|||מאגר תחנות לטיפול זוגי';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '233|||סיוע וטיפול לשורדי המסיבות בנובה — הרצליה';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '234|||טיפול עומק לפצועי נובה — לפחות 24 מפגשים';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '235|||טיפול ממוקד בטראומה לשורדי מסיבות — מרכז רפואי + מסיבות בדרום';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '236|||מידע, סיוע והכוונה — 24/7';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '237|||טיפול לבני זוג שאיבדו בן/בת במהלך שירות (מלחמה, תאונה, מחלה, התאבדות)';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/"}}'::jsonb
WHERE card_key = '238|||טיפול קבוצתי/זוגי/פרטני לשכולים ואחים/יתומים/אלמנות';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.elah.org.il/"},"en":{"web":"https://www.elah.org.il/en/home-page/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.elah.org.il/en/home-page/"}'::jsonb,
      true
    )
WHERE card_key = '239|||טיפול פרטני, זוגי, משפחתי וייעוץ פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/children_online_safety"}}'::jsonb
WHERE card_key = '240|||קישורים למטה להגנה, על"ם, מצמיחים, בית בטוח לנוער, נע"ן, עמותת ל.מ.ה, עמ"י ועוד';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '241|||טיפול משפחתי אינטנסיבי לילדים 6-18';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '242|||קו סיוע וקישורים — להט"ב, הורים, דתיים, נוער';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.telem.org.il/"}}'::jsonb
WHERE card_key = '243|||3 שיחות טיפוליות מקוונות ללא עלות';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://salshikum.org/"},"en":{"web":"https://salshikum.org/en/"},"ar":{"web":"https://salshikum.org/ar/"},"ru":{"web":"https://salshikum.org/ru/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://salshikum.org/en/"}'::jsonb,
      true
    )
WHERE card_key = '244|||מידע, זכויות ואיתור ספקי שירות בסל שיקום';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://refuavesimcha.co.il/free-ambulance/"}}'::jsonb
WHERE card_key = '245|||שירותי אמבולנס ללא תשלום להסעת חולים, נכים ומוגבלים לטיפולים, בדיקות ושמחות';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.ezra-lemarpe.org/ambulances/"}}'::jsonb
WHERE card_key = '246|||שירותי אמבולנס להסעת חולים, נכים ומוגבלים לטיפולים, בדיקות ואירועים משפחתיים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.ksharim-center.org/"}}'::jsonb
WHERE card_key = '247|||טיפול בהתמכרויות התנהגותיות (מין, פורנו, הימורים, אוכל, קשרים, מסכים) ותמיכה מערכתית לבני משפחה ובני זוג — טיפול, קבוצות ותוכנית 12 הצעדים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hitmakruyot.efshar.org.il/"}}'::jsonb
WHERE card_key = '248|||טיפול בנפגעי אלכוהול, הימורים והתמכרויות התנהגותיות נוספות — למכורים ולבני משפחותיהם; הסברה ומניעה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://retorno.org.il/"},"en":{"web2":"https://retorno.org/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web2":"https://retorno.org/"}'::jsonb,
      true
    )
WHERE card_key = '249|||אשפוזית, טיפול יום וקהילות טיפוליות לגמילה ושיקום; מותאם גם לאוכלוסייה דתית וחרדית; מפוקח ע״י משרדי הבריאות והרווחה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://acher.org.il/"}}'::jsonb
WHERE card_key = '250|||מרכז ברישיון משרד הבריאות לטיפול בהתמכרויות — בית מאזן לתחלואה כפולה, מרפאת יום, גמילה ותמיכה למשפחות; בשיתוף קופות החולים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.nar-anon.org.il/"}}'::jsonb
WHERE card_key = '251|||קבוצות עזרה עצמית אנונימיות (12 צעדים) למשפחות וחברים של מכורים לסמים';

UPDATE directory_card_edits
SET site_languages = '{"en":{"web":"https://al-anon-israel.org/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://al-anon-israel.org/en/"}'::jsonb,
      true
    )
WHERE card_key = '252|||קבוצות תמיכה אנונימיות (12 צעדים) למשפחות וחברים של אנשים הסובלים מאלכוהוליזם — פרונטלי וזום';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.aa-israel.co.il/","add":"https://www.aa-israel.org/he/"},"ru":{"web":"https://www.aa-israel.co.il/ru/"}}'::jsonb
WHERE card_key = '253|||קבוצות עזרה עצמית אנונימיות (12 צעדים) לאנשים הסובלים מבעיית שתייה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://malkishua.org.il/"}}'::jsonb
WHERE card_key = '254|||כפר ומרכז לטיפול בהתמכרויות — גמילה פיזית, קהילות טיפוליות לנוער/צעירים/בגירים/נשים; בפיקוח משרדי הרווחה והבריאות';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://mapalanefesh.org.il/"},"en":{"web":"https://mapalanefesh.org.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://mapalanefesh.org.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '255|||מפה ומאגר מענים טיפוליים ונפשיים בישראל לילדים, נוער ומבוגרים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.elem.org.il/","add":"https://yelem.org.il/"},"en":{"web":"https://elem.org.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://elem.org.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '256|||איתור, ליווי וטיפול בנוער וצעירים במצבי סיכון — בקהילה, ברחוב ובמרחב הדיגיטלי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://alsam.org.il/"}}'::jsonb
WHERE card_key = '257|||ייעוץ וטיפול לנוער וצעירים עד גיל 24 ולהוריהם בנושאי סמים, אלכוהול והתמכרויות';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.krembo.org.il/"},"en":{"web":"https://www.krembo.org.il/en/"},"ar":{"web":"https://www.krembo.org.il/ar/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.krembo.org.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '258|||תנועת נוער משלבת לילדים עם ובלי צרכים מיוחדים — שילוב חברתי מלא ושוויוני';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://igy.org.il/"},"en":{"web":"https://igy.org.il/en"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://igy.org.il/en"}'::jsonb,
      true
    )
WHERE card_key = '259|||תנועת נוער וצעירים להט"ב — קבוצות חברתיות ותמיכה בעשרות יישובים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.hoshen.org/"},"en":{"web":"https://www.hoshen.org/english"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.hoshen.org/english"}'::jsonb,
      true
    )
WHERE card_key = '260|||הסברה וסדנאות בבתי ספר ובמסגרות נוער למניעת להט"בופוביה ולתמיכה בנוער להט"ב';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://path-to-life.org/"},"en":{"web":"https://path-to-life.org/english/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://path-to-life.org/english/"}'::jsonb,
      true
    )
WHERE card_key = '261|||מניעת אובדנות ותמיכה במשפחות שכולות לאחר התאבדות או מוות פתאומי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.ozma.org.il/"}}'::jsonb
WHERE card_key = '262|||פורום ארצי של בני משפחה של מתמודדי נפש — תמיכה, מיצוי זכויות, סנגור והפחתת סטיגמה';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '263|||פורום משפחות המתמודדות עם הפרעות אכילה — קבוצות תמיכה, מידע על זכויות וסנגור';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.iaed.org.il/"},"en":{"web":"https://www.iaed.org.il/english/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.iaed.org.il/english/"}'::jsonb,
      true
    )
WHERE card_key = '264|||מידע לציבור ולמשפחות, מפת מסגרות טיפול ואינדקס מטפלים בהפרעות אכילה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://alut.org.il/"}}'::jsonb
WHERE card_key = '265|||ליווי ילדים ובוגרים על הרצף האוטיסטי ומשפחותיהם — זכויות, מרכזי משפחה ותמיכה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meitav.net/"}}'::jsonb
WHERE card_key = '266|||מרכז רב-תחומי לייעוץ, טיפול וחינוך בקהילה — ילדים, מתבגרים ומבוגרים; כולל יחידת קשב';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/units/105_unit"}}'::jsonb
WHERE card_key = '267|||דיווח ומענה 24/7 על פגיעות, בריונות, סחיטה ופשיעה נגד ילדים ונוער במרחב המקוון';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://israel.stellacenter.com/"}}'::jsonb
WHERE card_key = '268|||הליך רפואי קצר (Stellate Ganglion Block): שתי זריקות הרדמה מקומית בצידי הצוואר תחת אולטרסאונד, להקלה על תסמינים פיזיים של פוסט־טראומה, חרדה ודיכאון. מיועד לשילוב עם טיפול רגשי.';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://prism-il.com/"}}'::jsonb
WHERE card_key = '269|||טיפול EEG לא פולשני (GrayMatters Health) לאימון ויסות פעילות מוחית הקשורה לפוסט־טראומה, ללא חשיפה לטראומה. מאושר FDA ו־אמ"ר; מוכר לאגף השיקום למטופלים זכאים. רשימת מרכזים באתר (שיבא, איכילוב, ברזילי, מעלה הכרמל, בתי הלוחם ועוד).';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.tasmc.org.il/unit-index-page/psychiatr/psychiatry-clinic/brain-magnetic-stimulation/","add":"https://www.maccabi4u.co.il/eligibilites/12022/"},"ar":{"add":"https://www.maccabi4u.co.il/ar/main-arabic/arabic/"}}'::jsonb
WHERE card_key = '270|||תרסיס אף של אסקטמין לדיכאון מג''ורי עמיד. בסל הבריאות (מ-2020) למבוגרים שלא הגיבו לשני קווי טיפול משתי קבוצות פרמקולוגיות, בשילוב SSRI/SNRI. ניתן רק במרפאה מורשית תחת השגחה.';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://ketamindclinic.com/"}}'::jsonb
WHERE card_key = '271|||מרפאה פסיכיאטרית מקבוצת Stella Israel: עירוי קטמין במינון נמוך בהשגחה רפואית לדיכאון, חרדה ופוסט־טראומה.';

UPDATE directory_card_edits
SET site_languages = '{"en":{"web":"https://www.keterhealth.com/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.keterhealth.com/"}'::jsonb,
      true
    )
WHERE card_key = '272|||Ketamine-assisted psychotherapy in Jerusalem: psychiatrist and KAP therapist (mainly IM ketamine with preparation and integration) for treatment-resistant depression, PTSD and anxiety.';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://herzoghospital.org.il/clinicsinstitutes/%D7%9E%D7%A8%D7%A4%D7%90%D7%94-%D7%9C%D7%92%D7%A8%D7%99%D7%99%D7%94-%D7%9E%D7%95%D7%97%D7%99%D7%AA/"}}'::jsonb
WHERE card_key = '273|||גרייה מוחית בזרם ישר חלש (tDCS) במרפאה לגרייה מוחית בהרצוג. לא פולשני; למצבים פסיכיאטריים ונוירולוגיים לפי הערכה רפואית. באותה מרפאה גם Deep TMS לדיכאון מג''ורי (טופס 17).';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.lev-hasharon.co.il/?clinic=%D7%9E%D7%A8%D7%A4%D7%90%D7%94"}}'::jsonb
WHERE card_key = '274|||השתלת קוצב המגרה את עצב הואגוס לדיכאון קשה עמיד לטיפול. בישראל: הערכה ביחידה לגרייה מוחית בלב השרון; ההשתלה בנוירוכירורגיה תפקודית באיכילוב. מוגבל, דורש הפניה פסיכיאטרית.';

UPDATE directory_card_edits
SET site_languages = '{"en":{"web":"https://www.rambam.org.il/en/rambam_news/dbs_for_tx-resistant_ocd.aspx"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.rambam.org.il/en/rambam_news/dbs_for_tx-resistant_ocd.aspx"}'::jsonb,
      true
    )
WHERE card_key = '275|||הליך נוירוכירורגי להשתלת אלקטרודות וקוצב מוחי במקרי OCD חמורים ועמידים לטיפול. ניתן במספר מרכזים בודדים (למשל רמב"ם). אינו בסל הבריאות; רק באישור מיוחד של משרד הבריאות או במחקר.';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://mnefesh.org/he/"},"en":{"web":"https://mnefesh.org/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://mnefesh.org/","webLabel":"Website"}'::jsonb,
      true
    )
WHERE card_key = '276|||ייעוץ הלכתי ורוחני למתמודדים ולבני משפחה — רבנים ורבניות שעברו הכשרה בבריאות הנפש (לא טיפול קליני)';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '277|||קבוצה בפייסבוק';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.aguda.co.il/service-categories/%d7%a9%d7%99%d7%a7%d7%95%d7%9d-%d7%95%d7%97%d7%95%d7%a0%d7%9b%d7%95%d7%aa/"},"en":{"web":"https://www.aguda.co.il/en/service-categories/rehabilitation-and-mentoring/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.aguda.co.il/en/service-categories/rehabilitation-and-mentoring/"}'::jsonb,
      true
    )
WHERE card_key = '278|||שירותי סל שיקום';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.aguda.co.il/services/%d7%91%d7%99%d7%aa-%d7%a8%d7%a2%d7%99%d7%9d-%d7%a0%d7%aa%d7%a0%d7%99%d7%94/"}}'::jsonb
WHERE card_key = '279|||טיפול יום פסיכיאטרי — חלופת אשפוז למבוגרים במצבי משבר';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.aguda.co.il/services/%d7%9e%d7%a8%d7%a4%d7%90%d7%aa-%d7%90%d7%95%d7%a4%d7%a7%d7%99%d7%9d/"}}'::jsonb
WHERE card_key = '280|||טיפול נפשי מרפאתי — הערכה פסיכיאטרית, טיפול תרופתי ופסיכותרפיה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.aguda.co.il/service-categories/%d7%a9%d7%99%d7%a7%d7%95%d7%9d-%d7%9c%d7%a0%d7%9b%d7%99-%d7%a6%d7%94%d7%9c-%d7%95%d7%a0%d7%a4%d7%92%d7%a2%d7%99-%d7%a4%d7%a2%d7%95%d7%9c%d7%95%d7%aa-%d7%90%d7%99%d7%91%d7%94/"}}'::jsonb
WHERE card_key = '281|||שיקום לנכי צה"ל ונפגעי פעולות איבה — מרכז החממה ותכנית תושייה למשפחות הלומי קרב';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.aguda.co.il/services/%d7%9e%d7%a8%d7%9b%d7%96-%d7%a6%d7%b3%d7%95%d7%99%d7%a1-choice/"}}'::jsonb
WHERE card_key = '282|||מרכז יום לנוער וצעירים (12–35) על רצף הטראומה וההתמכרות — אבחון, טיפול פרטני וקבוצתי וליווי שיקומי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.yozma4u.co.il/"}}'::jsonb
WHERE card_key = '283|||שיקום תעסוקתי, תעסוקה נתמכת ויזמות — כולל תוכנית צרכנים נותני שירות';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://meshulash.org/"}}'::jsonb
WHERE card_key = '284|||בית חם, מרחב פתוח והלנת חירום לנוער וצעירים בסיכון — כולל שלטר לצעירות חרדיות';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shanti.org.il/"},"en":{"web":"https://shanti.org.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://shanti.org.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '285|||בית חם ומקלט חירום לנוער בסיכון ובסכנת חיים (14–21)';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.yachdav.org.il/"}}'::jsonb
WHERE card_key = '286|||קורת גג 24/7 לנוער 12–18 ללא קבלה בירוקרטית — עד 3 חודשים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.enosh.org.il/%D7%94%D7%9C%D7%A0%D7%AA-%D7%97%D7%99%D7%A8%D7%95%D7%9D/"}}'::jsonb
WHERE card_key = '287|||קורת גג 24/7 לצעירים 18–25 ללא עורף משפחתי — עד 6 חודשים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/dynamiccollectors/molsa-yated-social-workers"}}'::jsonb
WHERE card_key = '288|||עובד/ת סוציאלי/ת בתוכנית יתד — ליווי צעירים וצעירות (18–25/26) במצבי חיים מורכבים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://wtc-anatgur.co.il/%D7%90%D7%95%D7%93%D7%95%D7%AA/%D7%91%D7%99%D7%AA-%D7%9E%D7%A9%D7%9C%D7%9A/"}}'::jsonb
WHERE card_key = '289|||רשת הוסטלים לנערות וצעירות במצבי סיכון — ראשון לציון; גישה מודעת טראומה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://wtc-anatgur.co.il/"}}'::jsonb
WHERE card_key = '290|||קליניקה לטיפול בנשים ובנערות — פסיכותרפיה, פגיעות מיניות, הפרעות אכילה, דיכאון אחרי לידה ואלימות ביחסים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.navigateisrael.com/"}}'::jsonb
WHERE card_key = '291|||תוכנית טיפול קהילתית מוקדמת לצעירים אחרי אפיזודה פסיכוטית ראשונה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/units/my-way-beerness","web2":"https://www.gov.il/he/departments/mental-health-center-beer-yaacov-ness-ziona"}}'::jsonb
WHERE card_key = '292|||מחלקה פתוחה לאשפוז בטראומה מורכבת — כולל נפגעי 7 באוקטובר ובני משפחותיהם';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/units/department-by-your-side","web2":"https://www.iaed.org.il/treatment_center/1004/"}}'::jsonb
WHERE card_key = '293|||מחלקה פתוחה לנשים עם פוסט־טראומה מורכבת והפרעות אכילה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://mazormed.org.il/%D7%91%D7%A8%D7%99%D7%90%D7%95%D7%AA-%D7%94%D7%A0%D7%A4%D7%A9/","web2":"https://mazormed.org.il/%D7%A4%D7%A0%D7%99%D7%94-%D7%90%D7%95%D7%A0%D7%9C%D7%99%D7%99%D7%9F/"},"en":{"web":"https://mazormed.org.il/en/mental-health/","web2":"https://mazormed.org.il/en/online-inquiry/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://mazormed.org.il/en/mental-health/","web2":"https://mazormed.org.il/en/online-inquiry/"}'::jsonb,
      true
    )
WHERE card_key = '294|||הכוונה וליווי למציאת מענה בפסיכיאטריה ובריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://eza.org.il/activities-domain/transportation/","web2":"https://eza.org.il/our-activities/%D7%94%D7%A1%D7%A2%D7%95%D7%AA-%D7%97%D7%95%D7%9C%D7%99%D7%9D/"},"en":{"web":"https://eza.org.il/en/activities-domain/transportation-en/","web2":"https://eza.org.il/en/our-activities/transportation-services/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://eza.org.il/en/activities-domain/transportation-en/","web2":"https://eza.org.il/en/our-activities/transportation-services/"}'::jsonb,
      true
    )
WHERE card_key = '295|||הסעות מסובסדות לבתי חולים מבית שמש לירושלים, אמבולנסים ורכבים מונגשים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gvanim.org.il/"}}'::jsonb
WHERE card_key = '296|||תעסוקה נתמכת, מועדון חברתי באשקלון, מכינת הד, דיור מוגן לבודדים / ליווי, וסייעים בחינוך';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://psjer.org.il/clinics/%D7%94%D7%9E%D7%97%D7%9C%D7%A7%D7%94-%D7%9C%D7%98%D7%99%D7%A4%D7%95%D7%9C-%D7%99%D7%95%D7%9D-%D7%90%D7%99%D7%A0%D7%98%D7%A0%D7%A1%D7%99%D7%91%D7%99/"}}'::jsonb
WHERE card_key = '297|||טיפול יום אינטנסיבי למבוגרים — מניעת אשפוז מלא';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il/he/your_health/family/mental_health/Pages/day_hospitalization.aspx","web2":"https://www.clalit.co.il/he/sefersherut/pages/clinicdetails.aspx?ddeptcode=15530","add":"https://www.clalit.co.il/he/sefersherut/pages/clinicdetails.aspx?ddeptcode=15533"}}'::jsonb
WHERE card_key = '298|||אשפוז יום פסיכיאטרי למבוטחי כללית';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.tasmc.org.il/unit-index-page/psychiatr/psychiatry-daytreatment/"}}'::jsonb
WHERE card_key = '299|||טיפול יום למצבים נוירופסיכיאטריים וסומטיים — לא מסגרת כללית למשבר';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mymc.co.il/main-departments/psychiatric-day-care/"},"en":{"web":"https://www.mymc.co.il/en/main-departments/psychiatric-day-care-unit/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.mymc.co.il/en/main-departments/psychiatric-day-care-unit/"}'::jsonb,
      true
    )
WHERE card_key = '300|||טיפול יום פסיכיאטרי בהפרדה מגדרית — לציבור הדתי והחרדי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.rambam.org.il/departmentsandclinics/mental-health-division/day-care-unit/"}}'::jsonb
WHERE card_key = '301|||טיפול יום פסיכיאטרי בשני שלבים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hymc.org.il/?CategoryID=234"}}'::jsonb
WHERE card_key = '302|||טיפול יום פסיכיאטרי, חמישה ימים בשבוע';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.kolsherut.org.il/p/card/c/1b891eb0"}}'::jsonb
WHERE card_key = '303|||טיפול יום פסיכיאטרי למבוטחי כללית';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://me.health.gov.il/mental-health/therapy-rehabilitation/public-care/community-treatment/psychiatric-day-care/","web2":"https://www.kolzchut.org.il/he/%D7%9E%D7%A1%D7%92%D7%A8%D7%AA_%D7%98%D7%99%D7%A4%D7%95%D7%9C_%D7%99%D7%95%D7%9D_%D7%9C%D7%9E%D7%AA%D7%9E%D7%95%D7%93%D7%93%D7%99_%D7%A0%D7%A4%D7%A9","add":"https://www.milam.org.il/%D7%9E%D7%97%D7%9C%D7%A7%D7%95%D7%AA-%D7%98%D7%99%D7%A4%D7%95%D7%9C-%D7%99%D7%95%D7%9D/"},"en":{"web":"https://me.health.gov.il/en/mental-health/therapy-rehabilitation/public-care/community-treatment/psychiatric-day-care/"},"ru":{"web":"https://me.health.gov.il/ru/mental-health/therapy-rehabilitation/public-care/community-treatment/psychiatric-day-care/","web2":"https://www.kolzchut.org.il/ru/%D0%94%D0%BD%D0%B5%D0%B2%D0%BD%D0%BE%D0%B9_%D1%81%D1%82%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%B0%D1%80_%D0%B4%D0%BB%D1%8F_%D1%81%D1%82%D1%80%D0%B0%D0%B4%D0%B0%D1%8E%D1%89%D0%B8%D1%85_%D0%BF%D1%81%D0%B8%D1%85%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B8%D0%BC%D0%B8_%D1%80%D0%B0%D1%81%D1%81%D1%82%D1%80%D0%BE%D0%B9%D1%81%D1%82%D0%B2%D0%B0%D0%BC%D0%B8"},"ar":{"web2":"https://www.kolzchut.org.il/ar/%D8%A5%D8%B7%D8%A7%D8%B1_%D8%B9%D9%84%D8%A7%D8%AC_%D9%8A%D9%88%D9%85%D9%8A_%D9%84%D9%84%D9%85%D8%B1%D8%B6%D9%89_%D8%A7%D9%84%D9%86%D9%81%D8%B3%D9%8A%D9%8A%D9%86"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://me.health.gov.il/en/mental-health/therapy-rehabilitation/public-care/community-treatment/psychiatric-day-care/"}'::jsonb,
      true
    )
WHERE card_key = '304|||הסבר על השירות, וטבלאות מרכזים שאין להם כרטיס נפרד';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.ami.org.il/communities/mental-health","web2":"https://www.ami.org.il/services/rehabilitation-employment","add":"https://www.ami.org.il/services/free-market-labor"}}'::jsonb
WHERE card_key = '305|||שיקום תעסוקתי, תעסוקה נתמכת, פנאי ומרכזי משפחות למתמודדי נפש מגיל 18';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://slavpro.co.il/"}}'::jsonb
WHERE card_key = '306|||סל שיקום, דיור, תעסוקה וסיוע להורים מתמודדים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.soulbird.co.il/","web2":"https://www.soulbird.co.il/about-page/"}}'::jsonb
WHERE card_key = '307|||ליווי ממוקד הורות להורים המתמודדים עם קשיים נפשיים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/dynamiccollectors/smtl-families-center","web2":"https://me.health.gov.il/mental-health/therapy-rehabilitation/rehabilitation/rehabilitation-basket/family-counseling-centers/"},"en":{"web2":"https://me.health.gov.il/en/mental-health/therapy-rehabilitation/rehabilitation/rehabilitation-basket/family-counseling-centers/"},"ru":{"web2":"https://me.health.gov.il/ru/mental-health/therapy-rehabilitation/rehabilitation/rehabilitation-basket/family-counseling-centers/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web2":"https://me.health.gov.il/en/mental-health/therapy-rehabilitation/rehabilitation/rehabilitation-basket/family-counseling-centers/"}'::jsonb,
      true
    )
WHERE card_key = '308|||רשימת מרכזי הייעוץ למשפחות בקהילה ובבתי החולים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://psjer.org.il/clinics/%d7%90%d7%a9%d7%a4%d7%95%d7%96-%d7%99%d7%95%d7%9d/"}}'::jsonb
WHERE card_key = '309|||אשפוז יום אחרי אשפוז מלא — הדרך שלך חזרה לקהילה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://psjer.org.il/clinics/%d7%9c%d7%95%d7%98%d7%95%d7%a1/"}}'::jsonb
WHERE card_key = '310|||טיפול יום לנשים עם טראומה מורכבת אחרי פגיעה מינית';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/kaplan/he/med_units/psychiatric_care/Pages/psychiatric_day_care.aspx","web2":"https://www.mh-israel.co.il/Article/43/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_מרכז"}}'::jsonb
WHERE card_key = '311|||מחלקת טיפול יום, כחודש וחצי בממוצע';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/geha/he/med/mature/Pages/hdept.aspx","web2":"https://www.mh-israel.co.il/Article/43/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_מרכז"}}'::jsonb
WHERE card_key = '312|||טיפול יום למבוגרים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.tasmc.org.il/media/ggzdwfvx/hascama_div.pdf"}}'::jsonb
WHERE card_key = '313|||מחלקה לטיפול יום פסיכיאטרי לילדים ולנוער';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mh-israel.co.il/Article/49/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_ירושלים"}}'::jsonb
WHERE card_key = '314|||טיפול יום לקטינים באתיופיה, ואשפוז יום בעין כרם';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mh-israel.co.il/Article/40/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_דרום"}}'::jsonb
WHERE card_key = '315|||טיפול יום ואשפוז יום למבוגרים, וטיפול יום לקטינים בבית ספר שקד';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://ziv.org.il","web2":"https://www.mh-israel.co.il/Article/41/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_צפון"}}'::jsonb
WHERE card_key = '316|||טיפול יום ואשפוז יום';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://mazra.org.il","web2":"https://www.mh-israel.co.il/Article/41/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_צפון"}}'::jsonb
WHERE card_key = '317|||טיפול יום למבוגרים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mh-israel.co.il/Article/41/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_צפון"}}'::jsonb
WHERE card_key = '318|||טיפול יום ואשפוז יום למבוגרים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://nazhosp.com","web2":"https://www.mh-israel.co.il/Article/41/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_צפון"},"en":{"web":"https://nazhosp.com/?lang=en"},"ar":{"web":"https://nazhosp.com/"},"ru":{"web":"https://nazhosp.com/?lang=ru"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://nazhosp.com/?lang=en"}'::jsonb,
      true
    )
WHERE card_key = '319|||אשפוז יום למבוגרים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mh-israel.co.il/Article/41/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_צפון"}}'::jsonb
WHERE card_key = '320|||אשפוז יום לקטינים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mh-israel.co.il/Article/40/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_דרום"}}'::jsonb
WHERE card_key = '321|||טיפול יום למבוגרים במרכז לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mh-israel.co.il/Article/40/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_דרום"}}'::jsonb
WHERE card_key = '322|||טיפול יום למבוגרים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.beer-ness.co.il","web2":"https://www.mh-israel.co.il/Article/43/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_מרכז"}}'::jsonb
WHERE card_key = '323|||טיפול יום למבוגרים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mh-israel.co.il/Article/43/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_מרכז"}}'::jsonb
WHERE card_key = '324|||טיפול יום למבוגרים ואשפוז יום';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.schneider.org.il","web2":"https://www.mh-israel.co.il/Article/43/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_מרכז"},"en":{"web":"https://www.schneider.org.il/eng"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.schneider.org.il/eng"}'::jsonb,
      true
    )
WHERE card_key = '325|||אשפוז יום לקטינים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mh-israel.co.il/Article/48/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_תל_אביב"}}'::jsonb
WHERE card_key = '326|||טיפול יום למבוגרים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mh-israel.co.il/Article/48/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_תל_אביב"}}'::jsonb
WHERE card_key = '327|||טיפול יום למבוגרים של כללית';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://rehabilitation.sheba.co.il/Psychiatric_Division/","web2":"https://www.mh-israel.co.il/Article/48/מרכזים_לטיפול_יום_פסיכיאטרי_-_במחוז_תל_אביב"}}'::jsonb
WHERE card_key = '328|||אשפוז יום במחלקת ילדים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il/eligibilites/64533/"},"ar":{"web":"https://www.maccabi4u.co.il/ar/main-arabic/arabic/"}}'::jsonb
WHERE card_key = '329|||טיפול יום לנוער, בשיבולים ובצור הדסה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il/eligibilites/64533/"},"ar":{"web":"https://www.maccabi4u.co.il/ar/main-arabic/arabic/"}}'::jsonb
WHERE card_key = '330|||טיפול יום באבן יהודה וביבנה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il/eligibilites/64533/"},"ar":{"web":"https://www.maccabi4u.co.il/ar/main-arabic/arabic/"}}'::jsonb
WHERE card_key = '331|||טיפול יום לנשים אחרי בית מאזן להפרעות אכילה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il/eligibilites/64533/"},"ar":{"web":"https://www.maccabi4u.co.il/ar/main-arabic/arabic/"}}'::jsonb
WHERE card_key = '332|||טיפול יום למבוגרים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il/eligibilites/64533/"},"ar":{"web":"https://www.maccabi4u.co.il/ar/main-arabic/arabic/"}}'::jsonb
WHERE card_key = '333|||טיפול יום למבוגרים עם הפרעות אכילה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il/eligibilites/64533/"},"ar":{"web":"https://www.maccabi4u.co.il/ar/main-arabic/arabic/"}}'::jsonb
WHERE card_key = '334|||טיפול יום למבוגרים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il/eligibilites/64533/"},"ar":{"web":"https://www.maccabi4u.co.il/ar/main-arabic/arabic/"}}'::jsonb
WHERE card_key = '335|||טיפול יום למבוגרים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il/eligibilites/64533/"},"ar":{"web":"https://www.maccabi4u.co.il/ar/main-arabic/arabic/"}}'::jsonb
WHERE card_key = '336|||טיפול יום למבוגרים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il/eligibilites/64533/"},"ar":{"web":"https://www.maccabi4u.co.il/ar/main-arabic/arabic/"}}'::jsonb
WHERE card_key = '337|||טיפול יום לילדים ולנוער';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.shaar-menashe.org/?ArticleID=157&CategoryID=178","web2":"https://www.shaar-menashe.org/?CategoryID=156"}}'::jsonb
WHERE card_key = '338|||מרפאת חוץ לבריאות הנפש, ליד שער בית החולים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.shaar-menashe.org/?ArticleID=237&CategoryID=156"}}'::jsonb
WHERE card_key = '339|||מחלקת אשפוז יום לטיפול אינטנסיבי או אחרי אשפוז מלא';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.shaar-menashe.org/?ArticleID=267&CategoryID=156","web2":"https://www.kolzchut.org.il/he/מרכזי_יום_ומרפאות_לטיפול_נפש_בנפגעות_תקיפה_מינית","add":"https://www.kolzchut.org.il/he/אשפוז_פסיכיאטרי_לנפגעות_תקיפה_מינית"},"ar":{"web2":"https://www.kolzchut.org.il/ar/%D8%A7%D9%84%D9%85%D8%B1%D8%A7%D9%83%D8%B2_%D8%A7%D9%84%D9%86%D9%87%D8%A7%D8%B1%D9%8A%D8%A9_%D9%88%D8%A7%D9%84%D8%B9%D9%8A%D8%A7%D8%AF%D8%A7%D8%AA_%D8%A7%D9%84%D9%86%D9%81%D8%B3%D9%8A%D8%A9_%D9%84%D8%B9%D9%84%D8%A7%D8%AC_%D8%B6%D8%AD%D8%A7%D9%8A%D8%A7_%D8%A7%D9%84%D8%A7%D8%B9%D8%AA%D8%AF%D8%A7%D8%A1%D8%A7%D8%AA_%D8%A7%D9%84%D8%AC%D9%86%D8%B3%D9%8A%D8%A9","add":"https://www.kolzchut.org.il/ar/%D9%85%D9%83%D9%88%D8%AB_%D9%84%D9%84%D8%B9%D9%84%D8%A7%D8%AC_%D8%A7%D9%84%D9%86%D9%81%D8%B3%D9%8A_%D9%84%D9%85%D8%AA%D8%B6%D8%B1%D8%B1%D8%A7%D8%AA_%D8%A7%D9%84%D8%A7%D8%B9%D8%AA%D8%AF%D8%A7%D8%A1_%D8%A7%D9%84%D8%AC%D9%86%D8%B3%D9%8A"},"ru":{"web2":"https://www.kolzchut.org.il/ru/%D0%94%D0%BD%D0%B5%D0%B2%D0%BD%D1%8B%D0%B5_%D1%86%D0%B5%D0%BD%D1%82%D1%80%D1%8B_%D0%B8_%D0%BA%D0%BB%D0%B8%D0%BD%D0%B8%D0%BA%D0%B8_%D0%BF%D1%81%D0%B8%D1%85%D0%BE%D0%BB%D0%BE%D0%B3%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%BE%D0%B9_%D0%BF%D0%BE%D0%BC%D0%BE%D1%89%D0%B8_%D0%BF%D0%BE%D1%81%D1%82%D1%80%D0%B0%D0%B4%D0%B0%D0%B2%D1%88%D0%B8%D0%BC_%D0%BE%D1%82_%D1%81%D0%B5%D0%BA%D1%81%D1%83%D0%B0%D0%BB%D1%8C%D0%BD%D0%BE%D0%B3%D0%BE_%D0%BD%D0%B0%D1%81%D0%B8%D0%BB%D0%B8%D1%8F"}}'::jsonb
WHERE card_key = '340|||אשפוז ממוקד, מרפאה וטיפול יום לנפגעי ולנפגעות טראומה מינית';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.lev-hasharon.co.il/?ward=%D7%9E%D7%A2%D7%A8%D7%9A-%D7%9C%D7%98%D7%99%D7%A4%D7%95%D7%9C-%D7%91%D7%98%D7%A8%D7%90%D7%95%D7%9E%D7%94-%D7%9E%D7%99%D7%A0%D7%99%D7%AA","web2":"https://www.lev-hasharon.co.il/?clinic=%D7%90%D7%A9%D7%A4%D7%95%D7%96-%D7%9E%D7%9E%D7%95%D7%A7%D7%93-%D7%9C%D7%A0%D7%A4%D7%92%D7%A2%D7%95%D7%AA-%D7%98%D7%A8%D7%90%D7%95%D7%9E%D7%94-%D7%9E%D7%99%D7%A0%D7%99%D7%AA","add":"https://www.kolzchut.org.il/he/מרכזי_יום_ומרפאות_לטיפול_נפש_בנפגעות_תקיפה_מינית"},"ar":{"add":"https://www.kolzchut.org.il/ar/%D8%A7%D9%84%D9%85%D8%B1%D8%A7%D9%83%D8%B2_%D8%A7%D9%84%D9%86%D9%87%D8%A7%D8%B1%D9%8A%D8%A9_%D9%88%D8%A7%D9%84%D8%B9%D9%8A%D8%A7%D8%AF%D8%A7%D8%AA_%D8%A7%D9%84%D9%86%D9%81%D8%B3%D9%8A%D8%A9_%D9%84%D8%B9%D9%84%D8%A7%D8%AC_%D8%B6%D8%AD%D8%A7%D9%8A%D8%A7_%D8%A7%D9%84%D8%A7%D8%B9%D8%AA%D8%AF%D8%A7%D8%A1%D8%A7%D8%AA_%D8%A7%D9%84%D8%AC%D9%86%D8%B3%D9%8A%D8%A9"},"ru":{"add":"https://www.kolzchut.org.il/ru/%D0%94%D0%BD%D0%B5%D0%B2%D0%BD%D1%8B%D0%B5_%D1%86%D0%B5%D0%BD%D1%82%D1%80%D1%8B_%D0%B8_%D0%BA%D0%BB%D0%B8%D0%BD%D0%B8%D0%BA%D0%B8_%D0%BF%D1%81%D0%B8%D1%85%D0%BE%D0%BB%D0%BE%D0%B3%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%BE%D0%B9_%D0%BF%D0%BE%D0%BC%D0%BE%D1%89%D0%B8_%D0%BF%D0%BE%D1%81%D1%82%D1%80%D0%B0%D0%B4%D0%B0%D0%B2%D1%88%D0%B8%D0%BC_%D0%BE%D1%82_%D1%81%D0%B5%D0%BA%D1%81%D1%83%D0%B0%D0%BB%D1%8C%D0%BD%D0%BE%D0%B3%D0%BE_%D0%BD%D0%B0%D1%81%D0%B8%D0%BB%D0%B8%D1%8F"}}'::jsonb
WHERE card_key = '341|||אשפוז ממוקד ל-16 יום, וטיפול יום במרכז עוגן';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.tasmc.org.il/health/psychiatry/magen/","add":"https://www.kolzchut.org.il/he/אשפוז_פסיכיאטרי_לנפגעות_תקיפה_מינית"},"ar":{"add":"https://www.kolzchut.org.il/ar/%D9%85%D9%83%D9%88%D8%AB_%D9%84%D9%84%D8%B9%D9%84%D8%A7%D8%AC_%D8%A7%D9%84%D9%86%D9%81%D8%B3%D9%8A_%D9%84%D9%85%D8%AA%D8%B6%D8%B1%D8%B1%D8%A7%D8%AA_%D8%A7%D9%84%D8%A7%D8%B9%D8%AA%D8%AF%D8%A7%D8%A1_%D8%A7%D9%84%D8%AC%D9%86%D8%B3%D9%8A"}}'::jsonb
WHERE card_key = '342|||יחידת אשפוז לנשים אחרי פגיעה מינית';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hst.org.il/"}}'::jsonb
WHERE card_key = '343|||הכוונה לטיפול הפסיכולוגי המתאים וסבסוד טיפולים פסיכולוגיים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hst.org.il/"}}'::jsonb
WHERE card_key = '344|||הכוונה לטיפול הפסיכולוגי המתאים לכם, סבסוד טיפולים, חוסן משפחתי. שינוי מפת ההתמודדות המשפחתית והקהילתית במצבי מצוקה אישיים ומשפחתיים.';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://gonicenter.co.il/"}}'::jsonb
WHERE card_key = '345|||מרכז טיפול ואבחון רב-תחומי לפרט ולמשפחה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.drtal.co.il/"}}'::jsonb
WHERE card_key = '346|||מרכז לתמיכה רגשית ונפשית';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://leshanot.co.il/"}}'::jsonb
WHERE card_key = '347|||מכון לאבחון ולייעוץ, מגיל הרך עד מבוגרים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://keshet-refua.co.il/"}}'::jsonb
WHERE card_key = '348|||מרכז מומחים רב-תחומי, כולל מרכז נווה להפרעות אכילה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.reuth-mc.org.il/en/clinics/the-institute-for-treatment-of-eating-disorders/"},"ar":{"web":"https://www.reuth-mc.org.il/ar/clinics/%d9%85%d8%b1%d9%83%d8%b2-%d8%b9%d9%84%d8%a7%d8%ac-%d8%a7%d8%b6%d8%b7%d8%b1%d8%a7%d8%a8%d8%a7%d8%aa-%d8%a7%d9%84%d8%a7%d9%83%d9%84/"},"ru":{"web":"https://www.reuth-mc.org.il/ru/clinics/%d0%b8%d0%bd%d1%81%d1%82%d0%b8%d1%82%d1%83%d1%82-%d0%bb%d0%b5%d1%87%d0%b5%d0%bd%d0%b8%d1%8f-%d0%bd%d0%b0%d1%80%d1%83%d1%88%d0%b5%d0%bd%d0%b8%d0%b9-%d0%bf%d0%b8%d1%89%d0%b5%d0%b2%d0%be%d0%b3%d0%be/"}}'::jsonb
WHERE card_key = '349|||טיפול בהפרעות אכילה — טיפול יום למבוגרים וטיפול אמבולטורי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://fym-clinic.co.il/"}}'::jsonb
WHERE card_key = '350|||מרפאה רב-תחומית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.alef-tav.co/"}}'::jsonb
WHERE card_key = '351|||מרכז פסיכולוגי-חינוכי לילדים ולנוער';

UPDATE directory_card_edits
SET site_languages = '{"en":{"web":"https://machondvir.org/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://machondvir.org/"}'::jsonb,
      true
    )
WHERE card_key = '352|||מכון לבריאות התנהגותית, עם צוות דובר אנגלית';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hofhagalil.co.il/"}}'::jsonb
WHERE card_key = '353|||מרכז לטיפול בילד, במבוגר ובמשפחה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.psy.org.il"}}'::jsonb
WHERE card_key = '354|||טיפול נפשי לילדים, לנוער ולמבוגרים';

UPDATE directory_card_edits
SET site_languages = '{"en":{"web":"https://www.mymc.co.il/en/clinics/mental-health-clinic-for-english-speakers-2/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.mymc.co.il/en/clinics/mental-health-clinic-for-english-speakers-2/"}'::jsonb,
      true
    )
WHERE card_key = '355|||מרפאה לבריאות הנפש לדוברי אנגלית';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://mental-data.datacity.org.il/"}}'::jsonb
WHERE card_key = '356|||מאגרי נתונים פתוחים על בריאות הנפש בישראל';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.telem.org.il"}}'::jsonb
WHERE card_key = '357|||רשת לטיפול פסיכולוגי, ייעוץ ואבחון (ע"ר, קבוצת עמל)';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '358|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '359|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.bayit-cham.org.il/"}}'::jsonb
WHERE card_key = '360|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '361|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '362|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '363|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '364|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '365|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.bayit-cham.org.il/"}}'::jsonb
WHERE card_key = '366|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '367|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '368|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '369|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '370|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '371|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '372|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '373|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.bayit-cham.org.il/"}}'::jsonb
WHERE card_key = '374|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.leumit.co.il/mental-health-arena/mental-health-services/"},"en":{"web":"https://www.leumit.co.il/en/mental-health-arena/mental-health-services/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.leumit.co.il/en/mental-health-arena/mental-health-services/"}'::jsonb,
      true
    )
WHERE card_key = '375|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '376|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '377|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '378|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.barzilaimc.org.il/?CategoryID=240&ArticleID=866"}}'::jsonb
WHERE card_key = '379|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '380|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '381|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '382|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.shamir.org/he/clinic/psychiatry/"}}'::jsonb
WHERE card_key = '383|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/mental-health-center-beer-yaacov-ness-ziona/govil-landing-page"}}'::jsonb
WHERE card_key = '384|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '385|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '386|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '387|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '388|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.nefeshb7.org.il/"}}'::jsonb
WHERE card_key = '389|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.nefeshb7.org.il/"}}'::jsonb
WHERE card_key = '390|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/soroka/he/med-units/psychiatry/Pages/default.aspx"}}'::jsonb
WHERE card_key = '391|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/soroka/he/med-units/psychiatry/Pages/default.aspx"}}'::jsonb
WHERE card_key = '392|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/soroka/he/med-units/psychiatry/Pages/default.aspx"}}'::jsonb
WHERE card_key = '393|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/soroka/he/med-units/psychiatry/Pages/default.aspx"}}'::jsonb
WHERE card_key = '394|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/soroka/he/med-units/psychiatry/Pages/default.aspx"}}'::jsonb
WHERE card_key = '395|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.nefeshb7.org.il/"}}'::jsonb
WHERE card_key = '396|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.shaar-menashe.org/"}}'::jsonb
WHERE card_key = '397|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '398|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '399|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.psjer.org.il/"}}'::jsonb
WHERE card_key = '400|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.psjer.org.il/"}}'::jsonb
WHERE card_key = '401|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '402|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '403|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.bayit-cham.org.il/"}}'::jsonb
WHERE card_key = '404|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '405|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '406|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '407|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mymc.co.il/division/mental-health-division/"},"en":{"web":"https://www.mymc.co.il/en/the-mental-health-department-en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.mymc.co.il/en/the-mental-health-department-en/"}'::jsonb,
      true
    )
WHERE card_key = '408|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mymc.co.il/division/mental-health-division/"},"en":{"web":"https://www.mymc.co.il/en/the-mental-health-department-en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.mymc.co.il/en/the-mental-health-department-en/"}'::jsonb,
      true
    )
WHERE card_key = '409|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '410|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.bayit-cham.org.il/"}}'::jsonb
WHERE card_key = '411|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/mental-health-center-abarbanel/govil-landing-page"}}'::jsonb
WHERE card_key = '412|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/mental-health-center-abarbanel/govil-landing-page"}}'::jsonb
WHERE card_key = '413|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '414|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/mental-health-center-abarbanel/govil-landing-page"}}'::jsonb
WHERE card_key = '415|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/mental-health-center-abarbanel/govil-landing-page"}}'::jsonb
WHERE card_key = '416|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '417|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '418|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '419|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '420|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/shalvata/he/Pages/default.aspx"}}'::jsonb
WHERE card_key = '421|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/shalvata/he/Pages/default.aspx"}}'::jsonb
WHERE card_key = '422|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/shalvata/he/Pages/default.aspx"}}'::jsonb
WHERE card_key = '423|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '424|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '425|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '426|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '427|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '428|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '429|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '430|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.bayit-cham.org.il/"}}'::jsonb
WHERE card_key = '431|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hymc.org.il/?CategoryID=234"}}'::jsonb
WHERE card_key = '432|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '433|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hymc.org.il/?CategoryID=234"}}'::jsonb
WHERE card_key = '434|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '435|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '436|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hymc.org.il/?CategoryID=234"}}'::jsonb
WHERE card_key = '437|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '438|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '439|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '440|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '441|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '442|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '443|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '444|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '445|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '446|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '447|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '448|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.tiratcarmel-med.org.il/"}}'::jsonb
WHERE card_key = '449|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.rambam.org.il/departmentsandclinics/mental-health-division"}}'::jsonb
WHERE card_key = '450|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '451|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '452|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '453|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.rambam.org.il/departmentsandclinics/mental-health-division"}}'::jsonb
WHERE card_key = '454|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.rambam.org.il/departmentsandclinics/mental-health-division"}}'::jsonb
WHERE card_key = '455|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '456|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/adult_psychiatric_ziv"}}'::jsonb
WHERE card_key = '457|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '458|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '459|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '460|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '461|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '462|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '463|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.tiratcarmel-med.org.il/"}}'::jsonb
WHERE card_key = '464|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.tiratcarmel-med.org.il/"}}'::jsonb
WHERE card_key = '465|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.tiratcarmel-med.org.il/"}}'::jsonb
WHERE card_key = '466|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '467|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '468|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/mental-health-center-beer-yaacov-ness-ziona/govil-landing-page"}}'::jsonb
WHERE card_key = '469|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '470|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.leumit.co.il/mental-health-arena/mental-health-services/"},"en":{"web":"https://www.leumit.co.il/en/mental-health-arena/mental-health-services/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.leumit.co.il/en/mental-health-arena/mental-health-services/"}'::jsonb,
      true
    )
WHERE card_key = '471|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '472|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '473|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '474|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '475|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '476|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '477|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '478|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.psjer.org.il/"}}'::jsonb
WHERE card_key = '479|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.psjer.org.il/"}}'::jsonb
WHERE card_key = '480|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://he.hadassah.org.il/patient-information/information-sheets-for-patients-in-the-department-of-psychiatry/"}}'::jsonb
WHERE card_key = '481|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://he.hadassah.org.il/patient-information/information-sheets-for-patients-in-the-department-of-psychiatry/"}}'::jsonb
WHERE card_key = '482|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://he.hadassah.org.il/patient-information/information-sheets-for-patients-in-the-department-of-psychiatry/"}}'::jsonb
WHERE card_key = '483|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://he.hadassah.org.il/patient-information/information-sheets-for-patients-in-the-department-of-psychiatry/"}}'::jsonb
WHERE card_key = '484|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://he.hadassah.org.il/patient-information/information-sheets-for-patients-in-the-department-of-psychiatry/"}}'::jsonb
WHERE card_key = '485|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '486|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '487|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '488|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '489|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.psjer.org.il/"}}'::jsonb
WHERE card_key = '490|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '491|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.psjer.org.il/"}}'::jsonb
WHERE card_key = '492|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.psjer.org.il/"}}'::jsonb
WHERE card_key = '493|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.psjer.org.il/"}}'::jsonb
WHERE card_key = '494|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.psjer.org.il/"}}'::jsonb
WHERE card_key = '495|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.psjer.org.il/"}}'::jsonb
WHERE card_key = '496|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.psjer.org.il/"}}'::jsonb
WHERE card_key = '497|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://he.hadassah.org.il/patient-information/information-sheets-for-patients-in-the-department-of-psychiatry/"}}'::jsonb
WHERE card_key = '498|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://he.hadassah.org.il/patient-information/information-sheets-for-patients-in-the-department-of-psychiatry/"}}'::jsonb
WHERE card_key = '499|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '500|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '501|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.bayit-cham.org.il/"}}'::jsonb
WHERE card_key = '502|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '503|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '504|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.leumit.co.il/mental-health-arena/mental-health-services/"},"en":{"web":"https://www.leumit.co.il/en/mental-health-arena/mental-health-services/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.leumit.co.il/en/mental-health-arena/mental-health-services/"}'::jsonb,
      true
    )
WHERE card_key = '505|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '506|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '507|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '508|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '509|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '510|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '511|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.herzoghospital.org.il/"}}'::jsonb
WHERE card_key = '512|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.herzoghospital.org.il/"}}'::jsonb
WHERE card_key = '513|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.psjer.org.il/"}}'::jsonb
WHERE card_key = '514|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.bayit-cham.org.il/"}}'::jsonb
WHERE card_key = '515|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '516|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '517|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '518|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '519|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/shalvata/he/Pages/default.aspx"}}'::jsonb
WHERE card_key = '520|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '521|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '522|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '523|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mazorhealth.co.il/"}}'::jsonb
WHERE card_key = '524|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '525|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/mental-health-center-beer-yaacov-ness-ziona/govil-landing-page"}}'::jsonb
WHERE card_key = '526|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/mental-health-center-beer-yaacov-ness-ziona/govil-landing-page"}}'::jsonb
WHERE card_key = '527|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '528|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/adult_psychiatric_ziv"}}'::jsonb
WHERE card_key = '529|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/adult_psychiatric_ziv"}}'::jsonb
WHERE card_key = '530|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/adult_psychiatric_ziv"}}'::jsonb
WHERE card_key = '531|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/adult_psychiatric_ziv"}}'::jsonb
WHERE card_key = '532|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '533|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '534|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/mental-health-center-beer-yaacov-ness-ziona/govil-landing-page"}}'::jsonb
WHERE card_key = '535|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '536|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '537|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '538|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '539|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '540|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.bayit-cham.org.il/"}}'::jsonb
WHERE card_key = '541|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '542|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '543|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.psjer.org.il/"}}'::jsonb
WHERE card_key = '544|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '545|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.psjer.org.il/"}}'::jsonb
WHERE card_key = '546|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '547|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '548|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '549|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mazorhealth.co.il/"}}'::jsonb
WHERE card_key = '550|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '551|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mazorhealth.co.il/"}}'::jsonb
WHERE card_key = '552|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mazorhealth.co.il/"}}'::jsonb
WHERE card_key = '553|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.leumit.co.il/mental-health-arena/mental-health-services/"},"en":{"web":"https://www.leumit.co.il/en/mental-health-arena/mental-health-services/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.leumit.co.il/en/mental-health-arena/mental-health-services/"}'::jsonb,
      true
    )
WHERE card_key = '554|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '555|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.amcha.org/"}}'::jsonb
WHERE card_key = '556|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '557|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '558|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/mental-health-center-beer-yaacov-ness-ziona/govil-landing-page"}}'::jsonb
WHERE card_key = '559|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/mental-health-center-beer-yaacov-ness-ziona/govil-landing-page"}}'::jsonb
WHERE card_key = '560|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '561|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://nazhosp.com/"},"en":{"web":"https://nazhosp.com/?lang=en"},"ar":{"web":"https://nazhosp.com/"},"ru":{"web":"https://nazhosp.com/?lang=ru"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://nazhosp.com/?lang=en"}'::jsonb,
      true
    )
WHERE card_key = '562|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://nazhosp.com/"},"en":{"web":"https://nazhosp.com/?lang=en"},"ar":{"web":"https://nazhosp.com/"},"ru":{"web":"https://nazhosp.com/?lang=ru"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://nazhosp.com/?lang=en"}'::jsonb,
      true
    )
WHERE card_key = '563|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '564|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '565|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '566|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '567|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '568|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '569|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.lev-hasharon.co.il/"},"en":{"web":"https://www.lev-hasharon.co.il/?lang=en"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.lev-hasharon.co.il/?lang=en"}'::jsonb,
      true
    )
WHERE card_key = '570|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.lev-hasharon.co.il/"},"en":{"web":"https://www.lev-hasharon.co.il/?lang=en"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.lev-hasharon.co.il/?lang=en"}'::jsonb,
      true
    )
WHERE card_key = '571|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '572|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.amcha.org/"}}'::jsonb
WHERE card_key = '573|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '574|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.leumit.co.il/mental-health-arena/mental-health-services/"},"en":{"web":"https://www.leumit.co.il/en/mental-health-arena/mental-health-services/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.leumit.co.il/en/mental-health-arena/mental-health-services/"}'::jsonb,
      true
    )
WHERE card_key = '575|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '576|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '577|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '578|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '579|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mazorhealth.co.il/"}}'::jsonb
WHERE card_key = '580|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mazorhealth.co.il/"}}'::jsonb
WHERE card_key = '581|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '582|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/emek/he/Pages/default.aspx"},"en":{"web":"https://hospitals.clalit.co.il/emek/en/Pages/default.aspx"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://hospitals.clalit.co.il/emek/en/Pages/default.aspx"}'::jsonb,
      true
    )
WHERE card_key = '583|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/emek/he/Pages/default.aspx"},"en":{"web":"https://hospitals.clalit.co.il/emek/en/Pages/default.aspx"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://hospitals.clalit.co.il/emek/en/Pages/default.aspx"}'::jsonb,
      true
    )
WHERE card_key = '584|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/emek/he/Pages/default.aspx"},"en":{"web":"https://hospitals.clalit.co.il/emek/en/Pages/default.aspx"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://hospitals.clalit.co.il/emek/en/Pages/default.aspx"}'::jsonb,
      true
    )
WHERE card_key = '585|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '586|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '587|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '588|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '589|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '590|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '591|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '592|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '593|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '594|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.lev-hasharon.co.il/"},"en":{"web":"https://www.lev-hasharon.co.il/?lang=en"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.lev-hasharon.co.il/?lang=en"}'::jsonb,
      true
    )
WHERE card_key = '595|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '596|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/geha/he/Pages/default.aspx"}}'::jsonb
WHERE card_key = '597|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/geha/he/Pages/default.aspx"}}'::jsonb
WHERE card_key = '598|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/geha/he/Pages/default.aspx"}}'::jsonb
WHERE card_key = '599|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/geha/he/Pages/default.aspx"}}'::jsonb
WHERE card_key = '600|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '601|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '602|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '603|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '604|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '605|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.schneider.org.il/?CategoryID=987&ArticleID=2982"}}'::jsonb
WHERE card_key = '606|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/adult_psychiatric_ziv"}}'::jsonb
WHERE card_key = '607|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/adult_psychiatric_ziv"}}'::jsonb
WHERE card_key = '608|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/adult_psychiatric_ziv"}}'::jsonb
WHERE card_key = '609|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '610|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '611|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/adult_psychiatric_ziv"}}'::jsonb
WHERE card_key = '612|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '613|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '614|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '615|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '616|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.tiratcarmel-med.org.il/"}}'::jsonb
WHERE card_key = '617|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.barzilaimc.org.il/?CategoryID=240&ArticleID=866"}}'::jsonb
WHERE card_key = '618|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '619|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/adult_psychiatric_ziv"}}'::jsonb
WHERE card_key = '620|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '621|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '622|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '623|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '624|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '625|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '626|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '627|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '628|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '629|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '630|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/mental-health-center-beer-yaacov-ness-ziona/govil-landing-page"}}'::jsonb
WHERE card_key = '631|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/mental-health-center-beer-yaacov-ness-ziona/govil-landing-page"}}'::jsonb
WHERE card_key = '632|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '633|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '634|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/kaplan/he/med_units/psychiatric_care/Pages/psychiatric_day_care.aspx"}}'::jsonb
WHERE card_key = '635|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/kaplan/he/med_units/psychiatric_care/Pages/psychiatric_day_care.aspx"}}'::jsonb
WHERE card_key = '636|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '637|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '638|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/mental-health-center-beer-yaacov-ness-ziona/govil-landing-page"}}'::jsonb
WHERE card_key = '639|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.sheba.co.il"}}'::jsonb
WHERE card_key = '640|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.sheba.co.il"}}'::jsonb
WHERE card_key = '641|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.sheba.co.il"}}'::jsonb
WHERE card_key = '642|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.sheba.co.il"}}'::jsonb
WHERE card_key = '643|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.sheba.co.il"}}'::jsonb
WHERE card_key = '644|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.sheba.co.il"}}'::jsonb
WHERE card_key = '645|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.sheba.co.il"}}'::jsonb
WHERE card_key = '646|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.sheba.co.il"}}'::jsonb
WHERE card_key = '647|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.sheba.co.il"}}'::jsonb
WHERE card_key = '648|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.sheba.co.il"}}'::jsonb
WHERE card_key = '649|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.sheba.co.il"}}'::jsonb
WHERE card_key = '650|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.sheba.co.il"}}'::jsonb
WHERE card_key = '651|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '652|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '653|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '654|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '655|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '656|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '657|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '658|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.barzilaimc.org.il/?CategoryID=240&ArticleID=866"}}'::jsonb
WHERE card_key = '659|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '660|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '661|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '662|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '663|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.bayit-cham.org.il/"}}'::jsonb
WHERE card_key = '664|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.tasmc.org.il/unit-index-page/psychiatr/"}}'::jsonb
WHERE card_key = '665|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '666|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '667|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '668|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '669|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '670|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '671|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '672|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '673|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '674|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '675|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.tasmc.org.il/unit-index-page/psychiatr/"}}'::jsonb
WHERE card_key = '676|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.tasmc.org.il/unit-index-page/psychiatr/"}}'::jsonb
WHERE card_key = '677|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/PublicBodies/yaffo-yaffo"}}'::jsonb
WHERE card_key = '678|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '679|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.maccabi4u.co.il"},"ru":{"web":"https://www.maccabi4u.co.il/ru/homepage-ru/main-russian/"}}'::jsonb
WHERE card_key = '680|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '681|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.clalit.co.il"}}'::jsonb
WHERE card_key = '682|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '683|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.meuhedet.co.il"},"en":{"web":"https://www.meuhedet.co.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.meuhedet.co.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '684|||מרפאה רב-צוותית לבריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '685|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '686|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '687|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '688|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '689|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '690|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '691|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '692|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '693|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '694|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '695|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '696|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '697|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '698|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '699|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '700|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '701|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '702|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '703|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '704|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '705|||טיפול יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '706|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '707|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '708|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '709|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '710|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '711|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '712|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '713|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '714|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '715|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/mental-health-daily"}}'::jsonb
WHERE card_key = '716|||אשפוז יום פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.sheba.co.il"}}'::jsonb
WHERE card_key = '717|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.rambam.org.il/departmentsandclinics/mental-health-division"}}'::jsonb
WHERE card_key = '718|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.shamir.org/he/clinic/psychiatry/"}}'::jsonb
WHERE card_key = '719|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/wolfson/govil-landing-page"}}'::jsonb
WHERE card_key = '720|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/pages/adult_psychiatric_ziv"}}'::jsonb
WHERE card_key = '721|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hymc.org.il/?CategoryID=234"}}'::jsonb
WHERE card_key = '722|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gmc.org.il/?CategoryID=1424"}}'::jsonb
WHERE card_key = '723|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.barzilaimc.org.il/?CategoryID=240&ArticleID=866"}}'::jsonb
WHERE card_key = '724|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.poria.org.il/"},"en":{"web":"https://www.poria.org.il/en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.poria.org.il/en/"}'::jsonb,
      true
    )
WHERE card_key = '725|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.tasmc.org.il/unit-index-page/psychiatr/"}}'::jsonb
WHERE card_key = '726|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '727|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/soroka/he/med-units/psychiatry/Pages/default.aspx"}}'::jsonb
WHERE card_key = '728|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/meir/he/Pages/default.aspx"},"ar":{"web":"https://hospitals.clalit.co.il/meir/ar/Pages/default.aspx"}}'::jsonb
WHERE card_key = '729|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/kaplan/he/med_units/psychiatric_care/Pages/psychiatric_day_care.aspx"}}'::jsonb
WHERE card_key = '730|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/emek/he/Pages/default.aspx"},"en":{"web":"https://hospitals.clalit.co.il/emek/en/Pages/default.aspx"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://hospitals.clalit.co.il/emek/en/Pages/default.aspx"}'::jsonb,
      true
    )
WHERE card_key = '731|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://he.hadassah.org.il/patient-information/information-sheets-for-patients-in-the-department-of-psychiatry/"}}'::jsonb
WHERE card_key = '732|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://he.hadassah.org.il/patient-information/information-sheets-for-patients-in-the-department-of-psychiatry/"}}'::jsonb
WHERE card_key = '733|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://nazhosp.com/"},"en":{"web":"https://nazhosp.com/?lang=en"},"ar":{"web":"https://nazhosp.com/"},"ru":{"web":"https://nazhosp.com/?lang=ru"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://nazhosp.com/?lang=en"}'::jsonb,
      true
    )
WHERE card_key = '734|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://saint-vincent-hospital.org/"},"ar":{"web":"https://saint-vincent-hospital.org/?lang=ar"}}'::jsonb
WHERE card_key = '735|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hfhosp.org/he"},"en":{"web":"https://hfhosp.org/en"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://hfhosp.org/en"}'::jsonb,
      true
    )
WHERE card_key = '736|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.szmc.org.il/departments/internal-medicine/yehida-leyeutz-psichiatry/"}}'::jsonb
WHERE card_key = '737|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mymc.co.il/division/mental-health-division/"},"en":{"web":"https://www.mymc.co.il/en/the-mental-health-department-en/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.mymc.co.il/en/the-mental-health-department-en/"}'::jsonb,
      true
    )
WHERE card_key = '738|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '739|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.schneider.org.il/?CategoryID=987&ArticleID=2982"}}'::jsonb
WHERE card_key = '740|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.shaar-menashe.org/"}}'::jsonb
WHERE card_key = '741|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/mental-health-center-abarbanel/govil-landing-page"}}'::jsonb
WHERE card_key = '742|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.mazorhealth.co.il/"}}'::jsonb
WHERE card_key = '743|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.gov.il/he/departments/mental-health-center-beer-yaacov-ness-ziona/govil-landing-page"}}'::jsonb
WHERE card_key = '744|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.lev-hasharon.co.il/"},"en":{"web":"https://www.lev-hasharon.co.il/?lang=en"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.lev-hasharon.co.il/?lang=en"}'::jsonb,
      true
    )
WHERE card_key = '745|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.tiratcarmel-med.org.il/"}}'::jsonb
WHERE card_key = '746|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.nefeshb7.org.il/"}}'::jsonb
WHERE card_key = '747|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"http://www.psjer.org.il/?CategoryID=254"}}'::jsonb
WHERE card_key = '748|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/geha/he/Pages/default.aspx"}}'::jsonb
WHERE card_key = '749|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/shalvata/he/Pages/default.aspx"}}'::jsonb
WHERE card_key = '750|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '751|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.herzoghospital.org.il/"}}'::jsonb
WHERE card_key = '752|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://hospitals.clalit.co.il/loewenstein/he/Pages/default.aspx"},"en":{"web":"https://hospitals.clalit.co.il/loewenstein/En/Pages/default.aspx"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://hospitals.clalit.co.il/loewenstein/En/Pages/default.aspx"}'::jsonb,
      true
    )
WHERE card_key = '753|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://www.alyn.org.il/"}}'::jsonb
WHERE card_key = '754|||אשפוז פסיכיאטרי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/medical/mental-therapy","web2":"https://shikum.mod.gov.il/medical/mental-therapy/main-services-guide","add":"https://myshikum.mod.gov.il/suppliers/therapy"}}'::jsonb
WHERE card_key = '755|||עמוד השירותים לטיפול ושיקום נפשי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://tochnitamit.mod.gov.il/"}}'::jsonb
WHERE card_key = '756|||טיפולים, ספורט וסדנאות בחינם למשוחררי מלחמת חרבות ברזל';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/medical/mental-therapy/before-recognition"}}'::jsonb
WHERE card_key = '757|||מדריך מענים נפשיים למי שטרם הגיש בקשה להכרה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/medical/mental-therapy/matan"}}'::jsonb
WHERE card_key = '758|||צוות התערבות מתן לשעת משבר';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/medical/hospitalization/service-dog"}}'::jsonb
WHERE card_key = '759|||כלב סיוע להתמודדות עם פוסט טראומה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/rehabilitation/vocational/farms-therapy"}}'::jsonb
WHERE card_key = '760|||חוות שיקומיות לפוסט טראומה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/medical/mental-therapy/maavar_housing"}}'::jsonb
WHERE card_key = '761|||בית מעבר בית מעגן';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/medical/mental-therapy/balancing-house"}}'::jsonb
WHERE card_key = '762|||בית מאזן בקהילה — מניעת אשפוז';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/rehabilitation/vocational/group-therapy","add":"https://shikum.mod.gov.il/groups"}}'::jsonb
WHERE card_key = '763|||קבוצות טיפוליות לנכי צה״ל ולבני משפחה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/rehabilitation/vocational/tutoring"}}'::jsonb
WHERE card_key = '764|||חונכות אישית לשיקום בבית ובקהילה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/medical/treatment/alternative","add":"https://shikumme.co.il/"}}'::jsonb
WHERE card_key = '765|||טיפולי רפואה משלימה באפליקציית Shikum.Me';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/family/support/therapy"}}'::jsonb
WHERE card_key = '766|||טיפול נפשי לבני משפחה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/medical/treatment/intimacy-therapy"}}'::jsonb
WHERE card_key = '767|||טיפול בתפקוד האינטימי';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/medical/relaxation/mental","add":"https://shikum.mod.gov.il/medical/relaxation/hospitalization"}}'::jsonb
WHERE card_key = '768|||הבראה למתמודדים עם פגיעה נפשית';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikum.mod.gov.il/medical/treatment/ptsd"}}'::jsonb
WHERE card_key = '769|||טיפולים חדשניים להקלה בפוסט טראומה';

UPDATE directory_card_edits
SET site_languages = '{"en":{"web":"https://www.geerz.org/en/","web2":"https://www.geerz.org/en/page/registration/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.geerz.org/en/","web2":"https://www.geerz.org/en/page/registration/"}'::jsonb,
      true
    )
WHERE card_key = '770|||רכיבת הרים טיפולית לילדים ונוער, גילאי 7–16';

UPDATE directory_card_edits
SET site_languages = '{"en":{"web":"https://www.geerz.org/en/veterans.php"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.geerz.org/en/veterans.php"}'::jsonb,
      true
    )
WHERE card_key = '771|||רכיבת הרים טיפולית ללוחמים ומילואימניקים';

UPDATE directory_card_edits
SET site_languages = '{"en":{"web":"https://www.hin-group.org/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://www.hin-group.org/"}'::jsonb,
      true
    )
WHERE card_key = '772|||ריטריט בטבע ללוחמים קרביים';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://fighting-ocd.com/ocdgroup/"}}'::jsonb
WHERE card_key = '773|||קבוצת תמיכה למתמודדים עם OCD';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://fighting-ocd.com/pereants-sec/"}}'::jsonb
WHERE card_key = '774|||קבוצת תמיכה להורים למתמודדים עם OCD';

UPDATE directory_card_edits
SET site_languages = '{"en":{"web":"https://jtc.org.il/"}}'::jsonb,
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || '{"web":"https://jtc.org.il/"}'::jsonb,
      true
    )
WHERE card_key = '775|||Counseling in English for adults in Jerusalem';

UPDATE directory_card_edits
SET site_languages = '{}'::jsonb
WHERE card_key = '776|||חוברת זכויות בריאות הנפש';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://shikumacher.org.il/","web2":"https://shikumacher.org.il/programs/"}}'::jsonb
WHERE card_key = '777|||תעסוקה נתמכת ופיתוח קריירה לזכאי סל שיקום';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://ruahyam.com/"}}'::jsonb
WHERE card_key = '778|||בית מאזן פרטי יוקרתי, ללא רשימת המתנה';

UPDATE directory_card_edits
SET site_languages = '{"he":{"web":"https://ruahyam-provence.co.il/"}}'::jsonb
WHERE card_key = '779|||בית מאזן';

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-08-english-site-languages',
  DATE '2026-11-08',
  'כרטיסים באנגלית רק כשיש אתר באנגלית',
  'במצב אנגלית מוצגים כרטיסים שהעמוד שלהם קיים באנגלית, והקישור לאתר נפתח בעמוד האנגלי. כרטיס בלי עמוד באנגלית לא מופיע, אלא אם בוחרים «הצג כרטיסים בכל השפות».',
  'cards',
  '{}',
  '{}',
  '124_site_languages.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
