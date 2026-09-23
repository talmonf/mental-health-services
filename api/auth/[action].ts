/**
 * One Serverless Function for all /api/auth/* routes.
 *
 * Hobby deployments allow 12 functions. Separate files for login/register/session/…
 * exceeded that (the build succeeded, then "Deploying outputs" failed).
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import {
  clearCareStepupCookie,
  clearSessionCookie,
  clientKey,
  getAuthFromRequest,
  hashPassword,
  invalidateSessions,
  normalizeEmail,
  originAllowed,
  parseJsonBody,
  passwordPolicyError,
  rateLimit,
  sessionStillValid,
  setAuthCors,
  setSessionCookie,
  shouldRefreshSession,
  signSession,
  verifyPassword,
} from '../../lib/auth';
import { appUrl, pgClient } from '../../lib/db';
import { enqueueConfirmEmail, enqueueRegisterAdminEmails, processOutbox } from '../../lib/email';
import { findValidToken } from '../../lib/tokens';
import {
  isAdminEmail,
  isEmailPreference,
  isFoundVia,
  isGender,
  isQualification,
  licenseNumberError,
  parseLicenseNumber,
  publicUserFromRow,
  touchLastAccess,
  USER_PUBLIC_COLUMNS,
} from '../../lib/users';

function actionName(req: VercelRequest): string {
  const raw = req.query.action;
  return typeof raw === 'string' ? raw : Array.isArray(raw) ? raw[0] || '' : '';
}

function jwtFallbackUser(jwtUser: { id: string; email: string; isAdmin: boolean }) {
  return {
    id: jwtUser.id,
    email: jwtUser.email,
    isAdmin: jwtUser.isAdmin,
    country: '',
    city: null,
    qualification: 'other',
    licenseNumber: null,
    gender: null,
    organization: '',
    title: '',
    foundVia: 'other',
    foundViaOther: null,
    emailPreference: 'none',
    emailVerified: false,
    hideIntro: false,
  };
}

async function handleRegister(req: VercelRequest, res: VercelResponse) {
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
  const licenseNumber = parseLicenseNumber(body.licenseNumber);
  const foundViaOther = typeof body.foundViaOther === 'string' ? body.foundViaOther.trim() : '';
  const consent = body.consent === true;
  const emailPreference = isEmailPreference(body.emailPreference) ? body.emailPreference : 'weekly';

  if (!email) return res.status(400).json({ error: 'Invalid email' });
  const weakPassword = passwordPolicyError(password);
  if (weakPassword) return res.status(400).json({ error: weakPassword });
  if (!country) return res.status(400).json({ error: 'Country is required' });
  if (!isQualification(body.qualification)) return res.status(400).json({ error: 'Invalid qualification' });
  const licenseErr = licenseNumberError(body.qualification, licenseNumber);
  if (licenseErr) return res.status(400).json({ error: licenseErr });
  if (!organization) return res.status(400).json({ error: 'Organization is required' });
  if (!title) return res.status(400).json({ error: 'Title is required' });
  if (!isFoundVia(body.foundVia)) return res.status(400).json({ error: 'Invalid foundVia' });
  if (body.foundVia === 'other' && !foundViaOther) {
    return res.status(400).json({ error: 'Please describe how you found the site' });
  }
  if (!consent) return res.status(400).json({ error: 'Consent is required' });
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
         email, password_hash, is_admin, country, city, qualification, license_number,
         organization, title, found_via, found_via_other, email_preference
       ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)
       RETURNING ${USER_PUBLIC_COLUMNS}`,
      [
        email,
        passwordHash,
        admin,
        country.slice(0, 100),
        city ? city.slice(0, 100) : null,
        body.qualification,
        licenseNumber || null,
        organization.slice(0, 200),
        title.slice(0, 200),
        body.foundVia,
        body.foundVia === 'other' ? foundViaOther.slice(0, 200) : null,
        emailPreference,
      ]
    );
    const user = publicUserFromRow(inserted.rows[0]);
    await enqueueConfirmEmail(client, { id: user.id, email: user.email });
    try {
      await enqueueRegisterAdminEmails(client, {
        email: user.email,
        country: user.country,
        city: user.city,
        qualification: user.qualification,
        licenseNumber: user.licenseNumber,
        organization: user.organization,
        title: user.title,
        foundVia: user.foundVia,
        foundViaOther: user.foundViaOther,
        emailPreference: user.emailPreference,
      });
    } catch (err) {
      console.error('register admin email failed', err);
    }
    const send = await processOutbox(client, 20, { userId: user.id, kind: 'confirm' });
    await processOutbox(client);
    await touchLastAccess(client, user.id);
    const token = await signSession({ id: user.id, email: user.email, isAdmin: user.isAdmin });
    setSessionCookie(res, token);
    return res.status(201).json({ user, send });
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

async function handleLogin(req: VercelRequest, res: VercelResponse) {
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
    await touchLastAccess(client, user.id);
    if (!user.emailVerified) {
      const pending = await client.query(
        `SELECT 1 FROM email_outbox WHERE user_id = $1 AND kind = 'confirm' AND sent_at IS NULL LIMIT 1`,
        [user.id]
      );
      if (pending.rows.length) await processOutbox(client);
    }
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

async function handleLogout(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
  if (!originAllowed(req)) return res.status(403).json({ error: 'Forbidden' });
  const jwtUser = await getAuthFromRequest(req);
  if (jwtUser && process.env.DATABASE_URL) {
    const client = pgClient();
    try {
      await client.connect();
      if (await sessionStillValid(client, jwtUser)) {
        await invalidateSessions(client, jwtUser.id);
      }
    } catch (err) {
      console.error('logout invalidate error', err);
    } finally {
      await client.end().catch(() => {});
    }
  }
  clearSessionCookie(res);
  clearCareStepupCookie(res);
  return res.status(200).json({ ok: true });
}

async function handleSession(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });

  const jwtUser = await getAuthFromRequest(req);
  if (!jwtUser) return res.status(200).json({ user: null });

  if (!process.env.DATABASE_URL) {
    return res.status(200).json({ user: jwtFallbackUser(jwtUser) });
  }

  const client = pgClient();
  try {
    await client.connect();
    const { rows } = await client.query(`SELECT ${USER_PUBLIC_COLUMNS} FROM users WHERE id = $1`, [jwtUser.id]);
    if (!rows[0]) return res.status(200).json({ user: null });
    if (!rows[0].is_admin && isAdminEmail(rows[0].email)) {
      await client.query(`UPDATE users SET is_admin = true, updated_at = now() WHERE id = $1`, [rows[0].id]);
      rows[0].is_admin = true;
    }
    if (!(await sessionStillValid(client, jwtUser))) {
      clearSessionCookie(res);
      clearCareStepupCookie(res);
      return res.status(200).json({ user: null });
    }
    const user = publicUserFromRow(rows[0]);
    await touchLastAccess(client, user.id);
    if (shouldRefreshSession(jwtUser)) {
      const token = await signSession({ id: user.id, email: user.email, isAdmin: user.isAdmin });
      setSessionCookie(res, token);
    }
    return res.status(200).json({ user });
  } catch (err) {
    console.error('session error', err);
    return res.status(200).json({ user: jwtFallbackUser(jwtUser) });
  } finally {
    await client.end().catch(() => {});
  }
}

async function handleMe(req: VercelRequest, res: VercelResponse) {
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
    if (!(await sessionStillValid(client, jwtUser))) {
      clearSessionCookie(res);
      clearCareStepupCookie(res);
      return res.status(401).json({ error: 'Unauthorized' });
    }
    if (req.method === 'GET') {
      const { rows } = await client.query(`SELECT ${USER_PUBLIC_COLUMNS} FROM users WHERE id = $1`, [jwtUser.id]);
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
    const hideIntro = typeof body.hideIntro === 'boolean' ? body.hideIntro : null;
    const licenseRaw = body.licenseNumber;
    const licenseNumber =
      licenseRaw === null || licenseRaw === undefined
        ? undefined
        : typeof licenseRaw === 'string'
          ? licenseRaw.trim()
          : null;
    const genderRaw = body.gender;
    const gender =
      genderRaw === undefined
        ? undefined
        : genderRaw === null || genderRaw === ''
          ? ''
          : isGender(genderRaw)
            ? genderRaw
            : null;
    if (gender === null) return res.status(400).json({ error: 'Invalid gender' });

    if (country !== null && country.length === 0) {
      return res.status(400).json({ error: 'Country is required' });
    }
    if (organization !== null && organization.length === 0) {
      return res.status(400).json({ error: 'Organization is required' });
    }
    if (title !== null && title.length === 0) {
      return res.status(400).json({ error: 'Title is required' });
    }

    const current = await client.query(
      `SELECT qualification, license_number FROM users WHERE id = $1`,
      [jwtUser.id]
    );
    if (!current.rows[0]) return res.status(401).json({ error: 'Unauthorized' });
    const nextQual = qualification || String(current.rows[0].qualification || '');
    const nextLicense =
      licenseNumber === undefined
        ? parseLicenseNumber(current.rows[0].license_number)
        : licenseNumber || '';
    const licenseErr = licenseNumberError(nextQual, nextLicense);
    if (licenseErr) return res.status(400).json({ error: licenseErr });

    const { rows } = await client.query(
      `UPDATE users SET
         country = COALESCE($2, country),
         city = CASE WHEN $3::text = '__omit' THEN city WHEN $3 = '' THEN NULL ELSE $3 END,
         qualification = COALESCE($4, qualification),
         organization = COALESCE($5, organization),
         title = COALESCE($6, title),
         email_preference = COALESCE($7, email_preference),
         hide_intro = COALESCE($8::boolean, hide_intro),
         license_number = CASE WHEN $9::text = '__omit' THEN license_number WHEN $9 = '' THEN NULL ELSE $9 END,
         gender = CASE WHEN $10::text = '__omit' THEN gender WHEN $10 = '' THEN NULL ELSE $10 END,
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
        hideIntro,
        licenseNumber === undefined ? '__omit' : nextLicense,
        gender === undefined ? '__omit' : gender,
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

async function handleResendConfirm(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
  if (!originAllowed(req)) return res.status(403).json({ error: 'Forbidden' });

  const jwtUser = await getAuthFromRequest(req);
  if (!jwtUser) return res.status(401).json({ error: 'Unauthorized' });
  if (!rateLimit(`resend-confirm:${jwtUser.id}`, 3, 60 * 60 * 1000)) {
    return res.status(429).json({ error: 'Too many attempts' });
  }
  if (!process.env.DATABASE_URL) return res.status(500).json({ error: 'Server misconfiguration' });

  const client = pgClient();
  try {
    await client.connect();
    const { rows } = await client.query(`SELECT ${USER_PUBLIC_COLUMNS} FROM users WHERE id = $1`, [jwtUser.id]);
    const row = rows[0];
    if (!row) return res.status(401).json({ error: 'Unauthorized' });
    const user = publicUserFromRow(row);
    if (user.emailVerified) return res.status(400).json({ error: 'Email already verified' });
    await enqueueConfirmEmail(client, { id: user.id, email: user.email });
    const send = await processOutbox(client, 20, { userId: user.id, kind: 'confirm' });
    if (!send.sent) {
      const last = await client.query(
        `SELECT error FROM email_outbox
          WHERE user_id = $1 AND kind = 'confirm'
          ORDER BY created_at DESC
          LIMIT 1`,
        [user.id]
      );
      console.error('resend-confirm failed', { send, error: last.rows[0]?.error || null });
      return res.status(503).json({ error: 'Email could not be sent', send });
    }
    return res.status(200).json({ send });
  } catch (err) {
    console.error('resend-confirm error', err);
    return res.status(500).json({ error: 'Failed to send confirmation email' });
  } finally {
    await client.end().catch(() => {});
  }
}

async function handleConfirm(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });
  const raw = typeof req.query.token === 'string' ? req.query.token : '';
  const dest = (ok: boolean) => `${appUrl()}/?confirmed=${ok ? '1' : 'invalid'}`;
  if (!raw || !process.env.DATABASE_URL) {
    res.statusCode = 302;
    res.setHeader('Location', dest(false));
    return res.end();
  }

  const client = pgClient();
  try {
    await client.connect();
    const token = await findValidToken(client, raw, 'confirm');
    if (!token) {
      res.statusCode = 302;
      res.setHeader('Location', dest(false));
      return res.end();
    }
    await client.query(`UPDATE email_tokens SET consumed_at = now() WHERE id = $1 AND consumed_at IS NULL`, [
      token.id,
    ]);
    await client.query(
      `UPDATE users SET email_verified_at = COALESCE(email_verified_at, now()), updated_at = now() WHERE id = $1`,
      [token.user_id]
    );
    res.statusCode = 302;
    res.setHeader('Location', dest(true));
    return res.end();
  } catch (err) {
    console.error('confirm error', err);
    res.statusCode = 302;
    res.setHeader('Location', dest(false));
    return res.end();
  } finally {
    await client.end().catch(() => {});
  }
}

async function handleUnsubscribe(req: VercelRequest, res: VercelResponse) {
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
    await client.query(`UPDATE users SET email_preference = 'none', updated_at = now() WHERE id = $1`, [
      token.user_id,
    ]);
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

async function handleDeleteAccount(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
  if (!originAllowed(req)) return res.status(403).json({ error: 'Forbidden' });

  const jwtUser = await getAuthFromRequest(req);
  if (!jwtUser) return res.status(401).json({ error: 'Unauthorized' });
  if (!process.env.DATABASE_URL || !process.env.AUTH_SECRET) {
    return res.status(500).json({ error: 'Server misconfiguration' });
  }

  if (!rateLimit(`delete-account:${jwtUser.id}`, 5, 60 * 60 * 1000)) {
    return res.status(429).json({ error: 'Too many attempts' });
  }

  const body = parseJsonBody(req);
  if (!body || body.confirm !== true) return res.status(400).json({ error: 'Confirmation required' });
  const password = typeof body.password === 'string' ? body.password : '';
  if (!password) return res.status(400).json({ error: 'Password is required' });

  const client = pgClient();
  try {
    await client.connect();
    if (!(await sessionStillValid(client, jwtUser))) {
      clearSessionCookie(res);
      clearCareStepupCookie(res);
      return res.status(401).json({ error: 'Unauthorized' });
    }
    const { rows } = await client.query(`SELECT password_hash FROM users WHERE id = $1`, [jwtUser.id]);
    if (!rows[0] || !(await verifyPassword(password, rows[0].password_hash))) {
      return res.status(401).json({ error: 'Invalid password' });
    }
    await client.query(`DELETE FROM users WHERE id = $1`, [jwtUser.id]);
    clearSessionCookie(res);
    clearCareStepupCookie(res);
    return res.status(200).json({ ok: true });
  } catch (err) {
    console.error('delete-account error', err);
    return res.status(500).json({ error: 'Failed' });
  } finally {
    await client.end().catch(() => {});
  }
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  const action = actionName(req);
  const skipCors = action === 'confirm' || action === 'unsubscribe';
  if (!skipCors) {
    setAuthCors(req, res);
    if (req.method === 'OPTIONS') return res.status(204).end();
  }

  switch (action) {
    case 'register':
      return handleRegister(req, res);
    case 'login':
      return handleLogin(req, res);
    case 'logout':
      return handleLogout(req, res);
    case 'session':
      return handleSession(req, res);
    case 'me':
      return handleMe(req, res);
    case 'confirm':
      return handleConfirm(req, res);
    case 'resend-confirm':
      return handleResendConfirm(req, res);
    case 'unsubscribe':
      return handleUnsubscribe(req, res);
    case 'delete-account':
      return handleDeleteAccount(req, res);
    default:
      if (!skipCors) setAuthCors(req, res);
      return res.status(404).json({ error: 'Not found' });
  }
}
