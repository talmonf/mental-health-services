-- 035_users_auth_analytics_email.sql
--
-- Optional accounts, signed-in analytics, and the email-update pipeline.
--
-- The directory itself stays usable without an account. These tables exist so that
-- people who choose to register can receive site-change emails, and so that an
-- admin can see aggregate usage plus (when signed in) which account a session
-- belonged to. Search-query retention in 030 is unchanged: identity does not
-- buy a longer memory of what someone typed.
--
-- events.user_id / sessions.user_id are nullable. Anonymous traffic stays anonymous.
-- The application stamps user_id from the auth cookie only; a client-sent user_id
-- is ignored.
--
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

CREATE TABLE IF NOT EXISTS users (
  id                 UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  email              TEXT        NOT NULL,
  password_hash      TEXT        NOT NULL,
  is_admin           BOOLEAN     NOT NULL DEFAULT false,

  country            TEXT        NOT NULL,
  city               TEXT,
  qualification      TEXT        NOT NULL,
  organization       TEXT        NOT NULL,
  title              TEXT        NOT NULL,
  found_via          TEXT        NOT NULL,
  found_via_other    TEXT,

  email_preference   TEXT        NOT NULL DEFAULT 'none',
  email_verified_at  TIMESTAMPTZ,

  created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at         TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT users_email_lower CHECK (email = lower(btrim(email))),
  CONSTRAINT users_email_len CHECK (char_length(email) >= 3 AND char_length(email) <= 320),
  CONSTRAINT users_qualification_valid CHECK (
    qualification IN (
      'social_worker',
      'psychologist',
      'psychiatrist',
      'therapist',
      'nurse',
      'peer_supporter',
      'student',
      'family_self',
      'other'
    )
  ),
  CONSTRAINT users_found_via_valid CHECK (
    found_via IN (
      'google',
      'facebook_instagram',
      'whatsapp',
      'colleague',
      'university',
      'organization',
      'media',
      'other'
    )
  ),
  CONSTRAINT users_found_via_other_required CHECK (
    found_via <> 'other'
    OR (found_via_other IS NOT NULL AND length(btrim(found_via_other)) > 0)
  ),
  CONSTRAINT users_email_preference_valid CHECK (
    email_preference IN ('none', 'weekly', 'immediate')
  )
);

CREATE UNIQUE INDEX IF NOT EXISTS users_email_uidx ON users (email);

COMMENT ON TABLE users IS
  'Optional accounts. The public directory does not require a row here. Emails are stored lowercased. password_hash is bcrypt; never select it in public APIs.';
COMMENT ON COLUMN users.email_preference IS
  'none (default) | weekly | immediate. Update mail is sent only after email_verified_at is set.';
COMMENT ON COLUMN users.is_admin IS
  'Operator flag. Also set at login/register when the address is listed in ADMIN_EMAILS. Can be flipped in SQL.';

CREATE TABLE IF NOT EXISTS email_tokens (
  id           BIGSERIAL   PRIMARY KEY,
  user_id      UUID        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  kind         TEXT        NOT NULL,
  token_hash   TEXT        NOT NULL,
  expires_at   TIMESTAMPTZ NOT NULL,
  consumed_at  TIMESTAMPTZ,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT email_tokens_kind_valid CHECK (kind IN ('confirm', 'unsubscribe'))
);

CREATE UNIQUE INDEX IF NOT EXISTS email_tokens_hash_uidx ON email_tokens (token_hash);
CREATE INDEX IF NOT EXISTS email_tokens_user_kind_idx ON email_tokens (user_id, kind);

COMMENT ON TABLE email_tokens IS
  'Hashed confirm and unsubscribe tokens. The raw token appears only in the email URL.';

CREATE TABLE IF NOT EXISTS site_updates (
  id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  title         TEXT        NOT NULL,
  body          TEXT        NOT NULL,
  published_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  published_by  UUID        REFERENCES users (id) ON DELETE SET NULL,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE site_updates IS
  'Admin-authored "what changed" notes. The live site is edited in index.html, so email is triggered by publishing a row here, not by git.';

CREATE TABLE IF NOT EXISTS email_outbox (
  id            BIGSERIAL   PRIMARY KEY,
  user_id       UUID        REFERENCES users (id) ON DELETE CASCADE,
  kind          TEXT        NOT NULL,
  payload       JSONB       NOT NULL DEFAULT '{}'::jsonb,
  scheduled_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  sent_at       TIMESTAMPTZ,
  error         TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT email_outbox_kind_valid CHECK (kind IN ('confirm', 'immediate', 'weekly'))
);

CREATE INDEX IF NOT EXISTS email_outbox_pending_idx
  ON email_outbox (scheduled_at)
  WHERE sent_at IS NULL;
CREATE INDEX IF NOT EXISTS email_outbox_user_kind_sent_idx
  ON email_outbox (user_id, kind, sent_at DESC);

COMMENT ON TABLE email_outbox IS
  'Queued mail. Cron and publish handlers send via Resend. Rows stay pending when RESEND_API_KEY is unset.';

ALTER TABLE events ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES users (id) ON DELETE SET NULL;
ALTER TABLE sessions ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES users (id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS events_user_id_occurred_at_idx
  ON events (user_id, occurred_at DESC)
  WHERE user_id IS NOT NULL;

COMMENT ON COLUMN events.user_id IS
  'Set from the auth cookie by /api/analytics when the visitor is signed in. Never taken from the JSON body. NULL for anonymous traffic.';
COMMENT ON COLUMN sessions.user_id IS
  'First signed-in user observed on this analytics session_id. NULL if the session stayed anonymous.';

COMMIT;
