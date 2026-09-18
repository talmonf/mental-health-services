/**
 * POST /api/admin/updates
 * Publish a site-change note and enqueue immediate emails.
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import { getAuthFromRequest, originAllowed, parseJsonBody, setAuthCors } from '../../lib/auth';
import { pgClient } from '../../lib/db';
import { enqueueImmediateEmails, processOutbox } from '../../lib/email';
import { userIsAdmin } from '../../lib/users';

export default async function handler(req: VercelRequest, res: VercelResponse) {
  setAuthCors(req, res);
  if (req.method === 'OPTIONS') return res.status(204).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
  if (!originAllowed(req)) return res.status(403).json({ error: 'Forbidden' });

  const jwtUser = await getAuthFromRequest(req);
  if (!jwtUser) return res.status(401).json({ error: 'Unauthorized' });

  const body = parseJsonBody(req);
  if (!body) return res.status(400).json({ error: 'Invalid JSON' });
  const title = typeof body.title === 'string' ? body.title.trim() : '';
  const text = typeof body.body === 'string' ? body.body.trim() : '';
  if (!title || !text) return res.status(400).json({ error: 'Title and body are required' });
  if (!process.env.DATABASE_URL) return res.status(500).json({ error: 'Server misconfiguration' });

  const client = pgClient();
  try {
    await client.connect();
    if (!(await userIsAdmin(client, jwtUser.id))) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    const inserted = await client.query(
      `INSERT INTO site_updates (title, body, published_by)
       VALUES ($1, $2, $3)
       RETURNING id::text, title, body, published_at`,
      [title.slice(0, 200), text.slice(0, 8000), jwtUser.id]
    );
    const update = inserted.rows[0];
    const queued = await enqueueImmediateEmails(client, update.id);
    const send = await processOutbox(client);
    return res.status(201).json({ update, queued, send });
  } catch (err) {
    console.error('admin updates error', err);
    return res.status(500).json({ error: 'Failed to publish update' });
  } finally {
    await client.end().catch(() => {});
  }
}
