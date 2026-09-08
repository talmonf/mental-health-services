/**
 * Server-side request logging.
 *
 * Why this exists: GA4 and /api/analytics both require JavaScript, so neither can see a bot
 * (bots do not run JS and therefore never POST) and neither can see a human whose browser
 * blocked or failed the scripts. Static pages mean the server now sees every HTML request,
 * which is the first time this site has had a denominator.
 *
 * Safety rules, which outrank anything this file is trying to measure:
 *   1. Never block or alter the response. The log is best-effort; the page is not.
 *   2. Never await the write on the request path. It goes out through waitUntil.
 *   3. Always honour the kill switch. REQUEST_LOG_DISABLED=1 turns it off without a deploy.
 *
 * A person in crisis loading this page gains nothing from the logging, so it gets no latency
 * budget. Every failure path ends in next().
 *
 * Env:
 *   DATABASE_URL              — Postgres; logging is skipped when absent
 *   REQUEST_LOG_DISABLED=1    — kill switch
 *   REQUEST_LOG_HUMAN_SAMPLE  — 0..1, fraction of non-bot traffic to record (default 0.1)
 */

import { next, waitUntil } from '@vercel/functions';
import { Pool } from 'pg';
import { identifyBot } from './lib/bots';

/**
 * Node rather than the default Edge runtime, so `pg` can be used over TCP. The alternative
 * was adding a second database driver for the Edge runtime, which is not worth it for a
 * one-person project that already depends on `pg` everywhere else.
 */
export const config = {
  runtime: 'nodejs',
  /** HTML routes only. Static assets and /api must not match, or logging would log itself. */
  matcher: ['/', '/directory', '/terms', '/s/:path*', '/c/:path*', '/g/:path*', '/term/:path*'],
};

const HUMAN_SAMPLE = (() => {
  const raw = Number(process.env.REQUEST_LOG_HUMAN_SAMPLE);
  return Number.isFinite(raw) && raw > 0 && raw <= 1 ? raw : 0.1;
})();

/** Matches api/analytics.ts: avoids pg's deprecation warning for prefer/require/verify-ca. */
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

/**
 * Module scope, so a warm invocation reuses the connection instead of opening one per
 * request. max: 1 keeps this from competing with the API functions for Neon connections.
 */
let pool: Pool | null = null;
function getPool(): Pool | null {
  if (pool) return pool;
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) return null;
  pool = new Pool({
    connectionString: normalizePgSslMode(databaseUrl),
    max: 1,
    idleTimeoutMillis: 10_000,
    connectionTimeoutMillis: 3_000,
  });
  pool.on('error', () => {}); // An idle-client error must not become an unhandled rejection.
  return pool;
}

const truncate = (v: string | null, max: number): string | null => (v ? v.slice(0, max) : null);

export default function middleware(request: Request, context?: { waitUntil?: (p: Promise<unknown>) => void }) {
  try {
    if (process.env.REQUEST_LOG_DISABLED === '1') return next();

    const db = getPool();
    if (!db) return next();

    const url = new URL(request.url);
    const userAgent = request.headers.get('user-agent');
    const bot = identifyBot(userAgent);

    // Bots are recorded in full. Humans are sampled, because the human rows exist only to
    // form a ratio against GA4 and the internal endpoint, and a ratio does not need
    // every row. sample_rate is stored so the estimate can be scaled back up.
    const sampleRate = bot ? 1 : HUMAN_SAMPLE;
    if (!bot && Math.random() >= sampleRate) return next();

    const write = db
      .query(
        `INSERT INTO request_log
           (path, method, host, user_agent, referrer, country, is_bot, bot_name, bot_kind, sample_rate)
         VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)`,
        [
          truncate(url.pathname, 500),
          truncate(request.method, 10),
          truncate(url.host, 255),
          truncate(userAgent, 1000),
          truncate(request.headers.get('referer'), 1000),
          truncate(request.headers.get('x-vercel-ip-country'), 8),
          Boolean(bot),
          bot?.name ?? null,
          bot?.kind ?? null,
          sampleRate,
        ]
      )
      .then(
        () => undefined,
        // Swallowed deliberately, including "relation request_log does not exist" before the
        // migration is run. Losing a log row is acceptable; a failed page load is not.
        () => undefined
      );

    if (typeof context?.waitUntil === 'function') context.waitUntil(write);
    else waitUntil(write);
  } catch {
    // Deliberately silent. Any failure here falls through to next(), which is the only
    // outcome that matters to someone loading this page.
  }
  return next();
}
