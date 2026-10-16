import { createCipheriv, createDecipheriv, createHash, randomBytes } from 'crypto';
import type { Client } from 'pg';
import { appUrl } from './db';

export const CONTACTS_SCOPE = 'https://www.googleapis.com/auth/contacts.readonly';
const READ_MASK = 'names,emailAddresses,phoneNumbers,organizations';

export class GoogleContactsError extends Error {
  status: number;
  constructor(message: string, status = 400) {
    super(message);
    this.status = status;
  }
}

export function contactsRedirectUri(): string {
  return `${appUrl()}/api/admin/google-callback`;
}

export function contactsConfigured(): boolean {
  return Boolean(process.env.GOOGLE_CLIENT_ID && process.env.GOOGLE_CLIENT_SECRET && process.env.GOOGLE_TOKEN_KEY);
}

function tokenKey(): Buffer {
  const raw = process.env.GOOGLE_TOKEN_KEY;
  if (!raw) throw new GoogleContactsError('GOOGLE_TOKEN_KEY is not set', 500);
  return createHash('sha256').update(raw).digest();
}

export function encryptToken(plain: string): string {
  const iv = randomBytes(12);
  const cipher = createCipheriv('aes-256-gcm', tokenKey(), iv);
  const body = Buffer.concat([cipher.update(plain, 'utf8'), cipher.final()]);
  return [iv, cipher.getAuthTag(), body].map((b) => b.toString('base64url')).join('.');
}

export function decryptToken(enc: string): string {
  const [iv, tag, body] = String(enc).split('.').map((part) => Buffer.from(part, 'base64url'));
  const decipher = createDecipheriv('aes-256-gcm', tokenKey(), iv);
  decipher.setAuthTag(tag);
  return Buffer.concat([decipher.update(body), decipher.final()]).toString('utf8');
}

export function contactsAuthorizeUrl(opts: { clientId: string; state: string; challenge: string }): string {
  const u = new URL('https://accounts.google.com/o/oauth2/v2/auth');
  u.searchParams.set('client_id', opts.clientId);
  u.searchParams.set('redirect_uri', contactsRedirectUri());
  u.searchParams.set('response_type', 'code');
  u.searchParams.set('scope', `openid email ${CONTACTS_SCOPE}`);
  u.searchParams.set('state', opts.state);
  u.searchParams.set('code_challenge', opts.challenge);
  u.searchParams.set('code_challenge_method', 'S256');
  u.searchParams.set('access_type', 'offline');
  u.searchParams.set('prompt', 'consent');
  return u.toString();
}

async function tokenRequest(params: Record<string, string>): Promise<Record<string, unknown>> {
  const response = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      client_id: process.env.GOOGLE_CLIENT_ID || '',
      client_secret: process.env.GOOGLE_CLIENT_SECRET || '',
      ...params,
    }),
  });
  const data = (await response.json().catch(() => ({}))) as Record<string, unknown>;
  if (!response.ok) {
    console.error('google contacts token request failed', response.status, {
      error: typeof data.error === 'string' ? data.error : undefined,
    });
    const revoked = data.error === 'invalid_grant';
    throw new GoogleContactsError(
      revoked ? 'החיבור ל-Google פג או בוטל. יש להתחבר מחדש.' : 'הבקשה ל-Google נכשלה.',
      revoked ? 409 : 502
    );
  }
  return data;
}

/** Exchanges the consent code. Returns the refresh token, the granted scopes and the account email. */
export async function exchangeContactsCode(opts: {
  code: string;
  verifier: string;
}): Promise<{ refreshToken: string; scopes: string; email: string }> {
  const tokens = await tokenRequest({
    code: opts.code,
    redirect_uri: contactsRedirectUri(),
    grant_type: 'authorization_code',
    code_verifier: opts.verifier,
  });
  const refreshToken = typeof tokens.refresh_token === 'string' ? tokens.refresh_token : '';
  const access = typeof tokens.access_token === 'string' ? tokens.access_token : '';
  const scopes = typeof tokens.scope === 'string' ? tokens.scope : '';
  if (!refreshToken || !access) throw new GoogleContactsError('Google did not return a refresh token', 502);
  if (!scopes.split(' ').includes(CONTACTS_SCOPE)) {
    throw new GoogleContactsError('לא ניתנה הרשאה לאנשי הקשר. יש לסמן את ההרשאה במסך האישור של Google.', 400);
  }
  const info = await fetch('https://openidconnect.googleapis.com/userinfo', {
    headers: { Authorization: `Bearer ${access}` },
  });
  const profile = (await info.json().catch(() => ({}))) as Record<string, unknown>;
  const email = typeof profile.email === 'string' ? profile.email.trim().toLowerCase() : '';
  return { refreshToken, scopes, email };
}

let cachedAccess: { token: string; expiresAt: number; refreshEnc: string } | null = null;
let warmedUp = false;

export async function connectionStatus(client: Client): Promise<{ connected: boolean; email: string; connectedAt: string | null }> {
  const { rows } = await client.query(`SELECT google_email, connected_at FROM google_connection WHERE id = 1`);
  if (!rows[0]) return { connected: false, email: '', connectedAt: null };
  const at = rows[0].connected_at;
  return {
    connected: true,
    email: String(rows[0].google_email || ''),
    connectedAt: at instanceof Date ? at.toISOString() : at ? String(at) : null,
  };
}

async function accessToken(client: Client): Promise<string> {
  const { rows } = await client.query(`SELECT refresh_token_enc FROM google_connection WHERE id = 1`);
  const enc = rows[0] ? String(rows[0].refresh_token_enc) : '';
  if (!enc) throw new GoogleContactsError('Google Contacts לא מחובר.', 409);
  if (cachedAccess && cachedAccess.refreshEnc === enc && cachedAccess.expiresAt > Date.now() + 60_000) {
    return cachedAccess.token;
  }
  const data = await tokenRequest({ refresh_token: decryptToken(enc), grant_type: 'refresh_token' });
  const token = typeof data.access_token === 'string' ? data.access_token : '';
  if (!token) throw new GoogleContactsError('Google did not return an access token', 502);
  const ttl = Number(data.expires_in) || 3600;
  cachedAccess = { token, expiresAt: Date.now() + ttl * 1000, refreshEnc: enc };
  return token;
}

export type ContactRecord = {
  resourceName: string;
  displayName: string;
  email: string;
  phone: string;
  organization: string;
  contactUrl: string;
};

export function contactUrlFor(resourceName: string): string {
  const id = /^people\/(c\d+)$/.exec(resourceName);
  return id ? `https://contacts.google.com/person/${id[1]}` : '';
}

/** Accepts a contacts.google.com person URL (any /u/N/ prefix) or a people/c... id. */
export function resourceNameFromInput(raw: string): string | null {
  const s = String(raw || '').trim();
  const direct = /^people\/(c\d+)$/.exec(s);
  if (direct) return `people/${direct[1]}`;
  const url = /contacts\.google\.com\/(?:u\/\d+\/)?person\/(c\d+)/.exec(s);
  return url ? `people/${url[1]}` : null;
}

function first(list: unknown, key: string): string {
  if (!Array.isArray(list)) return '';
  const primary = list.find((item) => item && item.metadata && item.metadata.primary) || list[0];
  return primary && typeof primary[key] === 'string' ? primary[key] : '';
}

function personToRecord(person: Record<string, unknown>): ContactRecord {
  const resourceName = String(person.resourceName || '');
  const orgName = first(person.organizations, 'name');
  const orgTitle = first(person.organizations, 'title');
  return {
    resourceName,
    displayName: first(person.names, 'displayName') || first(person.emailAddresses, 'value') || resourceName,
    email: first(person.emailAddresses, 'value'),
    phone: first(person.phoneNumbers, 'value'),
    organization: [orgName, orgTitle].filter(Boolean).join(' · '),
    contactUrl: contactUrlFor(resourceName),
  };
}

async function peopleGet(client: Client, path: string, params: Record<string, string>): Promise<Record<string, unknown>> {
  const token = await accessToken(client);
  const url = new URL(`https://people.googleapis.com/v1/${path}`);
  Object.entries(params).forEach(([k, v]) => url.searchParams.set(k, v));
  const response = await fetch(url, { headers: { Authorization: `Bearer ${token}` } });
  const data = (await response.json().catch(() => ({}))) as Record<string, unknown>;
  if (response.status === 404) throw new GoogleContactsError('איש הקשר לא נמצא ב-Google Contacts.', 404);
  if (!response.ok) {
    console.error('google people request failed', response.status, path);
    throw new GoogleContactsError('הבקשה ל-Google Contacts נכשלה.', 502);
  }
  return data;
}

export async function searchContacts(client: Client, query: string): Promise<ContactRecord[]> {
  if (!warmedUp) {
    // People API caches search results per user; an empty query primes it.
    await peopleGet(client, 'people:searchContacts', { query: '', readMask: READ_MASK }).catch(() => null);
    warmedUp = true;
  }
  const data = await peopleGet(client, 'people:searchContacts', {
    query,
    readMask: READ_MASK,
    pageSize: '20',
  });
  const results = Array.isArray(data.results) ? data.results : [];
  return results
    .map((r: { person?: Record<string, unknown> }) => (r && r.person ? personToRecord(r.person) : null))
    .filter((r): r is ContactRecord => Boolean(r && r.resourceName));
}

export async function getContact(client: Client, resourceName: string): Promise<ContactRecord> {
  return personToRecord(await peopleGet(client, resourceName, { personFields: READ_MASK }));
}
