# Testing Rules — Path-Scoped Context
<!-- APERTURE-CLEAN v1.0 | Injected ONLY when agent reads/edits /tests or *.test.* -->
<!-- Static content only. Cache-compatible. Target: ≤55 lines. -->

<!-- ═══ HARD STOPS — READ FIRST ═══════════════════════════════ -->
RESTRICTED: coverage_report_read | assert NOT read_path MATCHES "coverage/**"
  REQUIRED: parse_failing_lines_only | source: CI_logs
RESTRICTED: sleep_in_test | assert NOT git_stage_contains(setTimeout|sleep)
  REQUIRED: async_await_only | fakes: [fakeTimers, wait_for]
<!-- ══════════════════════════════════════════════════════════ -->

## Test Runner & Framework
- Pointer: `docs/testing-strategy.md` — test pyramid rationale
- Pointer: `tests/fixtures/README.md` — fixture inventory, factory usage
- [ ] TODO: Define test runner (Jest / Vitest / pytest / Go test / RSpec)
- [ ] TODO: Define assertion library
- [ ] TODO: Define mock/stub library

## Coverage Thresholds
- [ ] TODO: Define minimum line coverage (enforced in CI)
- [ ] TODO: Define minimum branch coverage
- [ ] TODO: Define coverage exclusion policy
- [ ] TODO: Define coverage report output path: `coverage/` (in `.claudeignore`)

## Test Taxonomy & Naming
- [ ] TODO: Define co-location policy: test files alongside source OR mirrored tree
- [ ] TODO: Define naming convention: `<module>.test.ts`
- [ ] TODO: Enforce: test description must state behavior
- [ ] TODO: Define test categories and tags: `@unit` / `@integration` / `@e2e`

## Fixture & Snapshot Policy
- [ ] TODO: Define fixture strategy: static JSON / factory functions
- [ ] TODO: Snapshot policy: UI snapshots allowed (YES/NO)
- [ ] TODO: Enforce: snapshots require explicit review on diff

## Forbidden Patterns
- [ ] TODO: No shared mutable state between test cases
- [ ] TODO: No tests that pass only in a specific execution order

## Context Engineering Notes
- Do NOT read full coverage report — parse only the failing file's uncovered lines
- Do NOT dump entire test suite — read the single failing test + its subject module
- Fixture reads → targeted factory lookup only
- Large integration test suites → subagent returns failing test IDs only

## Populated By
- QA lead / test architect on project onboarding
- Last reviewed: [ TODO: date ]
