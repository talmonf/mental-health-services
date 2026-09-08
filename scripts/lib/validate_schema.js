/**
 * A small JSON Schema validator, covering exactly the keywords directory.schema.json uses.
 *
 * Why not a real validator: this repo vendors node_modules into git, so pulling one in for a
 * build-time check is a poor trade. The risk with hand-rolling is a validator that silently
 * ignores a keyword it does not implement — which would give false confidence, the exact
 * thing the check exists to prevent. So `KNOWN` is exhaustive and any keyword outside it
 * throws. If someone adds `oneOf` to the schema, the build fails loudly rather than skipping it.
 *
 * Not a general-purpose validator. It does not implement $ref, composition, or annotations,
 * and it should not be reused as though it does.
 */

// Keywords this validator actually checks.
const CHECKED = new Set([
  'type',
  'enum',
  'const',
  'required',
  'properties',
  'additionalProperties',
  'items',
  'minimum',
  'maximum',
  'minItems',
  'format',
]);

// Keywords that are documentation or metadata and carry no validation obligation.
const IGNORED = new Set(['$schema', '$id', 'title', 'description', 'default', 'examples', 'deprecated']);

const KNOWN = new Set([...CHECKED, ...IGNORED]);

// Only the formats the schema uses. An unknown format is a schema bug, not a pass.
const FORMATS = {
  'date-time': (v) => !Number.isNaN(Date.parse(v)) && /^\d{4}-\d{2}-\d{2}T/.test(v),
  date: (v) => /^\d{4}-\d{2}-\d{2}$/.test(v) && !Number.isNaN(Date.parse(v)),
  uri: (v) => /^[a-z][a-z0-9+.-]*:/i.test(v),
};

function typeOf(value) {
  if (value === null) return 'null';
  if (Array.isArray(value)) return 'array';
  if (Number.isInteger(value)) return 'integer';
  return typeof value;
}

function matchesType(value, expected) {
  const actual = typeOf(value);
  if (expected === 'number') return actual === 'number' || actual === 'integer';
  return actual === expected;
}

function walk(value, schema, at, errors) {
  for (const keyword of Object.keys(schema)) {
    if (!KNOWN.has(keyword)) {
      // Deliberately fatal, not an error entry: this is a defect in the validator or the
      // schema, not in the data, and it must not be reported as "data is valid".
      throw new Error(
        `validate_schema.js does not implement the "${keyword}" keyword (used at ${at || '/'}). ` +
          `Implement it or the check is not doing what it claims.`
      );
    }
  }

  const fail = (msg) => errors.push(`${at || '/'} ${msg}`);

  if (schema.type !== undefined) {
    const allowed = Array.isArray(schema.type) ? schema.type : [schema.type];
    if (!allowed.some((t) => matchesType(value, t))) {
      fail(`expected ${allowed.join(' or ')}, got ${typeOf(value)}`);
      return; // Further checks would be meaningless and noisy.
    }
  }

  if (value === null || value === undefined) return;

  if (schema.enum !== undefined && !schema.enum.includes(value)) {
    fail(`${JSON.stringify(value)} is not one of ${JSON.stringify(schema.enum)}`);
  }

  if (schema.const !== undefined && value !== schema.const) {
    fail(`expected constant ${JSON.stringify(schema.const)}`);
  }

  if (typeof value === 'string' && schema.format !== undefined) {
    const check = FORMATS[schema.format];
    if (!check) throw new Error(`validate_schema.js does not know format "${schema.format}" (at ${at || '/'})`);
    if (!check(value)) fail(`"${value}" is not a valid ${schema.format}`);
  }

  if (typeof value === 'number') {
    if (schema.minimum !== undefined && value < schema.minimum) fail(`${value} < minimum ${schema.minimum}`);
    if (schema.maximum !== undefined && value > schema.maximum) fail(`${value} > maximum ${schema.maximum}`);
  }

  if (Array.isArray(value)) {
    if (schema.minItems !== undefined && value.length < schema.minItems) {
      fail(`${value.length} items, minimum ${schema.minItems}`);
    }
    if (schema.items) value.forEach((v, i) => walk(v, schema.items, `${at}/${i}`, errors));
    return;
  }

  if (typeOf(value) === 'object') {
    for (const key of schema.required || []) {
      if (!(key in value)) fail(`missing required property "${key}"`);
    }
    for (const [key, sub] of Object.entries(schema.properties || {})) {
      if (key in value) walk(value[key], sub, `${at}/${key}`, errors);
    }
    if (schema.additionalProperties && typeof schema.additionalProperties === 'object') {
      const declared = new Set(Object.keys(schema.properties || {}));
      for (const [key, v] of Object.entries(value)) {
        if (!declared.has(key)) walk(v, schema.additionalProperties, `${at}/${key}`, errors);
      }
    }
  }
}

/** Returns an array of human-readable error strings. Empty means valid. */
function validate(value, schema) {
  const errors = [];
  walk(value, schema, '', errors);
  return errors;
}

module.exports = { validate };
