/**
 * Vercel serverless: POST /api/analytics
 * Expects Neon DB with:
 * - sessions (session_id PK/unique, user_pseudo_id, country, device_type, first_event_at, last_event_at, first_seen_at, last_seen_at)
 * - events (event_id uuid, session_id, event_type, occurred_at, page_url, page_route, section,
 *   element_id, element_type, element_text_short, search_query, results_count, search_location,
 *   extra jsonb, entry_id, country, device_type, browser_name, os_name, language, referrer_domain, utm_*)
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
  const acceptLanguage = req.headers['accept-language'] as string | undefined;
  const language = acceptLanguage ? acceptLanguage.split(',')[0].trim().slice(0, 50) : null;

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
      const pageUrl = (e?.page_url as string) || null;
      let pageRoute: string | null = null;
      if (pageUrl) {
        try {
          pageRoute = new URL(pageUrl).pathname.slice(0, 500) || null;
        } catch {
          pageRoute = null;
        }
      }
      await client.query(
        `INSERT INTO sessions (session_id, user_pseudo_id, country, device_type, first_event_at, last_event_at, first_seen_at, last_seen_at)
         VALUES ($1, $2, $3, $4, $5, $5, $5, $5)
         ON CONFLICT (session_id) DO UPDATE SET
           user_pseudo_id = COALESCE(EXCLUDED.user_pseudo_id, sessions.user_pseudo_id),
           country = COALESCE(EXCLUDED.country, sessions.country),
           device_type = COALESCE(EXCLUDED.device_type, sessions.device_type),
           first_event_at = COALESCE(sessions.first_event_at, EXCLUDED.first_event_at),
           last_event_at = EXCLUDED.last_event_at,
           last_seen_at = EXCLUDED.last_seen_at`,
        [sessionId, userPseudoId, country, device, occurredAt]
      );

      const eventId = (e?.event_id as string) || (typeof crypto !== 'undefined' && crypto.randomUUID ? crypto.randomUUID() : '');
      if (!eventId) continue;

      const extra: Record<string, unknown> = {
        page_title: e?.page_title ?? null,
        user_agent: ua || null,
        viewport_width: typeof e?.viewport_width === 'number' ? e.viewport_width : null,
        viewport_height: typeof e?.viewport_height === 'number' ? e.viewport_height : null,
        user_pseudo_id: userPseudoId,
      };
      await client.query(
        `INSERT INTO events (
          event_id, session_id, event_type, occurred_at, page_url, page_route, section,
          element_id, element_type, element_text_short, search_query, results_count, search_location,
          extra, entry_id, country, device_type, browser_name, os_name, language,
          referrer_domain, utm_source, utm_medium, utm_campaign
        ) VALUES ($1::uuid, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24)`,
        [
          eventId,
          sessionId,
          (e?.event_type as string) || 'unknown',
          occurredAt,
          pageUrl,
          pageRoute,
          (e?.section as string) || null,
          (e?.element_id as string) || null,
          (e?.element_type as string) || null,
          (e?.element_text_short as string) || null,
          (e?.search_query as string) || null,
          (e?.results_count as number) ?? null,
          (e?.search_location as string) || null,
          JSON.stringify(extra),
          (e?.entry_id as string) || null,
          country,
          device,
          null, // browser_name
          null, // os_name
          language,
          (e?.referrer_domain as string) || null,
          (e?.utm_source as string) || null,
          (e?.utm_medium as string) || null,
          (e?.utm_campaign as string) || null,
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
