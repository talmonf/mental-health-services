-- Migration 063 (16 Oct 2026)
-- Internal card verification and related Google Contacts (admin only, never published).
-- Register as [ ] in database_updates_master.sql; do not mark [x].
--
-- Verification levels:
--   0 not verified
--   1 website checked
--   2 confirmed by phone or email with the organisation
--   3 confirmed by a named contact at the organisation
-- A card's current status is its latest card_verifications row; earlier rows are history.

BEGIN;

CREATE TABLE IF NOT EXISTS google_connection (
  id smallint PRIMARY KEY DEFAULT 1,
  google_email text NOT NULL,
  refresh_token_enc text NOT NULL,
  scopes text NOT NULL DEFAULT '',
  connected_by uuid REFERENCES users (id) ON DELETE SET NULL,
  connected_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT google_connection_single_row CHECK (id = 1)
);

COMMENT ON TABLE google_connection IS
  'Single Google account whose contacts admins search. refresh_token_enc is AES-256-GCM with GOOGLE_TOKEN_KEY.';

CREATE TABLE IF NOT EXISTS google_contacts (
  id serial PRIMARY KEY,
  resource_name text UNIQUE,
  display_name text NOT NULL,
  email text NOT NULL DEFAULT '',
  phone text NOT NULL DEFAULT '',
  organization text NOT NULL DEFAULT '',
  contact_url text NOT NULL DEFAULT '',
  synced_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT google_contacts_resource_fmt CHECK (resource_name IS NULL OR resource_name ~ '^people/c[0-9]+$'),
  CONSTRAINT google_contacts_name_len CHECK (char_length(display_name) BETWEEN 1 AND 200)
);

COMMENT ON TABLE google_contacts IS
  'Local copy of Google Contacts people linked to cards. resource_name is the People API id (people/c...); contact_url opens it in contacts.google.com for the connected account only.';

CREATE TABLE IF NOT EXISTS card_contacts (
  id serial PRIMARY KEY,
  card_edit_id integer NOT NULL REFERENCES directory_card_edits (id) ON DELETE CASCADE,
  contact_id integer NOT NULL REFERENCES google_contacts (id) ON DELETE CASCADE,
  role_note text NOT NULL DEFAULT '',
  created_by uuid REFERENCES users (id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT card_contacts_unique UNIQUE (card_edit_id, contact_id),
  CONSTRAINT card_contacts_role_len CHECK (char_length(role_note) <= 500)
);

CREATE TABLE IF NOT EXISTS card_verifications (
  id serial PRIMARY KEY,
  card_edit_id integer NOT NULL REFERENCES directory_card_edits (id) ON DELETE CASCADE,
  level smallint NOT NULL,
  verified_on date NOT NULL,
  verified_by_contact_id integer REFERENCES google_contacts (id) ON DELETE SET NULL,
  method_note text NOT NULL DEFAULT '',
  recorded_by uuid REFERENCES users (id) ON DELETE SET NULL,
  recorded_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT card_verifications_level CHECK (level BETWEEN 0 AND 3),
  CONSTRAINT card_verifications_note_len CHECK (char_length(method_note) <= 2000)
);

CREATE INDEX IF NOT EXISTS card_verifications_card_idx
  ON card_verifications (card_edit_id, verified_on DESC, id DESC);

COMMIT;
