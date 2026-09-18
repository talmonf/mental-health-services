/**
 * One Serverless Function for /api/admin/analytics, /api/admin/users, and /api/admin/updates.
 * See api/auth/[action].ts for why these are not separate files.
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import { getAuthFromRequest, originAllowed, parseJsonBody, setAuthCors } from '../../lib/auth';
import { pgClient } from '../../lib/db';
import { enqueueImmediateEmails, processOutbox } from '../../lib/email';
import {
  ADMIN_USER_COLUMNS,
  adminUserFromRow,
  USER_PUBLIC_COLUMNS,
  userIsAdmin,
} from '../../lib/users';
import type { Client } from 'pg';

const DEEP_LINK_TYPES = [
  'search_link_copied',
  'card_link_copied',
  'section_link_copied',
  'search_link_opened',
  'card_link_opened',
  'section_link_opened',
] as const;

const EVENT_TYPES = ['page_view', 'search', 'click', 'deep-link'] as const;
const DEVICES = ['mobile', 'desktop', 'tablet'] as const;
const AUDIENCES = ['signed-in', 'anonymous'] as const;

function resourceName(req: VercelRequest): string {
  const raw = req.query.resource;
  return typeof raw === 'string' ? raw : Array.isArray(raw) ? raw[0] || '' : '';
}

function qstr(query: VercelRequest['query'], key: string): string {
  const raw = query[key];
  const v = typeof raw === 'string' ? raw : Array.isArray(raw) ? raw[0] || '' : '';
  return v.trim();
}

function isYmd(v: string): boolean {
  return /^\d{4}-\d{2}-\d{2}$/.test(v);
}

type SqlFilter = {
  dateWhere: string;
  dateParams: unknown[];
  eventWhere: string;
  eventParams: unknown[];
  days: number;
  from: string | null;
  to: string | null;
  eventType: string;
  device: string;
  audience: string;
  country: string;
  section: string;
};

function parseAnalyticsFilters(query: VercelRequest['query']): SqlFilter {
  const from = isYmd(qstr(query, 'from')) ? qstr(query, 'from') : '';
  const to = isYmd(qstr(query, 'to')) ? qstr(query, 'to') : '';
  const eventTypeRaw = qstr(query, 'event_type');
  const deviceRaw = qstr(query, 'device');
  const audienceRaw = qstr(query, 'audience');
  const country = qstr(query, 'country').slice(0, 80);
  const section = qstr(query, 'section').slice(0, 80);
  const eventType = (EVENT_TYPES as readonly string[]).includes(eventTypeRaw) ? eventTypeRaw : '';
  const device = (DEVICES as readonly string[]).includes(deviceRaw) ? deviceRaw : '';
  const audience = (AUDIENCES as readonly string[]).includes(audienceRaw) ? audienceRaw : '';

  let dateWhere: string;
  let dateParams: unknown[];
  let days: number;
  let fromOut: string | null = null;
  let toOut: string | null = null;

  if (from && to) {
    const fromTime = Date.parse(`${from}T00:00:00Z`);
    const toTime = Date.parse(`${to}T00:00:00Z`);
    let start = from;
    let end = to;
    if (Number.isFinite(fromTime) && Number.isFinite(toTime) && toTime < fromTime) {
      start = to;
      end = from;
    }
    const startMs = Date.parse(`${start}T00:00:00Z`);
    const endMs = Date.parse(`${end}T00:00:00Z`);
    const span = Math.max(1, Math.round((endMs - startMs) / 86400000) + 1);
    if (span > 365) {
      const clipped = new Date(endMs - 364 * 86400000);
      start = clipped.toISOString().slice(0, 10);
      days = 365;
    } else {
      days = span;
    }
    dateWhere = `occurred_at >= $1::date AND occurred_at < ($2::date + interval '1 day')`;
    dateParams = [start, end];
    fromOut = start;
    toOut = end;
  } else {
    days = Math.min(Math.max(Number(qstr(query, 'days')) || 30, 1), 365);
    dateWhere = `occurred_at > now() - ($1 || ' days')::interval`;
    dateParams = [days];
  }

  const extra: string[] = [];
  const eventParams = [...dateParams];
  const add = (sql: string, value: unknown) => {
    eventParams.push(value);
    extra.push(sql.replace('?', `$${eventParams.length}`));
  };

  if (eventType === 'deep-link') {
    extra.push(`event_type IN (${DEEP_LINK_TYPES.map((t) => `'${t}'`).join(', ')})`);
  } else if (eventType) {
    add('event_type = ?', eventType);
  }
  if (device) add('device_type = ?', device);
  if (audience === 'signed-in') extra.push('user_id IS NOT NULL');
  if (audience === 'anonymous') extra.push('user_id IS NULL');
  if (country) add('country = ?', country);
  if (section) add('section = ?', section);

  const eventWhere = extra.length ? `${dateWhere} AND ${extra.join(' AND ')}` : dateWhere;

  return {
    dateWhere,
    dateParams,
    eventWhere,
    eventParams,
    days,
    from: fromOut,
    to: toOut,
    eventType,
    device,
    audience,
    country,
    section,
  };
}

async function requireAdmin(req: VercelRequest, res: VercelResponse, client: Client): Promise<boolean> {
  const jwtUser = await getAuthFromRequest(req);
  if (!jwtUser) {
    res.status(401).json({ error: 'Unauthorized' });
    return false;
  }
  if (!(await userIsAdmin(client, jwtUser.id))) {
    res.status(403).json({ error: 'Forbidden' });
    return false;
  }
  return true;
}

async function handleAnalytics(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });

  const jwtUser = await getAuthFromRequest(req);
  if (!jwtUser) return res.status(401).json({ error: 'Unauthorized' });
  if (!process.env.DATABASE_URL) return res.status(500).json({ error: 'Server misconfiguration' });

  const filters = parseAnalyticsFilters(req.query);
  const client = pgClient();
  try {
    await client.connect();
    if (!(await userIsAdmin(client, jwtUser.id))) {
      return res.status(403).json({ error: 'Forbidden' });
    }

    const volume = await client.query(
      `SELECT date_trunc('day', occurred_at)::date AS day,
              count(*) FILTER (WHERE event_type = 'page_view')::int AS page_view,
              count(*) FILTER (WHERE event_type = 'search')::int AS search,
              count(*) FILTER (WHERE event_type = 'click')::int AS click,
              count(*) FILTER (WHERE event_type NOT IN ('page_view', 'search', 'click'))::int AS other,
              count(*)::int AS total
         FROM events
        WHERE ${filters.eventWhere}
        GROUP BY 1
        ORDER BY 1`,
      filters.eventParams
    );

    let requestLog: { recorded_human: number; estimated_human: number; bot: number } | null = null;
    try {
      const rl = await client.query(
        `SELECT
            count(*) FILTER (WHERE NOT is_bot)::int AS recorded_human,
            coalesce(sum(1.0 / nullif(sample_rate, 0)) FILTER (WHERE NOT is_bot), 0)::int AS estimated_human,
            count(*) FILTER (WHERE is_bot)::int AS bot
           FROM request_log
          WHERE ${filters.dateWhere}`,
        filters.dateParams
      );
      requestLog = rl.rows[0] || null;
    } catch {
      requestLog = null;
    }

    const kpis = await client.query(
      `SELECT
          count(*) FILTER (WHERE event_type = 'page_view')::int AS page_view,
          count(*) FILTER (WHERE event_type = 'search')::int AS search,
          count(*) FILTER (WHERE event_type = 'click')::int AS click,
          count(DISTINCT session_id)::int AS unique_sessions,
          count(*)::int AS total
         FROM events
        WHERE ${filters.eventWhere}`,
      filters.eventParams
    );

    let signedIn = { signed_in_events: 0, anonymous_events: 0 };
    try {
      const si = await client.query(
        `SELECT
            count(*) FILTER (WHERE user_id IS NOT NULL)::int AS signed_in_events,
            count(*) FILTER (WHERE user_id IS NULL)::int AS anonymous_events
           FROM events
          WHERE ${filters.eventWhere}`,
        filters.eventParams
      );
      signedIn = si.rows[0] || signedIn;
    } catch {
      /* user_id column not present yet */
    }

    const topClicks = await client.query(
      `SELECT coalesce(entry_id, '') AS entry_id,
              coalesce(element_id, '') AS element_id,
              coalesce(element_type, '') AS element_type,
              count(*)::int AS n
         FROM events
        WHERE event_type = 'click'
          AND ${filters.eventWhere}
        GROUP BY 1, 2, 3
        ORDER BY n DESC
        LIMIT 20`,
      filters.eventParams
    );

    const topSearches = await client.query(
      `SELECT search_query, count(*)::int AS n
         FROM events
        WHERE event_type = 'search'
          AND search_query IS NOT NULL
          AND ${filters.eventWhere}
        GROUP BY 1
        HAVING count(*) >= 3
        ORDER BY n DESC
        LIMIT 20`,
      filters.eventParams
    );

    const deepLinks = await client.query(
      `SELECT event_type, count(*)::int AS n
         FROM events
        WHERE ${filters.eventWhere}
          AND event_type IN (
            'search_link_copied', 'card_link_copied', 'section_link_copied',
            'search_link_opened', 'card_link_opened', 'section_link_opened'
          )
        GROUP BY 1
        ORDER BY n DESC`,
      filters.eventParams
    );

    const byDevice = await client.query(
      `SELECT coalesce(nullif(device_type, ''), '(unknown)') AS key, count(*)::int AS n
         FROM events
        WHERE ${filters.eventWhere}
        GROUP BY 1
        ORDER BY n DESC`,
      filters.eventParams
    );
    const byCountry = await client.query(
      `SELECT coalesce(nullif(country, ''), '(unknown)') AS key, count(*)::int AS n
         FROM events
        WHERE ${filters.eventWhere}
        GROUP BY 1
        ORDER BY n DESC
        LIMIT 20`,
      filters.eventParams
    );
    const bySection = await client.query(
      `SELECT coalesce(nullif(section, ''), '(none)') AS key, count(*)::int AS n
         FROM events
        WHERE ${filters.eventWhere}
        GROUP BY 1
        ORDER BY n DESC
        LIMIT 20`,
      filters.eventParams
    );

    const optionCountries = await client.query(
      `SELECT DISTINCT country AS key
         FROM events
        WHERE ${filters.dateWhere}
          AND country IS NOT NULL AND country <> ''
        ORDER BY 1
        LIMIT 80`,
      filters.dateParams
    );
    const optionSections = await client.query(
      `SELECT DISTINCT section AS key
         FROM events
        WHERE ${filters.dateWhere}
          AND section IS NOT NULL AND section <> ''
        ORDER BY 1
        LIMIT 80`,
      filters.dateParams
    );

    const recentUpdates = await client.query(
      `SELECT id::text, title, published_at
         FROM site_updates
        ORDER BY published_at DESC
        LIMIT 10`
    );

    return res.status(200).json({
      days: filters.days,
      from: filters.from,
      to: filters.to,
      filters: {
        eventType: filters.eventType,
        device: filters.device,
        audience: filters.audience,
        country: filters.country,
        section: filters.section,
      },
      kpis: {
        page_view: kpis.rows[0]?.page_view ?? 0,
        search: kpis.rows[0]?.search ?? 0,
        click: kpis.rows[0]?.click ?? 0,
        unique_sessions: kpis.rows[0]?.unique_sessions ?? 0,
        total: kpis.rows[0]?.total ?? 0,
      },
      volume: volume.rows,
      requestLog,
      topClicks: topClicks.rows,
      topSearches: topSearches.rows,
      deepLinks: deepLinks.rows,
      signedIn,
      byDevice: byDevice.rows,
      byCountry: byCountry.rows,
      bySection: bySection.rows,
      filterOptions: {
        countries: optionCountries.rows.map((r: { key: string }) => r.key),
        sections: optionSections.rows.map((r: { key: string }) => r.key),
      },
      recentUpdates: recentUpdates.rows,
    });
  } catch (err) {
    console.error('admin analytics error', err);
    return res.status(500).json({ error: 'Failed to load analytics' });
  } finally {
    await client.end().catch(() => {});
  }
}

async function accountBreakdowns(client: Client) {
  const accountCount = await client.query(
    `SELECT
        count(*)::int AS total,
        count(*) FILTER (WHERE email_verified_at IS NOT NULL)::int AS verified
       FROM users`
  );
  const byCountry = await client.query(
    `SELECT country AS key, count(*)::int AS n FROM users GROUP BY 1 ORDER BY n DESC LIMIT 20`
  );
  const byQualification = await client.query(
    `SELECT qualification AS key, count(*)::int AS n FROM users GROUP BY 1 ORDER BY n DESC`
  );
  const byOrganization = await client.query(
    `SELECT organization AS key, count(*)::int AS n FROM users GROUP BY 1 ORDER BY n DESC LIMIT 20`
  );
  const byFoundVia = await client.query(
    `SELECT found_via AS key, count(*)::int AS n FROM users GROUP BY 1 ORDER BY n DESC`
  );
  const byEmailPreference = await client.query(
    `SELECT email_preference AS key, count(*)::int AS n FROM users GROUP BY 1 ORDER BY n DESC`
  );
  return {
    total: accountCount.rows[0]?.total ?? 0,
    verified: accountCount.rows[0]?.verified ?? 0,
    byCountry: byCountry.rows,
    byQualification: byQualification.rows,
    byOrganization: byOrganization.rows,
    byFoundVia: byFoundVia.rows,
    byEmailPreference: byEmailPreference.rows,
  };
}

async function handleUsers(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });
  if (!process.env.DATABASE_URL) return res.status(500).json({ error: 'Server misconfiguration' });

  const q = qstr(req.query, 'q').slice(0, 120);
  const sortRaw = qstr(req.query, 'sort');
  const dirRaw = qstr(req.query, 'dir').toLowerCase() === 'asc' ? 'ASC' : 'DESC';
  const sortCols: Record<string, string> = {
    created_at: 'created_at',
    last_access_at: 'last_access_at',
    email_verified_at: 'email_verified_at',
    email: 'email',
  };
  const sortCol = sortCols[sortRaw] || 'created_at';
  const nulls = sortCol === 'last_access_at' || sortCol === 'email_verified_at' ? ' NULLS LAST' : '';

  const client = pgClient();
  try {
    await client.connect();
    if (!(await requireAdmin(req, res, client))) return;

    const params: unknown[] = [];
    let where = '';
    if (q) {
      params.push(`%${q}%`);
      where = `WHERE (email ILIKE $1 OR organization ILIKE $1 OR title ILIKE $1 OR coalesce(city, '') ILIKE $1 OR country ILIKE $1)`;
    }

    let rows;
    try {
      const result = await client.query(
        `SELECT ${ADMIN_USER_COLUMNS}
           FROM users
           ${where}
          ORDER BY ${sortCol} ${dirRaw}${nulls}, created_at DESC
          LIMIT 500`,
        params
      );
      rows = result.rows;
    } catch (err) {
      const code = (err as { code?: string }).code;
      if (code !== '42703') throw err;
      const result = await client.query(
        `SELECT ${USER_PUBLIC_COLUMNS}, created_at
           FROM users
           ${where}
          ORDER BY created_at ${dirRaw}
          LIMIT 500`,
        params
      );
      rows = result.rows;
    }

    const accounts = await accountBreakdowns(client);
    return res.status(200).json({
      users: rows.map((row: Record<string, unknown>) => adminUserFromRow(row)),
      accounts,
    });
  } catch (err) {
    console.error('admin users error', err);
    return res.status(500).json({ error: 'Failed to load users' });
  } finally {
    await client.end().catch(() => {});
  }
}

async function handleUpdates(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
  if (!originAllowed(req)) return res.status(403).json({ error: 'Forbidden' });

  const jwtUser = await getAuthFromRequest(req);
  if (!jwtUser) return res.status(401).json({ error: 'Unauthorized' });

  const body = parseJsonBody(req);
  if (!body) return res.status(400).json({ error: 'Invalid JSON' });
  const title = typeof body.title === 'string' ? body.title.trim() : '';
  const text = typeof body.body === 'string' ? body.body.trim() : '';
  if (!title || !text) return res.status(400).json({ error: 'Title and body are required' });
  if (!process.env.DATABASE_URL) return res.status(500).json({ error: 'Server misconfiguration' });

  const client = pgClient();
  try {
    await client.connect();
    if (!(await userIsAdmin(client, jwtUser.id))) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    const inserted = await client.query(
      `INSERT INTO site_updates (title, body, published_by)
       VALUES ($1, $2, $3)
       RETURNING id::text, title, body, published_at`,
      [title.slice(0, 200), text.slice(0, 8000), jwtUser.id]
    );
    const update = inserted.rows[0];
    const queued = await enqueueImmediateEmails(client, update.id);
    const send = await processOutbox(client);
    return res.status(201).json({ update, queued, send });
  } catch (err) {
    console.error('admin updates error', err);
    return res.status(500).json({ error: 'Failed to publish update' });
  } finally {
    await client.end().catch(() => {});
  }
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  setAuthCors(req, res);
  if (req.method === 'OPTIONS') return res.status(204).end();

  switch (resourceName(req)) {
    case 'analytics':
      return handleAnalytics(req, res);
    case 'users':
      return handleUsers(req, res);
    case 'updates':
      return handleUpdates(req, res);
    default:
      return res.status(404).json({ error: 'Not found' });
  }
}
