-- Run once on the Neon/Postgres DB (directory_entries table).
-- update_details: free text you maintain when you change an entry (e.g. changelog).
-- last_accessed: set automatically by POST /api/directory-entry-touch when a user uses a card action link/button.

ALTER TABLE directory_entries
  ADD COLUMN IF NOT EXISTS update_details text NULL,
  ADD COLUMN IF NOT EXISTS last_accessed timestamptz NULL;

COMMENT ON COLUMN directory_entries.update_details IS 'Editor notes / what changed when the entry was last updated (maintained manually).';
COMMENT ON COLUMN directory_entries.last_accessed IS 'Last time a visitor used a link or button on this entry''s card.';
