-- 040_users_license_register_admin.sql
--
-- Professional license number (מספר רישוי) on users, and a register_admin
-- outbox kind so operators are emailed when someone creates an account.
-- Required-ness for psychiatrist / nurse / social_worker is enforced in
-- the app so existing rows without a number stay valid.
--
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

ALTER TABLE users
  ADD COLUMN IF NOT EXISTS license_number TEXT;

COMMENT ON COLUMN users.license_number IS
  'Professional license number (מספר רישוי). The app requires it for psychiatrist, nurse, and social_worker.';

ALTER TABLE users DROP CONSTRAINT IF EXISTS users_license_number_len;
ALTER TABLE users ADD CONSTRAINT users_license_number_len
  CHECK (
    license_number IS NULL
    OR (char_length(btrim(license_number)) >= 1 AND char_length(license_number) <= 40)
  );

ALTER TABLE email_outbox DROP CONSTRAINT IF EXISTS email_outbox_kind_valid;
ALTER TABLE email_outbox ADD CONSTRAINT email_outbox_kind_valid
  CHECK (kind IN (
    'confirm', 'immediate', 'weekly', 'question_admin',
    'care_otp', 'care_grant_invite', 'care_grant_accepted', 'care_grant_revoked',
    'care_committee_reminder',
    'register_admin'
  ));

COMMIT;
