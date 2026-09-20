import { createCipheriv, createDecipheriv, randomBytes } from 'crypto';
import type { Client } from 'pg';
import type { JwtUser } from './auth';
import { sessionStillValid } from './auth';
import { hashToken } from './tokens';

export const CARE_SECTIONS = [
  'timeline',
  'documents',
  'medications',
  'contacts',
  'notes',
  'rights',
  'profile',
  'family',
  'diagnoses',
  'therapy',
  'activity',
  'intake',
  'labs',
] as const;
export type CareSection = (typeof CARE_SECTIONS)[number];

export const ENCOUNTER_KINDS = [
  'hospital',
  'home_hospital',
  'psychiatrist',
  'therapy',
  'social_work',
  'meeting',
  'committee',
  'phone',
  'email',
  'home_visit',
  'application',
  'other',
] as const;
export type EncounterKind = (typeof ENCOUNTER_KINDS)[number];

export const MAX_FILE_BYTES = 2 * 1024 * 1024;
export const MED_STATUSES = ['current', 'past', 'recommended'] as const;
export const HMO_VALUES = ['clalit', 'maccabi', 'meuhedet', 'leumit', 'other'] as const;
export const CONTACT_KINDS = ['person', 'org'] as const;
export const ORG_TYPES = [
  'rehab_provider',
  'hospital',
  'clinic',
  'hmo',
  'btl',
  'municipality',
  'ngo',
  'housing',
  'employment',
  'legal',
  'hostile_actions',
  'other',
] as const;
export const QUALIFICATIONS = [
  'social_work',
  'psychiatrist',
  'psychologist',
  'occupational_therapist',
  'nurse',
  'rehab_coordinator',
  'peer',
  'lawyer',
  'physician',
  'other',
] as const;
export const LAB_MARKERS = [
  'b12',
  'folate',
  'vitamin_d',
  'tsh',
  'ft4',
  'ferritin',
  'hemoglobin',
  'glucose',
  'hba1c',
  'lithium',
  'sodium',
  'creatinine',
  'alt',
  'ast',
  'prolactin',
  'cholesterol',
  'triglycerides',
  'crp',
  'magnesium',
  'zinc',
  'weight',
  'bp',
  'other',
] as const;
export const LAB_FLAGS = ['low', 'normal', 'high'] as const;
export const LAB_UNITS: Record<(typeof LAB_MARKERS)[number], string> = {
  b12: 'pg/mL',
  folate: 'ng/mL',
  vitamin_d: 'ng/mL',
  tsh: 'mIU/L',
  ft4: 'ng/dL',
  ferritin: 'ng/mL',
  hemoglobin: 'g/dL',
  glucose: 'mg/dL',
  hba1c: '%',
  lithium: 'mEq/L',
  sodium: 'mEq/L',
  creatinine: 'mg/dL',
  alt: 'U/L',
  ast: 'U/L',
  prolactin: 'ng/mL',
  cholesterol: 'mg/dL',
  triglycerides: 'mg/dL',
  crp: 'mg/L',
  magnesium: 'mg/dL',
  zinc: 'µg/dL',
  weight: 'kg',
  bp: 'mmHg',
  other: '',
};
export const RIGHTS_KINDS = [
  'disability_mental',
  'disability_general',
  'work_incapacity',
  'rehab_basket',
  'special_services',
  'hostile_actions',
  'income_support',
  'housing',
  'other',
] as const;
export const RIGHTS_STATUSES = [
  'not_started',
  'applied',
  'waiting_committee',
  'committee_held',
  'approved',
  'rejected',
  'appeal_planned',
  'appeal_filed',
  'temporary',
  'closed',
] as const;
export const COMMITTEE_BODIES = [
  'btl',
  'disability_general',
  'hostile_actions',
  'rehab',
  'special_services',
  'other',
] as const;
export const COMMITTEE_STATUSES = ['upcoming', 'held', 'cancelled'] as const;
export const DIAGNOSIS_STATUSES = ['active', 'historical'] as const;
export const ACTIVITY_KINDS = ['sport', 'walking', 'gym', 'yoga', 'other'] as const;

export function isOneOf<T extends string>(v: unknown, allowed: readonly T[]): v is T {
  return typeof v === 'string' && (allowed as readonly string[]).includes(v);
}

export type CareActor = {
  fileId: string;
  ownerId: string;
  ownerEmail: string;
  actorUserId: string | null;
  actorKind: 'owner' | 'grantee' | 'share_link';
  grantId: string | null;
  linkId: string | null;
  sections: CareSection[];
  canWrite: boolean;
};

export function isSection(v: unknown): v is CareSection {
  return typeof v === 'string' && (CARE_SECTIONS as readonly string[]).includes(v);
}

export function isEncounterKind(v: unknown): v is EncounterKind {
  return typeof v === 'string' && (ENCOUNTER_KINDS as readonly string[]).includes(v);
}

export function parseSections(raw: unknown): CareSection[] | null {
  if (!Array.isArray(raw) || !raw.length) return null;
  const out: CareSection[] = [];
  const seen = new Set<string>();
  for (const item of raw) {
    if (!isSection(item) || seen.has(item)) continue;
    seen.add(item);
    out.push(item);
  }
  return out.length ? out : null;
}

export function isUuid(v: unknown): v is string {
  return typeof v === 'string' && /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(v);
}

function fileKey(): Buffer {
  const raw = process.env.FILE_ENCRYPTION_KEY || '';
  if (/^[0-9a-fA-F]{64}$/.test(raw)) return Buffer.from(raw, 'hex');
  try {
    const b64 = Buffer.from(raw, 'base64');
    if (b64.length === 32) return b64;
  } catch {
    /* ignore */
  }
  throw new Error('FILE_ENCRYPTION_KEY must be 32 bytes (64 hex characters)');
}

export function fileEncryptionConfigured(): boolean {
  try {
    fileKey();
    return true;
  } catch {
    return false;
  }
}

export function encryptFile(plain: Buffer): { ciphertext: Buffer; nonce: Buffer } {
  const nonce = randomBytes(12);
  const cipher = createCipheriv('aes-256-gcm', fileKey(), nonce);
  const enc = Buffer.concat([cipher.update(plain), cipher.final()]);
  const tag = cipher.getAuthTag();
  return { ciphertext: Buffer.concat([enc, tag]), nonce };
}

export function decryptFile(ciphertext: Buffer, nonce: Buffer): Buffer {
  if (ciphertext.length < 17) throw new Error('ciphertext too short');
  const tag = ciphertext.subarray(ciphertext.length - 16);
  const data = ciphertext.subarray(0, ciphertext.length - 16);
  const decipher = createDecipheriv('aes-256-gcm', fileKey(), nonce);
  decipher.setAuthTag(tag);
  return Buffer.concat([decipher.update(data), decipher.final()]);
}

export function sniffAllowedFile(buf: Buffer): { contentType: string } | null {
  if (buf.length >= 5 && buf.subarray(0, 5).toString('ascii') === '%PDF-') {
    return { contentType: 'application/pdf' };
  }
  if (buf.length >= 3 && buf[0] === 0xff && buf[1] === 0xd8 && buf[2] === 0xff) {
    return { contentType: 'image/jpeg' };
  }
  if (
    buf.length >= 8 &&
    buf[0] === 0x89 &&
    buf[1] === 0x50 &&
    buf[2] === 0x4e &&
    buf[3] === 0x47 &&
    buf[4] === 0x0d &&
    buf[5] === 0x0a &&
    buf[6] === 0x1a &&
    buf[7] === 0x0a
  ) {
    return { contentType: 'image/png' };
  }
  if (
    buf.length >= 12 &&
    buf.subarray(0, 4).toString('ascii') === 'RIFF' &&
    buf.subarray(8, 12).toString('ascii') === 'WEBP'
  ) {
    return { contentType: 'image/webp' };
  }
  return null;
}

export function sanitizeFilename(raw: unknown): string | null {
  if (typeof raw !== 'string') return null;
  const base = raw.replace(/\\/g, '/').split('/').pop() || '';
  const cleaned = base.replace(/[^\w.\u0590-\u05FF \-()[\]]+/g, '_').trim();
  if (!cleaned || cleaned === '.' || cleaned === '..') return null;
  return cleaned.slice(0, 200);
}

export async function writeAudit(
  client: Client,
  actor: Pick<CareActor, 'fileId' | 'actorUserId' | 'actorKind'>,
  action: string,
  section: CareSection | null,
  itemId: string | null
): Promise<void> {
  await client.query(
    `INSERT INTO care_audit_events (file_id, actor_user_id, actor_kind, action, section, item_id)
     VALUES ($1,$2,$3,$4,$5,$6)`,
    [actor.fileId, actor.actorUserId, actor.actorKind, action, section, itemId]
  );
}

export async function ensureOwnFile(client: Client, ownerId: string): Promise<{ id: string; ownerId: string }> {
  const existing = await client.query(`SELECT id::text FROM care_files WHERE owner_id = $1`, [ownerId]);
  if (existing.rows[0]) return { id: existing.rows[0].id, ownerId };
  const inserted = await client.query(
    `INSERT INTO care_files (owner_id) VALUES ($1) RETURNING id::text`,
    [ownerId]
  );
  return { id: inserted.rows[0].id, ownerId };
}

const GRANT_ACTIVE_SQL = `
  status = 'active'
  AND revoked_at IS NULL
  AND (kind = 'proxy' OR expires_at > now())
`;

export async function resolveFileAccess(
  client: Client,
  opts: { jwtUser: JwtUser; fileId: string }
): Promise<CareActor | null> {
  const { rows } = await client.query(
    `SELECT f.id::text AS file_id, f.owner_id::text, u.email AS owner_email
       FROM care_files f
       JOIN users u ON u.id = f.owner_id
      WHERE f.id = $1`,
    [opts.fileId]
  );
  const file = rows[0];
  if (!file) return null;

  if (file.owner_id === opts.jwtUser.id) {
    return {
      fileId: file.file_id,
      ownerId: file.owner_id,
      ownerEmail: file.owner_email,
      actorUserId: opts.jwtUser.id,
      actorKind: 'owner',
      grantId: null,
      linkId: null,
      sections: [...CARE_SECTIONS],
      canWrite: true,
    };
  }

  const grant = await client.query(
    `SELECT id::text, can_write, sections
       FROM care_grants
      WHERE file_id = $1
        AND grantee_email = $2
        AND ${GRANT_ACTIVE_SQL}
      ORDER BY created_at DESC
      LIMIT 1`,
    [opts.fileId, opts.jwtUser.email]
  );
  const g = grant.rows[0];
  if (!g) return null;
  const sections = parseSections(g.sections);
  if (!sections) return null;
  return {
    fileId: file.file_id,
    ownerId: file.owner_id,
    ownerEmail: file.owner_email,
    actorUserId: opts.jwtUser.id,
    actorKind: 'grantee',
    grantId: g.id,
    linkId: null,
    sections,
    canWrite: Boolean(g.can_write),
  };
}

export async function resolveShareAccess(client: Client, rawToken: string): Promise<CareActor | null> {
  const hash = hashToken(rawToken);
  const { rows } = await client.query(
    `SELECT l.id::text, l.file_id::text, l.sections, f.owner_id::text, u.email AS owner_email
       FROM care_share_links l
       JOIN care_files f ON f.id = l.file_id
       JOIN users u ON u.id = f.owner_id
      WHERE l.token_hash = $1
        AND l.revoked_at IS NULL
        AND l.expires_at > now()
      LIMIT 1`,
    [hash]
  );
  const row = rows[0];
  if (!row) return null;
  const sections = parseSections(row.sections);
  if (!sections) return null;
  await client.query(`UPDATE care_share_links SET last_viewed_at = now() WHERE id = $1`, [row.id]);
  return {
    fileId: row.file_id,
    ownerId: row.owner_id,
    ownerEmail: row.owner_email,
    actorUserId: null,
    actorKind: 'share_link',
    grantId: null,
    linkId: row.id,
    sections,
    canWrite: false,
  };
}

export function canReadSection(actor: CareActor, section: CareSection): boolean {
  return actor.sections.includes(section);
}

export function canAddToSection(actor: CareActor, section: CareSection): boolean {
  return actor.canWrite && actor.sections.includes(section);
}

export function canMutateRow(actor: CareActor, createdBy: string | null): boolean {
  if (actor.actorKind === 'owner') return true;
  if (!actor.canWrite || !actor.actorUserId) return false;
  return createdBy === actor.actorUserId;
}

export async function assertAuthedSession(client: Client, jwtUser: JwtUser): Promise<boolean> {
  return sessionStillValid(client, jwtUser);
}

export function isoDate(v: unknown): string | null {
  if (v == null) return null;
  if (typeof v === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(v)) return v;
  const d = v instanceof Date ? v : new Date(String(v));
  if (Number.isNaN(d.getTime())) return null;
  return d.toISOString().slice(0, 10);
}

export function isoTs(v: unknown): string | null {
  if (v == null) return null;
  const d = v instanceof Date ? v : new Date(String(v));
  return Number.isNaN(d.getTime()) ? null : d.toISOString();
}

export function clip(s: string, max: number): string {
  return s.slice(0, max);
}

export function asBuffer(v: unknown): Buffer | null {
  if (Buffer.isBuffer(v)) return v;
  if (v instanceof Uint8Array) return Buffer.from(v);
  if (typeof v === 'string') return Buffer.from(v, 'base64');
  return null;
}
