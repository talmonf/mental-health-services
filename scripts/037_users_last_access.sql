-- 037_users_last_access.sql
--
-- Remember the last time a signed-in account hit login or session, so the
-- admin users list can show כניסה אחרונה. Throttled in application SQL
-- (update only if null or older than 5 minutes).
--
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

ALTER TABLE users ADD COLUMN IF NOT EXISTS last_access_at TIMESTAMPTZ;

COMMENT ON COLUMN users.last_access_at IS
  'Last login or session ping. Null until the account is used after this migration.';

COMMIT;
