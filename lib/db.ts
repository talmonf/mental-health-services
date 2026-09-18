import { Client } from 'pg';

/** Matches api/analytics.ts: avoids pg's deprecation warning for prefer/require/verify-ca. */
export function normalizePgSslMode(connectionString: string): string {
  try {
    const u = new URL(connectionString);
    const mode = u.searchParams.get('sslmode');
    if (mode === 'prefer' || mode === 'require' || mode === 'verify-ca') {
      u.searchParams.set('sslmode', 'verify-full');
    }
    return u.toString();
  } catch {
    return connectionString;
  }
}

export function pgClient(): Client {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    throw new Error('DATABASE_URL missing');
  }
  return new Client({ connectionString: normalizePgSslMode(databaseUrl) });
}

export function appUrl(): string {
  const explicit = process.env.AUTH_APP_URL;
  if (explicit) return explicit.replace(/\/$/, '');
  if (process.env.VERCEL_ENV === 'production') return 'https://nefesh-il.org';
  if (process.env.VERCEL_URL) return `https://${process.env.VERCEL_URL}`;
  return 'http://localhost:3000';
}
