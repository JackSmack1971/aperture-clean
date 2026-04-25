# Frontend Rules — Path-Scoped Context
<!-- APERTURE-CLEAN v1.0 | Injected ONLY when agent reads/edits /frontend/** -->
<!-- Static content only. Cache-compatible. Target: ≤50 lines. -->

<!-- ═══ HARD STOPS — READ FIRST ═══════════════════════════════ -->
RESTRICTED: inline_styling | assert NOT git_stage_contains(style={{)
  REQUIRED: design_token_classes | source: frontend/docs/design-tokens.md
RESTRICTED: prop_drilling | assert NOT prop_depth > 3
  REQUIRED: shared_state_refactor | target: [Zustand, Redux, Context]
<!-- ══════════════════════════════════════════════════════════ -->

## Component Conventions
- Pointer: `frontend/docs/component-library.md` — approved component inventory
- Pointer: `frontend/docs/design-tokens.md` — color, spacing, typography scale
- [ ] TODO: Define component framework (React / Vue / Svelte / Web Components)
- [ ] TODO: Define naming convention (PascalCase files / kebab-case CSS)
- [ ] TODO: Define barrel export policy

## Styling
- [ ] TODO: Define styling system (Tailwind / CSS Modules / styled-components)
- [ ] TODO: Define responsive breakpoint names and pixel values
- [ ] TODO: Define dark mode strategy

## State Management
- [ ] TODO: Define state layers: local / shared / server
- [ ] TODO: Define shared state store location

## Rendering & Performance
- [ ] TODO: Define SSR/SSG/CSR split per route type
- [ ] TODO: Enforce: no `useEffect` for derived state
- [ ] TODO: Define bundle split strategy

## Context Engineering Notes
- Do NOT dump full component files — read the interface/type block only
- Do NOT ingest full Tailwind config — query specific token value via grep
- Large component trees → subagent reads and returns affected node list only

## Populated By
- Frontend lead / design systems engineer on project onboarding
- Last reviewed: [ TODO: date ]
