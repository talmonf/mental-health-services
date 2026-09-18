/**
 * POST /api/auth/logout
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import { clearSessionCookie, originAllowed, setAuthCors } from '../../lib/auth';

export default async function handler(req: VercelRequest, res: VercelResponse) {
  setAuthCors(req, res);
  if (req.method === 'OPTIONS') return res.status(204).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
  if (!originAllowed(req)) return res.status(403).json({ error: 'Forbidden' });
  clearSessionCookie(res);
  return res.status(200).json({ ok: true });
}
