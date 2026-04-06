-- Run once against the Neon/Postgres DB used by /api/analytics
ALTER TABLE events
  ADD COLUMN IF NOT EXISTS error text NULL,
  ADD COLUMN IF NOT EXISTS error_details text NULL;

COMMENT ON COLUMN events.error IS 'Literal tag, e.g. error, for error-class rows; NULL for normal events.';
COMMENT ON COLUMN events.error_details IS 'Error payload (often JSON string from client).';
