#!/usr/bin/env node
/**
 * Generates the machine-readable export.
 *
 * This is the highest-leverage item in Phase 2, ahead of the JSON-LD: one static fetch
 * gives a consumer the whole dataset, rather than 189 page fetches and a parser. Static and
 * generated rather than an API route — cheaper, cacheable, no cold start, and it cannot
 * return a 500.
 *
 *   node scripts/build_export.js
 *
 * Emits:
 *   /directory.json          the dataset
 *   /directory.schema.json   JSON Schema for it
 *   /llms.txt                a signpost to both, for agents that look for one
 *
 * Field contract: names are frozen, changes are additive only, and anything removed is
 * recorded in directory.changelog.md. Consumers can rely on that; it is the whole point of
 * publishing schema_version.
 */

const fs = require('fs');
const path = require('path');
const { load, phonesOf } = require('./lib/extract_data');
const { overlayDirectoryCards } = require('./lib/overlay_directory_cards');
const { validate } = require('./lib/validate_schema');
const LD = require('./lib/jsonld');

const ROOT = path.join(__dirname, '..');
const SCHEMA_VERSION = '1.0.0';
const SITE = 'https://nefesh-il.org';

const clean = (v) => {
  if (v == null) return null;
  const s = String(v).replace(/\r/g, '').trim();
  return s === '' ? null : s;
};

function isoDate(ddmmyyyy) {
  const m = String(ddmmyyyy || '').match(/^(\d{2})\.(\d{2})\.(\d{4})$/);
  return m ? `${m[3]}-${m[2]}-${m[1]}` : null;
}

function buildExport(data = load()) {

  const holdoutPath = path.join(ROOT, 'experiments', 'holdout.json');
  const holdoutRows = new Set(
    fs.existsSync(holdoutPath) ? (JSON.parse(fs.readFileSync(holdoutPath, 'utf8')).rows || []).map((r) => r.row) : []
  );

  const published = data.entries.filter((e) => !holdoutRows.has(e.row));
  const lastUpdated = isoDate(data.LAST_UPDATED);

  const groupOf = (categoryKey) =>
    Object.keys(data.CATEGORY_GROUPS).find((g) => data.CATEGORY_GROUPS[g].subcategories.includes(categoryKey)) || null;

  const entries = published.map((entry) => {
    const r = entry.raw;
    return {
      id: entry.path.replace('/s/', ''),
      row: entry.row,
      url: `${SITE}${entry.path}`,
      // The legacy Hebrew slug, still used by directory_entries and by old share links.
      legacy_entry_id: entry.entryId,
      organisation: clean(entry.org),
      organisation_id: LD.orgId(entry.org),
      service: clean(entry.svc),
      language_direction: r.dir === 'ltr' ? 'ltr' : 'rtl',
      categories: entry.categories.filter((c) => data.DATA[c]),
      subsections: entry.subsections,
      groups: [...new Set(entry.categories.map(groupOf).filter(Boolean))],

      // Free-text facets, exactly as published. Not normalised, and deliberately so: the
      // original wording is the only thing that is actually verifiable against the source.
      // Coverage is uneven and documented in docs/facet-coverage.md.
      target: clean(r.target),
      region: clean(r.region),
      cost: clean(r.cost),
      specialty: clean(r.specialty),
      diseases: clean(r.diseases),
      languages: clean(r.languages),
      notes: clean(r.notes),

      // Normalised codes sit alongside the free text, never replacing it. Null where the
      // source does not say. See docs/facet-coverage.md for coverage.
      referral_codes: Array.isArray(r.referralCodes) && r.referralCodes.length ? r.referralCodes : null,

      // Derived, and derived conservatively: true only where the cost field says nothing
      // but "free". Conditional forms such as "חינם לזכאים" are not free here.
      is_free: r.cost ? LD.isLiterallyFree(r.cost) : null,

      phones: phonesOf(r).map((p) => ({
        slot: p.slot,
        // Verbatim source string. It is sometimes not a bare number ("מוקד 'קשובים' 9518*",
        // "*2700 | חירום: 1-700-50-70-50"), and truncating it would lose meaning.
        raw: p.number,
        label: p.label,
      })),
      whatsapp: clean(r.whatsapp),
      email: clean(r.email),
      website: /^https?:\/\//.test(r.web || '') ? r.web : null,
      website_label: clean(r.webLabel),
      additional_links: [
        ...(/^https?:\/\//.test(r.web2 || '') ? [{ url: r.web2, label: clean(r.webLabel2) }] : []),
        ...(/^https?:\/\//.test(r.add || '') ? [{ url: r.add, label: clean(r.addLabel) }] : []),
      ],
      locations: (data.ENTRY_LOCATIONS[String(entry.row)] || []).map((l) => ({
        label: clean(l.label),
        address: clean(l.address),
        lat: l.lat ?? null,
        lng: l.lng ?? null,
      })),
    };
  });

  const categories = Object.entries(data.DATA).map(([key, cat]) => ({
    key,
    title: clean(cat.title),
    title_en: clean(cat.titleEn),
    description: clean(cat.desc),
    group: groupOf(key),
    url: `${SITE}/c/${key}`,
    // books_movies holds no service entries; its content is the `media` array below.
    // entry_count 0 there means "not that kind of category", not "empty".
    is_resource_hub: cat.resourceHub === true,
    entry_count: published.filter((e) => e.categories.includes(key)).length,
    subsections: Object.entries(cat.subsections || {}).map(([sk, s]) => ({
      key: sk,
      title: clean(s.title),
      url: `${SITE}/c/${key}/${sk}`,
      entry_count: published.filter((e) => e.subsections.includes(`${key}/${sk}`)).length,
    })),
  }));

  const groups = Object.entries(data.CATEGORY_GROUPS).map(([key, g]) => ({
    key,
    title: clean(g.title),
    description: clean(g.desc),
    url: `${SITE}/g/${key}`,
    categories: g.subcategories.filter((c) => data.DATA[c]),
  }));

  // Films, series and documentaries. A separate entity type from services: they are not
  // something you can phone, and flattening them into `entries` would misrepresent both.
  const media = (data.FILMS || []).map((f) => ({
    id: f.id,
    title: clean(f.title),
    type: clean(f.type),
    year: clean(f.year),
    languages: f.languages || [],
    hebrew_subtitles: clean(f.hebrewSubs),
    topics: f.topics || [],
    brief: clean(f.brief),
    // Editorial ratings, 1-5, from the compiler of the directory. Subjective by construction.
    rating_therapists: f.ratingTherapists ?? null,
    rating_peers: f.ratingPeers ?? null,
    platforms: (f.platforms || []).map((p) => ({ name: clean(p.name), url: clean(p.url), free: p.free === true })),
  }));

  const termSlug = (k) => String(k).toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
  const glossary = Object.entries(data.terms).map(([key, t]) => ({
    key,
    slug: termSlug(key),
    url: `${SITE}/term/${termSlug(key)}`,
    title: clean(t.title),
    text: clean(t.text),
    category: clean(t.category),
    category_title: clean(data.TERM_CATEGORIES[t.category]?.title),
    phone: clean(t.phone),
    related: t.related || [],
  }));

  return {
    export: {
      schema_version: SCHEMA_VERSION,
      // The moment this file was built. A consumer republishing stale crisis numbers is a
      // genuine harm, so this is the timestamp that lets them notice.
      generated_at: new Date().toISOString(),
      // The date the underlying directory was last curated, which is the number that
      // actually matters for staleness. generated_at only says when the build ran.
      source_last_updated: lastUpdated,
      source: `${SITE}/`,
      schema: `${SITE}/directory.schema.json`,
      changelog: `${SITE}/directory.changelog.md`,
      license: 'CC-BY-4.0 on the compilation. See /LICENSE-data.md.',
      license_url: `${SITE}/LICENSE-data.md`,
      notices: [
        'Not medical advice. This is a signposting directory, not a clinical resource.',
        'Listing is not endorsement. Inclusion does not imply vetting, accreditation or recommendation.',
        'Verify every phone number against the organisation before republishing it. A wrong crisis number is a concrete harm.',
        'Facet fields (target, region, cost, specialty, diseases, languages) are free text as published by the source and are unevenly populated. See docs/facet-coverage.md.',
      ],
      counts: {
        entries: entries.length,
        organisations: new Set(entries.map((e) => e.organisation_id)).size,
        categories: categories.length,
        groups: groups.length,
        glossary_terms: glossary.length,
        media: media.length,
        geocoded_locations: entries.reduce((n, e) => n + e.locations.length, 0),
        entries_withheld: holdoutRows.size,
      },
      withheld_note:
        holdoutRows.size > 0
          ? `${holdoutRows.size} entries are withheld from this export for one cycle as the control arm of a documented experiment. None are emergency or crisis services. See ${SITE}/experiments/holdout.json.`
          : null,
    },
    groups,
    categories,
    entries,
    glossary,
    media,
  };
}

// ---------------------------------------------------------------- JSON Schema

function buildSchema() {
  const str = { type: ['string', 'null'] };
  return {
    $schema: 'https://json-schema.org/draft/2020-12/schema',
    $id: `${SITE}/directory.schema.json`,
    title: 'Nefesh mental-health services directory export',
    description:
      'Schema for directory.json. Field names are frozen; changes are additive only. Removals and deprecations are recorded in directory.changelog.md.',
    type: 'object',
    required: ['export', 'groups', 'categories', 'entries', 'glossary', 'media'],
    properties: {
      export: {
        type: 'object',
        required: ['schema_version', 'generated_at', 'source_last_updated', 'license', 'counts'],
        properties: {
          schema_version: { type: 'string', description: 'Semver. Major bump means a breaking field change.' },
          generated_at: { type: 'string', format: 'date-time', description: 'When this file was built.' },
          source_last_updated: {
            type: ['string', 'null'],
            format: 'date',
            description: 'When the directory itself was last curated. The staleness signal that matters.',
          },
          source: { type: 'string', format: 'uri' },
          schema: { type: 'string', format: 'uri' },
          changelog: { type: 'string', format: 'uri' },
          license: { type: 'string' },
          license_url: { type: 'string', format: 'uri' },
          notices: { type: 'array', items: { type: 'string' } },
          counts: { type: 'object', additionalProperties: { type: 'integer' } },
          withheld_note: { type: ['string', 'null'] },
        },
      },
      groups: {
        type: 'array',
        items: {
          type: 'object',
          required: ['key', 'title', 'categories'],
          properties: {
            key: { type: 'string' },
            title: str,
            description: str,
            url: { type: 'string', format: 'uri' },
            categories: { type: 'array', items: { type: 'string' } },
          },
        },
      },
      categories: {
        type: 'array',
        items: {
          type: 'object',
          required: ['key', 'title', 'entry_count'],
          properties: {
            key: { type: 'string' },
            title: str,
            title_en: str,
            description: str,
            group: { type: ['string', 'null'] },
            url: { type: 'string', format: 'uri' },
            is_resource_hub: {
              type: 'boolean',
              description: 'True for categories whose content is `media` rather than service entries. entry_count will be 0.',
            },
            entry_count: { type: 'integer' },
            subsections: {
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  key: { type: 'string' },
                  title: str,
                  url: { type: 'string', format: 'uri' },
                  entry_count: { type: 'integer' },
                },
              },
            },
          },
        },
      },
      entries: {
        type: 'array',
        items: {
          type: 'object',
          required: ['id', 'row', 'url', 'organisation', 'categories'],
          properties: {
            id: {
              type: 'string',
              description:
                'Stable public identifier, matching the /s/<id> URL. Usually the row number. Rows shared by more than one entry get a suffix, e.g. "15-naa1"; the first entry in source order keeps the bare row.',
            },
            row: {
              type: 'integer',
              description:
                'Source row number. NOT unique: nine rows are shared by two or three entries. Use `id` as the key, not `row`.',
            },
            url: { type: 'string', format: 'uri' },
            legacy_entry_id: {
              type: 'string',
              description: 'Older Hebrew slug identifier, retained because old share links and the database still use it.',
            },
            organisation: str,
            organisation_id: {
              type: 'string',
              description: 'Stable per organisation, shared across all its services. Matches the provider @id in the page JSON-LD.',
            },
            service: str,
            language_direction: { enum: ['rtl', 'ltr'], description: 'ltr marks entries published in English.' },
            categories: { type: 'array', items: { type: 'string' } },
            subsections: { type: 'array', items: { type: 'string' }, description: 'Composite "<category>/<subsection>" keys.' },
            groups: { type: 'array', items: { type: 'string' } },

            target: { ...str, description: 'Intended audience, free text as published. Populated on roughly 23% of entries.' },
            region: { ...str, description: 'Geographic coverage, free text. Roughly 55%.' },
            cost: { ...str, description: 'Cost or funding, free text. Roughly 29%. Not a price and often not expressible as one.' },
            specialty: str,
            diseases: str,
            languages: { ...str, description: 'Languages of service, free text.' },
            notes: str,

            referral_codes: {
              type: ['array', 'null'],
              items: {
                enum: [
                  'self_referral',
                  'gp_referral',
                  'hmo_form17',
                  'psychiatrist_referral',
                  'mod_rehab_worker',
                  'nii_referral',
                  'rehab_basket_committee',
                  'court_or_welfare',
                  'unknown',
                ],
              },
              description:
                'How to get in. The only normalised vocabulary so far. Null where not yet assessed. The free-text source wording is always preserved in `notes` and `cost`.',
            },
            is_free: {
              type: ['boolean', 'null'],
              description:
                'True only where the cost field says nothing but "free". Conditional forms such as "free for those eligible" are false, not true. Null where cost is not published.',
            },

            phones: {
              type: 'array',
              description:
                'Up to six labelled slots. `raw` is the verbatim source string and is sometimes more than a bare number; parse it, do not assume.',
              items: {
                type: 'object',
                required: ['slot', 'raw'],
                properties: {
                  slot: { type: 'integer', minimum: 1, maximum: 6 },
                  raw: { type: 'string' },
                  label: { ...str, description: 'Hebrew label as published, e.g. "מוקד", "ירושלים", "חירום".' },
                },
              },
            },
            whatsapp: str,
            email: str,
            website: { type: ['string', 'null'], format: 'uri' },
            website_label: str,
            additional_links: {
              type: 'array',
              items: { type: 'object', properties: { url: { type: 'string' }, label: str } },
            },
            locations: {
              type: 'array',
              items: {
                type: 'object',
                properties: { label: str, address: str, lat: { type: ['number', 'null'] }, lng: { type: ['number', 'null'] } },
              },
            },
          },
        },
      },
      glossary: {
        type: 'array',
        items: {
          type: 'object',
          required: ['key', 'slug', 'title'],
          properties: {
            key: { type: 'string', description: 'Stable identifier, also emitted as termCode in the page JSON-LD.' },
            slug: { type: 'string' },
            url: { type: 'string', format: 'uri' },
            title: str,
            text: str,
            category: str,
            category_title: str,
            phone: str,
            related: { type: 'array', items: { type: 'string' } },
          },
        },
      },
      media: {
        type: 'array',
        description:
          'Films, series and documentaries about therapy and mental health. A separate entity type from services — not something you can contact.',
        items: {
          type: 'object',
          required: ['id', 'title', 'type'],
          properties: {
            id: { type: 'string' },
            title: str,
            type: { enum: ['movie', 'series', 'doc', 'doc_series'] },
            year: str,
            languages: { type: 'array', items: { type: 'string' } },
            hebrew_subtitles: str,
            topics: { type: 'array', items: { type: 'string' }, description: 'Hebrew topic tags.' },
            brief: { ...str, description: 'Editorial note, in English.' },
            rating_therapists: {
              type: ['integer', 'null'],
              minimum: 1,
              maximum: 5,
              description: "The compiler's own rating for a therapists' audience. Subjective, not a survey result.",
            },
            rating_peers: { type: ['integer', 'null'], minimum: 1, maximum: 5, description: "The compiler's own rating for a lived-experience audience." },
            platforms: {
              type: 'array',
              items: {
                type: 'object',
                properties: { name: str, url: str, free: { type: 'boolean' } },
              },
            },
          },
        },
      },
    },
  };
}

// ---------------------------------------------------------------- llms.txt

/**
 * llms.txt is a proposed convention, not a standard, and no major model provider has
 * committed to reading it. It costs about twenty lines to generate from data we already
 * have, so it is worth having; it should not be described as more than a low-cost bet.
 *
 * Generated rather than hand-written so the category list and counts cannot drift.
 */
function buildLlmsTxt(payload) {
  const c = payload.export.counts;
  const byGroup = payload.groups.map((g) => {
    const cats = payload.categories.filter((cat) => cat.group === g.key);
    const lines = cats.map((cat) => {
      const count = cat.is_resource_hub ? `${c.media} סרטים וסדרות` : `${cat.entry_count} שירותים`;
      return `- [${cat.title}](${cat.url}): ${count}${cat.description ? ` — ${cat.description}` : ''}`;
    });
    return `### ${g.title}\n\n${lines.join('\n')}`;
  });

  return `# מדריך נפש — Nefesh, Israel mental-health services directory

> A curated directory of ${c.entries} mental-health services from ${c.organisations} organisations in Israel,
> organised into ${c.groups} groups and ${c.categories} categories, plus a ${c.glossary_terms}-term glossary
> and ${c.media} films and series about therapy.
> Content is in Hebrew. Last curated ${payload.export.source_last_updated}.

## Before you use this

- **Not medical advice.** This is a signposting directory. It does not diagnose, triage or treat.
- **Listing is not endorsement.** Inclusion means the service was found and recorded, not vetted or accredited.
- **Phone numbers go stale.** Every number carries the date the directory was last curated. If you
  are about to repeat a crisis number to someone, say where it came from and when it was checked.
  A wrong crisis number is a concrete harm, not a formatting error.
- **If someone is in immediate danger**, the numbers are 101 (מד"א), 100 (משטרה),
  1201 (ער"ן), and 1800-363-363 (סה"ר). These are on every page of the site.

## Structured data

Prefer these over scraping. They are static files, updated on every deploy.

- [directory.json](${SITE}/directory.json): the whole dataset in one fetch — entries, categories, groups, glossary
- [directory.schema.json](${SITE}/directory.schema.json): JSON Schema for the above, with field-level caveats
- [directory.changelog.md](${SITE}/directory.changelog.md): what changed between schema versions
- [LICENSE-data.md](${SITE}/LICENSE-data.md): CC-BY-4.0 on the compilation, with attribution terms
- [sitemap.xml](${SITE}/sitemap.xml): every indexable page

Individual pages also carry schema.org JSON-LD (\`Service\`, \`Organization\`, \`DefinedTerm\`).

## What the fields do and don't tell you

The facet fields — target, region, cost, specialty, diseases, languages — are **free text as
published by each source**, not a controlled vocabulary. They are unevenly populated: region is
present on roughly 55% of entries, cost on 29%, target on 23%. Absence of a value means the
source did not publish one, **not** that the service is unrestricted. Do not infer eligibility,
catchment or price from a null. Coverage figures: ${SITE}/docs/facet-coverage.md

\`is_free\` is true only where the cost field says nothing but "free". Conditional wording such as
"חינם לזכאים" (free for those eligible) is false, not true.

\`row\` is not unique — nine rows are shared by more than one entry. Key on \`id\`.

## Directory structure

${byGroup.join('\n\n')}

## Also here

- [Glossary](${SITE}/terms): ${c.glossary_terms} terms explaining the Israeli mental-health system
- [Full index](${SITE}/directory): every service on one page
${payload.export.withheld_note ? `\n## Note on completeness\n\n${payload.export.withheld_note}\n` : ''}`;
}

// ---------------------------------------------------------------- assertions

function assertExportIsSound(payload) {
  const problems = [];
  const ids = new Set();

  for (const e of payload.entries) {
    if (ids.has(e.id)) problems.push(`duplicate entry id: ${e.id}`);
    ids.add(e.id);
    if (!e.organisation) problems.push(`entry ${e.id} has no organisation name`);
    if (!e.categories.length) problems.push(`entry ${e.id} has no categories`);
    if (e.is_free === true && !require('./lib/jsonld').isLiterallyFree(e.cost)) {
      problems.push(`entry ${e.id} is_free=true but cost is "${e.cost}"`);
    }
  }

  // Category entry_count must agree with the entries actually exported, or a consumer
  // trusting the counts gets a different answer from a consumer counting the rows.
  for (const c of payload.categories) {
    const actual = payload.entries.filter((e) => e.categories.includes(c.key)).length;
    if (actual !== c.entry_count) problems.push(`category ${c.key} count ${c.entry_count} != ${actual} exported entries`);
  }

  const declared = payload.export.counts.entries;
  if (declared !== payload.entries.length) problems.push(`counts.entries ${declared} != ${payload.entries.length}`);

  if (problems.length) {
    throw new Error(`${problems.length} export problem(s):\n${problems.slice(0, 8).map((p) => `  ${p}`).join('\n')}`);
  }
}

/**
 * Validate the export against the schema we publish alongside it. A schema that does not
 * describe its own data is worse than no schema: it tells consumers they can rely on
 * something they cannot. This already caught film `type` values the schema had not declared.
 */
function assertMatchesSchema(payload, schema) {
  const errors = validate(payload, schema);
  if (!errors.length) return;
  const shown = errors.slice(0, 10).map((e) => `  ${e}`).join('\n');
  throw new Error(`directory.json does not match directory.schema.json (${errors.length} error(s)):\n${shown}`);
}

// ---------------------------------------------------------------- cli

async function main() {
  const catalog = load();
  const cardText = await overlayDirectoryCards(catalog);
  const payload = buildExport(catalog);
  const schema = buildSchema();
  assertExportIsSound(payload);
  assertMatchesSchema(payload, schema);

  const jsonPath = path.join(ROOT, 'directory.json');
  const schemaPath = path.join(ROOT, 'directory.schema.json');
  const llmsPath = path.join(ROOT, 'llms.txt');
  fs.writeFileSync(jsonPath, JSON.stringify(payload, null, 2) + '\n', 'utf8');
  fs.writeFileSync(schemaPath, JSON.stringify(schema, null, 2) + '\n', 'utf8');
  fs.writeFileSync(llmsPath, buildLlmsTxt(payload), 'utf8');

  const kb = (p) => Math.round(fs.statSync(p).size / 1024);
  const c = payload.export.counts;
  console.log(`Wrote directory.json (${kb(jsonPath)}KB), directory.schema.json (${kb(schemaPath)}KB), llms.txt (${kb(llmsPath)}KB)`);
  console.log(`  ${c.entries} entries across ${c.organisations} organisations, ${c.categories} categories, ${c.glossary_terms} glossary terms`);
  console.log(`  ${c.media} films and series, ${c.geocoded_locations} geocoded locations`);
  console.log(`  ${c.entries_withheld} entries withheld (holdout control)`);
  console.log(`  schema_version ${payload.export.schema_version}, source_last_updated ${payload.export.source_last_updated}`);
  console.log('  validates against directory.schema.json');
  console.log(`  card text: ${cardText.source} (${cardText.applied} of ${cardText.rows} database rows applied)`);
}

if (require.main === module) {
  main().catch((err) => {
    console.error(`\nEXPORT FAILED: ${err.message}`);
    process.exit(1);
  });
}

module.exports = { buildExport, buildSchema, SCHEMA_VERSION };
