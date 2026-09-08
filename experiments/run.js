#!/usr/bin/env node
/**
 * GEO experiment runner.
 *
 *   node experiments/run.js --providers openai,anthropic,google [--web]
 *   node experiments/run.js --ingest experiments/results/manual-answers.json
 *
 * Records the resolved model version the API returns, not the alias. Full raw responses
 * are kept so a later analysis does not need a re-run.
 *
 * Env:
 *   OPENAI_API_KEY, OPENAI_MODEL          default gpt-4o
 *   ANTHROPIC_API_KEY, ANTHROPIC_MODEL    default claude-sonnet-4-5
 *   GOOGLE_API_KEY, GOOGLE_MODEL          default gemini-3.6-flash
 */
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const ROOT = path.join(__dirname, '..');
const QUESTIONS = JSON.parse(fs.readFileSync(path.join(__dirname, 'questions', 'v1.json'), 'utf8'));

const AUTHORITATIVE =
  /nefesh-il\.org|gov\.il|btl\.gov\.il|health\.gov\.il|kolzchut\.org\.il|eran\.org\.il|sahar\.org\.il|natal\.org\.il/i;

const SYSTEM = `אתה עוזר שעונה על שאלות של הציבור בישראל על קבלת עזרה נפשית.
ענה בעברית (unless the question is in English).
תן שמות של שירותים, מספרי טלפון ומסלולי פנייה רק אם אתה בטוח בהם.
אם אינך בטוח במספר, אל תמציא אחד.
זה אינו ייעוץ רפואי. במצב משבר הפנה לער"ן 1201.`;

function csvEscape(v) {
  const s = v == null ? '' : String(v);
  return /[",\n]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s;
}

function toCsv(records, columns) {
  return [columns.join(','), ...records.map((r) => columns.map((c) => csvEscape(r[c])).join(','))].join('\n') + '\n';
}

function gitSha() {
  try {
    return execSync('git rev-parse --short HEAD', { cwd: ROOT, encoding: 'utf8' }).trim();
  } catch {
    return '';
  }
}

function lastUpdated() {
  const html = fs.readFileSync(path.join(ROOT, 'index.html'), 'utf8');
  const m = /LAST_UPDATED\s*=\s*"([^"]+)"/.exec(html);
  return m ? m[1] : '';
}

function extractCitations(text, providerCitations) {
  const found = new Set();
  for (const c of providerCitations || []) if (c) found.add(String(c));
  const re = /https?:\/\/[^\s)\]>"']+/gi;
  let m;
  while ((m = re.exec(text || '')) !== null) found.add(m[0].replace(/[.,;]+$/, ''));
  if (/nefesh-il\.org/i.test(text || '')) found.add('https://nefesh-il.org/');
  return [...found];
}

const COLUMNS = [
  'answer_id',
  'run_id',
  'question_id',
  'question_he',
  'axis',
  'safety_item',
  'provider',
  'model_alias',
  'model_version_resolved',
  'web_access',
  'arm',
  'answer_text',
  'raw_response',
  'citations_found',
  'latency_ms',
  'git_sha',
  'site_last_updated',
];

async function callOpenAI(question, web) {
  const key = process.env.OPENAI_API_KEY;
  if (!key) throw new Error('OPENAI_API_KEY is not set');
  const model = process.env.OPENAI_MODEL || 'gpt-4o';
  const body = {
    model,
    messages: [
      { role: 'system', content: SYSTEM },
      { role: 'user', content: question.he },
    ],
  };
  if (web) body.tools = [{ type: 'web_search_preview' }];
  const res = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: { Authorization: `Bearer ${key}`, 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });
  const json = await res.json();
  if (!res.ok) throw new Error(`OpenAI ${res.status}: ${JSON.stringify(json).slice(0, 400)}`);
  const text = json.choices?.[0]?.message?.content || '';
  const citations = (json.choices?.[0]?.message?.annotations || [])
    .map((a) => a.url || a.citation?.url)
    .filter(Boolean);
  return { text, raw: json, version: json.model || model, citations };
}

async function callAnthropic(question, web) {
  const key = process.env.ANTHROPIC_API_KEY;
  if (!key) throw new Error('ANTHROPIC_API_KEY is not set');
  const model = process.env.ANTHROPIC_MODEL || 'claude-sonnet-4-5';
  const body = {
    model,
    max_tokens: 1200,
    system: SYSTEM,
    messages: [{ role: 'user', content: question.he }],
  };
  if (web) body.tools = [{ type: 'web_search_20250305', name: 'web_search' }];
  const res = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'x-api-key': key,
      'anthropic-version': '2023-06-01',
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(body),
  });
  const json = await res.json();
  if (!res.ok) throw new Error(`Anthropic ${res.status}: ${JSON.stringify(json).slice(0, 400)}`);
  const text = (json.content || []).filter((c) => c.type === 'text').map((c) => c.text).join('\n');
  const citations = [];
  for (const c of json.content || []) {
    for (const cit of c.citations || []) if (cit.url) citations.push(cit.url);
  }
  return { text, raw: json, version: json.model || model, citations };
}

async function callGoogle(question, _web) {
  const key = process.env.GOOGLE_API_KEY;
  if (!key) throw new Error('GOOGLE_API_KEY is not set');
  const model = process.env.GOOGLE_MODEL || 'gemini-3.6-flash';
  const url = `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${key}`;
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      systemInstruction: { parts: [{ text: SYSTEM }] },
      contents: [{ role: 'user', parts: [{ text: question.he }] }],
    }),
  });
  const json = await res.json();
  if (!res.ok) throw new Error(`Google ${res.status}: ${JSON.stringify(json).slice(0, 400)}`);
  const text = json.candidates?.[0]?.content?.parts?.map((p) => p.text).join('\n') || '';
  const version = json.modelVersion || json.candidates?.[0]?.modelVersion || model;
  return { text, raw: json, version, citations: [] };
}

const PROVIDERS = {
  openai: { fn: callOpenAI, alias: () => process.env.OPENAI_MODEL || 'gpt-4o' },
  anthropic: { fn: callAnthropic, alias: () => process.env.ANTHROPIC_MODEL || 'claude-sonnet-4-5' },
  google: { fn: callGoogle, alias: () => process.env.GOOGLE_MODEL || 'gemini-3.6-flash' },
};

function rowFromResult({ runId, q, provider, alias, result, web, arm, latency, sha, updated }) {
  const citations = extractCitations(result.text, result.citations);
  return {
    answer_id: `${runId}-${q.id}-${provider}-web${web ? '1' : '0'}`,
    run_id: runId,
    question_id: q.id,
    question_he: q.he,
    axis: q.axis,
    safety_item: q.safety_item ? 'true' : 'false',
    provider,
    model_alias: alias,
    model_version_resolved: result.version || alias,
    web_access: web ? 'true' : 'false',
    arm,
    answer_text: result.text,
    raw_response: JSON.stringify(result.raw),
    citations_found: citations.join(';'),
    latency_ms: latency,
    git_sha: sha,
    site_last_updated: updated,
  };
}

async function runApi(providers, web) {
  const runId = `baseline-${new Date().toISOString().slice(0, 10)}`;
  const sha = gitSha();
  const updated = lastUpdated();
  const records = [];

  for (const name of providers) {
    const spec = PROVIDERS[name];
    if (!spec) throw new Error(`Unknown provider ${name}. Use openai, anthropic, google.`);
    const alias = spec.alias();
    console.log(`\n=== ${name} (${alias}) web=${web} ===`);
    for (const q of QUESTIONS.questions) {
      const t0 = Date.now();
      process.stdout.write(`  ${q.id} ... `);
      try {
        const result = await spec.fn(q, web);
        const latency = Date.now() - t0;
        records.push(rowFromResult({ runId, q, provider: name, alias, result, web, arm: 'api', latency, sha, updated }));
        console.log(`${latency}ms  ${AUTHORITATIVE.test(result.text) ? 'cited-il' : ''}`);
      } catch (err) {
        const latency = Date.now() - t0;
        records.push(
          rowFromResult({
            runId,
            q,
            provider: name,
            alias,
            result: { text: '', raw: { error: String(err.message) }, version: alias, citations: [] },
            web,
            arm: 'api',
            latency,
            sha,
            updated,
          })
        );
        console.log(`FAIL ${err.message}`);
      }
    }
  }
  return { runId, records };
}

function ingest(jsonPath) {
  const payload = JSON.parse(fs.readFileSync(jsonPath, 'utf8'));
  const runId = payload.run_id || `ingest-${new Date().toISOString().slice(0, 10)}`;
  const sha = payload.git_sha || gitSha();
  const updated = payload.site_last_updated || lastUpdated();
  const byId = Object.fromEntries(QUESTIONS.questions.map((q) => [q.id, q]));
  const records = [];
  for (const a of payload.answers) {
    const q = byId[a.question_id];
    if (!q) throw new Error(`Unknown question_id ${a.question_id}`);
    records.push(
      rowFromResult({
        runId,
        q,
        provider: a.provider,
        alias: a.model_alias || a.provider,
        result: { text: a.answer_text, raw: a.raw_response || {}, version: a.model_version_resolved || a.model_alias, citations: a.citations || [] },
        web: a.web_access === true || a.web_access === 'true',
        arm: a.arm || 'manual_ui',
        latency: a.latency_ms || '',
        sha,
        updated,
      })
    );
  }
  return { runId, records };
}

function writeRun({ runId, records }) {
  const dir = path.join(__dirname, 'results');
  fs.mkdirSync(dir, { recursive: true });
  const out = path.join(dir, `${runId}.csv`);
  fs.writeFileSync(out, toCsv(records, COLUMNS), 'utf8');
  console.log(`\nWrote ${out} (${records.length} answers)`);
  return out;
}

async function main() {
  const args = process.argv.slice(2);
  const ingestPath = args.includes('--ingest') ? args[args.indexOf('--ingest') + 1] : null;
  const web = args.includes('--web');
  const providersArg = args.includes('--providers') ? args[args.indexOf('--providers') + 1] : '';

  if (ingestPath) {
    writeRun(ingest(ingestPath));
    return;
  }

  const providers = providersArg
    ? providersArg.split(',').map((s) => s.trim()).filter(Boolean)
    : Object.keys(PROVIDERS).filter((name) => {
        if (name === 'openai') return Boolean(process.env.OPENAI_API_KEY);
        if (name === 'anthropic') return Boolean(process.env.ANTHROPIC_API_KEY);
        if (name === 'google') return Boolean(process.env.GOOGLE_API_KEY);
        return false;
      });

  if (!providers.length) {
    console.error(`No provider API keys found.

Set OPENAI_API_KEY / ANTHROPIC_API_KEY / GOOGLE_API_KEY, or pass --providers openai,anthropic
or ingest a manual run:

  node experiments/run.js --ingest experiments/results/manual-answers.json

The baseline must be captured before the crawlable surface is promoted to production.
See experiments/README.md and experiments/results/README.md.`);
    process.exit(2);
  }

  const result = await runApi(providers, web);
  writeRun(result);
}

if (require.main === module) {
  main().catch((err) => {
    console.error(err);
    process.exit(1);
  });
}

module.exports = { extractCitations, AUTHORITATIVE };
