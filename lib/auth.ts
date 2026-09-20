/**
 * JWT cookie sessions. Same policy as the other site's NextAuth config, without NextAuth:
 *   strategy: jwt
 *   maxAge: 2 hours
 *   updateAge: 30 minutes
 *
 * Cookies are HttpOnly, SameSite=Lax, Path=/. Production uses Secure and the __Host- prefix.
 * There is nothing server-side to revoke except rotating AUTH_SECRET.
 */

import type { VercelRequest, VercelResponse } from '@vercel/node';
import bcrypt from 'bcryptjs';
import { SignJWT, jwtVerify, type JWTPayload } from 'jose';

export const SESSION_MAX_AGE_SEC = 2 * 60 * 60;
export const SESSION_UPDATE_AGE_SEC = 30 * 60;
export const CARE_STEPUP_MAX_AGE_SEC = 30 * 60;
const BCRYPT_ROUNDS = 12;

export type JwtUser = {
  id: string;
  email: string;
  isAdmin: boolean;
  iat: number;
};

function isProduction(): boolean {
  return process.env.VERCEL_ENV === 'production';
}

export function authCookieName(): string {
  return isProduction() ? '__Host-mh-auth' : 'mh-auth';
}

export function careCookieName(): string {
  return isProduction() ? '__Host-mh-care' : 'mh-care';
}

function secretKey(): Uint8Array {
  const secret = process.env.AUTH_SECRET;
  if (!secret || secret.length < 16) {
    throw new Error('AUTH_SECRET is missing or too short');
  }
  return new TextEncoder().encode(secret);
}

export function sessionCookieHeader(token: string): string {
  const parts = [
    `${authCookieName()}=${token}`,
    'Path=/',
    'HttpOnly',
    'SameSite=Lax',
    `Max-Age=${SESSION_MAX_AGE_SEC}`,
  ];
  if (isProduction()) parts.push('Secure');
  return parts.join('; ');
}

export function clearSessionCookieHeader(): string {
  const parts = [`${authCookieName()}=`, 'Path=/', 'HttpOnly', 'SameSite=Lax', 'Max-Age=0'];
  if (isProduction()) parts.push('Secure');
  return parts.join('; ');
}

export function readCookie(req: VercelRequest, name: string): string | null {
  const header = req.headers.cookie;
  if (!header) return null;
  const parts = Array.isArray(header) ? header.join(';').split(';') : header.split(';');
  for (const part of parts) {
    const idx = part.indexOf('=');
    if (idx === -1) continue;
    const key = part.slice(0, idx).trim();
    if (key === name) return part.slice(idx + 1).trim();
  }
  return null;
}

export async function signSession(user: { id: string; email: string; isAdmin: boolean }): Promise<string> {
  return new SignJWT({ email: user.email, isAdmin: user.isAdmin })
    .setProtectedHeader({ alg: 'HS256' })
    .setSubject(user.id)
    .setIssuedAt()
    .setExpirationTime(`${SESSION_MAX_AGE_SEC}s`)
    .sign(secretKey());
}

function payloadToUser(payload: JWTPayload): JwtUser | null {
  const id = typeof payload.sub === 'string' ? payload.sub : '';
  const email = typeof payload.email === 'string' ? payload.email : '';
  const iat = typeof payload.iat === 'number' ? payload.iat : 0;
  if (!id || !email || !iat) return null;
  return { id, email, isAdmin: payload.isAdmin === true, iat };
}

export async function verifySessionToken(token: string): Promise<JwtUser | null> {
  try {
    const { payload } = await jwtVerify(token, secretKey());
    return payloadToUser(payload);
  } catch {
    return null;
  }
}

export async function getAuthFromRequest(req: VercelRequest): Promise<JwtUser | null> {
  const named = readCookie(req, authCookieName()) || readCookie(req, 'mh-auth') || readCookie(req, '__Host-mh-auth');
  if (!named) return null;
  try {
    return await verifySessionToken(named);
  } catch {
    return null;
  }
}

export function shouldRefreshSession(user: JwtUser): boolean {
  const ageSec = Math.floor(Date.now() / 1000) - user.iat;
  return ageSec >= SESSION_UPDATE_AGE_SEC;
}

export const PASSWORD_MIN_LENGTH = 8;
export const PASSWORD_MAX_LENGTH = 72;

export const PASSWORD_POLICY_ERROR =
  'Password must be 8-72 characters and include uppercase, lowercase, a number, and a symbol';

export function passwordPolicyError(password: string): string | null {
  if (typeof password !== 'string') return PASSWORD_POLICY_ERROR;
  if (password.length < PASSWORD_MIN_LENGTH || password.length > PASSWORD_MAX_LENGTH) {
    return PASSWORD_POLICY_ERROR;
  }
  if (!/[a-z]/.test(password) || !/[A-Z]/.test(password) || !/[0-9]/.test(password)) {
    return PASSWORD_POLICY_ERROR;
  }
  if (!/[^A-Za-z0-9\s]/.test(password)) return PASSWORD_POLICY_ERROR;
  return null;
}

export async function hashPassword(plain: string): Promise<string> {
  return bcrypt.hash(plain, BCRYPT_ROUNDS);
}

export async function verifyPassword(plain: string, hash: string): Promise<boolean> {
  return bcrypt.compare(plain, hash);
}

export function originAllowed(req: VercelRequest): boolean {
  const origin = req.headers.origin;
  if (!origin) {
    return req.method === 'GET' || req.method === 'HEAD' || req.method === 'OPTIONS';
  }
  const host = req.headers.host;
  try {
    const o = new URL(origin);
    if (host && o.host === host) return true;
  } catch {
    return false;
  }
  const extra = process.env.ANALYTICS_ALLOWED_ORIGINS;
  if (extra && extra.split(',').map((s) => s.trim()).filter(Boolean).includes(origin)) {
    return true;
  }
  return origin.startsWith('http://localhost:') || origin.startsWith('http://127.0.0.1:');
}

export function setAuthCors(req: VercelRequest, res: VercelResponse): void {
  const origin = typeof req.headers.origin === 'string' ? req.headers.origin : '';
  if (origin && originAllowed(req)) {
    res.setHeader('Access-Control-Allow-Origin', origin);
    res.setHeader('Access-Control-Allow-Credentials', 'true');
  }
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PATCH, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  res.setHeader('Access-Control-Max-Age', '86400');
}

export function parseJsonBody(req: VercelRequest): Record<string, unknown> | null {
  const body = req.body;
  if (body == null) return {};
  if (typeof body === 'string') {
    try {
      const parsed = JSON.parse(body);
      return parsed && typeof parsed === 'object' && !Array.isArray(parsed) ? parsed : null;
    } catch {
      return null;
    }
  }
  if (typeof body === 'object' && !Array.isArray(body)) return body as Record<string, unknown>;
  return null;
}

const attemptLog = new Map<string, number[]>();

export function rateLimit(key: string, max: number, windowMs: number): boolean {
  const now = Date.now();
  const kept = (attemptLog.get(key) || []).filter((t) => now - t < windowMs);
  if (kept.length >= max) {
    attemptLog.set(key, kept);
    return false;
  }
  kept.push(now);
  attemptLog.set(key, kept);
  return true;
}

export function clientKey(req: VercelRequest): string {
  const fwd = req.headers['x-forwarded-for'];
  const ip = typeof fwd === 'string' ? fwd.split(',')[0].trim() : req.socket?.remoteAddress || 'unknown';
  return ip;
}

export function normalizeEmail(raw: unknown): string | null {
  if (typeof raw !== 'string') return null;
  const email = raw.trim().toLowerCase();
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) || email.length > 320) return null;
  return email;
}

export function appendCookie(res: VercelResponse, header: string): void {
  const prev = res.getHeader('Set-Cookie');
  if (!prev) {
    res.setHeader('Set-Cookie', header);
    return;
  }
  const list = Array.isArray(prev) ? prev.map(String) : [String(prev)];
  res.setHeader('Set-Cookie', [...list, header]);
}

export function setSessionCookie(res: VercelResponse, token: string): void {
  appendCookie(res, sessionCookieHeader(token));
}

export function clearSessionCookie(res: VercelResponse): void {
  appendCookie(res, clearSessionCookieHeader());
}

function careCookieHeader(token: string): string {
  const parts = [
    `${careCookieName()}=${token}`,
    'Path=/',
    'HttpOnly',
    'SameSite=Lax',
    `Max-Age=${CARE_STEPUP_MAX_AGE_SEC}`,
  ];
  if (isProduction()) parts.push('Secure');
  return parts.join('; ');
}

function clearCareCookieHeader(): string {
  const parts = [`${careCookieName()}=`, 'Path=/', 'HttpOnly', 'SameSite=Lax', 'Max-Age=0'];
  if (isProduction()) parts.push('Secure');
  return parts.join('; ');
}

export async function signCareStepup(userId: string): Promise<string> {
  return new SignJWT({ purpose: 'care' })
    .setProtectedHeader({ alg: 'HS256' })
    .setSubject(userId)
    .setIssuedAt()
    .setExpirationTime(`${CARE_STEPUP_MAX_AGE_SEC}s`)
    .sign(secretKey());
}

export async function getCareStepupFromRequest(req: VercelRequest): Promise<{ id: string } | null> {
  const named = readCookie(req, careCookieName()) || readCookie(req, 'mh-care') || readCookie(req, '__Host-mh-care');
  if (!named) return null;
  try {
    const { payload } = await jwtVerify(named, secretKey());
    const id = typeof payload.sub === 'string' ? payload.sub : '';
    if (!id || payload.purpose !== 'care') return null;
    return { id };
  } catch {
    return null;
  }
}

export function setCareStepupCookie(res: VercelResponse, token: string): void {
  appendCookie(res, careCookieHeader(token));
}

export function clearCareStepupCookie(res: VercelResponse): void {
  appendCookie(res, clearCareCookieHeader());
}

export async function sessionStillValid(
  client: { query: (sql: string, params?: unknown[]) => Promise<{ rows: Record<string, unknown>[] }> },
  user: JwtUser
): Promise<boolean> {
  try {
    const { rows } = await client.query(`SELECT session_invalid_before FROM users WHERE id = $1`, [user.id]);
    if (!rows[0]) return false;
    const raw = rows[0].session_invalid_before;
    if (raw == null) return true;
    const cut = raw instanceof Date ? raw : new Date(String(raw));
    if (Number.isNaN(cut.getTime())) return true;
    return user.iat >= Math.floor(cut.getTime() / 1000);
  } catch (err) {
    const code = (err as { code?: string }).code;
    if (code === '42703') return true;
    throw err;
  }
}

export async function invalidateSessions(
  client: { query: (sql: string, params?: unknown[]) => Promise<unknown> },
  userId: string
): Promise<void> {
  try {
    await client.query(`UPDATE users SET session_invalid_before = now(), updated_at = now() WHERE id = $1`, [userId]);
  } catch (err) {
    const code = (err as { code?: string }).code;
    if (code === '42703') return;
    throw err;
  }
}
