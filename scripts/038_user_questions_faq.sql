-- 038_user_questions_faq.sql
--
-- Registered users can submit a question. Admins are emailed and can
-- publish answers into a public FAQ. No AI in this migration; the
-- questions table is the seam for a later assistant.
--
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

CREATE TABLE IF NOT EXISTS user_questions (
  id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  question     TEXT        NOT NULL,
  status       TEXT        NOT NULL DEFAULT 'open',
  admin_notes  TEXT,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT user_questions_question_len CHECK (
    char_length(btrim(question)) >= 10 AND char_length(question) <= 2000
  ),
  CONSTRAINT user_questions_status_valid CHECK (
    status IN ('open', 'answered', 'published', 'discarded')
  )
);

CREATE INDEX IF NOT EXISTS user_questions_status_created_idx
  ON user_questions (status, created_at DESC);
CREATE INDEX IF NOT EXISTS user_questions_user_created_idx
  ON user_questions (user_id, created_at DESC);

COMMENT ON TABLE user_questions IS
  'Questions submitted by registered users. Admins reply offline; rows can later be published as FAQ.';
COMMENT ON COLUMN user_questions.status IS
  'open (new) | answered (handled offline) | published (copied to faq_items) | discarded.';

CREATE TABLE IF NOT EXISTS faq_items (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  question            TEXT        NOT NULL,
  answer              TEXT        NOT NULL,
  source_question_id  UUID        REFERENCES user_questions (id) ON DELETE SET NULL,
  sort_order          INT         NOT NULL DEFAULT 0,
  published           BOOLEAN     NOT NULL DEFAULT true,
  published_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  published_by        UUID        REFERENCES users (id) ON DELETE SET NULL,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT faq_items_question_len CHECK (
    char_length(btrim(question)) >= 3 AND char_length(question) <= 500
  ),
  CONSTRAINT faq_items_answer_len CHECK (
    char_length(btrim(answer)) >= 3 AND char_length(answer) <= 8000
  )
);

CREATE INDEX IF NOT EXISTS faq_items_published_sort_idx
  ON faq_items (published, sort_order, published_at);

COMMENT ON TABLE faq_items IS
  'Public FAQ entries. Usually promoted from user_questions; can also be authored from scratch.';

ALTER TABLE email_outbox DROP CONSTRAINT IF EXISTS email_outbox_kind_valid;
ALTER TABLE email_outbox ADD CONSTRAINT email_outbox_kind_valid
  CHECK (kind IN ('confirm', 'immediate', 'weekly', 'question_admin'));

COMMIT;
