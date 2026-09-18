/**
 * GET /api/auth/unsubscribe?token=
 * Sets email_preference to none. No login required.
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import { appUrl, pgClient } from '../../lib/db';
import { findValidToken } from '../../lib/tokens';

export default async function handler(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });
  const raw = typeof req.query.token === 'string' ? req.query.token : '';
  const dest = (ok: boolean) => `${appUrl()}/?unsubscribed=${ok ? '1' : 'invalid'}`;
  if (!raw || !process.env.DATABASE_URL) {
    res.statusCode = 302;
    res.setHeader('Location', dest(false));
    return res.end();
  }

  const client = pgClient();
  try {
    await client.connect();
    const token = await findValidToken(client, raw, 'unsubscribe');
    if (!token) {
      res.statusCode = 302;
      res.setHeader('Location', dest(false));
      return res.end();
    }
    await client.query(
      `UPDATE users SET email_preference = 'none', updated_at = now() WHERE id = $1`,
      [token.user_id]
    );
    res.statusCode = 302;
    res.setHeader('Location', dest(true));
    return res.end();
  } catch (err) {
    console.error('unsubscribe error', err);
    res.statusCode = 302;
    res.setHeader('Location', dest(false));
    return res.end();
  } finally {
    await client.end().catch(() => {});
  }
}
