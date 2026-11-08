-- Migration 126 (8 Nov 2026)
-- The glossary follows the site language. In English, the page, the categories, and every term are in English.
-- Description approved with the glossary English plan on 08.11.2026.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

INSERT INTO site_audit_entries (entry_key, happened_at, title, description, area, card_keys, term_keys, migration)
VALUES (
  '2026-11-08-glossary-english',
  DATE '2026-11-08',
  'מילון המונחים באנגלית',
  'כשהאתר באנגלית, מילון המונחים כולו באנגלית: הכותרת, החיפוש, הקטגוריות, וההסבר של כל מונח. אין בו עברית. כשהאתר בעברית, המילון נשאר כפי שהוא.',
  'glossary',
  '{}',
  ARRAY['disability','sharam','nursing','rehab_basket','medical_committee','rights_utilization','guidance_service','cbt','somatic','emdr','therapy','psychodynamic','group_therapy','couples_therapy','family_therapy','art_therapy','occupational_therapy','hypnosis','online_therapy','tms','ketamine','ect','sgb','prism','spravato','tdcs','vns','dbs','psychiatrist','psychologist','social_worker','art_therapist','occupational_therapist_prof','hospitalization','voluntary_hosp','involuntary_hosp','psychiatric_order','day_hosp','home_hosp','balancing_homes','safe_house','crisis_team','alternatives','supported_housing','rehab_club','vocational_rehab','community_support','rehabilitation','hmo','clalit','maccabi','meuhedet','leumit','ptsd','cptsd','depression','anxiety','eating_disorders','bipolar','schizophrenia','ocd','adhd','mental_health_clinic','multidisciplinary_center','psychiatric_er','resilience_center','helpline','mental_support','day_treatment','form17','btl','moh','mod_rehab','one_soul','family_doctor','rehab_committee','supported_employment','hostel','open_closed_ward','sexual_trauma','medication','natal','eran','postpartum_depression','health_basket','kol_zchut','trauma','family_support','addictions'],
  '126_glossary_english.sql'
)
ON CONFLICT (entry_key) DO NOTHING;

COMMIT;
