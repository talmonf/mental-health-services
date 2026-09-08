# Analytics discrepancy analysis

Internal `/api/analytics` and GA4 both require JavaScript, so neither is a denominator. `request_log` (middleware) is. After migrations 028 and 029 are applied, run this against a window of at least a week and a minimum n of 30 per segment before concluding anything.

## Join key

- Internal: `events.session_id` (= `mh_session_id`) and `events.extra->>'ga_client_id'`
- GA4: event parameter `mh_session_id` and the standard `client_id`
- Server log: `request_log.path`, `request_log.user_agent`, `request_log.referrer`

## Segments

| Segment | How to identify |
|---|---|
| Facebook in-app | UA contains `FBAN` or `FBAV`; referrer `l.facebook.com` / `lm.facebook.com` |
| Android WebView | UA contains `; wv)` |
| WhatsApp in-app | UA contains `WhatsApp` |
| Tracker blocking (hypothesis) | Internal events present, GA4 absent, same session |
| Bots | `request_log.is_bot` |

## Discriminators (pre-registered)

- GA4 low **only** in in-app segments, internal normal → in-app browser breakage.
- Both low, server high → page did not execute JS.
- Server high, both near zero, bot UA → bot traffic.
- GA4 low, internal normal, **all** segments → tracker blocking. Internal is first-party; GA4 is googletagmanager.com.

Report ratios with counts, not a single headline number.

```sql
-- Server HTML requests vs internal page_view, last 7 days
WITH server AS (
  SELECT
    CASE
      WHEN user_agent ILIKE '%FBAN%' OR user_agent ILIKE '%FBAV%' THEN 'facebook_inapp'
      WHEN user_agent ILIKE '%WhatsApp%' THEN 'whatsapp'
      WHEN user_agent ILIKE '%; wv)%' THEN 'android_webview'
      WHEN is_bot THEN 'bot'
      ELSE 'other'
    END AS segment,
    count(*) FILTER (WHERE sample_rate = 1) +
    coalesce(sum(1.0/sample_rate) FILTER (WHERE sample_rate < 1), 0) AS est_requests
  FROM request_log
  WHERE occurred_at > now() - interval '7 days'
    AND method = 'GET'
  GROUP BY 1
),
internal AS (
  SELECT
    CASE
      WHEN extra->>'user_agent' ILIKE '%FBAN%' OR extra->>'user_agent' ILIKE '%FBAV%' THEN 'facebook_inapp'
      WHEN extra->>'user_agent' ILIKE '%WhatsApp%' THEN 'whatsapp'
      WHEN extra->>'user_agent' ILIKE '%; wv)%' THEN 'android_webview'
      ELSE 'other'
    END AS segment,
    count(*) AS events
  FROM events
  WHERE occurred_at > now() - interval '7 days'
    AND event_type = 'page_view'
  GROUP BY 1
)
SELECT s.segment,
       round(s.est_requests)::int AS server_est,
       coalesce(i.events, 0) AS internal_page_views,
       CASE WHEN s.est_requests > 0
            THEN round(100.0 * coalesce(i.events, 0) / s.est_requests, 1)
       END AS internal_pct_of_server
  FROM server s
  LEFT JOIN internal i USING (segment)
 ORDER BY s.est_requests DESC;
```

Vercel Analytics was removed in this change so the comparison is two-way (internal vs GA4 vs server), not three-way.
