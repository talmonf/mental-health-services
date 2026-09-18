/**
 * GET /api/admin/analytics
 * Aggregate usage for signed-in admins. Default dashboard is counts, not identified queries.
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import { getAuthFromRequest, setAuthCors } from '../../lib/auth';
import { pgClient } from '../../lib/db';
import { userIsAdmin } from '../../lib/users';

export default async function handler(req: VercelRequest, res: VercelResponse) {
  setAuthCors(req, res);
  if (req.method === 'OPTIONS') return res.status(204).end();
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });

  const jwtUser = await getAuthFromRequest(req);
  if (!jwtUser) return res.status(401).json({ error: 'Unauthorized' });

  const days = Math.min(Math.max(Number(req.query.days) || 30, 1), 365);
  if (!process.env.DATABASE_URL) return res.status(500).json({ error: 'Server misconfiguration' });

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
              count(*) FILTER (WHERE event_type NOT IN ('page_view', 'search', 'click'))::int AS other
         FROM events
        WHERE occurred_at > now() - ($1 || ' days')::interval
        GROUP BY 1
        ORDER BY 1`,
      [days]
    );

    let requestLog: { recorded_human: number; estimated_human: number; bot: number } | null = null;
    try {
      const rl = await client.query(
        `SELECT
            count(*) FILTER (WHERE NOT is_bot)::int AS recorded_human,
            coalesce(sum(1.0 / nullif(sample_rate, 0)) FILTER (WHERE NOT is_bot), 0)::int AS estimated_human,
            count(*) FILTER (WHERE is_bot)::int AS bot
           FROM request_log
          WHERE occurred_at > now() - ($1 || ' days')::interval`,
        [days]
      );
      requestLog = rl.rows[0] || null;
    } catch {
      requestLog = null;
    }

    const topClicks = await client.query(
      `SELECT coalesce(entry_id, '') AS entry_id,
              coalesce(element_id, '') AS element_id,
              coalesce(element_type, '') AS element_type,
              count(*)::int AS n
         FROM events
        WHERE event_type = 'click'
          AND occurred_at > now() - ($1 || ' days')::interval
        GROUP BY 1, 2, 3
        ORDER BY n DESC
        LIMIT 20`,
      [days]
    );

    const topSearches = await client.query(
      `SELECT search_query, count(*)::int AS n
         FROM events
        WHERE event_type = 'search'
          AND search_query IS NOT NULL
          AND occurred_at > now() - ($1 || ' days')::interval
        GROUP BY 1
        HAVING count(*) >= 3
        ORDER BY n DESC
        LIMIT 20`,
      [days]
    );

    const deepLinks = await client.query(
      `SELECT event_type, count(*)::int AS n
         FROM events
        WHERE occurred_at > now() - ($1 || ' days')::interval
          AND event_type IN (
            'search_link_copied', 'card_link_copied', 'section_link_copied',
            'search_link_opened', 'card_link_opened', 'section_link_opened'
          )
        GROUP BY 1
        ORDER BY n DESC`,
      [days]
    );

    let signedIn = { signed_in_events: 0, anonymous_events: 0 };
    try {
      const si = await client.query(
        `SELECT
            count(*) FILTER (WHERE user_id IS NOT NULL)::int AS signed_in_events,
            count(*) FILTER (WHERE user_id IS NULL)::int AS anonymous_events
           FROM events
          WHERE occurred_at > now() - ($1 || ' days')::interval`,
        [days]
      );
      signedIn = si.rows[0] || signedIn;
    } catch {
      /* user_id column not present yet */
    }

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

    const recentUpdates = await client.query(
      `SELECT id::text, title, published_at
         FROM site_updates
        ORDER BY published_at DESC
        LIMIT 10`
    );

    return res.status(200).json({
      days,
      volume: volume.rows,
      requestLog,
      topClicks: topClicks.rows,
      topSearches: topSearches.rows,
      deepLinks: deepLinks.rows,
      signedIn,
      accounts: {
        total: accountCount.rows[0]?.total ?? 0,
        verified: accountCount.rows[0]?.verified ?? 0,
        byCountry: byCountry.rows,
        byQualification: byQualification.rows,
        byOrganization: byOrganization.rows,
        byFoundVia: byFoundVia.rows,
        byEmailPreference: byEmailPreference.rows,
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
