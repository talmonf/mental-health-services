/**
 * One Serverless Function for all /api/care/* routes.
 * Hobby deployments allow 12 functions; keep new endpoints in an existing [action] file.
 */
import { randomUUID } from 'crypto';
import type { VercelRequest, VercelResponse } from '@vercel/node';
import type { Client } from 'pg';
import {
  clientKey,
  getAuthFromRequest,
  getCareStepupFromRequest,
  normalizeEmail,
  originAllowed,
  parseJsonBody,
  rateLimit,
  setAuthCors,
  setCareStepupCookie,
  signCareStepup,
  type JwtUser,
} from '../../lib/auth';
import {
  ACTIVITY_KINDS,
  asBuffer,
  assertAuthedSession,
  canAddToSection,
  canMutateRow,
  canReadSection,
  CARE_SECTIONS,
  clip,
  COMMITTEE_BODIES,
  COMMITTEE_STATUSES,
  CONTACT_KINDS,
  decryptFile,
  DIAGNOSIS_STATUSES,
  encryptFile,
  ensureOwnFile,
  fileEncryptionConfigured,
  HMO_VALUES,
  isEncounterKind,
  isOneOf,
  isUuid,
  isoDate,
  isoTs,
  LAB_FLAGS,
  LAB_MARKERS,
  MAX_FILE_BYTES,
  MED_STATUSES,
  ORG_TYPES,
  parseSections,
  QUALIFICATIONS,
  resolveFileAccess,
  resolveShareAccess,
  RIGHTS_KINDS,
  RIGHTS_STATUSES,
  sanitizeFilename,
  sniffAllowedFile,
  writeAudit,
  type CareActor,
  type CareSection,
} from '../../lib/care';
import { appUrl, pgClient } from '../../lib/db';
import { careObjectKey, deleteCiphertext, getCiphertext, putCiphertext, s3Configured } from '../../lib/s3';
import {
  enqueueCareGrantAccepted,
  enqueueCareGrantInvite,
  enqueueCareGrantRevoked,
  enqueueCareOtpEmail,
  processOutbox,
} from '../../lib/email';
import { consumeOtpCode, insertOtpCode, newOtpCode, newRawToken, hashToken } from '../../lib/tokens';
import { publicUserFromRow, USER_PUBLIC_COLUMNS } from '../../lib/users';

function actionName(req: VercelRequest): string {
  const raw = req.query.action;
  return typeof raw === 'string' ? raw : Array.isArray(raw) ? raw[0] || '' : '';
}

function q(req: VercelRequest, key: string): string {
  const raw = req.query[key];
  return typeof raw === 'string' ? raw : Array.isArray(raw) ? raw[0] || '' : '';
}

function jsonError(res: VercelResponse, status: number, error: string) {
  return res.status(status).json({ error });
}

async function loadUser(client: Client, jwtUser: JwtUser) {
  const { rows } = await client.query(`SELECT ${USER_PUBLIC_COLUMNS} FROM users WHERE id = $1`, [jwtUser.id]);
  if (!rows[0]) return null;
  return publicUserFromRow(rows[0]);
}

async function requireUser(
  req: VercelRequest,
  res: VercelResponse,
  client: Client
): Promise<JwtUser | null> {
  const jwtUser = await getAuthFromRequest(req);
  if (!jwtUser) {
    jsonError(res, 401, 'Unauthorized');
    return null;
  }
  if (!(await assertAuthedSession(client, jwtUser))) {
    jsonError(res, 401, 'Unauthorized');
    return null;
  }
  return jwtUser;
}

async function requireStepup(
  req: VercelRequest,
  res: VercelResponse,
  jwtUser: JwtUser
): Promise<boolean> {
  const step = await getCareStepupFromRequest(req);
  if (!step || step.id !== jwtUser.id) {
    jsonError(res, 403, 'Care verification required');
    return false;
  }
  return true;
}

function fileIdFrom(req: VercelRequest, body: Record<string, unknown> | null): string | null {
  const fromQ = q(req, 'fileId');
  const fromB = body && typeof body.fileId === 'string' ? body.fileId : '';
  const id = fromQ || fromB;
  return isUuid(id) ? id : null;
}

async function requireActor(
  req: VercelRequest,
  res: VercelResponse,
  client: Client,
  jwtUser: JwtUser,
  body: Record<string, unknown> | null,
  section: CareSection | null,
  write: boolean
): Promise<CareActor | null> {
  const fileId = fileIdFrom(req, body);
  if (!fileId) {
    jsonError(res, 400, 'fileId is required');
    return null;
  }
  const actor = await resolveFileAccess(client, { jwtUser, fileId });
  if (!actor) {
    jsonError(res, 403, 'Forbidden');
    return null;
  }
  if (section && !canReadSection(actor, section)) {
    jsonError(res, 403, 'Forbidden');
    return null;
  }
  if (write && section && !canAddToSection(actor, section)) {
    jsonError(res, 403, 'Forbidden');
    return null;
  }
  return actor;
}

function itemIdFrom(req: VercelRequest, body: Record<string, unknown> | null): string | null {
  const fromQ = q(req, 'id');
  const fromB = body && typeof body.id === 'string' ? body.id : '';
  const id = fromQ || fromB;
  return isUuid(id) ? id : null;
}

function strField(body: Record<string, unknown>, key: string, max: number, required: boolean): string | null {
  const v = body[key];
  if (v == null) return required ? null : '';
  if (typeof v !== 'string') return null;
  const t = v.trim();
  if (required && !t) return null;
  return clip(t, max);
}

async function handleBootstrap(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  if (req.method !== 'GET') return jsonError(res, 405, 'Method not allowed');
  const user = await loadUser(client, jwtUser);
  if (!user) return jsonError(res, 401, 'Unauthorized');
  const step = await getCareStepupFromRequest(req);
  const careReady = Boolean(step && step.id === jwtUser.id);
  if (!user.emailVerified) {
    return res.status(200).json({ user, emailVerified: false, careReady: false, file: null, inboxCount: 0 });
  }
  if (!careReady) {
    return res.status(200).json({ user, emailVerified: true, careReady: false, file: null, inboxCount: 0 });
  }
  const file = await ensureOwnFile(client, jwtUser.id);
  const inbox = await client.query(
    `SELECT count(*)::int AS n
       FROM care_grants
      WHERE grantee_email = $1
        AND status = 'pending'
        AND revoked_at IS NULL`,
    [jwtUser.email]
  );
  return res.status(200).json({
    user,
    emailVerified: true,
    careReady: true,
    file: { id: file.id, role: 'owner', sections: [...CARE_SECTIONS] },
    inboxCount: inbox.rows[0]?.n || 0,
  });
}

async function handleOtpRequest(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  if (req.method !== 'POST') return jsonError(res, 405, 'Method not allowed');
  if (!originAllowed(req)) return jsonError(res, 403, 'Forbidden');
  if (!rateLimit(`care-otp:${jwtUser.id}`, 5, 60 * 60 * 1000)) {
    return jsonError(res, 429, 'Too many attempts');
  }
  const user = await loadUser(client, jwtUser);
  if (!user) return jsonError(res, 401, 'Unauthorized');
  if (!user.emailVerified) return jsonError(res, 403, 'Email not verified');
  const code = newOtpCode();
  await insertOtpCode(client, jwtUser.id, 'care_otp', code);
  await enqueueCareOtpEmail(client, { id: user.id, email: user.email }, code);
  const send = await processOutbox(client, 10, { userId: user.id, kind: 'care_otp' });
  if (!send.sent) return jsonError(res, 503, 'Email could not be sent');
  return res.status(200).json({ ok: true });
}

async function handleOtpVerify(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  if (req.method !== 'POST') return jsonError(res, 405, 'Method not allowed');
  if (!originAllowed(req)) return jsonError(res, 403, 'Forbidden');
  if (!rateLimit(`care-otp-verify:${jwtUser.id}`, 10, 15 * 60 * 1000)) {
    return jsonError(res, 429, 'Too many attempts');
  }
  const body = parseJsonBody(req);
  if (!body) return jsonError(res, 400, 'Invalid JSON');
  const code = typeof body.code === 'string' ? body.code.replace(/\s/g, '') : '';
  if (!/^\d{6}$/.test(code)) return jsonError(res, 400, 'Invalid code');
  const ok = await consumeOtpCode(client, jwtUser.id, 'care_otp', code);
  if (!ok) return jsonError(res, 401, 'Invalid code');
  const token = await signCareStepup(jwtUser.id);
  setCareStepupCookie(res, token);
  return res.status(200).json({ ok: true });
}

const ENCOUNTER_SELECT = `
  e.id::text, e.kind, e.occurred_on, e.title, e.summary,
  e.contact_id::text, e.org_id::text,
  e.created_by_user_id::text, e.created_at, e.updated_at,
  c.name AS contact_name, o.name AS org_name
`;

function mapEncounter(row: Record<string, unknown>) {
  return {
    id: String(row.id),
    kind: row.kind,
    occurredOn: isoDate(row.occurred_on),
    title: row.title,
    summary: row.summary || '',
    contactId: row.contact_id ? String(row.contact_id) : null,
    orgId: row.org_id ? String(row.org_id) : null,
    contactName: row.contact_name || '',
    orgName: row.org_name || '',
    createdByUserId: row.created_by_user_id ? String(row.created_by_user_id) : null,
    createdAt: isoTs(row.created_at),
    updatedAt: isoTs(row.updated_at),
    mine: false,
  };
}

async function contactInFile(
  client: Client,
  fileId: string,
  id: string | null,
  kind?: 'person' | 'org'
): Promise<boolean> {
  if (!id) return true;
  const { rows } = await client.query(
    `SELECT kind FROM care_contacts WHERE id = $1 AND file_id = $2`,
    [id, fileId]
  );
  if (!rows[0]) return false;
  return kind ? rows[0].kind === kind : true;
}

async function handleEncounters(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  const body = req.method === 'GET' ? {} : parseJsonBody(req);
  if (req.method !== 'GET' && !body) return jsonError(res, 400, 'Invalid JSON');
  const write = req.method !== 'GET';
  const actor = await requireActor(req, res, client, jwtUser, body, 'timeline', write && req.method === 'POST');
  if (!actor) return null;

  if (req.method === 'GET') {
    const { rows } = await client.query(
      `SELECT ${ENCOUNTER_SELECT}
         FROM care_encounters e
         LEFT JOIN care_contacts c ON c.id = e.contact_id
         LEFT JOIN care_contacts o ON o.id = e.org_id
        WHERE e.file_id = $1
        ORDER BY e.occurred_on DESC, e.created_at DESC`,
      [actor.fileId]
    );
    await writeAudit(client, actor, 'view', 'timeline', null);
    return res.status(200).json({
      items: rows.map((r) => ({ ...mapEncounter(r), mine: r.created_by_user_id === jwtUser.id || actor.actorKind === 'owner' })),
    });
  }

  if (req.method === 'POST') {
    if (!canAddToSection(actor, 'timeline')) return jsonError(res, 403, 'Forbidden');
    const kind = isEncounterKind(body!.kind) ? body!.kind : null;
    const occurredOn = isoDate(body!.occurredOn);
    const title = strField(body!, 'title', 200, true);
    const summary = strField(body!, 'summary', 4000, false);
    const contactId = isUuid(body!.contactId) ? body!.contactId : null;
    const orgId = isUuid(body!.orgId) ? body!.orgId : null;
    if (!kind || !occurredOn || title == null) return jsonError(res, 400, 'Invalid encounter');
    if (!(await contactInFile(client, actor.fileId, contactId, 'person'))) return jsonError(res, 400, 'Invalid contact');
    if (!(await contactInFile(client, actor.fileId, orgId, 'org'))) return jsonError(res, 400, 'Invalid contact');
    const { rows } = await client.query(
      `INSERT INTO care_encounters (file_id, created_by_user_id, kind, occurred_on, title, summary, contact_id, org_id)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8)
       RETURNING id::text, kind, occurred_on, title, summary, contact_id::text, org_id::text,
                 created_by_user_id::text, created_at, updated_at`,
      [actor.fileId, jwtUser.id, kind, occurredOn, title, summary || '', contactId, orgId]
    );
    await writeAudit(client, actor, 'create', 'timeline', rows[0].id);
    return res.status(201).json({ item: { ...mapEncounter(rows[0]), mine: true } });
  }

  const id = itemIdFrom(req, body);
  if (!id) return jsonError(res, 400, 'id is required');
  const existing = await client.query(
    `SELECT id::text, created_by_user_id::text FROM care_encounters WHERE id = $1 AND file_id = $2`,
    [id, actor.fileId]
  );
  if (!existing.rows[0]) return jsonError(res, 404, 'Not found');
  if (!canMutateRow(actor, existing.rows[0].created_by_user_id)) return jsonError(res, 403, 'Forbidden');

  if (req.method === 'DELETE') {
    await client.query(`DELETE FROM care_encounters WHERE id = $1`, [id]);
    await writeAudit(client, actor, 'delete', 'timeline', id);
    return res.status(200).json({ ok: true });
  }

  if (req.method === 'PATCH') {
    const kind = isEncounterKind(body!.kind) ? body!.kind : null;
    const occurredOn = body!.occurredOn != null ? isoDate(body!.occurredOn) : null;
    const title = typeof body!.title === 'string' ? clip(body!.title.trim(), 200) : null;
    const summary = typeof body!.summary === 'string' ? clip(body!.summary.trim(), 4000) : null;
    const contactId = body!.contactId === null || body!.contactId === '' ? null : isUuid(body!.contactId) ? body!.contactId : undefined;
    const orgId = body!.orgId === null || body!.orgId === '' ? null : isUuid(body!.orgId) ? body!.orgId : undefined;
    if (contactId && !(await contactInFile(client, actor.fileId, contactId, 'person'))) {
      return jsonError(res, 400, 'Invalid contact');
    }
    if (orgId && !(await contactInFile(client, actor.fileId, orgId, 'org'))) {
      return jsonError(res, 400, 'Invalid contact');
    }
    const { rows } = await client.query(
      `UPDATE care_encounters SET
         kind = COALESCE($3, kind),
         occurred_on = COALESCE($4::date, occurred_on),
         title = COALESCE(NULLIF($5, ''), title),
         summary = COALESCE($6, summary),
         contact_id = CASE WHEN $7::text = '__omit' THEN contact_id ELSE $7::uuid END,
         org_id = CASE WHEN $8::text = '__omit' THEN org_id ELSE $8::uuid END,
         updated_at = now()
       WHERE id = $1 AND file_id = $2
       RETURNING id::text, kind, occurred_on, title, summary, contact_id::text, org_id::text,
                 created_by_user_id::text, created_at, updated_at`,
      [
        id,
        actor.fileId,
        kind,
        occurredOn,
        title,
        summary,
        contactId === undefined ? '__omit' : contactId,
        orgId === undefined ? '__omit' : orgId,
      ]
    );
    await writeAudit(client, actor, 'update', 'timeline', id);
    return res.status(200).json({ item: { ...mapEncounter(rows[0]), mine: true } });
  }

  return jsonError(res, 405, 'Method not allowed');
}

function mapDocument(row: Record<string, unknown>, jwtUserId: string, isOwner: boolean) {
  return {
    id: String(row.id),
    originalFilename: row.original_filename,
    contentType: row.content_type,
    byteSize: Number(row.byte_size),
    encounterId: row.encounter_id ? String(row.encounter_id) : null,
    labPanelId: row.lab_panel_id ? String(row.lab_panel_id) : null,
    kind: row.kind === 'lab' ? 'lab' : 'other',
    createdByUserId: row.created_by_user_id ? String(row.created_by_user_id) : null,
    createdAt: isoTs(row.created_at),
    mine: isOwner || row.created_by_user_id === jwtUserId,
  };
}

function docKindFrom(req: VercelRequest, body: Record<string, unknown> | null): 'lab' | 'other' {
  const qk = q(req, 'kind');
  const bk = body && typeof body.kind === 'string' ? body.kind : '';
  return qk === 'lab' || bk === 'lab' ? 'lab' : 'other';
}

async function storedCiphertext(row: Record<string, unknown>): Promise<Buffer | null> {
  const key = typeof row.storage_key === 'string' ? row.storage_key.trim() : '';
  if (key) return getCiphertext(key);
  return asBuffer(row.ciphertext);
}

async function removeStoredObjects(keys: string[]): Promise<void> {
  for (const key of keys) {
    if (!key) continue;
    try {
      await deleteCiphertext(key);
    } catch (err) {
      console.error('care s3 delete failed', err);
    }
  }
}

async function handleDocuments(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  const body = req.method === 'GET' || req.method === 'DELETE' ? parseJsonBody(req) || {} : parseJsonBody(req);
  if (req.method !== 'GET' && req.method !== 'DELETE' && !body) return jsonError(res, 400, 'Invalid JSON');

  if (req.method === 'DELETE') {
    const id = itemIdFrom(req, body);
    const fileId = fileIdFrom(req, body);
    if (!id || !fileId) return jsonError(res, 400, 'id is required');
    const existing = await client.query(
      `SELECT created_by_user_id::text, kind, storage_key FROM care_documents WHERE id = $1 AND file_id = $2`,
      [id, fileId]
    );
    if (!existing.rows[0]) return jsonError(res, 404, 'Not found');
    const delSection: CareSection = existing.rows[0].kind === 'lab' ? 'labs' : 'documents';
    const actor = await requireActor(req, res, client, jwtUser, body, delSection, false);
    if (!actor) return null;
    if (!canMutateRow(actor, existing.rows[0].created_by_user_id)) return jsonError(res, 403, 'Forbidden');
    await client.query(`DELETE FROM care_documents WHERE id = $1`, [id]);
    const storageKey = typeof existing.rows[0].storage_key === 'string' ? existing.rows[0].storage_key : '';
    if (storageKey) await removeStoredObjects([storageKey]);
    await writeAudit(client, actor, 'delete', delSection, id);
    return res.status(200).json({ ok: true });
  }

  const kind = docKindFrom(req, body);
  const section: CareSection = kind === 'lab' ? 'labs' : 'documents';
  const write = req.method === 'POST';
  const actor = await requireActor(req, res, client, jwtUser, body, section, write);
  if (!actor) return null;

  if (req.method === 'GET') {
    const { rows } = await client.query(
      `SELECT id::text, original_filename, content_type, byte_size, encounter_id::text, lab_panel_id::text,
              kind, created_by_user_id::text, created_at
         FROM care_documents WHERE file_id = $1 AND kind = $2 ORDER BY created_at DESC`,
      [actor.fileId, kind]
    );
    await writeAudit(client, actor, 'view', section, null);
    return res.status(200).json({
      items: rows.map((r) => mapDocument(r, jwtUser.id, actor.actorKind === 'owner')),
    });
  }

  if (req.method === 'POST') {
    if (!fileEncryptionConfigured() || !s3Configured()) return jsonError(res, 500, 'Server misconfiguration');
    if (!canAddToSection(actor, section)) return jsonError(res, 403, 'Forbidden');
    if (!rateLimit(`care-upload:${jwtUser.id}`, 30, 60 * 60 * 1000)) {
      return jsonError(res, 429, 'Too many attempts');
    }
    const filename = sanitizeFilename(body!.filename);
    const b64 = typeof body!.dataBase64 === 'string' ? body!.dataBase64.replace(/\s/g, '') : '';
    if (!filename || !b64) return jsonError(res, 400, 'Invalid document');
    let buf: Buffer;
    try {
      buf = Buffer.from(b64, 'base64');
    } catch {
      return jsonError(res, 400, 'Invalid document');
    }
    if (!buf.length || buf.length > MAX_FILE_BYTES) return jsonError(res, 400, 'File too large');
    const sniffed = sniffAllowedFile(buf);
    if (!sniffed) return jsonError(res, 400, 'File type not allowed');
    const encounterId = isUuid(body!.encounterId) ? body!.encounterId : null;
    const labPanelId = isUuid(body!.labPanelId) ? body!.labPanelId : null;
    if (encounterId) {
      const enc = await client.query(`SELECT 1 FROM care_encounters WHERE id = $1 AND file_id = $2`, [
        encounterId,
        actor.fileId,
      ]);
      if (!enc.rows[0]) return jsonError(res, 400, 'Invalid encounter');
    }
    if (labPanelId) {
      const pan = await client.query(`SELECT 1 FROM care_lab_panels WHERE id = $1 AND file_id = $2`, [
        labPanelId,
        actor.fileId,
      ]);
      if (!pan.rows[0]) return jsonError(res, 400, 'Invalid item');
    }
    const id = randomUUID();
    const storageKey = careObjectKey(actor.fileId, id);
    const { ciphertext, nonce } = encryptFile(buf);
    await putCiphertext(storageKey, ciphertext);
    let rows: Record<string, unknown>[];
    try {
      ({ rows } = await client.query(
        `INSERT INTO care_documents
           (id, file_id, created_by_user_id, encounter_id, lab_panel_id, kind, original_filename, content_type, byte_size, ciphertext, nonce, storage_key)
         VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,NULL,$10,$11)
         RETURNING id::text, original_filename, content_type, byte_size, encounter_id::text, lab_panel_id::text,
                   kind, created_by_user_id::text, created_at`,
        [
          id,
          actor.fileId,
          jwtUser.id,
          encounterId,
          labPanelId,
          kind,
          filename,
          sniffed.contentType,
          buf.length,
          nonce,
          storageKey,
        ]
      ));
    } catch (err) {
      try {
        await deleteCiphertext(storageKey);
      } catch (cleanupErr) {
        console.error('care s3 cleanup failed', cleanupErr);
      }
      throw err;
    }
    if (!rows[0]) throw new Error('insert failed');
    await writeAudit(client, actor, 'create', section, String(rows[0].id));
    return res.status(201).json({ item: mapDocument(rows[0], jwtUser.id, true) });
  }

  return jsonError(res, 405, 'Method not allowed');
}

async function handleDocumentDownload(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  if (req.method !== 'GET') return jsonError(res, 405, 'Method not allowed');
  const id = itemIdFrom(req, {});
  if (!id) return jsonError(res, 400, 'id is required');
  const fileId = fileIdFrom(req, {});
  if (!fileId) return jsonError(res, 400, 'fileId is required');
  if (!fileEncryptionConfigured()) return jsonError(res, 500, 'Server misconfiguration');
  const meta = await client.query(
    `SELECT kind FROM care_documents WHERE id = $1 AND file_id = $2`,
    [id, fileId]
  );
  const section: CareSection = meta.rows[0]?.kind === 'lab' ? 'labs' : 'documents';
  const actor = await requireActor(req, res, client, jwtUser, {}, section, false);
  if (!actor) return null;
  const { rows } = await client.query(
    `SELECT original_filename, content_type, ciphertext, nonce, storage_key
       FROM care_documents WHERE id = $1 AND file_id = $2`,
    [id, actor.fileId]
  );
  if (!rows[0]) return jsonError(res, 404, 'Not found');
  const ciphertext = await storedCiphertext(rows[0]);
  const nonce = asBuffer(rows[0].nonce);
  if (!ciphertext || !nonce) return jsonError(res, 500, 'Failed');
  const plain = decryptFile(ciphertext, nonce);
  await writeAudit(client, actor, 'download', section, id);
  return res.status(200).json({
    filename: rows[0].original_filename,
    contentType: rows[0].content_type,
    dataBase64: plain.toString('base64'),
  });
}

function mapMedication(row: Record<string, unknown>, jwtUserId: string, isOwner: boolean) {
  const status = isOneOf(row.status, MED_STATUSES) ? row.status : row.ended_on ? 'past' : 'current';
  return {
    id: String(row.id),
    name: row.name,
    dose: row.dose || '',
    schedule: row.schedule || '',
    startedOn: isoDate(row.started_on),
    endedOn: isoDate(row.ended_on),
    notes: row.notes || '',
    status,
    prescriber: row.prescriber || '',
    efficacy: row.efficacy || '',
    createdByUserId: row.created_by_user_id ? String(row.created_by_user_id) : null,
    createdAt: isoTs(row.created_at),
    updatedAt: isoTs(row.updated_at),
    mine: isOwner || row.created_by_user_id === jwtUserId,
  };
}

async function handleMedications(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  const body = req.method === 'GET' ? {} : parseJsonBody(req);
  if (req.method !== 'GET' && !body) return jsonError(res, 400, 'Invalid JSON');
  const actor = await requireActor(req, res, client, jwtUser, body, 'medications', req.method === 'POST');
  if (!actor) return null;

  if (req.method === 'GET') {
    const { rows } = await client.query(
      `SELECT id::text, name, dose, schedule, started_on, ended_on, notes, status, prescriber, efficacy,
              created_by_user_id::text, created_at, updated_at
         FROM care_medications WHERE file_id = $1
        ORDER BY CASE status WHEN 'current' THEN 0 WHEN 'recommended' THEN 1 ELSE 2 END,
                 started_on DESC NULLS LAST, created_at DESC`,
      [actor.fileId]
    );
    await writeAudit(client, actor, 'view', 'medications', null);
    return res.status(200).json({
      items: rows.map((r) => mapMedication(r, jwtUser.id, actor.actorKind === 'owner')),
    });
  }

  if (req.method === 'POST') {
    if (!canAddToSection(actor, 'medications')) return jsonError(res, 403, 'Forbidden');
    const name = strField(body!, 'name', 200, true);
    const dose = strField(body!, 'dose', 200, false);
    const schedule = strField(body!, 'schedule', 200, false);
    const notes = strField(body!, 'notes', 2000, false);
    const prescriber = strField(body!, 'prescriber', 200, false);
    const efficacy = strField(body!, 'efficacy', 2000, false);
    const status = isOneOf(body!.status, MED_STATUSES) ? body!.status : 'current';
    const startedOn = body!.startedOn ? isoDate(body!.startedOn) : null;
    const endedOn = body!.endedOn ? isoDate(body!.endedOn) : null;
    if (!name) return jsonError(res, 400, 'Invalid medication');
    const { rows } = await client.query(
      `INSERT INTO care_medications
         (file_id, created_by_user_id, name, dose, schedule, started_on, ended_on, notes, status, prescriber, efficacy)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)
       RETURNING id::text, name, dose, schedule, started_on, ended_on, notes, status, prescriber, efficacy,
                 created_by_user_id::text, created_at, updated_at`,
      [
        actor.fileId,
        jwtUser.id,
        name,
        dose || '',
        schedule || '',
        startedOn,
        endedOn,
        notes || '',
        status,
        prescriber || '',
        efficacy || '',
      ]
    );
    await writeAudit(client, actor, 'create', 'medications', rows[0].id);
    return res.status(201).json({ item: mapMedication(rows[0], jwtUser.id, true) });
  }

  const id = itemIdFrom(req, body);
  if (!id) return jsonError(res, 400, 'id is required');
  const existing = await client.query(
    `SELECT created_by_user_id::text FROM care_medications WHERE id = $1 AND file_id = $2`,
    [id, actor.fileId]
  );
  if (!existing.rows[0]) return jsonError(res, 404, 'Not found');
  if (!canMutateRow(actor, existing.rows[0].created_by_user_id)) return jsonError(res, 403, 'Forbidden');

  if (req.method === 'DELETE') {
    await client.query(`DELETE FROM care_medications WHERE id = $1`, [id]);
    await writeAudit(client, actor, 'delete', 'medications', id);
    return res.status(200).json({ ok: true });
  }

  if (req.method === 'PATCH') {
    const name = typeof body!.name === 'string' ? clip(body!.name.trim(), 200) : null;
    const dose = typeof body!.dose === 'string' ? clip(body!.dose.trim(), 200) : null;
    const schedule = typeof body!.schedule === 'string' ? clip(body!.schedule.trim(), 200) : null;
    const notes = typeof body!.notes === 'string' ? clip(body!.notes.trim(), 2000) : null;
    const prescriber = typeof body!.prescriber === 'string' ? clip(body!.prescriber.trim(), 200) : null;
    const efficacy = typeof body!.efficacy === 'string' ? clip(body!.efficacy.trim(), 2000) : null;
    const status = isOneOf(body!.status, MED_STATUSES) ? body!.status : null;
    const startedOn = body!.startedOn === null ? null : body!.startedOn != null ? isoDate(body!.startedOn) : undefined;
    const endedOn = body!.endedOn === null ? null : body!.endedOn != null ? isoDate(body!.endedOn) : undefined;
    const { rows } = await client.query(
      `UPDATE care_medications SET
         name = COALESCE(NULLIF($3, ''), name),
         dose = COALESCE($4, dose),
         schedule = COALESCE($5, schedule),
         notes = COALESCE($6, notes),
         prescriber = COALESCE($7, prescriber),
         efficacy = COALESCE($8, efficacy),
         status = COALESCE($9, status),
         started_on = CASE WHEN $10::text = '__omit' THEN started_on WHEN $10 = '' THEN NULL ELSE $10::date END,
         ended_on = CASE WHEN $11::text = '__omit' THEN ended_on WHEN $11 = '' THEN NULL ELSE $11::date END,
         updated_at = now()
       WHERE id = $1 AND file_id = $2
       RETURNING id::text, name, dose, schedule, started_on, ended_on, notes, status, prescriber, efficacy,
                 created_by_user_id::text, created_at, updated_at`,
      [
        id,
        actor.fileId,
        name,
        dose,
        schedule,
        notes,
        prescriber,
        efficacy,
        status,
        startedOn === undefined ? '__omit' : startedOn || '',
        endedOn === undefined ? '__omit' : endedOn || '',
      ]
    );
    await writeAudit(client, actor, 'update', 'medications', id);
    return res.status(200).json({ item: mapMedication(rows[0], jwtUser.id, true) });
  }

  return jsonError(res, 405, 'Method not allowed');
}

function mapContact(row: Record<string, unknown>, jwtUserId: string, isOwner: boolean) {
  return {
    id: String(row.id),
    kind: row.kind === 'org' ? 'org' : 'person',
    name: row.name,
    orgType: row.org_type || '',
    website: row.website || '',
    qualification: row.qualification || '',
    role: row.role || '',
    orgId: row.org_id ? String(row.org_id) : null,
    orgName: row.org_name || '',
    phone: row.phone || '',
    email: row.email || '',
    referredById: row.referred_by_id ? String(row.referred_by_id) : null,
    referredByName: row.referred_by_name || '',
    notes: row.notes || '',
    createdByUserId: row.created_by_user_id ? String(row.created_by_user_id) : null,
    createdAt: isoTs(row.created_at),
    updatedAt: isoTs(row.updated_at),
    mine: isOwner || row.created_by_user_id === jwtUserId,
  };
}

const CONTACT_SELECT = `
  c.id::text, c.kind, c.name, c.org_type, c.website, c.qualification, c.role,
  c.org_id::text, c.phone, c.email, c.referred_by_id::text, c.notes,
  c.created_by_user_id::text, c.created_at, c.updated_at,
  o.name AS org_name, r.name AS referred_by_name
`;

async function handleContacts(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  const body = req.method === 'GET' ? {} : parseJsonBody(req);
  if (req.method !== 'GET' && !body) return jsonError(res, 400, 'Invalid JSON');
  const actor = await requireActor(req, res, client, jwtUser, body, 'contacts', req.method === 'POST');
  if (!actor) return null;

  if (req.method === 'GET') {
    const { rows } = await client.query(
      `SELECT ${CONTACT_SELECT}
         FROM care_contacts c
         LEFT JOIN care_contacts o ON o.id = c.org_id
         LEFT JOIN care_contacts r ON r.id = c.referred_by_id
        WHERE c.file_id = $1
        ORDER BY c.kind ASC, c.name ASC`,
      [actor.fileId]
    );
    await writeAudit(client, actor, 'view', 'contacts', null);
    return res.status(200).json({
      items: rows.map((r) => mapContact(r, jwtUser.id, actor.actorKind === 'owner')),
    });
  }

  if (req.method === 'POST') {
    if (!canAddToSection(actor, 'contacts')) return jsonError(res, 403, 'Forbidden');
    const kind = isOneOf(body!.kind, CONTACT_KINDS) ? body!.kind : 'person';
    const name = strField(body!, 'name', 200, true);
    if (!name) return jsonError(res, 400, 'Invalid contact');
    const orgType = kind === 'org' && isOneOf(body!.orgType, ORG_TYPES) ? body!.orgType : '';
    const website = kind === 'org' ? strField(body!, 'website', 400, false) || '' : '';
    const qualification = kind === 'person' && isOneOf(body!.qualification, QUALIFICATIONS) ? body!.qualification : '';
    const role = strField(body!, 'role', 200, false) || '';
    const phone = strField(body!, 'phone', 80, false) || '';
    const email = strField(body!, 'email', 320, false) || '';
    const notes = strField(body!, 'notes', 2000, false) || '';
    const orgId = kind === 'person' && isUuid(body!.orgId) ? body!.orgId : null;
    const referredById = isUuid(body!.referredById) ? body!.referredById : null;
    if (!(await contactInFile(client, actor.fileId, orgId, 'org'))) return jsonError(res, 400, 'Invalid contact');
    if (!(await contactInFile(client, actor.fileId, referredById))) return jsonError(res, 400, 'Invalid contact');
    const { rows } = await client.query(
      `INSERT INTO care_contacts
         (file_id, created_by_user_id, kind, name, org_type, website, qualification, role, org_id, phone, email, referred_by_id, notes)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13)
       RETURNING id::text, kind, name, org_type, website, qualification, role, org_id::text, phone, email,
                 referred_by_id::text, notes, created_by_user_id::text, created_at, updated_at`,
      [actor.fileId, jwtUser.id, kind, name, orgType, website, qualification, role, orgId, phone, email, referredById, notes]
    );
    await writeAudit(client, actor, 'create', 'contacts', rows[0].id);
    return res.status(201).json({ item: mapContact(rows[0], jwtUser.id, true) });
  }

  const id = itemIdFrom(req, body);
  if (!id) return jsonError(res, 400, 'id is required');
  const existing = await client.query(
    `SELECT created_by_user_id::text FROM care_contacts WHERE id = $1 AND file_id = $2`,
    [id, actor.fileId]
  );
  if (!existing.rows[0]) return jsonError(res, 404, 'Not found');
  if (!canMutateRow(actor, existing.rows[0].created_by_user_id)) return jsonError(res, 403, 'Forbidden');

  if (req.method === 'DELETE') {
    await client.query(`DELETE FROM care_contacts WHERE id = $1`, [id]);
    await writeAudit(client, actor, 'delete', 'contacts', id);
    return res.status(200).json({ ok: true });
  }

  if (req.method === 'PATCH') {
    const name = typeof body!.name === 'string' ? clip(body!.name.trim(), 200) : null;
    const role = typeof body!.role === 'string' ? clip(body!.role.trim(), 200) : null;
    const phone = typeof body!.phone === 'string' ? clip(body!.phone.trim(), 80) : null;
    const email = typeof body!.email === 'string' ? clip(body!.email.trim(), 320) : null;
    const notes = typeof body!.notes === 'string' ? clip(body!.notes.trim(), 2000) : null;
    const website = typeof body!.website === 'string' ? clip(body!.website.trim(), 400) : null;
    const orgType = isOneOf(body!.orgType, ORG_TYPES) ? body!.orgType : body!.orgType === '' ? '' : null;
    const qualification = isOneOf(body!.qualification, QUALIFICATIONS)
      ? body!.qualification
      : body!.qualification === ''
        ? ''
        : null;
    const orgId = body!.orgId === null || body!.orgId === '' ? null : isUuid(body!.orgId) ? body!.orgId : undefined;
    const referredById =
      body!.referredById === null || body!.referredById === ''
        ? null
        : isUuid(body!.referredById)
          ? body!.referredById
          : undefined;
    if (orgId && orgId === id) return jsonError(res, 400, 'Invalid contact');
    if (referredById && referredById === id) return jsonError(res, 400, 'Invalid contact');
    if (orgId && !(await contactInFile(client, actor.fileId, orgId, 'org'))) return jsonError(res, 400, 'Invalid contact');
    if (referredById && !(await contactInFile(client, actor.fileId, referredById))) {
      return jsonError(res, 400, 'Invalid contact');
    }
    const { rows } = await client.query(
      `UPDATE care_contacts SET
         name = COALESCE(NULLIF($3, ''), name),
         role = COALESCE($4, role),
         phone = COALESCE($5, phone),
         email = COALESCE($6, email),
         notes = COALESCE($7, notes),
         website = COALESCE($8, website),
         org_type = COALESCE($9, org_type),
         qualification = COALESCE($10, qualification),
         org_id = CASE WHEN $11::text = '__omit' THEN org_id ELSE $11::uuid END,
         referred_by_id = CASE WHEN $12::text = '__omit' THEN referred_by_id ELSE $12::uuid END,
         updated_at = now()
       WHERE id = $1 AND file_id = $2
       RETURNING id::text, kind, name, org_type, website, qualification, role, org_id::text, phone, email,
                 referred_by_id::text, notes, created_by_user_id::text, created_at, updated_at`,
      [
        id,
        actor.fileId,
        name,
        role,
        phone,
        email,
        notes,
        website,
        orgType,
        qualification,
        orgId === undefined ? '__omit' : orgId,
        referredById === undefined ? '__omit' : referredById,
      ]
    );
    await writeAudit(client, actor, 'update', 'contacts', id);
    return res.status(200).json({ item: mapContact(rows[0], jwtUser.id, true) });
  }

  return jsonError(res, 405, 'Method not allowed');
}

function mapNote(row: Record<string, unknown>, jwtUserId: string, isOwner: boolean) {
  return {
    id: String(row.id),
    body: row.body,
    createdByUserId: row.created_by_user_id ? String(row.created_by_user_id) : null,
    createdAt: isoTs(row.created_at),
    updatedAt: isoTs(row.updated_at),
    mine: isOwner || row.created_by_user_id === jwtUserId,
  };
}

async function handleNotes(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  const body = req.method === 'GET' ? {} : parseJsonBody(req);
  if (req.method !== 'GET' && !body) return jsonError(res, 400, 'Invalid JSON');
  const actor = await requireActor(req, res, client, jwtUser, body, 'notes', req.method === 'POST');
  if (!actor) return null;

  if (req.method === 'GET') {
    const { rows } = await client.query(
      `SELECT id::text, body, created_by_user_id::text, created_at, updated_at
         FROM care_notes WHERE file_id = $1 ORDER BY created_at DESC`,
      [actor.fileId]
    );
    await writeAudit(client, actor, 'view', 'notes', null);
    return res.status(200).json({
      items: rows.map((r) => mapNote(r, jwtUser.id, actor.actorKind === 'owner')),
    });
  }

  if (req.method === 'POST') {
    if (!canAddToSection(actor, 'notes')) return jsonError(res, 403, 'Forbidden');
    const noteBody = strField(body!, 'body', 8000, true);
    if (!noteBody) return jsonError(res, 400, 'Invalid note');
    const { rows } = await client.query(
      `INSERT INTO care_notes (file_id, created_by_user_id, body)
       VALUES ($1,$2,$3)
       RETURNING id::text, body, created_by_user_id::text, created_at, updated_at`,
      [actor.fileId, jwtUser.id, noteBody]
    );
    await writeAudit(client, actor, 'create', 'notes', rows[0].id);
    return res.status(201).json({ item: mapNote(rows[0], jwtUser.id, true) });
  }

  const id = itemIdFrom(req, body);
  if (!id) return jsonError(res, 400, 'id is required');
  const existing = await client.query(
    `SELECT created_by_user_id::text FROM care_notes WHERE id = $1 AND file_id = $2`,
    [id, actor.fileId]
  );
  if (!existing.rows[0]) return jsonError(res, 404, 'Not found');
  if (!canMutateRow(actor, existing.rows[0].created_by_user_id)) return jsonError(res, 403, 'Forbidden');

  if (req.method === 'DELETE') {
    await client.query(`DELETE FROM care_notes WHERE id = $1`, [id]);
    await writeAudit(client, actor, 'delete', 'notes', id);
    return res.status(200).json({ ok: true });
  }

  if (req.method === 'PATCH') {
    const noteBody = strField(body!, 'body', 8000, true);
    if (!noteBody) return jsonError(res, 400, 'Invalid note');
    const { rows } = await client.query(
      `UPDATE care_notes SET body = $3, updated_at = now()
       WHERE id = $1 AND file_id = $2
       RETURNING id::text, body, created_by_user_id::text, created_at, updated_at`,
      [id, actor.fileId, noteBody]
    );
    await writeAudit(client, actor, 'update', 'notes', id);
    return res.status(200).json({ item: mapNote(rows[0], jwtUser.id, true) });
  }

  return jsonError(res, 405, 'Method not allowed');
}

function rowMeta(row: Record<string, unknown>, jwtUserId: string, isOwner: boolean) {
  return {
    id: String(row.id),
    createdByUserId: row.created_by_user_id ? String(row.created_by_user_id) : null,
    createdAt: isoTs(row.created_at),
    updatedAt: isoTs(row.updated_at),
    mine: isOwner || row.created_by_user_id === jwtUserId,
  };
}

type RowParse = (body: Record<string, unknown>) => Record<string, unknown> | null;

async function handleRowCrud(
  req: VercelRequest,
  res: VercelResponse,
  client: Client,
  jwtUser: JwtUser,
  spec: {
    section: CareSection;
    table: string;
    select: string;
    order: string;
    map: (row: Record<string, unknown>, jwtId: string, owner: boolean) => Record<string, unknown>;
    parse: RowParse;
  }
) {
  const body = req.method === 'GET' ? {} : parseJsonBody(req);
  if (req.method !== 'GET' && !body) return jsonError(res, 400, 'Invalid JSON');
  const actor = await requireActor(req, res, client, jwtUser, body, spec.section, req.method === 'POST');
  if (!actor) return null;

  if (req.method === 'GET') {
    const { rows } = await client.query(
      `SELECT ${spec.select} FROM ${spec.table} WHERE file_id = $1 ORDER BY ${spec.order}`,
      [actor.fileId]
    );
    await writeAudit(client, actor, 'view', spec.section, null);
    return res.status(200).json({
      items: rows.map((r) => spec.map(r, jwtUser.id, actor.actorKind === 'owner')),
    });
  }

  if (req.method === 'POST') {
    if (!canAddToSection(actor, spec.section)) return jsonError(res, 403, 'Forbidden');
    const parsed = spec.parse(body!);
    if (!parsed) return jsonError(res, 400, 'Invalid item');
    const cols = Object.keys(parsed);
    const vals = cols.map((c) => parsed[c]);
    const ph = cols.map((_, i) => `$${i + 3}`);
    const { rows } = await client.query(
      `INSERT INTO ${spec.table} (file_id, created_by_user_id, ${cols.join(', ')})
       VALUES ($1,$2,${ph.join(',')})
       RETURNING ${spec.select}`,
      [actor.fileId, jwtUser.id, ...vals]
    );
    await writeAudit(client, actor, 'create', spec.section, rows[0].id);
    return res.status(201).json({ item: spec.map(rows[0], jwtUser.id, true) });
  }

  const id = itemIdFrom(req, body);
  if (!id) return jsonError(res, 400, 'id is required');
  const existing = await client.query(
    `SELECT created_by_user_id::text FROM ${spec.table} WHERE id = $1 AND file_id = $2`,
    [id, actor.fileId]
  );
  if (!existing.rows[0]) return jsonError(res, 404, 'Not found');
  if (!canMutateRow(actor, existing.rows[0].created_by_user_id)) return jsonError(res, 403, 'Forbidden');

  if (req.method === 'DELETE') {
    await client.query(`DELETE FROM ${spec.table} WHERE id = $1`, [id]);
    await writeAudit(client, actor, 'delete', spec.section, id);
    return res.status(200).json({ ok: true });
  }

  if (req.method === 'PATCH') {
    const parsed = spec.parse(body!);
    if (!parsed || !Object.keys(parsed).length) return jsonError(res, 400, 'Invalid item');
    const cols = Object.keys(parsed);
    const sets = cols.map((c, i) => `${c} = $${i + 3}`).join(', ');
    const vals = cols.map((c) => parsed[c]);
    const { rows } = await client.query(
      `UPDATE ${spec.table} SET ${sets}, updated_at = now()
        WHERE id = $1 AND file_id = $2
        RETURNING ${spec.select}`,
      [id, actor.fileId, ...vals]
    );
    await writeAudit(client, actor, 'update', spec.section, id);
    return res.status(200).json({ item: spec.map(rows[0], jwtUser.id, true) });
  }

  return jsonError(res, 405, 'Method not allowed');
}

function optText(body: Record<string, unknown>, key: string, max: number): string | undefined {
  if (typeof body[key] !== 'string') return undefined;
  return clip(body[key].trim(), max);
}

function optDate(body: Record<string, unknown>, key: string): string | null | undefined {
  if (body[key] === undefined) return undefined;
  if (body[key] === null || body[key] === '') return null;
  return isoDate(body[key]);
}

function optBool(body: Record<string, unknown>, key: string): boolean | undefined {
  return typeof body[key] === 'boolean' ? body[key] : undefined;
}

function dropUndef(obj: Record<string, unknown>): Record<string, unknown> {
  const out: Record<string, unknown> = {};
  for (const [k, v] of Object.entries(obj)) {
    if (v !== undefined) out[k] = v;
  }
  return out;
}

async function handleRights(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  return handleRowCrud(req, res, client, jwtUser, {
    section: 'rights',
    table: 'care_rights',
    select:
      'id::text, kind, status, percent_a, percent_b, valid_until, summary, notes, created_by_user_id::text, created_at, updated_at',
    order: 'created_at DESC',
    map: (row, jwtId, owner) => ({
      ...rowMeta(row, jwtId, owner),
      kind: row.kind,
      status: row.status,
      percentA: row.percent_a || '',
      percentB: row.percent_b || '',
      validUntil: isoDate(row.valid_until),
      summary: row.summary || '',
      notes: row.notes || '',
    }),
    parse: (body) => {
      const kind = isOneOf(body.kind, RIGHTS_KINDS) ? body.kind : undefined;
      const status = isOneOf(body.status, RIGHTS_STATUSES) ? body.status : undefined;
      if (body.kind !== undefined && !kind) return null;
      const out = dropUndef({
        kind,
        status,
        percent_a: optText(body, 'percentA', 20),
        percent_b: optText(body, 'percentB', 20),
        valid_until: optDate(body, 'validUntil'),
        summary: optText(body, 'summary', 500),
        notes: optText(body, 'notes', 2000),
      });
      if (body.kind !== undefined && !out.kind) return null;
      if (!body.id && !out.kind) {
        if (!kind) return null;
      }
      return out;
    },
  });
}

async function handleCommittees(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  return handleRowCrud(req, res, client, jwtUser, {
    section: 'rights',
    table: 'care_committees',
    select:
      'id::text, rights_id::text, body, title, scheduled_on, scheduled_time, place, status, remind, last_reminded_on, notes, created_by_user_id::text, created_at, updated_at',
    order: 'scheduled_on ASC',
    map: (row, jwtId, owner) => ({
      ...rowMeta(row, jwtId, owner),
      rightsId: row.rights_id ? String(row.rights_id) : null,
      body: row.body,
      title: row.title,
      scheduledOn: isoDate(row.scheduled_on),
      scheduledTime: row.scheduled_time || '',
      place: row.place || '',
      status: row.status,
      remind: Boolean(row.remind),
      lastRemindedOn: isoDate(row.last_reminded_on),
      notes: row.notes || '',
    }),
    parse: (body) => {
      const title = optText(body, 'title', 200);
      const committeeBody = isOneOf(body.body, COMMITTEE_BODIES) ? body.body : undefined;
      const status = isOneOf(body.status, COMMITTEE_STATUSES) ? body.status : undefined;
      const scheduledOn = optDate(body, 'scheduledOn');
      if (body.title !== undefined && !title) return null;
      if (!body.id && (!title || !committeeBody || !scheduledOn)) return null;
      const out = dropUndef({
        rights_id: isUuid(body.rightsId) ? body.rightsId : body.rightsId === null ? null : undefined,
        body: committeeBody,
        title,
        scheduled_on: scheduledOn,
        scheduled_time: optText(body, 'scheduledTime', 40),
        place: optText(body, 'place', 200),
        status,
        remind: optBool(body, 'remind'),
        notes: optText(body, 'notes', 2000),
      });
      return out;
    },
  });
}

async function handleHmoHistory(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  return handleRowCrud(req, res, client, jwtUser, {
    section: 'profile',
    table: 'care_hmo_history',
    select:
      'id::text, hmo, started_on, ended_on, notes, created_by_user_id::text, created_at, updated_at',
    order: 'started_on DESC NULLS LAST, created_at DESC',
    map: (row, jwtId, owner) => ({
      ...rowMeta(row, jwtId, owner),
      hmo: row.hmo,
      startedOn: isoDate(row.started_on),
      endedOn: isoDate(row.ended_on),
      notes: row.notes || '',
    }),
    parse: (body) => {
      const hmo = isOneOf(body.hmo, HMO_VALUES) ? body.hmo : undefined;
      if (!body.id && !hmo) return null;
      return dropUndef({
        hmo,
        started_on: optDate(body, 'startedOn'),
        ended_on: optDate(body, 'endedOn'),
        notes: optText(body, 'notes', 2000),
      });
    },
  });
}

async function handleFamily(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  return handleRowCrud(req, res, client, jwtUser, {
    section: 'family',
    table: 'care_family',
    select:
      'id::text, name, relation, phone, email, lives_with, involved, notes, created_by_user_id::text, created_at, updated_at',
    order: 'created_at DESC',
    map: (row, jwtId, owner) => ({
      ...rowMeta(row, jwtId, owner),
      name: row.name,
      relation: row.relation || '',
      phone: row.phone || '',
      email: row.email || '',
      livesWith: Boolean(row.lives_with),
      involved: Boolean(row.involved),
      notes: row.notes || '',
    }),
    parse: (body) => {
      const name = optText(body, 'name', 200);
      if (body.name !== undefined && !name) return null;
      if (!body.id && !name) return null;
      return dropUndef({
        name,
        relation: optText(body, 'relation', 80),
        phone: optText(body, 'phone', 80),
        email: optText(body, 'email', 320),
        lives_with: optBool(body, 'livesWith'),
        involved: optBool(body, 'involved'),
        notes: optText(body, 'notes', 2000),
      });
    },
  });
}

async function handleDiagnoses(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  return handleRowCrud(req, res, client, jwtUser, {
    section: 'diagnoses',
    table: 'care_diagnoses',
    select:
      'id::text, name, code, diagnosed_on, diagnosed_by, status, notes, created_by_user_id::text, created_at, updated_at',
    order: 'diagnosed_on DESC NULLS LAST, created_at DESC',
    map: (row, jwtId, owner) => ({
      ...rowMeta(row, jwtId, owner),
      name: row.name,
      code: row.code || '',
      diagnosedOn: isoDate(row.diagnosed_on),
      diagnosedBy: row.diagnosed_by || '',
      status: row.status,
      notes: row.notes || '',
    }),
    parse: (body) => {
      const name = optText(body, 'name', 200);
      const status = isOneOf(body.status, DIAGNOSIS_STATUSES) ? body.status : undefined;
      if (body.name !== undefined && !name) return null;
      if (!body.id && !name) return null;
      return dropUndef({
        name,
        code: optText(body, 'code', 40),
        diagnosed_on: optDate(body, 'diagnosedOn'),
        diagnosed_by: optText(body, 'diagnosedBy', 200),
        status,
        notes: optText(body, 'notes', 2000),
      });
    },
  });
}

async function handleTherapy(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  return handleRowCrud(req, res, client, jwtUser, {
    section: 'therapy',
    table: 'care_therapy',
    select:
      'id::text, modality, therapist_name, started_on, ended_on, frequency, notes, created_by_user_id::text, created_at, updated_at',
    order: 'started_on DESC NULLS LAST, created_at DESC',
    map: (row, jwtId, owner) => ({
      ...rowMeta(row, jwtId, owner),
      modality: row.modality || '',
      therapistName: row.therapist_name,
      startedOn: isoDate(row.started_on),
      endedOn: isoDate(row.ended_on),
      frequency: row.frequency || '',
      notes: row.notes || '',
    }),
    parse: (body) => {
      const therapistName = optText(body, 'therapistName', 200);
      if (body.therapistName !== undefined && !therapistName) return null;
      if (!body.id && !therapistName) return null;
      return dropUndef({
        modality: optText(body, 'modality', 80),
        therapist_name: therapistName,
        started_on: optDate(body, 'startedOn'),
        ended_on: optDate(body, 'endedOn'),
        frequency: optText(body, 'frequency', 200),
        notes: optText(body, 'notes', 2000),
      });
    },
  });
}

async function handleActivities(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  return handleRowCrud(req, res, client, jwtUser, {
    section: 'activity',
    table: 'care_activities',
    select:
      'id::text, kind, name, frequency, started_on, notes, created_by_user_id::text, created_at, updated_at',
    order: 'created_at DESC',
    map: (row, jwtId, owner) => ({
      ...rowMeta(row, jwtId, owner),
      kind: row.kind,
      name: row.name,
      frequency: row.frequency || '',
      startedOn: isoDate(row.started_on),
      notes: row.notes || '',
    }),
    parse: (body) => {
      const name = optText(body, 'name', 200);
      const kind = isOneOf(body.kind, ACTIVITY_KINDS) ? body.kind : undefined;
      if (body.name !== undefined && !name) return null;
      if (!body.id && !name) return null;
      return dropUndef({
        kind,
        name,
        frequency: optText(body, 'frequency', 200),
        started_on: optDate(body, 'startedOn'),
        notes: optText(body, 'notes', 2000),
      });
    },
  });
}

function mapLabResult(row: Record<string, unknown>, jwtId: string, owner: boolean) {
  return {
    ...rowMeta(row, jwtId, owner),
    panelId: row.panel_id ? String(row.panel_id) : null,
    marker: row.marker,
    customName: row.custom_name || '',
    value: row.value,
    unit: row.unit || '',
    flag: row.flag || '',
    measuredOn: isoDate(row.measured_on),
    notes: row.notes || '',
  };
}

function latestLabs(items: ReturnType<typeof mapLabResult>[]) {
  const map = new Map<string, (typeof items)[number]>();
  for (const it of items) {
    const key = it.marker === 'other' ? `other:${it.customName}` : String(it.marker);
    const prev = map.get(key);
    if (!prev || String(it.measuredOn || '') > String(prev.measuredOn || '')) map.set(key, it);
  }
  const order = LAB_MARKERS as readonly string[];
  return [...map.values()].sort((a, b) => {
    const ia = order.indexOf(String(a.marker));
    const ib = order.indexOf(String(b.marker));
    return (ia < 0 ? 99 : ia) - (ib < 0 ? 99 : ib);
  });
}

async function handleLabPanels(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  return handleRowCrud(req, res, client, jwtUser, {
    section: 'labs',
    table: 'care_lab_panels',
    select: 'id::text, drawn_on, lab_name, notes, created_by_user_id::text, created_at, updated_at',
    order: 'drawn_on DESC, created_at DESC',
    map: (row, jwtId, owner) => ({
      ...rowMeta(row, jwtId, owner),
      drawnOn: isoDate(row.drawn_on),
      labName: row.lab_name || '',
      notes: row.notes || '',
    }),
    parse: (body) => {
      const drawnOn = optDate(body, 'drawnOn');
      if (!body.id && !drawnOn) return null;
      return dropUndef({
        drawn_on: drawnOn,
        lab_name: optText(body, 'labName', 200),
        notes: optText(body, 'notes', 2000),
      });
    },
  });
}

async function handleLabResults(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  const body = req.method === 'GET' ? {} : parseJsonBody(req);
  if (req.method !== 'GET' && !body) return jsonError(res, 400, 'Invalid JSON');
  if (req.method === 'GET') {
    const actor = await requireActor(req, res, client, jwtUser, body, 'labs', false);
    if (!actor) return null;
    const { rows } = await client.query(
      `SELECT id::text, panel_id::text, marker, custom_name, value, unit, flag, measured_on, notes,
              created_by_user_id::text, created_at, updated_at
         FROM care_lab_results WHERE file_id = $1
        ORDER BY measured_on DESC, created_at DESC`,
      [actor.fileId]
    );
    await writeAudit(client, actor, 'view', 'labs', null);
    const items = rows.map((r) => mapLabResult(r, jwtUser.id, actor.actorKind === 'owner'));
    return res.status(200).json({ items, current: latestLabs(items) });
  }
  if ((req.method === 'POST' || req.method === 'PATCH') && body && isUuid(body.panelId)) {
    const fileId = fileIdFrom(req, body);
    const pan = await client.query(`SELECT 1 FROM care_lab_panels WHERE id = $1 AND file_id = $2`, [
      body.panelId,
      fileId,
    ]);
    if (!pan.rows[0]) return jsonError(res, 400, 'Invalid item');
  }
  return handleRowCrud(req, res, client, jwtUser, {
    section: 'labs',
    table: 'care_lab_results',
    select:
      'id::text, panel_id::text, marker, custom_name, value, unit, flag, measured_on, notes, created_by_user_id::text, created_at, updated_at',
    order: 'measured_on DESC, created_at DESC',
    map: mapLabResult,
    parse: (b) => {
      const marker = isOneOf(b.marker, LAB_MARKERS) ? b.marker : undefined;
      const value = optText(b, 'value', 80);
      const measuredOn = optDate(b, 'measuredOn');
      const flag = isOneOf(b.flag, LAB_FLAGS) ? b.flag : b.flag === '' ? '' : undefined;
      if (!b.id && (!marker || !value || !measuredOn)) return null;
      return dropUndef({
        panel_id: isUuid(b.panelId) ? b.panelId : b.panelId === null || b.panelId === '' ? null : undefined,
        marker,
        custom_name: optText(b, 'customName', 80),
        value,
        unit: optText(b, 'unit', 40),
        flag,
        measured_on: measuredOn,
        notes: optText(b, 'notes', 2000),
      });
    },
  });
}

const PROFILE_TEXT: { json: string; col: string; max: number }[] = [
  { json: 'fullName', col: 'full_name', max: 200 },
  { json: 'nationalId', col: 'national_id', max: 20 },
  { json: 'gender', col: 'gender', max: 40 },
  { json: 'maritalStatus', col: 'marital_status', max: 40 },
  { json: 'childrenCount', col: 'children_count', max: 40 },
  { json: 'phone', col: 'phone', max: 80 },
  { json: 'address', col: 'address', max: 400 },
  { json: 'city', col: 'city', max: 100 },
  { json: 'countryOfBirth', col: 'country_of_birth', max: 100 },
  { json: 'aliyahYear', col: 'aliyah_year', max: 10 },
  { json: 'languages', col: 'languages', max: 200 },
  { json: 'education', col: 'education', max: 400 },
  { json: 'employment', col: 'employment', max: 400 },
  { json: 'military', col: 'military', max: 400 },
  { json: 'housing', col: 'housing', max: 400 },
  { json: 'clinicName', col: 'clinic_name', max: 200 },
  { json: 'allergies', col: 'allergies', max: 1000 },
  { json: 'emergencyName', col: 'emergency_name', max: 200 },
  { json: 'emergencyPhone', col: 'emergency_phone', max: 80 },
  { json: 'emergencyRelation', col: 'emergency_relation', max: 80 },
  { json: 'btlUserCode', col: 'btl_user_code', max: 80 },
  { json: 'btlPassword', col: 'btl_password', max: 200 },
];

function mapProfile(row: Record<string, unknown> | null) {
  if (!row) {
    return {
      fullName: '',
      nationalId: '',
      birthOn: null,
      gender: '',
      maritalStatus: '',
      childrenCount: '',
      phone: '',
      address: '',
      city: '',
      countryOfBirth: '',
      aliyahYear: '',
      languages: '',
      education: '',
      employment: '',
      military: '',
      housing: '',
      hmo: '',
      hmoMemberSince: null,
      clinicName: '',
      allergies: '',
      emergencyName: '',
      emergencyPhone: '',
      emergencyRelation: '',
      btlUserCode: '',
      btlPassword: '',
    };
  }
  return {
    fullName: row.full_name || '',
    nationalId: row.national_id || '',
    birthOn: isoDate(row.birth_on),
    gender: row.gender || '',
    maritalStatus: row.marital_status || '',
    childrenCount: row.children_count || '',
    phone: row.phone || '',
    address: row.address || '',
    city: row.city || '',
    countryOfBirth: row.country_of_birth || '',
    aliyahYear: row.aliyah_year || '',
    languages: row.languages || '',
    education: row.education || '',
    employment: row.employment || '',
    military: row.military || '',
    housing: row.housing || '',
    hmo: row.hmo || '',
    hmoMemberSince: isoDate(row.hmo_member_since),
    clinicName: row.clinic_name || '',
    allergies: row.allergies || '',
    emergencyName: row.emergency_name || '',
    emergencyPhone: row.emergency_phone || '',
    emergencyRelation: row.emergency_relation || '',
    btlUserCode: row.btl_user_code || '',
    btlPassword: row.btl_password || '',
  };
}

function profileForActor(row: Record<string, unknown> | null, actor: CareActor) {
  const mapped = mapProfile(row);
  if (actor.actorKind === 'share_link') {
    mapped.btlUserCode = '';
    mapped.btlPassword = '';
  }
  return mapped;
}

async function handleProfile(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  const body = req.method === 'GET' ? {} : parseJsonBody(req);
  if (req.method !== 'GET' && !body) return jsonError(res, 400, 'Invalid JSON');
  const actor = await requireActor(req, res, client, jwtUser, body, 'profile', req.method !== 'GET');
  if (!actor) return null;
  const { rows } = await client.query(`SELECT * FROM care_profile WHERE file_id = $1`, [actor.fileId]);
  if (req.method === 'GET') {
    await writeAudit(client, actor, 'view', 'profile', null);
    return res.status(200).json({ item: profileForActor(rows[0] || null, actor) });
  }
  if (req.method !== 'PATCH' && req.method !== 'POST') return jsonError(res, 405, 'Method not allowed');
  if (!canAddToSection(actor, 'profile') && actor.actorKind !== 'owner') return jsonError(res, 403, 'Forbidden');
  const parsed: Record<string, unknown> = {};
  for (const f of PROFILE_TEXT) {
    if (actor.actorKind === 'share_link' && (f.col === 'btl_user_code' || f.col === 'btl_password')) continue;
    const v = optText(body!, f.json, f.max);
    if (v !== undefined) parsed[f.col] = v;
  }
  const hmo = body!.hmo === '' || body!.hmo === null ? '' : isOneOf(body!.hmo, HMO_VALUES) ? body!.hmo : undefined;
  if (hmo !== undefined) parsed.hmo = hmo;
  const birthOn = optDate(body!, 'birthOn');
  if (birthOn !== undefined) parsed.birth_on = birthOn;
  const hmoSince = optDate(body!, 'hmoMemberSince');
  if (hmoSince !== undefined) parsed.hmo_member_since = hmoSince;
  if (!Object.keys(parsed).length) return jsonError(res, 400, 'Invalid item');
  const cols = Object.keys(parsed);
  const vals = cols.map((c) => parsed[c]);
  const insertPh = cols.map((_, i) => `$${i + 3}`);
  const updates = cols.map((c, i) => `${c} = EXCLUDED.${c}`).join(', ');
  const { rows: saved } = await client.query(
    `INSERT INTO care_profile (file_id, created_by_user_id, ${cols.join(', ')})
     VALUES ($1,$2,${insertPh.join(',')})
     ON CONFLICT (file_id) DO UPDATE SET ${updates}, updated_at = now()
     RETURNING *`,
    [actor.fileId, jwtUser.id, ...vals]
  );
  await writeAudit(client, actor, rows[0] ? 'update' : 'create', 'profile', actor.fileId);
  return res.status(200).json({ item: profileForActor(saved[0], actor) });
}

const INTAKE_FIELDS = [
  ['presentingProblem', 'presenting_problem'],
  ['psychiatricHistory', 'psychiatric_history'],
  ['medicalHistory', 'medical_history'],
  ['substanceUse', 'substance_use'],
  ['selfHarmHistory', 'self_harm_history'],
  ['legalIssues', 'legal_issues'],
  ['supports', 'supports'],
  ['sleepAppetite', 'sleep_appetite'],
  ['other', 'other'],
] as const;

function mapIntake(row: Record<string, unknown> | null) {
  const empty: Record<string, string> = {};
  for (const [json] of INTAKE_FIELDS) empty[json] = '';
  if (!row) return empty;
  const out: Record<string, string> = {};
  for (const [json, col] of INTAKE_FIELDS) out[json] = String(row[col] || '');
  return out;
}

async function handleIntake(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  const body = req.method === 'GET' ? {} : parseJsonBody(req);
  if (req.method !== 'GET' && !body) return jsonError(res, 400, 'Invalid JSON');
  const actor = await requireActor(req, res, client, jwtUser, body, 'intake', req.method !== 'GET');
  if (!actor) return null;
  const { rows } = await client.query(`SELECT * FROM care_intake WHERE file_id = $1`, [actor.fileId]);
  if (req.method === 'GET') {
    await writeAudit(client, actor, 'view', 'intake', null);
    return res.status(200).json({ item: mapIntake(rows[0] || null) });
  }
  if (req.method !== 'PATCH' && req.method !== 'POST') return jsonError(res, 405, 'Method not allowed');
  if (!canAddToSection(actor, 'intake') && actor.actorKind !== 'owner') return jsonError(res, 403, 'Forbidden');
  const parsed: Record<string, unknown> = {};
  for (const [json, col] of INTAKE_FIELDS) {
    const v = optText(body!, json, col === 'sleep_appetite' ? 2000 : 4000);
    if (v !== undefined) parsed[col] = v;
  }
  if (!Object.keys(parsed).length) return jsonError(res, 400, 'Invalid item');
  const cols = Object.keys(parsed);
  const vals = cols.map((c) => parsed[c]);
  const insertPh = cols.map((_, i) => `$${i + 3}`);
  const updates = cols.map((c) => `${c} = EXCLUDED.${c}`).join(', ');
  const { rows: saved } = await client.query(
    `INSERT INTO care_intake (file_id, created_by_user_id, ${cols.join(', ')})
     VALUES ($1,$2,${insertPh.join(',')})
     ON CONFLICT (file_id) DO UPDATE SET ${updates}, updated_at = now()
     RETURNING *`,
    [actor.fileId, jwtUser.id, ...vals]
  );
  await writeAudit(client, actor, rows[0] ? 'update' : 'create', 'intake', actor.fileId);
  return res.status(200).json({ item: mapIntake(saved[0]) });
}

function grantStatus(row: Record<string, unknown>): string {
  if (row.status === 'revoked' || row.revoked_at) return 'revoked';
  if (row.status === 'pending') return 'pending';
  if (row.kind === 'timed' && row.expires_at && new Date(String(row.expires_at)).getTime() <= Date.now()) {
    return 'expired';
  }
  return String(row.status);
}

function mapGrant(row: Record<string, unknown>) {
  return {
    id: String(row.id),
    fileId: String(row.file_id),
    granteeEmail: row.grantee_email,
    kind: row.kind,
    canWrite: Boolean(row.can_write),
    sections: row.sections,
    status: grantStatus(row),
    expiresAt: isoTs(row.expires_at),
    acceptedAt: isoTs(row.accepted_at),
    createdAt: isoTs(row.created_at),
    ownerEmail: row.owner_email || null,
  };
}

async function handleGrants(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  const body = req.method === 'GET' ? {} : parseJsonBody(req);
  if (req.method !== 'GET' && !body) return jsonError(res, 400, 'Invalid JSON');

  if (req.method === 'GET') {
    const actor = await requireActor(req, res, client, jwtUser, body, null, false);
    if (!actor) return null;
    if (actor.actorKind !== 'owner') return jsonError(res, 403, 'Forbidden');
    const { rows } = await client.query(
      `SELECT id::text, file_id::text, grantee_email, kind, can_write, sections, status,
              expires_at, accepted_at, revoked_at, created_at
         FROM care_grants WHERE file_id = $1 ORDER BY created_at DESC`,
      [actor.fileId]
    );
    return res.status(200).json({ items: rows.map(mapGrant) });
  }

  if (req.method !== 'POST') return jsonError(res, 405, 'Method not allowed');
  if (!originAllowed(req)) return jsonError(res, 403, 'Forbidden');
  if (!rateLimit(`care-grant:${jwtUser.id}`, 20, 60 * 60 * 1000)) {
    return jsonError(res, 429, 'Too many attempts');
  }
  const actor = await requireActor(req, res, client, jwtUser, body, null, false);
  if (!actor) return null;
  if (actor.actorKind !== 'owner') return jsonError(res, 403, 'Forbidden');

  const email = normalizeEmail(body!.email);
  const kind = body!.kind === 'proxy' ? 'proxy' : body!.kind === 'timed' ? 'timed' : null;
  const sections = parseSections(body!.sections);
  const canWrite = body!.canWrite === true;
  if (!email || !kind || !sections) return jsonError(res, 400, 'Invalid grant');
  if (email === jwtUser.email) return jsonError(res, 400, 'Cannot share with yourself');

  let expiresAt: string | null = null;
  if (kind === 'timed') {
    const hours = Number(body!.hours);
    const allowed = [24, 24 * 7, 24 * 30, 24 * 90];
    if (!allowed.includes(hours)) return jsonError(res, 400, 'Invalid duration');
    expiresAt = new Date(Date.now() + hours * 3600 * 1000).toISOString();
  }

  const found = await client.query(`SELECT id::text FROM users WHERE email = $1`, [email]);
  const granteeUserId = found.rows[0]?.id || null;
  const { rows } = await client.query(
    `INSERT INTO care_grants
       (file_id, grantee_user_id, grantee_email, kind, can_write, sections, status, expires_at, created_by_user_id)
     VALUES ($1,$2,$3,$4,$5,$6,'pending',$7,$8)
     RETURNING id::text, file_id::text, grantee_email, kind, can_write, sections, status,
               expires_at, accepted_at, revoked_at, created_at`,
    [actor.fileId, granteeUserId, email, kind, canWrite, sections, expiresAt, jwtUser.id]
  );
  const grantId = rows[0].id;
  await enqueueCareGrantInvite(client, {
    ownerEmail: jwtUser.email,
    granteeEmail: email,
    granteeUserId,
    acceptUrl: `${appUrl()}/care?grant=${grantId}`,
    kind,
  });
  await processOutbox(client, 10, { kind: 'care_grant_invite' });
  await writeAudit(client, actor, 'grant_create', null, grantId);
  return res.status(201).json({ item: mapGrant(rows[0]) });
}

async function handleGrantsAccept(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  if (req.method !== 'POST') return jsonError(res, 405, 'Method not allowed');
  if (!originAllowed(req)) return jsonError(res, 403, 'Forbidden');
  const body = parseJsonBody(req);
  if (!body || !isUuid(body.id)) return jsonError(res, 400, 'id is required');
  const { rows } = await client.query(
    `SELECT g.id::text, g.file_id::text, g.grantee_email, g.status, g.revoked_at, g.kind, g.expires_at,
            f.owner_id::text, u.email AS owner_email
       FROM care_grants g
       JOIN care_files f ON f.id = g.file_id
       JOIN users u ON u.id = f.owner_id
      WHERE g.id = $1`,
    [body.id]
  );
  const row = rows[0];
  if (!row || row.grantee_email !== jwtUser.email) return jsonError(res, 404, 'Not found');
  if (row.status === 'revoked' || row.revoked_at) return jsonError(res, 403, 'Forbidden');
  if (row.kind === 'timed' && row.expires_at && new Date(row.expires_at).getTime() <= Date.now()) {
    return jsonError(res, 403, 'Expired');
  }
  await client.query(
    `UPDATE care_grants SET status = 'active', accepted_at = now(), grantee_user_id = $2
      WHERE id = $1 AND status = 'pending'`,
    [row.id, jwtUser.id]
  );
  await enqueueCareGrantAccepted(client, {
    ownerUserId: row.owner_id,
    ownerEmail: row.owner_email,
    granteeEmail: jwtUser.email,
  });
  await processOutbox(client, 10, { kind: 'care_grant_accepted' });
  await writeAudit(
    client,
    {
      fileId: row.file_id,
      actorUserId: jwtUser.id,
      actorKind: 'grantee',
    },
    'grant_accept',
    null,
    row.id
  );
  return res.status(200).json({ ok: true, fileId: row.file_id });
}

async function handleGrantsRevoke(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  if (req.method !== 'POST') return jsonError(res, 405, 'Method not allowed');
  if (!originAllowed(req)) return jsonError(res, 403, 'Forbidden');
  const body = parseJsonBody(req);
  if (!body || !isUuid(body.id)) return jsonError(res, 400, 'id is required');
  const { rows } = await client.query(
    `SELECT g.id::text, g.file_id::text, g.grantee_email, g.grantee_user_id::text, f.owner_id::text
       FROM care_grants g JOIN care_files f ON f.id = g.file_id
      WHERE g.id = $1`,
    [body.id]
  );
  const row = rows[0];
  if (!row || row.owner_id !== jwtUser.id) return jsonError(res, 404, 'Not found');
  await client.query(
    `UPDATE care_grants SET status = 'revoked', revoked_at = now() WHERE id = $1 AND status <> 'revoked'`,
    [row.id]
  );
  await enqueueCareGrantRevoked(client, {
    ownerUserId: jwtUser.id,
    ownerEmail: jwtUser.email,
    granteeEmail: row.grantee_email,
    granteeUserId: row.grantee_user_id,
  });
  await processOutbox(client, 10, { kind: 'care_grant_revoked' });
  await writeAudit(
    client,
    { fileId: row.file_id, actorUserId: jwtUser.id, actorKind: 'owner' },
    'grant_revoke',
    null,
    row.id
  );
  return res.status(200).json({ ok: true });
}

async function handleLinks(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  const body = req.method === 'GET' ? {} : parseJsonBody(req);
  if (req.method !== 'GET' && !body) return jsonError(res, 400, 'Invalid JSON');
  const actor = await requireActor(req, res, client, jwtUser, body, null, false);
  if (!actor) return null;
  if (actor.actorKind !== 'owner') return jsonError(res, 403, 'Forbidden');

  if (req.method === 'GET') {
    const { rows } = await client.query(
      `SELECT id::text, sections, expires_at, revoked_at, created_at, last_viewed_at
         FROM care_share_links WHERE file_id = $1 ORDER BY created_at DESC`,
      [actor.fileId]
    );
    return res.status(200).json({
      items: rows.map((r) => ({
        id: r.id,
        sections: r.sections,
        expiresAt: isoTs(r.expires_at),
        revokedAt: isoTs(r.revoked_at),
        createdAt: isoTs(r.created_at),
        lastViewedAt: isoTs(r.last_viewed_at),
        active: !r.revoked_at && new Date(r.expires_at).getTime() > Date.now(),
      })),
    });
  }

  if (req.method !== 'POST') return jsonError(res, 405, 'Method not allowed');
  if (!originAllowed(req)) return jsonError(res, 403, 'Forbidden');
  if (!rateLimit(`care-link:${jwtUser.id}`, 20, 60 * 60 * 1000)) {
    return jsonError(res, 429, 'Too many attempts');
  }
  const sections = parseSections(body!.sections);
  const hours = Number(body!.hours);
  if (!sections || ![24, 24 * 7, 24 * 30].includes(hours)) return jsonError(res, 400, 'Invalid link');
  const raw = newRawToken();
  const expiresAt = new Date(Date.now() + hours * 3600 * 1000).toISOString();
  const { rows } = await client.query(
    `INSERT INTO care_share_links (file_id, token_hash, sections, expires_at, created_by_user_id)
     VALUES ($1,$2,$3,$4,$5)
     RETURNING id::text, sections, expires_at, created_at`,
    [actor.fileId, hashToken(raw), sections, expiresAt, jwtUser.id]
  );
  await writeAudit(client, actor, 'link_create', null, rows[0].id);
  return res.status(201).json({
    item: {
      id: rows[0].id,
      sections: rows[0].sections,
      expiresAt: isoTs(rows[0].expires_at),
      createdAt: isoTs(rows[0].created_at),
    },
    url: `${appUrl()}/care-share?t=${encodeURIComponent(raw)}`,
  });
}

async function handleLinksRevoke(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  if (req.method !== 'POST') return jsonError(res, 405, 'Method not allowed');
  if (!originAllowed(req)) return jsonError(res, 403, 'Forbidden');
  const body = parseJsonBody(req);
  if (!body || !isUuid(body.id)) return jsonError(res, 400, 'id is required');
  const { rows } = await client.query(
    `SELECT l.id::text, l.file_id::text, f.owner_id::text
       FROM care_share_links l JOIN care_files f ON f.id = l.file_id
      WHERE l.id = $1`,
    [body.id]
  );
  if (!rows[0] || rows[0].owner_id !== jwtUser.id) return jsonError(res, 404, 'Not found');
  await client.query(`UPDATE care_share_links SET revoked_at = now() WHERE id = $1 AND revoked_at IS NULL`, [
    rows[0].id,
  ]);
  await writeAudit(
    client,
    { fileId: rows[0].file_id, actorUserId: jwtUser.id, actorKind: 'owner' },
    'link_revoke',
    null,
    rows[0].id
  );
  return res.status(200).json({ ok: true });
}

async function loadSharePayload(client: Client, actor: CareActor) {
  const out: Record<string, unknown> = {
    sections: actor.sections,
    ownerLabel: 'תיק משותף',
  };
  if (canReadSection(actor, 'timeline')) {
    const { rows } = await client.query(
      `SELECT ${ENCOUNTER_SELECT}
         FROM care_encounters e
         LEFT JOIN care_contacts c ON c.id = e.contact_id
         LEFT JOIN care_contacts o ON o.id = e.org_id
        WHERE e.file_id = $1
        ORDER BY e.occurred_on DESC`,
      [actor.fileId]
    );
    out.encounters = rows.map((r) => ({ ...mapEncounter(r), mine: false }));
  }
  if (canReadSection(actor, 'documents')) {
    const { rows } = await client.query(
      `SELECT id::text, original_filename, content_type, byte_size, encounter_id::text, lab_panel_id::text, kind, created_at
         FROM care_documents WHERE file_id = $1 AND kind = 'other' ORDER BY created_at DESC`,
      [actor.fileId]
    );
    out.documents = rows.map((r) => mapDocument(r, '', false));
  }
  if (canReadSection(actor, 'medications')) {
    const { rows } = await client.query(
      `SELECT id::text, name, dose, schedule, started_on, ended_on, notes, status, prescriber, efficacy, created_at, updated_at
         FROM care_medications WHERE file_id = $1 ORDER BY CASE status WHEN 'current' THEN 0 WHEN 'recommended' THEN 1 ELSE 2 END, created_at DESC`,
      [actor.fileId]
    );
    out.medications = rows.map((r) => mapMedication(r, '', false));
  }
  if (canReadSection(actor, 'contacts')) {
    const { rows } = await client.query(
      `SELECT ${CONTACT_SELECT}
         FROM care_contacts c
         LEFT JOIN care_contacts o ON o.id = c.org_id
         LEFT JOIN care_contacts r ON r.id = c.referred_by_id
        WHERE c.file_id = $1
        ORDER BY c.kind ASC, c.name ASC`,
      [actor.fileId]
    );
    out.contacts = rows.map((r) => mapContact(r, '', false));
  }
  if (canReadSection(actor, 'notes')) {
    const { rows } = await client.query(
      `SELECT id::text, body, created_at, updated_at FROM care_notes WHERE file_id = $1 ORDER BY created_at DESC`,
      [actor.fileId]
    );
    out.notes = rows.map((r) => mapNote(r, '', false));
  }
  if (canReadSection(actor, 'rights')) {
    const rights = await client.query(
      `SELECT id::text, kind, status, percent_a, percent_b, valid_until, summary, notes, created_at, updated_at
         FROM care_rights WHERE file_id = $1 ORDER BY created_at DESC`,
      [actor.fileId]
    );
    out.rights = rights.rows.map((r) => ({
      kind: r.kind,
      status: r.status,
      percentA: r.percent_a || '',
      percentB: r.percent_b || '',
      validUntil: isoDate(r.valid_until),
      summary: r.summary || '',
      notes: r.notes || '',
    }));
    const committees = await client.query(
      `SELECT id::text, body, title, scheduled_on, scheduled_time, place, status, notes, created_at
         FROM care_committees WHERE file_id = $1 ORDER BY scheduled_on ASC`,
      [actor.fileId]
    );
    out.committees = committees.rows.map((r) => ({
      body: r.body,
      title: r.title,
      scheduledOn: isoDate(r.scheduled_on),
      scheduledTime: r.scheduled_time || '',
      place: r.place || '',
      status: r.status,
      notes: r.notes || '',
    }));
  }
  if (canReadSection(actor, 'profile')) {
    const profile = await client.query(`SELECT * FROM care_profile WHERE file_id = $1`, [actor.fileId]);
    out.profile = profileForActor(profile.rows[0] || null, actor);
    const hmo = await client.query(
      `SELECT id::text, hmo, started_on, ended_on, notes FROM care_hmo_history WHERE file_id = $1 ORDER BY started_on DESC NULLS LAST`,
      [actor.fileId]
    );
    out.hmoHistory = hmo.rows.map((r) => ({
      hmo: r.hmo,
      startedOn: isoDate(r.started_on),
      endedOn: isoDate(r.ended_on),
      notes: r.notes || '',
    }));
  }
  if (canReadSection(actor, 'family')) {
    const { rows } = await client.query(
      `SELECT id::text, name, relation, phone, email, lives_with, involved, notes FROM care_family WHERE file_id = $1 ORDER BY created_at DESC`,
      [actor.fileId]
    );
    out.family = rows.map((r) => ({
      name: r.name,
      relation: r.relation || '',
      phone: r.phone || '',
      email: r.email || '',
      livesWith: Boolean(r.lives_with),
      involved: Boolean(r.involved),
      notes: r.notes || '',
    }));
  }
  if (canReadSection(actor, 'diagnoses')) {
    const { rows } = await client.query(
      `SELECT id::text, name, code, diagnosed_on, diagnosed_by, status, notes FROM care_diagnoses WHERE file_id = $1 ORDER BY diagnosed_on DESC NULLS LAST`,
      [actor.fileId]
    );
    out.diagnoses = rows.map((r) => ({
      name: r.name,
      code: r.code || '',
      diagnosedOn: isoDate(r.diagnosed_on),
      diagnosedBy: r.diagnosed_by || '',
      status: r.status,
      notes: r.notes || '',
    }));
  }
  if (canReadSection(actor, 'therapy')) {
    const { rows } = await client.query(
      `SELECT id::text, modality, therapist_name, started_on, ended_on, frequency, notes FROM care_therapy WHERE file_id = $1 ORDER BY started_on DESC NULLS LAST`,
      [actor.fileId]
    );
    out.therapy = rows.map((r) => ({
      modality: r.modality || '',
      therapistName: r.therapist_name,
      startedOn: isoDate(r.started_on),
      endedOn: isoDate(r.ended_on),
      frequency: r.frequency || '',
      notes: r.notes || '',
    }));
  }
  if (canReadSection(actor, 'activity')) {
    const { rows } = await client.query(
      `SELECT id::text, kind, name, frequency, started_on, notes FROM care_activities WHERE file_id = $1 ORDER BY created_at DESC`,
      [actor.fileId]
    );
    out.activities = rows.map((r) => ({
      kind: r.kind,
      name: r.name,
      frequency: r.frequency || '',
      startedOn: isoDate(r.started_on),
      notes: r.notes || '',
    }));
  }
  if (canReadSection(actor, 'intake')) {
    const intake = await client.query(`SELECT * FROM care_intake WHERE file_id = $1`, [actor.fileId]);
    out.intake = mapIntake(intake.rows[0] || null);
  }
  if (canReadSection(actor, 'labs')) {
    const results = await client.query(
      `SELECT id::text, panel_id::text, marker, custom_name, value, unit, flag, measured_on, notes, created_at
         FROM care_lab_results WHERE file_id = $1 ORDER BY measured_on DESC, created_at DESC`,
      [actor.fileId]
    );
    const items = results.rows.map((r) => mapLabResult(r, '', false));
    out.labResults = items;
    out.labCurrent = latestLabs(items);
    const panels = await client.query(
      `SELECT id::text, drawn_on, lab_name, notes FROM care_lab_panels WHERE file_id = $1 ORDER BY drawn_on DESC`,
      [actor.fileId]
    );
    out.labPanels = panels.rows.map((r) => ({
      id: r.id,
      drawnOn: isoDate(r.drawn_on),
      labName: r.lab_name || '',
      notes: r.notes || '',
    }));
    const files = await client.query(
      `SELECT id::text, original_filename, content_type, byte_size, lab_panel_id::text, kind, created_at
         FROM care_documents WHERE file_id = $1 AND kind = 'lab' ORDER BY created_at DESC`,
      [actor.fileId]
    );
    out.labFiles = files.rows.map((r) => mapDocument(r, '', false));
  }
  return out;
}

async function handleShare(req: VercelRequest, res: VercelResponse, client: Client) {
  if (req.method !== 'GET') return jsonError(res, 405, 'Method not allowed');
  const ip = clientKey(req);
  if (!rateLimit(`care-share:${ip}`, 60, 15 * 60 * 1000)) {
    return jsonError(res, 429, 'Too many attempts');
  }
  const token = q(req, 't');
  if (!token || token.length < 16) return jsonError(res, 400, 'Invalid link');
  const actor = await resolveShareAccess(client, token);
  if (!actor) return jsonError(res, 403, 'Forbidden');
  const payload = await loadSharePayload(client, actor);
  await writeAudit(client, actor, 'link_view', null, actor.linkId);
  return res.status(200).json(payload);
}

async function handleShareDocument(req: VercelRequest, res: VercelResponse, client: Client) {
  if (req.method !== 'GET') return jsonError(res, 405, 'Method not allowed');
  const ip = clientKey(req);
  if (!rateLimit(`care-share-dl:${ip}`, 30, 15 * 60 * 1000)) {
    return jsonError(res, 429, 'Too many attempts');
  }
  const token = q(req, 't');
  const id = q(req, 'id');
  if (!token || !isUuid(id)) return jsonError(res, 400, 'Invalid link');
  if (!fileEncryptionConfigured()) return jsonError(res, 500, 'Server misconfiguration');
  const actor = await resolveShareAccess(client, token);
  if (!actor) return jsonError(res, 403, 'Forbidden');
  const { rows } = await client.query(
    `SELECT original_filename, content_type, ciphertext, nonce, storage_key, kind
       FROM care_documents WHERE id = $1 AND file_id = $2`,
    [id, actor.fileId]
  );
  if (!rows[0]) return jsonError(res, 404, 'Not found');
  const section: CareSection = rows[0].kind === 'lab' ? 'labs' : 'documents';
  if (!canReadSection(actor, section)) return jsonError(res, 403, 'Forbidden');
  const ciphertext = await storedCiphertext(rows[0]);
  const nonce = asBuffer(rows[0].nonce);
  if (!ciphertext || !nonce) return jsonError(res, 500, 'Failed');
  const plain = decryptFile(ciphertext, nonce);
  await writeAudit(client, actor, 'download', rows[0].kind === 'lab' ? 'labs' : 'documents', id);
  return res.status(200).json({
    filename: rows[0].original_filename,
    contentType: rows[0].content_type,
    dataBase64: plain.toString('base64'),
  });
}

async function handleAudit(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  if (req.method !== 'GET') return jsonError(res, 405, 'Method not allowed');
  const actor = await requireActor(req, res, client, jwtUser, {}, null, false);
  if (!actor) return null;
  if (actor.actorKind !== 'owner') return jsonError(res, 403, 'Forbidden');
  const { rows } = await client.query(
    `SELECT a.id::text, a.actor_kind, a.action, a.section, a.item_id::text, a.created_at, u.email
       FROM care_audit_events a
       LEFT JOIN users u ON u.id = a.actor_user_id
      WHERE a.file_id = $1
      ORDER BY a.created_at DESC
      LIMIT 200`,
    [actor.fileId]
  );
  return res.status(200).json({
    items: rows.map((r) => ({
      id: r.id,
      actorKind: r.actor_kind,
      action: r.action,
      section: r.section,
      itemId: r.item_id,
      createdAt: isoTs(r.created_at),
      actorEmail: r.email || null,
    })),
  });
}

async function handleInbox(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  if (req.method !== 'GET') return jsonError(res, 405, 'Method not allowed');
  const { rows } = await client.query(
    `SELECT g.id::text, g.file_id::text, g.grantee_email, g.kind, g.can_write, g.sections, g.status,
            g.expires_at, g.accepted_at, g.revoked_at, g.created_at, u.email AS owner_email
       FROM care_grants g
       JOIN care_files f ON f.id = g.file_id
       JOIN users u ON u.id = f.owner_id
      WHERE g.grantee_email = $1
        AND g.revoked_at IS NULL
        AND g.status IN ('pending', 'active')
        AND (g.kind = 'proxy' OR g.expires_at > now())
      ORDER BY g.created_at DESC`,
    [jwtUser.email]
  );
  return res.status(200).json({ items: rows.map(mapGrant) });
}

async function handleDeleteFile(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  if (req.method !== 'POST') return jsonError(res, 405, 'Method not allowed');
  if (!originAllowed(req)) return jsonError(res, 403, 'Forbidden');
  if (!rateLimit(`care-file-delete:${jwtUser.id}`, 5, 60 * 60 * 1000)) {
    return jsonError(res, 429, 'Too many attempts');
  }
  const body = parseJsonBody(req);
  if (!body || body.confirm !== true) return jsonError(res, 400, 'Confirmation required');
  const actor = await requireActor(req, res, client, jwtUser, body, null, false);
  if (!actor) return null;
  if (actor.actorKind !== 'owner') return jsonError(res, 403, 'Forbidden');
  const stored = await client.query(
    `SELECT storage_key FROM care_documents WHERE file_id = $1 AND storage_key IS NOT NULL`,
    [actor.fileId]
  );
  const deleted = await client.query(
    `DELETE FROM care_files WHERE id = $1 AND owner_id = $2 RETURNING id`,
    [actor.fileId, jwtUser.id]
  );
  if (deleted.rows[0]) {
    const keys = stored.rows
      .map((r) => (typeof r.storage_key === 'string' ? r.storage_key : ''))
      .filter((key) => key.length > 0);
    await removeStoredObjects(keys);
  }
  return res.status(200).json({ ok: true });
}

async function handleExport(req: VercelRequest, res: VercelResponse, client: Client, jwtUser: JwtUser) {
  if (req.method !== 'GET') return jsonError(res, 405, 'Method not allowed');
  if (!rateLimit(`care-export:${jwtUser.id}`, 10, 60 * 60 * 1000)) {
    return jsonError(res, 429, 'Too many attempts');
  }
  const actor = await requireActor(req, res, client, jwtUser, {}, null, false);
  if (!actor) return null;
  if (actor.actorKind !== 'owner') return jsonError(res, 403, 'Forbidden');
  const payload = await loadSharePayload(client, actor);
  payload.exportedAt = new Date().toISOString();
  payload.ownerEmail = actor.ownerEmail;
  await writeAudit(client, actor, 'export', null, null);
  return res.status(200).json(payload);
}

const STEPUP_ACTIONS = new Set([
  'bootstrap',
  'encounters',
  'documents',
  'document-download',
  'medications',
  'contacts',
  'notes',
  'rights',
  'committees',
  'profile',
  'hmo-history',
  'family',
  'diagnoses',
  'therapy',
  'activities',
  'intake',
  'lab-results',
  'lab-panels',
  'grants',
  'grants-accept',
  'grants-revoke',
  'links',
  'links-revoke',
  'audit',
  'inbox',
  'export',
  'file-delete',
]);

export default async function handler(req: VercelRequest, res: VercelResponse) {
  res.setHeader('Cache-Control', 'private, no-store');
  res.setHeader('Referrer-Policy', 'no-referrer');
  const action = actionName(req);
  const publicAction = action === 'share' || action === 'share-document';
  if (!publicAction) {
    setAuthCors(req, res);
    if (req.method === 'OPTIONS') return res.status(204).end();
  }

  if (!process.env.DATABASE_URL) return jsonError(res, 500, 'Server misconfiguration');

  const client = pgClient();
  try {
    await client.connect();

    if (action === 'share') return await handleShare(req, res, client);
    if (action === 'share-document') return await handleShareDocument(req, res, client);

    const jwtUser = await requireUser(req, res, client);
    if (!jwtUser) return;

    if (action === 'otp-request') return await handleOtpRequest(req, res, client, jwtUser);
    if (action === 'otp-verify') return await handleOtpVerify(req, res, client, jwtUser);

    if (STEPUP_ACTIONS.has(action) && action !== 'bootstrap') {
      if (!(await requireStepup(req, res, jwtUser))) return;
    }

    switch (action) {
      case 'bootstrap':
        return await handleBootstrap(req, res, client, jwtUser);
      case 'encounters':
        if (!(await requireStepup(req, res, jwtUser))) return;
        return await handleEncounters(req, res, client, jwtUser);
      case 'documents':
        return await handleDocuments(req, res, client, jwtUser);
      case 'document-download':
        return await handleDocumentDownload(req, res, client, jwtUser);
      case 'medications':
        return await handleMedications(req, res, client, jwtUser);
      case 'contacts':
        return await handleContacts(req, res, client, jwtUser);
      case 'notes':
        return await handleNotes(req, res, client, jwtUser);
      case 'rights':
        return await handleRights(req, res, client, jwtUser);
      case 'committees':
        return await handleCommittees(req, res, client, jwtUser);
      case 'profile':
        return await handleProfile(req, res, client, jwtUser);
      case 'hmo-history':
        return await handleHmoHistory(req, res, client, jwtUser);
      case 'family':
        return await handleFamily(req, res, client, jwtUser);
      case 'diagnoses':
        return await handleDiagnoses(req, res, client, jwtUser);
      case 'therapy':
        return await handleTherapy(req, res, client, jwtUser);
      case 'activities':
        return await handleActivities(req, res, client, jwtUser);
      case 'intake':
        return await handleIntake(req, res, client, jwtUser);
      case 'lab-results':
        return await handleLabResults(req, res, client, jwtUser);
      case 'lab-panels':
        return await handleLabPanels(req, res, client, jwtUser);
      case 'grants':
        return await handleGrants(req, res, client, jwtUser);
      case 'grants-accept':
        return await handleGrantsAccept(req, res, client, jwtUser);
      case 'grants-revoke':
        return await handleGrantsRevoke(req, res, client, jwtUser);
      case 'links':
        return await handleLinks(req, res, client, jwtUser);
      case 'links-revoke':
        return await handleLinksRevoke(req, res, client, jwtUser);
      case 'audit':
        return await handleAudit(req, res, client, jwtUser);
      case 'inbox':
        return await handleInbox(req, res, client, jwtUser);
      case 'export':
        return await handleExport(req, res, client, jwtUser);
      case 'file-delete':
        return await handleDeleteFile(req, res, client, jwtUser);
      default:
        return jsonError(res, 404, 'Not found');
    }
  } catch (err) {
    const code = (err as { code?: string }).code;
    if (code === '42P01' || code === '42703') {
      console.error('care tables missing', err);
      return jsonError(res, 503, 'Care file is not available yet');
    }
    console.error('care error', action, err);
    return jsonError(res, 500, 'Failed');
  } finally {
    await client.end().catch(() => {});
  }
}
