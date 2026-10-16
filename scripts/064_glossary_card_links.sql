-- Migration 064 (16 Oct 2026)
-- Two-way links between glossary terms (keys of the terms object in index.html) and cards.
-- Only approved rows are published: cards show the term, and the term lists the card.
-- Suggested rows come from scripts/suggest_glossary_links.js and are reviewed in /admin#glossary.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

CREATE TABLE IF NOT EXISTS glossary_card_links (
  id serial PRIMARY KEY,
  term_key text NOT NULL,
  card_key text NOT NULL REFERENCES directory_card_edits (card_key) ON DELETE CASCADE ON UPDATE CASCADE,
  status text NOT NULL DEFAULT 'suggested',
  matched_text text NOT NULL DEFAULT '',
  created_at timestamptz NOT NULL DEFAULT now(),
  reviewed_at timestamptz,
  reviewed_by uuid REFERENCES users (id) ON DELETE SET NULL,
  CONSTRAINT glossary_card_links_unique UNIQUE (term_key, card_key),
  CONSTRAINT glossary_card_links_term_fmt CHECK (term_key ~ '^[a-z0-9_]{1,80}$'),
  CONSTRAINT glossary_card_links_status CHECK (status IN ('suggested', 'approved', 'rejected'))
);

CREATE INDEX IF NOT EXISTS glossary_card_links_card_idx ON glossary_card_links (card_key) WHERE status = 'approved';
CREATE INDEX IF NOT EXISTS glossary_card_links_status_idx ON glossary_card_links (status, term_key);

COMMIT;
