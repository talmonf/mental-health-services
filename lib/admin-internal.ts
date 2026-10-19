/**
 * Internal admin resources: audit log, card verification, related contacts, the Google
 * Contacts connection and glossary-card links. Routed from api/admin/[resource].ts so they
 * share its Serverless Function. Nothing here is published on the public site except
 * approved glossary links, which /api/directory-cards reads directly.
 */
import type { VercelRequest, VercelResponse } from '@vercel/node';
import type { Client } from 'pg';
import {
  clearOAuthCookie,
  getAuthFromRequest,
  getOAuthStateFromRequest,
  originAllowed,
  parseJsonBody,
  setOAuthCookie,
  signOAuthState,
  type JwtUser,
} from './auth';
import { appUrl, pgClient } from './db';
import { cardCompleteness } from './card-completeness';
import {
  connectionStatus,
  contactsAuthorizeUrl,
  contactsConfigured,
  contactUrlFor,
  encryptToken,
  exchangeContactsCode,
  getContact,
  GoogleContactsError,
  resourceNameFromInput,
  searchContacts,
  type ContactRecord,
} from './google-contacts';
import { codeChallenge, newCodeVerifier, newOAuthState } from './google-oauth';
import { userIsAdmin } from './users';

const AUDIT_AREAS = ['cards', 'glossary', 'ui', 'admin', 'data'] as const;
const LINK_STATUSES = ['suggested', 'approved', 'rejected'] as const;

class InputError extends Error {}

function qstr(req: VercelRequest, key: string): string {
  const raw = req.query[key];
  const v = typeof raw === 'string' ? raw : Array.isArray(raw) ? raw[0] || '' : '';
  return v.trim();
}

function positiveInt(raw: unknown): number | null {
  const s = typeof raw === 'number' && Number.isFinite(raw) ? String(Math.trunc(raw)) : typeof raw === 'string' ? raw.trim() : '';
  if (!/^\d+$/.test(s)) return null;
  const n = Number(s);
  return Number.isSafeInteger(n) && n >= 1 && n <= 2147483647 ? n : null;
}

function str(raw: unknown, max: number): string {
  return typeof raw === 'string' ? raw.trim().slice(0, max) : '';
}

function isYmd(v: string): boolean {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(v)) return false;
  const d = new Date(`${v}T00:00:00Z`);
  return !Number.isNaN(d.getTime()) && d.toISOString().slice(0, 10) === v;
}

function iso(value: unknown): string | null {
  if (value == null || value === '') return null;
  return value instanceof Date ? value.toISOString() : String(value);
}

function pgCode(err: unknown): string {
  return err && typeof err === 'object' && 'code' in err ? String((err as { code?: string }).code) : '';
}

/** Connects, checks the session is an admin, runs fn, and maps the common failures. */
async function withAdmin(
  req: VercelRequest,
  res: VercelResponse,
  migration: string,
  fn: (client: Client, user: JwtUser) => Promise<unknown>
) {
  if (req.method !== 'GET' && req.method !== 'OPTIONS' && !originAllowed(req)) {
    return res.status(403).json({ error: 'Forbidden' });
  }
  if (!process.env.DATABASE_URL) return res.status(500).json({ error: 'Server misconfiguration' });
  const user = await getAuthFromRequest(req);
  if (!user) return res.status(401).json({ error: 'Unauthorized' });
  const client = pgClient();
  try {
    await client.connect();
    if (!(await userIsAdmin(client, user.id))) return res.status(403).json({ error: 'Forbidden' });
    return await fn(client, user);
  } catch (err) {
    if (err instanceof InputError) return res.status(400).json({ error: err.message });
    if (err instanceof GoogleContactsError) return res.status(err.status).json({ error: err.message });
    if (pgCode(err) === '42P01') {
      return res.status(500).json({ error: `הטבלה עדיין לא הותקנה. הריצו את סקריפט ${migration}.` });
    }
    console.error(`admin ${String(req.query.resource || '')} error`, err);
    return res.status(500).json({ error: 'הבקשה נכשלה' });
  } finally {
    await client.end().catch(() => {});
  }
}

/* ---------- Audit log ---------- */

type AuditInput = {
  title: string;
  description: string;
  area: string;
  happenedAt: string;
  cardKeys: string[];
  termKeys: string[];
  migration: string | null;
};

async function cardKeysFrom(client: Client, body: Record<string, unknown>): Promise<string[]> {
  const keys = new Set<string>();
  if (Array.isArray(body.cardKeys)) {
    body.cardKeys.forEach((k) => {
      if (typeof k === 'string' && k.trim()) keys.add(k.trim().slice(0, 800));
    });
  }
  const rows = Array.isArray(body.cardRows) ? body.cardRows.map(positiveInt).filter((n): n is number => n != null) : [];
  if (rows.length) {
    const found = await client.query(`SELECT card_key, row_id FROM directory_card_edits WHERE row_id = ANY($1::int[])`, [rows]);
    const seen = new Set(found.rows.map((r) => Number(r.row_id)));
    const missing = rows.filter((n) => !seen.has(n));
    if (missing.length) throw new InputError(`לא נמצאו כרטיסים בשורות: ${missing.join(', ')}`);
    found.rows.forEach((r) => keys.add(String(r.card_key)));
  }
  return [...keys].slice(0, 400);
}

async function auditInput(client: Client, body: Record<string, unknown>): Promise<AuditInput> {
  const title = str(body.title, 200);
  const description = str(body.description, 8000);
  const area = str(body.area, 20);
  const happenedAt = str(body.happenedAt, 10);
  if (!title) throw new InputError('חסרה כותרת');
  if (!description) throw new InputError('חסר תיאור');
  if (!(AUDIT_AREAS as readonly string[]).includes(area)) throw new InputError('תחום לא תקין');
  if (!isYmd(happenedAt)) throw new InputError('תאריך לא תקין');
  const termKeys = Array.isArray(body.termKeys)
    ? [...new Set(body.termKeys.filter((k): k is string => typeof k === 'string' && /^[a-z0-9_]{1,80}$/.test(k)))]
    : [];
  return {
    title,
    description,
    area,
    happenedAt,
    cardKeys: await cardKeysFrom(client, body),
    termKeys,
    migration: str(body.migration, 120) || null,
  };
}

function auditSelect(withHidden: boolean): string {
  const hiddenField = withHidden ? `, 'hidden', c.hidden` : '';
  return `
  SELECT e.id, e.entry_key, e.happened_at::text AS happened_at, e.title, e.description, e.area,
         e.card_keys, e.term_keys, e.migration, e.created_at, e.updated_at,
         coalesce((
           SELECT json_agg(json_build_object(
                    'id', c.id, 'rowId', c.row_id, 'cardKey', c.card_key,
                    'org', coalesce(c.public_fields->>'org', ''), 'svc', coalesce(c.public_fields->>'svc', '')${hiddenField})
                  ORDER BY c.row_id, c.id)
             FROM directory_card_edits c
            WHERE c.card_key = ANY(e.card_keys)
         ), '[]'::json) AS cards
    FROM site_audit_entries e`;
}

async function hiddenColumnInstalled(client: Client): Promise<boolean> {
  const { rows } = await client.query(
    `SELECT 1 FROM information_schema.columns
      WHERE table_name = 'directory_card_edits' AND column_name = 'hidden'`
  );
  return rows.length > 0;
}

function auditFromRow(row: Record<string, unknown>) {
  return {
    id: Number(row.id),
    entryKey: row.entry_key == null ? null : String(row.entry_key),
    happenedAt: String(row.happened_at || ''),
    title: String(row.title || ''),
    description: String(row.description || ''),
    area: String(row.area || ''),
    cardKeys: Array.isArray(row.card_keys) ? row.card_keys : [],
    termKeys: Array.isArray(row.term_keys) ? row.term_keys : [],
    migration: row.migration == null ? null : String(row.migration),
    cards: Array.isArray(row.cards) ? row.cards : [],
    createdAt: iso(row.created_at),
    updatedAt: iso(row.updated_at),
  };
}

export async function handleAudit(req: VercelRequest, res: VercelResponse) {
  if (!['GET', 'POST', 'PATCH'].includes(req.method || '')) return res.status(405).json({ error: 'Method not allowed' });
  return withAdmin(req, res, '062', async (client, user) => {
    const select = auditSelect(await hiddenColumnInstalled(client));
    if (req.method === 'GET') {
      const params: unknown[] = [];
      const where: string[] = [];
      const area = qstr(req, 'area');
      if ((AUDIT_AREAS as readonly string[]).includes(area)) {
        params.push(area);
        where.push(`e.area = $${params.length}`);
      }
      const card = positiveInt(qstr(req, 'card'));
      if (card != null) {
        params.push(card);
        where.push(`e.card_keys && ARRAY(SELECT card_key FROM directory_card_edits WHERE id = $${params.length})`);
      }
      const from = qstr(req, 'from');
      if (isYmd(from)) {
        params.push(from);
        where.push(`e.happened_at >= $${params.length}::date`);
      }
      const to = qstr(req, 'to');
      if (isYmd(to)) {
        params.push(to);
        where.push(`e.happened_at <= $${params.length}::date`);
      }
      const { rows } = await client.query(
        `${select} ${where.length ? `WHERE ${where.join(' AND ')}` : ''}
          ORDER BY e.happened_at DESC, e.id DESC
          LIMIT 500`,
        params
      );
      return res.status(200).json({ entries: rows.map(auditFromRow) });
    }

    const body = parseJsonBody(req);
    if (!body) throw new InputError('Invalid JSON');
    const input = await auditInput(client, body);
    if (req.method === 'POST') {
      const inserted = await client.query(
        `INSERT INTO site_audit_entries (happened_at, title, description, area, card_keys, term_keys, migration, created_by)
         VALUES ($1::date, $2, $3, $4, $5::text[], $6::text[], $7, $8)
         RETURNING id`,
        [input.happenedAt, input.title, input.description, input.area, input.cardKeys, input.termKeys, input.migration, user.id]
      );
      const { rows } = await client.query(`${select} WHERE e.id = $1`, [inserted.rows[0].id]);
      return res.status(201).json({ entry: auditFromRow(rows[0]) });
    }
    const id = positiveInt(body.id);
    if (id == null) throw new InputError('Invalid id');
    const updated = await client.query(
      `UPDATE site_audit_entries
          SET happened_at = $2::date, title = $3, description = $4, area = $5,
              card_keys = $6::text[], term_keys = $7::text[], migration = $8, updated_at = now()
        WHERE id = $1
        RETURNING id`,
      [id, input.happenedAt, input.title, input.description, input.area, input.cardKeys, input.termKeys, input.migration]
    );
    if (!updated.rows[0]) return res.status(404).json({ error: 'Not found' });
    const { rows } = await client.query(`${select} WHERE e.id = $1`, [id]);
    return res.status(200).json({ entry: auditFromRow(rows[0]) });
  });
}

/* ---------- Contacts ---------- */

function contactFromRow(row: Record<string, unknown>) {
  return {
    id: Number(row.id),
    resourceName: row.resource_name == null ? null : String(row.resource_name),
    displayName: String(row.display_name || ''),
    email: String(row.email || ''),
    phone: String(row.phone || ''),
    organization: String(row.organization || ''),
    contactUrl: String(row.contact_url || ''),
    syncedAt: iso(row.synced_at),
  };
}

const CONTACT_COLUMNS = 'id, resource_name, display_name, email, phone, organization, contact_url, synced_at';

/**
 * Saves a contact from a Google search result, a pasted contacts.google.com URL, or typed
 * details. When Google is connected and the id is known, the stored copy is refreshed from Google.
 */
async function upsertContact(client: Client, raw: unknown) {
  const src = (raw && typeof raw === 'object' ? raw : {}) as Record<string, unknown>;
  const resourceName = resourceNameFromInput(str(src.resourceName, 200) || str(src.url, 500));
  if (str(src.url, 500) && !resourceName) throw new InputError('הקישור אינו קישור לאיש קשר ב-contacts.google.com');

  let record: ContactRecord | null = null;
  if (resourceName && (await connectionStatus(client)).connected) {
    record = await getContact(client, resourceName);
  }
  const displayName = record?.displayName || str(src.displayName, 200);
  if (!displayName) throw new InputError('חסר שם איש קשר');
  const values = [
    resourceName,
    displayName,
    record?.email ?? str(src.email, 320),
    record?.phone ?? str(src.phone, 60),
    record?.organization ?? str(src.organization, 200),
    resourceName ? contactUrlFor(resourceName) : '',
    record ? new Date() : null,
  ];
  if (resourceName) {
    const { rows } = await client.query(
      `INSERT INTO google_contacts (resource_name, display_name, email, phone, organization, contact_url, synced_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       ON CONFLICT (resource_name) DO UPDATE
         SET display_name = EXCLUDED.display_name, email = EXCLUDED.email, phone = EXCLUDED.phone,
             organization = EXCLUDED.organization, contact_url = EXCLUDED.contact_url,
             synced_at = coalesce(EXCLUDED.synced_at, google_contacts.synced_at)
       RETURNING ${CONTACT_COLUMNS}`,
      values
    );
    return contactFromRow(rows[0]);
  }
  const { rows } = await client.query(
    `INSERT INTO google_contacts (resource_name, display_name, email, phone, organization, contact_url, synced_at)
     VALUES ($1, $2, $3, $4, $5, $6, $7)
     RETURNING ${CONTACT_COLUMNS}`,
    values
  );
  return contactFromRow(rows[0]);
}

export async function handleContacts(req: VercelRequest, res: VercelResponse) {
  if (!['GET', 'POST'].includes(req.method || '')) return res.status(405).json({ error: 'Method not allowed' });
  return withAdmin(req, res, '063', async (client) => {
    if (req.method === 'POST') {
      const body = parseJsonBody(req);
      if (!body) throw new InputError('Invalid JSON');
      return res.status(201).json({ contact: await upsertContact(client, body.contact) });
    }
    const q = qstr(req, 'q').slice(0, 120);
    const status = await connectionStatus(client);
    const local = await client.query(
      `SELECT ${CONTACT_COLUMNS}
         FROM google_contacts
        WHERE $1 = '' OR display_name ILIKE $2 OR email ILIKE $2 OR organization ILIKE $2 OR phone ILIKE $2
        ORDER BY display_name
        LIMIT 30`,
      [q, `%${q}%`]
    );
    let google: ContactRecord[] = [];
    let googleError = '';
    if (q && status.connected) {
      try {
        google = await searchContacts(client, q);
      } catch (err) {
        if (!(err instanceof GoogleContactsError)) throw err;
        googleError = err.message;
      }
    }
    return res.status(200).json({
      connected: status.connected,
      googleEmail: status.email,
      googleError,
      local: local.rows.map(contactFromRow),
      google,
    });
  });
}

export async function handleCardContacts(req: VercelRequest, res: VercelResponse) {
  if (!['GET', 'POST', 'PATCH', 'DELETE'].includes(req.method || '')) {
    return res.status(405).json({ error: 'Method not allowed' });
  }
  return withAdmin(req, res, '063', async (client, user) => {
    const list = async (cardId: number) => {
      const { rows } = await client.query(
        `SELECT cc.id AS link_id, cc.role_note, ${CONTACT_COLUMNS.split(', ').map((c) => `g.${c}`).join(', ')}
           FROM card_contacts cc
           JOIN google_contacts g ON g.id = cc.contact_id
          WHERE cc.card_edit_id = $1
          ORDER BY g.display_name`,
        [cardId]
      );
      return rows.map((row) => ({ linkId: Number(row.link_id), roleNote: String(row.role_note || ''), contact: contactFromRow(row) }));
    };

    if (req.method === 'GET') {
      const cardId = positiveInt(qstr(req, 'id'));
      if (cardId == null) throw new InputError('Invalid id');
      return res.status(200).json({ contacts: await list(cardId) });
    }
    if (req.method === 'DELETE') {
      const linkId = positiveInt(qstr(req, 'id'));
      if (linkId == null) throw new InputError('Invalid id');
      const { rows } = await client.query(`DELETE FROM card_contacts WHERE id = $1 RETURNING card_edit_id`, [linkId]);
      if (!rows[0]) return res.status(404).json({ error: 'Not found' });
      return res.status(200).json({ contacts: await list(Number(rows[0].card_edit_id)) });
    }
    const body = parseJsonBody(req);
    if (!body) throw new InputError('Invalid JSON');
    const roleNote = str(body.roleNote, 500);
    if (req.method === 'PATCH') {
      const linkId = positiveInt(body.linkId);
      if (linkId == null) throw new InputError('Invalid id');
      const { rows } = await client.query(
        `UPDATE card_contacts SET role_note = $2 WHERE id = $1 RETURNING card_edit_id`,
        [linkId, roleNote]
      );
      if (!rows[0]) return res.status(404).json({ error: 'Not found' });
      return res.status(200).json({ contacts: await list(Number(rows[0].card_edit_id)) });
    }
    const cardId = positiveInt(body.cardId);
    if (cardId == null) throw new InputError('Invalid cardId');
    const contactId = positiveInt(body.contactId) ?? (await upsertContact(client, body.contact)).id;
    await client.query(
      `INSERT INTO card_contacts (card_edit_id, contact_id, role_note, created_by)
       VALUES ($1, $2, $3, $4)
       ON CONFLICT (card_edit_id, contact_id) DO UPDATE SET role_note = EXCLUDED.role_note`,
      [cardId, contactId, roleNote, user.id]
    );
    return res.status(201).json({ contacts: await list(cardId) });
  });
}

/* ---------- Verification ---------- */

function verificationFromRow(row: Record<string, unknown>) {
  return {
    id: Number(row.id),
    level: Number(row.level),
    verifiedOn: String(row.verified_on || ''),
    methodNote: String(row.method_note || ''),
    contact: row.contact_id == null
      ? null
      : { id: Number(row.contact_id), displayName: String(row.contact_name || ''), contactUrl: String(row.contact_url || '') },
    recordedBy: row.recorded_by_email == null ? '' : String(row.recorded_by_email),
    recordedAt: iso(row.recorded_at),
  };
}

const VERIFICATION_SELECT = `
  SELECT v.id, v.card_edit_id, v.level, v.verified_on::text AS verified_on, v.method_note, v.recorded_at,
         g.id AS contact_id, g.display_name AS contact_name, g.contact_url, u.email AS recorded_by_email
    FROM card_verifications v
    LEFT JOIN google_contacts g ON g.id = v.verified_by_contact_id
    LEFT JOIN users u ON u.id = v.recorded_by`;

export async function handleVerification(req: VercelRequest, res: VercelResponse) {
  if (!['GET', 'POST'].includes(req.method || '')) return res.status(405).json({ error: 'Method not allowed' });
  return withAdmin(req, res, '063', async (client, user) => {
    if (req.method === 'GET') {
      const cardId = positiveInt(qstr(req, 'id'));
      if (cardId != null) {
        const { rows } = await client.query(
          `${VERIFICATION_SELECT} WHERE v.card_edit_id = $1 ORDER BY v.verified_on DESC, v.id DESC`,
          [cardId]
        );
        const card = await client.query(
          `SELECT public_fields, sites, eligibility FROM directory_card_edits WHERE id = $1`,
          [cardId]
        );
        if (!card.rows[0]) return res.status(404).json({ error: 'הכרטיס לא נמצא' });
        const c = card.rows[0];
        return res.status(200).json({
          verifications: rows.map(verificationFromRow),
          completeness: cardCompleteness(c.public_fields, c.sites, c.eligibility),
        });
      }
      const { rows } = await client.query(
        `SELECT c.id, c.row_id, c.public_fields, c.sites, c.eligibility,
                lv.level, lv.verified_on, lv.contact_name, lv.contact_url,
                (SELECT count(*)::int FROM card_contacts cc WHERE cc.card_edit_id = c.id) AS contacts
           FROM directory_card_edits c
           LEFT JOIN LATERAL (
             SELECT v.level, v.verified_on::text AS verified_on, g.display_name AS contact_name, g.contact_url
               FROM card_verifications v
               LEFT JOIN google_contacts g ON g.id = v.verified_by_contact_id
              WHERE v.card_edit_id = c.id
              ORDER BY v.verified_on DESC, v.id DESC
              LIMIT 1
           ) lv ON true
          ORDER BY c.row_id, c.id`
      );
      const google = await connectionStatus(client);
      return res.status(200).json({
        google: { ...google, configured: contactsConfigured() },
        cards: rows.map((row) => {
          const fields = (row.public_fields || {}) as Record<string, unknown>;
          const completeness = cardCompleteness(row.public_fields, row.sites, row.eligibility);
          return {
            id: Number(row.id),
            rowId: Number(row.row_id),
            org: String(fields.org || ''),
            svc: String(fields.svc || ''),
            level: row.level == null ? 0 : Number(row.level),
            verifiedOn: row.verified_on == null ? null : String(row.verified_on),
            verifiedBy: row.contact_name == null ? '' : String(row.contact_name),
            verifiedByUrl: row.contact_url == null ? '' : String(row.contact_url),
            contacts: Number(row.contacts) || 0,
            score: completeness.score,
            gaps: completeness.gaps.map((g) => g.code),
          };
        }),
      });
    }

    const body = parseJsonBody(req);
    if (!body) throw new InputError('Invalid JSON');
    const cardId = positiveInt(body.cardId);
    if (cardId == null) throw new InputError('Invalid cardId');
    const level = Number(body.level);
    if (!Number.isInteger(level) || level < 0 || level > 3) throw new InputError('רמת אימות לא תקינה');
    const verifiedOn = str(body.verifiedOn, 10);
    if (!isYmd(verifiedOn)) throw new InputError('תאריך לא תקין');
    if (verifiedOn > new Date().toISOString().slice(0, 10)) throw new InputError('תאריך האימות בעתיד');
    let contactId: number | null = null;
    if (body.contactId != null && body.contactId !== '') {
      contactId = positiveInt(body.contactId);
      if (contactId == null) throw new InputError('Invalid contactId');
    } else if (body.contact) {
      contactId = (await upsertContact(client, body.contact)).id;
    }
    if (level === 3 && contactId == null) throw new InputError('ברמה 3 צריך לבחור את איש הקשר שאישר');
    await client.query(
      `INSERT INTO card_verifications (card_edit_id, level, verified_on, verified_by_contact_id, method_note, recorded_by)
       VALUES ($1, $2, $3::date, $4, $5, $6)`,
      [cardId, level, verifiedOn, contactId, str(body.methodNote, 2000), user.id]
    );
    const { rows } = await client.query(
      `${VERIFICATION_SELECT} WHERE v.card_edit_id = $1 ORDER BY v.verified_on DESC, v.id DESC`,
      [cardId]
    );
    return res.status(201).json({ verifications: rows.map(verificationFromRow) });
  });
}

/* ---------- Google Contacts connection ---------- */

function adminDest(result: string): string {
  return `${appUrl()}/admin?google=${encodeURIComponent(result)}#verification`;
}

function redirect(res: VercelResponse, location: string) {
  res.statusCode = 302;
  res.setHeader('Location', location);
  return res.end();
}

/** GET starts consent (redirect), GET ?status=1 reports the connection, DELETE disconnects. */
export async function handleGoogleConnect(req: VercelRequest, res: VercelResponse) {
  if (req.method === 'GET' && qstr(req, 'status') !== '1') {
    const user = await getAuthFromRequest(req);
    if (!user || !process.env.DATABASE_URL) return redirect(res, adminDest('error'));
    const client = pgClient();
    try {
      await client.connect();
      if (!(await userIsAdmin(client, user.id))) return redirect(res, adminDest('error'));
    } finally {
      await client.end().catch(() => {});
    }
    if (!contactsConfigured() || !process.env.AUTH_SECRET) return redirect(res, adminDest('not-configured'));
    const state = newOAuthState();
    const codeVerifier = newCodeVerifier();
    setOAuthCookie(res, await signOAuthState({ state, codeVerifier }));
    return redirect(
      res,
      contactsAuthorizeUrl({ clientId: process.env.GOOGLE_CLIENT_ID || '', state, challenge: codeChallenge(codeVerifier) })
    );
  }
  if (req.method !== 'GET' && req.method !== 'DELETE') return res.status(405).json({ error: 'Method not allowed' });
  return withAdmin(req, res, '063', async (client) => {
    if (req.method === 'DELETE') {
      await client.query(`DELETE FROM google_connection WHERE id = 1`);
    }
    return res.status(200).json({ google: { ...(await connectionStatus(client)), configured: contactsConfigured() } });
  });
}

export async function handleGoogleCallback(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });
  const fail = (why: string) => {
    clearOAuthCookie(res);
    return redirect(res, adminDest(why));
  };
  const code = qstr(req, 'code');
  const state = qstr(req, 'state');
  if (qstr(req, 'error')) return fail('denied');
  if (!code || !state || !process.env.DATABASE_URL) return fail('error');
  const stored = await getOAuthStateFromRequest(req);
  if (!stored || stored.state !== state) return fail('error');
  const user = await getAuthFromRequest(req);
  if (!user) return fail('error');

  const client = pgClient();
  try {
    await client.connect();
    if (!(await userIsAdmin(client, user.id))) return fail('error');
    const tokens = await exchangeContactsCode({ code, verifier: stored.codeVerifier });
    await client.query(
      `INSERT INTO google_connection (id, google_email, refresh_token_enc, scopes, connected_by, connected_at)
       VALUES (1, $1, $2, $3, $4, now())
       ON CONFLICT (id) DO UPDATE
         SET google_email = EXCLUDED.google_email, refresh_token_enc = EXCLUDED.refresh_token_enc,
             scopes = EXCLUDED.scopes, connected_by = EXCLUDED.connected_by, connected_at = now()`,
      [tokens.email, encryptToken(tokens.refreshToken), tokens.scopes, user.id]
    );
    clearOAuthCookie(res);
    return redirect(res, adminDest('connected'));
  } catch (err) {
    console.error('google contacts callback error', err);
    return fail(err instanceof GoogleContactsError && err.status === 400 ? 'scope' : 'error');
  } finally {
    await client.end().catch(() => {});
  }
}

/* ---------- Glossary links ---------- */

export async function handleGlossaryLinks(req: VercelRequest, res: VercelResponse) {
  if (!['GET', 'POST', 'PATCH'].includes(req.method || '')) return res.status(405).json({ error: 'Method not allowed' });
  return withAdmin(req, res, '064', async (client, user) => {
    const select = `
      SELECT l.id, l.term_key, l.card_key, l.status, l.matched_text, l.created_at, l.reviewed_at,
             c.id AS card_id, c.row_id, coalesce(c.public_fields->>'org', '') AS org, coalesce(c.public_fields->>'svc', '') AS svc
        FROM glossary_card_links l
        JOIN directory_card_edits c ON c.card_key = l.card_key`;
    const fromRow = (row: Record<string, unknown>) => ({
      id: Number(row.id),
      termKey: String(row.term_key),
      cardKey: String(row.card_key),
      status: String(row.status),
      matchedText: String(row.matched_text || ''),
      card: { id: Number(row.card_id), rowId: Number(row.row_id), org: String(row.org), svc: String(row.svc) },
      createdAt: iso(row.created_at),
      reviewedAt: iso(row.reviewed_at),
    });

    if (req.method === 'GET') {
      const params: unknown[] = [];
      const where: string[] = [];
      const status = qstr(req, 'status');
      if ((LINK_STATUSES as readonly string[]).includes(status)) {
        params.push(status);
        where.push(`l.status = $${params.length}`);
      }
      const cardId = positiveInt(qstr(req, 'card'));
      if (cardId != null) {
        params.push(cardId);
        where.push(`c.id = $${params.length}`);
      }
      const term = qstr(req, 'term');
      if (/^[a-z0-9_]{1,80}$/.test(term)) {
        params.push(term);
        where.push(`l.term_key = $${params.length}`);
      }
      const { rows } = await client.query(
        `${select} ${where.length ? `WHERE ${where.join(' AND ')}` : ''} ORDER BY l.term_key, c.row_id LIMIT 2000`,
        params
      );
      return res.status(200).json({ links: rows.map(fromRow) });
    }

    const body = parseJsonBody(req);
    if (!body) throw new InputError('Invalid JSON');
    if (req.method === 'POST') {
      const termKey = str(body.termKey, 80);
      const cardId = positiveInt(body.cardId);
      if (!/^[a-z0-9_]{1,80}$/.test(termKey) || cardId == null) throw new InputError('Invalid termKey or cardId');
      const { rows } = await client.query(
        `INSERT INTO glossary_card_links (term_key, card_key, status, reviewed_at, reviewed_by)
         SELECT $1, card_key, 'approved', now(), $3 FROM directory_card_edits WHERE id = $2
         ON CONFLICT (term_key, card_key) DO UPDATE SET status = 'approved', reviewed_at = now(), reviewed_by = EXCLUDED.reviewed_by
         RETURNING id`,
        [termKey, cardId, user.id]
      );
      if (!rows[0]) return res.status(404).json({ error: 'הכרטיס לא נמצא' });
      const out = await client.query(`${select} WHERE l.id = $1`, [rows[0].id]);
      return res.status(201).json({ link: fromRow(out.rows[0]) });
    }
    const ids = (Array.isArray(body.ids) ? body.ids : [body.id]).map(positiveInt).filter((n): n is number => n != null);
    const status = str(body.status, 20);
    if (!ids.length || !(LINK_STATUSES as readonly string[]).includes(status)) throw new InputError('Invalid ids or status');
    const { rows } = await client.query(
      `UPDATE glossary_card_links SET status = $2, reviewed_at = now(), reviewed_by = $3
        WHERE id = ANY($1::int[])
        RETURNING id`,
      [ids, status, user.id]
    );
    const out = await client.query(`${select} WHERE l.id = ANY($1::int[])`, [rows.map((r) => r.id)]);
    return res.status(200).json({ links: out.rows.map(fromRow) });
  });
}
