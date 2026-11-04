-- Migration 113 (4 Nov 2026)
-- The directory can be opened in English at /en.
-- Cards whose visible wording has no Hebrew are left out of the Hebrew lists.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-04-english-entry',
  DATE '2026-11-04',
  'כניסה באנגלית, בלי כרטיסים שכתובים רק באנגלית',
  'הכתובת nefesh-il.org/en פותחת את המדריך באנגלית. כרטיס שכל הנוסח שלו באנגלית לא מופיע ברשימות כשהמדריך בעברית.',
  'ui',
  ARRAY[
    '18|||Provides English-speakers with access to verified mental health specialists as well as resources and information on navigating the mental health system in Israel',
    '76|||Crisis Support, Family Support, Family & Sibling Therapy, Legal Support, Mentors and Volunteers, Network of Professionals',
    '77|||Israel''s Emergency Mental Health Resources During War - Comprehensive list of mental health resources',
    '80|||Clinical case management for English-speakers in Israel from all walks of life: counseling, referrals to therapists, treatment programs, guidance through the legal process',
    '81|||Help finding qualified mental health providers for English-speakers',
    '93|||CBT, DBT, and Exposure-Based Therapies',
    '102|||Therapy clinic for teenagers & young adults (11-27) and parents; specializes in Anglo olim; Halachik framework; therapy for individuals, couples and families',
    '106|||Access center for psychedelic treatment and therapy.',
    '272|||Ketamine-assisted psychotherapy in Jerusalem: psychiatrist and KAP therapist (mainly IM ketamine with preparation and integration) for treatment-resistant depression, PTSD and anxiety.',
    '775|||Counseling in English for adults in Jerusalem'
  ],
  '{}',
  '113_english_entry.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
