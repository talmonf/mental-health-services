/**
 * POST /api/auth/login
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import {
  clientKey,
  originAllowed,
  parseJsonBody,
  rateLimit,
  setAuthCors,
  setSessionCookie,
  signSession,
  normalizeEmail,
  verifyPassword,
} from '../../lib/auth';
import { pgClient } from '../../lib/db';
import { isAdminEmail, publicUserFromRow, USER_PUBLIC_COLUMNS } from '../../lib/users';

export default async function handler(req: VercelRequest, res: VercelResponse) {
  setAuthCors(req, res);
  if (req.method === 'OPTIONS') return res.status(204).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
  if (!originAllowed(req)) return res.status(403).json({ error: 'Forbidden' });

  const body = parseJsonBody(req);
  if (!body) return res.status(400).json({ error: 'Invalid JSON' });

  const email = normalizeEmail(body.email);
  const password = typeof body.password === 'string' ? body.password : '';
  const ip = clientKey(req);
  if (!rateLimit(`login:${ip}:${email || 'none'}`, 10, 15 * 60 * 1000)) {
    return res.status(429).json({ error: 'Too many attempts' });
  }
  if (!email || password.length < 1) {
    return res.status(400).json({ error: 'Invalid email or password' });
  }
  if (!process.env.DATABASE_URL || !process.env.AUTH_SECRET) {
    return res.status(500).json({ error: 'Server misconfiguration' });
  }

  const client = pgClient();
  try {
    await client.connect();
    const { rows } = await client.query(
      `SELECT password_hash, ${USER_PUBLIC_COLUMNS} FROM users WHERE email = $1`,
      [email]
    );
    const row = rows[0];
    if (!row || !(await verifyPassword(password, row.password_hash))) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }
    if (!row.is_admin && isAdminEmail(email)) {
      await client.query(`UPDATE users SET is_admin = true, updated_at = now() WHERE id = $1`, [row.id]);
      row.is_admin = true;
    }
    const user = publicUserFromRow(row);
    const token = await signSession({ id: user.id, email: user.email, isAdmin: user.isAdmin });
    setSessionCookie(res, token);
    return res.status(200).json({ user });
  } catch (err) {
    console.error('login error', err);
    return res.status(500).json({ error: 'Login failed' });
  } finally {
    await client.end().catch(() => {});
  }
}
