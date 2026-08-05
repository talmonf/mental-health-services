/**
 * Vercel serverless: POST /api/analytics
 * Expects Neon DB with:
 * - sessions (session_id PK/unique, user_pseudo_id, country, device_type, first_event_at, last_event_at, first_seen_at, last_seen_at)
 * - events (event_id uuid, session_id, event_type, occurred_at, page_url, page_route, section,
 *   element_id, element_type, element_text_short, search_query, results_count, search_location,
 *   extra jsonb, entry_id, country, device_type, browser_name, os_name, language, referrer_domain, utm_*,
 *   error text NULL, error_details text NULL)
 *
 * Migration: scripts/analytics_events_add_error_columns.sql
 * Migration: scripts/012_events_allow_deep_link_event_types.sql (required for deep-link event_type values)
 * Migration: scripts/014_events_allow_section_link_event_types.sql (section_link_copied / section_link_opened)
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import { Client } from 'pg';
import { UAParser } from 'ua-parser-js';

const ALLOWED_ORIGINS = process.env.ANALYTICS_ALLOWED_ORIGINS
  ? process.env.ANALYTICS_ALLOWED_ORIGINS.split(',').map((o) => o.trim())
  : ['*'];

/** Known-safe event_type values if the DB still has the old CHECK/ENUM. */
const LEGACY_EVENT_TYPES = new Set(['search', 'click', 'page_view']);

/**
 * If deep-link types are still blocked by a DB constraint, store under a legacy
 * event_type and keep the intended name in search_location / element_type.
 */
const EVENT_TYPE_FALLBACK: Record<string, string> = {
  share: 'click',
  search_link_copied: 'click',
  card_link_copied: 'click',
  entry_link_copied: 'click',
  section_link_copied: 'click',
  search_link_opened: 'search',
  card_link_opened: 'page_view',
  section_link_opened: 'page_view',
};

/** Use sslmode=verify-full when pg would treat prefer/require/verify-ca as verify-full, to avoid the deprecation warning. */
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

function deviceType(ua: string | undefined): string {
  if (!ua) return 'unknown';
  const u = ua.toLowerCase();
  if (/mobile|android|iphone|ipod|blackberry|iemobile|opera mini/i.test(u)) return 'mobile';
  if (/tablet|ipad|playbook|silk/i.test(u)) return 'tablet';
  return 'desktop';
}

const ERROR_DETAILS_MAX = 8000;

/** Client may send error: 'error' and/or error_details (string or JSON-serializable). */
function normalizeErrorFields(e: Record<string, unknown>): { error: string | null; error_details: string | null } {
  let errorDetails: string | null = null;
  const raw = e?.error_details;
  if (raw != null) {
    if (typeof raw === 'string') {
      errorDetails = raw.slice(0, ERROR_DETAILS_MAX);
    } else {
      try {
        errorDetails = JSON.stringify(raw).slice(0, ERROR_DETAILS_MAX);
      } catch {
        errorDetails = String(raw).slice(0, ERROR_DETAILS_MAX);
      }
    }
  }
  const er = e?.error;
  const isErrorTag = typeof er === 'string' && er.trim() === 'error';
  if (isErrorTag) {
    return { error: 'error', error_details: errorDetails };
  }
  if (errorDetails) {
    return { error: 'error', error_details: errorDetails };
  }
  return { error: null, error_details: null };
}

function isEventTypeConstraintError(err: unknown): boolean {
  const e = err as { code?: string; message?: string };
  const code = e?.code || '';
  // 23514 = check_violation, 22P02 = invalid_text_representation (enum)
  if (code === '23514' || code === '22P02') return true;
  const msg = (e?.message || '').toLowerCase();
  return msg.includes('event_type') || msg.includes('check constraint') || msg.includes('invalid input value for enum');
}

/** Expand CHECK/ENUM so deep-link event_type values can be stored. Idempotent. */
async function ensureDeepLinkEventTypesAllowed(client: Client): Promise<void> {
  await client.query(`
DO $$
DECLARE
  col_udt text;
  is_enum boolean := false;
  con record;
  enum_label text;
  labels text[] := ARRAY[
    'search',
    'click',
    'page_view',
    'share',
    'search_link_copied',
    'card_link_copied',
    'search_link_opened',
    'card_link_opened',
    'section_link_copied',
    'section_link_opened',
    'entry_link_copied',
    'unknown'
  ];
BEGIN
  SELECT c.udt_name
  INTO col_udt
  FROM information_schema.columns c
  WHERE c.table_schema = 'public'
    AND c.table_name = 'events'
    AND c.column_name = 'event_type';

  IF col_udt IS NULL THEN
    RETURN;
  END IF;

  SELECT EXISTS (
    SELECT 1 FROM pg_type t
    JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE n.nspname = 'public'
      AND t.typname = col_udt
      AND t.typtype = 'e'
  ) INTO is_enum;

  IF is_enum THEN
    FOREACH enum_label IN ARRAY labels LOOP
      BEGIN
        EXECUTE format('ALTER TYPE public.%I ADD VALUE IF NOT EXISTS %L', col_udt, enum_label);
      EXCEPTION
        WHEN duplicate_object THEN NULL;
      END;
    END LOOP;
    RETURN;
  END IF;

  FOR con IN
    SELECT c.conname
    FROM pg_constraint c
    JOIN pg_class t ON c.conrelid = t.oid
    JOIN pg_namespace n ON n.oid = t.relnamespace
    WHERE n.nspname = 'public'
      AND t.relname = 'events'
      AND c.contype = 'c'
      AND pg_get_constraintdef(c.oid) ILIKE '%event_type%'
  LOOP
    EXECUTE format('ALTER TABLE public.events DROP CONSTRAINT %I', con.conname);
  END LOOP;

  ALTER TABLE public.events
    ADD CONSTRAINT events_event_type_check
    CHECK (
      event_type IN (
        'search',
        'click',
        'page_view',
        'share',
        'search_link_copied',
        'card_link_copied',
        'search_link_opened',
        'card_link_opened',
        'section_link_copied',
        'section_link_opened',
        'entry_link_copied',
        'unknown'
      )
    );
END $$;
`);
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

  // Use verify-full to avoid pg SSL mode warning and keep current secure behavior
  const connectionString = normalizePgSslMode(databaseUrl);

  const country = (req.headers['x-vercel-ip-country'] as string) || null;
  const acceptLanguage = req.headers['accept-language'] as string | undefined;
  const language = acceptLanguage ? acceptLanguage.split(',')[0].trim().slice(0, 50) : null;

  const client = new Client({ connectionString });
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
          const parsed = new URL(pageUrl);
          pageRoute = (parsed.pathname || '/') + (parsed.hash || '');
          pageRoute = pageRoute.slice(0, 500) || null;
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

      let browserName: string | null = null;
      let osName: string | null = null;
      if (ua) {
        try {
          const parsed = UAParser(ua);
          browserName = parsed.browser?.name ? parsed.browser.name.slice(0, 100) : null;
          osName = parsed.os?.name ? parsed.os.name.slice(0, 100) : null;
        } catch {
          /* ignore parse errors */
        }
      }

      const extra: Record<string, unknown> = {
        page_title: e?.page_title ?? null,
        user_agent: ua || null,
        viewport_width: typeof e?.viewport_width === 'number' ? e.viewport_width : null,
        viewport_height: typeof e?.viewport_height === 'number' ? e.viewport_height : null,
        user_pseudo_id: userPseudoId,
        entry_hostname: (e?.entry_hostname as string) || null,
        entry_origin: (e?.entry_origin as string) || null,
        entry_url: (e?.entry_url as string) || null,
      };
      const { error: errorCol, error_details: errorDetailsCol } = normalizeErrorFields(e);

      const requestedType = ((e?.event_type as string) || 'unknown').trim() || 'unknown';
      let eventType = requestedType;
      let searchLocation = (e?.search_location as string) || null;
      let elementType = (e?.element_type as string) || null;
      // Preserve intended deep-link type even if we must fall back on insert.
      if (!LEGACY_EVENT_TYPES.has(requestedType)) {
        if (!searchLocation) searchLocation = requestedType;
        if (!elementType) elementType = requestedType;
        extra.requested_event_type = requestedType;
      }

      const insertEvent = async (type: string, loc: string | null, elType: string | null) => {
        await client.query(
          `INSERT INTO events (
            event_id, session_id, event_type, occurred_at, page_url, page_route, section,
            element_id, element_type, element_text_short, search_query, results_count, search_location,
            extra, entry_id, country, device_type, browser_name, os_name, language,
            referrer_domain, utm_source, utm_medium, utm_campaign,
            error, error_details
          ) VALUES ($1::uuid, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26)`,
          [
            eventId,
            sessionId,
            type,
            occurredAt,
            pageUrl,
            pageRoute,
            (e?.section as string) || null,
            (e?.element_id as string) || null,
            elType,
            (e?.element_text_short as string) || null,
            (e?.search_query as string) || null,
            (e?.results_count as number) ?? null,
            loc,
            JSON.stringify(extra),
            ((e?.entry_id as string) || null)?.slice(0, 255) || null,
            country,
            device,
            browserName,
            osName,
            language,
            ((e?.referrer_domain as string) || null)?.slice(0, 255) || null,
            ((e?.utm_source as string) || null)?.slice(0, 255) || null,
            ((e?.utm_medium as string) || null)?.slice(0, 255) || null,
            ((e?.utm_campaign as string) || null)?.slice(0, 255) || null,
            errorCol,
            errorDetailsCol,
          ]
        );
      };

      try {
        await insertEvent(eventType, searchLocation, elementType);
      } catch (insertErr) {
        if (!isEventTypeConstraintError(insertErr)) throw insertErr;

        // Self-heal: expand DB allowlist, then retry with the intended event_type.
        try {
          console.warn(
            `Analytics event_type "${requestedType}" rejected by DB; expanding allowlist and retrying`
          );
          await ensureDeepLinkEventTypesAllowed(client);
          await insertEvent(requestedType, searchLocation || requestedType, elementType || requestedType);
        } catch (healErr) {
          const fallback = EVENT_TYPE_FALLBACK[requestedType];
          if (!fallback) throw healErr;
          console.warn(
            `Analytics allowlist expand failed; storing "${requestedType}" as "${fallback}"`,
            healErr
          );
          extra.event_type_fallback_from = requestedType;
          await insertEvent(
            fallback,
            searchLocation || requestedType,
            elementType || requestedType
          );
        }
      }
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
