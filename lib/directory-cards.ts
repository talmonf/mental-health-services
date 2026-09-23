/**
 * Visible directory-card fields and eligibility published as JSON-LD, not painted on the card.
 * Empty / "any" on an eligibility dimension means no constraint (a future matcher
 * must not exclude the person). A filled value is necessary but not sufficient.
 * Keep the seed script in sync by having it transpile this module.
 */

export class DirectoryCardError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'DirectoryCardError';
  }
}

export const PUBLIC_TEXT_KEYS = [
  'org',
  'svc',
  'target',
  'region',
  'cost',
  'specialty',
  'languages',
  'diseases',
  'notes',
  'tags',
  'whatsapp',
  'whatsappLabel',
  'email',
  'web',
  'webLabel',
  'web2',
  'webLabel2',
  'add',
  'addLabel',
] as const;

const TEXT_MAX: Record<(typeof PUBLIC_TEXT_KEYS)[number], number> = {
  org: 300,
  svc: 500,
  target: 4000,
  region: 500,
  cost: 500,
  specialty: 2000,
  languages: 500,
  diseases: 2000,
  notes: 4000,
  tags: 2000,
  whatsapp: 40,
  whatsappLabel: 120,
  email: 200,
  web: 2000,
  webLabel: 120,
  web2: 2000,
  webLabel2: 120,
  add: 2000,
  addLabel: 120,
};

export const PHONE_SUFFIXES = ['', '2', '3', '4', '5', '6'] as const;

const PHONE_MAX = 80;
const PHONE_LABEL_MAX = 120;

const SEX_VALUES = ['any', 'female', 'male'] as const;
const LOCATION_VALUES = ['any', 'nationwide', 'regions'] as const;
const RECOGNITION_KEYS = ['btl', 'moh', 'mod', 'rehab_basket'] as const;
const RECOGNITION_VALUES = ['any', 'required'] as const;

const LIST_MAX_ITEMS = 40;
const LIST_ITEM_MAX = 120;
const NOTES_MAX = 4000;

export type PublicFields = Record<string, string | boolean>;

export type RecognitionValue = (typeof RECOGNITION_VALUES)[number];

export type Eligibility = {
  age_min: number | null;
  age_max: number | null;
  sex: (typeof SEX_VALUES)[number];
  location_mode: (typeof LOCATION_VALUES)[number];
  regions: string[];
  diagnoses: string[];
  presenting_problems: string[];
  recognition: Record<(typeof RECOGNITION_KEYS)[number], RecognitionValue>;
  internal_notes: string;
};

export function emptyEligibility(): Eligibility {
  return {
    age_min: null,
    age_max: null,
    sex: 'any',
    location_mode: 'any',
    regions: [],
    diagnoses: [],
    presenting_problems: [],
    recognition: { btl: 'any', moh: 'any', mod: 'any', rehab_basket: 'any' },
    internal_notes: '',
  };
}

function asObject(raw: unknown): Record<string, unknown> {
  if (raw && typeof raw === 'object' && !Array.isArray(raw)) return raw as Record<string, unknown>;
  return {};
}

function textField(raw: unknown): string {
  if (typeof raw === 'string') return raw.trim();
  if (typeof raw === 'number' && Number.isFinite(raw)) return String(raw);
  return '';
}

export function normalizePublicFields(raw: unknown): PublicFields {
  const src = asObject(raw);
  const out: PublicFields = {};
  for (const key of PUBLIC_TEXT_KEYS) {
    const value = textField(src[key]);
    if (value.length > TEXT_MAX[key]) {
      throw new DirectoryCardError(`השדה ${key} ארוך מדי`);
    }
    out[key] = value;
  }
  if (!out.org) throw new DirectoryCardError('שם הארגון הוא שדה חובה');
  if (out.email && !/^[^\s@]+@[^\s@]+$/.test(String(out.email))) {
    throw new DirectoryCardError('כתובת הדוא״ל אינה תקינה');
  }
  for (const suffix of PHONE_SUFFIXES) {
    const phone = textField(src[`phone${suffix}`]);
    const label = textField(src[`phoneLabel${suffix}`]);
    if (phone.length > PHONE_MAX || label.length > PHONE_LABEL_MAX) {
      throw new DirectoryCardError('מספר הטלפון או התווית ארוכים מדי');
    }
    out[`phone${suffix}`] = phone;
    out[`phoneLabel${suffix}`] = label;
    // The card shows "label: number" only when the flag is strictly true. A missing
    // flag with a label hides the number, so preserve that instead of defaulting to true.
    const flag = src[`phoneShowNumber${suffix}`];
    out[`phoneShowNumber${suffix}`] = flag === true || (flag !== false && label === '');
  }
  return out;
}

function parseAge(raw: unknown, label: string): number | null {
  if (raw == null || raw === '') return null;
  const n = typeof raw === 'number' ? raw : Number(String(raw).trim());
  if (!Number.isInteger(n) || n < 0 || n > 120) {
    throw new DirectoryCardError(`${label} חייב להיות מספר שלם בין 0 ל-120`);
  }
  return n;
}

function stringList(raw: unknown, label: string): string[] {
  let items: unknown[] = [];
  if (Array.isArray(raw)) items = raw;
  else if (typeof raw === 'string') items = raw.split(/\r?\n/);
  else if (raw == null || raw === '') items = [];
  else throw new DirectoryCardError(`${label} אינו רשימה`);
  const out: string[] = [];
  const seen = new Set<string>();
  for (const item of items) {
    const value = textField(item);
    if (!value || seen.has(value)) continue;
    if (value.length > LIST_ITEM_MAX) throw new DirectoryCardError(`פריט ב${label} ארוך מדי`);
    seen.add(value);
    out.push(value);
  }
  if (out.length > LIST_MAX_ITEMS) throw new DirectoryCardError(`${label} מכיל יותר מדי פריטים`);
  return out;
}

function oneOf<T extends string>(raw: unknown, allowed: readonly T[], label: string, fallback: T): T {
  if (raw == null || raw === '') return fallback;
  const value = textField(raw);
  if ((allowed as readonly string[]).includes(value)) return value as T;
  throw new DirectoryCardError(`${label} אינו ערך מוכר`);
}

export function normalizeEligibility(raw: unknown): Eligibility {
  const src = asObject(raw);
  const ageMin = parseAge(src.age_min, 'גיל מינימום');
  const ageMax = parseAge(src.age_max, 'גיל מקסימום');
  if (ageMin != null && ageMax != null && ageMin > ageMax) {
    throw new DirectoryCardError('גיל מינימום גבוה מגיל מקסימום');
  }
  const locationMode = oneOf(src.location_mode, LOCATION_VALUES, 'מיקום', 'any');
  const regions = locationMode === 'regions' ? stringList(src.regions, 'אזורים') : [];
  if (locationMode === 'regions' && regions.length === 0) {
    throw new DirectoryCardError('כשבוחרים אזורים, יש להזין לפחות אזור אחד');
  }
  const recognitionSrc = asObject(src.recognition);
  const recognition = {
    btl: oneOf(recognitionSrc.btl, RECOGNITION_VALUES, 'ביטוח לאומי', 'any'),
    moh: oneOf(recognitionSrc.moh, RECOGNITION_VALUES, 'משרד הבריאות', 'any'),
    mod: oneOf(recognitionSrc.mod, RECOGNITION_VALUES, 'משרד הביטחון', 'any'),
    rehab_basket: oneOf(recognitionSrc.rehab_basket, RECOGNITION_VALUES, 'סל שיקום', 'any'),
  };
  const internalNotes = textField(src.internal_notes);
  if (internalNotes.length > NOTES_MAX) throw new DirectoryCardError('ההערות הפנימיות ארוכות מדי');
  return {
    age_min: ageMin,
    age_max: ageMax,
    sex: oneOf(src.sex, SEX_VALUES, 'מין', 'any'),
    location_mode: locationMode,
    regions,
    diagnoses: stringList(src.diagnoses, 'אבחנות'),
    presenting_problems: stringList(src.presenting_problems, 'קשיים'),
    recognition,
    internal_notes: internalNotes,
  };
}

export function hasEligibility(raw: unknown): boolean {
  try {
    const e = normalizeEligibility(raw);
    if (e.age_min != null || e.age_max != null) return true;
    if (e.sex !== 'any') return true;
    if (e.location_mode !== 'any') return true;
    if (e.regions.length || e.diagnoses.length || e.presenting_problems.length) return true;
    if (Object.values(e.recognition).some((v) => v !== 'any')) return true;
    if (e.internal_notes) return true;
    return false;
  } catch {
    return true;
  }
}

function stable(value: unknown): string {
  if (Array.isArray(value)) return `[${value.map(stable).join(',')}]`;
  if (value && typeof value === 'object') {
    const src = value as Record<string, unknown>;
    return `{${Object.keys(src)
      .sort()
      .map((key) => `${JSON.stringify(key)}:${stable(src[key])}`)
      .join(',')}}`;
  }
  return JSON.stringify(value);
}

export function publicFieldsEqual(a: unknown, b: unknown): boolean {
  return stable(normalizePublicFields(a)) === stable(normalizePublicFields(b));
}

export function eligibilityEqual(a: unknown, b: unknown): boolean {
  return stable(normalizeEligibility(a)) === stable(normalizeEligibility(b));
}
