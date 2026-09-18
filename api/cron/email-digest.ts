/**
 * GET /api/cron/email-digest
 *
 * Weekly: enqueue one digest per verified weekly subscriber when there is something new,
 * then send pending outbox rows.
 *
 * Invoke: curl -H "Authorization: Bearer $CRON_SECRET" "https://<your-domain>/api/cron/email-digest"
 * Vercel Cron sends the same header when CRON_SECRET is set.
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import { pgClient } from '../../lib/db';
import { enqueueWeeklyEmails, processOutbox } from '../../lib/email';

function authorize(req: VercelRequest): boolean {
  const secret = process.env.CRON_SECRET;
  if (!secret) return process.env.VERCEL_ENV !== 'production';
  return req.headers.authorization === `Bearer ${secret}`;
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
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
