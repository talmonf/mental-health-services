// Builds scripts/128_mh_public_names_english.sql from migration 102.
// Retitles a public card when its name is a street, a city, an age group, or a
// leaked heading. The new title is the health fund or the mental-health center.
// Phone buttons get the label טלפון and stop printing the number.
// translations.en is filled in. An English web URL already stored is left in place.
//
//   node scripts/generate_mh_public_card_fix.js

const fs = require('fs');
const path = require('path');

const SRC = path.join(__dirname, '102_multidisciplinary_public_centers.sql');
const OUT = path.join(__dirname, '128_mh_public_names_english.sql');
const ROW_MIN = 358;
const ROW_MAX = 754;

const CITIES = {
  'אום אל פחם': 'Umm al-Fahm',
  'אופקים': 'Ofakim',
  'אזור': 'Azor',
  'אזור תעסוקה משגב (תרדיון)': 'Misgav industrial zone (Teradion)',
  'אילת': 'Eilat',
  'אלעד': 'Elad',
  'אפרת': 'Efrat',
  'אריאל': 'Ariel',
  'אשדוד': 'Ashdod',
  'אשקלון': 'Ashkelon',
  "באקה אל ע'רביה": 'Baqa al-Gharbiyye',
  'באר יעקב': "Be'er Yaakov",
  'באר שבע': "Be'er Sheva",
  'בי"ח שער מנשה': "Sha'ar Menashe hospital",
  'בית החולים באר יעקב': "Be'er Yaakov hospital",
  'בית החולים נס ציונה': 'Ness Ziona hospital',
  'בית שמש': 'Beit Shemesh',
  'ביתר': 'Beitar',
  'בני ברק': 'Bnei Brak',
  'בת ים': 'Bat Yam',
  'גבעת שמואל': 'Givat Shmuel',
  'דימונה': 'Dimona',
  'דלית אל כרמל': 'Daliyat al-Karmel',
  'הוד השרון': 'Hod HaSharon',
  'הרצליה': 'Herzliya',
  'הרצלייה': 'Herzliya',
  'זכרון יעקב': "Zikhron Ya'akov",
  'חדרה': 'Hadera',
  'חולון': 'Holon',
  'חיפה': 'Haifa',
  'טבריה': 'Tiberias',
  'טייבה': 'Tayibe',
  'טירה': 'Tira',
  'טירת הכרמל': 'Tirat Carmel',
  'טירת כרמל': 'Tirat Carmel',
  'יבנה': 'Yavne',
  'יפו': 'Jaffa',
  'יקנעם': 'Yokneam',
  'ירושלים': 'Jerusalem',
  'ירכא': 'Yarka',
  'כפר ברא': 'Kfar Bara',
  'כפר כנא': 'Kfar Kanna',
  'כפר סבא': 'Kfar Saba',
  'כפר קרע': 'Kfar Qara',
  'כפר-סבא': 'Kfar Saba',
  'כרמיאל': 'Karmiel',
  'לוד': 'Lod',
  'מבשרת ציון': 'Mevaseret Zion',
  "מג'אר": 'Maghar',
  "מג'דל שמס": 'Majdal Shams',
  'מגדל העמק': 'Migdal HaEmek',
  'מודיעין': "Modi'in",
  'מודיעין .': "Modi'in",
  'מודיעין עילית': "Modi'in Illit",
  'מזרח ירושלים': 'East Jerusalem',
  'מיתרים': 'Meitarim',
  'מעלה אדומים': "Ma'ale Adumim",
  'מעלות': "Ma'alot",
  'נהריה': 'Nahariya',
  'נחף': 'Nahf',
  'נס ציונה': 'Ness Ziona',
  'נצרת': 'Nazareth',
  'נצרת עילית': 'Nazareth Illit',
  'נתניה': 'Netanya',
  'נתניה ק. השרון': 'Netanya, Kiryat Hasharon',
  'סחנין': 'Sakhnin',
  'עוספיה': 'Isfiya',
  'עכו': 'Acre',
  'עפולה': 'Afula',
  'עראבה': 'Arraba',
  'ערד': 'Arad',
  'עתניאל': 'Otniel',
  'פ"ת': 'Petah Tikva',
  'פארק המדע רחובות': 'Rehovot Science Park',
  'פרדס חנה-כרכור': 'Pardes Hanna-Karkur',
  'פרדסיה': 'Pardesiya',
  'פתח תקוה': 'Petah Tikva',
  'פתח תקווה': 'Petah Tikva',
  "צמוד למרפאת בית שאן ג'": "next to Beit She'an clinic C",
  'צפת': 'Safed',
  'קלנסווה': 'Qalansawe',
  'קצרין': 'Katzrin',
  'קריית גת': 'Kiryat Gat',
  'קריית מלאכי': 'Kiryat Malakhi',
  'קרית ארבע': 'Kiryat Arba',
  'קרית אתא': 'Kiryat Ata',
  'קרית גת': 'Kiryat Gat',
  'קרית מוצקין': 'Kiryat Motzkin',
  'קרית שמונה': 'Kiryat Shmona',
  'ראשון לציון': 'Rishon LeZion',
  'ראשל"צ': 'Rishon LeZion',
  'רהט': 'Rahat',
  'רחובות': 'Rehovot',
  'רמלה': 'Ramla',
  'רמת גן': 'Ramat Gan',
  'רמת השרון': 'Ramat HaSharon',
  'רמת-גן': 'Ramat Gan',
  'רעות': "Re'ut",
  'רעננה': "Ra'anana",
  'שדרות': 'Sderot',
  'שוהם': 'Shoham',
  'שער מנשה': "Sha'ar Menashe",
  'שפרעם': "Shefa-Amr",
  'תל אביב': 'Tel Aviv',
  'תל אביב - יפו': 'Tel Aviv-Yafo',
  'תל אביב יפו': 'Tel Aviv-Yafo',
  'תל השומר': 'Tel HaShomer',
  'תל-אביב': 'Tel Aviv',
  'בית שאן': "Beit She'an",
  'רמת חן': 'Ramat Chen',
  'קריית אונו': 'Kiryat Ono',
  'גבעתיים': 'Givatayim',
  'יהוד': 'Yehud',
  'אור יהודה': 'Or Yehuda',
  'אור עקיבא': 'Or Akiva',
  'נשר': 'Nesher',
  'קריית ים': 'Kiryat Yam',
  'קריית ביאליק': 'Kiryat Bialik',
  'קריית מוצקין': 'Kiryat Motzkin',
  'עכו': 'Acre',
  'צפת': 'Safed',
  'טמרה': 'Tamra',
  'באקה': 'Baqa',
  'כפר יאסיף': 'Kfar Yasif',
  'מעלה אדומים': "Ma'ale Adumim",
  'אריאל': 'Ariel',
  'גדרה': 'Gedera',
  'יבנה': 'Yavne',
  'נס ציונה': 'Ness Ziona',
  'רחובות': 'Rehovot',
  'קרית גת': 'Kiryat Gat',
  'אופקים': 'Ofakim',
  'נתיבות': 'Netivot',
  'שדרות': 'Sderot',
  'אשקלון': 'Ashkelon',
  'אשדוד': 'Ashdod',
  'קרית מלאכי': 'Kiryat Malakhi',
  'גן יבנה': 'Gan Yavne',
  'מזכרת בתיה': 'Mazkeret Batya',
  'באר יעקב': "Be'er Yaakov",
  'רמלה': 'Ramla',
  'לוד': 'Lod',
  'מודיעין': "Modi'in",
  'ראש העין': 'Rosh HaAyin',
  'אלעד': 'Elad',
  'פתח תקווה': 'Petah Tikva',
  'ראשון לציון': 'Rishon LeZion',
  'חולון': 'Holon',
  'בת ים': 'Bat Yam',
  'יפו': 'Jaffa',
  'תל אביב': 'Tel Aviv',
  'רמת גן': 'Ramat Gan',
  'גבעתיים': 'Givatayim',
  'בני ברק': 'Bnei Brak',
  'גבעת שמואל': 'Givat Shmuel',
  'פתח תקוה': 'Petah Tikva',
  'הוד השרון': 'Hod HaSharon',
  'כפר סבא': 'Kfar Saba',
  'רעננה': "Ra'anana",
  'הרצליה': 'Herzliya',
  'רמת השרון': 'Ramat HaSharon',
  'נתניה': 'Netanya',
  'חדרה': 'Hadera',
  'פרדס חנה': 'Pardes Hanna',
  'זכרון יעקב': "Zikhron Ya'akov",
  'בנימינה': 'Binyamina',
  'חיפה': 'Haifa',
  'קריית אתא': 'Kiryat Ata',
  'קריית ביאליק': 'Kiryat Bialik',
  'קריית ים': 'Kiryat Yam',
  'קריית מוצקין': 'Kiryat Motzkin',
  'טירת כרמל': 'Tirat Carmel',
  'נשר': 'Nesher',
  'עכו': 'Acre',
  'נהריה': 'Nahariya',
  'כרמיאל': 'Karmiel',
  'צפת': 'Safed',
  'טבריה': 'Tiberias',
  'עפולה': 'Afula',
  'נצרת': 'Nazareth',
  'נוף הגליל': 'Nof HaGalil',
  'ירושלים': 'Jerusalem',
  'בית שמש': 'Beit Shemesh',
  'באר שבע': "Be'er Sheva",
  'אילת': 'Eilat',
  'דימונה': 'Dimona',
  'ערד': 'Arad',
  'ישראל': 'Israel',
};

const WORDS = {
  'יהודה': 'Yehuda',
  'פרח': 'Perach',
  'רמז': 'Remez',
  'הצורן': 'HaTzoran',
  'אמנון': 'Amnon',
  'תמר': 'Tamar',
  'שטמפפר': 'Shtamper',
  'פולג': 'Poleg',
  'רחוב': 'street',
  "רח'": 'street',
  'שדרות': 'Sderot',
  "שד'": 'Sderot',
  'דרך': 'Derekh',
  'שכונת': 'neighborhood',
  'שכונה': 'neighborhood',
  'קומה': 'floor',
  'בניין': 'building',
  'בית': 'Beit',
  'מרכז': 'center',
  'מרפאת': 'clinic',
  'מרפאה': 'clinic',
  'ילדים': 'children',
  'נוער': 'youth',
  'מבוגרים': 'adults',
  'ונוער': 'and youth',
  'פסיכוגריאטריה': 'psychogeriatrics',
  'פסיכוגריאטרית': 'psychogeriatric',
  'טיפול': 'treatment',
  'יום': 'day',
  'אשפוז': 'hospitalization',
  'פסיכיאטרי': 'psychiatric',
  'פסיכיאטרית': 'psychiatric',
  'בריאות': 'health',
  'הנפש': 'mental',
  'לבריאות': 'for health',
  'הנפש': 'mental health',
  'מבוגרים': 'adults',
  'כללית': 'Clalit',
  'מכבי': 'Maccabi',
  'מאוחדת': 'Meuhedet',
  'לאומית': 'Leumit',
  'ציפור': 'Tsipor',
  'הנפש': 'HaNefesh',
  'עמך': 'AMCHA',
  'עמותת': 'nonprofit',
  'אגודה': 'association',
  'הציבור': 'the public',
  'לבריאות': 'for health',
  'סורוקה': 'Soroka',
  'ברזילי': 'Barzilai',
  'אברבנאל': 'Abarbanel',
  'ניצנים': 'Nitzanim',
  'שלוותה': 'Shalvata',
  'גהה': 'Geha',
  'הדסה': 'Hadassah',
  'איכילוב': 'Ichilov',
  'רמב"ם': 'Rambam',
  'שניידר': 'Schneider',
  'וולפסון': 'Wolfson',
  'יוספטל': 'Yoseftal',
  'שיבא': 'Sheba',
  'בלינסון': 'Beilinson',
  'קפלן': 'Kaplan',
  'פוריה': 'Poria',
  'לניאדו': 'Laniado',
  'מאיר': 'Meir',
  'הלל': 'Hillel',
  'יפה': 'Yaffe',
  'מזור': 'Mazor',
  'הרצוג': 'Herzog',
  'אלין': 'ALYN',
  'הדקל': 'HaDekel',
  'זיו': 'Ziv',
  'שמיר': 'Shamir',
  'שער': "Sha'ar",
  'מנשה': 'Menashe',
  'לב': 'Lev',
  'השרון': 'HaSharon',
  'כפר': 'Kfar',
  'שאול': 'Shaul',
  'איתנים': 'Eitanim',
  'תפארת': 'Tiferet',
  'חם': 'Cham',
  'בניין': 'building',
  'רעים': "Re'im",
  'קניון': 'mall',
  'קומה': 'floor',
  'כניסה': 'entrance',
  'ליד': 'near',
  'מול': 'opposite',
  'צפון': 'north',
  'דרום': 'south',
  'מזרח': 'east',
  'מערב': 'west',
  'ישן': 'old',
  'חדש': 'new',
  'מרכזי': 'central',
  'העיר': 'the city',
  'העתיקה': 'the Old City',
  'גן': 'Gan',
  'נווה': 'Neve',
  'גבעת': 'Givat',
  'גבעה': 'Giv\'a',
  'קרית': 'Kiryat',
  'קריית': 'Kiryat',
  'שדרות': 'Sderot',
  'הרצל': 'Herzl',
  'ויצמן': 'Weizmann',
  'ביאליק': 'Bialik',
  'רוטשילד': 'Rothschild',
  'ז\'בוטינסקי': 'Jabotinsky',
  "ז'בוטינסקי": 'Jabotinsky',
  'בן': 'Ben',
  'גוריון': 'Gurion',
  'הנשיא': 'HaNasi',
  'העצמאות': 'HaAtzmaut',
  'ירושלים': 'Jerusalem',
  'הגליל': 'HaGalil',
  'הנגב': 'HaNegev',
  'הכרמל': 'HaCarmel',
  'הים': 'HaYam',
  'הפלמח': 'HaPalmach',
  'הפלמ"ח': 'HaPalmach',
  'ההגנה': 'HaHagana',
  'הברזל': 'HaBarzel',
  'התקווה': 'HaTikva',
  'התקוה': 'HaTikva',
  'השומרון': 'HaShomron',
  'הגלבוע': 'HaGilboa',
  'הירדן': 'HaYarden',
  'הירקון': 'HaYarkon',
  'הנביאים': 'HaNeviim',
  'המלך': 'HaMelekh',
  'דוד': 'David',
  'שלמה': 'Shlomo',
  'יצחק': 'Yitzhak',
  'רבין': 'Rabin',
  'בגין': 'Begin',
  'מנחם': 'Menachem',
  'גולדה': 'Golda',
  'מאיר': 'Meir',
  'אחד': 'Echad',
  'העם': 'HaAm',
  'סוקולוב': 'Sokolov',
  'ארלוזורוב': 'Arlozorov',
  'דיזנגוף': 'Dizengoff',
  'אלנבי': 'Allenby',
  'קינג': 'King',
  'ג\'ורג': 'George',
  "ג'ורג'": 'George',
  'יפו': 'Jaffa',
  'חיפה': 'Haifa',
  'נצרת': 'Nazareth',
  'עכו': 'Acre',
  'צפת': 'Safed',
  'טבריה': 'Tiberias',
  'באר': "Be'er",
  'שבע': 'Sheva',
  'יעקב': "Ya'akov",
  'שאן': "She'an",
  'הצדיק': 'HaTzadik',
  'מירושלים': 'miYerushalayim',
  'פתן': 'Petan',
  'ההסתדרות': 'HaHistadrut',
  'יהודה': 'Yehuda',
  'המכבי': 'HaMaccabi',
  'הציונות': 'HaTziyonut',
  'רגר': 'Rager',
  'אופנהיימר': 'Oppenheimer',
  'גיבורי': 'Giborei',
  'ישראל': 'Yisrael',
  'בנימין': 'Binyamin',
  'סמילנסקי': 'Smilansky',
  'לנטוס': 'Lantos',
  'טום': 'Tom',
  'עצמון': 'Atzmon',
  'אלהרם': 'Al-Haram',
  'אלעיון': 'Al-Iyun',
  'פנחס': 'Pinchas',
  'יאיר': 'Yair',
  'המלך': 'HaMelekh',
  'דוד': 'David',
  'שדרות': 'Sderot',
  'מעלה': "Ma'ale",
  'יצחק': 'Yitzhak',
  'הצורן': 'HaTzoran',
  'אמנון': 'Amnon',
  'ותמר': 'veTamar',
  'שטמפפר': 'Shtamper',
  'יוני': 'Yoni',
  'נתניהו': 'Netanyahu',
  'הפרחים': 'HaPrachim',
  'שער': "Sha'ar",
  'הפרחים': 'HaPrachim',
  'העיר': 'HaIr',
  'העתיקה': 'HaAtika',
  'ראשי': 'main',
  'קומת': 'floor',
  'קרקע': 'ground',
  'אתיופיה': 'Ethiopia',
  'תרצו': 'Tarzav',
  'שקד': 'Shaked',
  'בש': "Be'er Sheva",
  'ביהח': 'Hospital',
};

const PHRASES = {
  'מרפאה רב-צוותית לבריאות הנפש': 'Multidisciplinary mental health clinic',
  'טיפול יום פסיכיאטרי': 'Psychiatric day treatment',
  'אשפוז יום פסיכיאטרי': 'Psychiatric day hospitalization',
  'אשפוז פסיכיאטרי': 'Psychiatric hospitalization',
  'ציפור הנפש': 'Tsipor HaNefesh',
  'לב השרון': 'Lev Hasharon',
  'טיפול יום –': 'Day treatment — ',
  'טיפול יום -': 'Day treatment — ',
  'אשפוז יום –': 'Day hospitalization — ',
  'אשפוז יום -': 'Day hospitalization — ',
  'אשפוז פסיכיאטרי –': 'Psychiatric hospitalization — ',
  'אשפוז פסיכיאטרי -': 'Psychiatric hospitalization — ',
  'בית החולים': 'Hospital',
  'בית חולים': 'Hospital',
  'מרכז קהילתי לבריאות הנפש': 'community mental health center',
  'מרכז רפואי': 'medical center',
  'בית הספר שקד': 'Shaked School',
  'בית הספר': 'School',
  'ביה"ח ברזילי': 'Barzilai Hospital',
  'פלוטקין': 'Plotkin',
  'ת"א': 'Tel Aviv',
  'ת״א': 'Tel Aviv',
  'בי"ח ברזילי': 'Barzilai Hospital',
  'ביה״ח': 'Hospital',
  'ביה"ח': 'Hospital',
  'בי"ח': 'Hospital',
  'ב"ש': "Be'er Sheva",
  'אגודה לבריאות הציבור': 'Public Health Association',
  'תפארת בית חם': 'Tiferet Beit Cham',
  'עמותת בית חם': 'Beit Cham',
  'בית חם': 'Beit Cham',
  'מרכז בריאות הנפש': 'mental health center',
  'מרכז לבריאות הנפש': 'mental health center',
  'מרפאת בריאות הנפש': 'mental health clinic',
  'בריאות הנפש': 'mental health',
  'לבריאות הנפש': 'mental health',
  'ילדים ונוער': 'children and youth',
  'טיפול יום': 'day treatment',
  'אשפוז יום': 'day hospitalization',
  'הפרעות אכילה': 'eating disorders',
  'הפרעת אכילה': 'an eating disorder',
  'תחלואה כפולה': 'dual diagnosis',
  'פוסט-טראומה': 'post-trauma',
  'פוסט טראומה': 'post-trauma',
  'נפגעי תקיפה מינית': 'people affected by sexual assault',
  'נפגעי פגיעה מינית': 'people affected by sexual assault',
  'נפגעות תקיפה מינית': 'women affected by sexual assault',
  'פגיעה מינית': 'sexual assault',
  'תקיפה מינית': 'sexual assault',
  'פסיכיאטריה משפטית': 'forensic psychiatry',
  'פסיכוגריאטריה': 'psychogeriatrics',
  'פסיכוגריאטרית': 'psychogeriatric',
  'הפרעות חרדה': 'anxiety disorders',
  'הפרעת חרדה': 'an anxiety disorder',
  'מרפאת חרדה': 'an anxiety clinic',
  'צוות חרדה': 'an anxiety team',
  'הפרעות התנהגות': 'behavior disorders',
  'הפרעת קשב וריכוז': 'attention-deficit disorder',
  'הפרעות קשב': 'attention disorders',
  'יחידת ניצני קשב': 'an attention-disorder unit',
  'חונכות טיפולית': 'therapeutic mentoring',
  'גיל הרך': 'early childhood',
  'גיל רך': 'early childhood',
  'התערבות במשבר': 'crisis intervention',
  'הדרכת הורים': 'parent guidance',
  'הדרכות הורים': 'parent guidance',
  'סדנת הורים': 'a parents workshop',
  'קבוצת הורים': 'a parents group',
  'טיפול זוגי': 'couples therapy',
  'יעוץ זוגי': 'couples counseling',
  'ייעוץ זוגי': 'couples counseling',
  'טיפול משפחתי': 'family therapy',
  'התערבות משפחתית': 'family intervention',
  'טיפול דיאדי': 'dyadic therapy',
  'פסיכותרפיה פרטנית': 'individual psychotherapy',
  'פסיכותרפיה קבוצתית': 'group psychotherapy',
  'פסיכותרפיה': 'psychotherapy',
  'פסיכוטרפיה': 'psychotherapy',
  'מעקב פסיכיאטרי': 'psychiatric follow-up',
  'טיפול פסיכיאטרי': 'psychiatric treatment',
  'הערכה פסיכיאטרית': 'a psychiatric evaluation',
  'אבחון פסיכולוגי': 'psychological assessment',
  'אבחון פסיכוגריאטרי': 'psychogeriatric assessment',
  'טיפול תרופתי': 'medication treatment',
  'מעקב תרופתי': 'medication follow-up',
  'טיפול קבוצתי': 'group treatment',
  'טיפול פרטני': 'individual treatment',
  'טיפול דינמי': 'dynamic therapy',
  'טיפול דינאמי': 'dynamic therapy',
  'פסיכותרפיה דינמית': 'dynamic psychotherapy',
  'פסיכותרפיה דינאמית': 'dynamic psychotherapy',
  'דינמי': 'dynamic',
  'דינאמי': 'dynamic',
  'דיאדי': 'dyadic',
  'קבוצתי': 'group',
  'משפחתי': 'family',
  'פרטני': 'individual',
  'פרטנית': 'individual',
  'תרופתי': 'medication',
  'קצר מועד': 'short-term',
  'ארוך טווח': 'long-term',
  'לטווח ארוך': 'long-term',
  'לטווח קצר': 'short-term',
  'תמיכתי': 'supportive',
  'תמיכתית': 'supportive',
  'שיקומי': 'rehabilitative',
  'שיקום': 'rehabilitation',
  'סל שיקום': 'the rehabilitation basket',
  'סלי שיקום': 'rehabilitation baskets',
  'הכנה לסלי שיקום': 'preparation for a rehabilitation basket',
  'הגשה לסל שיקום': 'applying to the rehabilitation basket',
  'ריפוי בעיסוק': 'occupational therapy',
  'טיפול באמנות': 'art therapy',
  'טיפול באומנות': 'art therapy',
  'תרפיה באומנות': 'art therapy',
  'תרפיה באמנות': 'art therapy',
  'טיפול במוזיקה': 'music therapy',
  'תרפיה במוזיקה': 'music therapy',
  'טיפול בתנועה': 'movement therapy',
  'ביבליותרפיה': 'bibliotherapy',
  'בבילוטרפיה': 'bibliotherapy',
  'ביופידבק': 'biofeedback',
  'סכמה-תרפיה': 'schema therapy',
  'סכמה': 'schema',
  '12 צעדים': '12 steps',
  'ניהול מקרה': 'case management',
  'אינטייק': 'intake',
  'אבחון': 'assessment',
  'אבחונים': 'assessments',
  'חרדה': 'anxiety',
  'דיכאון': 'depression',
  'טראומה': 'trauma',
  'פסיכוזה': 'psychosis',
  'פסיכוטי': 'psychotic',
  'התמכרויות': 'addictions',
  'אוטיזם': 'autism',
  'קשב': 'attention',
  'משפחות': 'families',
  'הורים': 'parents',
  'נשים': 'women',
  'גברים': 'men',
  'ילדים': 'children',
  'נוער': 'youth',
  'מתבגרים': 'adolescents',
  'מבוגרים': 'adults',
  'קשישים': 'older adults',
  'כל סוגי הטיפול': 'all kinds of treatment',
  'כל סוגי ההתערבויות': 'all kinds of intervention',
  'ממוקד בטראומה': 'trauma-focused',
  'ממוקדת טראומה': 'trauma-focused',
  'ובהם': 'including',
  'כולל': 'including',
  'אין המתנה': 'no waiting list',
  'קבלה מיידית': 'immediate admission',
  'קבוצת תמיכה': 'a support group',
  'לבני משפחה': 'for family members',
  'קיימת': 'there is',
  'חוות דעת': 'an opinion',
  'לבתי משפט': 'for the courts',
  'בית משפט': 'a court',
  'מרפאת טיפול כפוי': 'a compulsory-treatment clinic',
  'טיפול כפוי': 'compulsory treatment',
  'צו לטמ"כ': 'a compulsory-treatment order',
  'טמ"כ': 'compulsory treatment',
  'מזרח ירושלים': 'East Jerusalem',
  'האוכלוסיה הערבית': 'the Arab population',
  'האוכלוסייה הערבית': 'the Arab population',
  'חירשים': 'deaf people',
  'כבדי שמיעה': 'people who are hard of hearing',
  'לקויי שמיעה': 'people with a hearing impairment',
  'לקוי שמיעה': 'hearing impairment',
  'לקו"ש': 'hearing impairment',
  'הפרעת אישיות גבולית': 'borderline personality disorder',
  'פסיכוזה ראשונה': 'first-episode psychosis',
  'משבר פסיכוטי': 'a psychotic crisis',
  'נכי משהב"ט': 'Ministry of Defense disabled veterans',
  'משהב"ט': 'the Ministry of Defense',
  'פוריות': 'fertility',
  'הריון': 'pregnancy',
  'לידה': 'childbirth',
  'אחרי לידה': 'after childbirth',
  'דיכאון אחרי לידה': 'postpartum depression',
  'אובדני הריון': 'pregnancy loss',
  'עיבוד אובדן': 'grief processing',
  'בריאות הנפש של האישה': "women's mental health",
  'מרפאה מגדרית': 'a gender clinic',
  'בריאטרית': 'bariatric',
  'אנקומפרזיס': 'encopresis',
  'הפרעות שינה': 'sleep disorders',
  'בעיות רפואיות כרוניות': 'chronic medical problems',
  'משפחות רב בעייתיות': 'families with many difficulties',
  'משפחות רב בעיתיות': 'families with many difficulties',
  'רב בעייתיות': 'with many difficulties',
  'אצל ילדים': 'in children',
  'הגדלים': 'growing up',
  'במשפחות': 'in families',
  'מענה': 'a response',
  'למגוון': 'to a range of',
  'מצבים': 'conditions',
  'רגשיים': 'emotional',
  'נפשיים': 'mental',
  'לא נבדק': 'was not checked',
  'במרפאה זו': 'at this clinic',
  'קופת חולים': 'a health fund',
  'משרד הבריאות': 'the Ministry of Health',
  'בית חולים': 'a hospital',
  'עמותה': 'a nonprofit',
  'מלכ"ר': 'a nonprofit',
  'ספק': 'a provider',
  'בהסדר': 'under contract',
  'חיצוני': 'external',
  'ממשלתי': 'government',
  'עירוני': 'municipal',
  'פרטי': 'private',
  'ציבורי': 'public',
  'מיסיון': 'mission',
  'לא צוין': 'not stated',
  'סוג הבעלות': 'the kind of ownership',
  'הבעלות': 'ownership',
};

const OWN = {
  'קופת חולים': 'Health fund',
  'עמותה (מלכ"ר) – ספק בהסדר קופה': 'Nonprofit — a provider under contract with a health fund',
  'ספק חיצוני בהסדר קופה (סוג הבעלות לא צוין)': 'External provider under contract with a health fund (ownership not stated)',
  'מרכז ממשלתי לבריאות הנפש (משרד הבריאות)': 'Government mental-health center (Ministry of Health)',
  'בית חולים ממשלתי': 'Government hospital',
  'בית חולים של כללית': 'Clalit hospital',
  'בית חולים ציבורי-מלכ"ר': 'Public nonprofit hospital',
  'בית חולים עירוני-ממשלתי': 'Municipal-government hospital',
  'בית חולים – הדסה': 'Hadassah hospital',
  'בית חולים מיסיון (מלכ"ר)': 'Mission hospital (nonprofit)',
  'לא צוין': 'Not stated',
  'בית חולים פרטי': 'Private hospital',
};

const TARGETS = {
  '': '',
  'ילדים ונוער': 'Children and youth',
  'מבוגרים': 'Adults',
  'ילדים ונוער, מבוגרים': 'Children and youth, adults',
  'מבוגרים, ילדים ונוער': 'Adults, children and youth',
  'טיפול יום נוער': 'Youth day treatment',
  'טיפול יום מבוגרים': 'Adult day treatment',
  'טיפול יום מבוגרים, מבוגרים': 'Adult day treatment, adults',
  'מבוגרים, ילדים ונוער, טיפול יום מבוגרים': 'Adults, children and youth, adult day treatment',
};

const AUDIENCE_HE = {
  '': '',
  'ילדים ונוער': 'ילדים ונוער',
  'מבוגרים': 'מבוגרים',
  'ילדים ונוער, מבוגרים': 'ילדים, נוער ומבוגרים',
  'מבוגרים, ילדים ונוער': 'מבוגרים, ילדים ונוער',
  'טיפול יום נוער': 'טיפול יום נוער',
  'טיפול יום מבוגרים': 'טיפול יום מבוגרים',
  'טיפול יום מבוגרים, מבוגרים': 'מבוגרים וטיפול יום',
  'מבוגרים, ילדים ונוער, טיפול יום מבוגרים': 'מבוגרים, ילדים ונוער, וטיפול יום',
};

const AUDIENCE_EN = {
  '': '',
  'ילדים ונוער': 'children and youth',
  'מבוגרים': 'adults',
  'ילדים ונוער, מבוגרים': 'children, youth, and adults',
  'מבוגרים, ילדים ונוער': 'adults, children, and youth',
  'טיפול יום נוער': 'youth day treatment',
  'טיפול יום מבוגרים': 'adult day treatment',
  'טיפול יום מבוגרים, מבוגרים': 'adults and adult day treatment',
  'מבוגרים, ילדים ונוער, טיפול יום מבוגרים': 'adults, children and youth, and adult day treatment',
};

const SVCS = {
  'מרפאה רב-צוותית לבריאות הנפש': 'Multidisciplinary mental health clinic',
  'טיפול יום פסיכיאטרי': 'Psychiatric day treatment',
  'אשפוז יום פסיכיאטרי': 'Psychiatric day hospitalization',
  'אשפוז פסיכיאטרי': 'Psychiatric hospitalization',
};

const FUNDS = {
  מאוחדת: { he: 'מאוחדת', en: 'Meuhedet' },
  כללית: { he: 'כללית', en: 'Clalit' },
  מכבי: { he: 'מכבי', en: 'Maccabi' },
  לאומית: { he: 'לאומית', en: 'Leumit' },
};

const CENTERS = [
  { test: /lev-hasharon/i, he: 'לב השרון', en: 'Lev Hasharon', home: 'נתניה' },
  { test: /psjer\.org\.il/i, he: 'המרכז הירושלמי לבריאות הנפש', en: 'Jerusalem Mental Health Center', home: 'ירושלים' },
  { test: /nefeshb7/i, he: 'המרכז לבריאות הנפש באר שבע', en: "Be'er Sheva Mental Health Center", home: 'באר שבע' },
  { test: /mental-health-center-beer-yaacov/i, he: 'באר יעקב', en: "Be'er Yaakov", home: 'באר יעקב' },
  { test: /mental-health-center-abarbanel/i, he: 'אברבנאל', en: 'Abarbanel', home: 'בת ים' },
  { test: /adult_psychiatric_ziv/i, he: 'זיו', en: 'Ziv', home: 'צפת' },
  { test: /wolfson/i, he: 'וולפסון', en: 'Wolfson', home: 'חולון' },
  { test: /sheba/i, he: 'שיבא', en: 'Sheba', home: 'תל השומר' },
  { test: /hadassah/i, he: 'הדסה', en: 'Hadassah', home: 'ירושלים' },
  { test: /mazorhealth/i, he: 'מזור', en: 'Mazor', home: 'עכו' },
  { test: /tiratcarmel/i, he: 'טירת הכרמל', en: 'Tirat Carmel', home: 'טירת הכרמל' },
  { test: /barzilai/i, he: 'ברזילי', en: 'Barzilai', home: 'אשקלון' },
  { test: /hymc\.org\.il|hfhosp\.org/i, he: 'הלל יפה', en: 'Hillel Yaffe', home: 'חדרה' },
  { test: /rambam\.org\.il/i, he: 'רמב"ם', en: 'Rambam', home: 'חיפה' },
  { test: /tasmc\.org\.il/i, he: 'איכילוב', en: 'Ichilov', home: 'תל אביב' },
  { test: /mymc\.co\.il/i, he: 'מאיר', en: 'Meir', home: 'כפר סבא' },
  { test: /herzoghospital/i, he: 'הרצוג', en: 'Herzog', home: 'ירושלים' },
  { test: /nazhosp\.com/i, he: 'המשפחה הקדושה', en: 'Holy Family Hospital', home: 'נצרת' },
  { test: /shamir\.org/i, he: 'שמיר', en: 'Shamir', home: 'באר יעקב' },
  { test: /shaar-menashe/i, he: 'שער מנשה', en: "Sha'ar Menashe", home: 'שער מנשה' },
  { test: /amcha\.org/i, he: 'עמך', en: 'AMCHA', home: '' },
  { test: /schneider\.org\.il/i, he: 'שניידר', en: 'Schneider', home: 'פתח תקוה' },
  { test: /gmc\.org\.il/i, he: 'המרכז הרפואי לגליל', en: 'Galilee Medical Center', home: 'נהריה' },
  { test: /poria\.org\.il/i, he: 'פוריה', en: 'Poria', home: 'טבריה' },
  { test: /saint-vincent/i, he: 'סנט וינסנט', en: 'Saint Vincent', home: 'נצרת' },
  { test: /szmc\.org\.il/i, he: 'שערי צדק', en: "Shaare Zedek", home: 'ירושלים' },
  { test: /alyn\.org\.il/i, he: 'אלין', en: 'ALYN', home: 'ירושלים' },
  { test: /bayit-cham/i, he: 'בית חם', en: 'Beit Cham', home: '' },
];

const INSTITUTIONS = [
  'בית חם', 'תפארת', 'ציפור הנפש', 'עמך', 'אגודה לבריאות', 'סורוקה', 'סורוק',
  'ברזילי', 'אברבנאל', 'ניצנים', 'שלוותה', 'שלוות', 'גהה', 'אסף הרופא',
  'מעייני', 'איכילוב', 'הדסה', 'רמב"ם', 'רמב״ם', 'שניידר', 'וולפסון', 'יוספטל',
  'שיבא', 'בלינסון', 'קפלן', 'פוריה', 'הלל יפה', 'לניאדו', 'בני ציון',
  'שערי צדק', 'מזור', 'שער מנשה', 'לב השרון', 'איתנים', 'כפר שאול', 'הרצוג',
  'אלין', 'הדקל', 'המשפחה הקדושה', 'סנט וינסנט', 'שמיר', 'שערי',
  'מרכז רפואי העמק', 'בית חולים העמק', 'העמק', 'המרכזי בעמק',
  'זיו', 'מזרע', 'בארי', 'טלביה', 'אילנית', 'לוינשטיין', 'מאיר',
  'רמת חן', 'האנגלי', 'לגליל המערבי', 'תלם', 'מרקם', 'גזאללה', 'מרכז לין', 'שיא',
];

const PHONE_KEYS = ['phone', 'phone2', 'phone3', 'phone4', 'phone5', 'phone6'];

function norm(s) {
  return String(s || '')
    .replace(/[״"׳']/g, '')
    .replace(/[־–—-]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim()
    .toLowerCase();
}

function hasInstitution(org) {
  const name = String(org || '');
  if (/דלית אל כרמל|טירת הכרמל|טירת כרמל/.test(name) && !/מרכז רפואי|בית חולים/.test(name)) {
    return INSTITUTIONS.some((token) => token !== 'העמק' && name.includes(token));
  }
  return INSTITUTIONS.some((token) => name.includes(token));
}

function isCityOnly(card) {
  return norm(card.org) !== '' && norm(card.org) === norm(card.region);
}

function isAudienceLabel(org) {
  return /^(ילדים ונוער|ילדים|מבוגרים|נוער)(\s|$)/.test(String(org || '').trim());
}

function readSqlString(sql, i) {
  if (sql[i] !== "'") throw new Error(`expected quote at ${i}`);
  let out = '';
  i += 1;
  while (i < sql.length) {
    if (sql[i] === "'" && sql[i + 1] === "'") {
      out += "'";
      i += 2;
      continue;
    }
    if (sql[i] === "'") return { value: out, end: i + 1 };
    out += sql[i];
    i += 1;
  }
  throw new Error('unterminated SQL string');
}

function loadCards() {
  const sql = fs.readFileSync(SRC, 'utf8');
  const cards = [];
  let idx = 0;
  while (true) {
    const at = sql.indexOf('INSERT INTO directory_card_edits', idx);
    if (at < 0) break;
    const values = sql.indexOf('VALUES', at);
    const open = sql.indexOf('(', values);
    let i = open + 1;
    while (/\s/.test(sql[i])) i += 1;
    const key = readSqlString(sql, i);
    i = key.end;
    while (sql[i] !== ',') i += 1;
    i += 1;
    while (/\s/.test(sql[i])) i += 1;
    const rowStart = i;
    while (/\d/.test(sql[i])) i += 1;
    const row = Number(sql.slice(rowStart, i));
    while (sql[i] !== "'") i += 1;
    const entry = readSqlString(sql, i);
    i = entry.end;
    while (sql[i] !== "'") i += 1;
    const fieldsRaw = readSqlString(sql, i);
    i = fieldsRaw.end;
    while (sql[i] !== "'") i += 1;
    const elig = readSqlString(sql, i);
    i = elig.end;
    while (i < sql.length && sql[i] !== "'" && sql[i] !== ')') i += 1;
    let sites = [];
    if (sql[i] === "'") {
      const parsed = readSqlString(sql, i);
      sites = JSON.parse(parsed.value);
      i = parsed.end;
    }
    idx = i;
    if (row < ROW_MIN || row > ROW_MAX) continue;
    const fields = JSON.parse(fieldsRaw.value);
    cards.push({
      row,
      cardKey: key.value,
      entryId: entry.value,
      fields,
      sites: Array.isArray(sites) ? sites : [],
    });
  }
  cards.sort((a, b) => a.row - b.row);
  return cards;
}

function hostFund(web) {
  const w = String(web || '');
  if (/meuhedet/i.test(w)) return 'מאוחדת';
  if (/maccabi/i.test(w)) return 'מכבי';
  if (/leumit/i.test(w)) return 'לאומית';
  if (/clalit/i.test(w)) return 'כללית';
  return '';
}

function costAllows(fund, cost) {
  const text = String(cost || '');
  if (/כל הקופות/.test(text)) return true;
  const named = [];
  if (text.includes('מאוחדת')) named.push('מאוחדת');
  if (text.includes('כללית')) named.push('כללית');
  if (text.includes('מכבי')) named.push('מכבי');
  if (text.includes('לאומית')) named.push('לאומית');
  if (!named.length) return false;
  return named.includes(fund);
}

function isYaffo(web) {
  return /yaffo-yaffo/i.test(String(web || ''));
}

function centerOf(web) {
  const w = String(web || '');
  if (!w || isYaffo(w)) return null;
  return CENTERS.find((c) => c.test.test(w)) || null;
}

function operatorOf(card) {
  if (card.row === 396) {
    const center = CENTERS.find((c) => /nefeshb7/.test(c.test.source));
    return { kind: 'center', ...center, id: `center:${center.he}` };
  }
  if (isYaffo(card.fields.web)) return null;
  const fund = hostFund(card.fields.web);
  if (fund && costAllows(fund, card.fields.cost)) {
    return { kind: 'fund', ...FUNDS[fund], id: `fund:${fund}`, home: '' };
  }
  const center = centerOf(card.fields.web);
  if (center) return { kind: 'center', ...center, id: `center:${center.he}` };
  return null;
}

function wantsRename(card) {
  if (card.row === 396) return true;
  if (isYaffo(card.fields.web)) return false;
  if (isCityOnly({ org: card.fields.org, region: card.fields.region })) return true;
  if (isAudienceLabel(card.fields.org) && !hasInstitution(card.fields.org)) return true;
  if (hasInstitution(card.fields.org)) return false;
  return true;
}

function cityEn(region) {
  const raw = String(region || '').trim();
  if (!raw) return '';
  if (CITIES[raw]) return CITIES[raw];
  const trimmed = raw.replace(/\s+\.$/, '').replace(/\.$/, '');
  if (CITIES[trimmed]) return CITIES[trimmed];
  return phraseEn(raw);
}

function samePlace(a, b) {
  if (!a || !b) return false;
  return norm(a) === norm(b) || norm(cityEn(a)) === norm(cityEn(b));
}

function containsPlace(name, place) {
  if (!name || !place) return false;
  return norm(name).includes(norm(place));
}

const CONS_OUT = /[bcdfghjklmnpqrstvwxz]$/i;

function transliterateCore(word) {
  const chars = [...word];
  let out = '';
  const push = (latin, vowelBefore) => {
    if (!latin) return;
    if (vowelBefore && out && CONS_OUT.test(out) && !/^[aeiou]/i.test(latin)) out += 'a';
    out += latin;
  };
  for (let i = 0; i < chars.length; i += 1) {
    const c = chars[i];
    const prev = chars[i - 1];
    const next = chars[i + 1];
    const start = i === 0;
    const end = i === chars.length - 1;
    const cons = (ch) => ch && /[בגדהוזחטיכלמנסעפצקרשתךםןףץ]/.test(ch);
    if (c === 'א') push(start || (next && cons(next)) ? 'a' : '', false);
    else if (c === 'ע') push(start || (prev && cons(prev)) ? 'a' : '', false);
    else if (c === 'ה') push(end ? 'a' : 'h', !end);
    else if (c === 'ו') {
      if (next === 'ו') {
        push('v', true);
        i += 1;
      } else if (!start && next && cons(next) && prev && cons(prev)) push('o', false);
      else if (start) push('v', true);
      else if (end) push('v', true);
      else push('o', false);
    } else if (c === 'י') {
      if (end || (prev && cons(prev) && next && cons(next))) push('i', false);
      else push('y', true);
    } else if (c === 'ב') push(start ? 'b' : 'v', true);
    else if (c === 'כ' || c === 'ך') push(start && c === 'כ' ? 'k' : 'kh', true);
    else if (c === 'פ') push(start ? 'p' : 'f', true);
    else if (c === 'ף') push('f', true);
    else if (c === 'ש') push('sh', true);
    else if (c === 'צ' || c === 'ץ') push('ts', true);
    else if (c === 'ח') push('ch', true);
    else if (c === 'ת') push('t', true);
    else if (c === 'ק') push('k', true);
    else if (c === 'ר') push('r', true);
    else if (c === 'ד') push('d', true);
    else if (c === 'ג') push('g', true);
    else if (c === 'ז') push('z', true);
    else if (c === 'ט') push('t', true);
    else if (c === 'ל') push('l', true);
    else if (c === 'מ' || c === 'ם') push('m', true);
    else if (c === 'נ' || c === 'ן') push('n', true);
    else if (c === 'ס') push('s', true);
    else push(c, false);
  }
  return out;
}

const HEB_NUM = {
  א: 'A', ב: 'B', ג: 'C', ד: 'D', ה: 'E', ו: 'F', ז: 'G', ח: 'H', ט: 'I', י: 'J',
  כ: 'K', ל: 'L', מ: 'M', נ: 'N', ס: 'O', ע: 'P', פ: 'Q', צ: 'R', ק: 'S', ר: 'T', ש: 'U', ת: 'V',
};

function latinNumber(text) {
  return String(text || '').replace(/(\d)\s*([א-ת])/g, (_, digit, letter) => digit + (HEB_NUM[letter] || ''));
}

function cap(s) {
  if (!s) return '';
  return s.charAt(0).toUpperCase() + s.slice(1);
}

function transliterateWord(word) {
  const clean = String(word || '').replace(/[״"׳']/g, '');
  if (!clean) return '';
  if (CITIES[clean]) return CITIES[clean];
  if (WORDS[clean]) return WORDS[clean];
  if (clean.startsWith('וה') && clean.length > 3) return `veHa${cap(transliterateCore(clean.slice(2)))}`;
  if (clean.startsWith('ה') && clean.length > 2) return `Ha${cap(transliterateCore(clean.slice(1)))}`;
  if (clean.startsWith('ו') && clean.length > 2 && WORDS[clean.slice(1)]) return `ve${cap(WORDS[clean.slice(1)])}`;
  if (clean.startsWith('ו') && clean.length > 2 && CITIES[clean.slice(1)]) return `ve${CITIES[clean.slice(1)]}`;
  let core = clean;
  if (core.startsWith('יהו') && core.length > 3) return `Yehu${transliterateCore(core.slice(3))}`;
  if (core.startsWith('יה') && core.length > 2) return `Ye${transliterateCore(core.slice(2))}`;
  return cap(transliterateCore(core));
}

const PHRASE_KEYS = Object.keys(PHRASES).sort((a, b) => b.length - a.length);

function escapeReg(text) {
  return String(text).replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function phraseEn(text) {
  let s = String(text || '').replace(/[\u0591-\u05C7]/g, '');
  if (!s) return '';
  for (const key of PHRASE_KEYS) {
    const re = new RegExp(`(?<![\\u0590-\\u05FF])${escapeReg(key)}(?![\\u0590-\\u05FF])`, 'g');
    s = s.replace(re, PHRASES[key]);
  }
  const cityKeys = Object.keys(CITIES).sort((a, b) => b.length - a.length);
  for (const key of cityKeys) {
    if (key.length < 2) continue;
    const re = new RegExp(`(?<![\\u0590-\\u05FF])${escapeReg(key)}(?![\\u0590-\\u05FF])`, 'g');
    s = s.replace(re, CITIES[key]);
  }
  s = s.replace(/[\u0590-\u05FF][\u0590-\u05FF״"׳'\-]*/g, (token) => {
    const parts = token.split('-');
    return parts.map((part) => transliterateWord(part)).join('-');
  });
  s = latinNumber(s);
  s = s.replace(/(^|[\s,(])([א-ת])(?=[\s,.)]|$)/g, (_, lead, letter) => lead + (HEB_NUM[letter] || letter));
  return s.replace(/\s+/g, ' ').replace(/\s+([,.;:])/g, '$1').trim();
}

function methodsEn(text) {
  return phraseEn(text).replace(/\s+/g, ' ').trim();
}

function addressEn(addr) {
  const raw = String(addr || '').trim();
  if (!raw) return '';
  const parts = raw.split(',').map((p) => p.trim()).filter(Boolean);
  return parts.map((part, index) => {
    const asCity = CITIES[part] || CITIES[part.replace(/\.$/, '')];
    if (asCity && (index === parts.length - 1 || CITIES[part])) return asCity;
    const po = part.match(/ת\.?\s*ד\.?\s*(\d+)/);
    if (po) return `P.O. Box ${po[1]}`;
    const floor = part.match(/קומה\s*(\d+|קרקע)/);
    if (floor) return floor[1] === 'קרקע' ? 'ground floor' : `floor ${floor[1]}`;
    const lead = part.match(/^(\d+[א-ת]?)\s+(.+)$/);
    if (lead) return `${latinNumber(lead[1])} ${phraseEn(lead[2])}`;
    const trail = part.match(/^(.*\D)\s+(\d+\s*[א-ת]?)$/);
    if (trail && /[\u0590-\u05FF]/.test(trail[1])) return `${latinNumber(trail[2].replace(/\s+/g, ''))} ${phraseEn(trail[1].trim())}`;
    return phraseEn(part);
  }).join(', ');
}

function translateNotes(notes) {
  let s = String(notes || '').replace(/\s+/g, ' ').trim();
  const chunks = [];
  const take = (re, repl) => {
    const m = s.match(re);
    if (!m) return false;
    chunks.push(typeof repl === 'function' ? repl(m) : repl);
    s = `${s.slice(0, m.index)} ${s.slice(m.index + m[0].length)}`.replace(/\s+/g, ' ').trim();
    return true;
  };
  let guard = 0;
  while (s && guard < 30) {
    guard += 1;
    if (take(/^סוג בעלות: ([^.]+)\.\s*/, (m) => `Ownership: ${OWN[m[1]] || phraseEn(m[1])}.`)) continue;
    if (take(/הרכב הצוות לפי הגדרת משרד הבריאות למרפאה רב-מקצועית, ולא נבדק במרפאה זו\.\s*/,
      'The team makeup follows the Ministry of Health definition of a multidisciplinary clinic, and it was not checked at this clinic.')) continue;
    if (take(/מקור: מאגר מרפאות בריאות הנפש של משרד הבריאות, עדכון 28\.12\.2025\./,
      'Source: Ministry of Health mental-health clinic registry, updated 28.12.2025.')) continue;
    if (take(/מקור: רשימת טיפול היום ואשפוז היום של משרד הבריאות, 2023\./,
      'Source: Ministry of Health day-treatment and day-hospitalization list, 2023.')) continue;
    if (take(/מקור: מאגר בתי החולים הפסיכיאטריים והמחלקות הפסיכיאטריות של משרד הבריאות\./,
      'Source: Ministry of Health registry of psychiatric hospitals and psychiatric departments.')) continue;
    if (take(/מפעיל: ([^.]+)\./, (m) => `Operator: ${phraseEn(m[1])}.`)) continue;
    if (take(/כתובת: (.+?)\.(?=\s|$)/, (m) => `Address: ${addressEn(m[1])}.`)) continue;
    if (take(/יש לבדוק מראש את מדיניות הקבלה מול המרכז\.?/,
      'Check the admission policy with the center beforehand.')) continue;
    if (take(/שלוחה (\d+)\.?/, (m) => `Extension ${m[1]}.`)) continue;
    if (take(/טלפון נוסף: ([^.]+)\.?/, (m) => `Additional phone: ${m[1]}.`)) continue;
    const marker = s.search(/מפעיל:|מקור:|כתובת:|יש לבדוק|שלוחה \d|טלפון נוסף:/);
    if (s.startsWith('שיטות טיפול:')) {
      const body = (marker < 0 ? s.slice('שיטות טיפול:'.length) : s.slice('שיטות טיפול:'.length, marker))
        .replace(/^[.\s]+|[.\s]+$/g, '');
      chunks.push(`Treatment methods: ${methodsEn(body)}.`);
      s = (marker < 0 ? '' : s.slice(marker)).trim();
      continue;
    }
    chunks.push(phraseEn(s));
    break;
  }
  return chunks.join(' ').replace(/\s+/g, ' ').trim();
}

function fundsPhrase(list) {
  if (list === 'כל הקופות') return 'members of all health funds';
  const parts = list.split(',').map((s) => s.trim()).filter(Boolean).map((name) => {
    if (name === 'מאוחדת') return 'Meuhedet';
    if (name === 'כללית') return 'Clalit';
    if (name === 'מכבי') return 'Maccabi';
    if (name === 'לאומית') return 'Leumit';
    return phraseEn(name);
  });
  let joined = parts[0] || '';
  if (parts.length === 2) joined = `${parts[0]} and ${parts[1]}`;
  else if (parts.length > 2) joined = `${parts.slice(0, -1).join(', ')}, and ${parts[parts.length - 1]}`;
  return `${joined} members`;
}

function costEn(cost) {
  const text = String(cost || '');
  if (!text) return '';
  if (text === 'סל הבריאות – באישור מראש של הקופה (טופס 17); השתתפות עצמית רבעונית') {
    return 'Health basket — with prior approval from the health fund (form 17); quarterly co-payment';
  }
  if (text === 'ציבורי – באמצעות קופות החולים (סל הבריאות)') {
    return 'Public — through the health funds (health basket)';
  }
  if (text === 'לא צוין (בית חולים פרטי)') return 'Not stated (private hospital)';
  const m = text.match(/^סל הבריאות – למבוטחי (.+) \(בהפניה מהקופה; השתתפות עצמית רבעונית\)$/);
  if (m) return `Health basket — ${fundsPhrase(m[1])} (referral from the fund; quarterly co-payment)`;
  return phraseEn(text);
}

function parsePhoneChunk(raw) {
  let s = String(raw || '').trim();
  if (!s) return [];
  let trailing = '';
  const sent = s.match(/^(\d[\d\-\s/]*)\.\s*([א-ת].+)$/);
  if (sent) {
    s = sent[1].trim();
    trailing = sent[2].trim().replace(/\.$/, '');
  }
  const extWords = s.match(/^(.*?)\s+שלוחה\s+(\S+)\s*$/);
  if (extWords) {
    s = extWords[1].trim();
    const note = `שלוחה ${extWords[2].replace(/\.$/, '')}`;
    trailing = trailing ? `${trailing}. ${note}` : note;
  }
  const two = s.match(/^(\*?[\d][\d\- ]{2,})\s+(\*?[\d][\d\- ]{2,})$/);
  const parts = two ? [two[1], two[2]] : [s];
  return parts.map((part, index) => {
    let extra = index === 0 ? trailing : '';
    let phone = part.trim();
    const slash = phone.match(/^(\*?[\d][\d\-]*)\/(\d+)$/);
    if (slash) {
      phone = slash[1];
      const note = `שלוחה ${slash[2]}`;
      extra = extra ? `${extra}. ${note}` : note;
    }
    phone = phone.replace(/\s*-\s*/g, '-').replace(/^(\d{2,3})\s+(\d+)$/, '$1-$2').replace(/\s+/g, '');
    return { phone, extra };
  }).filter((item) => item.phone);
}

function cleanPhones(fields) {
  const slots = PHONE_KEYS.map((key) => parsePhoneChunk(fields[key] || ''));
  const flat = [];
  slots.forEach((list) => list.forEach((item) => flat.push(item)));
  while (flat.length < PHONE_KEYS.length) flat.push(null);
  const extras = [];
  const patch = {};
  PHONE_KEYS.forEach((key, index) => {
    const item = flat[index];
    const labelKey = index === 0 ? 'phoneLabel' : `phoneLabel${index + 1}`;
    const showKey = index === 0 ? 'phoneShowNumber' : `phoneShowNumber${index + 1}`;
    const original = String(fields[key] || '');
    if (!item) {
      if (original) patch[key] = '';
      return;
    }
    if (item.phone !== original) patch[key] = item.phone;
    patch[labelKey] = 'טלפון';
    patch[showKey] = false;
    if (item.extra) extras.push(item.extra.replace(/\.$/, ''));
  });
  return { patch, extras };
}

function appendNotes(notes, extras) {
  let next = String(notes || '').trim();
  extras.forEach((extra) => {
    const sentence = extra.endsWith('.') ? extra : `${extra}.`;
    if (!next.includes(extra)) next = `${next}${next ? ' ' : ''}${sentence}`;
  });
  return next;
}

function buildTitles(prepared) {
  const groups = new Map();
  prepared.forEach((card) => {
    if (!card.rename || !card.operator || card.row === 396) return;
    const key = `${card.operator.id}|${norm(card.fields.region)}`;
    if (!groups.has(key)) groups.set(key, []);
    groups.get(key).push(card);
  });
  groups.forEach((group) => {
    const counts = new Map();
    group.forEach((card) => {
      const audience = card.fields.target || '';
      counts.set(audience, (counts.get(audience) || 0) + 1);
    });
    const distinct = [...counts.keys()];
    let plain = null;
    if (distinct.length > 1) {
      const max = Math.max(...counts.values());
      const leaders = distinct.filter((audience) => counts.get(audience) === max);
      if (leaders.length === 1 && max > 1) plain = leaders[0];
    }
    group.forEach((card) => {
      const audience = card.fields.target || '';
      const withAudience = distinct.length > 1 && audience !== plain && audience !== '';
      card.heOrg = titleHe(card, withAudience);
      card.enOrg = titleEn(card, withAudience);
    });
  });
  prepared.forEach((card) => {
    if (card.heOrg) return;
    if (card.row === 396 && card.operator) {
      card.heOrg = `${card.operator.he} — פסיכוגריאטריה`;
      card.enOrg = `${card.operator.en} — psychogeriatrics`;
      card.rename = true;
      return;
    }
    if (card.rename && card.operator) {
      card.heOrg = titleHe(card, false);
      card.enOrg = titleEn(card, false);
      return;
    }
    card.heOrg = card.fields.org;
    card.enOrg = phraseEn(card.fields.org);
    card.rename = false;
  });
}

function titleHe(card, withAudience) {
  const city = String(card.fields.region || '').trim();
  const audience = AUDIENCE_HE[card.fields.target] || card.fields.target || '';
  const op = card.operator;
  if (op.kind === 'fund') {
    if (withAudience && audience) return city ? `${op.he} — ${audience}, ${city}` : `${op.he} — ${audience}`;
    return city ? `${op.he}, ${city}` : op.he;
  }
  const away = city && !samePlace(city, op.home) && !containsPlace(op.he, city);
  if (withAudience && audience) {
    if (away) return `${op.he} — ${audience}, ${city}`;
    return `${op.he} — ${audience}`;
  }
  if (away) return `${op.he}, ${city}`;
  if (city && !containsPlace(op.he, city)) return `${op.he}, ${city}`;
  return op.he;
}

function titleEn(card, withAudience) {
  const city = cityEn(card.fields.region);
  const audience = AUDIENCE_EN[card.fields.target] || phraseEn(card.fields.target || '');
  const op = card.operator;
  if (op.kind === 'fund') {
    if (withAudience && audience) return city ? `${op.en} — ${audience}, ${city}` : `${op.en} — ${audience}`;
    return city ? `${op.en}, ${city}` : op.en;
  }
  const away = card.fields.region && !samePlace(card.fields.region, op.home) && !containsPlace(op.he, card.fields.region);
  if (withAudience && audience) {
    if (away) return `${op.en} — ${audience}, ${city}`;
    return `${op.en} — ${audience}`;
  }
  if (away) return `${op.en}, ${city}`;
  if (city && !containsPlace(op.en, city) && !containsPlace(op.he, card.fields.region)) return `${op.en}, ${city}`;
  return op.en;
}

function sqlJson(value) {
  return `'${JSON.stringify(value).replace(/'/g, "''")}'`;
}

function sqlText(value) {
  return `'${String(value).replace(/'/g, "''")}'`;
}

function englishBlock(card, notes) {
  const en = {};
  en.org = card.enOrg;
  if (SVCS[card.fields.svc]) en.svc = SVCS[card.fields.svc];
  else if (card.fields.svc) en.svc = phraseEn(card.fields.svc);
  if (card.fields.target) en.target = TARGETS[card.fields.target] || phraseEn(card.fields.target);
  if (card.fields.region) en.region = cityEn(card.fields.region);
  if (card.fields.cost) en.cost = costEn(card.fields.cost);
  if (card.fields.specialty) en.specialty = phraseEn(card.fields.specialty);
  if (notes) en.notes = translateNotes(notes);
  PHONE_KEYS.forEach((key, index) => {
    const labelKey = index === 0 ? 'phoneLabel' : `phoneLabel${index + 1}`;
    const phone = card.phonePatch[key] != null ? card.phonePatch[key] : card.fields[key];
    if (phone) en[labelKey] = 'Phone';
  });
  if (card.sites.length) {
    en.siteLabels = card.sites.map((site) => {
      if (card.rename && (norm(site.label) === norm(card.fields.org) || norm(site.label) === norm(card.fields.region))) {
        return card.enOrg;
      }
      if (CITIES[site.label]) return CITIES[site.label];
      return phraseEn(site.label || card.enOrg);
    });
    en.siteAddresses = card.sites.map((site) => addressEn(site.address || ''));
  }
  return en;
}

function reasonLeft(card) {
  if (isYaffo(card.fields.web)) return 'yaffo-yaffo is not treated as the operator';
  const fund = hostFund(card.fields.web);
  if (fund && !costAllows(fund, card.fields.cost)) {
    return `website says ${fund}, payer line does not`;
  }
  if (!card.fields.web) return 'no website and no single fund on the payer line';
  if (fund && !costAllows(fund, card.fields.cost)) return 'payer line does not match the website';
  return 'no fund or named center on the website';
}

function main() {
  const cards = loadCards();
  if (cards.length !== 397) throw new Error(`expected 397 cards, parsed ${cards.length}`);
  const prepared = cards.map((card) => {
    const rename = wantsRename(card);
    const operator = rename ? operatorOf(card) : null;
    return { ...card, rename: Boolean(rename && operator), operator, heOrg: '', enOrg: '' };
  });
  // A card that wanted a new name but has no operator stays as filed.
  prepared.forEach((card) => {
    if (wantsRename(card) && !card.operator) card.rename = false;
  });
  buildTitles(prepared);

  const yaffo = [];
  const unknown = [];
  prepared.forEach((card) => {
    if (!wantsRename(card) && hasInstitution(card.fields.org) && !isYaffo(card.fields.web)) return;
    if (card.rename) return;
    if (!wantsRename(card) && !isYaffo(card.fields.web)) return;
    const line = `${card.row} ${card.fields.org} | ${card.fields.region} | ${reasonLeft(card)}`;
    if (isYaffo(card.fields.web)) yaffo.push(line);
    else unknown.push(line);
  });

  let renamed = 0;
  let labeled = 0;
  const lines = [];
  lines.push('-- Migration 128 (9 Nov 2026)');
  lines.push('-- Public clinics, day treatment, and psychiatric hospitals from migration 102.');
  lines.push('-- A title that was a street, a neighborhood, a city, or an age group is now the');
  lines.push('-- health fund or the mental-health center, and the city. The street stays on the map.');
  lines.push('-- Phone buttons say טלפון and no longer print the number. English wording is in');
  lines.push('-- translations.en. An English website address already stored is left in place.');
  lines.push('-- Register as [ ] in database_updates_master.sql; do not mark [x].');
  lines.push('--');
  lines.push(`-- Left as filed because gov.il/.../yaffo-yaffo is not proof of the operator (${yaffo.length}):`);
  yaffo.forEach((line) => lines.push(`-- ${line}`));
  lines.push(`-- Left as filed because the operator could not be read from the website and the payer line (${unknown.length}):`);
  unknown.forEach((line) => lines.push(`-- ${line}`));
  lines.push('');
  lines.push('BEGIN;');
  lines.push('');

  const cardKeys = [];
  prepared.forEach((card) => {
    const { patch: phonePatch, extras } = cleanPhones(card.fields);
    card.phonePatch = phonePatch;
    const notes = appendNotes(card.fields.notes, extras);
    const publicPatch = { ...phonePatch };
    if (notes !== String(card.fields.notes || '')) publicPatch.notes = notes;
    if (card.heOrg !== card.fields.org) {
      publicPatch.org = card.heOrg;
      renamed += 1;
    }
    PHONE_KEYS.forEach((key, index) => {
      const showKey = index === 0 ? 'phoneShowNumber' : `phoneShowNumber${index + 1}`;
      if (publicPatch[showKey] === false) labeled += 1;
    });
    const en = englishBlock(card, notes);
    cardKeys.push(card.cardKey);
    lines.push('UPDATE directory_card_edits');
    lines.push('SET public_fields = public_fields || ' + sqlJson(publicPatch) + '::jsonb,');
    lines.push('    translations = jsonb_set(');
    lines.push("      COALESCE(translations, '{}'::jsonb),");
    lines.push("      '{en}',");
    lines.push("      COALESCE(translations->'en', '{}'::jsonb) || " + sqlJson(en) + '::jsonb,');
    lines.push('      true');
    lines.push('    ),');
    lines.push('    public_edited_at = now(),');
    lines.push('    updated_at = now()');
    lines.push(`WHERE card_key = ${sqlText(card.cardKey)};`);
    lines.push('');
    if (card.heOrg !== card.fields.org) {
      lines.push('UPDATE directory_entries');
      lines.push(`SET display_name = ${sqlText(card.heOrg)}`);
      lines.push(`WHERE entry_id = ${sqlText(card.entryId)};`);
      lines.push('');
    }
  });

  lines.push('INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)');
  lines.push('VALUES (');
  lines.push("  '2026-11-09-public-clinic-names',");
  lines.push("  DATE '2026-11-09',");
  lines.push(`  ${sqlText('שמות הקופה או המרכז על הכרטיסים הציבוריים')},`);
  lines.push(`  ${sqlText('במרפאות, בטיפול היום ובאשפוז מרשימות משרד הבריאות, כרטיס שהשם שלו היה רחוב, שכונה, עיר או קבוצת גיל נקרא עכשיו על שם הקופה או המרכז לבריאות הנפש, והעיר. הרחוב נשאר במפה. כפתור הטלפון אומר «טלפון» בלי המספר. באנגלית הנוסח של הכרטיסים האלה באנגלית.')},`);
  lines.push("  'cards',");
  lines.push(`  ARRAY[${cardKeys.map(sqlText).join(', ')}]::text[],`);
  lines.push("  '{}',");
  lines.push("  '128_mh_public_names_english.sql'");
  lines.push(')');
  lines.push('ON CONFLICT (entry_key) DO NOTHING;');
  lines.push('');
  lines.push('COMMIT;');
  lines.push('');

  const byRow = new Map(prepared.map((card) => [card.row, card]));
  const expect = {
    569: 'מאוחדת, נתניה',
    574: 'מאוחדת, נתניה',
    576: 'מאוחדת — ילדים ונוער, נתניה',
    570: 'לב השרון — ילדים ונוער',
  };
  Object.entries(expect).forEach(([row, title]) => {
    const card = byRow.get(Number(row));
    if (!card || card.heOrg !== title) {
      throw new Error(`row ${row} title ${card && card.heOrg} !== ${title}`);
    }
  });
  const kept = byRow.get(575);
  if (!kept || kept.heOrg !== kept.fields.org) throw new Error('row 575 should keep its name');
  if (!/Tsipor/.test(kept.enOrg)) throw new Error(`row 575 English org: ${kept.enOrg}`);

  ['569', '570', '574', '576'].forEach((row) => {
    const card = byRow.get(Number(row));
    const { patch } = cleanPhones(card.fields);
    if (patch.phoneLabel !== 'טלפון' || patch.phoneShowNumber !== false) {
      throw new Error(`row ${row} phone label missing`);
    }
    const en = englishBlock(card, card.fields.notes);
    if (/[\u0590-\u05FF]/.test(JSON.stringify(en))) {
      throw new Error(`row ${row} English still has Hebrew: ${JSON.stringify(en)}`);
    }
  });

  let hebrewLeft = 0;
  prepared.forEach((card) => {
    const notes = appendNotes(card.fields.notes, cleanPhones(card.fields).extras);
    const en = englishBlock(card, notes);
    const blob = JSON.stringify(en);
    if (/[\u0590-\u05FF]/.test(blob)) hebrewLeft += 1;
  });

  fs.writeFileSync(OUT, lines.join('\n'));
  const netanya = prepared.filter((card) => card.fields.region === 'נתניה' || /נתניה/.test(card.fields.region || ''));
  console.log(JSON.stringify({
    cards: prepared.length,
    renamed,
    phoneButtons: labeled,
    yaffo: yaffo.length,
    unknown: unknown.length,
    hebrewLeft,
    bytes: fs.statSync(OUT).size,
  }, null, 2));
  console.log('--- Netanya ---');
  netanya.forEach((card) => {
    console.log(`${card.row} ${card.fields.org} => ${card.heOrg} | ${card.enOrg}`);
  });
  console.log('--- unknown ---');
  unknown.forEach((line) => console.log(line));
  console.log('--- yaffo ---');
  yaffo.forEach((line) => console.log(line));
  if (hebrewLeft) {
    prepared.forEach((card) => {
      const notes = appendNotes(card.fields.notes, cleanPhones(card.fields).extras);
      const en = englishBlock(card, notes);
      const blob = JSON.stringify(en);
      if (/[\u0590-\u05FF]/.test(blob)) {
        const bits = blob.match(/[\u0590-\u05FF][^"\\]*/g) || [];
        console.log('HE', card.row, bits.slice(0, 6).join(' | '));
      }
    });
    throw new Error(`${hebrewLeft} English blocks still contain Hebrew`);
  }
}

main();
