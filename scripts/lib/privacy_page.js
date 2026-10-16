// Body of /privacy. Every statement here describes what the code actually does
// (api/analytics.ts, middleware.ts, scripts/030_retention.sql, lib/auth.ts, api/care,
// lib/google-contacts.ts). Change the text when the behaviour changes.

const OPERATOR_EN = 'Talmon Friedlander';
const CONTACT_EMAIL = 'talmonf@gmail.com';
const EFFECTIVE = '16.10.2026';
const EFFECTIVE_ISO = '2026-10-16';

const mail = `<a href="mailto:${CONTACT_EMAIL}">${CONTACT_EMAIL}</a>`;
const ltr = (s) => `<bdi dir="ltr">${s}</bdi>`;

const HE = `
<h1>מדיניות פרטיות</h1>
<p class="lede">בתוקף מ־<time datetime="${EFFECTIVE_ISO}">${EFFECTIVE}</time>. הדף מסביר איזה מידע האתר nefesh-il.org («מדריך נפש») אוסף, למה, למי הוא מועבר, כמה זמן הוא נשמר ואיך אפשר לעיין בו, לתקן אותו או למחוק אותו.</p>

<h2>מי מפעיל את האתר</h2>
<p>האתר מופעל על ידי ${ltr(OPERATOR_EN)}, באופן פרטי. לכל שאלה או בקשה בנוגע למידע אישי: ${mail}.</p>

<h2>גלישה במדריך, בלי חשבון</h2>
<p>אפשר להשתמש במדריך בלי להירשם ובלי למסור שם או פרטי קשר. בזמן הגלישה נאסף מידע סטטיסטי:</p>
<ul>
  <li><strong>סטטיסטיקה של האתר עצמו:</strong> אילו דפים נפתחו, על אילו כפתורים וקישורים לחצו, ומה חיפשו במדריך. נרשמים גם סוג הדפדפן, גודל המסך, האתר שממנו הגעתם והמדינה (לפי נתוני שרת האחסון). כדי לזהות ביקורים חוזרים נשמר בדפדפן מזהה אקראי (ב־localStorage וב־sessionStorage, לא בעוגייה). המזהה לא כולל שם, כתובת דוא"ל או כתובת IP.</li>
  <li><strong>חיפושים:</strong> טקסט החיפוש מקוצר ל־80 תווים, וכתובות דוא"ל ורצפים ארוכים של ספרות מוסרים ממנו לפני שהוא נשמר. אחרי 90 יום הטקסט נמחק, ונשארת רק ספירה חודשית של חיפושים שחזרו לפחות חמש פעמים.</li>
  <li><strong>יומן בקשות:</strong> על מדגם של כ־10% מהביקורים נרשמים כתובת הדף, סוג הדפדפן, האתר המפנה והמדינה. כתובת IP לא נשמרת. הרשומות נמחקות אחרי 90 יום.</li>
  <li><strong>Google Analytics:</strong> בדף הראשי של המדריך פועל Google Analytics, שמציב עוגיות של Google ומודד שימוש באתר. Google מעבדת את המידע לפי <a href="https://policies.google.com/privacy?hl=iw" target="_blank" rel="noopener noreferrer">מדיניות הפרטיות שלה</a>. אפשר לחסום אותו בהגדרות הדפדפן או בתוסף <a href="https://tools.google.com/dlpage/gaoptout?hl=iw" target="_blank" rel="noopener noreferrer">Google Analytics Opt-out</a>.</li>
</ul>
<p>המידע הזה משמש רק כדי להבין אילו שירותים אנשים מחפשים ולשפר את המדריך. אנחנו לא מוכרים מידע ולא משתמשים בו לפרסום.</p>

<h2>חשבון באתר</h2>
<p>ההרשמה היא רשות. מי שנרשם מוסר כתובת דוא"ל וסיסמה. הסיסמה נשמרת מוצפנת (bcrypt) ואי אפשר לשחזר אותה ממה שנשמר. אפשר להירשם גם דרך Google, ואז נשמרים רק כתובת הדוא"ל והמזהה שלכם ב־Google, בלי שם ובלי תמונה.</p>
<p>בפרופיל אפשר למלא, לפי בחירתכם: מדינה ועיר, מקצוע, ארגון, תפקיד, מספר רישיון, מגדר ואיך הגעתם לאתר. נשמרים גם העדפת הדיוור שבחרתם, ומועדי ההרשמה והכניסה האחרונה.</p>
<p><strong>עוגיות:</strong> אחרי כניסה לחשבון האתר מציב עוגיית התחברות (עד שעתיים), ועוגיות זמניות לאבטחת הכניסה עם Google (10 דקות), לאיפוס סיסמה (15 דקות) ולכניסה ל«התיק שלי» (30 דקות). אלה עוגיות הכרחיות להפעלת החשבון, לא עוגיות מעקב.</p>
<p><strong>דוא"ל:</strong> האתר שולח אישור הרשמה, איפוס סיסמה, קודי כניסה ל«התיק שלי», ועדכונים על שינויים במדריך רק למי שבחר לקבל אותם. אפשר להפסיק את העדכונים בכל עת מהפרופיל או מהקישור שבמייל.</p>
<p><strong>שאלות:</strong> מי שמחובר יכול לשלוח שאלה. השאלה נשמרת יחד עם החשבון, ומנהלי האתר מקבלים אותה עם כתובת הדוא"ל של השולח כדי לענות.</p>

<h2>«התיק שלי»</h2>
<p>«התיק שלי» הוא מקום אישי לרכז בו מידע על הטיפול: אבחנות, תרופות, בדיקות, מסמכים, אנשי קשר, זכויות והערות. זה מידע רגיש, ולכן:</p>
<ul>
  <li>הוא נשמר רק כשאתם מזינים אותו, ומשמש רק כדי להציג לכם אותו. הוא לא משמש לסטטיסטיקה, למחקר או לפרסום.</li>
  <li>מסמכים שמעלים מוצפנים (AES-256-GCM) לפני שהם נשמרים באחסון של Amazon S3.</li>
  <li>הכניסה לתיק דורשת קוד חד־פעמי שנשלח לדוא"ל שלכם.</li>
  <li>רק אתם רואים את התיק, וכל מי שבחרתם לשתף: בהזמנה לפי כתובת דוא"ל, או בקישור שיתוף שתוקפו פג אחרי יום, שבוע או 30 יום. אפשר לבטל שיתוף בכל עת.</li>
  <li>אפשר להוריד את כל התיק כקובץ ZIP, למחוק את התיק בלבד, או למחוק את החשבון כולו.</li>
</ul>
<p>«התיק שלי» אינו תיק רפואי רשמי ואינו מיועד למצבי חירום. במצב חירום פנו ל־101 או לער"ן ב־1201.</p>

<h2>למי המידע מועבר</h2>
<p>אנחנו לא מוכרים ולא משכירים מידע אישי. המידע עובר רק לספקים שהאתר צריך כדי לפעול:</p>
<ul>
  <li><strong>Vercel:</strong> אחסון האתר והשרתים.</li>
  <li><strong>ספק מסד הנתונים</strong> שבו נשמרים החשבונות, «התיק שלי» והסטטיסטיקה.</li>
  <li><strong>Amazon Web Services (S3):</strong> אחסון המסמכים המוצפנים של «התיק שלי».</li>
  <li><strong>Resend:</strong> שליחת הודעות הדוא"ל של האתר.</li>
  <li><strong>Google:</strong> Google Analytics, כניסה עם חשבון Google, וגופני Google Fonts.</li>
  <li><strong>unpkg ו־cdnjs:</strong> ספריות קוד וסמלים שהדפים טוענים. כמו כל אתר, הם מקבלים את כתובת ה־IP של הדפדפן כשהוא טוען מהם קובץ.</li>
</ul>
<p>חלק מהספקים האלה מאחסנים מידע מחוץ לישראל. מידע יימסר לרשויות רק אם החוק מחייב זאת.</p>

<h2>Google Contacts (מנהלי האתר בלבד)</h2>
<p>מנהל האתר יכול לחבר את אנשי הקשר שלו ב־Google כדי לתעד מול מי אומת כל כרטיס במדריך. האתר מבקש הרשאת קריאה בלבד (contacts.readonly), שומר רק שם, דוא"ל, טלפון וארגון של אנשי הקשר שנבחרו, ומציג אותם רק למנהלי האתר. המידע לא מוצג באתר, לא משמש לשום מטרה אחרת ולא מועבר לאחר. אפשר לנתק את החיבור בכל עת מדף האימות בניהול, או מ<a href="https://myaccount.google.com/permissions" target="_blank" rel="noopener noreferrer">הגדרות חשבון Google</a>.</p>
<p>השימוש של האתר במידע שמתקבל מממשקי Google, והעברתו, כפופים ל<a href="https://developers.google.com/terms/api-services-user-data-policy" target="_blank" rel="noopener noreferrer">מדיניות נתוני המשתמש של שירותי ה־API של Google</a>, כולל דרישות השימוש המוגבל (Limited Use).</p>

<h2>כמה זמן המידע נשמר</h2>
<ul>
  <li>טקסט חיפושים ויומן הבקשות: 90 יום.</li>
  <li>שאר נתוני הסטטיסטיקה: נשמרים כנתונים סטטיסטיים, בלי שם, דוא"ל או כתובת IP.</li>
  <li>חשבון, פרופיל ו«התיק שלי»: עד שתמחקו אותם. מחיקת החשבון מוחקת גם את התיק ואת המסמכים שהועלו.</li>
  <li>קישורי אישור ואיפוס בדוא"ל: בין 10 דקות ל־90 יום, לפי סוג הקישור.</li>
</ul>

<h2>הזכויות שלכם</h2>
<p>לפי חוק הגנת הפרטיות אתם זכאים לעיין במידע ששמור עליכם, לבקש לתקן אותו ולבקש למחוק אותו. את רוב הפעולות אפשר לעשות לבד: עריכת הפרופיל, ייצוא «התיק שלי» ומחיקת החשבון. לכל בקשה אחרת כתבו ל־${mail}.</p>

<h2>שינויים במדיניות</h2>
<p>אם המדיניות תשתנה, הנוסח המעודכן יפורסם בדף הזה עם תאריך חדש. שינוי מהותי יפורסם גם בעדכוני האתר.</p>
`;

const EN = `
<section lang="en" dir="ltr" class="ltr-block">
<h2>Privacy Policy (English)</h2>
<p>Effective <time datetime="${EFFECTIVE_ISO}">16 October 2026</time>. This page explains what nefesh-il.org ("Nefesh") collects, why, who receives it, how long it is kept, and how to access, correct or delete it.</p>

<h3>Who runs the site</h3>
<p>The site is operated by ${OPERATOR_EN}, as a private individual. For any question or request about personal data: ${mail}.</p>

<h3>Browsing without an account</h3>
<ul>
  <li><strong>Site statistics:</strong> pages opened, buttons and links clicked, and searches made in the directory, with browser type, screen size, referring site and country (from the hosting provider). A random identifier is kept in browser storage (localStorage and sessionStorage, not a cookie) to recognise return visits. It contains no name, email or IP address.</li>
  <li><strong>Searches:</strong> search text is cut to 80 characters and email addresses and long digit runs are removed before it is stored. After 90 days the text is deleted; only a monthly count of searches made at least five times is kept.</li>
  <li><strong>Request log:</strong> for a sample of about 10% of visits, the page path, browser type, referring site and country are recorded. IP addresses are not stored. Records are deleted after 90 days.</li>
  <li><strong>Google Analytics</strong> runs on the main directory page and sets Google cookies. Google processes this data under <a href="https://policies.google.com/privacy" target="_blank" rel="noopener noreferrer">its privacy policy</a>. You can block it in your browser or with the <a href="https://tools.google.com/dlpage/gaoptout" target="_blank" rel="noopener noreferrer">Google Analytics Opt-out add-on</a>.</li>
</ul>
<p>This information is used only to understand which services people look for and to improve the directory. We do not sell data or use it for advertising.</p>

<h3>Accounts</h3>
<p>Registering is optional. An account stores your email address and a password hash (bcrypt). If you sign in with Google, only your email address and Google account ID are stored, not your name or picture. Optional profile fields: country and city, profession, organisation, title, licence number, gender and how you found the site; also your email preference and sign-up and last-access dates.</p>
<p><strong>Cookies:</strong> after you sign in, the site sets a session cookie (up to 2 hours) and short-lived security cookies for Google sign-in (10 minutes), password reset (15 minutes) and access to "My file" (30 minutes). They are strictly necessary for the account to work and are not used for tracking.</p>
<p><strong>Email:</strong> sign-up confirmation, password reset, one-time codes for "My file", and site update emails only if you opt in. You can stop updates at any time from your profile or the link in the email.</p>
<p><strong>Questions:</strong> signed-in users can send a question. It is stored with the account, and the site's administrators receive it with the sender's email address so they can reply.</p>

<h3>"My file" (התיק שלי)</h3>
<p>"My file" is a personal space for care information: diagnoses, medications, tests, documents, contacts, rights and notes. Because this is sensitive health information:</p>
<ul>
  <li>It is stored only when you enter it and is used only to show it to you. It is not used for statistics, research or advertising.</li>
  <li>Uploaded documents are encrypted (AES-256-GCM) before they are stored in Amazon S3.</li>
  <li>Opening the file requires a one-time code sent to your email.</li>
  <li>Only you can see it, plus anyone you choose to share it with, by email invitation or by a share link that expires after a day, a week or 30 days. You can revoke sharing at any time.</li>
  <li>You can download the whole file as a ZIP, delete the file only, or delete your entire account.</li>
</ul>
<p>"My file" is not an official medical record and is not for emergencies. In an emergency call 101, or ERAN on 1201.</p>

<h3>Who receives data</h3>
<p>We do not sell or rent personal data. It goes only to the providers the site needs in order to run: Vercel (hosting), the database provider (accounts, "My file" and statistics), Amazon Web Services S3 (encrypted documents), Resend (email delivery), Google (Analytics, Google sign-in, Google Fonts), and unpkg and cdnjs (code libraries and icons, which like any web server receive your browser's IP address when it loads a file). Some of these providers store data outside Israel. Data is disclosed to authorities only where the law requires it.</p>

<h3>Google user data</h3>
<p>Google sign-in provides only your email address and Google account ID. Separately, the site administrator can connect his own Google Contacts, with read-only access (contacts.readonly), to record whom each directory card was verified with. Only the name, email, phone and organisation of selected contacts are stored; they are shown only to the site's administrators, never published, not used for any other purpose and not transferred to anyone. The connection can be removed at any time from the admin verification page or in <a href="https://myaccount.google.com/permissions" target="_blank" rel="noopener noreferrer">Google Account settings</a>.</p>
<p>nefesh-il.org's use and transfer to any other app of information received from Google APIs will adhere to the <a href="https://developers.google.com/terms/api-services-user-data-policy" target="_blank" rel="noopener noreferrer">Google API Services User Data Policy</a>, including the Limited Use requirements.</p>

<h3>Retention</h3>
<ul>
  <li>Search text and the request log: 90 days.</li>
  <li>Other statistics: kept as statistics, without name, email or IP address.</li>
  <li>Account, profile and "My file": until you delete them. Deleting your account also deletes your file and uploaded documents.</li>
  <li>Email confirmation and reset links: 10 minutes to 90 days depending on the link.</li>
</ul>

<h3>Your rights</h3>
<p>Under Israel's Protection of Privacy Law you may access the information held about you, ask for it to be corrected, and ask for it to be deleted. Most of this you can do yourself: edit your profile, export "My file", or delete your account. For anything else, write to ${mail}.</p>

<h3>Changes</h3>
<p>If this policy changes, the updated text will be published on this page with a new date. Material changes will also be announced in the site updates.</p>
</section>
`;

module.exports = { HE, EN, EFFECTIVE, EFFECTIVE_ISO, CONTACT_EMAIL };
