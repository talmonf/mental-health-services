/**
 * Vercel serverless: POST /api/analytics
 * Expects Neon DB with:
 * - sessions (session_id PK/unique, user_pseudo_id, country, device_type, first_event_at, first_seen_at, last_seen_at)
 * - events (session_id, event_id, event_type, occurred_at, page_url, page_title, referrer_domain,
 *   user_agent, viewport_width, viewport_height, entry_id FK nullable, search_query, search_location,
 *   element_id, element_type, element_text_short, section, properties jsonb)
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import { Client } from 'pg';

const ALLOWED_ORIGINS = process.env.ANALYTICS_ALLOWED_ORIGINS
  ? process.env.ANALYTICS_ALLOWED_ORIGINS.split(',').map((o) => o.trim())
  : ['*'];

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

function deviceType(ua: string | undefined): string {
  if (!ua) return 'unknown';
  const u = ua.toLowerCase();
  if (/mobile|android|iphone|ipod|blackberry|iemobile|opera mini/i.test(u)) return 'mobile';
  if (/tablet|ipad|playbook|silk/i.test(u)) return 'tablet';
  return 'desktop';
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  const origin = req.headers.origin as string | undefined;
  const headers = corsHeaders(origin);

  const setCors = (r: VercelResponse) => {
    Object.entries(headers).forEach(([k, v]) => r.setHeader(k, v));
    return r;
  };

  if (req.method === 'OPTIONS') {
    setCors(res);
    return res.status(204).end();
  }

  if (req.method !== 'POST') {
    setCors(res);
    return res.status(405).json({ error: 'Method not allowed' });
  }

  let body: unknown;
  try {
    body = typeof req.body === 'string' ? JSON.parse(req.body) : req.body;
  } catch {
    setCors(res);
    return res.status(400).json({ error: 'Invalid JSON' });
  }

  const events = Array.isArray(body) ? body : [body];
  if (events.length === 0) {
    setCors(res);
    return res.status(204).end();
  }

  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    setCors(res);
    return res.status(500).json({ error: 'Server misconfiguration' });
  }

  const country = (req.headers['x-vercel-ip-country'] as string) || null;

  const client = new Client({ connectionString: databaseUrl });
  try {
    await client.connect();

    for (const ev of events) {
      const e = ev as Record<string, unknown>;
      const sessionId = e?.session_id as string | undefined;
      const userPseudoId = (e?.user_pseudo_id as string) || null;
      const ua = (e?.user_agent as string) || '';
      const device = deviceType(ua);

      if (!sessionId) continue;

      const occurredAt = (e?.occurred_at as string) || new Date().toISOString();
      await client.query(
        `INSERT INTO sessions (session_id, user_pseudo_id, country, device_type, first_event_at, first_seen_at, last_seen_at)
         VALUES ($1, $2, $3, $4, $5, $5, $5)
         ON CONFLICT (session_id) DO UPDATE SET
           user_pseudo_id = COALESCE(EXCLUDED.user_pseudo_id, sessions.user_pseudo_id),
           country = COALESCE(EXCLUDED.country, sessions.country),
           device_type = COALESCE(EXCLUDED.device_type, sessions.device_type),
           first_event_at = COALESCE(sessions.first_event_at, EXCLUDED.first_event_at),
           last_seen_at = EXCLUDED.last_seen_at`,
        [sessionId, userPseudoId, country, device, occurredAt]
      );

      await client.query(
        `INSERT INTO events (
          session_id, event_id, event_type, occurred_at, page_url, page_title,
          referrer_domain, user_agent, viewport_width, viewport_height,
          entry_id, search_query, search_location, element_id, element_type, element_text_short, section, properties
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18)`,
        [
          sessionId,
          (e?.event_id as string) || null,
          (e?.event_type as string) || null,
          (e?.occurred_at as string) || new Date().toISOString(),
          (e?.page_url as string) || null,
          (e?.page_title as string) || null,
          (e?.referrer_domain as string) || null,
          ua || null,
          typeof e?.viewport_width === 'number' ? e.viewport_width : null,
          typeof e?.viewport_height === 'number' ? e.viewport_height : null,
          (e?.entry_id as string) || null,
          (e?.search_query as string) || null,
          (e?.search_location as string) || null,
          (e?.element_id as string) || null,
          (e?.element_type as string) || null,
          (e?.element_text_short as string) || null,
          (e?.section as string) || null,
          JSON.stringify({
            ...e,
            session_id: undefined,
            event_id: undefined,
            event_type: undefined,
            occurred_at: undefined,
            page_url: undefined,
            page_title: undefined,
            referrer_domain: undefined,
            user_agent: undefined,
            viewport_width: undefined,
            viewport_height: undefined,
            entry_id: undefined,
            search_query: undefined,
            search_location: undefined,
            element_id: undefined,
            element_type: undefined,
            element_text_short: undefined,
            section: undefined,
          }),
        ]
      );
    }
  } catch (err) {
    console.error('Analytics API error:', err);
    setCors(res);
    return res.status(500).json({ error: 'Failed to store events' });
  } finally {
    await client.end().catch(() => {});
  }

  setCors(res);
  return res.status(204).end();
}
