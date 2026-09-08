-- 028_request_log.sql
--
-- Server-side request log. This is the denominator that the existing analytics cannot
-- provide: both GA4 and /api/analytics require JavaScript, so bots never appear in either
-- (they do not run JS and therefore never POST), and neither do humans in browsers where
-- the scripts fail. Static pages mean the server now sees every HTML request.
--
-- Written directly from middleware.ts (Node runtime), fire-and-forget. 100% of requests
-- whose user agent matches a known bot, plus a sampled slice of human traffic.
--
-- Privacy: no IP address is stored, only the country Vercel already resolves. The user
-- agent and path are stored because bot identification is the entire purpose. Retention is
-- capped at 90 days by migration 030.

CREATE TABLE IF NOT EXISTS request_log (
  id             BIGSERIAL PRIMARY KEY,
  occurred_at    TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Request
  path           TEXT        NOT NULL,
  method         TEXT,
  host           TEXT,

  -- Client, from server headers rather than anything the client chose to send
  user_agent     TEXT,
  referrer       TEXT,
  country        TEXT,

  -- Classification, computed in middleware so reporting does not have to re-parse UAs
  is_bot         BOOLEAN     NOT NULL DEFAULT false,
  bot_name       TEXT,                                  -- 'GPTBot', 'Googlebot', ... NULL when not a bot
  bot_kind       TEXT,                                   -- 'ai_training' | 'ai_search' | 'search' | 'social' | 'other'

  -- Sampling. Human rows are sampled; bot rows are always 1.0. Divide by this to estimate totals.
  sample_rate    NUMERIC(5,4) NOT NULL DEFAULT 1.0,

  CONSTRAINT request_log_sample_rate_range CHECK (sample_rate > 0 AND sample_rate <= 1),
  CONSTRAINT request_log_bot_kind_valid CHECK (
    bot_kind IS NULL OR bot_kind IN ('ai_training', 'ai_search', 'search', 'social', 'other')
  )
);

-- Reporting is always "which agents hit which paths, recently", and the retention delete is
-- always "occurred_at older than N days". Both are served by these.
CREATE INDEX IF NOT EXISTS request_log_occurred_at_idx ON request_log (occurred_at DESC);
CREATE INDEX IF NOT EXISTS request_log_bot_idx ON request_log (bot_name, occurred_at DESC) WHERE is_bot;
CREATE INDEX IF NOT EXISTS request_log_path_idx ON request_log (path, occurred_at DESC);

COMMENT ON TABLE request_log IS
  'Server-side HTML request log written from middleware. Provides the denominator that GA4 and /api/analytics cannot, because both require JavaScript. 90-day retention.';
COMMENT ON COLUMN request_log.sample_rate IS
  'Fraction of matching traffic that was recorded. 1.0 for bots, REQUEST_LOG_HUMAN_SAMPLE for humans. Divide counts by this to estimate totals.';
COMMENT ON COLUMN request_log.bot_kind IS
  'ai_training crawlers bake in a snapshot; ai_search crawlers fetch live and reflect corrections. The distinction matters for the staleness argument in robots.txt.';
