-- 075_glossary_link_suggestions_alternatives.sql (2026-10-16)
-- Glossary-card link suggestions for the term "alternatives" (חלופות אשפוז), from
-- scripts/suggest_glossary_links.js --term alternatives (5 suggestions, text source: index.html).
-- The term now has the alias «חלופת אשפוז», which is the form the cards use.
-- They stay hidden until approved in /admin#glossary.
-- Cards that are not in directory_card_edits are skipped by the join. Existing links,
-- approved or rejected, are left as they are.
-- Also records the owner-approved audit entries for the hospitalization-alternatives cleanup.
-- Requires 062 and 064. Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO glossary_card_links (term_key, card_key, status, matched_text)
SELECT v.term_key, c.card_key, 'suggested', v.matched_text
  FROM (VALUES
  ('alternatives', '39|||בית בטוח לטיפול מיידי - חלופת אשפוז', '…בטחון בית בטוח לטיפול מיידי - חלופת אשפוז נכי ונכות צה"ל שהוכרו עם פוסט…'),
  ('alternatives', '43|||אשפוז בית פסיכיאטרי', '…הקופות: כללית, מאוחדת ולאומית חלופת אשפוז מיצוי זכויות חלופה לאשפוז בב…'),
  ('alternatives', '48|||אשפוז בית פסיכיאטרי', '…הקופות: מכבי, מאוחדת ולאומית חלופת אשפוז'),
  ('alternatives', '53|||חלופת אשפוז', 'בתים מאזנים חלופת אשפוז'),
  ('alternatives', '279|||טיפול יום פסיכיאטרי — חלופת אשפוז למבוגרים במצבי משבר', '…הציבור) טיפול יום פסיכיאטרי — חלופת אשפוז למבוגרים במצבי משבר מגיל 18 ח…')
  ) AS v (term_key, card_key, matched_text)
  JOIN directory_card_edits c ON replace(c.card_key, E'\r', '') = v.card_key
ON CONFLICT (term_key, card_key) DO NOTHING;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-16-glossary-hospitalization-alternatives',
    DATE '2026-10-16',
    'מילון: חלופות אשפוז ואשפוז יום',
    'הערך «חלופות אשפוז» מונה עכשיו גם טיפול יום וצוות משבר. הערך «אשפוז יום» מסביר שהשם משמש בשתי דרכים: שלב קצר אחרי אשפוז מלא, או שם נוסף לטיפול יום. בערכים חלופות אשפוז, אשפוז יום, טיפול יום, אשפוז בית ובתים מאזנים יש קישור לקטגוריה המתאימה במדריך.',
    'glossary',
    '{}',
    ARRAY['alternatives', 'day_hosp', 'day_treatment', 'home_hosp', 'balancing_homes'],
    '075_glossary_link_suggestions_alternatives.sql'
  ),
  (
    '2026-10-16-glossary-term-service-lists',
    DATE '2026-10-16',
    'מילון: רשימת השירותים של מונח',
    'כשמונח במילון מקושר לשירותים רבים, השירותים מקובצים לפי קטגוריה, מוצגים עד 8 בכל קבוצה עם כפתור «הצג עוד», ושירותים עם אותו שם ארגון מופרדים לפי שם השירות.',
    'ui',
    '{}',
    '{}',
    '075_glossary_link_suggestions_alternatives.sql'
  ),
  (
    '2026-10-16-alternatives-section',
    DATE '2026-10-16',
    'קטגוריית חלופות אשפוז',
    'תיאור הקטגוריה תוקן ל«אשפוז בית, בתים מאזנים, צוותי משבר ובית בטוח», כי אשפוז יום נמצא בקטגוריה נפרדת. בראש הקטגוריה נוסף קישור לקטגוריה «אשפוז יום פסיכיאטרי (טיפול יום)».',
    'ui',
    '{}',
    '{}',
    '075_glossary_link_suggestions_alternatives.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
