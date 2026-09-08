// schema.org emission for the pre-rendered pages.
//
// Honest framing, so nobody reads more into this than it earns: `Service` markup has no
// rich-result treatment in Google or Bing, so the SERP payoff here is close to zero. This
// is worth doing because it is cheap, because it makes the entity relationships explicit
// for agents, and because writing it forces the vocabulary discipline that Phase 3 needs.
// It is not an SEO play and should not be described as one.
//
// The modelling decision that matters: the organisation/service pair is real. Sharan Medical
// is five entries because it runs five services. So entries are `Service` nodes with a
// `provider`, and every provider gets a stable `@id` so the 173 organisations are reusable
// graph nodes rather than 197 duplicated blobs.

const { phonesOf } = require('./extract_data');

const SITE = 'https://nefesh-il.org';

/** Provider type by category. One lookup beats a per-entry judgement call. */
const PROVIDER_TYPE_BY_CATEGORY = {
  moh: 'GovernmentOrganization',
  mod: 'GovernmentOrganization',
  rights: 'GovernmentOrganization',
  mh_clinics: 'MedicalClinic',
  hospitalization: 'Hospital',
  hmo: 'MedicalOrganization',
  therapists: 'MedicalOrganization',
  treatments: 'MedicalOrganization',
};

function providerType(categories) {
  for (const c of categories) {
    if (PROVIDER_TYPE_BY_CATEGORY[c]) return PROVIDER_TYPE_BY_CATEGORY[c];
  }
  return 'NGO';
}

/** Stable, ASCII, opaque identifier for an organisation, derived from its name. */
function orgHash(name) {
  let h1 = 2166136261;
  let h2 = 5381;
  const s = String(name).replace(/\s+/g, ' ').trim();
  for (let i = 0; i < s.length; i++) {
    h1 ^= s.charCodeAt(i);
    h1 = Math.imul(h1, 16777619);
    h2 = (Math.imul(h2, 33) + s.charCodeAt(i)) | 0;
  }
  return ((h1 >>> 0).toString(16).padStart(8, '0') + (h2 >>> 0).toString(16).padStart(8, '0')).slice(0, 12);
}

const orgId = (name) => `${SITE}/#org-${orgHash(name)}`;
const serviceId = (entry) => `${SITE}${entry.path}#service`;

/**
 * Free only where the cost field says nothing but "free".
 *
 * Deliberately strict, and the strictness is the point. A substring match is not good
 * enough here, because the source contains conditional forms that a substring test reads
 * as unconditional:
 *
 *   "חינם"                                        -> free
 *   "חינם לזכאים"                                  -> free *for those eligible*. NOT free.
 *   "חינם דרך קופות החולים (טופס 17)... גם פרטי"    -> free *via a referral route*. NOT free.
 *   "ממונן ע״י הקופות: כללית, מאוחדת ולאומית"        -> a funding model plus a payer list, not a price.
 *   "מסובסד"                                       -> subsidised, not free.
 *
 * Emitting isAccessibleForFree and price: 0 for a conditionally-free service is a
 * fabrication with machine consequences — someone could conclude a service costs nothing
 * when it will in fact turn them away without a form 17. Those cases keep their Offer with
 * the source wording as the description and no price at all, which is the honest shape.
 */
const UNCONDITIONALLY_FREE = /^(חינם|ללא עלות|ללא תשלום|בחינם|free|free of charge|no cost)$/i;

function isLiterallyFree(cost) {
  const s = String(cost || '')
    .replace(/\s+/g, ' ')
    .replace(/[.!;,]+$/, '')
    .trim();
  if (!s) return false;
  return UNCONDITIONALLY_FREE.test(s);
}

/**
 * areaServed from the free-text region field.
 * "כל הארץ" is the whole country. A comma-separated city list becomes an array of Place,
 * which is a cheap win available without waiting for Phase 3's controlled vocabulary.
 */
function areaServed(region) {
  const s = String(region || '').replace(/\s+/g, ' ').trim();
  if (!s) return undefined;

  if (/^כל הארץ/.test(s) || /^nationwide/i.test(s) || /כל הארץ/.test(s)) {
    return { '@type': 'Country', name: 'ישראל', alternateName: 'Israel' };
  }
  // Only split when it really looks like a list; parenthetical qualifiers are left whole
  // rather than chopped into meaningless fragments.
  if (s.includes(',') && !/[()]/.test(s)) {
    const places = s
      .split(',')
      .map((p) => p.trim())
      .filter(Boolean);
    if (places.length > 1) return places.map((name) => ({ '@type': 'Place', name }));
  }
  return { '@type': 'Place', name: s };
}

/**
 * One ServiceChannel per populated phone slot, each carrying the Hebrew label as
 * contactType. This preserves the published wording and is the richest thing the dataset
 * has: labelled multi-number contact ("מוקד", "באר שבע", "ירושלים") is not published in
 * structured form by anyone else in this space.
 */
function availableChannel(entry, telsBySlot) {
  const channels = [];
  for (const p of phonesOf(entry.raw)) {
    const tels = telsBySlot.get(p.slot) || [];
    if (!tels.length) continue;
    channels.push({
      '@type': 'ServiceChannel',
      name: p.label || undefined,
      servicePhone: tels.map((tel) => ({
        '@type': 'ContactPoint',
        telephone: tel,
        contactType: p.label || 'טלפון',
        availableLanguage: languageCodes(entry.raw.languages),
      })),
    });
  }
  const web = entry.raw.web;
  if (web && /^https?:\/\//.test(web)) {
    channels.push({ '@type': 'ServiceChannel', serviceUrl: web, name: entry.raw.webLabel || undefined });
  }
  return channels.length ? channels : undefined;
}

const LANGUAGE_TOKENS = [
  [/עברית|hebrew/i, 'he'],
  [/ערבית|arabic/i, 'ar'],
  [/רוסית|russian/i, 'ru'],
  [/אנגלית|english/i, 'en'],
  [/אמהרית|amharic/i, 'am'],
  [/צרפתית|french/i, 'fr'],
  [/ספרדית|spanish/i, 'es'],
  [/יידיש|yiddish/i, 'yi'],
];

/** BCP-47 codes where the free text names a recognisable language, otherwise nothing. */
function languageCodes(languages) {
  const s = String(languages || '');
  if (!s.trim()) return undefined;
  const codes = LANGUAGE_TOKENS.filter(([re]) => re.test(s)).map(([, code]) => code);
  return codes.length ? codes : undefined;
}

/** Strip undefined and empty arrays so the emitted JSON carries no hollow keys. */
function prune(obj) {
  if (Array.isArray(obj)) {
    const arr = obj.map(prune).filter((v) => v !== undefined);
    return arr.length ? arr : undefined;
  }
  if (obj && typeof obj === 'object') {
    const out = {};
    for (const [k, v] of Object.entries(obj)) {
      const p = prune(v);
      if (p !== undefined && p !== null && p !== '') out[k] = p;
    }
    return Object.keys(out).length ? out : undefined;
  }
  return obj;
}

const clean = (s) => (s ? String(s).replace(/\s+/g, ' ').trim() : undefined);

/**
 * The canonical Service node for an entry, plus its provider Organization.
 * @param telsBySlot Map<slot, string[]> of tel: values the page actually rendered, so the
 *                   markup can never claim a number the visible page does not show.
 */
function entryGraph(entry, ctx, telsBySlot, trail) {
  const { DATA, ENTRY_LOCATIONS, lastUpdatedIso } = ctx;
  const categoryTitles = entry.categories.filter((c) => DATA[c]).map((c) => DATA[c].title);
  const providerNodeId = orgId(entry.org);

  const locations = (ENTRY_LOCATIONS[String(entry.row)] || []).map((l) =>
    prune({
      '@type': 'Place',
      name: clean(l.label),
      address: clean(l.address),
      geo:
        l.lat != null && l.lng != null
          ? { '@type': 'GeoCoordinates', latitude: l.lat, longitude: l.lng }
          : undefined,
    })
  );

  const provider = prune({
    '@type': providerType(entry.categories),
    '@id': providerNodeId,
    name: clean(entry.org),
    url: /^https?:\/\//.test(entry.raw.web || '') ? entry.raw.web : undefined,
    email: clean(entry.raw.email),
    location: locations.length ? locations : undefined,
    areaServed: areaServed(entry.raw.region),
  });

  const cost = clean(entry.raw.cost);
  const service = prune({
    '@type': 'Service',
    '@id': serviceId(entry),
    name: clean(entry.svc) || clean(entry.org),
    alternateName: clean(entry.svc) ? clean(entry.org) : undefined,
    description: clean(entry.raw.notes) || clean(entry.svc),
    url: `${SITE}${entry.path}`,
    inLanguage: entry.raw.dir === 'ltr' ? 'en' : 'he',
    dateModified: lastUpdatedIso,
    // Multi-homing is expressed as an array on one node, never as duplicate nodes per
    // category. Category pages reference this @id instead of restating it.
    serviceType: categoryTitles.length ? categoryTitles : undefined,
    category: categoryTitles.length ? categoryTitles : undefined,
    provider: { '@id': providerNodeId },
    areaServed: areaServed(entry.raw.region),
    availableLanguage: languageCodes(entry.raw.languages),
    audience: entry.raw.target
      ? {
          '@type': 'PeopleAudience',
          // Free text, so not machine-comparable. Phase 3's controlled vocabulary is what
          // would make this useful; until then it is a faithful copy of the source.
          audienceType: clean(entry.raw.target),
        }
      : undefined,
    availableChannel: availableChannel(entry, telsBySlot),
    // An Offer with a description and no price. There is no price to state for most of
    // these, and inventing one would be worse than omitting it.
    offers: cost
      ? prune({
          '@type': 'Offer',
          description: cost,
          availability: 'https://schema.org/InStock',
          ...(isLiterallyFree(cost) ? { price: 0, priceCurrency: 'ILS' } : {}),
        })
      : undefined,
    isAccessibleForFree: cost ? isLiterallyFree(cost) : undefined,
  });

  return [service, provider, breadcrumbList(trail)].filter(Boolean);
}

function breadcrumbList(trail) {
  if (!trail || trail.length < 2) return null;
  return {
    '@type': 'BreadcrumbList',
    itemListElement: trail.map((c, i) => ({
      '@type': 'ListItem',
      position: i + 1,
      name: c.name,
      item: `${SITE}${c.url}`,
    })),
  };
}

/**
 * Category and group pages: an ItemList of @id references into the graph, not copies.
 * A crawler that has seen /s/210 already has the Service; this only says "it is in here".
 */
function collectionGraph({ name, description, path, members, trail, lastUpdatedIso, extra }) {
  const nodes = [
    prune({
      '@type': 'CollectionPage',
      '@id': `${SITE}${path}#page`,
      name,
      description,
      url: `${SITE}${path}`,
      inLanguage: 'he',
      dateModified: lastUpdatedIso,
      isPartOf: { '@id': `${SITE}/#website` },
      mainEntity: {
        '@type': 'ItemList',
        numberOfItems: members.length,
        itemListOrder: 'https://schema.org/ItemListUnordered',
        itemListElement: members.map((e, i) => ({
          '@type': 'ListItem',
          position: i + 1,
          item: { '@id': serviceId(e) },
        })),
      },
    }),
    breadcrumbList(trail),
    ...(extra || []),
  ].filter(Boolean);
  return nodes;
}

/** A single glossary term, as a member of the set at /terms. */
function termGraph({ key, term, slug, categoryTitle, trail, lastUpdatedIso }) {
  return [
    prune({
      '@type': 'DefinedTerm',
      '@id': `${SITE}/term/${slug}#term`,
      name: clean(term.title),
      description: clean(term.text),
      // The existing DATA key is already a stable ASCII identifier, so it is the termCode.
      termCode: key,
      url: `${SITE}/term/${slug}`,
      inLanguage: 'he',
      inDefinedTermSet: { '@id': `${SITE}/terms#set` },
      dateModified: lastUpdatedIso,
      additionalType: categoryTitle,
    }),
    breadcrumbList(trail),
  ].filter(Boolean);
}

/** The glossary index: one parent set with a nested subset per TERM_CATEGORIES group. */
function termsIndexGraph({ terms, TERM_CATEGORIES, slugByKey, trail, lastUpdatedIso }) {
  const byCat = {};
  for (const [k, t] of Object.entries(terms)) {
    const cat = t.category || 'other';
    (byCat[cat] = byCat[cat] || []).push([k, t]);
  }

  const subsets = Object.entries(TERM_CATEGORIES)
    .filter(([cid]) => byCat[cid])
    .map(([cid, c]) =>
      prune({
        '@type': 'DefinedTermSet',
        '@id': `${SITE}/terms#set-${cid}`,
        name: clean(c.title),
        inLanguage: 'he',
        isPartOf: { '@id': `${SITE}/terms#set` },
        hasDefinedTerm: byCat[cid].map(([k]) => ({ '@id': `${SITE}/term/${slugByKey[k]}#term` })),
      })
    );

  return [
    prune({
      '@type': 'DefinedTermSet',
      '@id': `${SITE}/terms#set`,
      name: 'מילון מונחים בבריאות הנפש בישראל',
      description: `${Object.keys(terms).length} מונחים שחוזרים בשירותי בריאות הנפש בישראל: זכויות, טיפול, אשפוז, שיקום וקופות חולים.`,
      url: `${SITE}/terms`,
      inLanguage: 'he',
      dateModified: lastUpdatedIso,
      hasPart: subsets.map((s) => ({ '@id': s['@id'] })),
    }),
    ...subsets,
    breadcrumbList(trail),
  ].filter(Boolean);
}

/** WebSite plus SearchAction, exposing the existing in-app search at /?q=. */
function websiteNode() {
  return {
    '@type': 'WebSite',
    '@id': `${SITE}/#website`,
    name: 'מדריך נפש',
    alternateName: 'Nefesh — Israel Mental Health Directory',
    url: `${SITE}/`,
    inLanguage: 'he',
    potentialAction: {
      '@type': 'SearchAction',
      target: { '@type': 'EntryPoint', urlTemplate: `${SITE}/?q={search_term_string}` },
      'query-input': 'required name=search_term_string',
    },
  };
}

/** Serialise an @graph. `</` is escaped so the payload cannot terminate the script tag. */
function serialize(nodes) {
  const graph = { '@context': 'https://schema.org', '@graph': nodes.filter(Boolean) };
  return JSON.stringify(graph).replace(/<\//g, '<\\/');
}

module.exports = {
  SITE,
  orgId,
  orgHash,
  serviceId,
  providerType,
  isLiterallyFree,
  areaServed,
  languageCodes,
  entryGraph,
  collectionGraph,
  termGraph,
  termsIndexGraph,
  breadcrumbList,
  websiteNode,
  serialize,
  prune,
};
