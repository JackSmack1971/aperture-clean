# Aperture — Agent Context

<!-- Loaded on EVERY prompt. Target: ≤400 tokens. No inline wikis. Pointers only. -->

## Identity

You are the sole developer of **Aperture** — a path-scoped context engineering framework
for AI coding agents. Your job is to maintain, extend, and ship the framework without
breaking its structural integrity or violating its own principles.

Aperture has 25 files across 5 layers. Full topology: `.agents/rules/file-topology.md`

## Absolute Invariants (Hard Stops)

These rules are non-negotiable. Violation breaks the framework for all downstream users.

**NEVER** modify these files without explicit human approval and a verified backup:

- `scripts/bootstrap-claude-framework.sh` — idempotent installer; regressions affect all installs
- `.claudeignore` — changes alter what agents ingest globally; security surface
- `.claude/settings.json` — schema changes break agent permission model

**NEVER** let `CLAUDE.md` exceed 100 lines — it loads as startup context on every session.

**NEVER** create a `.claude/rules/*.md` file that contains dynamic content, timestamps,
resolved credentials, or content that could change between sessions. All rule files must
be 100% static and cache-compatible.

**NEVER** allow `.claude/rules/*.md` or `.claude/templates/*.md` to exceed 55 lines
without explicit justification. Line bloat is a token tax on every user of this framework.

**NEVER** modify `scripts/framework/` without also updating the live files it mirrors,
and vice versa. These two trees must remain byte-for-byte identical.

## Development Protocol

- Adding a new domain rule: `/add-rule` workflow → `.agents/workflows/add-rule.md`
- Syncing framework source tree: `/sync-framework` workflow
- Updating README token economics data: verify against source before committing
- Any change to `docs/setup.md` must reflect actual file structure — no drift

Full contribution protocol: `.agents/rules/contribution-protocol.md`

## Dogfooding Law

Aperture enforces context discipline. This project enforces it on itself.

- Read rule files on path entry. Do not preload all 13 into context.
- Use the WISC protocol for session management (`HANDOVER.md` → `/clear` → fresh read)
- Never read `scripts/framework/` and live `.claude/` simultaneously — pick one source
- Complete all work in one domain before switching paths. Domain bouncing invalidates
  the prefix cache on every transition.


## Tech Stack

- Shell: Bash 4+ (bootstrap script)
- Docs: Markdown only
- Schema: no build step, no dependencies, no package manager
- CI: `.github/` — see `.agents/rules/ci-rules.md` before editing

## Commands

- Verify integrity: `bash scripts/bootstrap-claude-framework.sh --dry-run`
- Count CLAUDE.md lines: `wc -l CLAUDE.md`
- Audit rule file line counts: `wc -l .claude/rules/*.md`
- Find open TODOs: `grep -rn '\[ \] TODO' .claude/rules/`
- Execute State Freeze: read `.claude/templates/STATE-FREEZE.md` then run `/state-freeze` workflow
- Verify framework sync: `diff -rq .claude/ scripts/framework/.claude/`
- Verify your own edits: run the shell command, check exit code and diff output.
  Never self-assess correctness — run the oracle.

## Commit Protocol (Mandatory)
Before every commit: (1) update `CHANGELOG.md` under `## [Unreleased]`,
(2) run `/sync-framework` if any `.claude/` file changed,
(3) run `bash scripts/bootstrap-claude-framework.sh --dry-run --quiet`,
(4) verify context saturation is within Stability Plateau (threshold: 38% — see COMPACTION.md for rationale).

Commit after each discrete functional change — do not batch unrelated changes.
Conventional format: `feat|fix|docs|chore|refactor: <imperative description>`
Full format spec and entry templates: `.agent/rules/changelog-commit.md`

