-- 043_care_documents_s3.sql
--
-- Care document bytes move to S3. Postgres keeps the AES-GCM nonce and a
-- storage_key. ciphertext stays for rows not yet copied; new uploads leave it null.
-- The existing care_documents_nonce_len check (12-byte nonce) still applies.
--
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

ALTER TABLE care_documents
  ADD COLUMN IF NOT EXISTS storage_key TEXT;

COMMENT ON COLUMN care_documents.storage_key IS
  'Private S3 object key for the AES-256-GCM ciphertext. NULL while the bytes still live in ciphertext.';

COMMENT ON COLUMN care_documents.ciphertext IS
  'Legacy AES-256-GCM ciphertext. NULL once the object has been copied to storage_key.';

ALTER TABLE care_documents
  ALTER COLUMN ciphertext DROP NOT NULL;

ALTER TABLE care_documents DROP CONSTRAINT IF EXISTS care_documents_storage_key_len;
ALTER TABLE care_documents ADD CONSTRAINT care_documents_storage_key_len
  CHECK (
    storage_key IS NULL
    OR (char_length(btrim(storage_key)) >= 1 AND char_length(storage_key) <= 200)
  );

ALTER TABLE care_documents DROP CONSTRAINT IF EXISTS care_documents_storage_key_key;
ALTER TABLE care_documents ADD CONSTRAINT care_documents_storage_key_key
  UNIQUE (storage_key);

ALTER TABLE care_documents DROP CONSTRAINT IF EXISTS care_documents_bytes_present;
ALTER TABLE care_documents ADD CONSTRAINT care_documents_bytes_present
  CHECK (
    (storage_key IS NOT NULL AND char_length(btrim(storage_key)) > 0)
    OR ciphertext IS NOT NULL
  );

COMMIT;
