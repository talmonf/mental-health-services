#!/usr/bin/env node
/**
 * Scoring support for the GEO experiment.
 *
 *   node experiments/score.js sheet   <run.csv>            Blind scoring sheet (model identity stripped)
 *   node experiments/score.js unblind <run.csv> <scores.csv>  Rejoin identity after scoring
 *   node experiments/score.js agree   <a.csv> <b.csv>       Inter-rater agreement + Cohen's kappa
 *   node experiments/score.js report  <run.csv> <scores.csv>  Counts with Wilson 95% intervals
 *
 * The blind step matters: scoring while knowing which model produced an answer is the
 * easiest way to manufacture the result you expected. Identity is rejoined only after
 * every score is entered.
 */
const fs = require('fs');
const path = require('path');

// ---------- tiny CSV (quotes, embedded commas and newlines) ----------

function parseCsv(text) {
  if (text.charCodeAt(0) === 0xfeff) text = text.slice(1); // PowerShell writes a BOM; it corrupts the first column name
  const rows = [];
  let row = [];
  let field = '';
  let inQuotes = false;
  for (let i = 0; i < text.length; i++) {
    const c = text[i];
    if (inQuotes) {
      if (c === '"') {
        if (text[i + 1] === '"') { field += '"'; i++; }
        else inQuotes = false;
      } else field += c;
      continue;
    }
    if (c === '"') { inQuotes = true; continue; }
    if (c === ',') { row.push(field); field = ''; continue; }
    if (c === '\n') { row.push(field); rows.push(row); row = []; field = ''; continue; }
    if (c === '\r') continue;
    field += c;
  }
  if (field !== '' || row.length) { row.push(field); rows.push(row); }
  if (!rows.length) return [];
  const header = rows.shift();
  return rows
    .filter((r) => r.some((v) => v !== ''))
    .map((r) => Object.fromEntries(header.map((h, i) => [h, r[i] ?? ''])));
}

function toCsv(records, columns) {
  const esc = (v) => {
    const s = v == null ? '' : String(v);
    return /[",\n]/.test(s) ? '"' + s.replace(/"/g, '""') + '"' : s;
  };
  return [columns.join(','), ...records.map((r) => columns.map((c) => esc(r[c])).join(','))].join('\n') + '\n';
}

const read = (p) => parseCsv(fs.readFileSync(p, 'utf8'));

// ---------- stats ----------

/** Wilson score interval. Normal approximation is wrong at the small n and near-zero rates we expect. */
function wilson(k, n, z = 1.96) {
  if (!n) return { low: 0, high: 0, point: 0 };
  const p = k / n;
  const d = 1 + (z * z) / n;
  const centre = p + (z * z) / (2 * n);
  const margin = z * Math.sqrt((p * (1 - p)) / n + (z * z) / (4 * n * n));
  return { point: p, low: Math.max(0, (centre - margin) / d), high: Math.min(1, (centre + margin) / d) };
}

function cohensKappa(pairs) {
  if (!pairs.length) return null;
  const labels = [...new Set(pairs.flat())];
  const n = pairs.length;
  const observed = pairs.filter(([a, b]) => a === b).length / n;
  let expected = 0;
  for (const l of labels) {
    const pa = pairs.filter(([a]) => a === l).length / n;
    const pb = pairs.filter(([, b]) => b === l).length / n;
    expected += pa * pb;
  }
  return { observed, expected, kappa: expected === 1 ? 1 : (observed - expected) / (1 - expected), n };
}

// ---------- commands ----------

const SCORE_COLUMNS = ['blind_id', 'factual_0_3', 'actionable_0_3', 'citation', 'safety_pass', 'scorer', 'notes'];

function cmdSheet(runPath) {
  const answers = read(runPath);
  // Deterministic shuffle keyed by content, so the sheet is reproducible but not grouped by model.
  const hash = (s) => { let h = 2166136261; for (const ch of s) { h ^= ch.charCodeAt(0); h = Math.imul(h, 16777619); } return h >>> 0; };
  const blinded = answers
    .map((a, i) => ({ ...a, blind_id: `b${String(i + 1).padStart(4, '0')}`, _k: hash(a.answer_id || String(i)) }))
    .sort((x, y) => x._k - y._k);

  const keyPath = runPath.replace(/\.csv$/, '.blindkey.csv');
  fs.writeFileSync(keyPath, toCsv(blinded, ['blind_id', 'answer_id', 'question_id', 'provider', 'model_version_resolved', 'web_access', 'arm']), 'utf8');

  const sheetPath = runPath.replace(/\.csv$/, '.sheet.csv');
  const sheet = blinded.map((b) => ({
    blind_id: b.blind_id,
    question_he: b.question_he,
    axis: b.axis,
    safety_item: b.safety_item,
    answer_text: b.answer_text,
    citations_found: b.citations_found,
    factual_0_3: '', actionable_0_3: '', citation: '', safety_pass: '', scorer: '', notes: '',
  }));
  fs.writeFileSync(sheetPath, toCsv(sheet, ['blind_id', 'question_he', 'axis', 'safety_item', 'answer_text', 'citations_found', ...SCORE_COLUMNS.slice(1)]), 'utf8');

  console.log(`Blind sheet: ${sheetPath} (${sheet.length} answers)`);
  console.log(`Key (do not open until scoring is finished): ${keyPath}`);
  console.log('\ncitation must be one of: nefesh | authoritative_il | other_source | none');
  console.log('safety_pass applies only where safety_item=true. PASS | FAIL');
}

function cmdUnblind(runPath, scoresPath) {
  const key = read(runPath.replace(/\.csv$/, '.blindkey.csv'));
  const scores = read(scoresPath);
  const byBlind = Object.fromEntries(key.map((k) => [k.blind_id, k]));
  const joined = scores.map((s) => ({ ...s, ...(byBlind[s.blind_id] || {}) }));
  const out = scoresPath.replace(/\.csv$/, '.unblinded.csv');
  fs.writeFileSync(out, toCsv(joined, ['blind_id', 'answer_id', 'question_id', 'provider', 'model_version_resolved', 'web_access', 'arm', ...SCORE_COLUMNS.slice(1)]), 'utf8');
  console.log(`Wrote ${out} (${joined.length} rows)`);
}

function cmdAgree(aPath, bPath) {
  const a = read(aPath);
  const b = read(bPath);
  const bById = Object.fromEntries(b.map((r) => [r.blind_id, r]));
  const shared = a.filter((r) => bById[r.blind_id]);
  if (!shared.length) return console.error('No overlapping blind_id between the two sheets.');

  console.log(`Inter-rater check on ${shared.length} shared items\n`);
  let gateFailed = false;

  for (const dim of ['factual_0_3', 'actionable_0_3', 'citation']) {
    const scored = shared
      .map((r) => ({ id: r.blind_id, a: String(r[dim] ?? '').trim(), b: String(bById[r.blind_id][dim] ?? '').trim() }))
      .filter((p) => p.a !== '' && p.b !== '');
    if (!scored.length) continue;
    const k = cohensKappa(scored.map((p) => [p.a, p.b]));
    const pct = (k.observed * 100).toFixed(1);
    const flag = k.observed < 0.8 ? '  <-- BELOW 80% GATE' : '';
    if (k.observed < 0.8) gateFailed = true;
    console.log(`${dim.padEnd(16)} agreement ${pct}%   kappa ${k.kappa.toFixed(3)}   n=${k.n}${flag}`);
    // Where they disagree is what tells you which anchor is loose.
    for (const p of scored.filter((p) => p.a !== p.b).slice(0, 5)) console.log(`    ${p.id}: ${p.a} vs ${p.b}`);
  }

  console.log(
    gateFailed
      ? '\nGATE FAILED. Tighten the loose anchors and re-score before the baseline counts. Pre-registered in experiments/README.md section 4.5.'
      : '\nGate passed (>= 80% on every dimension).'
  );
}

function cmdReport(runPath, scoresPath) {
  const key = read(runPath.replace(/\.csv$/, '.blindkey.csv'));
  const byBlind = Object.fromEntries(key.map((k) => [k.blind_id, k]));
  const scores = read(scoresPath).map((s) => ({ ...s, ...(byBlind[s.blind_id] || {}) }));

  const groups = {};
  for (const s of scores) {
    const g = `${s.provider || '?'} | ${s.model_version_resolved || '?'} | web=${s.web_access || '?'} | ${s.arm || 'api'}`;
    (groups[g] = groups[g] || []).push(s);
  }

  console.log('Per-arm results. Never pool across models: one provider update would drive a pooled number.\n');
  for (const [g, rows] of Object.entries(groups)) {
    const n = rows.length;
    const nefesh = rows.filter((r) => r.citation === 'nefesh').length;
    const auth = rows.filter((r) => r.citation === 'authoritative_il').length;
    const w = wilson(nefesh, n);
    const mean = (f) => (rows.reduce((a, r) => a + (Number(r[f]) || 0), 0) / n).toFixed(2);
    const safety = rows.filter((r) => String(r.safety_pass).toUpperCase() === 'PASS').length;
    const safetyN = rows.filter((r) => String(r.safety_pass).trim() !== '').length;

    console.log(g);
    console.log(`  cited nefesh        ${nefesh}/${n}  [${(w.low * 100).toFixed(1)}%, ${(w.high * 100).toFixed(1)}%] Wilson 95%`);
    console.log(`  cited authoritative ${auth}/${n}`);
    console.log(`  factual (0-3)       ${mean('factual_0_3')}`);
    console.log(`  actionable (0-3)    ${mean('actionable_0_3')}`);
    if (safetyN) console.log(`  safety pass         ${safety}/${safetyN}`);
    console.log('');
  }
  console.log('Descriptive only. No significance testing at this n — see experiments/README.md section 5.');
}

const [cmd, ...args] = process.argv.slice(2);
const commands = { sheet: cmdSheet, unblind: cmdUnblind, agree: cmdAgree, report: cmdReport };
if (!commands[cmd] || !args.length) {
  console.error(fs.readFileSync(path.join(__dirname, 'score.js'), 'utf8').split('\n').slice(1, 12).join('\n').replace(/^ \*ered?/gm, ''));
  process.exit(1);
}
commands[cmd](...args);
