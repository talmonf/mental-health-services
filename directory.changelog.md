# directory.json changelog

Changes to the shape of [`directory.json`](https://nefesh-il.org/directory.json), which is
described by [`directory.schema.json`](https://nefesh-il.org/directory.schema.json).

This file tracks the **schema**, not the data. Entries are added and corrected continuously;
`export.source_last_updated` in the file itself tells you when the data was last curated, and
`export.generated_at` when the file was built.

## Compatibility promise

`export.schema_version` is semver:

- **Patch** — documentation or description changes only. Nothing a consumer reads changes.
- **Minor** — new fields added, or new values in an existing enum. Existing fields keep their
  names, types and meaning. Safe to pick up without reading this file.
- **Major** — a field was removed, renamed, retyped, or its meaning changed. Read this file
  before upgrading. Deprecated fields will be listed here for at least one minor version
  before removal, and will keep returning their old values in the meantime.

Fields are never silently repurposed. If a field's meaning has to change, it gets a new name
and the old one is deprecated.

## 1.0.0 — 2026-09-08

First published export.

Contains `groups`, `categories`, `entries`, `glossary` and `media`, plus an `export` block
carrying version, provenance, licence and counts.

`entries[].referral_codes` is present from the first export (nullable array of
`referral_route` codes). It sits alongside the free-text `notes` / `cost` / `target` fields
and does not replace them. `unknown` means the source did not say.

Notes for this version, which are properties of the underlying data rather than the format:

- The facet fields (`target`, `region`, `cost`, `specialty`, `diseases`, `languages`) are free
  text exactly as published by each source. They are not a controlled vocabulary and they are
  unevenly populated. Nulls mean "the source did not say", not "unrestricted".
- `referral_codes` is the first normalised vocabulary. It is populated where the source
  wording supports a code, otherwise `unknown` or null. Free-text `notes` / `cost` / `target`
  are never replaced. Coverage is measured in `docs/facet-coverage.md`.
- `row` is not unique. Nine rows are shared by two or three entries. `id` is the key.
- Eight entries are withheld from the export for one cycle as the control arm of a documented
  experiment; see `export.withheld_note`. None are emergency or crisis services. This is a
  deliberate incompleteness and it is disclosed in the file.
