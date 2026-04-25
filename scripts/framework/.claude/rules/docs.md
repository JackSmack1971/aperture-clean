# Docs Rules — Path-Scoped Context
<!-- APERTURE-CLEAN v1.0 | Injected when agent reads /docs/** or *.md files -->
<!-- Static content only. Cache-compatible. Target: ≤55 lines. -->

<!-- ═══ HARD STOPS — READ FIRST ═══════════════════════════════ -->
RESTRICTED: doc_tree_ingestion | assert NOT full_directory_read WHERE path MATCHES "/docs/**"
  REQUIRED: navigation_via_readme | target: docs/README.md
RESTRICTED: adr_deletion | assert NOT git_stage_contains(DELETE) WHERE path MATCHES "docs/decisions/*.md"
  REQUIRED: status_update_only | expected: [Deprecated, Superseded]
<!-- ══════════════════════════════════════════════════════════ -->

## Documentation Taxonomy
- Pointer: `docs/README.md` — full doc inventory and navigation map
- Pointer: `docs/decisions/README.md` — ADR index (Architecture Decision Records)
- [ ] TODO: Define doc categories and home paths (Architecture, API, Runbooks, Decisions)
- [ ] TODO: Define setup/onboard path: `docs/setup.md`
- [ ] TODO: Define changelog path: `CHANGELOG.md`

## ADR (Architecture Decision Record) Protocol
- [ ] TODO: Define ADR template location: `docs/decisions/_template.md`
- [ ] TODO: Define ADR naming: `ADR-{NNN}-{kebab-title}.md`
- [ ] TODO: Enforce: all major architectural decisions require an ADR entry
- [ ] TODO: ADR statuses: `Proposed` → `Accepted` → `Deprecated` → `Superseded`

## Authoring Standards
- [ ] TODO: Define doc format (Markdown only — no HTML in docs)
- [ ] TODO: Define heading hierarchy: H1 = document title only; H2+ = sections
- [ ] TODO: Enforce: all code blocks have language tags
- [ ] TODO: Define diagram format (Mermaid / draw.io / Excalidraw)
- [ ] TODO: Define link convention: relative paths only

## Freshness Policy
- [ ] TODO: Define doc review cadence
- [ ] TODO: Enforce: docs modified in same PR as code change
- [ ] TODO: Define stale doc label: `<!-- STALE: last verified {date} -->`

## Context Engineering Notes
- Do NOT read entire `/docs` tree — use `docs/README.md` as navigation map
- Do NOT ingest full ADR history — query by ADR number or keyword grep only
- For onboarding context: read `docs/setup.md` and `docs/architecture/overview.md` ONLY
- Large architecture documents → fetch targeted section via heading anchor

## Populated By
- Tech lead / engineering manager on project onboarding
- Last reviewed: [ TODO: date ]
