-- Allow deep-link analytics event_type values.
-- Production currently rejects anything outside search/click/page_view (CHECK or ENUM),
-- which caused /api/analytics to 500 for search_link_* / card_link_* / share.

DO $$
DECLARE
  col_udt text;
  is_enum boolean := false;
  con record;
  enum_label text;
  labels text[] := ARRAY[
    'search',
    'click',
    'page_view',
    'share',
    'search_link_copied',
    'card_link_copied',
    'search_link_opened',
    'card_link_opened',
    'entry_link_copied',
    'unknown'
  ];
BEGIN
  SELECT c.udt_name
  INTO col_udt
  FROM information_schema.columns c
  WHERE c.table_schema = 'public'
    AND c.table_name = 'events'
    AND c.column_name = 'event_type';

  IF col_udt IS NULL THEN
    RAISE NOTICE 'events.event_type column not found — skipping';
    RETURN;
  END IF;

  SELECT EXISTS (
    SELECT 1 FROM pg_type t
    JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE n.nspname = 'public'
      AND t.typname = col_udt
      AND t.typtype = 'e'
  ) INTO is_enum;

  IF is_enum THEN
    FOREACH enum_label IN ARRAY labels LOOP
      BEGIN
        EXECUTE format('ALTER TYPE public.%I ADD VALUE IF NOT EXISTS %L', col_udt, enum_label);
      EXCEPTION
        WHEN duplicate_object THEN NULL;
      END;
    END LOOP;
    RAISE NOTICE 'Extended enum type %.%', 'public', col_udt;
    RETURN;
  END IF;

  -- Text / varchar with CHECK constraint(s) mentioning event_type
  FOR con IN
    SELECT c.conname
    FROM pg_constraint c
    JOIN pg_class t ON c.conrelid = t.oid
    JOIN pg_namespace n ON n.oid = t.relnamespace
    WHERE n.nspname = 'public'
      AND t.relname = 'events'
      AND c.contype = 'c'
      AND pg_get_constraintdef(c.oid) ILIKE '%event_type%'
  LOOP
    EXECUTE format('ALTER TABLE public.events DROP CONSTRAINT %I', con.conname);
  END LOOP;

  ALTER TABLE public.events
    ADD CONSTRAINT events_event_type_check
    CHECK (
      event_type IN (
        'search',
        'click',
        'page_view',
        'share',
        'search_link_copied',
        'card_link_copied',
        'search_link_opened',
        'card_link_opened',
        'entry_link_copied',
        'unknown'
      )
    );
END $$;
