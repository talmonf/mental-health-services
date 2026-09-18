/**
 * GET / PATCH /api/auth/me
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import {
  getAuthFromRequest,
  originAllowed,
  parseJsonBody,
  setAuthCors,
} from '../../lib/auth';
import { pgClient } from '../../lib/db';
import {
  isEmailPreference,
  isQualification,
  publicUserFromRow,
  USER_PUBLIC_COLUMNS,
} from '../../lib/users';

export default async function handler(req: VercelRequest, res: VercelResponse) {
  setAuthCors(req, res);
  if (req.method === 'OPTIONS') return res.status(204).end();
  if (req.method !== 'GET' && req.method !== 'PATCH') {
    return res.status(405).json({ error: 'Method not allowed' });
  }
  if (req.method === 'PATCH' && !originAllowed(req)) {
    return res.status(403).json({ error: 'Forbidden' });
  }

  const jwtUser = await getAuthFromRequest(req);
  if (!jwtUser) return res.status(401).json({ error: 'Unauthorized' });
  if (!process.env.DATABASE_URL) return res.status(500).json({ error: 'Server misconfiguration' });

  const client = pgClient();
  try {
    await client.connect();
    if (req.method === 'GET') {
      const { rows } = await client.query(
        `SELECT ${USER_PUBLIC_COLUMNS} FROM users WHERE id = $1`,
        [jwtUser.id]
      );
      if (!rows[0]) return res.status(401).json({ error: 'Unauthorized' });
      return res.status(200).json({ user: publicUserFromRow(rows[0]) });
    }

    const body = parseJsonBody(req);
    if (!body) return res.status(400).json({ error: 'Invalid JSON' });

    const country = typeof body.country === 'string' ? body.country.trim() : null;
    const cityRaw = body.city;
    const city =
      cityRaw === null || cityRaw === undefined
        ? undefined
        : typeof cityRaw === 'string'
          ? cityRaw.trim()
          : null;
    const organization = typeof body.organization === 'string' ? body.organization.trim() : null;
    const title = typeof body.title === 'string' ? body.title.trim() : null;
    const qualification = isQualification(body.qualification) ? body.qualification : null;
    const emailPreference = isEmailPreference(body.emailPreference) ? body.emailPreference : null;

    if (country !== null && country.length === 0) {
      return res.status(400).json({ error: 'Country is required' });
    }
    if (organization !== null && organization.length === 0) {
      return res.status(400).json({ error: 'Organization is required' });
    }
    if (title !== null && title.length === 0) {
      return res.status(400).json({ error: 'Title is required' });
    }

    const { rows } = await client.query(
      `UPDATE users SET
         country = COALESCE($2, country),
         city = CASE WHEN $3::text = '__omit' THEN city WHEN $3 = '' THEN NULL ELSE $3 END,
         qualification = COALESCE($4, qualification),
         organization = COALESCE($5, organization),
         title = COALESCE($6, title),
         email_preference = COALESCE($7, email_preference),
         updated_at = now()
       WHERE id = $1
       RETURNING ${USER_PUBLIC_COLUMNS}`,
      [
        jwtUser.id,
        country ? country.slice(0, 100) : null,
        city === undefined ? '__omit' : city ? city.slice(0, 100) : '',
        qualification,
        organization ? organization.slice(0, 200) : null,
        title ? title.slice(0, 200) : null,
        emailPreference,
      ]
    );
    if (!rows[0]) return res.status(401).json({ error: 'Unauthorized' });
    return res.status(200).json({ user: publicUserFromRow(rows[0]) });
  } catch (err) {
    console.error('me error', err);
    return res.status(500).json({ error: 'Failed' });
  } finally {
    await client.end().catch(() => {});
  }
}
