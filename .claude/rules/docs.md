# Docs Rules — Path-Scoped Context
<!-- Injected when agent reads: /docs/**, *.md files outside root, /wiki/**, ADRs -->
<!-- Static content only. Cache-compatible. Target: ≤50 lines. -->

## Documentation Taxonomy
- Pointer: `docs/README.md` — full doc inventory and navigation map (read THIS before any doc tree exploration)
- Pointer: `docs/decisions/README.md` — ADR index (Architecture Decision Records)
- [ ] TODO: Define doc categories and home paths:
  - Architecture:  `docs/architecture/`
  - API contracts: `docs/api/`
  - Runbooks:      `docs/runbooks/`
  - Decisions:     `docs/decisions/` (ADRs)
  - Setup/onboard: `docs/setup.md`
  - Changelogs:    `CHANGELOG.md`

## ADR (Architecture Decision Record) Protocol
- [ ] TODO: Define ADR template location: `docs/decisions/_template.md`
- [ ] TODO: Define ADR naming: `ADR-{NNN}-{kebab-title}.md`
- [ ] TODO: Enforce: all major architectural decisions require an ADR entry before implementation
- [ ] TODO: ADR statuses: `Proposed` → `Accepted` → `Deprecated` → `Superseded by ADR-{NNN}`
- [ ] TODO: Superseded ADRs retained in history — never deleted

## Authoring Standards
- [ ] TODO: Define doc format (Markdown only — no HTML in docs)
- [ ] TODO: Define heading hierarchy: H1 = document title only; H2+ = sections
- [ ] TODO: Enforce: all code blocks have language tags (` ```python ` not ` ``` `)
- [ ] TODO: Define diagram format (Mermaid embedded in Markdown / draw.io / Excalidraw)
- [ ] TODO: Define link convention: relative paths only — no absolute URLs to internal docs

## Freshness Policy
- [ ] TODO: Define doc review cadence: architecture docs reviewed every 6 months
- [ ] TODO: Enforce: docs modified in same PR as the code change they describe
- [ ] TODO: Define stale doc label: `<!-- STALE: last verified {date} -->` at file top
- [ ] TODO: Runbooks tested against real incidents before marking `status: verified`

## Context Engineering Notes
- Do NOT read entire `/docs` tree to answer a single question — use `docs/README.md` as navigation map
- Do NOT ingest full ADR history — query by ADR number or keyword grep only
- For onboarding context: read `docs/setup.md` and `docs/architecture/overview.md` ONLY (two files max)
- Large architecture documents → fetch targeted section via heading anchor, not full file
- Doc tree exploration for refactoring → subagent builds doc inventory; returns file list + one-line descriptions

## Populated By
- Tech lead / engineering manager on project onboarding
- Last reviewed: [ TODO: date ]
