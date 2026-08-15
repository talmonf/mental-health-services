-- Migration 020 (Aug 2026)
-- directory_entries: national NGOs from מפה לנפש that were missing (rows 256–267)
-- entry_id slugs match generate_directory_entries_sql.js / mhSlugify.

BEGIN;

INSERT INTO directory_entries (
  entry_id,
  display_name,
  description,
  primary_category,
  category_keys
) VALUES
  (
    'עמותת_על_ם_256',
    'עמותת על"ם',
    'איתור, ליווי וטיפול בנוער וצעירים במצבי סיכון — בקהילה, ברחוב ובמרחב הדיגיטלי',
    'youth',
    ARRAY['youth', 'helplines']::text[]
  ),
  (
    'עמותת_אל_סם_257',
    'עמותת אל-סם',
    'ייעוץ וטיפול לנוער וצעירים עד גיל 24 ולהוריהם בנושאי סמים, אלכוהול והתמכרויות',
    'addictions',
    ARRAY['addictions', 'helplines', 'youth']::text[]
  ),
  (
    'כנפיים_של_קרמבו_258',
    'כנפיים של קרמבו',
    'תנועת נוער משלבת לילדים עם ובלי צרכים מיוחדים — שילוב חברתי מלא ושוויוני',
    'youth',
    ARRAY['youth']::text[]
  ),
  (
    'איגי_ארגון_הנוער_הגאה_259',
    'איגי — ארגון הנוער הגאה',
    'תנועת נוער וצעירים להט"ב — קבוצות חברתיות ותמיכה בעשרות יישובים',
    'youth',
    ARRAY['youth', 'populations']::text[]
  ),
  (
    'חוש_ן_חינוך_ושינוי_260',
    'חוש"ן — חינוך ושינוי',
    'הסברה וסדנאות בבתי ספר ובמסגרות נוער למניעת להט"בופוביה ולתמיכה בנוער להט"ב',
    'populations',
    ARRAY['populations']::text[]
  ),
  (
    'בשביל_החיים_261',
    'בשביל החיים',
    'מניעת אובדנות ותמיכה במשפחות שכולות לאחר התאבדות או מוות פתאומי',
    'families',
    ARRAY['families', 'helplines']::text[]
  ),
  (
    'עמותת_עוצמה_262',
    'עמותת עוצמה',
    'פורום ארצי של בני משפחה של מתמודדי נפש — תמיכה, מיצוי זכויות, סנגור והפחתת סטיגמה',
    'families',
    ARRAY['families']::text[]
  ),
  (
    'המסע_שלנו_263',
    'המסע שלנו',
    'פורום משפחות המתמודדות עם הפרעות אכילה — קבוצות תמיכה, מידע על זכויות וסנגור',
    'families',
    ARRAY['families', 'nutrition']::text[]
  ),
  (
    'iaed_העמותה_הישראלית_להפרעות_אכילה_264',
    'IAED — העמותה הישראלית להפרעות אכילה',
    'מידע לציבור ולמשפחות, מפת מסגרות טיפול ואינדקס מטפלים בהפרעות אכילה',
    'nutrition',
    ARRAY['nutrition']::text[]
  ),
  (
    'אלו_ט_265',
    'אלו"ט',
    'ליווי ילדים ובוגרים על הרצף האוטיסטי ומשפחותיהם — זכויות, מרכזי משפחה ותמיכה',
    'populations',
    ARRAY['populations', 'families']::text[]
  ),
  (
    'עמותת_מיט_ב_266',
    'עמותת מיט"ב',
    'מרכז רב-תחומי לייעוץ, טיפול וחינוך בקהילה — ילדים, מתבגרים ומבוגרים; כולל יחידת קשב',
    'youth',
    ARRAY['youth', 'local']::text[]
  ),
  (
    'מוקד_105_המטה_הלאומי_להגנה_על_ילדים_ברשת_267',
    'מוקד 105 — המטה הלאומי להגנה על ילדים ברשת',
    'דיווח ומענה 24/7 על פגיעות, בריונות, סחיטה ופשיעה נגד ילדים ונוער במרחב המקוון',
    'emergency',
    ARRAY['emergency', 'helplines', 'youth']::text[]
  )
ON CONFLICT (entry_id) DO UPDATE SET
  display_name = EXCLUDED.display_name,
  description = EXCLUDED.description,
  primary_category = EXCLUDED.primary_category,
  category_keys = EXCLUDED.category_keys;

COMMIT;
