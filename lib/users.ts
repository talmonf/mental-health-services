import type { Client } from 'pg';

export const QUALIFICATIONS = [
  'social_worker',
  'psychologist',
  'psychiatrist',
  'therapist',
  'nurse',
  'peer_supporter',
  'student',
  'family_self',
  'other',
] as const;

export const FOUND_VIA = [
  'google',
  'facebook_instagram',
  'whatsapp',
  'colleague',
  'university',
  'organization',
  'media',
  'other',
] as const;

export const EMAIL_PREFERENCES = ['none', 'weekly', 'immediate'] as const;

export type Qualification = (typeof QUALIFICATIONS)[number];
export type FoundVia = (typeof FOUND_VIA)[number];
export type EmailPreference = (typeof EMAIL_PREFERENCES)[number];

export type PublicUser = {
  id: string;
  email: string;
  isAdmin: boolean;
  country: string;
  city: string | null;
  qualification: Qualification;
  organization: string;
  title: string;
  foundVia: FoundVia;
  foundViaOther: string | null;
  emailPreference: EmailPreference;
  emailVerified: boolean;
};

export const USER_PUBLIC_COLUMNS = `
  id, email, is_admin, country, city, qualification, organization, title,
  found_via, found_via_other, email_preference, email_verified_at
`;

export function isQualification(v: unknown): v is Qualification {
  return typeof v === 'string' && (QUALIFICATIONS as readonly string[]).includes(v);
}

export function isFoundVia(v: unknown): v is FoundVia {
  return typeof v === 'string' && (FOUND_VIA as readonly string[]).includes(v);
}

export function isEmailPreference(v: unknown): v is EmailPreference {
  return typeof v === 'string' && (EMAIL_PREFERENCES as readonly string[]).includes(v);
}

export function publicUserFromRow(row: Record<string, unknown>): PublicUser {
  return {
    id: String(row.id),
    email: String(row.email),
    isAdmin: Boolean(row.is_admin),
    country: String(row.country),
    city: row.city == null || row.city === '' ? null : String(row.city),
    qualification: row.qualification as Qualification,
    organization: String(row.organization),
    title: String(row.title),
    foundVia: row.found_via as FoundVia,
    foundViaOther: row.found_via_other == null ? null : String(row.found_via_other),
    emailPreference: (row.email_preference as EmailPreference) || 'none',
    emailVerified: row.email_verified_at != null,
  };
}

export function isAdminEmail(email: string): boolean {
  const list = (process.env.ADMIN_EMAILS || '')
    .split(',')
    .map((s) => s.trim().toLowerCase())
    .filter(Boolean);
  return list.includes(email.toLowerCase());
}

export async function userIsAdmin(client: Client, userId: string): Promise<boolean> {
  const { rows } = await client.query(`SELECT is_admin FROM users WHERE id = $1`, [userId]);
  return Boolean(rows[0]?.is_admin);
}
