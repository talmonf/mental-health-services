import { createHash, randomBytes } from 'crypto';
import type { Client } from 'pg';

export type TokenKind = 'confirm' | 'unsubscribe';

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
