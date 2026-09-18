-- 036_users_hide_intro.sql
--
-- Remember that the visitor collapsed the homepage welcome card, so returning
-- to the site (including after signing in on another device) does not pop it
-- open again. They can still reopen it from אתם לא לבד.
--
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

ALTER TABLE users ADD COLUMN IF NOT EXISTS hide_intro BOOLEAN NOT NULL DEFAULT false;

COMMENT ON COLUMN users.hide_intro IS
  'When true, the homepage welcome card stays hidden until reopened from אתם לא לבד.';

COMMIT;
