/**
 * POST /api/directory-entry-touch
 * Body: { "entry_id": "<same as data-entry-id on cards>" }
 * Sets directory_entries.last_accessed = now() for that row (no-op if entry_id unknown).
 *
 * GET /api/directory-cards (rewritten here) returns visible card edits and eligibility.
 * Eligibility is not painted on the card; the page publishes set values as JSON-LD.
 *
 * Env: DATABASE_URL (same as /api/analytics)
 *
 * Migration: scripts/directory_entries_add_update_details_last_accessed.sql
 *            scripts/045_directory_card_edits.sql
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import { Client } from 'pg';
import { pgClient } from '../lib/db';

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
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
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

function isoTime(value: unknown): string | null {
  if (value == null || value === '') return null;
  if (value instanceof Date) return value.toISOString();
  return String(value);
}

async function handlePublicCards(res: VercelResponse) {
  if (!process.env.DATABASE_URL) {
    return res.status(500).json({ error: 'Server misconfiguration' });
  }
  const client = pgClient();
  try {
    await client.connect();
    let rows: Array<Record<string, unknown>>;
    try {
      const result = await client.query(
        `SELECT id, card_key, row_id, public_fields, eligibility, sites, public_edited_at
           FROM directory_card_edits
          ORDER BY row_id, id`
      );
      rows = result.rows;
    } catch (err) {
      const code = err && typeof err === 'object' && 'code' in err ? String((err as { code?: string }).code) : '';
      if (code !== '42703') throw err;
      const result = await client.query(
        `SELECT id, card_key, row_id, public_fields, eligibility, public_edited_at
           FROM directory_card_edits
          ORDER BY row_id, id`
      );
      rows = result.rows;
    }
    res.setHeader('Cache-Control', 'no-cache');
    return res.status(200).json({
      cards: rows.map((row) => ({
        id: Number(row.id),
        cardKey: String(row.card_key || ''),
        rowId: Number(row.row_id),
        publicFields: row.public_fields && typeof row.public_fields === 'object' ? row.public_fields : {},
        eligibility: row.eligibility && typeof row.eligibility === 'object' ? row.eligibility : {},
        sites: Array.isArray(row.sites) ? row.sites : [],
        publicEditedAt: isoTime(row.public_edited_at),
      })),
    });
  } catch (err) {
    const code = err && typeof err === 'object' && 'code' in err ? String((err as { code?: string }).code) : '';
    if (code === '42P01') {
      res.setHeader('Cache-Control', 'no-cache');
      return res.status(200).json({ cards: [] });
    }
    console.error('directory-cards error:', err);
    return res.status(500).json({ error: 'Failed to load' });
  } finally {
    await client.end().catch(() => {});
  }
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  const origin = req.headers.origin as string | undefined;
  const headers = corsHeaders(origin);
  Object.entries(headers).forEach(([k, v]) => res.setHeader(k, v));

  if (req.method === 'OPTIONS') {
    return res.status(204).end();
  }

  if (req.method === 'GET') {
    return handlePublicCards(res);
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
