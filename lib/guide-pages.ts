/**
 * The 15 search articles and how a visit is described in admin analytics.
 * Classification happens when the rows are read, so a new referrer can be named
 * without rewriting events already stored.
 */

export type GuidePage = { path: string; title: string };

export const GUIDE_PAGES: GuidePage[] = [
  { path: '/panic-attack-vs-heart-attack-what-to-do', title: 'התקף חרדה או התקף לב: איך מבדילים ומה עושים בזמן ההתקף' },
  { path: '/coping-with-ptsd-symptoms-treatment-where-to-turn', title: 'פוסט טראומה (PTSD): סימנים, סוגי טיפול ולמי פונים' },
  { path: '/family-member-addiction-guide', title: 'איך מתמודדים עם התמכרות של בן משפחה | מדריך למשפחות' },
  { path: '/coping-with-anxiety-after-war-israel', title: 'איך מתמודדים עם חרדה לאחר מלחמה — מדריך למי שמרגיש שלא חוזר לעצמו ולמי פונים' },
  { path: '/coping-with-grief-and-loss', title: 'איך מתמודדים עם אבל ואובדן — מתי הכאב נורמלי ומתי כדאי לפנות לעזרה' },
  { path: '/gaslighting-guide-israel', title: 'גזלייטינג — איך מזהים מניפולציה רגשית ואיפה מקבלים עזרה' },
  { path: '/how-to-recognize-mental-crisis-family-member-what-to-do', title: 'איך מזהים משבר נפשי אצל בן משפחה ומה עושים עכשיו — מדריך למשפחות' },
  { path: '/how-to-support-family-member-with-depression', title: 'איך תומכים בבן משפחה עם דיכאון — מדריך למשפחות ולחברים' },
  { path: '/coping-with-suicidal-thoughts-where-to-turn', title: 'איך מתמודדים עם מחשבות אובדניות — מה עושים עכשיו ולמי פונים' },
  { path: '/postpartum-depression-guide', title: 'איך מתמודדים עם דיכאון אחרי לידה — סימנים, מתי לפנות לעזרה ולמי פונים' },
  { path: '/insomnia-sleep-problems-mental-health', title: 'איך מתמודדים עם בעיות שינה ונדודי שינה — מתי זו בעיה נפשית ולמי פונים' },
  { path: '/how-to-support-family-member-with-anxiety', title: 'איך תומכים בבן משפחה עם חרדה — מה אומרים, מה לא אומרים ואיך עוזרים לו לפנות לטיפול' },
  { path: '/coping-with-ocd-signs-treatment-where-to-turn', title: 'איך מתמודדים עם הפרעה טורדנית כפייתית (OCD) — סימנים, סוגי טיפול ולמי פונים' },
  { path: '/psychologist-psychiatrist-difference-israel', title: 'פסיכולוג או פסיכיאטר — מה ההבדל ולמי לפנות' },
  { path: '/helping-child-teen-emotional-distress-israel', title: 'איך עוזרים לילד או לנער במצוקה נפשית — סימנים, מה אומרים ולמי פונים' },
];

const GUIDE_BY_PATH = new Map(GUIDE_PAGES.map((page) => [page.path, page]));

/** Pathname only: no query, no hash, no trailing slash, no .html. */
export function normalizePath(raw: string | null | undefined): string {
  let path = String(raw || '').trim();
  if (!path) return '/';
  const hash = path.indexOf('#');
  if (hash >= 0) path = path.slice(0, hash);
  const query = path.indexOf('?');
  if (query >= 0) path = path.slice(0, query);
  if (!path.startsWith('/')) path = `/${path}`;
  if (path.length > 1 && path.endsWith('/')) path = path.slice(0, -1);
  if (path.endsWith('.html')) path = path.slice(0, -'.html'.length) || '/';
  if (path === '/index') return '/';
  return path || '/';
}

export function guideByPath(raw: string | null | undefined): GuidePage | null {
  return GUIDE_BY_PATH.get(normalizePath(raw)) || null;
}

export function isGuidePath(raw: string | null | undefined): boolean {
  return guideByPath(raw) != null;
}

/** Title of a search article, or the path of any other page on the site. */
export function pageLabel(route: string | null | undefined): string {
  const path = normalizePath(route);
  const guide = guideByPath(path);
  if (guide) return guide.title;
  return path;
}

function bareHost(domain: string | null | undefined): string {
  return String(domain || '')
    .trim()
    .toLowerCase()
    .replace(/\.$/, '')
    .replace(/^www\./, '');
}

function isOwnHost(host: string): boolean {
  return (
    host === 'nefesh-il.org' ||
    host === 'localhost' ||
    host === '127.0.0.1' ||
    host === '[::1]' ||
    host.endsWith('.vercel.app')
  );
}

function isGoogleHost(host: string): boolean {
  if (host === 'gemini.google.com' || host.endsWith('.gemini.google.com')) return false;
  return host === 'google.com' || host.endsWith('.google.com') || host.startsWith('google.');
}

/**
 * Where a page view came from. An empty referrer stays "unknown";
 * a host we do not name is shown as itself.
 */
export function classifySource(domain: string | null | undefined, path: string | null | undefined): string {
  const host = bareHost(domain);
  if (!host) return 'unknown';
  if (host === 'gemini.google.com' || host.endsWith('.gemini.google.com')) return 'Gemini';
  if (isGoogleHost(host)) return 'Google';
  if (host === 'bing.com' || host.endsWith('.bing.com')) return 'Bing';
  if (host === 'duckduckgo.com' || host.endsWith('.duckduckgo.com')) return 'DuckDuckGo';
  if (host === 'chatgpt.com' || host.endsWith('.chatgpt.com') || host === 'chat.openai.com') return 'ChatGPT';
  if (host === 'perplexity.ai' || host.endsWith('.perplexity.ai')) return 'Perplexity';
  if (host === 'claude.ai' || host.endsWith('.claude.ai')) return 'Claude';
  if (host === 'copilot.microsoft.com' || host.endsWith('.copilot.microsoft.com')) return 'Copilot';
  if (host === 'you.com' || host.endsWith('.you.com')) return 'You.com';
  if (isOwnHost(host)) {
    return isGuidePath(path) ? 'another article' : 'the directory';
  }
  return host;
}

/** A short hint for "another article" (its title) or "the directory" (its path). */
export function sourceDetail(domain: string | null | undefined, path: string | null | undefined): string {
  const label = classifySource(domain, path);
  if (label === 'another article') return pageLabel(path);
  if (label === 'the directory') return normalizePath(path);
  return '';
}

export type NextStep = 'another article' | 'the directory' | 'outside';

/** Where a link click on an article went. elementId is a path, or a host when the link leaves the site. */
export function classifyDestination(elementId: string | null | undefined): NextStep {
  const id = String(elementId || '').trim();
  if (!id.startsWith('/')) return 'outside';
  return isGuidePath(id) ? 'another article' : 'the directory';
}

export function tallyCounts(pairs: { label: string; n: number }[]): { label: string; n: number }[] {
  const map = new Map<string, number>();
  for (const pair of pairs) {
    const n = Number(pair.n) || 0;
    if (!pair.label || n <= 0) continue;
    map.set(pair.label, (map.get(pair.label) || 0) + n);
  }
  return [...map.entries()]
    .map(([label, n]) => ({ label, n }))
    .sort((a, b) => b.n - a.n || a.label.localeCompare(b.label));
}
