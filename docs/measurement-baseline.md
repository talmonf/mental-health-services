# Measurement baseline

Phases 1 and 2 are only worth anything if their effect can be observed. This file is the record. Fill in the dated rows; do not overwrite them.

## Status

**Search Console and Bing Webmaster Tools verification is not done and cannot be done from the repo.** Both require signing in with the account that owns the domain. The steps are below and take about 30 minutes in total. An unofficial public `site:` search on 2026-09-08 is recorded in the table; it is **not** a GSC number.

Everything else in Phase 4a — the `request_log` table, the middleware and `/api/bot-report` — is implemented and needs only the migration to be run.

## 1. Google Search Console

1. Go to [Search Console](https://search.google.com/search-console) and add a property.
2. Choose **Domain** (`nefesh-il.org`), not URL-prefix. Domain covers `http`/`https` and every subdomain, so it will not need redoing.
3. Verify with the DNS TXT record the wizard gives you, at the registrar for `nefesh-il.org`.
4. Under **Sitemaps**, submit `sitemap.xml`.
5. Under **Settings → Crawl stats**, note the current crawl rate before the new pages are picked up.

If DNS access is awkward, the fallback is a `<meta name="google-site-verification" content="...">` tag in `index.html`. Add it next to the canonical link. The DNS method is preferable because it survives changes to `index.html`.

**What to watch, and why**

| Report | What it tells you |
|---|---|
| Pages → **Crawled – currently not indexed** | The expected failure mode for pre-rendered entry pages. Google fetches them and decides they are too thin to index. If most of the 189 entry pages land here, the answer is richer pages, not more pages. |
| Pages → Indexed | The headline number. Record it monthly below. |
| Sitemaps | Discovered vs indexed. A large gap is the same signal as above. |
| Performance → Queries | Hebrew queries the site actually surfaces for. This is also the input that fixes the biggest weakness of the GEO question set — see `experiments/README.md` section 8. |

Queries worth checking explicitly, because they are the high-intent ones the directory is built for: `סל שיקום`, `מרכזי חוסן`, `טופס 17 בריאות הנפש`, `קצבת נכות נפשית`, `חלופת אשפוז`, `בית מאזן`.

## 2. Bing Webmaster Tools

Free, roughly 20 minutes, and it feeds Copilot, which makes it directly relevant to the GEO experiment rather than an afterthought.

1. Go to [Bing Webmaster Tools](https://www.bing.com/webmasters).
2. Import from Search Console if it is already set up — this is the fast path.
3. Submit `sitemap.xml`.
4. Note the **URL Inspection** result for `/s/210` as a spot check that Bing sees server-rendered content.

## 3. Baseline record

Record before the new pages are crawled, then monthly. Do not overwrite rows; append.

| Date | Google indexed | Google crawled-not-indexed | Bing indexed | Sitemap discovered | Notes |
|---|---|---|---|---|---|
| _(pre-Phase-1)_ | | | | | Expected: 1 page (`/`). This is the number that makes the "before" claim truthful. |
| 2026-09-08 | *unofficial, not GSC* | — | — | sitemap.xml generated (292 URLs), not yet submitted | Domain-owner login is still required. A public `site:nefesh-il.org` search on this date returned no hits. Do not treat that as a GSC indexed count. |

## 4. Bot fetch baseline

From `request_log` once the migration is run and the middleware is live:

```
curl -H "Authorization: Bearer $CRON_SECRET" https://nefesh-il.org/api/bot-report
```

| Date | GPTBot | ClaudeBot | PerplexityBot | OAI-SearchBot | CCBot | Googlebot | Bingbot | Notes |
|---|---|---|---|---|---|---|---|---|
| | | | | | | | | |

**This table is the gate for the GEO follow-up run.** If an agent's count is zero, a null result for that model is *not testable*, not *no effect*. Pre-registered in `experiments/README.md` section 2.

## 5. What these numbers do and do not license

**Can be said once recorded:** "N pages indexed as of date D, up from 1." "These specific AI agents fetched the site this many times." "The gap between internal analytics and GA4 is X% and is attributable mostly to Y."

**Cannot be said:** that Phase 1 or 2 *caused* any traffic change. There is no control group for the site as a whole, and search behaviour, the news cycle and seasonality all move these numbers. The only genuine control anywhere in this work is the eight-entry holdout slice, and it controls for site changes, not for anything else.
