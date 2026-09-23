import { DeleteObjectCommand, GetObjectCommand, PutObjectCommand, S3Client } from '@aws-sdk/client-s3';

/** Object key for a care document. No filename — the key is file id and document id only. */
export function careObjectKey(fileId: string, documentId: string): string {
  return `care/${fileId}/${documentId}`;
}

export function s3Configured(): boolean {
  return Boolean(
    process.env.AWS_ACCESS_KEY_ID &&
      process.env.AWS_SECRET_ACCESS_KEY &&
      process.env.AWS_REGION &&
      process.env.S3_BUCKET
  );
}

function bucket(): string {
  const name = process.env.S3_BUCKET || '';
  if (!name) throw new Error('S3_BUCKET missing');
  return name;
}

let client: S3Client | null = null;

function s3(): S3Client {
  if (!s3Configured()) throw new Error('S3 is not configured');
  if (!client) client = new S3Client({ region: process.env.AWS_REGION });
  return client;
}

export async function putCiphertext(key: string, body: Buffer): Promise<void> {
  await s3().send(
    new PutObjectCommand({
      Bucket: bucket(),
      Key: key,
      Body: body,
      ContentType: 'application/octet-stream',
      ServerSideEncryption: 'AES256',
    })
  );
}

export async function getCiphertext(key: string): Promise<Buffer> {
  const out = await s3().send(
    new GetObjectCommand({
      Bucket: bucket(),
      Key: key,
    })
  );
  if (!out.Body) throw new Error('empty object');
  const bytes = await out.Body.transformToByteArray();
  return Buffer.from(bytes);
}

export async function deleteCiphertext(key: string): Promise<void> {
  await s3().send(
    new DeleteObjectCommand({
      Bucket: bucket(),
      Key: key,
    })
  );
}
