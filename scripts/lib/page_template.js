// Shared HTML shell for the pre-rendered pages.
//
// These pages exist so that crawlers which do not execute JavaScript can read the
// directory. Two rules follow from that and are load-bearing:
//   1. No external CDN. No React, no Babel, no Font Awesome, no web fonts. If a crawler
//      or a person on a bad connection gets only the HTML, the page must still work.
//   2. The emergency block comes first in source order, so any excerpt taken from the
//      top of the document carries a working crisis number.

const SITE = 'https://nefesh-il.org';
const SITE_NAME_HE = 'מדריך נפש';
const SITE_NAME_EN = 'Nefesh — Israel Mental Health Directory';

function escapeHtml(value) {
  return String(value == null ? '' : value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

/** Multi-line free text from DATA renders as paragraphs, not one run-on line. */
function paragraphs(text) {
  return String(text || '')
    .split(/\n+/)
    .map((t) => t.trim())
    .filter(Boolean)
    .map((t) => `<p>${escapeHtml(t)}</p>`)
    .join('');
}

/** True when the first strong character is Latin — used to keep Hebrew titles from leading with Latin text. */
function startsWithLatin(text) {
  const m = String(text || '').match(/[A-Za-zא-ת]/);
  return m ? /[A-Za-z]/.test(m[0]) : false;
}

/** Truncate on a word boundary. Meta descriptions get cut at ~155 chars by search engines anyway. */
function truncate(text, max = 155) {
  const t = String(text || '').replace(/\s+/g, ' ').trim();
  if (t.length <= max) return t;
  const cut = t.slice(0, max);
  const lastSpace = cut.lastIndexOf(' ');
  return (lastSpace > max * 0.6 ? cut.slice(0, lastSpace) : cut).replace(/[,;:·—-]+$/, '').trim() + '…';
}

const CSS = `
:root{--primary:#2d5a7b;--primary-dark:#1e3f5a;--accent:#52b788;--danger:#c0392b;
--text:#333;--muted:#5a5a5a;--border:#e0e0e0;--bg:#f0f2f5;--card:#fff;--radius:10px}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--text);line-height:1.6;
font-family:'Heebo',-apple-system,BlinkMacSystemFont,'Segoe UI',Arial,sans-serif}
.wrap{max-width:820px;margin:0 auto;padding:16px}
a{color:var(--primary)}
.card{background:var(--card);border:1px solid var(--border);border-radius:var(--radius);padding:16px;margin-bottom:16px}
h1{font-size:1.5rem;margin:0 0 8px}
h2{font-size:1.15rem;margin:24px 0 8px}
h3{font-size:1rem;margin:16px 0 4px}
.sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border:0}
.emergency{background:#fff5f5;border:2px solid var(--danger);border-radius:var(--radius);padding:12px 16px;margin-bottom:16px}
.emergency h2{margin:0 0 8px;font-size:1rem;color:var(--danger)}
.emergency ul{margin:0;padding-inline-start:20px}
.emergency li{margin-bottom:2px}
.crumbs{font-size:.85rem;color:var(--muted);margin-bottom:12px}
.crumbs a{color:var(--muted)}
.lede{font-size:1.05rem;color:var(--text);margin:0 0 12px}
.facts{margin:0;padding:0}
.facts div{display:flex;gap:8px;padding:6px 0;border-top:1px solid var(--border);flex-wrap:wrap}
.facts dt{font-weight:600;min-width:110px;color:var(--muted)}
.facts dd{margin:0;flex:1 1 260px}
.contact{list-style:none;margin:0;padding:0}
.contact li{padding:6px 0;border-top:1px solid var(--border)}
.contact .label{color:var(--muted);font-size:.9rem}
.tag{display:inline-block;background:#eef3f7;border-radius:999px;padding:3px 10px;margin:0 0 6px 6px;font-size:.85rem;text-decoration:none}
.count{unicode-bidi:isolate;direction:ltr;display:inline-block}
.badge-ref{margin:0 0 12px;padding:8px 12px;background:#eef6f1;border:1px solid #c5e4d4;border-radius:8px;font-size:.9rem}
.badge-ref summary{cursor:pointer;font-weight:600;color:var(--primary-dark)}
.badge-ref p{margin:8px 0 0;color:var(--muted)}
.btn{display:inline-block;background:var(--primary);color:#fff;text-decoration:none;
padding:10px 18px;border-radius:var(--radius);font-weight:600;margin:4px 0}
.btn-secondary{background:#fff;color:var(--primary);border:2px solid var(--primary)}
.entry-list{list-style:none;margin:0;padding:0}
.entry-list li{padding:10px 0;border-top:1px solid var(--border)}
.entry-list a{font-weight:600;text-decoration:none}
.entry-list .svc{display:block;color:var(--muted);font-size:.9rem}
.entry-list .tags{display:block;margin-top:6px}
.entry-list strong{display:block}
.notes{background:#fafbfc;border-inline-start:3px solid var(--border);padding:8px 12px;margin:8px 0}
footer{color:var(--muted);font-size:.85rem;padding:16px 0;border-top:1px solid var(--border);margin-top:24px}
[dir=ltr]{text-align:left}
.ltr-block{direction:ltr;text-align:left}
@media(max-width:520px){.wrap{padding:12px}h1{font-size:1.3rem}}
`.trim();

/**
 * The crisis block. Every number carries its label — a bare number lifted out of context
 * by a model or a scraper is exactly the failure mode this guards against.
 */
const EMERGENCY_HTML = `
<aside class="emergency" aria-label="עזרה דחופה">
  <h2>במצב משבר — עזרה מיידית</h2>
  <ul>
    <li><strong>1201</strong> — ער"ן, עזרה ראשונה נפשית, 24/7</li>
    <li><strong>*2201</strong> — ער"ן, קו לחיילים ומילואים</li>
    <li><strong>*6690</strong> — מערך בריאות הנפש בצה"ל, לכלל המשרתים</li>
    <li><strong>118</strong> — מוקד משרד הרווחה, 24/7</li>
    <li><strong>1202</strong> נשים / <strong>1203</strong> גברים — סיוע לנפגעות ונפגעי תקיפה מינית</li>
    <li><strong>105</strong> — המטה הלאומי להגנה על ילדים ברשת</li>
  </ul>
</aside>`.trim();

function breadcrumbs(trail) {
  if (!trail || trail.length < 2) return '';
  const parts = trail.map((c, i) =>
    i === trail.length - 1
      ? `<span aria-current="page">${escapeHtml(c.name)}</span>`
      : `<a href="${escapeHtml(c.url)}">${escapeHtml(c.name)}</a>`
  );
  return `<nav class="crumbs" aria-label="מיקום בעץ האתר">${parts.join(' <span aria-hidden="true">›</span> ')}</nav>`;
}

/**
 * @param {object} o
 * @param {string} o.title           full <title>
 * @param {string} o.description     meta description
 * @param {string} o.path            canonical path, e.g. /s/210
 * @param {string} o.body            page body HTML
 * @param {string} [o.lang]          document language, defaults to he
 * @param {string} [o.dir]           document direction, defaults to rtl
 * @param {string} [o.jsonLd]        JSON-LD, already serialised
 * @param {Array}  [o.trail]         breadcrumb trail
 * @param {string} o.lastUpdated     LAST_UPDATED from index.html, shown and machine-readable
 */
function renderPage(o) {
  const lang = o.lang || 'he';
  const dir = o.dir || 'rtl';
  const canonical = `${SITE}${o.path}`;
  const siteName = lang === 'en' ? SITE_NAME_EN : SITE_NAME_HE;

  return `<!DOCTYPE html>
<html lang="${lang}" dir="${dir}">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${escapeHtml(o.title)}</title>
<meta name="description" content="${escapeHtml(o.description)}">
<link rel="canonical" href="${escapeHtml(canonical)}">
<meta name="robots" content="index, follow, max-snippet:-1, max-image-preview:large">
<meta property="og:type" content="${o.ogType || 'article'}">
<meta property="og:locale" content="${lang === 'en' ? 'en_US' : 'he_IL'}">
<meta property="og:site_name" content="${escapeHtml(siteName)}">
<meta property="og:url" content="${escapeHtml(canonical)}">
<meta property="og:title" content="${escapeHtml(o.title)}">
<meta property="og:description" content="${escapeHtml(o.description)}">
<meta property="og:image" content="${SITE}/og-image.png">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="${escapeHtml(o.title)}">
<meta name="twitter:description" content="${escapeHtml(o.description)}">
<meta name="twitter:image" content="${SITE}/og-image.png">
<style>${CSS}</style>${o.jsonLd ? `\n<script type="application/ld+json">${o.jsonLd}</script>` : ''}
</head>
<body>
<div class="wrap">
${EMERGENCY_HTML}
${breadcrumbs(o.trail)}
<main>
${o.body}
</main>
<footer>
  <p>עודכן: <time datetime="${escapeHtml(o.lastUpdatedIso || '')}">${escapeHtml(o.lastUpdated || '')}</time></p>
  <p>המידע במדריך נאסף ממקורות ציבוריים ומתעדכן ידנית. הוא אינו ייעוץ רפואי ואינו תחליף לאבחון או לטיפול מקצועי. אנא ודאו פרטים מול הגורם עצמו לפני פנייה.</p>
  <p><a href="/">${escapeHtml(siteName)}</a> · <a href="/directory">כל הקטגוריות</a> · <a href="/terms">מילון מונחים</a></p>
</footer>
</div>
</body>
</html>
`;
}

module.exports = {
  SITE,
  SITE_NAME_HE,
  SITE_NAME_EN,
  CSS,
  EMERGENCY_HTML,
  escapeHtml,
  paragraphs,
  startsWithLatin,
  truncate,
  breadcrumbs,
  renderPage,
};
