/**
 * One Serverless Function for scheduled jobs: /api/cron/retention and
 * /api/cron/email-digest. Hobby deployments allow 12 functions; these used
 * to be separate files.
 *
 * Invoke:
 *   curl -H "Authorization: Bearer $CRON_SECRET" "https://<your-domain>/api/cron/retention"
 *   curl -H "Authorization: Bearer $CRON_SECRET" "https://<your-domain>/api/cron/email-digest"
 * Vercel Cron sends the same header when CRON_SECRET is set.
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import { pgClient } from '../../lib/db';
import { enqueueCareCommitteeReminders, enqueueWeeklyEmails, processOutbox } from '../../lib/email';

function actionName(req: VercelRequest): string {
  const raw = req.query.action;
  return typeof raw === 'string' ? raw : Array.isArray(raw) ? raw[0] || '' : '';
}

function authorize(req: VercelRequest): boolean {
  const secret = process.env.CRON_SECRET;
  if (!secret) return process.env.VERCEL_ENV !== 'production';
  return req.headers.authorization === `Bearer ${secret}`;
}

async function handleRetention(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });
  if (!authorize(req)) return res.status(401).json({ error: 'Unauthorized' });
  if (!process.env.DATABASE_URL) return res.status(500).json({ error: 'Server misconfiguration' });

  const client = pgClient();
  try {
    await client.connect();
    const rolled = await client.query('SELECT roll_up_search_queries() AS n');
    const queries = await client.query('SELECT purge_old_search_queries() AS n');
    const logs = await client.query('SELECT purge_old_request_log() AS n');
    const reminders = await enqueueCareCommitteeReminders(client);
    const send = reminders
      ? await processOutbox(client, 50, { kind: 'care_committee_reminder' })
      : { sent: 0, failed: 0, skipped: 0 };
    return res.status(200).json({
      rolled_up: rolled.rows[0]?.n ?? 0,
      search_queries_nulled: queries.rows[0]?.n ?? 0,
      request_log_deleted: logs.rows[0]?.n ?? 0,
      committee_reminders: reminders,
      reminder_send: send,
    });
  } catch (err) {
    console.error('retention error', err);
    return res.status(500).json({ error: 'Retention failed' });
  } finally {
    await client.end().catch(() => {});
  }
}

async function handleEmailDigest(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });
  if (!authorize(req)) return res.status(401).json({ error: 'Unauthorized' });
  if (!process.env.DATABASE_URL) return res.status(500).json({ error: 'Server misconfiguration' });

  const client = pgClient();
  try {
    await client.connect();
    const queued = await enqueueWeeklyEmails(client);
    const send = await processOutbox(client, 200);
    return res.status(200).json({ queued, send });
  } catch (err) {
    console.error('email-digest error', err);
    return res.status(500).json({ error: 'Digest failed' });
  } finally {
    await client.end().catch(() => {});
  }
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  switch (actionName(req)) {
    case 'retention':
      return handleRetention(req, res);
    case 'email-digest':
      return handleEmailDigest(req, res);
    default:
      return res.status(404).json({ error: 'Not found' });
  }
}
