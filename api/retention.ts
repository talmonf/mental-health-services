/**
 * GET /api/retention
 *
 * Nightly purge: roll up search queries, then null events.search_query older than 90 days
 * and delete request_log older than 90 days. See scripts/030_retention.sql.
 *
 * Invoke: curl -H "Authorization: Bearer $CRON_SECRET" "https://<your-domain>/api/retention"
 * Vercel Cron sends the same header when CRON_SECRET is set.
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import { Client } from 'pg';

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

  const client = new Client({ connectionString: normalizePgSslMode(databaseUrl) });
  try {
    await client.connect();
    const rolled = await client.query('SELECT roll_up_search_queries() AS n');
    const queries = await client.query('SELECT purge_old_search_queries() AS n');
    const logs = await client.query('SELECT purge_old_request_log() AS n');
    return res.status(200).json({
      rolled_up: rolled.rows[0]?.n ?? 0,
      search_queries_nulled: queries.rows[0]?.n ?? 0,
      request_log_deleted: logs.rows[0]?.n ?? 0,
    });
  } catch (err) {
    console.error('retention error', err);
    return res.status(500).json({ error: 'Retention failed' });
  } finally {
    await client.end().catch(() => {});
  }
}
