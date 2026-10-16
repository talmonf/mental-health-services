-- Migration 077 (16 Oct 2026)
-- Card indicators: what a card offers, whether it is an organization's general card, how the
-- service is funded, and how to get referred. Shown on the card face; edited in /admin#directory.
-- Saving indicators does not change public_edited_at (the footer "עודכן" date).
-- Register as [ ] in database_updates_master.sql; do not mark [x].
--
-- indicators shape (lib/directory-cards.ts normalizeIndicators):
--   offers           text[]  info | navigate | care | claim | community
--   whole_org        boolean the card is the organization's general entry point
--   funding          [{channel, terms}]
--                    channel: private | free | hmo | moh | mod | welfare | btl | supplementary | edu
--                    terms:   '' | full | partial | eligible  (always '' for private and free)
--   referral         text[]  referral route codes (index.html MH_REFERRAL_LABELS_HE)
--   referral_source  text    published wording the referral codes were taken from
-- An empty object means nothing is set; the page then falls back to the embedded referral codes.

BEGIN;

ALTER TABLE directory_card_edits
  ADD COLUMN IF NOT EXISTS indicators jsonb NOT NULL DEFAULT '{}'::jsonb;

COMMENT ON COLUMN directory_card_edits.indicators IS
  'Card-face indicators: offers, whole_org, funding [{channel, terms}], referral codes and source.';

-- An organization's general card lists that organization's specific cards.
CREATE TABLE IF NOT EXISTS card_org_links (
  id serial PRIMARY KEY,
  org_card_key text NOT NULL REFERENCES directory_card_edits (card_key) ON DELETE CASCADE ON UPDATE CASCADE,
  member_card_key text NOT NULL REFERENCES directory_card_edits (card_key) ON DELETE CASCADE ON UPDATE CASCADE,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT card_org_links_unique UNIQUE (org_card_key, member_card_key),
  CONSTRAINT card_org_links_not_self CHECK (org_card_key <> member_card_key)
);

CREATE INDEX IF NOT EXISTS card_org_links_org_idx ON card_org_links (org_card_key, sort_order);

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES
  (
    '2026-10-16-card-indicators',
    DATE '2026-10-16',
    'סימונים חדשים בכרטיסים: מה יש בכרטיס, כרטיס כללי של ארגון, ומימון',
    'לכל כרטיס אפשר לסמן מה יש בו (מידע, הכוונה ואיתור, טיפול ותמיכה, מימוש זכות, קהילה), האם הוא הכרטיס הכללי של הארגון, ואיך השירות ממומן (חינם, קופות חולים, משרד הבריאות, משרד הביטחון, רווחה, ביטוח לאומי, משרד החינוך, ביטוח משלים או בתשלום, עם מימון מלא, השתתפות עצמית או לזכאים). כרטיס שיש בו רק מידע מוצג כ«מידע בלבד». המימון ודרך ההפניה מוצגים יחד בשורה «איך מקבלים», וכרטיס כללי של ארגון מקשר לשירותים של הארגון. מתחת לתיבת החיפוש נוסף סינון לפי סוג הכרטיס והמימון. בעריכת כרטיס נוסף חלק «סימונים בכרטיס». בנוסף הוסר המספר 0 שהופיע בטעות בכרטיסים שאין בהם פרטים נוספים.',
    'ui',
    '{}',
    '{}',
    '077_card_indicators.sql'
  )
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
