/**
 * Completeness checks for one card, from its published fields, sites and eligibility.
 * Used by /api/admin/verification and by scripts/card_review.js (Node strips the types).
 * Keep this file to erasable TypeScript only (no enums, namespaces or parameter properties).
 */

export type CardGap = {
  code: string;
  label: string;
  detail?: string;
};

export type CardCompleteness = {
  score: number;
  checks: number;
  gaps: CardGap[];
};

type Fields = Record<string, unknown>;

const PHONE_SUFFIXES = ['', '2', '3', '4', '5', '6'];

// "מצדה 7, בני ברק" or "רחוב הרקפת 6 שדרות": a street word, a house number, then a place name.
const ADDRESS_RE = /(?:^|[\s,(])(?:רח(?:וב|')?\s+|שד(?:רות|')\s+|דרך\s+)?[\u05d0-\u05ea"'׳״-]{2,}(?:\s[\u05d0-\u05ea"'׳״-]{2,}){0,2}\s\d{1,4}[\u05d0-\u05ea]?\s*,?\s*[\u05d0-\u05ea]{2,}(?:[\s-][\u05d0-\u05ea]{2,})?/;
const BRANCHES_RE = /סניפים|שלוחות|מוקדים|\d+\s*(?:מרפאות|מרכזים|סניפים)|בכל רחבי הארץ/;
const ROW_REF_RE = /שורה\s*\d+/;

function text(fields: Fields, key: string): string {
  const v = fields[key];
  return v == null ? '' : String(v).trim();
}

function eligibilityIsAny(elig: unknown): boolean {
  if (!elig || typeof elig !== 'object') return true;
  const e = elig as Record<string, unknown>;
  const rec = (e.recognition && typeof e.recognition === 'object' ? e.recognition : {}) as Record<string, unknown>;
  const listEmpty = (k: string) => !Array.isArray(e[k]) || (e[k] as unknown[]).length === 0;
  return (
    e.age_min == null &&
    e.age_max == null &&
    (e.sex == null || e.sex === 'any') &&
    (e.location_mode == null || e.location_mode === 'any') &&
    listEmpty('regions') &&
    listEmpty('diagnoses') &&
    listEmpty('presenting_problems') &&
    Object.values(rec).every((v) => v == null || v === 'any')
  );
}

export function cardCompleteness(fieldsRaw: unknown, sitesRaw: unknown, eligibility: unknown): CardCompleteness {
  const fields = (fieldsRaw && typeof fieldsRaw === 'object' ? fieldsRaw : {}) as Fields;
  const sites = Array.isArray(sitesRaw) ? sitesRaw : [];
  const gaps: CardGap[] = [];
  let checks = 0;
  const check = (ok: boolean, gap: CardGap) => {
    checks++;
    if (!ok) gaps.push(gap);
  };

  const prose = ['svc', 'region', 'notes', 'target'].map((k) => text(fields, k)).join('\n');

  const phones = PHONE_SUFFIXES.filter((s) => text(fields, `phone${s}`));
  const hasContact =
    phones.length > 0 || Boolean(text(fields, 'email') || text(fields, 'whatsapp') || text(fields, 'web'));
  check(hasContact, { code: 'no_contact', label: 'אין טלפון, דוא״ל, וואטסאפ או אתר' });

  if (phones.length > 1) {
    const unlabeled = phones.filter((s) => !text(fields, `phoneLabel${s}`)).length;
    check(unlabeled === 0, {
      code: 'phones_unlabeled',
      label: 'כמה מספרי טלפון בלי תווית',
      detail: `${unlabeled} מתוך ${phones.length}`,
    });
  }

  const address = ADDRESS_RE.exec(prose);
  if (address || sites.length) {
    check(sites.length > 0, {
      code: 'address_no_site',
      label: 'כתובת בטקסט אבל אין מיקום במפה',
      detail: address ? address[0].trim() : undefined,
    });
  }

  if (BRANCHES_RE.test(prose)) {
    check(sites.length > 1, {
      code: 'branches_few_sites',
      label: 'הטקסט מתאר כמה סניפים, אבל במפה יש פחות משניים',
      detail: `${sites.length} מיקומים`,
    });
  }

  check(!ROW_REF_RE.test(text(fields, 'notes')), {
    code: 'row_ref_text',
    label: 'הפניה בנוסח «שורה N» במקום קישור לכרטיס',
  });

  check(Boolean(text(fields, 'target')), { code: 'empty_target', label: 'אין «למי»' });
  check(Boolean(text(fields, 'region')), { code: 'empty_region', label: 'אין «אזור»' });
  check(Boolean(text(fields, 'cost')), { code: 'empty_cost', label: 'אין «עלות»' });
  check(!eligibilityIsAny(eligibility), { code: 'eligibility_any', label: 'אין תנאי התאמה (הכול «ללא הגבלה»)' });

  const score = checks ? Math.round(((checks - gaps.length) / checks) * 100) : 100;
  return { score, checks, gaps };
}
