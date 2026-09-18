/**
 * POST /api/auth/register
 * Creates an optional account, sets the JWT cookie, enqueues a confirm email.
 * The directory stays usable without this.
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import {
  clientKey,
  hashPassword,
  originAllowed,
  parseJsonBody,
  rateLimit,
  setAuthCors,
  setSessionCookie,
  signSession,
  normalizeEmail,
} from '../../lib/auth';
import { pgClient } from '../../lib/db';
import { enqueueConfirmEmail, processOutbox } from '../../lib/email';
import {
  isAdminEmail,
  isEmailPreference,
  isFoundVia,
  isQualification,
  publicUserFromRow,
  USER_PUBLIC_COLUMNS,
} from '../../lib/users';

export default async function handler(req: VercelRequest, res: VercelResponse) {
  setAuthCors(req, res);
  if (req.method === 'OPTIONS') return res.status(204).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
  if (!originAllowed(req)) return res.status(403).json({ error: 'Forbidden' });

  const ip = clientKey(req);
  if (!rateLimit(`register:${ip}`, 8, 60 * 60 * 1000)) {
    return res.status(429).json({ error: 'Too many attempts' });
  }

  const body = parseJsonBody(req);
  if (!body) return res.status(400).json({ error: 'Invalid JSON' });

  const email = normalizeEmail(body.email);
  const password = typeof body.password === 'string' ? body.password : '';
  const country = typeof body.country === 'string' ? body.country.trim() : '';
  const city = typeof body.city === 'string' ? body.city.trim() : '';
  const organization = typeof body.organization === 'string' ? body.organization.trim() : '';
  const title = typeof body.title === 'string' ? body.title.trim() : '';
  const foundViaOther = typeof body.foundViaOther === 'string' ? body.foundViaOther.trim() : '';
  const consent = body.consent === true;
  const emailPreference = isEmailPreference(body.emailPreference) ? body.emailPreference : 'none';

  if (!email) return res.status(400).json({ error: 'Invalid email' });
  if (password.length < 8) return res.status(400).json({ error: 'Password must be at least 8 characters' });
  if (!country) return res.status(400).json({ error: 'Country is required' });
  if (!isQualification(body.qualification)) return res.status(400).json({ error: 'Invalid qualification' });
  if (!organization) return res.status(400).json({ error: 'Organization is required' });
  if (!title) return res.status(400).json({ error: 'Title is required' });
  if (!isFoundVia(body.foundVia)) return res.status(400).json({ error: 'Invalid foundVia' });
  if (body.foundVia === 'other' && !foundViaOther) {
    return res.status(400).json({ error: 'Please describe how you found the site' });
  }
  if (!consent) {
    return res.status(400).json({ error: 'Consent is required' });
  }

  if (!process.env.DATABASE_URL || !process.env.AUTH_SECRET) {
    return res.status(500).json({ error: 'Server misconfiguration' });
  }

  const passwordHash = await hashPassword(password);
  const admin = isAdminEmail(email);
  const client = pgClient();
  try {
    await client.connect();
    const inserted = await client.query(
      `INSERT INTO users (
         email, password_hash, is_admin, country, city, qualification,
         organization, title, found_via, found_via_other, email_preference
       ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)
       RETURNING ${USER_PUBLIC_COLUMNS}`,
      [
        email,
        passwordHash,
        admin,
        country.slice(0, 100),
        city ? city.slice(0, 100) : null,
        body.qualification,
        organization.slice(0, 200),
        title.slice(0, 200),
        body.foundVia,
        body.foundVia === 'other' ? foundViaOther.slice(0, 200) : null,
        emailPreference,
      ]
    );
    const user = publicUserFromRow(inserted.rows[0]);
    await enqueueConfirmEmail(client, { id: user.id, email: user.email });
    await processOutbox(client);
    const token = await signSession({ id: user.id, email: user.email, isAdmin: user.isAdmin });
    setSessionCookie(res, token);
    return res.status(201).json({ user });
  } catch (err) {
    const e = err as { code?: string };
    if (e?.code === '23505') {
      return res.status(409).json({ error: 'An account with this email already exists' });
    }
    console.error('register error', err);
    return res.status(500).json({ error: 'Registration failed' });
  } finally {
    await client.end().catch(() => {});
  }
}
