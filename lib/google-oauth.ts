import { createHash, randomBytes } from 'crypto';
import { appUrl } from './db';

export function googleRedirectUri(): string {
  return `${appUrl()}/api/auth/google/callback`;
}

export function newCodeVerifier(): string {
  return randomBytes(32).toString('base64url');
}

export function newOAuthState(): string {
  return randomBytes(24).toString('base64url');
}

export function codeChallenge(verifier: string): string {
  return createHash('sha256').update(verifier).digest('base64url');
}

export function googleAuthorizeUrl(opts: { clientId: string; state: string; challenge: string }): string {
  const u = new URL('https://accounts.google.com/o/oauth2/v2/auth');
  u.searchParams.set('client_id', opts.clientId);
  u.searchParams.set('redirect_uri', googleRedirectUri());
  u.searchParams.set('response_type', 'code');
  u.searchParams.set('scope', 'openid email profile');
  u.searchParams.set('state', opts.state);
  u.searchParams.set('code_challenge', opts.challenge);
  u.searchParams.set('code_challenge_method', 'S256');
  u.searchParams.set('access_type', 'online');
  u.searchParams.set('prompt', 'select_account');
  return u.toString();
}

export type GoogleProfile = { sub: string; email: string };

function emailVerifiedFlag(v: unknown): boolean {
  return v === true || v === 'true';
}

export async function exchangeGoogleCode(opts: { code: string; verifier: string }): Promise<GoogleProfile | null> {
  const clientId = process.env.GOOGLE_CLIENT_ID;
  const clientSecret = process.env.GOOGLE_CLIENT_SECRET;
  if (!clientId || !clientSecret) return null;

  const tokenRes = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      code: opts.code,
      client_id: clientId,
      client_secret: clientSecret,
      redirect_uri: googleRedirectUri(),
      grant_type: 'authorization_code',
      code_verifier: opts.verifier,
    }),
  });
  if (!tokenRes.ok) {
    console.error('google token exchange failed', tokenRes.status);
    return null;
  }
  const tokens = (await tokenRes.json()) as { access_token?: unknown };
  const access = typeof tokens.access_token === 'string' ? tokens.access_token : '';
  if (!access) return null;

  const infoRes = await fetch('https://openidconnect.googleapis.com/userinfo', {
    headers: { Authorization: `Bearer ${access}` },
  });
  if (!infoRes.ok) {
    console.error('google userinfo failed', infoRes.status);
    return null;
  }
  const info = (await infoRes.json()) as Record<string, unknown>;
  const email = typeof info.email === 'string' ? info.email.trim().toLowerCase() : '';
  const sub = typeof info.sub === 'string' ? info.sub : '';
  if (!email || !sub || !emailVerifiedFlag(info.email_verified)) return null;
  return { sub, email };
}
