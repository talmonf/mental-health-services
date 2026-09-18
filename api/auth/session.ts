/**
 * GET /api/auth/session
 *
 * Returns the current user. Rewrites the JWT cookie when iat is older than 30 minutes
 * (rolling 2-hour idle expiry). Anonymous visitors get { user: null } so the SPA can
 * ping this on every load without a 401 in the console.
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import {
  getAuthFromRequest,
  setAuthCors,
  setSessionCookie,
  shouldRefreshSession,
  signSession,
} from '../../lib/auth';
import { pgClient } from '../../lib/db';
import { isAdminEmail, publicUserFromRow, USER_PUBLIC_COLUMNS } from '../../lib/users';

export default async function handler(req: VercelRequest, res: VercelResponse) {
  setAuthCors(req, res);
  if (req.method === 'OPTIONS') return res.status(204).end();
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });

  const jwtUser = await getAuthFromRequest(req);
  if (!jwtUser) return res.status(200).json({ user: null });

  if (!process.env.DATABASE_URL) {
    return res.status(200).json({
      user: {
        id: jwtUser.id,
        email: jwtUser.email,
        isAdmin: jwtUser.isAdmin,
        country: '',
        city: null,
        qualification: 'other',
        organization: '',
        title: '',
        foundVia: 'other',
        foundViaOther: null,
        emailPreference: 'none',
        emailVerified: false,
      },
    });
  }

  const client = pgClient();
  try {
    await client.connect();
    const { rows } = await client.query(
      `SELECT ${USER_PUBLIC_COLUMNS} FROM users WHERE id = $1`,
      [jwtUser.id]
    );
    if (!rows[0]) return res.status(200).json({ user: null });
    if (!rows[0].is_admin && isAdminEmail(rows[0].email)) {
      await client.query(`UPDATE users SET is_admin = true, updated_at = now() WHERE id = $1`, [rows[0].id]);
      rows[0].is_admin = true;
    }
    const user = publicUserFromRow(rows[0]);
    if (shouldRefreshSession(jwtUser)) {
      const token = await signSession({ id: user.id, email: user.email, isAdmin: user.isAdmin });
      setSessionCookie(res, token);
    }
    return res.status(200).json({ user });
  } catch (err) {
    console.error('session error', err);
    return res.status(200).json({
      user: {
        id: jwtUser.id,
        email: jwtUser.email,
        isAdmin: jwtUser.isAdmin,
        country: '',
        city: null,
        qualification: 'other',
        organization: '',
        title: '',
        foundVia: 'other',
        foundViaOther: null,
        emailPreference: 'none',
        emailVerified: false,
      },
    });
  } finally {
    await client.end().catch(() => {});
  }
}
