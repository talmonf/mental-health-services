# Run results

One CSV per run, named `YYYY-MM-DD-<label>.csv`. Committed, so results are longitudinal and diffable.

## Answer CSV contract

Produced by `experiments/run.js` (Phase 5b), or by hand for the manual baseline.

| Column | Meaning |
|---|---|
| `answer_id` | Unique per row. `<run>-<question_id>-<provider>-<web>`. |
| `run_id` | Groups all answers from one run. |
| `question_id` | `q01`..`q40` from `questions/v1.json`. |
| `question_he` | Copied in so the sheet is readable standalone. |
| `axis` | `entitlement_funding` / `crisis` / `population` / `navigational`. |
| `safety_item` | `true` for the eight crisis items. |
| `provider` | Vendor name. |
| `model_alias` | What you asked for. |
| `model_version_resolved` | **What the API actually returned.** Aliases drift silently; this column is the entire reason the storage is longitudinal. |
| `web_access` | `true` / `false`. |
| `arm` | `api` or `manual_ui`. |
| `answer_text` | Full text. |
| `raw_response` | Full JSON, for re-analysis without a re-run. |
| `citations_found` | Semicolon-separated URLs, from the provider's citation array and from a regex over the text. |
| `latency_ms` | |
| `git_sha` | Repo state at run time. |
| `site_last_updated` | `LAST_UPDATED` from `index.html`. Ties the run to a site state. |

## Scoring flow

```
node experiments/score.js sheet   results/2026-09-08-baseline.csv     # blind sheet + key
# ... score the sheet by hand, second rater scores the same 10 items ...
node experiments/score.js agree   rater-a.csv rater-b.csv             # must clear the 80% gate
node experiments/score.js unblind results/2026-09-08-baseline.csv scores.csv
node experiments/score.js report  results/2026-09-08-baseline.csv scores.csv
```

The 80% agreement gate is pre-registered. A baseline that fails it is re-scored against tightened anchors before it counts.

## Status

**Baseline recorded 2026-09-08** in `baseline-2026-09-08.csv` (**160 answers**, four arms).

Source files (keep them; they are the un-merged runs):

- `baseline-2026-09-08-grok.csv` — Cursor Grok 4.6, parametric, `arm=manual_ui`
- `baseline-2026-09-08-api.csv` — first three-vendor attempt (Anthropic succeeded; OpenAI quota and Gemini 2.5 404 failed)
- `baseline-2026-09-08-openai.csv` — OpenAI gpt-4o retry after billing
- `baseline-2026-09-08-google.csv` — Gemini 3.6-flash retry after billing and model rename

Merged file keeps only non-empty answers: Grok 40 + Anthropic 40 + OpenAI 40 + Google 40.

Limits that remain:

- Inter-rater check is **not done**. Template: `baseline-2026-09-08.rater-b.template.csv`. Until a second person scores 10 items and agreement clears 80%, section 4.5 of `experiments/README.md` is unmet for *scores*. The **answers** themselves are recorded.
- No `--web` arm. Google’s web flag in the runner is a no-op.
- Do not promote `/s/*` to `nefesh-il.org` until you accept this as the pre-change record. Once those pages are live and crawled, a clean baseline is unrecoverable.
