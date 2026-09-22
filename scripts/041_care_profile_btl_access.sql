-- 041_care_profile_btl_access.sql
--
-- National Insurance personal-area login (ביטוח לאומי — אזור אישי) on the
-- care profile: user code and password. Stored in plain text so the file
-- owner can read them back. Anonymous share links omit both fields.
--
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

ALTER TABLE care_profile
  ADD COLUMN IF NOT EXISTS btl_user_code TEXT NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS btl_password TEXT NOT NULL DEFAULT '';

COMMENT ON COLUMN care_profile.btl_user_code IS
  'ביטוח לאומי אזור אישי — קוד משתמש. Plain text so the owner can read it back. Omitted from no-login share links.';
COMMENT ON COLUMN care_profile.btl_password IS
  'ביטוח לאומי אזור אישי — סיסמה. Plain text so the owner can read it back. Omitted from no-login share links.';

ALTER TABLE care_profile DROP CONSTRAINT IF EXISTS care_profile_btl_len;
ALTER TABLE care_profile ADD CONSTRAINT care_profile_btl_len
  CHECK (char_length(btl_user_code) <= 80 AND char_length(btl_password) <= 200);

COMMIT;
