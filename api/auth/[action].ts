/**
 * One Serverless Function for all /api/auth/* routes.
 *
 * Hobby deployments allow 12 functions. Separate files for login/register/session/…
 * exceeded that (the build succeeded, then "Deploying outputs" failed).
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import {
  clearCareStepupCookie,
  clearOAuthCookie,
  clearResetCookie,
  clearSessionCookie,
  clientKey,
  getAuthFromRequest,
  getOAuthStateFromRequest,
  hashPassword,
  invalidateSessions,
  normalizeEmail,
  originAllowed,
  parseJsonBody,
  passwordPolicyError,
  rateLimit,
  readResetCookie,
  sessionStillValid,
  setAuthCors,
  setOAuthCookie,
  setResetCookie,
  setSessionCookie,
  shouldRefreshSession,
  signOAuthState,
  signSession,
  verifyPassword,
} from '../../lib/auth';
import { appUrl, pgClient } from '../../lib/db';
import {
  enqueueConfirmEmail,
  enqueueRegisterAdminEmails,
  enqueueResetEmail,
  processOutbox,
} from '../../lib/email';
import {
  codeChallenge,
  exchangeGoogleCode,
  googleAuthorizeUrl,
  newCodeVerifier,
  newOAuthState,
} from '../../lib/google-oauth';
import { consumeUserTokens, findValidToken } from '../../lib/tokens';
import {
  isAdminEmail,
  isEmailPreference,
  isFoundVia,
  isGender,
  isQualification,
  licenseNumberError,
  parseLicenseNumber,
  passwordChangedAfterJwt,
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
    hasPassword: true,
    hasGoogle: false,
    profileComplete: true,
    passwordActionRequired: false,
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
         organization, title, found_via, found_via_other, email_preference,
         password_changed_at, profile_completed_at
       ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12, now(), now())
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
    if (!row || typeof row.password_hash !== 'string' || !(await verifyPassword(password, row.password_hash))) {
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
    if (!(await sessionStillValid(client, jwtUser)) || passwordChangedAfterJwt(rows[0], jwtUser.iat)) {
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
    const sessionRow = await client.query(`SELECT ${USER_PUBLIC_COLUMNS} FROM users WHERE id = $1`, [jwtUser.id]);
    if (!sessionRow.rows[0]) return res.status(401).json({ error: 'Unauthorized' });
    if (
      !(await sessionStillValid(client, jwtUser)) ||
      passwordChangedAfterJwt(sessionRow.rows[0], jwtUser.iat)
    ) {
      clearSessionCookie(res);
      clearCareStepupCookie(res);
      return res.status(401).json({ error: 'Unauthorized' });
    }
    if (req.method === 'GET') {
      return res.status(200).json({ user: publicUserFromRow(sessionRow.rows[0]) });
    }

    const body = parseJsonBody(req);
    if (!body) return res.status(400).json({ error: 'Invalid JSON' });
    if (sessionRow.rows[0].profile_completed_at == null) {
      const tryingProfile =
        typeof body.country === 'string' ||
        body.city !== undefined ||
        typeof body.organization === 'string' ||
        typeof body.title === 'string' ||
        body.qualification != null ||
        body.emailPreference != null ||
        body.licenseNumber !== undefined ||
        body.gender !== undefined;
      if (tryingProfile) return res.status(409).json({ error: 'Complete your profile first' });
    }

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

  const client = pgClient();
  try {
    await client.connect();
    if (!(await sessionStillValid(client, jwtUser))) {
      clearSessionCookie(res);
      clearCareStepupCookie(res);
      return res.status(401).json({ error: 'Unauthorized' });
    }
    const { rows } = await client.query(`SELECT password_hash FROM users WHERE id = $1`, [jwtUser.id]);
    if (!rows[0]) return res.status(401).json({ error: 'Unauthorized' });
    const hash = rows[0].password_hash;
    if (typeof hash === 'string') {
      if (!password) return res.status(400).json({ error: 'Password is required' });
      if (!(await verifyPassword(password, hash))) {
        return res.status(401).json({ error: 'Invalid password' });
      }
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

async function handlePassword(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
  if (!originAllowed(req)) return res.status(403).json({ error: 'Forbidden' });

  const jwtUser = await getAuthFromRequest(req);
  if (!jwtUser) return res.status(401).json({ error: 'Unauthorized' });
  if (!rateLimit(`password:${jwtUser.id}`, 5, 15 * 60 * 1000)) {
    return res.status(429).json({ error: 'Too many attempts' });
  }

  const body = parseJsonBody(req);
  if (!body) return res.status(400).json({ error: 'Invalid JSON' });
  const currentPassword = typeof body.currentPassword === 'string' ? body.currentPassword : '';
  const newPassword = typeof body.newPassword === 'string' ? body.newPassword : '';
  const weak = passwordPolicyError(newPassword);
  if (weak) return res.status(400).json({ error: weak });
  if (!process.env.DATABASE_URL || !process.env.AUTH_SECRET) {
    return res.status(500).json({ error: 'Server misconfiguration' });
  }

  const client = pgClient();
  try {
    await client.connect();
    const { rows } = await client.query(
      `SELECT password_hash, ${USER_PUBLIC_COLUMNS} FROM users WHERE id = $1`,
      [jwtUser.id]
    );
    const row = rows[0];
    if (!row) return res.status(401).json({ error: 'Unauthorized' });
    if (!(await sessionStillValid(client, jwtUser)) || passwordChangedAfterJwt(row, jwtUser.iat)) {
      clearSessionCookie(res);
      clearCareStepupCookie(res);
      return res.status(401).json({ error: 'Unauthorized' });
    }
    if (typeof row.password_hash !== 'string') {
      return res.status(400).json({ error: 'No password on this account' });
    }
    if (!(await verifyPassword(currentPassword, row.password_hash))) {
      return res.status(401).json({ error: 'Current password is incorrect' });
    }
    const passwordHash = await hashPassword(newPassword);
    await client.query(
      `UPDATE users SET password_hash = $2, password_changed_at = now(), updated_at = now() WHERE id = $1`,
      [jwtUser.id, passwordHash]
    );
    await consumeUserTokens(client, jwtUser.id, 'reset');
    await invalidateSessions(client, jwtUser.id);
    const updated = await client.query(`SELECT ${USER_PUBLIC_COLUMNS} FROM users WHERE id = $1`, [jwtUser.id]);
    const user = publicUserFromRow(updated.rows[0]);
    const token = await signSession({ id: user.id, email: user.email, isAdmin: user.isAdmin });
    setSessionCookie(res, token);
    return res.status(200).json({ user });
  } catch (err) {
    console.error('password change error', err);
    return res.status(500).json({ error: 'Failed' });
  } finally {
    await client.end().catch(() => {});
  }
}

async function handleForgot(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
  if (!originAllowed(req)) return res.status(403).json({ error: 'Forbidden' });

  const body = parseJsonBody(req) || {};
  const email = normalizeEmail(body.email);
  const ip = clientKey(req);
  if (!rateLimit(`forgot:${ip}`, 5, 60 * 60 * 1000) || !rateLimit(`forgot-email:${email || 'none'}`, 3, 60 * 60 * 1000)) {
    return res.status(429).json({ error: 'Too many attempts' });
  }

  if (email && process.env.DATABASE_URL) {
    const client = pgClient();
    try {
      await client.connect();
      const { rows } = await client.query(`SELECT id::text, email FROM users WHERE email = $1`, [email]);
      if (rows[0]) {
        await enqueueResetEmail(client, { id: rows[0].id, email: rows[0].email });
        await processOutbox(client, 20, { userId: rows[0].id, kind: 'reset' });
      }
    } catch (err) {
      console.error('forgot error', err);
    } finally {
      await client.end().catch(() => {});
    }
  }
  return res.status(200).json({ ok: true });
}

function resetDest(ok: boolean): string {
  return `${appUrl()}/?reset=${ok ? '1' : 'invalid'}`;
}

async function handleReset(req: VercelRequest, res: VercelResponse) {
  if (req.method === 'GET') {
    const raw = typeof req.query.token === 'string' ? req.query.token : '';
    if (!raw || !process.env.DATABASE_URL) {
      res.statusCode = 302;
      res.setHeader('Location', resetDest(false));
      return res.end();
    }
    const client = pgClient();
    try {
      await client.connect();
      const token = await findValidToken(client, raw, 'reset');
      if (!token) {
        res.statusCode = 302;
        res.setHeader('Location', resetDest(false));
        return res.end();
      }
      setResetCookie(res, raw);
      res.statusCode = 302;
      res.setHeader('Location', resetDest(true));
      return res.end();
    } catch (err) {
      console.error('reset get error', err);
      res.statusCode = 302;
      res.setHeader('Location', resetDest(false));
      return res.end();
    } finally {
      await client.end().catch(() => {});
    }
  }

  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
  if (!originAllowed(req)) return res.status(403).json({ error: 'Forbidden' });
  const ip = clientKey(req);
  if (!rateLimit(`reset:${ip}`, 10, 15 * 60 * 1000)) {
    return res.status(429).json({ error: 'Too many attempts' });
  }

  const raw = readResetCookie(req);
  const body = parseJsonBody(req);
  const newPassword = body && typeof body.newPassword === 'string' ? body.newPassword : '';
  const weak = passwordPolicyError(newPassword);
  if (!raw) return res.status(400).json({ error: 'Reset link is invalid or expired' });
  if (weak) return res.status(400).json({ error: weak });
  if (!process.env.DATABASE_URL || !process.env.AUTH_SECRET) {
    return res.status(500).json({ error: 'Server misconfiguration' });
  }

  const client = pgClient();
  try {
    await client.connect();
    const token = await findValidToken(client, raw, 'reset');
    if (!token) {
      clearResetCookie(res);
      return res.status(400).json({ error: 'Reset link is invalid or expired' });
    }
    const passwordHash = await hashPassword(newPassword);
    await client.query(
      `UPDATE users SET password_hash = $2, password_changed_at = now(), updated_at = now() WHERE id = $1`,
      [token.user_id, passwordHash]
    );
    await consumeUserTokens(client, token.user_id, 'reset');
    await invalidateSessions(client, token.user_id);
    const { rows } = await client.query(`SELECT ${USER_PUBLIC_COLUMNS} FROM users WHERE id = $1`, [token.user_id]);
    if (!rows[0]) {
      clearResetCookie(res);
      return res.status(400).json({ error: 'Reset link is invalid or expired' });
    }
    const user = publicUserFromRow(rows[0]);
    const session = await signSession({ id: user.id, email: user.email, isAdmin: user.isAdmin });
    setSessionCookie(res, session);
    clearResetCookie(res);
    await touchLastAccess(client, user.id);
    return res.status(200).json({ user });
  } catch (err) {
    console.error('reset post error', err);
    return res.status(500).json({ error: 'Failed' });
  } finally {
    await client.end().catch(() => {});
  }
}

function googleDest(ok: boolean): string {
  return `${appUrl()}/?google=${ok ? '1' : 'error'}`;
}

async function handleGoogleStart(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });
  const ip = clientKey(req);
  if (!rateLimit(`google:${ip}`, 20, 60 * 60 * 1000)) {
    res.statusCode = 302;
    res.setHeader('Location', googleDest(false));
    return res.end();
  }
  const clientId = process.env.GOOGLE_CLIENT_ID;
  if (!clientId || !process.env.GOOGLE_CLIENT_SECRET || !process.env.AUTH_SECRET) {
    res.statusCode = 302;
    res.setHeader('Location', googleDest(false));
    return res.end();
  }
  const state = newOAuthState();
  const codeVerifier = newCodeVerifier();
  const cookie = await signOAuthState({ state, codeVerifier });
  setOAuthCookie(res, cookie);
  res.statusCode = 302;
  res.setHeader(
    'Location',
    googleAuthorizeUrl({ clientId, state, challenge: codeChallenge(codeVerifier) })
  );
  return res.end();
}

async function finishGoogleUser(
  client: ReturnType<typeof pgClient>,
  profile: { sub: string; email: string }
): Promise<{ id: string; email: string; isAdmin: boolean }> {
  const bySub = await client.query(`SELECT ${USER_PUBLIC_COLUMNS} FROM users WHERE google_sub = $1`, [
    profile.sub,
  ]);
  if (bySub.rows[0]) {
    const user = publicUserFromRow(bySub.rows[0]);
    if (!user.isAdmin && isAdminEmail(user.email)) {
      await client.query(`UPDATE users SET is_admin = true, updated_at = now() WHERE id = $1`, [user.id]);
      user.isAdmin = true;
    }
    return { id: user.id, email: user.email, isAdmin: user.isAdmin };
  }

  const byEmail = await client.query(`SELECT ${USER_PUBLIC_COLUMNS} FROM users WHERE email = $1`, [
    profile.email,
  ]);
  if (byEmail.rows[0]) {
    await client.query(
      `UPDATE users SET
         google_sub = $2,
         email_verified_at = COALESCE(email_verified_at, now()),
         is_admin = CASE WHEN $3 THEN true ELSE is_admin END,
         updated_at = now()
       WHERE id = $1`,
      [byEmail.rows[0].id, profile.sub, isAdminEmail(profile.email)]
    );
    const user = publicUserFromRow(byEmail.rows[0]);
    return { id: user.id, email: user.email, isAdmin: user.isAdmin || isAdminEmail(profile.email) };
  }

  const inserted = await client.query(
    `INSERT INTO users (
       email, password_hash, is_admin, google_sub, email_verified_at, email_preference
     ) VALUES ($1, NULL, $2, $3, now(), 'none')
     RETURNING id::text, email, is_admin`,
    [profile.email, isAdminEmail(profile.email), profile.sub]
  );
  const row = inserted.rows[0];
  return { id: String(row.id), email: String(row.email), isAdmin: Boolean(row.is_admin) };
}

async function handleGoogleCallback(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });
  const fail = () => {
    clearOAuthCookie(res);
    res.statusCode = 302;
    res.setHeader('Location', googleDest(false));
    return res.end();
  };
  const code = typeof req.query.code === 'string' ? req.query.code : '';
  const state = typeof req.query.state === 'string' ? req.query.state : '';
  if (!code || !state || !process.env.DATABASE_URL || !process.env.AUTH_SECRET) return fail();

  const stored = await getOAuthStateFromRequest(req);
  if (!stored || stored.state !== state) return fail();

  const profile = await exchangeGoogleCode({ code, verifier: stored.codeVerifier });
  if (!profile) return fail();

  const client = pgClient();
  try {
    await client.connect();
    const user = await finishGoogleUser(client, profile);
    await touchLastAccess(client, user.id);
    const token = await signSession(user);
    setSessionCookie(res, token);
    clearOAuthCookie(res);
    res.statusCode = 302;
    res.setHeader('Location', googleDest(true));
    return res.end();
  } catch (err) {
    console.error('google callback error', err);
    return fail();
  } finally {
    await client.end().catch(() => {});
  }
}

async function handleCompleteProfile(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
  if (!originAllowed(req)) return res.status(403).json({ error: 'Forbidden' });

  const jwtUser = await getAuthFromRequest(req);
  if (!jwtUser) return res.status(401).json({ error: 'Unauthorized' });
  if (!process.env.DATABASE_URL) return res.status(500).json({ error: 'Server misconfiguration' });

  const body = parseJsonBody(req);
  if (!body) return res.status(400).json({ error: 'Invalid JSON' });

  const country = typeof body.country === 'string' ? body.country.trim() : '';
  const city = typeof body.city === 'string' ? body.city.trim() : '';
  const organization = typeof body.organization === 'string' ? body.organization.trim() : '';
  const title = typeof body.title === 'string' ? body.title.trim() : '';
  const licenseNumber = parseLicenseNumber(body.licenseNumber);
  const foundViaOther = typeof body.foundViaOther === 'string' ? body.foundViaOther.trim() : '';
  const consent = body.consent === true;
  const emailPreference = isEmailPreference(body.emailPreference) ? body.emailPreference : 'none';
  const gender =
    body.gender === null || body.gender === '' || body.gender === undefined
      ? null
      : isGender(body.gender)
        ? body.gender
        : false;

  if (gender === false) return res.status(400).json({ error: 'Invalid gender' });
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

  const client = pgClient();
  try {
    await client.connect();
    const existing = await client.query(`SELECT ${USER_PUBLIC_COLUMNS} FROM users WHERE id = $1`, [jwtUser.id]);
    if (!existing.rows[0]) return res.status(401).json({ error: 'Unauthorized' });
    if (!(await sessionStillValid(client, jwtUser)) || passwordChangedAfterJwt(existing.rows[0], jwtUser.iat)) {
      clearSessionCookie(res);
      clearCareStepupCookie(res);
      return res.status(401).json({ error: 'Unauthorized' });
    }
    if (existing.rows[0].profile_completed_at != null) {
      return res.status(200).json({ user: publicUserFromRow(existing.rows[0]) });
    }

    const { rows } = await client.query(
      `UPDATE users SET
         country = $2,
         city = $3,
         qualification = $4,
         license_number = $5,
         gender = $6,
         organization = $7,
         title = $8,
         found_via = $9,
         found_via_other = $10,
         email_preference = $11,
         profile_completed_at = now(),
         updated_at = now()
       WHERE id = $1 AND profile_completed_at IS NULL
       RETURNING ${USER_PUBLIC_COLUMNS}`,
      [
        jwtUser.id,
        country.slice(0, 100),
        city ? city.slice(0, 100) : null,
        body.qualification,
        licenseNumber || null,
        gender,
        organization.slice(0, 200),
        title.slice(0, 200),
        body.foundVia,
        body.foundVia === 'other' ? foundViaOther.slice(0, 200) : null,
        emailPreference,
      ]
    );
    if (!rows[0]) {
      const again = await client.query(`SELECT ${USER_PUBLIC_COLUMNS} FROM users WHERE id = $1`, [jwtUser.id]);
      if (!again.rows[0]) return res.status(401).json({ error: 'Unauthorized' });
      return res.status(200).json({ user: publicUserFromRow(again.rows[0]) });
    }
    const user = publicUserFromRow(rows[0]);
    try {
      await enqueueRegisterAdminEmails(client, {
        email: user.email,
        country: user.country,
        city: user.city,
        qualification: user.qualification || 'other',
        licenseNumber: user.licenseNumber,
        organization: user.organization,
        title: user.title,
        foundVia: user.foundVia || 'other',
        foundViaOther: user.foundViaOther,
        emailPreference: user.emailPreference,
      });
      await processOutbox(client);
    } catch (err) {
      console.error('complete-profile admin email failed', err);
    }
    return res.status(200).json({ user });
  } catch (err) {
    console.error('complete-profile error', err);
    return res.status(500).json({ error: 'Failed' });
  } finally {
    await client.end().catch(() => {});
  }
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  const action = actionName(req);
  const skipCors =
    action === 'confirm' ||
    action === 'unsubscribe' ||
    action === 'google' ||
    action === 'google-callback' ||
    (action === 'reset' && req.method === 'GET');
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
    case 'password':
      return handlePassword(req, res);
    case 'forgot':
      return handleForgot(req, res);
    case 'reset':
      return handleReset(req, res);
    case 'google':
      return handleGoogleStart(req, res);
    case 'google-callback':
      return handleGoogleCallback(req, res);
    case 'complete-profile':
      return handleCompleteProfile(req, res);
    default:
      if (!skipCors) setAuthCors(req, res);
      return res.status(404).json({ error: 'Not found' });
  }
}
