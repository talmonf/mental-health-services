/**
 * POST /api/link-probe  { "url": "https://..." }
 *
 * Used when a user clicks an outbound link: the page calls this first (same-origin fetch),
 * then navigates only if the target returns a successful HTTP status. Mitigates open-proxy
 * abuse by accepting only URLs that appear literally in index.html (or decodeURI variant).
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import fs from 'fs';
import path from 'path';

const UA =
  'Mozilla/5.0 (compatible; NefeshIL-LinkProbe/1.0; +https://nefesh-il.org) Node.js';

let cachedHtml: string | null = null;

function getIndexHtml(): string {
  if (cachedHtml === null) {
    cachedHtml = fs.readFileSync(path.join(process.cwd(), 'index.html'), 'utf8');
  }
  return cachedHtml;
}

function urlListedInPage(url: string): boolean {
  const html = getIndexHtml();
  if (html.includes(url)) return true;
  try {
    const decoded = decodeURI(url);
    if (decoded !== url && html.includes(decoded)) return true;
  } catch {
    /* ignore */
  }
  return false;
}

type ProbeResult =
  | { tag: 'ok'; status: number; finalUrl: string }
  | { tag: 'missing'; status: number; finalUrl: string }
  | { tag: 'bad_url'; message?: string }
  | { tag: 'not_allowed'; message?: string }
  | { tag: 'error'; message?: string };

async function probe(url: string, timeoutMs: number): Promise<ProbeResult> {
  let parsed: URL;
  try {
    parsed = new URL(url);
  } catch {
    return { tag: 'bad_url', message: 'Invalid URL' };
  }
  if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') {
    return { tag: 'bad_url', message: 'Only http(s) supported' };
  }
  if (url.length > 4096) {
    return { tag: 'bad_url', message: 'URL too long' };
  }

  if (!urlListedInPage(url)) {
    return { tag: 'not_allowed', message: 'URL not found in site content' };
  }

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);
  const init = {
    redirect: 'follow' as RequestRedirect,
    signal: controller.signal,
    headers: { 'User-Agent': UA, Accept: '*/*' },
  };

  try {
    let res = await fetch(url, { method: 'HEAD', ...init });
    if (!res.ok || res.status === 405 || res.status === 501) {
      res = await fetch(url, { method: 'GET', ...init });
    }
    const finalUrl = res.url;
    if (res.ok) {
      return { tag: 'ok', status: res.status, finalUrl };
    }
    /* Many sites return 403/401 to datacenter probes while browsers work — only treat clear "missing" as broken. */
    if (res.status === 404 || res.status === 410) {
      return { tag: 'missing', status: res.status, finalUrl };
    }
    return { tag: 'ok', status: res.status, finalUrl };
  } catch (e) {
    const err = e as Error;
    const name = err?.name || 'Error';
    const msg = err?.message || String(e);
    if (name === 'AbortError') {
      return { tag: 'error', message: `Timeout after ${timeoutMs}ms` };
    }
    return { tag: 'error', message: `${name}: ${msg}` };
  } finally {
    clearTimeout(timer);
  }
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

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

  const url = typeof (body as { url?: unknown })?.url === 'string' ? (body as { url: string }).url.trim() : '';
  if (!url) {
    return res.status(400).json({ error: 'Missing url' });
  }

  const TIMEOUT_MS = 10000;
  const result = await probe(url, TIMEOUT_MS);

  if (result.tag === 'ok') {
    return res.status(200).json({ ok: true, status: result.status, finalUrl: result.finalUrl });
  }

  if (result.tag === 'missing') {
    return res.status(200).json({
      ok: false,
      reason: 'http',
      status: result.status,
      finalUrl: result.finalUrl,
    });
  }

  if (result.tag === 'not_allowed' || result.tag === 'bad_url') {
    return res.status(400).json({ ok: false, reason: result.tag, message: result.message });
  }

  /* probe transport error — client should fail-open to normal navigation */
  if (result.tag === 'error') {
    return res.status(200).json({
      ok: false,
      reason: 'probe_error',
      message: result.message || 'Probe failed',
    });
  }

  return res.status(200).json({ ok: false, reason: 'probe_error', message: 'Probe failed' });
}
