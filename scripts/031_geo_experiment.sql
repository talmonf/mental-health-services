-- 031_geo_experiment.sql
--
-- Storage for the GEO experiment (Phase 5). Longitudinal: a later run is only comparable
-- to an earlier one if we know which question set, which site state, and which resolved
-- model version produced it.
--
-- The baseline itself is recorded first as CSV under experiments/results/ and backfilled
-- here by experiments/backfill.js. Tables are created empty; they are not a second source
-- of truth for the questions (those stay frozen in experiments/questions/v1.json).

BEGIN;

CREATE TABLE IF NOT EXISTS geo_question_sets (
  set_version  TEXT PRIMARY KEY,
  frozen_at    DATE NOT NULL,
  n            INTEGER NOT NULL,
  notes        TEXT
);

CREATE TABLE IF NOT EXISTS geo_questions (
  set_version    TEXT NOT NULL REFERENCES geo_question_sets (set_version),
  question_id    TEXT NOT NULL,
  he             TEXT NOT NULL,
  axis           TEXT NOT NULL,
  provenance     TEXT,
  expected_rows  INTEGER[],
  safety_item    BOOLEAN NOT NULL DEFAULT false,
  notes          TEXT,
  PRIMARY KEY (set_version, question_id),
  CONSTRAINT geo_questions_axis_check CHECK (
    axis IN ('entitlement_funding', 'crisis', 'population', 'navigational')
  )
);

CREATE TABLE IF NOT EXISTS geo_runs (
  run_id            TEXT PRIMARY KEY,
  started_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  set_version       TEXT NOT NULL REFERENCES geo_question_sets (set_version),
  git_sha           TEXT,
  site_last_updated TEXT,
  notes             TEXT
);

CREATE TABLE IF NOT EXISTS geo_answers (
  answer_id               TEXT PRIMARY KEY,
  run_id                  TEXT NOT NULL REFERENCES geo_runs (run_id),
  question_id             TEXT NOT NULL,
  provider                TEXT NOT NULL,
  model_alias             TEXT,
  model_version_resolved  TEXT,
  web_access              BOOLEAN NOT NULL DEFAULT false,
  arm                     TEXT NOT NULL DEFAULT 'api',
  answer_text             TEXT,
  raw_response            JSONB,
  citations_found         TEXT[],
  latency_ms              INTEGER,
  CONSTRAINT geo_answers_arm_check CHECK (arm IN ('api', 'manual_ui'))
);

CREATE TABLE IF NOT EXISTS geo_scores (
  answer_id       TEXT NOT NULL REFERENCES geo_answers (answer_id),
  scorer          TEXT NOT NULL,
  scored_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  factual_0_3     SMALLINT,
  actionable_0_3  SMALLINT,
  citation        TEXT,
  safety_pass     BOOLEAN,
  notes           TEXT,
  PRIMARY KEY (answer_id, scorer),
  CONSTRAINT geo_scores_factual_check CHECK (factual_0_3 BETWEEN 0 AND 3),
  CONSTRAINT geo_scores_actionable_check CHECK (actionable_0_3 BETWEEN 0 AND 3),
  CONSTRAINT geo_scores_citation_check CHECK (
    citation IS NULL OR citation IN ('nefesh', 'authoritative_il', 'other_source', 'none')
  )
);

CREATE INDEX IF NOT EXISTS geo_answers_run_idx ON geo_answers (run_id);
CREATE INDEX IF NOT EXISTS geo_answers_question_idx ON geo_answers (question_id);

COMMENT ON TABLE geo_runs IS
  'One experiment run. git_sha + site_last_updated is what ties the run to a specific state of the site.';
COMMENT ON COLUMN geo_answers.model_version_resolved IS
  'The version string the API actually returned, not the alias. Aliases drift silently.';
COMMENT ON COLUMN geo_scores.scorer IS
  'Multiple raters and re-scores are first-class rows, not overwrites.';

COMMIT;
