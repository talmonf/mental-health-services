/**
 * GET /api/link-check
 *
 * Scans index.html for unique http(s) URLs, verifies each (follow redirects, non-2xx and
 * network/timeout/abort errors count as failures), and emails a report when any fail.
 *
 * Invoke (manual): curl -H "Authorization: Bearer $CRON_SECRET" "https://<your-domain>/api/link-check"
 * Vercel Cron sends the same Authorization header when CRON_SECRET is set in project env.
 *
 * Env:
 *   CRON_SECRET            — required in production; must match Bearer token
 *   RESEND_API_KEY         — Resend API key (https://resend.com)
 *   LINK_CHECK_FROM_EMAIL  — verified sender in Resend (e.g. alerts@yourdomain.com)
 *   LINK_CHECK_NOTIFY_EMAIL — recipient address(es); comma-separated for multiple
 *   LINK_CHECK_SKIP_HOSTS  — optional extra hosts to skip (comma-separated), e.g. cdn.example.com
 *   LINK_CHECK_IGNORE_URLS — optional exact URLs to skip (comma-separated)
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import fs from 'fs';
import path from 'path';

/** Base hostnames; any subdomain of these is skipped (e.g. fonts.googleapis.com → googleapis.com). */
const DEFAULT_SKIP_HOSTS = new Set([
  'unpkg.com',
  'googletagmanager.com',
  'google-analytics.com',
  'googleapis.com',
  'gstatic.com',
  'cdnjs.cloudflare.com',
]);

const UA =
  'Mozilla/5.0 (compatible; NefeshIL-LinkCheck/1.0; +https://nefesh-il.org) Node.js';

function loadSkipHosts(): Set<string> {
  const s = new Set(DEFAULT_SKIP_HOSTS);
  const extra = process.env.LINK_CHECK_SKIP_HOSTS;
  if (extra) {
    extra.split(',').forEach((h) => {
      const t = h.trim().toLowerCase().replace(/^\.+/, '');
      if (t) s.add(t);
    });
  }
  return s;
}

function shouldSkipHost(hostname: string, skipHosts: Set<string>): boolean {
  const h = hostname.toLowerCase();
  if (skipHosts.has(h)) return true;
  for (const base of skipHosts) {
    if (h.endsWith(`.${base}`)) return true;
  }
  return false;
}

function loadIgnoreUrls(): Set<string> {
  const s = new Set<string>();
  const raw = process.env.LINK_CHECK_IGNORE_URLS;
  if (raw) {
    raw.split(',').forEach((u) => {
      const t = u.trim();
      if (t) s.add(t);
    });
  }
  return s;
}

function extractUrls(html: string): string[] {
  const found = new Set<string>();
  const re = /https?:\/\/[^\s"'<>)*\]\\,}]+/g;
  let m: RegExpExecArray | null;
  while ((m = re.exec(html)) !== null) {
    let u = m[0].replace(/[.,;:)]+$/, '');
    try {
      const parsed = new URL(u);
      if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') continue;
      found.add(parsed.href);
    } catch {
      /* skip malformed */
    }
  }
  return [...found];
}

function locationsForUrl(html: string, url: string): string[] {
  const lines = html.split('\n');
  const locs: string[] = [];
  lines.forEach((line, idx) => {
    if (line.includes(url)) locs.push(`index.html:${idx + 1}`);
  });
  return locs;
}

function authorize(req: VercelRequest): boolean {
  const secret = process.env.CRON_SECRET;
  if (!secret) {
    return process.env.VERCEL_ENV !== 'production';
  }
  const auth = req.headers.authorization;
  return auth === `Bearer ${secret}`;
}

type CheckOutcome =
  | { type: 'ok'; status: number; finalUrl: string }
  | { type: 'http'; status: number; finalUrl: string }
  | { type: 'error'; message: string };

async function probeUrl(url: string, timeoutMs: number): Promise<CheckOutcome> {
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
      return { type: 'ok', status: res.status, finalUrl };
    }
    return { type: 'http', status: res.status, finalUrl };
  } catch (e) {
    const err = e as Error;
    const name = err?.name || 'Error';
    const msg = err?.message || String(e);
    if (name === 'AbortError') {
      return { type: 'error', message: `Timeout after ${timeoutMs}ms` };
    }
    return { type: 'error', message: `${name}: ${msg}` };
  } finally {
    clearTimeout(timer);
  }
}

function describeFailure(out: CheckOutcome): string {
  if (out.type === 'http') {
    return `HTTP ${out.status}${out.finalUrl ? ` (final: ${out.finalUrl})` : ''}`;
  }
  if (out.type === 'error') {
    return out.message;
  }
  return '';
}

async function sendResendEmail(subject: string, text: string): Promise<{ ok: boolean; error?: string }> {
  const key = process.env.RESEND_API_KEY;
  const from = process.env.LINK_CHECK_FROM_EMAIL;
  const toRaw = process.env.LINK_CHECK_NOTIFY_EMAIL;
  if (!key || !from || !toRaw) {
    return { ok: false, error: 'Missing RESEND_API_KEY, LINK_CHECK_FROM_EMAIL, or LINK_CHECK_NOTIFY_EMAIL' };
  }
  const to = toRaw.split(',').map((s) => s.trim()).filter(Boolean);
  const res = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${key}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ from, to, subject, text }),
  });
  if (!res.ok) {
    const body = await res.text();
    return { ok: false, error: `Resend ${res.status}: ${body.slice(0, 500)}` };
  }
  return { ok: true };
}

function readIndexHtml(): string {
  const p = path.join(process.cwd(), 'index.html');
  return fs.readFileSync(p, 'utf8');
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  if (!authorize(req)) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  let html: string;
  try {
    html = readIndexHtml();
  } catch (e) {
    console.error('link-check: cannot read index.html', e);
    return res.status(500).json({ error: 'Could not read index.html (check Vercel includeFiles for this function)' });
  }

  const skipHosts = loadSkipHosts();
  const ignoreUrls = loadIgnoreUrls();
  const allUrls = extractUrls(html);

  const toCheck = allUrls.filter((u) => {
    if (ignoreUrls.has(u)) return false;
    try {
      const host = new URL(u).hostname;
      if (shouldSkipHost(host, skipHosts)) return false;
    } catch {
      return false;
    }
    return true;
  });

  const TIMEOUT_MS = 12000;
  const outcomes = await Promise.all(
    toCheck.map(async (url) => {
      const outcome = await probeUrl(url, TIMEOUT_MS);
      return { url, outcome };
    })
  );

  const failures = outcomes.filter(({ outcome }) => outcome.type !== 'ok');

  const failureReport = failures.map(({ url, outcome }) => {
    const where = locationsForUrl(html, url);
    const whereStr = where.length ? where.join(', ') : 'index.html (line unknown — URL may differ slightly in file)';
    return [`URL: ${url}`, `  Problem: ${describeFailure(outcome)}`, `  Where: ${whereStr}`].join('\n');
  });

  const emailConfigured = Boolean(
    process.env.RESEND_API_KEY && process.env.LINK_CHECK_FROM_EMAIL && process.env.LINK_CHECK_NOTIFY_EMAIL
  );

  let emailResult: { ok: boolean; error?: string } | null = null;
  if (failures.length > 0 && emailConfigured) {
    const subject = `[nefesh-il] Broken or unreachable links (${failures.length})`;
    const text = [
      'The link checker found one or more problems in index.html.',
      '',
      failureReport.join('\n\n'),
      '',
      `Checked ${toCheck.length} unique URLs (${allUrls.length} before host skip).`,
      `Skipped host bases (and their subdomains): ${[...DEFAULT_SKIP_HOSTS].join(', ')}${process.env.LINK_CHECK_SKIP_HOSTS ? `; plus ${process.env.LINK_CHECK_SKIP_HOSTS}` : ''}.`,
    ].join('\n');
    emailResult = await sendResendEmail(subject, text);
    if (!emailResult.ok) {
      console.error('link-check: email failed', emailResult.error);
    }
  }

  return res.status(200).json({
    checked: toCheck.length,
    uniqueFound: allUrls.length,
    failures: failures.length,
    failureDetails: failures.map(({ url, outcome }) => ({
      url,
      problem: describeFailure(outcome),
      locations: locationsForUrl(html, url),
    })),
    emailSent: failures.length > 0 && emailConfigured && emailResult?.ok === true,
    emailError: emailResult && !emailResult.ok ? emailResult.error : null,
    note:
      failures.length > 0 && !emailConfigured
        ? 'Failures found but email not sent: set RESEND_API_KEY, LINK_CHECK_FROM_EMAIL, LINK_CHECK_NOTIFY_EMAIL'
        : undefined,
  });
}
