import type { Client } from 'pg';
import { appUrl } from './db';
import { insertToken } from './tokens';
import { adminEmailList } from './users';

const CONFIRM_TTL_MS = 48 * 60 * 60 * 1000;
const UNSUBSCRIBE_TTL_MS = 90 * 24 * 60 * 60 * 1000;

function fromAddress(): string | null {
  return process.env.UPDATES_FROM_EMAIL || process.env.LINK_CHECK_FROM_EMAIL || null;
}

export function emailSendConfigured(): boolean {
  return Boolean(process.env.RESEND_API_KEY && fromAddress());
}

export type OutboxSendResult = { sent: number; failed: number; skipped: number };

export async function sendResendEmail(opts: {
  to: string;
  subject: string;
  text: string;
  html: string;
}): Promise<{ ok: boolean; error?: string }> {
  const key = process.env.RESEND_API_KEY;
  const from = fromAddress();
  if (!key || !from) {
    return { ok: false, error: 'Missing RESEND_API_KEY or UPDATES_FROM_EMAIL' };
  }
  const res = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${key}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      from,
      to: [opts.to],
      subject: opts.subject,
      text: opts.text,
      html: opts.html,
    }),
  });
  if (!res.ok) {
    const body = await res.text();
    return { ok: false, error: `Resend ${res.status}: ${body.slice(0, 500)}` };
  }
  return { ok: true };
}

function wrapHtml(body: string): string {
  return `<!DOCTYPE html><html lang="he" dir="rtl"><body style="font-family:Heebo,Arial,sans-serif;line-height:1.6;color:#333;max-width:640px;margin:0 auto;padding:16px">${body}<p style="font-size:0.85rem;color:#5a5a5a;margin-top:32px">מדריך נפש · <a href="https://nefesh-il.org">nefesh-il.org</a></p></body></html>`;
}

export async function enqueueConfirmEmail(client: Client, user: { id: string; email: string }): Promise<void> {
  const raw = await insertToken(client, user.id, 'confirm', CONFIRM_TTL_MS);
  const url = `${appUrl()}/api/auth/confirm?token=${encodeURIComponent(raw)}`;
  await client.query(
    `INSERT INTO email_outbox (user_id, kind, payload)
     VALUES ($1, 'confirm', $2::jsonb)`,
    [
      user.id,
      JSON.stringify({
        to: user.email,
        confirmUrl: url,
      }),
    ]
  );
}

export async function enqueueImmediateEmails(client: Client, updateId: string): Promise<number> {
  const result = await client.query(
    `INSERT INTO email_outbox (user_id, kind, payload)
     SELECT id, 'immediate', jsonb_build_object('update_id', $1::text)
       FROM users
      WHERE email_preference = 'immediate'
        AND email_verified_at IS NOT NULL
     RETURNING id`,
    [updateId]
  );
  return result.rowCount ?? 0;
}

export async function enqueueWeeklyEmails(client: Client): Promise<number> {
  const { rows: users } = await client.query(
    `SELECT id::text, email, created_at
       FROM users
      WHERE email_preference = 'weekly'
        AND email_verified_at IS NOT NULL`
  );
  let n = 0;
  for (const u of users) {
    const last = await client.query(
      `SELECT sent_at
         FROM email_outbox
        WHERE user_id = $1 AND kind = 'weekly' AND sent_at IS NOT NULL
        ORDER BY sent_at DESC
        LIMIT 1`,
      [u.id]
    );
    const since: Date = last.rows[0]?.sent_at ? new Date(last.rows[0].sent_at) : new Date(u.created_at);
    const updates = await client.query(
      `SELECT id::text, title, body, published_at
         FROM site_updates
        WHERE published_at > $1
        ORDER BY published_at ASC`,
      [since.toISOString()]
    );
    if (!updates.rows.length) continue;
    await client.query(
      `INSERT INTO email_outbox (user_id, kind, payload)
       VALUES ($1, 'weekly', $2::jsonb)`,
      [
        u.id,
        JSON.stringify({
          to: u.email,
          update_ids: updates.rows.map((r: { id: string }) => r.id),
        }),
      ]
    );
    n += 1;
  }
  return n;
}

export async function enqueueQuestionAdminEmails(
  client: Client,
  opts: { questionId: string; askerEmail: string; question: string }
): Promise<number> {
  const { rows: admins } = await client.query(`SELECT id::text, email FROM users WHERE is_admin = true`);
  const recipients: { id: string | null; email: string }[] = [];
  const seen = new Set<string>();
  for (const row of admins) {
    const email = String(row.email || '').toLowerCase();
    if (!email || seen.has(email)) continue;
    seen.add(email);
    recipients.push({ id: row.id, email });
  }
  for (const extra of adminEmailList()) {
    if (seen.has(extra)) continue;
    seen.add(extra);
    recipients.push({ id: null, email: extra });
  }
  if (!recipients.length) return 0;

  const adminUrl = `${appUrl()}/admin#questions`;
  const mailto = `mailto:${opts.askerEmail}?subject=${encodeURIComponent('תשובה לשאלה במדריך נפש')}`;
  const payloadBase = {
    askerEmail: opts.askerEmail,
    question: opts.question,
    questionId: opts.questionId,
    mailto,
    adminUrl,
  };

  let n = 0;
  for (const r of recipients) {
    await client.query(
      `INSERT INTO email_outbox (user_id, kind, payload)
       VALUES ($1, 'question_admin', $2::jsonb)`,
      [
        r.id,
        JSON.stringify({
          ...payloadBase,
          to: r.email,
        }),
      ]
    );
    n += 1;
  }
  return n;
}

export async function enqueueCareOtpEmail(
  client: Client,
  user: { id: string; email: string },
  code: string
): Promise<void> {
  await client.query(
    `INSERT INTO email_outbox (user_id, kind, payload)
     VALUES ($1, 'care_otp', $2::jsonb)`,
    [user.id, JSON.stringify({ to: user.email, code })]
  );
}

export async function enqueueCareGrantInvite(
  client: Client,
  opts: { ownerEmail: string; granteeEmail: string; granteeUserId: string | null; acceptUrl: string; kind: string }
): Promise<void> {
  await client.query(
    `INSERT INTO email_outbox (user_id, kind, payload)
     VALUES ($1, 'care_grant_invite', $2::jsonb)`,
    [
      opts.granteeUserId,
      JSON.stringify({
        to: opts.granteeEmail,
        ownerEmail: opts.ownerEmail,
        acceptUrl: opts.acceptUrl,
        kind: opts.kind,
      }),
    ]
  );
}

export async function enqueueCareGrantAccepted(
  client: Client,
  opts: { ownerUserId: string; ownerEmail: string; granteeEmail: string }
): Promise<void> {
  await client.query(
    `INSERT INTO email_outbox (user_id, kind, payload)
     VALUES ($1, 'care_grant_accepted', $2::jsonb)`,
    [
      opts.ownerUserId,
      JSON.stringify({ to: opts.ownerEmail, granteeEmail: opts.granteeEmail }),
    ]
  );
}

export async function enqueueCareGrantRevoked(
  client: Client,
  opts: {
    ownerUserId: string;
    ownerEmail: string;
    granteeEmail: string;
    granteeUserId: string | null;
  }
): Promise<void> {
  await client.query(
    `INSERT INTO email_outbox (user_id, kind, payload)
     VALUES ($1, 'care_grant_revoked', $2::jsonb)`,
    [
      opts.ownerUserId,
      JSON.stringify({ to: opts.ownerEmail, granteeEmail: opts.granteeEmail, role: 'owner' }),
    ]
  );
  await client.query(
    `INSERT INTO email_outbox (user_id, kind, payload)
     VALUES ($1, 'care_grant_revoked', $2::jsonb)`,
    [
      opts.granteeUserId,
      JSON.stringify({ to: opts.granteeEmail, ownerEmail: opts.ownerEmail, role: 'grantee' }),
    ]
  );
}

export async function enqueueCareCommitteeReminders(client: Client): Promise<number> {
  let rows: {
    id: string;
    title: string;
    scheduled_on: Date | string;
    scheduled_time: string;
    place: string;
    user_id: string;
    email: string;
    days: number;
  }[] = [];
  try {
    const found = await client.query(
      `SELECT c.id::text, c.title, c.scheduled_on, c.scheduled_time, c.place,
              u.id::text AS user_id, u.email,
              (c.scheduled_on - CURRENT_DATE)::int AS days
         FROM care_committees c
         JOIN care_files f ON f.id = c.file_id
         JOIN users u ON u.id = f.owner_id
        WHERE c.remind = true
          AND c.status = 'upcoming'
          AND (c.scheduled_on - CURRENT_DATE) IN (1, 3, 7)
          AND (c.last_reminded_on IS DISTINCT FROM CURRENT_DATE)
          AND u.email_verified_at IS NOT NULL`
    );
    rows = found.rows;
  } catch (err) {
    const code = (err as { code?: string }).code;
    if (code === '42P01' || code === '42703') return 0;
    throw err;
  }

  let n = 0;
  for (const row of rows) {
    const when =
      row.scheduled_on instanceof Date
        ? row.scheduled_on.toISOString().slice(0, 10)
        : String(row.scheduled_on).slice(0, 10);
    const [y, m, d] = when.split('-');
    const whenHe = d && m && y ? `${d}.${m}.${y}` : when;
    await client.query(
      `INSERT INTO email_outbox (user_id, kind, payload)
       VALUES ($1, 'care_committee_reminder', $2::jsonb)`,
      [
        row.user_id,
        JSON.stringify({
          to: row.email,
          title: row.title,
          whenHe,
          time: row.scheduled_time || '',
          place: row.place || '',
          days: row.days,
          careUrl: `${appUrl()}/care`,
        }),
      ]
    );
    await client.query(`UPDATE care_committees SET last_reminded_on = CURRENT_DATE WHERE id = $1`, [row.id]);
    n += 1;
  }
  return n;
}

type OutboxKind =
  | 'confirm'
  | 'immediate'
  | 'weekly'
  | 'question_admin'
  | 'care_otp'
  | 'care_grant_invite'
  | 'care_grant_accepted'
  | 'care_grant_revoked'
  | 'care_committee_reminder';

type OutboxRow = {
  id: string;
  user_id: string | null;
  kind: OutboxKind;
  payload: Record<string, unknown>;
  email: string | null;
};

function asRecord(v: unknown): Record<string, unknown> {
  if (v && typeof v === 'object' && !Array.isArray(v)) return v as Record<string, unknown>;
  if (typeof v === 'string') {
    try {
      const p = JSON.parse(v);
      if (p && typeof p === 'object') return p as Record<string, unknown>;
    } catch {
      /* ignore */
    }
  }
  return {};
}

async function unsubscribeUrl(client: Client, userId: string): Promise<string> {
  const raw = await insertToken(client, userId, 'unsubscribe', UNSUBSCRIBE_TTL_MS);
  return `${appUrl()}/api/auth/unsubscribe?token=${encodeURIComponent(raw)}`;
}

async function loadUpdate(
  client: Client,
  id: string
): Promise<{ title: string; body: string } | null> {
  const { rows } = await client.query(`SELECT title, body FROM site_updates WHERE id = $1`, [id]);
  return rows[0] || null;
}

async function renderOutbox(
  client: Client,
  row: OutboxRow
): Promise<{ to: string; subject: string; text: string; html: string } | null> {
  const to = (typeof row.payload.to === 'string' && row.payload.to) || row.email;
  if (!to) return null;

  if (row.kind === 'care_otp') {
    const code = String(row.payload.code || '');
    const subject = 'קוד כניסה לתיק שלי — מדריך נפש';
    const text = `קוד הכניסה לתיק שלכם: ${code}\n\nהקוד תקף ל־10 דקות. אם לא ביקשתם אותו, התעלמו מהודעה זו.`;
    const html = wrapHtml(
      `<p>קוד הכניסה לתיק שלכם:</p><p style="font-size:1.6rem;font-weight:700;letter-spacing:0.12em">${escapeHtml(code)}</p><p>הקוד תקף ל־10 דקות. אם לא ביקשתם אותו, התעלמו מהודעה זו.</p>`
    );
    return { to, subject, text, html };
  }

  if (row.kind === 'care_grant_invite') {
    const ownerEmail = String(row.payload.ownerEmail || '');
    const acceptUrl = String(row.payload.acceptUrl || `${appUrl()}/care`);
    const kind = String(row.payload.kind || 'timed');
    const kindHe = kind === 'proxy' ? 'גישת משפחה קבועה' : 'גישה לזמן מוגבל';
    const subject = 'שותף איתכם תיק במדריך נפש';
    const text = `${ownerEmail} שיתף איתכם את התיק האישי (${kindHe}).\n\nכדי לראות אותו, היכנסו לחשבון עם כתובת האימייל הזו ואשרו:\n${acceptUrl}\n\nאם לא ציפיתם להודעה זו, התעלמו ממנה.`;
    const html = wrapHtml(
      `<p><strong>${escapeHtml(ownerEmail)}</strong> שיתף איתכם את התיק האישי (${escapeHtml(kindHe)}).</p><p>כדי לראות אותו, היכנסו לחשבון עם כתובת האימייל הזו ואשרו:</p><p><a href="${escapeHtml(acceptUrl)}">לאישור הגישה</a></p><p>אם לא ציפיתם להודעה זו, התעלמו ממנה.</p>`
    );
    return { to, subject, text, html };
  }

  if (row.kind === 'care_grant_accepted') {
    const granteeEmail = String(row.payload.granteeEmail || '');
    const subject = 'מישהו אישר גישה לתיק שלכם';
    const text = `${granteeEmail} אישר/ה את הגישה לתיק שלכם.\n\nאפשר לנהל הרשאות ב־${appUrl()}/care`;
    const html = wrapHtml(
      `<p><strong>${escapeHtml(granteeEmail)}</strong> אישר/ה את הגישה לתיק שלכם.</p><p><a href="${escapeHtml(appUrl() + '/care')}">לניהול הרשאות</a></p>`
    );
    return { to, subject, text, html };
  }

  if (row.kind === 'care_grant_revoked') {
    const role = String(row.payload.role || 'owner');
    if (role === 'grantee') {
      const ownerEmail = String(row.payload.ownerEmail || '');
      const subject = 'הגישה לתיק בוטלה';
      const text = `הגישה לתיק של ${ownerEmail} בוטלה.`;
      const html = wrapHtml(`<p>הגישה לתיק של <strong>${escapeHtml(ownerEmail)}</strong> בוטלה.</p>`);
      return { to, subject, text, html };
    }
    const granteeEmail = String(row.payload.granteeEmail || '');
    const subject = 'ביטלתם גישה לתיק';
    const text = `ביטלתם את הגישה של ${granteeEmail} לתיק שלכם.`;
    const html = wrapHtml(`<p>ביטלתם את הגישה של <strong>${escapeHtml(granteeEmail)}</strong> לתיק שלכם.</p>`);
    return { to, subject, text, html };
  }

  if (row.kind === 'care_committee_reminder') {
    const title = String(row.payload.title || 'ועדה');
    const whenHe = String(row.payload.whenHe || '');
    const time = String(row.payload.time || '');
    const place = String(row.payload.place || '');
    const days = Number(row.payload.days) || 0;
    const careUrl = String(row.payload.careUrl || `${appUrl()}/care`);
    const whenLine = days === 1 ? 'מחר' : `בעוד ${days} ימים`;
    const subject = `תזכורת: ${title} ${whenLine}`;
    const details = [whenHe, time, place].filter(Boolean).join(' · ');
    const text = `תזכורת לוועדה בתיק שלכם:\n${title}\n${details}\n\n${careUrl}`;
    const html = wrapHtml(
      `<p>תזכורת לוועדה בתיק שלכם (${escapeHtml(whenLine)}):</p><p><strong>${escapeHtml(title)}</strong></p><p>${escapeHtml(details)}</p><p><a href="${escapeHtml(careUrl)}">לתיק שלי</a></p>`
    );
    return { to, subject, text, html };
  }

  if (row.kind === 'question_admin') {
    const asker = String(row.payload.askerEmail || '');
    const question = String(row.payload.question || '');
    const adminUrl = String(row.payload.adminUrl || `${appUrl()}/admin#questions`);
    const mailto = String(row.payload.mailto || (asker ? `mailto:${asker}` : ''));
    const subject = 'שאלה חדשה במדריך נפש';
    const text = [
      'התקבלה שאלה חדשה במדריך נפש.',
      '',
      `מאת: ${asker}`,
      '',
      question,
      '',
      mailto ? `מענה במייל: ${mailto}` : '',
      `לרשימת השאלות: ${adminUrl}`,
    ]
      .filter(Boolean)
      .join('\n');
    const html = wrapHtml(
      `<p>התקבלה שאלה חדשה במדריך נפש.</p>
       <p><strong>מאת:</strong> ${escapeHtml(asker)}</p>
       <p style="white-space:pre-wrap">${escapeHtml(question)}</p>
       <p>${mailto ? `<a href="${escapeHtml(mailto)}">מענה במייל</a> · ` : ''}<a href="${escapeHtml(adminUrl)}">לרשימת השאלות</a></p>`
    );
    return { to, subject, text, html };
  }

  const unsub = row.user_id ? await unsubscribeUrl(client, row.user_id) : '';
  const unsubLine = unsub
    ? `\n\nלהסרה מרשימת התפוצה: ${unsub}`
    : '';
  const unsubHtml = unsub
    ? `<p style="font-size:0.85rem;color:#5a5a5a"><a href="${unsub}">הסרה מרשימת התפוצה</a></p>`
    : '';

  if (row.kind === 'confirm') {
    const url = String(row.payload.confirmUrl || '');
    const subject = 'אישור כתובת האימייל — מדריך נפש';
    const text = `שלום,\n\nנא לאשר את כתובת האימייל כדי לקבל עדכונים ממדריך נפש:\n${url}\n\nהקישור תקף ל־48 שעות.\nאם לא נרשמתם, אפשר להתעלם מהודעה זו.`;
    const html = wrapHtml(
      `<p>שלום,</p><p>נא לאשר את כתובת האימייל כדי לקבל עדכונים ממדריך נפש:</p><p><a href="${url}">אישור הכתובת</a></p><p>הקישור תקף ל־48 שעות. אם לא נרשמתם, אפשר להתעלם מהודעה זו.</p>`
    );
    return { to, subject, text, html };
  }

  if (row.kind === 'immediate') {
    const updateId = String(row.payload.update_id || '');
    const update = updateId ? await loadUpdate(client, updateId) : null;
    if (!update) return null;
    const subject = `עדכון במדריך נפש: ${update.title}`;
    const text = `${update.title}\n\n${update.body}\n\nhttps://nefesh-il.org/${unsubLine}`;
    const html = wrapHtml(
      `<h2>${escapeHtml(update.title)}</h2><p style="white-space:pre-wrap">${escapeHtml(update.body)}</p><p><a href="https://nefesh-il.org/">למדריך</a></p>${unsubHtml}`
    );
    return { to, subject, text, html };
  }

  const ids = Array.isArray(row.payload.update_ids) ? row.payload.update_ids.map(String) : [];
  if (!ids.length) return null;
  const { rows } = await client.query(
    `SELECT title, body FROM site_updates WHERE id = ANY($1::uuid[]) ORDER BY published_at ASC`,
    [ids]
  );
  if (!rows.length) return null;
  const subject = 'עדכונים שבועיים — מדריך נפש';
  const textParts = rows.map((u: { title: string; body: string }) => `${u.title}\n${u.body}`);
  const text = `עדכונים מהשבוע במדריך נפש:\n\n${textParts.join('\n\n—\n\n')}\n\nhttps://nefesh-il.org/${unsubLine}`;
  const htmlBody = rows
    .map(
      (u: { title: string; body: string }) =>
        `<h3>${escapeHtml(u.title)}</h3><p style="white-space:pre-wrap">${escapeHtml(u.body)}</p>`
    )
    .join('<hr/>');
  const html = wrapHtml(`<p>עדכונים מהשבוע במדריך נפש:</p>${htmlBody}<p><a href="https://nefesh-il.org/">למדריך</a></p>${unsubHtml}`);
  return { to, subject, text, html };
}

function escapeHtml(value: string): string {
  return String(value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

export async function processOutbox(
  client: Client,
  limit = 80,
  opts?: { userId?: string; kind?: OutboxRow['kind'] }
): Promise<OutboxSendResult> {
  const from = fromAddress();
  const configured = Boolean(process.env.RESEND_API_KEY && from);
  const params: unknown[] = [limit];
  let extra = '';
  if (opts?.userId) {
    params.push(opts.userId);
    extra += ` AND o.user_id = $${params.length}`;
  }
  if (opts?.kind) {
    params.push(opts.kind);
    extra += ` AND o.kind = $${params.length}`;
  }

  const { rows } = await client.query(
    `SELECT o.id::text, o.user_id::text, o.kind, o.payload, u.email
       FROM email_outbox o
       LEFT JOIN users u ON u.id = o.user_id
      WHERE o.sent_at IS NULL
        AND o.scheduled_at <= now()
        ${extra}
      ORDER BY o.scheduled_at ASC
      LIMIT $1`,
    params
  );

  let sent = 0;
  let failed = 0;
  let skipped = 0;

  if (!configured && rows.length) {
    console.error('email outbox skipped: missing RESEND_API_KEY or from address');
  }

  for (const raw of rows) {
    const row: OutboxRow = {
      id: raw.id,
      user_id: raw.user_id,
      kind: raw.kind,
      payload: asRecord(raw.payload),
      email: raw.email,
    };
    if (!configured) {
      skipped += 1;
      continue;
    }
    try {
      const rendered = await renderOutbox(client, row);
      if (!rendered) {
        await client.query(`UPDATE email_outbox SET error = $2 WHERE id = $1`, [row.id, 'nothing to send']);
        failed += 1;
        continue;
      }
      const result = await sendResendEmail(rendered);
      if (result.ok) {
        await client.query(`UPDATE email_outbox SET sent_at = now(), error = NULL WHERE id = $1`, [row.id]);
        sent += 1;
      } else {
        const errText = result.error || 'send failed';
        console.error('email send failed', { id: row.id, kind: row.kind, to: rendered.to, from, error: errText });
        await client.query(`UPDATE email_outbox SET error = $2 WHERE id = $1`, [row.id, errText]);
        failed += 1;
      }
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      console.error('email send threw', { id: row.id, kind: row.kind, error: message });
      await client.query(`UPDATE email_outbox SET error = $2 WHERE id = $1`, [row.id, message.slice(0, 500)]);
      failed += 1;
    }
  }

  return { sent, failed, skipped };
}
