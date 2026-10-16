-- Migration 062 (16 Oct 2026)
-- Internal audit log of changes to the website, shown newest first in /admin#audit.
-- Each entry's description is approved by the site owner before it is inserted.
-- Register as [ ] in database_updates_master.sql; do not mark [x].
--
-- entry_key is a stable slug so a migration that records an entry can be re-run
-- with ON CONFLICT (entry_key) DO NOTHING.

BEGIN;

CREATE TABLE IF NOT EXISTS site_audit_entries (
  id serial PRIMARY KEY,
  entry_key text UNIQUE,
  happened_at date NOT NULL DEFAULT current_date,
  title text NOT NULL,
  description text NOT NULL,
  area text NOT NULL,
  card_keys text[] NOT NULL DEFAULT '{}',
  term_keys text[] NOT NULL DEFAULT '{}',
  migration text,
  created_by uuid REFERENCES users (id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT site_audit_entries_title_len CHECK (char_length(title) BETWEEN 1 AND 200),
  CONSTRAINT site_audit_entries_description_len CHECK (char_length(description) BETWEEN 1 AND 8000),
  CONSTRAINT site_audit_entries_area CHECK (area IN ('cards', 'glossary', 'ui', 'admin', 'data')),
  CONSTRAINT site_audit_entries_entry_key_fmt CHECK (entry_key IS NULL OR entry_key ~ '^[a-z0-9][a-z0-9_-]{0,119}$')
);

CREATE INDEX IF NOT EXISTS site_audit_entries_happened_idx ON site_audit_entries (happened_at DESC, id DESC);
CREATE INDEX IF NOT EXISTS site_audit_entries_card_keys_idx ON site_audit_entries USING gin (card_keys);

COMMENT ON TABLE site_audit_entries IS
  'Owner-approved descriptions of website changes. Internal; shown only in /admin#audit.';
COMMENT ON COLUMN site_audit_entries.card_keys IS
  'directory_card_edits.card_key values the change touched (row|||svc).';
COMMENT ON COLUMN site_audit_entries.term_keys IS
  'Glossary term keys (the keys of the terms object in index.html) the change touched.';

COMMIT;
