/**
 * GET /api/geocode?q=<address>
 * Proxies Nominatim (Israel only) with User-Agent, 1 req/s, and a short in-memory cache.
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';

const USER_AGENT = 'mental-health-services-directory/1.0 (https://nefesh-il.org; /api/geocode)';
const MIN_INTERVAL_MS = 1100;
const CACHE_TTL_MS = 6 * 60 * 60 * 1000;
const CACHE_MAX = 200;

const cache = new Map<string, { at: number; body: unknown }>();
let lastRequestAt = 0;
let chain: Promise<void> = Promise.resolve();

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
    'Access-Control-Allow-Methods': 'GET, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Max-Age': '86400',
  };
}

function normalizeQuery(raw: unknown): string | null {
  if (typeof raw !== 'string') return null;
  const t = raw.trim().replace(/\s+/g, ' ');
  if (t.length < 2 || t.length > 200) return null;
  if (/[\x00-\x08\x0b\x0c\x0e-\x1f]/.test(t)) return null;
  return t;
}

function pruneCache() {
  const now = Date.now();
  for (const [k, v] of cache) {
    if (now - v.at > CACHE_TTL_MS) cache.delete(k);
  }
  while (cache.size > CACHE_MAX) {
    const first = cache.keys().next().value;
    if (first == null) break;
    cache.delete(first);
  }
}

async function nominatim(q: string) {
  const url = new URL('https://nominatim.openstreetmap.org/search');
  url.searchParams.set('q', q);
  url.searchParams.set('format', 'json');
  url.searchParams.set('limit', '1');
  url.searchParams.set('countrycodes', 'il');
  const res = await fetch(url.toString(), {
    headers: { 'User-Agent': USER_AGENT, Accept: 'application/json' },
  });
  if (!res.ok) {
    throw new Error(`nominatim_${res.status}`);
  }
  const data = (await res.json()) as Array<{ lat: string; lon: string; display_name?: string }>;
  const hit = Array.isArray(data) && data[0] ? data[0] : null;
  if (!hit) return { found: false as const };
  return {
    found: true as const,
    lat: Number(hit.lat),
    lng: Number(hit.lon),
    display_name: hit.display_name || q,
  };
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  const origin = req.headers.origin as string | undefined;
  Object.entries(corsHeaders(origin)).forEach(([k, v]) => res.setHeader(k, v));

  if (req.method === 'OPTIONS') {
    return res.status(204).end();
  }
  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const q = normalizeQuery(req.query.q);
  if (!q) {
    return res.status(400).json({ error: 'Invalid q' });
  }

  const cacheKey = q.toLowerCase();
  pruneCache();
  const cached = cache.get(cacheKey);
  if (cached && Date.now() - cached.at < CACHE_TTL_MS) {
    res.setHeader('Cache-Control', 'public, max-age=3600');
    return res.status(200).json(cached.body);
  }

  const run = chain.then(async () => {
    const wait = MIN_INTERVAL_MS - (Date.now() - lastRequestAt);
    if (wait > 0) await new Promise((r) => setTimeout(r, wait));
    lastRequestAt = Date.now();
    return nominatim(q);
  });
  chain = run.then(
    () => undefined,
    () => undefined
  );

  try {
    const body = await run;
    cache.set(cacheKey, { at: Date.now(), body });
    res.setHeader('Cache-Control', 'public, max-age=3600');
    return res.status(200).json(body);
  } catch (err) {
    console.error('geocode error:', err);
    return res.status(502).json({ error: 'Geocode failed' });
  }
}
