# Testing Rules — Path-Scoped Context
<!-- Injected ONLY when agent reads/edits files under /tests or *.test.* / *.spec.* -->
<!-- Static content only. Cache-compatible. -->
<!-- Target: ≤50 lines. Deep detail lives in pointer docs below. -->

## Test Runner & Framework
- Pointer: `docs/testing-strategy.md` — test pyramid rationale, layer responsibilities
- Pointer: `tests/fixtures/README.md` — fixture inventory, factory usage, seed data contracts
- [ ] TODO: Define test runner (Jest / Vitest / pytest / Go test / RSpec)
- [ ] TODO: Define assertion library (built-in / Chai / Hamcrest)
- [ ] TODO: Define mock/stub library (vi.mock / jest.mock / unittest.mock / Sinon)

## Coverage Thresholds
- [ ] TODO: Define minimum line coverage: ___% (enforce in CI — not advisory)
- [ ] TODO: Define minimum branch coverage: ___%
- [ ] TODO: Define coverage exclusion policy: generated files, migrations, `*.config.*` — explicitly listed
- [ ] TODO: Define coverage report output path: `coverage/` (must be in `.claudeignore`)

## Test Taxonomy & Naming
- [ ] TODO: Define co-location policy: test files alongside source OR mirrored `/tests` tree
- [ ] TODO: Define naming convention: `<module>.test.ts` / `test_<module>.py`
- [ ] TODO: Enforce: test description must state behavior, NOT implementation
  - ✅ `it('returns 401 when token is expired')`
  - ❌ `it('calls verifyToken and catches error')`
- [ ] TODO: Define test categories and tags: `@unit` / `@integration` / `@e2e` / `@slow`

## Fixture & Snapshot Policy
- [ ] TODO: Define fixture strategy: static JSON / factory functions / seeded DB transactions
- [ ] TODO: Snapshot policy: UI snapshots allowed (YES/NO); max snapshot file size
- [ ] TODO: Enforce: snapshots require explicit review on diff — no auto-accept in CI

## Forbidden Patterns
- [ ] TODO: No `setTimeout` / `sleep` in tests — use proper async/await or fake timers
- [ ] TODO: No shared mutable state between test cases
- [ ] TODO: No tests that pass only in a specific execution order

## Context Engineering Notes
- Do NOT read full coverage report into context — parse only the failing file's uncovered lines
- Do NOT dump entire test suite to debug one failure — read the single failing test + its subject module
- Fixture reads → targeted factory lookup only; never ingest full seed file
- Large integration test suites → subagent runs grep for failure pattern; returns failing test IDs only

## Populated By
- QA lead / test architect on project onboarding
- Last reviewed: [ TODO: date ]
