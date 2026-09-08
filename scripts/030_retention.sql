-- 030_retention.sql
--
-- Retention limits for the two tables that hold anything sensitive.
--
-- The reason this is a migration and not a note in a README: this directory is used by
-- people looking for psychiatric help, sexual assault support, and addiction services.
-- events.search_query is free text they typed while doing that. It is sanitised on the
-- client (emails and long digit runs redacted, truncated to 80 chars) but it is not
-- anonymous in any meaningful sense — "טיפול בטראומה מינית ירושלים" tells you a great deal
-- about the person who typed it, and it sits next to a session_id and a country.
--
-- Nothing about the product needs a query string from four months ago. What it needs is the
-- aggregate — which terms are common, so the taxonomy can follow them — and that survives
-- the raw text being deleted.
--
--   request_log        90 days. It exists to measure crawler behaviour, which is a
--                      short-horizon question.
--   events.search_query 90 days, nulled in place. The event row itself is kept, so
--                      long-run counts of "how many searches" stay correct; only the text
--                      goes. Aggregates are preserved in search_query_monthly first.
--
-- Run by /api/retention on a schedule (see vercel.json crons). The functions are idempotent
-- and safe to run by hand.

-- ---------------------------------------------------------------- aggregate first

-- Preserve what the raw text is actually for, so deleting it costs nothing analytically.
-- Terms seen fewer than 5 times in a month are dropped rather than kept: a query typed once
-- is the one most likely to identify someone, and is the least useful signal.
CREATE TABLE IF NOT EXISTS search_query_monthly (
  month        DATE   NOT NULL,
  search_query TEXT   NOT NULL,
  occurrences  INTEGER NOT NULL,
  sessions     INTEGER NOT NULL,
  PRIMARY KEY (month, search_query)
);

COMMENT ON TABLE search_query_monthly IS
  'Monthly rollup of events.search_query, keeping only terms with >=5 occurrences in the month. Populated before the raw text is deleted at 90 days by roll_up_search_queries().';

CREATE OR REPLACE FUNCTION roll_up_search_queries() RETURNS integer AS $$
DECLARE
  affected integer;
BEGIN
  INSERT INTO search_query_monthly (month, search_query, occurrences, sessions)
  SELECT date_trunc('month', occurred_at)::date AS month,
         search_query,
         COUNT(*)::int,
         COUNT(DISTINCT session_id)::int
  FROM events
  WHERE search_query IS NOT NULL
    AND occurred_at < now() - interval '30 days'   -- only settled months
  GROUP BY 1, 2
  HAVING COUNT(*) >= 5
  ON CONFLICT (month, search_query) DO UPDATE
    SET occurrences = EXCLUDED.occurrences,
        sessions    = EXCLUDED.sessions;
  GET DIAGNOSTICS affected = ROW_COUNT;
  RETURN affected;
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------------- then delete

CREATE OR REPLACE FUNCTION purge_old_search_queries() RETURNS integer AS $$
DECLARE
  affected integer;
BEGIN
  -- Nulled, not deleted: the event still counts as a search for volume reporting.
  UPDATE events
     SET search_query = NULL
   WHERE search_query IS NOT NULL
     AND occurred_at < now() - interval '90 days';
  GET DIAGNOSTICS affected = ROW_COUNT;
  RETURN affected;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION purge_old_request_log() RETURNS integer AS $$
DECLARE
  affected integer;
BEGIN
  DELETE FROM request_log WHERE occurred_at < now() - interval '90 days';
  GET DIAGNOSTICS affected = ROW_COUNT;
  RETURN affected;
END;
$$ LANGUAGE plpgsql;

-- Partial index so the purge does not scan the whole events table each night.
CREATE INDEX IF NOT EXISTS events_search_query_present_idx
  ON events (occurred_at)
  WHERE search_query IS NOT NULL;

COMMENT ON FUNCTION purge_old_search_queries() IS
  'Nulls events.search_query older than 90 days, keeping the event row. Run roll_up_search_queries() first.';
COMMENT ON FUNCTION purge_old_request_log() IS
  'Deletes request_log rows older than 90 days.';
