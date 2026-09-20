import { createHash, randomBytes } from 'crypto';
import type { Client } from 'pg';

export type TokenKind = 'confirm' | 'unsubscribe' | 'care_otp';

export function newRawToken(): string {
  return randomBytes(32).toString('base64url');
}

export function hashToken(raw: string): string {
  return createHash('sha256').update(raw, 'utf8').digest('hex');
}

export async function insertToken(
  client: Client,
  userId: string,
  kind: TokenKind,
  ttlMs: number
): Promise<string> {
  const raw = newRawToken();
  const hash = hashToken(raw);
  await client.query(
    `INSERT INTO email_tokens (user_id, kind, token_hash, expires_at)
     VALUES ($1, $2, $3, now() + ($4 || ' milliseconds')::interval)`,
    [userId, kind, hash, String(ttlMs)]
  );
  return raw;
}

export async function findValidToken(
  client: Client,
  raw: string,
  kind: TokenKind
): Promise<{ id: string; user_id: string } | null> {
  const hash = hashToken(raw);
  const { rows } = await client.query(
    `SELECT id::text, user_id::text
       FROM email_tokens
      WHERE token_hash = $1
        AND kind = $2
        AND expires_at > now()
        AND (consumed_at IS NULL OR kind = 'unsubscribe')
      LIMIT 1`,
    [hash, kind]
  );
  return rows[0] || null;
}

const OTP_TTL_MS = 10 * 60 * 1000;

export function newOtpCode(): string {
  const n = randomBytes(4).readUInt32BE(0) % 900000;
  return String(n + 100000);
}

export async function insertOtpCode(
  client: Client,
  userId: string,
  kind: TokenKind,
  code: string,
  ttlMs: number = OTP_TTL_MS
): Promise<void> {
  await client.query(
    `UPDATE email_tokens SET consumed_at = now()
      WHERE user_id = $1 AND kind = $2 AND consumed_at IS NULL`,
    [userId, kind]
  );
  const hash = hashToken(`${userId}:${code}`);
  await client.query(
    `INSERT INTO email_tokens (user_id, kind, token_hash, expires_at)
     VALUES ($1, $2, $3, now() + ($4 || ' milliseconds')::interval)`,
    [userId, kind, hash, String(ttlMs)]
  );
}

export async function consumeOtpCode(
  client: Client,
  userId: string,
  kind: TokenKind,
  code: string
): Promise<boolean> {
  const hash = hashToken(`${userId}:${code}`);
  const { rows } = await client.query(
    `SELECT id::text
       FROM email_tokens
      WHERE token_hash = $1
        AND user_id = $2
        AND kind = $3
        AND expires_at > now()
        AND consumed_at IS NULL
      LIMIT 1`,
    [hash, userId, kind]
  );
  if (!rows[0]) return false;
  await client.query(`UPDATE email_tokens SET consumed_at = now() WHERE id = $1 AND consumed_at IS NULL`, [
    rows[0].id,
  ]);
  return true;
}
