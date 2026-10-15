-- Migration 059 (15 Oct 2026)
-- directory_card_edits: האגף לבריאות הנפש (עזר מציון), row 305.
-- Family counseling center, reported by a staff member: Ministry of Health subsidy,
-- 12 free sessions. Two lines by area. No street address, so no map pin.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'phone2', '073-3956128',
      'phoneLabel2', 'ייעוץ משפחות · בני ברק, אלעד, קריית ספר',
      'phoneShowNumber2', true,
      'phone3', '073-3952205',
      'phoneLabel3', 'ייעוץ משפחות · ירושלים, ביתר, בית שמש',
      'phoneShowNumber3', true,
      'region', rtrim(COALESCE(public_fields->>'region', ''))
        || '. ייעוץ משפחות: בני ברק, אלעד וקריית ספר; ירושלים, ביתר ובית שמש',
      'notes', 'מרכז ייעוץ למשפחות, מסובסד על ידי משרד הבריאות: 12 פגישות חינם. '
        || COALESCE(public_fields->>'notes', '')
    ),
    eligibility = jsonb_set(
      eligibility,
      '{internal_notes}',
      to_jsonb(
        rtrim(COALESCE(eligibility->>'internal_notes', ''))
        || E'\n\n15.10.2026: עובדת בעזר מציון מסרה שמרכז הייעוץ למשפחות מסובסד על ידי משרד הבריאות, 12 פגישות חינם. בני ברק, אלעד וקריית ספר: 073-3956128. ירושלים, ביתר ובית שמש: 073-3952205. לא נמסרו כתובות רחוב, ולכן לא נוספה סיכה במפה. קו השיקום 073-3952222 נשאר.'
      )
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key = '305|||שיקום תעסוקתי, תעסוקה נתמכת, פנאי ומרכזי משפחות למתמודדי נפש מגיל 18'
  AND COALESCE(public_fields->>'phone2', '') = '';

COMMIT;
