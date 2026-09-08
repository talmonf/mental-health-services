/**
 * GET /api/bot-report
 *
 * Reports what request_log has seen. This is the answer to a question that was previously
 * unanswerable: do GPTBot, ClaudeBot, PerplexityBot or OAI-SearchBot ever fetch this site
 * at all, and which URLs do they take?
 *
 * Invoke: curl -H "Authorization: Bearer $CRON_SECRET" "https://<your-domain>/api/bot-report"
 *
 * Query params:
 *   days=30      lookback window (1-365)
 *   format=text  human-readable instead of JSON
 *
 * Env:
 *   CRON_SECRET  — required in production; must match the Bearer token
 *   DATABASE_URL — Postgres
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import { Client } from 'pg';
import { GEO_GATE_AGENTS } from '../lib/bots';

function normalizePgSslMode(connectionString: string): string {
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

/** Same shape as api/link-check.ts: no secret configured means non-production only. */
function authorize(req: VercelRequest): boolean {
  const secret = process.env.CRON_SECRET;
  if (!secret) return process.env.VERCEL_ENV !== 'production';
  return req.headers.authorization === `Bearer ${secret}`;
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });
  if (!authorize(req)) return res.status(401).json({ error: 'Unauthorized' });

  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) return res.status(500).json({ error: 'Server misconfiguration' });

  const days = Math.min(Math.max(Number(req.query.days) || 30, 1), 365);
  const client = new Client({ connectionString: normalizePgSslMode(databaseUrl) });

  try {
    await client.connect();

    const byAgent = await client.query(
      `SELECT bot_name,
              bot_kind,
              count(*)                        AS fetches,
              count(DISTINCT path)            AS distinct_paths,
              min(occurred_at)                AS first_seen,
              max(occurred_at)                AS last_seen
         FROM request_log
        WHERE is_bot
          AND occurred_at > now() - ($1 || ' days')::interval
        GROUP BY bot_name, bot_kind
        ORDER BY count(*) DESC`,
      [days]
    );

    // Which pages the AI crawlers actually take is the interesting part: an agent that only
    // ever fetches / has not discovered the pre-rendered pages, which is a different problem
    // from an agent that never visits.
    const aiPaths = await client.query(
      `SELECT path, count(*) AS fetches, count(DISTINCT bot_name) AS agents
         FROM request_log
        WHERE is_bot
          AND bot_kind IN ('ai_training', 'ai_search')
          AND occurred_at > now() - ($1 || ' days')::interval
        GROUP BY path
        ORDER BY count(*) DESC
        LIMIT 40`,
      [days]
    );

    // Human rows are sampled, so the estimate divides by sample_rate.
    const humans = await client.query(
      `SELECT count(*)                            AS rows_logged,
              round(sum(1 / sample_rate))         AS estimated_requests,
              count(DISTINCT path)                AS distinct_paths
         FROM request_log
        WHERE NOT is_bot
          AND occurred_at > now() - ($1 || ' days')::interval`,
      [days]
    );

    const seen = new Set(byAgent.rows.map((r) => r.bot_name));
    const gate = GEO_GATE_AGENTS.map((name) => ({
      agent: name,
      fetches: Number(byAgent.rows.find((r) => r.bot_name === name)?.fetches ?? 0),
      testable: seen.has(name),
    }));

    const payload = {
      window_days: days,
      generated_at: new Date().toISOString(),
      bots: byAgent.rows,
      ai_crawler_paths: aiPaths.rows,
      humans: humans.rows[0],
      geo_gate: gate,
      geo_gate_note:
        'An agent with testable=false never fetched the site in this window. A null GEO result for that model is "not testable", not "no effect". Pre-registered in experiments/README.md section 2.',
    };

    if (req.query.format === 'text') {
      const lines: string[] = [];
      lines.push(`Bot report, last ${days} days`, '');
      lines.push('agent                     kind          fetches  paths  last seen');
      for (const r of byAgent.rows) {
        lines.push(
          `${String(r.bot_name).padEnd(25)} ${String(r.bot_kind).padEnd(13)} ${String(r.fetches).padStart(7)} ${String(r.distinct_paths).padStart(6)}  ${new Date(r.last_seen).toISOString().slice(0, 16)}`
        );
      }
      lines.push('', 'GEO gate:');
      for (const g of gate) lines.push(`  ${g.agent.padEnd(20)} ${g.testable ? `${g.fetches} fetches` : 'NEVER FETCHED — not testable'}`);
      lines.push(
        '',
        `Humans (sampled): ${humans.rows[0].rows_logged} rows logged, ~${humans.rows[0].estimated_requests} requests estimated.`
      );
      res.setHeader('Content-Type', 'text/plain; charset=utf-8');
      return res.status(200).send(lines.join('\n'));
    }

    return res.status(200).json(payload);
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unknown error';
    if (/relation "request_log" does not exist/i.test(message)) {
      return res.status(503).json({ error: 'request_log table is missing. Run scripts/028_request_log.sql.' });
    }
    return res.status(500).json({ error: message });
  } finally {
    await client.end().catch(() => {});
  }
}
