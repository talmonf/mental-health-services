/**
 * POST /api/directory-entry-touch
 * Body: { "entry_id": "<same as data-entry-id on cards>" }
 * Sets directory_entries.last_accessed = now() for that row (no-op if entry_id unknown).
 *
 * Env: DATABASE_URL (same as /api/analytics)
 *
 * Migration: scripts/directory_entries_add_update_details_last_accessed.sql
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import { Client } from 'pg';

const ALLOWED_ORIGINS = process.env.ANALYTICS_ALLOWED_ORIGINS
  ? process.env.ANALYTICS_ALLOWED_ORIGINS.split(',').map((o) => o.trim())
  : ['*'];

function normalizePgSslMode(connectionString: string): string {
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

function corsHeaders(origin: string | undefined): Record<string, string> {
  const allowOrigin =
    ALLOWED_ORIGINS[0] === '*' || (origin && ALLOWED_ORIGINS.includes(origin))
      ? origin || '*'
      : ALLOWED_ORIGINS[0];
  return {
    'Access-Control-Allow-Origin': allowOrigin,
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Max-Age': '86400',
  };
}

/** Same shape as data-entry-id on cards (mhGetEntryId); reject control chars only. */
function sanitizeEntryId(raw: unknown): string | null {
  if (typeof raw !== 'string') return null;
  const t = raw.trim();
  if (!t || t.length > 255) return null;
  if (/[\x00-\x08\x0b\x0c\x0e-\x1f]/.test(t)) return null;
  return t;
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  const origin = req.headers.origin as string | undefined;
  const headers = corsHeaders(origin);
  Object.entries(headers).forEach(([k, v]) => res.setHeader(k, v));

  if (req.method === 'OPTIONS') {
    return res.status(204).end();
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  let body: unknown;
  try {
    body = typeof req.body === 'string' ? JSON.parse(req.body) : req.body;
  } catch {
    return res.status(400).json({ error: 'Invalid JSON' });
  }

  const entryId = sanitizeEntryId((body as { entry_id?: unknown })?.entry_id);
  if (!entryId) {
    return res.status(400).json({ error: 'Invalid entry_id' });
  }

  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    return res.status(500).json({ error: 'Server misconfiguration' });
  }

  const client = new Client({ connectionString: normalizePgSslMode(databaseUrl) });
  try {
    await client.connect();
    await client.query(
      `UPDATE directory_entries
       SET last_accessed = now()
       WHERE entry_id = $1`,
      [entryId]
    );
  } catch (err) {
    console.error('directory-entry-touch error:', err);
    return res.status(500).json({ error: 'Failed to update' });
  } finally {
    await client.end().catch(() => {});
  }

  return res.status(204).end();
}
