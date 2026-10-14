-- Migration 058 (14 Oct 2026)
-- directory_card_edits: notes that named another card by its row number.
-- The name becomes a link that opens that card in its section.
-- Touches only the notes field, so other admin edits on the card stay.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = jsonb_set(public_fields, '{notes}', to_jsonb(replace(
      public_fields->>'notes',
      'גם מופיע בכרטיס זכויות שיקום (שורה 12).',
      'גם מופיע בכרטיס [זכויות שיקום](https://nefesh-il.org/rights?entry=12&section=rights).'
    ))),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '218|||טיפולים נפשיים מסובסדים ע"י משרד הביטחון (חרבות ברזל)'
  AND position('שורה 12' IN COALESCE(public_fields->>'notes', '')) > 0;

UPDATE directory_card_edits
SET public_fields = jsonb_set(public_fields, '{notes}', to_jsonb(replace(
      public_fields->>'notes',
      'מאגר עו״ס יתד באתר Gov.il — כרטיס 288.',
      'מאגר [עו״ס יתד](https://nefesh-il.org/support?entry=288&section=youth) באתר Gov.il.'
    ))),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '227|||שירותים חברתיים לצעירים 18-27'
  AND position('כרטיס 288' IN COALESCE(public_fields->>'notes', '')) > 0;

UPDATE directory_card_edits
SET public_fields = jsonb_set(public_fields, '{notes}', to_jsonb(replace(
      public_fields->>'notes',
      'התוכנית יתד (שורה 227)',
      '[התוכנית יתד](https://nefesh-il.org/support?entry=227&section=youth)'
    ))),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '288|||עובד/ת סוציאלי/ת בתוכנית יתד — ליווי צעירים וצעירות (18–25/26) במצבי חיים מורכבים'
  AND position('שורה 227' IN COALESCE(public_fields->>'notes', '')) > 0;

UPDATE directory_card_edits
SET public_fields = jsonb_set(public_fields, '{notes}', to_jsonb(replace(
      public_fields->>'notes',
      'מסגרות הדיור (בית משלך) בכרטיס נפרד (שורה 289).',
      'מסגרות הדיור ([בית משלך](https://nefesh-il.org/support?entry=289&section=youth)) בכרטיס נפרד.'
    ))),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '290|||קליניקה לטיפול בנשים ובנערות — פסיכותרפיה, פגיעות מיניות, הפרעות אכילה, דיכאון אחרי לידה ואלימות ביחסים'
  AND position('שורה 289' IN COALESCE(public_fields->>'notes', '')) > 0;

UPDATE directory_card_edits
SET public_fields = jsonb_set(public_fields, '{notes}', to_jsonb(replace(
      public_fields->>'notes',
      'מחלקת לצידך בכרטיס נפרד (שורה 293).',
      'מחלקת [לצידך](https://nefesh-il.org/treatment?entry=293&section=hospitalization) בכרטיס נפרד.'
    ))),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '292|||מחלקה פתוחה לאשפוז בטראומה מורכבת — כולל נפגעי 7 באוקטובר ובני משפחותיהם'
  AND position('שורה 293' IN COALESCE(public_fields->>'notes', '')) > 0;

UPDATE directory_card_edits
SET public_fields = jsonb_set(public_fields, '{notes}', to_jsonb(replace(
      public_fields->>'notes',
      'מחלקת בדרכי בכרטיס נפרד (שורה 292).',
      'מחלקת [בדרכי](https://nefesh-il.org/treatment?entry=292&section=hospitalization) בכרטיס נפרד.'
    ))),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '293|||מחלקה פתוחה לנשים עם פוסט־טראומה מורכבת והפרעות אכילה'
  AND position('שורה 292' IN COALESCE(public_fields->>'notes', '')) > 0;

UPDATE directory_card_edits
SET public_fields = jsonb_set(public_fields, '{notes}', to_jsonb(replace(
      public_fields->>'notes',
      'קו הייעוץ ידידי נפש בכרטיס נפרד (שורה 26). בלב ובנפש בכרטיס נפרד (שורה 68).',
      'קו הייעוץ [ידידי נפש](https://nefesh-il.org/emergency?entry=26&section=helplines) בכרטיס נפרד. [בלב ובנפש](https://nefesh-il.org/support?entry=68&section=families) בכרטיס נפרד.'
    ))),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '305|||שיקום תעסוקתי, תעסוקה נתמכת, פנאי ומרכזי משפחות למתמודדי נפש מגיל 18'
  AND position('שורה 26' IN COALESCE(public_fields->>'notes', '')) > 0;

COMMIT;
