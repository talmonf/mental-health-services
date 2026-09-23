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

export const LICENSE_REQUIRED_QUALIFICATIONS = ['psychiatrist', 'nurse', 'social_worker'] as const;

export const LICENSE_NUMBER_MAX = 40;

export const GENDERS = ['male', 'female'] as const;

export type Qualification = (typeof QUALIFICATIONS)[number];
export type Gender = (typeof GENDERS)[number];
export type FoundVia = (typeof FOUND_VIA)[number];
export type EmailPreference = (typeof EMAIL_PREFERENCES)[number];

export type PublicUser = {
  id: string;
  email: string;
  isAdmin: boolean;
  country: string;
  city: string | null;
  qualification: Qualification;
  licenseNumber: string | null;
  gender: Gender | null;
  organization: string;
  title: string;
  foundVia: FoundVia;
  foundViaOther: string | null;
  emailPreference: EmailPreference;
  emailVerified: boolean;
  hideIntro: boolean;
};

export const USER_PUBLIC_COLUMNS = `
  id, email, is_admin, country, city, qualification, license_number, gender, organization, title,
  found_via, found_via_other, email_preference, email_verified_at, hide_intro
`;

export function isGender(v: unknown): v is Gender {
  return typeof v === 'string' && (GENDERS as readonly string[]).includes(v);
}

export function isQualification(v: unknown): v is Qualification {
  return typeof v === 'string' && (QUALIFICATIONS as readonly string[]).includes(v);
}

export function isFoundVia(v: unknown): v is FoundVia {
  return typeof v === 'string' && (FOUND_VIA as readonly string[]).includes(v);
}

export function isEmailPreference(v: unknown): v is EmailPreference {
  return typeof v === 'string' && (EMAIL_PREFERENCES as readonly string[]).includes(v);
}

export function qualificationRequiresLicense(qualification: string): boolean {
  return (LICENSE_REQUIRED_QUALIFICATIONS as readonly string[]).includes(qualification);
}

export function parseLicenseNumber(v: unknown): string {
  return typeof v === 'string' ? v.trim() : '';
}

export function licenseNumberError(qualification: string, licenseNumber: string): string | null {
  if (qualificationRequiresLicense(qualification) && !licenseNumber) {
    return 'License number is required';
  }
  if (licenseNumber.length > LICENSE_NUMBER_MAX) {
    return 'License number is too long';
  }
  return null;
}

export function publicUserFromRow(row: Record<string, unknown>): PublicUser {
  return {
    id: String(row.id),
    email: String(row.email),
    isAdmin: Boolean(row.is_admin),
    country: String(row.country),
    city: row.city == null || row.city === '' ? null : String(row.city),
    qualification: row.qualification as Qualification,
    licenseNumber:
      row.license_number == null || row.license_number === '' ? null : String(row.license_number),
    gender: isGender(row.gender) ? row.gender : null,
    organization: String(row.organization),
    title: String(row.title),
    foundVia: row.found_via as FoundVia,
    foundViaOther: row.found_via_other == null ? null : String(row.found_via_other),
    emailPreference: (row.email_preference as EmailPreference) || 'none',
    emailVerified: row.email_verified_at != null,
    hideIntro: Boolean(row.hide_intro),
  };
}

export function adminEmailList(): string[] {
  return (process.env.ADMIN_EMAILS || '')
    .split(',')
    .map((s) => s.trim().toLowerCase())
    .filter(Boolean);
}

export function isAdminEmail(email: string): boolean {
  return adminEmailList().includes(email.toLowerCase());
}

export async function userIsAdmin(client: Client, userId: string): Promise<boolean> {
  const { rows } = await client.query(`SELECT is_admin FROM users WHERE id = $1`, [userId]);
  return Boolean(rows[0]?.is_admin);
}

export async function touchLastAccess(client: Client, userId: string): Promise<void> {
  try {
    await client.query(
      `UPDATE users SET last_access_at = now()
        WHERE id = $1
          AND (last_access_at IS NULL OR last_access_at < now() - interval '5 minutes')`,
      [userId]
    );
  } catch (err) {
    const code = (err as { code?: string }).code;
    if (code === '42703') return;
    throw err;
  }
}

export type AdminUser = PublicUser & {
  createdAt: string | null;
  lastAccessAt: string | null;
  emailVerifiedAt: string | null;
};

export const ADMIN_USER_COLUMNS = `
  ${USER_PUBLIC_COLUMNS},
  created_at, last_access_at
`;

function isoOrNull(v: unknown): string | null {
  if (v == null) return null;
  const d = v instanceof Date ? v : new Date(String(v));
  return Number.isNaN(d.getTime()) ? null : d.toISOString();
}

export function adminUserFromRow(row: Record<string, unknown>): AdminUser {
  return {
    ...publicUserFromRow(row),
    createdAt: isoOrNull(row.created_at),
    lastAccessAt: isoOrNull(row.last_access_at),
    emailVerifiedAt: isoOrNull(row.email_verified_at),
  };
}
