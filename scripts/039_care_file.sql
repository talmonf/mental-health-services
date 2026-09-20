-- 039_care_file.sql
--
-- Patient-owned care file (התיק שלי): timeline/events, documents, labs,
-- medications, contacts (orgs + people), notes, rights + committee
-- reminders, profile/HMO, family, diagnoses, therapy, activity, intake,
-- section-level sharing, time-limited read-only links, family proxy, audit.
--
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

ALTER TABLE users
  ADD COLUMN IF NOT EXISTS session_invalid_before TIMESTAMPTZ NOT NULL DEFAULT TIMESTAMPTZ '1970-01-01';

COMMENT ON COLUMN users.session_invalid_before IS
  'JWTs with iat before this instant are rejected. Bumped on logout so other devices drop.';

ALTER TABLE email_tokens DROP CONSTRAINT IF EXISTS email_tokens_kind_valid;
ALTER TABLE email_tokens ADD CONSTRAINT email_tokens_kind_valid
  CHECK (kind IN ('confirm', 'unsubscribe', 'care_otp'));

ALTER TABLE email_outbox DROP CONSTRAINT IF EXISTS email_outbox_kind_valid;
ALTER TABLE email_outbox ADD CONSTRAINT email_outbox_kind_valid
  CHECK (kind IN (
    'confirm', 'immediate', 'weekly', 'question_admin',
    'care_otp', 'care_grant_invite', 'care_grant_accepted', 'care_grant_revoked',
    'care_committee_reminder'
  ));

CREATE TABLE IF NOT EXISTS care_files (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id    UUID        NOT NULL UNIQUE REFERENCES users (id) ON DELETE CASCADE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE care_files IS
  'One personal care file per user. Created on first verified, OTP-gated open of /care.';

CREATE TABLE IF NOT EXISTS care_contacts (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  file_id             UUID        NOT NULL REFERENCES care_files (id) ON DELETE CASCADE,
  created_by_user_id  UUID        REFERENCES users (id) ON DELETE SET NULL,
  kind                TEXT        NOT NULL DEFAULT 'person',
  name                TEXT        NOT NULL,
  org_type            TEXT        NOT NULL DEFAULT '',
  website             TEXT        NOT NULL DEFAULT '',
  qualification       TEXT        NOT NULL DEFAULT '',
  role                TEXT        NOT NULL DEFAULT '',
  org_id              UUID        REFERENCES care_contacts (id) ON DELETE SET NULL,
  phone               TEXT        NOT NULL DEFAULT '',
  email               TEXT        NOT NULL DEFAULT '',
  referred_by_id      UUID        REFERENCES care_contacts (id) ON DELETE SET NULL,
  notes               TEXT        NOT NULL DEFAULT '',
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT care_contacts_kind_valid CHECK (kind IN ('person', 'org')),
  CONSTRAINT care_contacts_name_len CHECK (
    char_length(btrim(name)) >= 1 AND char_length(name) <= 200
  ),
  CONSTRAINT care_contacts_org_type_valid CHECK (
    org_type IN (
      '', 'rehab_provider', 'hospital', 'clinic', 'hmo', 'btl',
      'municipality', 'ngo', 'housing', 'employment', 'legal',
      'hostile_actions', 'other'
    )
  ),
  CONSTRAINT care_contacts_qualification_valid CHECK (
    qualification IN (
      '', 'social_work', 'psychiatrist', 'psychologist',
      'occupational_therapist', 'nurse', 'rehab_coordinator',
      'peer', 'lawyer', 'physician', 'other'
    )
  ),
  CONSTRAINT care_contacts_not_self CHECK (
    org_id IS DISTINCT FROM id AND referred_by_id IS DISTINCT FROM id
  ),
  CONSTRAINT care_contacts_short_len CHECK (
    char_length(role) <= 200 AND char_length(phone) <= 80
    AND char_length(email) <= 320 AND char_length(website) <= 400
    AND char_length(notes) <= 2000
  )
);

CREATE INDEX IF NOT EXISTS care_contacts_file_idx
  ON care_contacts (file_id, kind, created_at DESC);

COMMENT ON TABLE care_contacts IS
  'Organizations (ספק סל שיקום, ביטוח לאומי, …) and people. A person may have no org. referred_by_id is who pointed them to you.';

CREATE TABLE IF NOT EXISTS care_encounters (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  file_id             UUID        NOT NULL REFERENCES care_files (id) ON DELETE CASCADE,
  created_by_user_id  UUID        REFERENCES users (id) ON DELETE SET NULL,
  kind                TEXT        NOT NULL,
  occurred_on         DATE        NOT NULL,
  title               TEXT        NOT NULL,
  summary             TEXT        NOT NULL DEFAULT '',
  contact_id          UUID        REFERENCES care_contacts (id) ON DELETE SET NULL,
  org_id              UUID        REFERENCES care_contacts (id) ON DELETE SET NULL,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT care_encounters_kind_valid CHECK (
    kind IN (
      'hospital', 'home_hospital', 'psychiatrist', 'therapy', 'social_work',
      'meeting', 'committee', 'phone', 'email', 'home_visit', 'application', 'other'
    )
  ),
  CONSTRAINT care_encounters_title_len CHECK (
    char_length(btrim(title)) >= 1 AND char_length(title) <= 200
  ),
  CONSTRAINT care_encounters_summary_len CHECK (char_length(summary) <= 4000)
);

CREATE INDEX IF NOT EXISTS care_encounters_file_occurred_idx
  ON care_encounters (file_id, occurred_on DESC);

COMMENT ON TABLE care_encounters IS
  'Dated history: clinical visits, meetings, ועדות, phone calls. Optional link to a person and/or organization.';

CREATE TABLE IF NOT EXISTS care_lab_panels (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  file_id             UUID        NOT NULL REFERENCES care_files (id) ON DELETE CASCADE,
  created_by_user_id  UUID        REFERENCES users (id) ON DELETE SET NULL,
  drawn_on            DATE        NOT NULL,
  lab_name            TEXT        NOT NULL DEFAULT '',
  notes               TEXT        NOT NULL DEFAULT '',
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT care_lab_panels_name_len CHECK (char_length(lab_name) <= 200),
  CONSTRAINT care_lab_panels_notes_len CHECK (char_length(notes) <= 2000)
);

CREATE INDEX IF NOT EXISTS care_lab_panels_file_idx
  ON care_lab_panels (file_id, drawn_on DESC);

CREATE TABLE IF NOT EXISTS care_lab_results (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  file_id             UUID        NOT NULL REFERENCES care_files (id) ON DELETE CASCADE,
  created_by_user_id  UUID        REFERENCES users (id) ON DELETE SET NULL,
  panel_id            UUID        REFERENCES care_lab_panels (id) ON DELETE SET NULL,
  marker              TEXT        NOT NULL,
  custom_name         TEXT        NOT NULL DEFAULT '',
  value               TEXT        NOT NULL,
  unit                TEXT        NOT NULL DEFAULT '',
  flag                TEXT        NOT NULL DEFAULT '',
  measured_on         DATE        NOT NULL,
  notes               TEXT        NOT NULL DEFAULT '',
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT care_lab_results_marker_valid CHECK (
    marker IN (
      'b12', 'folate', 'vitamin_d', 'tsh', 'ft4', 'ferritin', 'hemoglobin',
      'glucose', 'hba1c', 'lithium', 'sodium', 'creatinine', 'alt', 'ast',
      'prolactin', 'cholesterol', 'triglycerides', 'crp', 'magnesium', 'zinc',
      'weight', 'bp', 'other'
    )
  ),
  CONSTRAINT care_lab_results_flag_valid CHECK (flag IN ('', 'low', 'normal', 'high')),
  CONSTRAINT care_lab_results_value_len CHECK (
    char_length(btrim(value)) >= 1 AND char_length(value) <= 80
  ),
  CONSTRAINT care_lab_results_short_len CHECK (
    char_length(custom_name) <= 80 AND char_length(unit) <= 40 AND char_length(notes) <= 2000
  )
);

CREATE INDEX IF NOT EXISTS care_lab_results_file_marker_idx
  ON care_lab_results (file_id, marker, measured_on DESC);

COMMENT ON TABLE care_lab_results IS
  'Typed measurements. MH-relevant presets include B12, folate, vitamin D, TSH, ferritin, lithium, prolactin, metabolic labs.';

CREATE TABLE IF NOT EXISTS care_documents (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  file_id             UUID        NOT NULL REFERENCES care_files (id) ON DELETE CASCADE,
  created_by_user_id  UUID        REFERENCES users (id) ON DELETE SET NULL,
  encounter_id        UUID        REFERENCES care_encounters (id) ON DELETE SET NULL,
  lab_panel_id        UUID        REFERENCES care_lab_panels (id) ON DELETE SET NULL,
  kind                TEXT        NOT NULL DEFAULT 'other',
  original_filename   TEXT        NOT NULL,
  content_type        TEXT        NOT NULL,
  byte_size           INT         NOT NULL,
  ciphertext          BYTEA       NOT NULL,
  nonce               BYTEA       NOT NULL,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT care_documents_kind_valid CHECK (kind IN ('other', 'lab')),
  CONSTRAINT care_documents_filename_len CHECK (
    char_length(btrim(original_filename)) >= 1 AND char_length(original_filename) <= 200
  ),
  CONSTRAINT care_documents_type_valid CHECK (
    content_type IN ('application/pdf', 'image/jpeg', 'image/png', 'image/webp')
  ),
  CONSTRAINT care_documents_size_valid CHECK (byte_size > 0 AND byte_size <= 2097152),
  CONSTRAINT care_documents_nonce_len CHECK (octet_length(nonce) = 12)
);

CREATE INDEX IF NOT EXISTS care_documents_file_created_idx
  ON care_documents (file_id, kind, created_at DESC);

CREATE TABLE IF NOT EXISTS care_medications (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  file_id             UUID        NOT NULL REFERENCES care_files (id) ON DELETE CASCADE,
  created_by_user_id  UUID        REFERENCES users (id) ON DELETE SET NULL,
  name                TEXT        NOT NULL,
  dose                TEXT        NOT NULL DEFAULT '',
  schedule            TEXT        NOT NULL DEFAULT '',
  started_on          DATE,
  ended_on            DATE,
  notes               TEXT        NOT NULL DEFAULT '',
  status              TEXT        NOT NULL DEFAULT 'current',
  prescriber          TEXT        NOT NULL DEFAULT '',
  efficacy            TEXT        NOT NULL DEFAULT '',
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT care_medications_name_len CHECK (
    char_length(btrim(name)) >= 1 AND char_length(name) <= 200
  ),
  CONSTRAINT care_medications_status_valid CHECK (status IN ('current', 'past', 'recommended')),
  CONSTRAINT care_medications_short_len CHECK (
    char_length(dose) <= 200 AND char_length(schedule) <= 200 AND char_length(notes) <= 2000
    AND char_length(prescriber) <= 200 AND char_length(efficacy) <= 2000
  )
);

CREATE INDEX IF NOT EXISTS care_medications_file_idx ON care_medications (file_id, started_on DESC NULLS LAST);

CREATE TABLE IF NOT EXISTS care_notes (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  file_id             UUID        NOT NULL REFERENCES care_files (id) ON DELETE CASCADE,
  created_by_user_id  UUID        REFERENCES users (id) ON DELETE SET NULL,
  body                TEXT        NOT NULL,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT care_notes_body_len CHECK (
    char_length(btrim(body)) >= 1 AND char_length(body) <= 8000
  )
);

CREATE INDEX IF NOT EXISTS care_notes_file_idx ON care_notes (file_id, created_at DESC);

CREATE TABLE IF NOT EXISTS care_profile (
  file_id              UUID        PRIMARY KEY REFERENCES care_files (id) ON DELETE CASCADE,
  created_by_user_id   UUID        REFERENCES users (id) ON DELETE SET NULL,
  full_name            TEXT        NOT NULL DEFAULT '',
  national_id          TEXT        NOT NULL DEFAULT '',
  birth_on             DATE,
  gender               TEXT        NOT NULL DEFAULT '',
  marital_status       TEXT        NOT NULL DEFAULT '',
  children_count       TEXT        NOT NULL DEFAULT '',
  phone                TEXT        NOT NULL DEFAULT '',
  address              TEXT        NOT NULL DEFAULT '',
  city                 TEXT        NOT NULL DEFAULT '',
  country_of_birth     TEXT        NOT NULL DEFAULT '',
  aliyah_year          TEXT        NOT NULL DEFAULT '',
  languages            TEXT        NOT NULL DEFAULT '',
  education            TEXT        NOT NULL DEFAULT '',
  employment           TEXT        NOT NULL DEFAULT '',
  military             TEXT        NOT NULL DEFAULT '',
  housing              TEXT        NOT NULL DEFAULT '',
  hmo                  TEXT        NOT NULL DEFAULT '',
  hmo_member_since     DATE,
  clinic_name          TEXT        NOT NULL DEFAULT '',
  allergies            TEXT        NOT NULL DEFAULT '',
  emergency_name       TEXT        NOT NULL DEFAULT '',
  emergency_phone      TEXT        NOT NULL DEFAULT '',
  emergency_relation   TEXT        NOT NULL DEFAULT '',
  created_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at           TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT care_profile_hmo_valid CHECK (
    hmo IN ('', 'clalit', 'maccabi', 'meuhedet', 'leumit', 'other')
  ),
  CONSTRAINT care_profile_short_len CHECK (
    char_length(full_name) <= 200 AND char_length(national_id) <= 20
    AND char_length(gender) <= 40 AND char_length(marital_status) <= 40
    AND char_length(children_count) <= 40 AND char_length(phone) <= 80
    AND char_length(address) <= 400 AND char_length(city) <= 100
    AND char_length(country_of_birth) <= 100 AND char_length(aliyah_year) <= 10
    AND char_length(languages) <= 200 AND char_length(education) <= 400
    AND char_length(employment) <= 400 AND char_length(military) <= 400
    AND char_length(housing) <= 400 AND char_length(clinic_name) <= 200
    AND char_length(allergies) <= 1000 AND char_length(emergency_name) <= 200
    AND char_length(emergency_phone) <= 80 AND char_length(emergency_relation) <= 80
  )
);

CREATE TABLE IF NOT EXISTS care_hmo_history (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  file_id             UUID        NOT NULL REFERENCES care_files (id) ON DELETE CASCADE,
  created_by_user_id  UUID        REFERENCES users (id) ON DELETE SET NULL,
  hmo                 TEXT        NOT NULL,
  started_on          DATE,
  ended_on            DATE,
  notes               TEXT        NOT NULL DEFAULT '',
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT care_hmo_history_hmo_valid CHECK (
    hmo IN ('clalit', 'maccabi', 'meuhedet', 'leumit', 'other')
  ),
  CONSTRAINT care_hmo_history_notes_len CHECK (char_length(notes) <= 2000)
);

CREATE INDEX IF NOT EXISTS care_hmo_history_file_idx
  ON care_hmo_history (file_id, started_on DESC NULLS LAST);

CREATE TABLE IF NOT EXISTS care_family (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  file_id             UUID        NOT NULL REFERENCES care_files (id) ON DELETE CASCADE,
  created_by_user_id  UUID        REFERENCES users (id) ON DELETE SET NULL,
  name                TEXT        NOT NULL,
  relation            TEXT        NOT NULL DEFAULT '',
  phone               TEXT        NOT NULL DEFAULT '',
  email               TEXT        NOT NULL DEFAULT '',
  lives_with          BOOLEAN     NOT NULL DEFAULT false,
  involved            BOOLEAN     NOT NULL DEFAULT false,
  notes               TEXT        NOT NULL DEFAULT '',
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT care_family_name_len CHECK (char_length(btrim(name)) >= 1 AND char_length(name) <= 200),
  CONSTRAINT care_family_short_len CHECK (
    char_length(relation) <= 80 AND char_length(phone) <= 80
    AND char_length(email) <= 320 AND char_length(notes) <= 2000
  )
);

CREATE INDEX IF NOT EXISTS care_family_file_idx ON care_family (file_id, created_at DESC);

CREATE TABLE IF NOT EXISTS care_diagnoses (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  file_id             UUID        NOT NULL REFERENCES care_files (id) ON DELETE CASCADE,
  created_by_user_id  UUID        REFERENCES users (id) ON DELETE SET NULL,
  name                TEXT        NOT NULL,
  code                TEXT        NOT NULL DEFAULT '',
  diagnosed_on        DATE,
  diagnosed_by        TEXT        NOT NULL DEFAULT '',
  status              TEXT        NOT NULL DEFAULT 'active',
  notes               TEXT        NOT NULL DEFAULT '',
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT care_diagnoses_name_len CHECK (char_length(btrim(name)) >= 1 AND char_length(name) <= 200),
  CONSTRAINT care_diagnoses_status_valid CHECK (status IN ('active', 'historical')),
  CONSTRAINT care_diagnoses_short_len CHECK (
    char_length(code) <= 40 AND char_length(diagnosed_by) <= 200 AND char_length(notes) <= 2000
  )
);

CREATE INDEX IF NOT EXISTS care_diagnoses_file_idx ON care_diagnoses (file_id, diagnosed_on DESC NULLS LAST);

CREATE TABLE IF NOT EXISTS care_therapy (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  file_id             UUID        NOT NULL REFERENCES care_files (id) ON DELETE CASCADE,
  created_by_user_id  UUID        REFERENCES users (id) ON DELETE SET NULL,
  modality            TEXT        NOT NULL DEFAULT '',
  therapist_name      TEXT        NOT NULL,
  started_on          DATE,
  ended_on            DATE,
  frequency           TEXT        NOT NULL DEFAULT '',
  notes               TEXT        NOT NULL DEFAULT '',
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT care_therapy_name_len CHECK (
    char_length(btrim(therapist_name)) >= 1 AND char_length(therapist_name) <= 200
  ),
  CONSTRAINT care_therapy_short_len CHECK (
    char_length(modality) <= 80 AND char_length(frequency) <= 200 AND char_length(notes) <= 2000
  )
);

CREATE INDEX IF NOT EXISTS care_therapy_file_idx ON care_therapy (file_id, started_on DESC NULLS LAST);

CREATE TABLE IF NOT EXISTS care_activities (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  file_id             UUID        NOT NULL REFERENCES care_files (id) ON DELETE CASCADE,
  created_by_user_id  UUID        REFERENCES users (id) ON DELETE SET NULL,
  kind                TEXT        NOT NULL DEFAULT 'sport',
  name                TEXT        NOT NULL,
  frequency           TEXT        NOT NULL DEFAULT '',
  started_on          DATE,
  notes               TEXT        NOT NULL DEFAULT '',
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT care_activities_kind_valid CHECK (kind IN ('sport', 'walking', 'gym', 'yoga', 'other')),
  CONSTRAINT care_activities_name_len CHECK (char_length(btrim(name)) >= 1 AND char_length(name) <= 200),
  CONSTRAINT care_activities_short_len CHECK (char_length(frequency) <= 200 AND char_length(notes) <= 2000)
);

CREATE INDEX IF NOT EXISTS care_activities_file_idx ON care_activities (file_id, created_at DESC);

CREATE TABLE IF NOT EXISTS care_rights (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  file_id             UUID        NOT NULL REFERENCES care_files (id) ON DELETE CASCADE,
  created_by_user_id  UUID        REFERENCES users (id) ON DELETE SET NULL,
  kind                TEXT        NOT NULL,
  status              TEXT        NOT NULL DEFAULT 'not_started',
  percent_a           TEXT        NOT NULL DEFAULT '',
  percent_b           TEXT        NOT NULL DEFAULT '',
  valid_until         DATE,
  summary             TEXT        NOT NULL DEFAULT '',
  notes               TEXT        NOT NULL DEFAULT '',
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT care_rights_kind_valid CHECK (
    kind IN (
      'disability_mental', 'disability_general', 'work_incapacity',
      'rehab_basket', 'special_services', 'hostile_actions',
      'income_support', 'housing', 'other'
    )
  ),
  CONSTRAINT care_rights_status_valid CHECK (
    status IN (
      'not_started', 'applied', 'waiting_committee', 'committee_held',
      'approved', 'rejected', 'appeal_planned', 'appeal_filed', 'temporary', 'closed'
    )
  ),
  CONSTRAINT care_rights_short_len CHECK (
    char_length(percent_a) <= 20 AND char_length(percent_b) <= 20
    AND char_length(summary) <= 500 AND char_length(notes) <= 2000
  )
);

CREATE INDEX IF NOT EXISTS care_rights_file_idx ON care_rights (file_id, kind);

COMMENT ON TABLE care_rights IS
  'מיצוי זכויות: נכות נפשית, נכות כללית, סל שיקום, שירותים מיוחדים, פעולות איבה, ועוד.';

CREATE TABLE IF NOT EXISTS care_committees (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  file_id             UUID        NOT NULL REFERENCES care_files (id) ON DELETE CASCADE,
  created_by_user_id  UUID        REFERENCES users (id) ON DELETE SET NULL,
  rights_id           UUID        REFERENCES care_rights (id) ON DELETE SET NULL,
  body                TEXT        NOT NULL,
  title               TEXT        NOT NULL,
  scheduled_on        DATE        NOT NULL,
  scheduled_time      TEXT        NOT NULL DEFAULT '',
  place               TEXT        NOT NULL DEFAULT '',
  status              TEXT        NOT NULL DEFAULT 'upcoming',
  remind              BOOLEAN     NOT NULL DEFAULT true,
  last_reminded_on    DATE,
  notes               TEXT        NOT NULL DEFAULT '',
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT care_committees_body_valid CHECK (
    body IN (
      'btl', 'disability_general', 'hostile_actions',
      'rehab', 'special_services', 'other'
    )
  ),
  CONSTRAINT care_committees_status_valid CHECK (status IN ('upcoming', 'held', 'cancelled')),
  CONSTRAINT care_committees_title_len CHECK (
    char_length(btrim(title)) >= 1 AND char_length(title) <= 200
  ),
  CONSTRAINT care_committees_short_len CHECK (
    char_length(scheduled_time) <= 40 AND char_length(place) <= 200 AND char_length(notes) <= 2000
  )
);

CREATE INDEX IF NOT EXISTS care_committees_file_when_idx
  ON care_committees (file_id, scheduled_on);
CREATE INDEX IF NOT EXISTS care_committees_remind_idx
  ON care_committees (scheduled_on)
  WHERE remind = true AND status = 'upcoming';

COMMENT ON TABLE care_committees IS
  'Upcoming/past ועדות including נכות כללית and פעולות איבה. Cron emails 7/3/1 days before when remind is true.';

CREATE TABLE IF NOT EXISTS care_intake (
  file_id                 UUID        PRIMARY KEY REFERENCES care_files (id) ON DELETE CASCADE,
  created_by_user_id      UUID        REFERENCES users (id) ON DELETE SET NULL,
  presenting_problem      TEXT        NOT NULL DEFAULT '',
  psychiatric_history     TEXT        NOT NULL DEFAULT '',
  medical_history         TEXT        NOT NULL DEFAULT '',
  substance_use           TEXT        NOT NULL DEFAULT '',
  self_harm_history       TEXT        NOT NULL DEFAULT '',
  legal_issues            TEXT        NOT NULL DEFAULT '',
  supports                TEXT        NOT NULL DEFAULT '',
  sleep_appetite          TEXT        NOT NULL DEFAULT '',
  other                   TEXT        NOT NULL DEFAULT '',
  created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT care_intake_len CHECK (
    char_length(presenting_problem) <= 4000 AND char_length(psychiatric_history) <= 4000
    AND char_length(medical_history) <= 4000 AND char_length(substance_use) <= 4000
    AND char_length(self_harm_history) <= 4000 AND char_length(legal_issues) <= 4000
    AND char_length(supports) <= 4000 AND char_length(sleep_appetite) <= 2000
    AND char_length(other) <= 4000
  )
);

CREATE TABLE IF NOT EXISTS care_grants (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  file_id             UUID        NOT NULL REFERENCES care_files (id) ON DELETE CASCADE,
  grantee_user_id     UUID        REFERENCES users (id) ON DELETE SET NULL,
  grantee_email       TEXT        NOT NULL,
  kind                TEXT        NOT NULL,
  can_write           BOOLEAN     NOT NULL DEFAULT false,
  sections            TEXT[]      NOT NULL,
  status              TEXT        NOT NULL DEFAULT 'pending',
  expires_at          TIMESTAMPTZ,
  accepted_at         TIMESTAMPTZ,
  revoked_at          TIMESTAMPTZ,
  created_by_user_id  UUID        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT care_grants_email_lower CHECK (grantee_email = lower(btrim(grantee_email))),
  CONSTRAINT care_grants_kind_valid CHECK (kind IN ('timed', 'proxy')),
  CONSTRAINT care_grants_status_valid CHECK (status IN ('pending', 'active', 'revoked')),
  CONSTRAINT care_grants_expiry_matches_kind CHECK (
    (kind = 'proxy' AND expires_at IS NULL)
    OR (kind = 'timed' AND expires_at IS NOT NULL)
  ),
  CONSTRAINT care_grants_sections_valid CHECK (
    cardinality(sections) >= 1
    AND sections <@ ARRAY[
      'timeline','documents','medications','contacts','notes',
      'rights','profile','family','diagnoses','therapy','activity','intake','labs'
    ]::text[]
  )
);

CREATE INDEX IF NOT EXISTS care_grants_file_status_idx ON care_grants (file_id, status);
CREATE INDEX IF NOT EXISTS care_grants_email_status_idx ON care_grants (grantee_email, status);

CREATE TABLE IF NOT EXISTS care_share_links (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  file_id             UUID        NOT NULL REFERENCES care_files (id) ON DELETE CASCADE,
  token_hash          TEXT        NOT NULL UNIQUE,
  sections            TEXT[]      NOT NULL,
  expires_at          TIMESTAMPTZ NOT NULL,
  revoked_at          TIMESTAMPTZ,
  created_by_user_id  UUID        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_viewed_at      TIMESTAMPTZ,

  CONSTRAINT care_share_links_sections_valid CHECK (
    cardinality(sections) >= 1
    AND sections <@ ARRAY[
      'timeline','documents','medications','contacts','notes',
      'rights','profile','family','diagnoses','therapy','activity','intake','labs'
    ]::text[]
  )
);

CREATE INDEX IF NOT EXISTS care_share_links_file_idx ON care_share_links (file_id, created_at DESC);

CREATE TABLE IF NOT EXISTS care_audit_events (
  id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  file_id         UUID        NOT NULL REFERENCES care_files (id) ON DELETE CASCADE,
  actor_user_id   UUID        REFERENCES users (id) ON DELETE SET NULL,
  actor_kind      TEXT        NOT NULL,
  action          TEXT        NOT NULL,
  section         TEXT,
  item_id         UUID,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT care_audit_actor_kind_valid CHECK (
    actor_kind IN ('owner', 'grantee', 'share_link')
  ),
  CONSTRAINT care_audit_action_len CHECK (char_length(action) >= 1 AND char_length(action) <= 40)
);

CREATE INDEX IF NOT EXISTS care_audit_file_created_idx
  ON care_audit_events (file_id, created_at DESC);

COMMENT ON TABLE care_audit_events IS
  'Who viewed, changed, shared, or revoked. Never stores document bodies or share tokens.';

COMMIT;
