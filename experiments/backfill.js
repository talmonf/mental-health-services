#!/usr/bin/env node
/**
 * Backfill a GEO run CSV into Postgres (geo_* tables from 031_geo_experiment.sql).
 *
 *   DATABASE_URL=postgres://... node experiments/backfill.js experiments/results/baseline-2026-09-08.csv
 */
const fs = require('fs');
const path = require('path');
const { Client } = require('pg');

function normalizePgSslMode(connectionString) {
  try {
    const u = new URL(connectionString);
    const mode = u.searchParams.get('sslmode');
    if (mode === 'prefer' || mode === 'require' || mode === 'verify-ca') {
      u.searchParams.set('sslmode', 'verify-full');
    }
    return u.toString();
  } catch {
    return connectionString;
  }
}

function parseCsv(text) {
  if (text.charCodeAt(0) === 0xfeff) text = text.slice(1);
  const rows = [];
  let row = [];
  let field = '';
  let inQuotes = false;
  for (let i = 0; i < text.length; i++) {
    const c = text[i];
    if (inQuotes) {
      if (c === '"') {
        if (text[i + 1] === '"') {
          field += '"';
          i++;
        } else inQuotes = false;
      } else field += c;
      continue;
    }
    if (c === '"') {
      inQuotes = true;
      continue;
    }
    if (c === ',') {
      row.push(field);
      field = '';
      continue;
    }
    if (c === '\n') {
      row.push(field);
      rows.push(row);
      row = [];
      field = '';
      continue;
    }
    if (c === '\r') continue;
    field += c;
  }
  if (field !== '' || row.length) {
    row.push(field);
    rows.push(row);
  }
  const header = rows.shift();
  return rows.filter((r) => r.some((v) => v !== '')).map((r) => Object.fromEntries(header.map((h, i) => [h, r[i] ?? ''])));
}

async function main() {
  const csvPath = process.argv[2];
  if (!csvPath) {
    console.error('Usage: node experiments/backfill.js <run.csv>');
    process.exit(1);
  }
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    console.error('DATABASE_URL is not set.');
    process.exit(1);
  }

  const questions = JSON.parse(fs.readFileSync(path.join(__dirname, 'questions', 'v1.json'), 'utf8'));
  const answers = parseCsv(fs.readFileSync(csvPath, 'utf8'));
  if (!answers.length) {
    console.error('CSV is empty.');
    process.exit(1);
  }

  const runId = answers[0].run_id;
  const client = new Client({ connectionString: normalizePgSslMode(databaseUrl) });
  await client.connect();

  try {
    await client.query('BEGIN');
    await client.query(
      `INSERT INTO geo_question_sets (set_version, frozen_at, n, notes)
       VALUES ($1, $2, $3, $4)
       ON CONFLICT (set_version) DO NOTHING`,
      [questions.set_version, questions.frozen_at, questions.n, questions.provenance_gap || null]
    );

    for (const q of questions.questions) {
      await client.query(
        `INSERT INTO geo_questions (set_version, question_id, he, axis, provenance, expected_rows, safety_item, notes)
         VALUES ($1,$2,$3,$4,$5,$6,$7,$8)
         ON CONFLICT (set_version, question_id) DO UPDATE SET
           he = EXCLUDED.he, axis = EXCLUDED.axis, expected_rows = EXCLUDED.expected_rows`,
        [
          questions.set_version,
          q.id,
          q.he,
          q.axis,
          q.provenance || null,
          q.expected_rows || [],
          Boolean(q.safety_item),
          q.notes || null,
        ]
      );
    }

    await client.query(
      `INSERT INTO geo_runs (run_id, set_version, git_sha, site_last_updated, notes)
       VALUES ($1,$2,$3,$4,$5)
       ON CONFLICT (run_id) DO UPDATE SET git_sha = EXCLUDED.git_sha, site_last_updated = EXCLUDED.site_last_updated`,
      [runId, questions.set_version, answers[0].git_sha || null, answers[0].site_last_updated || null, `Backfilled from ${path.basename(csvPath)}`]
    );

    let n = 0;
    for (const a of answers) {
      let raw = null;
      try {
        raw = a.raw_response ? JSON.parse(a.raw_response) : null;
      } catch {
        raw = { unparsed: a.raw_response };
      }
      const citations = (a.citations_found || '').split(';').map((s) => s.trim()).filter(Boolean);
      await client.query(
        `INSERT INTO geo_answers (
           answer_id, run_id, question_id, provider, model_alias, model_version_resolved,
           web_access, arm, answer_text, raw_response, citations_found, latency_ms
         ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)
         ON CONFLICT (answer_id) DO UPDATE SET
           answer_text = EXCLUDED.answer_text,
           raw_response = EXCLUDED.raw_response,
           model_version_resolved = EXCLUDED.model_version_resolved`,
        [
          a.answer_id,
          runId,
          a.question_id,
          a.provider,
          a.model_alias || null,
          a.model_version_resolved || null,
          a.web_access === 'true',
          a.arm || 'api',
          a.answer_text || null,
          raw,
          citations,
          a.latency_ms ? Number(a.latency_ms) : null,
        ]
      );
      n++;
    }
    await client.query('COMMIT');
    console.log(`Backfilled run ${runId}: ${n} answers`);
  } catch (err) {
    await client.query('ROLLBACK');
    throw err;
  } finally {
    await client.end();
  }
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
