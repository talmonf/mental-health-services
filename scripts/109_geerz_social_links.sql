-- Migration 109 (2 Nov 2026)
-- גירז, rows 770 and 771: Facebook, LinkedIn, and Instagram.
-- The buttons show the network icon. 104 is unchanged.
-- Register as [ ] in database_updates_master.sql; do not mark [x].

BEGIN;

UPDATE directory_card_edits
SET public_fields = public_fields || jsonb_build_object(
      'add', 'https://www.facebook.com/GeerzIsrael/',
      'addLabel', '',
      'add2', 'https://www.linkedin.com/company/geerz/home/',
      'addLabel2', '',
      'add3', 'https://www.instagram.com/geerz_il/',
      'addLabel3', ''
    ),
    public_edited_at = now(),
    updated_at = now()
WHERE card_key IN (
  '770|||רכיבת הרים טיפולית לילדים ונוער, גילאי 7–16',
  '771|||רכיבת הרים טיפולית ללוחמים ומילואימניקים'
);

COMMIT;
