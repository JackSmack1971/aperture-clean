# Frontend Rules — Path-Scoped Context
<!-- Injected ONLY when agent reads/edits files under /frontend -->
<!-- Static content only. No runtime values. Cache-compatible. -->
<!-- Target: ≤50 lines. Deep detail lives in pointer docs below. -->

## Component Conventions
- Pointer: `frontend/docs/component-library.md` — approved component inventory, usage contracts
- Pointer: `frontend/docs/design-tokens.md` — color, spacing, typography scale (source of truth)
- [ ] TODO: Define component framework (React / Vue / Svelte / Web Components)
- [ ] TODO: Define naming convention (PascalCase files / kebab-case CSS / co-located test files)
- [ ] TODO: Define barrel export policy (`index.ts` per feature folder — YES/NO)
- [ ] TODO: Define prop contract: required props explicit, optional props defaulted at definition

## Styling
- [ ] TODO: Define styling system (Tailwind / CSS Modules / styled-components / vanilla CSS)
- [ ] TODO: Enforce: NO inline `style={{}}` attributes — use design token classes only
- [ ] TODO: Define responsive breakpoint names and pixel values (document in design-tokens.md)
- [ ] TODO: Define dark mode strategy (CSS variables / class toggle / media query)

## State Management
- [ ] TODO: Define state layers: local (useState) / shared (Zustand / Redux) / server (React Query / SWR)
- [ ] TODO: Define forbidden patterns (prop drilling beyond 2 levels → lift to shared store)

## Rendering & Performance
- [ ] TODO: Define SSR/SSG/CSR split per route type
- [ ] TODO: Enforce: no `useEffect` for derived state — use `useMemo` / computed values
- [ ] TODO: Define bundle split strategy: route-level lazy loading minimum

## Context Engineering Notes
- Do NOT dump full component files to fix a prop type — read the interface/type block only
- Do NOT ingest full Tailwind config — query specific token value via grep
- Large component trees → subagent reads and returns affected node list only

## Populated By
- Frontend lead / design systems engineer on project onboarding
- Last reviewed: [ TODO: date ]
