-- 032_directory_entries_referral.sql
--
-- Mirror of the referral_route vocabulary onto directory_entries, plus the vocab_terms
-- lookup table. The live UI and the static pages read codes from index.html /
-- scripts/referral_codes.json; this table exists so the registry stays in step and so a
-- later faceted query can use it without parsing JSON.
--
-- Codes never replace the free-text notes/cost/target columns.

BEGIN;

CREATE TABLE IF NOT EXISTS vocab_terms (
  vocab      TEXT NOT NULL,
  code       TEXT NOT NULL,
  label_he   TEXT NOT NULL,
  label_en   TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (vocab, code)
);

COMMENT ON TABLE vocab_terms IS
  'Controlled vocabularies. Currently referral_route only. Codes used in DATA are validated against this list at build time.';

INSERT INTO vocab_terms (vocab, code, label_he, label_en, sort_order) VALUES
  ('referral_route', 'self_referral',            'אפשר לפנות ישירות',                    'Self-referral',                    1),
  ('referral_route', 'gp_referral',              'הפניה מרופא משפחה',                    'GP referral',                      2),
  ('referral_route', 'hmo_form17',               'טופס 17 מקופת החולים',                 'HMO form 17',                      3),
  ('referral_route', 'psychiatrist_referral',    'הפניה מפסיכיאטר',                      'Psychiatrist referral',            4),
  ('referral_route', 'mod_rehab_worker',         'הפניה מעובד שיקום (משרד הביטחון)',     'MoD rehab worker',                 5),
  ('referral_route', 'nii_referral',             'הפניה מביטוח לאומי',                   'NII referral',                     6),
  ('referral_route', 'rehab_basket_committee',   'ועדת סל שיקום',                         'Rehabilitation-basket committee',  7),
  ('referral_route', 'court_or_welfare',         'בית משפט או רווחה',                    'Court or welfare',                 8),
  ('referral_route', 'unknown',                  'לא צוין',                               'Not stated',                       99)
ON CONFLICT (vocab, code) DO UPDATE SET
  label_he   = EXCLUDED.label_he,
  label_en   = EXCLUDED.label_en,
  sort_order = EXCLUDED.sort_order;

ALTER TABLE directory_entries
  ADD COLUMN IF NOT EXISTS referral_codes TEXT[];

COMMENT ON COLUMN directory_entries.referral_codes IS
  'Controlled referral_route codes (see vocab_terms). Sits alongside free-text notes; never replaces them. unknown means the source did not say.';

COMMIT;
