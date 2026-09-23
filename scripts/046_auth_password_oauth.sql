-- 046_auth_password_oauth.sql
--
-- Password max-age, email reset tokens, and Google sign-in.
-- Google-only accounts have a null password_hash and may be incomplete until
-- the complete-profile step fills country / qualification / org / title / found_via.
--
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

ALTER TABLE users ALTER COLUMN password_hash DROP NOT NULL;

ALTER TABLE users
  ADD COLUMN IF NOT EXISTS password_changed_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS google_sub TEXT,
  ADD COLUMN IF NOT EXISTS profile_completed_at TIMESTAMPTZ;

UPDATE users
   SET password_changed_at = COALESCE(password_changed_at, created_at)
 WHERE password_hash IS NOT NULL
   AND password_changed_at IS NULL;

UPDATE users
   SET profile_completed_at = COALESCE(profile_completed_at, created_at)
 WHERE profile_completed_at IS NULL;

ALTER TABLE users ALTER COLUMN country DROP NOT NULL;
ALTER TABLE users ALTER COLUMN qualification DROP NOT NULL;
ALTER TABLE users ALTER COLUMN organization DROP NOT NULL;
ALTER TABLE users ALTER COLUMN title DROP NOT NULL;
ALTER TABLE users ALTER COLUMN found_via DROP NOT NULL;

ALTER TABLE users DROP CONSTRAINT IF EXISTS users_qualification_valid;
ALTER TABLE users ADD CONSTRAINT users_qualification_valid CHECK (
  qualification IS NULL OR qualification IN (
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
);

ALTER TABLE users DROP CONSTRAINT IF EXISTS users_found_via_valid;
ALTER TABLE users ADD CONSTRAINT users_found_via_valid CHECK (
  found_via IS NULL OR found_via IN (
    'google',
    'facebook_instagram',
    'whatsapp',
    'colleague',
    'university',
    'organization',
    'media',
    'other'
  )
);

CREATE UNIQUE INDEX IF NOT EXISTS users_google_sub_uidx ON users (google_sub)
  WHERE google_sub IS NOT NULL;

COMMENT ON COLUMN users.password_hash IS
  'bcrypt hash for email/password accounts. NULL for Google-only accounts until they set a password.';
COMMENT ON COLUMN users.password_changed_at IS
  'Set on register, password change, and reset. NULL when the account has no password. Max age is enforced in the app.';
COMMENT ON COLUMN users.google_sub IS
  'Google OpenID subject. Unique when set. Linked to an existing row when the verified Google email already has an account.';
COMMENT ON COLUMN users.profile_completed_at IS
  'When the registration profile fields were first completed. NULL until the complete-profile step for new Google accounts.';

ALTER TABLE email_tokens DROP CONSTRAINT IF EXISTS email_tokens_kind_valid;
ALTER TABLE email_tokens ADD CONSTRAINT email_tokens_kind_valid
  CHECK (kind IN ('confirm', 'unsubscribe', 'care_otp', 'reset'));

ALTER TABLE email_outbox DROP CONSTRAINT IF EXISTS email_outbox_kind_valid;
ALTER TABLE email_outbox ADD CONSTRAINT email_outbox_kind_valid
  CHECK (kind IN (
    'confirm', 'immediate', 'weekly', 'question_admin',
    'care_otp', 'care_grant_invite', 'care_grant_accepted', 'care_grant_revoked',
    'care_committee_reminder',
    'register_admin',
    'reset'
  ));

COMMIT;
