-- Migration 135 (13 Nov 2026)
-- Alma (row 782): the cost line, in the site owner's words.
-- Hebrew: פרטי, במימון מלא למבוטחות מאוחדת ומוכרות ע״י משרד הבטחון
-- English follows that sentence.
-- Funding marks: private stays. The old health-fund note "הסדר עם מאוחדת"
-- is cleared, and the health-fund mark is not "full", because full funding
-- is Meuhedet only and that detail stays on the cost line.
-- Ministry of Defense is added as full funding.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'cost', 'פרטי, במימון מלא למבוטחות מאוחדת ומוכרות ע״י משרד הבטחון'
    ),
    translations = jsonb_set(
      COALESCE(translations, '{}'::jsonb),
      '{en}',
      COALESCE(translations->'en', '{}'::jsonb) || jsonb_build_object(
        'cost', 'Private, fully funded for women insured by Meuhedet and for women recognized by the Ministry of Defense'
      ),
      true
    ),
    indicators = jsonb_set(
      COALESCE(indicators, '{}'::jsonb),
      '{funding}',
      '[{"channel":"private","terms":""},{"channel":"hmo","terms":""},{"channel":"mod","terms":"full"}]'::jsonb
    ),
    eligibility = jsonb_set(
      COALESCE(eligibility, '{}'::jsonb),
      '{internal_notes}',
      to_jsonb(
        CASE
          WHEN COALESCE(eligibility->>'internal_notes', '') LIKE '%במימון מלא למבוטחות מאוחדת%'
          THEN rtrim(eligibility->>'internal_notes')
          ELSE rtrim(COALESCE(eligibility->>'internal_notes', ''))
            || E'\n\n13.11.2026, בעל האתר: שורת העלות היא «פרטי, במימון מלא למבוטחות מאוחדת ומוכרות ע״י משרד הבטחון». סימון המימון: נשאר בתשלום וקופת חולים, בלי «הסדר עם מאוחדת». נוסף משרד הביטחון במימון מלא. קופות החולים לא סומנו כמימון מלא, כי המימון המלא הוא למאוחדת, וזה כתוב בשורת העלות.'
        END
      )
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '782|||בית מאזן לנשים עם פוסט־טראומה מורכבת והפרעת אכילה';

COMMIT;
