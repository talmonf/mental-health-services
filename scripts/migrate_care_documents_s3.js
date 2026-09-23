// Copy care_documents.ciphertext into S3, then clear the column.
// Does not re-encrypt: the existing nonce still decrypts the object.
// Safe to run more than once. Rows with ciphertext already null are skipped.
//
// Run after scripts/043_care_documents_s3.sql.
// Requires DATABASE_URL, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION, S3_BUCKET.
//
// Usage: node scripts/migrate_care_documents_s3.js

const { Client } = require('pg');
const { PutObjectCommand, S3Client } = require('@aws-sdk/client-s3');

function normalizePgSslMode(connectionString) {
  try {
    const u = new URL(connectionString);
    const mode = u.searchParams.get('sslmode');
    if (mode === 'prefer' || mode === 'require' || mode === 'verify-ca') {
      u.searchParams.set('sslmode', 'verify-full');
    }
    return u.toString();
  } catch {
    return connectionString;
  }
}

function objectKey(fileId, documentId) {
  return `care/${fileId}/${documentId}`;
}

function requireEnv(name) {
  const value = process.env[name];
  if (!value) {
    console.error(`Missing ${name}`);
    process.exit(1);
  }
  return value;
}

async function main() {
  const databaseUrl = requireEnv('DATABASE_URL');
  requireEnv('AWS_ACCESS_KEY_ID');
  requireEnv('AWS_SECRET_ACCESS_KEY');
  const region = requireEnv('AWS_REGION');
  const bucket = requireEnv('S3_BUCKET');

  const s3 = new S3Client({ region });
  const client = new Client({ connectionString: normalizePgSslMode(databaseUrl) });
  await client.connect();

  let migrated = 0;
  let failed = 0;
  try {
    const ids = await client.query(
      `SELECT id::text FROM care_documents WHERE ciphertext IS NOT NULL ORDER BY created_at`
    );
    for (const item of ids.rows) {
      const { rows } = await client.query(
        `SELECT id::text, file_id::text, storage_key, ciphertext
           FROM care_documents
          WHERE id = $1 AND ciphertext IS NOT NULL`,
        [item.id]
      );
      const row = rows[0];
      if (!row) continue;
      const key =
        typeof row.storage_key === 'string' && row.storage_key.trim()
          ? row.storage_key.trim()
          : objectKey(row.file_id, row.id);
      const body = Buffer.isBuffer(row.ciphertext) ? row.ciphertext : Buffer.from(row.ciphertext);
      if (!body.length) {
        console.error(`skip ${row.id}: empty ciphertext`);
        failed += 1;
        continue;
      }
      try {
        await s3.send(
          new PutObjectCommand({
            Bucket: bucket,
            Key: key,
            Body: body,
            ContentType: 'application/octet-stream',
            ServerSideEncryption: 'AES256',
          })
        );
        const updated = await client.query(
          `UPDATE care_documents
              SET storage_key = $2, ciphertext = NULL
            WHERE id = $1 AND ciphertext IS NOT NULL`,
          [row.id, key]
        );
        if (updated.rowCount !== 1) {
          console.error(`skip ${row.id}: row changed before update`);
          failed += 1;
          continue;
        }
        migrated += 1;
        console.log(`migrated ${row.id}`);
      } catch (err) {
        failed += 1;
        console.error(`failed ${row.id}`, err && err.message ? err.message : err);
      }
    }
  } finally {
    await client.end().catch(() => {});
  }

  console.log(`done migrated=${migrated} failed=${failed}`);
  if (failed) process.exit(1);
}

main().catch((err) => {
  console.error(err && err.message ? err.message : err);
  process.exit(1);
});
