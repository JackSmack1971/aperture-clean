# Aperture — Agent Context

<!-- Loaded on EVERY prompt. Target: ≤400 tokens. No inline wikis. Pointers only. -->

## Identity

Developer of **Aperture** — a path-scoped context framework for AI agents. Maintain integrity and ship without breaking its structural principles. 25 files, 5 layers. Topology: `.agents/rules/file-topology.md`

## Absolute Invariants (Hard Stops)

Non-negotiable. Violation breaks framework for all users.

**NEVER** modify without human approval/backup:
- `scripts/bootstrap-claude-framework.sh` (installer)
- `.claudeignore` (ingestion/security)
- `.claude/settings.json` (permissions)

**NEVER** let `CLAUDE.md` exceed 100 lines.
**NEVER** create `.claude/rules/*.md` with dynamic content/credentials. Must be 100% static.
**NEVER** allow `.claude/rules/*.md` or `templates/*.md` to exceed 55 lines.
**NEVER** modify `scripts/framework/` without mirroring to live `.claude/` (and vice versa).

## Development Protocol

- New rule: `/add-rule` → `.agents/workflows/add-rule.md`
- Sync: `/sync-framework` workflow
- Update README tokens: verify against source
- `docs/setup.md` must match actual structure
- Full protocol: `.agents/rules/contribution-protocol.md`

## Dogfooding Law

Aperture enforces context discipline. This project enforces it on itself.

- Read rule files on path entry. Do not preload all 13 into context.
- Use the WISC protocol for session management (`HANDOVER.md` → `/clear` → fresh read)
- Apply task-class compaction threshold: SYNTHESIS→40% | DEBUGGING→30% | REFACTOR→35%
  Load the matching MVCS template at session start to confirm the threshold.
  Default (unknown task): 38% (the universal sigmoid collapse safety margin).
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

## Documentation
- User deployment with Antigravity: `docs/antigravity-guide.md`

## Commit Protocol (Mandatory)
Before every commit: (1) update `CHANGELOG.md` under `## [Unreleased]`,
(2) run `/sync-framework` if any `.claude/` file changed,
(3) run `bash scripts/bootstrap-claude-framework.sh --dry-run --quiet`,
(4) verify context saturation is within Stability Plateau (threshold: 38% — see COMPACTION.md for rationale).

Commit after each discrete functional change — do not batch unrelated changes.
Conventional format: `feat|fix|docs|chore|refactor: <imperative description>`
Full format spec and entry templates: `.agent/rules/changelog-commit.md`

