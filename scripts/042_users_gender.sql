-- 042_users_gender.sql
--
-- Optional gender on the account profile: male or female. Null means unset.
--
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

ALTER TABLE users
  ADD COLUMN IF NOT EXISTS gender TEXT;

COMMENT ON COLUMN users.gender IS
  'Optional account gender: male or female. NULL when not set.';

ALTER TABLE users DROP CONSTRAINT IF EXISTS users_gender_valid;
ALTER TABLE users ADD CONSTRAINT users_gender_valid
  CHECK (gender IS NULL OR gender IN ('male', 'female'));

COMMIT;
