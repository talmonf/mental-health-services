#!/usr/bin/env node
/**
 * Pulls real search queries from events.search_query to seed the next question set version.
 *
 * v1 of the question set has no search_log provenance because the database was not
 * reachable when it was frozen. Run this before freezing v2.
 *
 *   DATABASE_URL=postgres://... node experiments/pull_search_queries.js > experiments/questions/search_log_seed.tsv
 *
 * Privacy: search_query on a mental-health site contains self-disclosure. This script
 * aggregates and applies a minimum-occurrence floor so that a query typed by a single
 * person is never emitted. Do not lower MIN_OCCURRENCES.
 */
const { Client } = require('pg');

const MIN_OCCURRENCES = 3;
const LIMIT = 300;

function normalizePgSslMode(connectionString) {
  try {
    const u = new URL(connectionString);
    const mode = u.searchParams.get('sslmode');
    if (mode === 'prefer' || mode === 'require' || mode === 'verify-ca') {
      u.searchParams.set('sslmode', 'verify-full');
    }
    return u.toString();
  } catch {
    return connectionString;
  }
}

async function main() {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    console.error('DATABASE_URL is not set. Nothing to pull.');
    process.exit(1);
  }

  const client = new Client({ connectionString: normalizePgSslMode(databaseUrl) });
  await client.connect();
  try {
    const { rows } = await client.query(
      `SELECT trim(search_query) AS q,
              count(*)            AS n,
              count(DISTINCT session_id) AS sessions,
              round(avg(results_count)::numeric, 1) AS avg_results
         FROM events
        WHERE search_query IS NOT NULL
          AND length(trim(search_query)) >= 2
        GROUP BY trim(search_query)
       HAVING count(DISTINCT session_id) >= $1
        ORDER BY count(*) DESC
        LIMIT $2`,
      [MIN_OCCURRENCES, LIMIT]
    );

    console.log(['query', 'hits', 'sessions', 'avg_results', 'zero_result'].join('\t'));
    for (const r of rows) {
      const zero = Number(r.avg_results) === 0 ? 'ZERO_RESULTS' : '';
      console.log([r.q, r.n, r.sessions, r.avg_results, zero].join('\t'));
    }

    console.error(
      `\n${rows.length} queries at >= ${MIN_OCCURRENCES} distinct sessions.\n` +
        'Queries marked ZERO_RESULTS are the most valuable: people asked and the directory had nothing.\n' +
        'Those are both question-set candidates and a content backlog.'
    );
  } finally {
    await client.end().catch(() => {});
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
