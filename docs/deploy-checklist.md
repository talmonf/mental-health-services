# Deploy checklist — first deploy with a build step

This repo had no `buildCommand` before. Adding one changes the deployment's failure mode, so the first deploy needs checking on a preview URL before it is promoted to `nefesh-il.org`.

## Why this is the risky change

`vercel.json` sets `buildCommand: "npm run build"` and `outputDirectory: "."` (the repo root after the build). Vercel CLI requires an output directory whenever a build command is set; the default is `public/`, which this project does not use. `.` is the directory that already contains `index.html` plus the generated `/s/`, `/c/`, `sitemap.xml` and `directory.json`. Do **not** set it to `public` or any other folder that does not contain `index.html` — that would serve an empty root and take the crisis path down.

If the build script throws, Vercel fails the deploy and the previous deployment keeps serving. That failure mode is stale, not down, and is acceptable.

## Before promoting a preview

Run these against the preview URL, not production.

**1. The crisis path, first.** This is the one that matters most.

```
/                              app loads, emergency block visible
/?entry=210&section=trauma     opens the trauma section with מטיב expanded
/?section=emergency            opens the emergency category
/?q=סל שיקום                   search works
/#treatment                    hash navigation still works
```

The `?entry=` form is the one pasted into WhatsApp threads that will never be updated. Nothing about it changed, but confirm it rather than assume it.

**2. The new pre-rendered pages.**

```
/s/210          entry page, Hebrew, content present in HTML source
/s/18           English entry: <html lang="he" dir="rtl">, content block lang="en" dir="ltr"
/s/210/anything rewrite resolves to /s/210 (cosmetic slugs, no redirect needed later). A local file server will 404 this path; `vercel.json` rewrites it. Check it on the preview URL.
/c/emergency    category page
/c/treatments/therapy   subsection page
/g/rights       group page
/term/cbt       glossary term
/terms          glossary index
/directory      hub
/sitemap.xml    valid XML, 292 urls
/robots.txt     Sitemap line points at https://nefesh-il.org/sitemap.xml
```

**3. Content is in the source, not just on screen.** This is the entire point of Phase 1, so verify it the way a crawler would:

```
curl -s <preview>/s/210 | grep -c "מטיב"
```

Must be non-zero **with JavaScript disabled**. If it only appears when JS runs, the build did not deploy and you are looking at the app's client-side render.

**4. The noscript fallback.** Disable JavaScript, load `/`. You should get the red emergency block with 1201, `*2201`, `*6690`, 118, 1202/1203, 105, plus links to `/c/emergency`, `/c/helplines`, `/directory` and `/terms`.

**5. `cleanUrls` side effects.** `cleanUrls: true` and `trailingSlash: false` change how paths normalise. Confirm `/s/210/` redirects to `/s/210` and that `/` still serves the app rather than redirecting anywhere.

**6. The middleware, which is the other thing that can break the site for everyone.** `middleware.ts` runs on every HTML route. It is wrapped so that every path ends in `next()`, but verify rather than trust:

- Load `/` and `/s/210` and confirm you get the page, not an empty `200` and not a `500`.
- Deploy once with `DATABASE_URL` deliberately unset in the preview environment. Pages must still serve; logging simply skips.
- Then set `DATABASE_URL`, run `scripts/028_request_log.sql`, and confirm rows appear.
- Confirm the kill switch: set `REQUEST_LOG_DISABLED=1`, reload, and check no new rows arrive while pages still serve.

Environment variables the middleware reads:

| Variable | Effect |
|---|---|
| `DATABASE_URL` | Required for logging. Absent means logging is skipped, not an error. |
| `REQUEST_LOG_DISABLED` | `1` disables logging without a deploy. |
| `REQUEST_LOG_HUMAN_SAMPLE` | Fraction of non-bot traffic recorded, default `0.1`. Bots are always recorded in full. |
| `CRON_SECRET` | Required to read `/api/bot-report`. |

## Hard gate before promoting

**The Phase 5 GEO baseline must be recorded before these pages are live on the production domain.** See `experiments/results/README.md`. Once `/s/*` is crawlable, a clean pre-change baseline cannot be recovered.

## After promoting

1. Submit `sitemap.xml` in Google Search Console and Bing Webmaster Tools.
2. Record the baseline indexed page count in `docs/measurement-baseline.md`.
3. Watch the "Crawled – currently not indexed" bucket. For thin entry pages that is the expected failure mode, not a surprise.

## Rollback

Redeploy the previous deployment from the Vercel dashboard. Because the generated pages are not committed, reverting the commit also removes them; nothing needs cleaning up by hand.

To disable request logging without a deploy, set `REQUEST_LOG_DISABLED=1` in the project environment. The middleware checks it on every request and falls straight through.
