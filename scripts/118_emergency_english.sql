-- Migration 118 (7 Nov 2026)
-- English wording for the cards on Emergency & Crisis Support.
-- Hebrew stays in public_fields. A key inside translations.en replaces that field while the site is in English.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"IDF Mental Health Directorate","svc":"Immediate mental-health help","target":"All service members","region":"Nationwide","cost":"Free","notes":"Run by the IDF Mental Health Directorate, through the Kol Halev hotline: *6690, extension 4. Available 24/7 for conscripts and reservists, and staffed by mental-health officers. In an urgent case the call is passed to the duty officer; otherwise the caller is referred to the unit''s mental-health officer for follow-up."}'::jsonb,
  true
)
WHERE card_key = '10|||קבלת סיוע נפשי מיידי';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"\"Nefesh Achat Israel\"\n(Rehabilitation Department, Ministry of Defense)","svc":"Line for initial mental-health support","target":"Disabled veterans of the IDF and the security forces, people who have applied for recognition, people who served in the IDF, the police, the Prison Service, or the security units and are struggling because of that service, and their families","region":"Nationwide","cost":"Free","notes":"The Rehabilitation Department''s support line, available 24/7 including holidays. The line is answered by professionals and volunteers from [NATAL](https://nefesh-il.org/support?entry=21&section=helplines). You can call anonymously, with no approvals and no paperwork. In a mental-health crisis the line can send an intervention team to the home, only with the caller''s consent."}'::jsonb,
  true
)
WHERE card_key = '11|||קו המעניק תמיכה נפשית ראשונית';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"B''Nefesh Bri''a — Ministry of Health","svc":"Help and referral lines","languages":"Hebrew, English, Russian, and Arabic"}'::jsonb,
  true
)
WHERE card_key = '13|||קווי סיוע והכוונה';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"National Insurance Institute","svc":"List of treatment hotlines and resilience centers","target":"Wounded people and bereaved families (victims of hostilities), and people with anxiety related to the security situation","cost":"Free","notes":"Resilience centers for the Iron Swords war. Emergency line for the wounded and bereaved families: Sun–Thu 8:00–17:00. For any other subject: National Insurance hotline *6050. See also [Resilience centers](https://nefesh-il.org/treatment?entry=30&section=therapists).","phoneLabel":"Emergency line for victims of terrorism"}'::jsonb,
  true
)
WHERE card_key = '14|||רשימת מוקדי הטיפול ומרכזי החוסן';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"\"Kol Lekulam\" hotline — Ministry of Education","svc":"Emotional and social support line for parents and students","target":"Students, parents, and education staff","region":"Nationwide","notes":"A Ministry of Education hotline, staffed by professionals from the psychological-counseling service. Emotional and social support in distress, social rejection, and ostracism. Open Sun–Thu 8:00–20:00, Fri 8:00–14:00. An anonymous request can also be opened on an online form."}'::jsonb,
  true
)
WHERE card_key = '15|||מוקד סיוע רגשי-חברתי להורים ולתלמידים';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"ERAN (Emotional First Aid)","svc":"Help and referral line","target":"The general public, at any age","region":"Nationwide","notes":"1201 — general line, 24/7. *2201 — for conscripts, career soldiers, reservists, and their families, 24/7. WhatsApp: 052-8451201. Also by chat on the website, email, and SMS. The call is anonymous.","whatsappLabel":"WhatsApp","phoneLabel":"General","phoneLabel2":"Soldiers, reservists, and their families"}'::jsonb,
  true
)
WHERE card_key = '20|||קו סיוע והכוונה';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"NATAL (Victims of National Trauma)","svc":"Mental-health and vocational support for people traumatized by war and terrorism","target":"People traumatized by war or terrorism: civilians, discharged soldiers, and their families","region":"Nationwide","cost":"Free (helpline)","notes":"NATAL''s helpline is available 24/7. The old number 1-800-363-363 still appears in official sources, and it belongs to NATAL. NATAL also answers the [Nefesh Achat](https://nefesh-il.org/support?entry=11&section=emergency) line of the Rehabilitation Department. Short individual therapy is also available, up to 12 sessions at no charge."}'::jsonb,
  true
)
WHERE card_key = '21|||תמיכה נפשית ותעסוקתית לנפגעי טראומה ממלחמה וטרור';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"SAHAR (Assistance and Listening Online)","svc":"Help and referral line","cost":"Free","notes":"Anonymous chat on the website or WhatsApp, 24/7, with volunteers supervised by mental-health professionals."}'::jsonb,
  true
)
WHERE card_key = '22|||קו סיוע והכוונה';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"Metivta (Torah-based family counseling center)","svc":"Help lines\nTreatment center\nand more","region":"Nationwide","notes":"Metivta offers mental and emotional treatment and counseling adapted for the religious and Haredi public. Distinct from METIV (the psychotrauma center, 02-5952240 — the Iron Swords booklet). Here you will find immediate help lines, professional information, an experts'' forum, and Metivta''s treatment center, which matches a therapist by criteria adapted for the religious and Haredi public.","siteLabels":["Jerusalem"],"siteAddresses":["Metivta, Jerusalem"]}'::jsonb,
  true
)
WHERE card_key = '24|||מוקדי סיוע
מרכז טיפול
ועוד';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"CALL Lanefesh hotline (coalition of religious organizations for mental health)","svc":"Support and a listening ear for family members of people living with mental illness","target":"Family members of people living with mental illness","notes":"Hotline volunteers offer support and a listening ear to family members. Hours: Sun–Thu 12:00–24:00, Fri 8:00–14:00, Saturday night 20:00–24:00. Also includes WhatsApp support groups for families of patients."}'::jsonb,
  true
)
WHERE card_key = '25|||תמיכה ואוזן קשבת לבני משפחה למתמודדי נפש';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"Yedidei Nefesh (Ezer Mizion)","svc":"Advice and support line — Sun–Thu, 10:00–13:00 and 16:00–22:00","target":"Anyone who needs immediate mental-health help, at any age","notes":"Support, advice, guidance, and help in times of mental distress. A discreet line staffed by mental-health professionals; you can call anonymously. During a national emergency or crisis a 24/6 emergency line opens: 1-800-808-100.","phoneLabel2":"Emergency line (during a national crisis)"}'::jsonb,
  true
)
WHERE card_key = '26|||קו ייעוץ ותמיכה - בימים א-ה בשעות 10:00-13:00 ו-16:00-22:00';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"Resilience centers","svc":"List of resilience centers around the country","target":"People with anxiety or distress related to the security situation","region":"Nationwide","cost":"Free","notes":"The first contact is *5486, which refers you to a resilience center by home address. Someone with no resilience center in their area is treated at the national resilience center. The national center is open Sun–Thu 08:00–20:00, and 24/7 in an emergency. In the north you can call directly: Hebrew 04-6900603, Arabic 04-7702649, Russian 04-7702650, English 04-7702651. See also [National Insurance Institute](https://nefesh-il.org/emergency?entry=14&section=helplines).","phoneLabel":"National therapeutic resilience center"}'::jsonb,
  true
)
WHERE card_key = '30|||רשימת מרכזי חוסן ברחבי הארץ';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"Rehabilitation Department, Ministry of Defense","svc":"Safe house for immediate care — an alternative to hospitalization","target":"Disabled IDF veterans recognized for post-trauma, or people in the process of recognition for a mental injury, who are in a mental-health crisis that needs an emergency assessment, a temporary alternative to hospitalization, or supervision","region":"Nationwide","cost":"Free","notes":"The safe houses are an immediate, short-term alternative to hospitalization for people with post-trauma during a mental and personal crisis. The houses are inside hospitals, open 24/7, and a stay can last up to 10 days, at no charge. You can go straight to the hospital emergency room, without a referral from the department. Not suitable for high-risk states (active suicidality, active psychosis). Jerusalem: 02-6551303 extension 2815 or 050-3682799. Tel Hashomer: 052-6669512. Be''er Yaakov (Merhavim): 08-9258271. See also [\"Nefesh Achat Israel\" (Rehabilitation Department, Ministry of Defense)](https://nefesh-il.org/emergency?entry=11&section=emergency).","phoneLabel":"Hotline","phoneLabel2":"Be''er Sheva","phoneLabel3":"Jerusalem","phoneLabel4":"Tirat Carmel","phoneLabel5":"Tel Hashomer","siteLabels":["Safe house, Be''er Sheva","Safe house, Jerusalem (Kfar Shaul)","Safe house, Tel Hashomer"],"siteAddresses":["2 HaTzadik MiYerushalayim, Be''er Sheva","101 Rafael Katzenelbogen, Jerusalem","Sheba Medical Center, Tel Hashomer, Ramat Gan"]}'::jsonb,
  true
)
WHERE card_key = '39|||בית בטוח לטיפול מיידי - חלופת אשפוז';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"Sharan Home Medical Care","svc":"Crisis team (an alternative to the emergency room)","cost":"Leumit and Meuhedet","notes":"Crisis intervention in the patient''s home","phoneLabel":"Sharan hotline"}'::jsonb,
  true
)
WHERE card_key = '40|||צוות משבר (חלופה לחדר מיון)';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"Beit Cham","svc":"Information, advice, and support\nTreatment centers\nRehabilitation centers","languages":"Hebrew, English","notes":"Beit Cham was founded to give people facing mental-health challenges the best support it can.","phone":"General: 1599-510-550","siteLabels":["Bnei Brak"],"siteAddresses":["Beit Cham, Bnei Brak"]}'::jsonb,
  true
)
WHERE card_key = '60|||מידע, ייעוץ ותמיכה
מרכזי טיפול
מרכזי שיקום';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"Beit Cham","svc":"Information, advice, and support","target":"People in mental distress, for a period or at a particular moment","notes":"A discreet response from mental-health professionals. A line for men, \"Ozen Kashevet\" (a listening ear), and a line for women, \"Milelev El Lev\" (from heart to heart).","phoneLabel":"Kashuvim hotline"}'::jsonb,
  true
)
WHERE card_key = '61|||מידע, ייעוץ ותמיכה';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"Headspace","svc":"Support for teens and young adults","target":"Teens and young adults aged 10–25","region":"Bat Yam, Jerusalem, Kiryat Shmona, Netivot, Ashdod, Be''er Sheva, the Krayot, Tel Aviv-Yafo, and online","cost":"No direct charge (at some centers, with a health-fund commitment, form 17)","languages":"Hebrew, English","notes":"For teens and young adults aged 10–25. The professional team helps with difficult periods through focused emotional support, at no charge. No forms or referral are required. Headspace is not an emergency hotline.","phoneLabel":"National hotline, Sun–Thu 9:00–17:00","siteLabels":["Headspace Bat Yam","Headspace Netivot"],"siteAddresses":["29 Rothschild, floor 3, Bat Yam","18 Sderot Yerushalayim, floor 1, Netivot"]}'::jsonb,
  true
)
WHERE card_key = '63|||תמיכה לנוער וצעירים';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"notes":"Crisis support team reachable day or night; helps families navigate welfare, mental health and legal systems. US toll-free: 1-855-928-4437. See also [Avnei Chein](https://nefesh-il.org/emergency?entry=77&section=emergency)."}'::jsonb,
  true
)
WHERE card_key = '76|||Crisis Support, Family Support, Family & Sibling Therapy, Legal Support, Mentors and Volunteers, Network of Professionals';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"notes":"English-language list of emergency mental health resources, compiled by Avnei Chein from public and social-media postings. Avnei Chein states the listings have not been vetted or verified. See also [Avnei Chein](https://nefesh-il.org/emergency?entry=76&section=helplines)."}'::jsonb,
  true
)
WHERE card_key = '77|||Israel''s Emergency Mental Health Resources During War - Comprehensive list of mental health resources';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"Rescue app","svc":"A free app that gives mental-health first aid and immediate support during an anxiety attack, and stays with you until you gradually return to routine.","cost":"Free","languages":"Hebrew, English","diseases":"Anxiety","notes":"The app is not a substitute for professional advice or treatment."}'::jsonb,
  true
)
WHERE card_key = '101|||אפליקציה חינמית המספקת עזרה ראשונה נפשית ותמיכה מיידית בזמן התקף חרדה, ומלווה את המשתמש עד חזרה הדרגתית לשגרה.';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"svc":"An interactive app for building a daily practice plan and tracking it over time.","notes":"Helps you put material into practice with exercises, reminders, and tools for sticking with it."}'::jsonb,
  true
)
WHERE card_key = '102|||אפליקציה אינטראקטיבית לבניית תוכניות תרגול יומי ומעקב לאורך זמן.';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"The PTSD Guide","svc":"An app and digital guide for coping with PTSD, from the Rehabilitation Department (Ministry of Defense).","target":"People coping with post-trauma","languages":"Hebrew","notes":"The app does not replace a diagnosis or professional treatment. You can use it for self-help or as part of treatment. See also [Rehabilitation Department, Ministry of Defense](https://nefesh-il.org/information?entry=12&section=portals)."}'::jsonb,
  true
)
WHERE card_key = '103|||אפליקציה/מדריך דיגיטלי להתמודדות עם PTSD, מטעם אגף השיקום (משרד הביטחון).';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"Association of Rape Crisis Centers","svc":"National lines of the umbrella organization for the crisis centers","target":"People who have been sexually assaulted, and their families","region":"Nationwide","notes":"Help for Arab society: 04-6566813, and an Arabic chat at chatwavo.org. See also [Tair — the crisis center for people who have been sexually assaulted](https://nefesh-il.org/treatment?entry=201&section=trauma).","whatsappLabel":"WhatsApp help · Kolmila","addLabel":"Anonymous chat · Kolmila","phoneLabel":"Women''s line","phoneLabel2":"Men''s line","phoneLabel3":"Women · help for religious society","phoneLabel4":"Men · help for religious society"}'::jsonb,
  true
)
WHERE card_key = '200|||קווי המענה הארציים של ארגון הגג למרכזי הסיוע';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"METIV (Israel Center for Psychotrauma)","svc":"Nationwide long-term trauma treatment at no charge","target":"Discharged soldiers and reservists (not conscripts) with post-trauma from military service","region":"Nationwide","cost":"Free","notes":"The no-charge treatment is part of a clinical study (somatic experiencing or prolonged exposure) and is offered across the country. METIV''s adult clinic in Jerusalem (02-644-9666) charges a fee, unless another body is funding it. Distinct from [Metivta](https://nefesh-il.org/support?entry=24&section=helplines) (*2837).","tags":"Iron Swords","phoneLabel":"WhatsApp — treatment at no charge","siteLabels":["METIV — Israel Center for Psychotrauma"],"siteAddresses":["Givat Shaul, Herzog Medical Center, Jerusalem"]}'::jsonb,
  true
)
WHERE card_key = '210|||טיפול ארצי ללא עלות לטווח ארוך בטראומה';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"AMCHA","svc":"No-charge treatment sessions in the north (in person or online)","region":"North","cost":"Free","notes":"Nahariya: 04-6665566 · Haifa: 04-8375649. See also [AMCHA — the Israeli center for mental and social support of Holocaust survivors and the second generation](https://nefesh-il.org/rights?entry=70&section=rehabilitation).","tags":"Iron Swords","phoneLabel":"Krayot","siteLabels":["AMCHA Kiryat Motzkin","AMCHA Nahariya"],"siteAddresses":["8 Yoni Netanyahu, Kiryat Motzkin","18 Lochamei HaGetaot, Nahariya"]}'::jsonb,
  true
)
WHERE card_key = '212|||טיפוליים מפגשים ללא עלות בצפון (פרונטלי או מקוון)';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"Operation Hakshev","svc":"Mental-health first aid for people affected by the Iron Swords war — up to 10 sessions","target":"Reservists and their partners in distress because of the war","region":"Nationwide","cost":"70 NIS per session","notes":"The project may have ended: the website does not load and no information was found from 2025 onward. Check before you contact them.","tags":"Iron Swords"}'::jsonb,
  true
)
WHERE card_key = '213|||עזרה ראשונה נפשית לנפגעי חרבות ברזל — עד 10 מפגשים';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"Ministry of Welfare — Addiction Services","svc":"Advice and referral — social and security situation","region":"Nationwide","notes":"Additional phones: 02-5085814 · 02-5085850","tags":"Iron Swords","phoneLabel":"Main"}'::jsonb,
  true
)
WHERE card_key = '231|||ייעוץ והפניה — חברתי-ביטחוני';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"Hotline 118 (Ministry of Welfare)","svc":"Information, help, and referral — 24/7","target":"Anyone who needs information and help on welfare: children and youth at risk, people affected by domestic violence, older adults, people with disabilities, and families in difficulty","region":"Nationwide","cost":"Free","languages":"Hebrew, Arabic, Amharic, Russian, English, French","notes":"Open 24/7 all year, except Yom Kippur. You can also call 077-9208560, or send a text (a quiet request) to 050-2270118. Men affected by domestic violence: 1218.","tags":"Iron Swords","phoneLabel":"Dial","phoneLabel2":"Phone"}'::jsonb,
  true
)
WHERE card_key = '236|||מידע, סיוע והכוונה — 24/7';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"Mental-health support lines — health funds (Iron Swords)","svc":"3 therapy calls by phone at no charge","target":"Health-fund members in mental distress","region":"Nationwide","cost":"Free","notes":"Meuhedet *3833 · Leumit *507 (on-call line 24/7). Maccabi: from age 14, 3 calls twice a year, with no referral. Leumit: from age 18, a return call within 24 hours. See also [Telem](https://nefesh-il.org/treatment?entry=203&section=trauma), [Clalit](https://nefesh-il.org/treatment?entry=28&section=hmo), [Maccabi](https://nefesh-il.org/treatment?entry=29&section=hmo), [Meuhedet](https://nefesh-il.org/support?entry=80&section=populations), [Leumit](https://nefesh-il.org/treatment?entry=81&section=therapists).","tags":"Iron Swords","phoneLabel":"Clalit (Sun–Thu 7:00–20:00, Fri 7:00–13:00)","phoneLabel2":"Leumit (through Telem)","phoneLabel3":"Maccabi (Sun–Thu 8:00–16:00)"}'::jsonb,
  true
)
WHERE card_key = '243|||3 שיחות טיפוליות מקוונות ללא עלות';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"ELEM","svc":"Finding, accompanying, and treating youth and young adults at risk — in the community, on the street, and online","target":"Youth and young adults at risk","region":"Nationwide","notes":"Anonymous chat: Sun–Thu 19:00–24:00. Headquarters: 35 HaYarkon, Bnei Brak.","whatsappLabel":"ELEM Digital · WhatsApp","addLabel":"ELEM Digital (chat)","phoneLabel":"Headquarters","siteLabels":["Headquarters, Bnei Brak"],"siteAddresses":["35 HaYarkon, Bnei Brak"]}'::jsonb,
  true
)
WHERE card_key = '256|||איתור, ליווי וטיפול בנוער וצעירים במצבי סיכון — בקהילה, ברחוב ובמרחב הדיגיטלי';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"Al-Sam","svc":"Counseling and treatment for youth and young adults up to age 24, and for their parents, on drugs, alcohol, and addictions","target":"Youth, young adults, and parents","region":"Nationwide","cost":"Subsidized according to need","specialty":"Addictions","notes":"14 counseling and treatment branches around the country","phoneLabel":"National advice line","phoneLabel2":"Head office"}'::jsonb,
  true
)
WHERE card_key = '257|||ייעוץ וטיפול לנוער וצעירים עד גיל 24 ולהוריהם בנושאי סמים, אלכוהול והתמכרויות';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"Bishvil Hachaim","svc":"Suicide prevention and support for families bereaved by suicide or sudden death","target":"Families bereaved by suicide, a road accident, or a homicide; education and prevention in the community","region":"Nationwide","notes":"The website is not an emergency hotline — in immediate distress call 1201 or 101. Assistance centers in the center and the south, on behalf of the Ministry of Welfare. See also [ERAN (Emotional First Aid)](https://nefesh-il.org/emergency?entry=20&section=emergency).","phoneLabel":"Support / WhatsApp","phoneLabel2":"Coordinator"}'::jsonb,
  true
)
WHERE card_key = '261|||מניעת אובדנות ותמיכה במשפחות שכולות לאחר התאבדות או מוות פתאומי';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"Hotline 105 — National Headquarters for Child Online Protection","svc":"24/7 reporting and response for harm, bullying, extortion, and crime against children and youth online","target":"Children, youth, parents, and education staff","region":"Nationwide","cost":"Free","languages":"Hebrew, Arabic, English","notes":"A joint civilian and police response in Hebrew, Arabic, and English. You can also reach them 24/7 on WhatsApp at 052-1210105 and on an online form.","whatsappLabel":"WhatsApp 24/7","phoneLabel":"Dial"}'::jsonb,
  true
)
WHERE card_key = '267|||דיווח ומענה 24/7 על פגיעות, בריונות, סחיטה ופשיעה נגד ילדים ונוער במרחב המקוון';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"Iron Swords","svc":"Psychosocial responses booklet — a collected guide for the Iron Swords war","target":"Service members, reservists, families, youth, victims of terrorism and the Nova festival, and others","region":"Nationwide","cost":"Free","notes":"Last updated: June 2024. The booklet may be updated; some details may have changed.","addLabel":"Download the booklet (PDF)","tags":"Iron Swords"}'::jsonb,
  true
)
WHERE card_key = '209|||חוברת מענים פסיכוסוציאליים — מדריך מרוכז למלחמת חרבות ברזל';

UPDATE directory_card_edits
SET translations = jsonb_set(
  COALESCE(translations, '{}'::jsonb),
  '{en}',
  '{"org":"Rehabilitation Department, Ministry of Defense","svc":"Matan crisis-intervention team","target":"Disabled IDF veterans, and people in the process of recognition","region":"Nationwide","notes":"A mental-health team that reaches the home within two hours, 24/7, nationwide. It is sent after a call to [Nefesh Achat](https://nefesh-il.org/emergency?entry=11&section=emergency) and an assessment, or through the rehabilitation social worker. A one-time response, not ongoing treatment.","phoneLabel":"Nefesh Achat"}'::jsonb,
  true
)
WHERE card_key = '758|||צוות התערבות מתן לשעת משבר';

COMMIT;
