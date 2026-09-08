-- 029_events_server_headers.sql
--
-- Record what the server saw, alongside what the client said.
--
-- events.extra->>'user_agent' and events.referrer_domain are both client-reported: the
-- browser puts them in the JSON body. That is fine for ordinary traffic and useless for the
-- question Phase 4 actually asks, which is "is this a person?". A client can send anything.
-- More prosaically, `referrer_domain` is computed from document.referrer, which is empty on
-- the very navigations we most want to attribute — an LLM answer opened in a new tab, a link
-- pasted from WhatsApp Desktop — while the Referer header sometimes still carries it.
--
-- Storing both lets the two be compared. Where they disagree, the server one is the evidence.
--
-- These are nullable and nothing depends on them being present: /api/analytics keeps working
-- unchanged if this migration has not been run, because the INSERT names its columns.

ALTER TABLE events ADD COLUMN IF NOT EXISTS server_user_agent TEXT;
ALTER TABLE events ADD COLUMN IF NOT EXISTS server_referrer   TEXT;

COMMENT ON COLUMN events.server_user_agent IS
  'User-Agent header as seen by the serverless function. Compare with extra->>''user_agent'' (client-reported) to spot automation. Not a security control — both are trivially spoofable — but a disagreement is a real signal.';
COMMENT ON COLUMN events.server_referrer IS
  'Full Referer header as seen by the server. referrer_domain is the client-computed hostname from document.referrer and is often null where this is not.';

-- The comparison query is "events in a window, grouped by agent", so index the window.
CREATE INDEX IF NOT EXISTS events_occurred_at_idx ON events (occurred_at DESC);
