# Aperture-Clean Implementation Notes
<!-- Strategic summary for maintainers and future agents -->

## Summary of Refactor
This repository implements the **Aperture-Clean** context engineering framework. The
2026-04-25 "Path A (Manual Governance)" pivot documented below was based on a
non-conformant `hooks.json` and rule files with no `paths:` frontmatter — neither native
path-scoped loading nor hooks were actually implemented at the time, despite this file and
`README.md` claiming otherwise. A 2026-09-18 context-engineering audit found the gap
between documented and shipped behavior; both mechanisms are now implemented against the
documented Claude Code schema. See `CHANGELOG.md` `[Unreleased]` and `.claude/DEPRECATED.md`.

## What Was Attempted (2026-04-25, Discovery Phase)
- **Objective:** Automate domain rule injection and failure logging using native hooks.
- **Finding at the time:** `hooks.json` (`{"hooks": [{"trigger": ..., "action": ...}]}`)
  appeared inert. In hindsight this was because it used an invented schema, not the
  documented one — never observed against the documented `hooks` object shape.
- **Decision at the time:** Pivot to manual governance via `CLAUDE.md` and structural redundancy.

## What Changed (2026-09-18, Remediation)
1. **Native rule injection:** All 13 `.claude/rules/*.md` now carry `paths:` frontmatter and
   load on Read of a matching file. The manual "Domain Rule Index" mandatory-read section
   was removed from `CLAUDE.md` in favor of a plain reference table — the two no longer
   contradict each other. Known residual gap: does not trigger on Write of a brand-new file.
2. **Real hooks:** `.claude/settings.json` → `hooks` now registers `SessionStart` and
   `PreCompact` in the documented event-keyed schema. The old `hooks.json`/`hooksFile`
   indirection and the live-only debug hook (`pre-tool-use.sh`) were deleted.
3. **Deterministic credential protection:** `.claude/settings.json` → `permissions.deny`
   blocks Read/Edit/Write of `.env*`, `secrets/**`, `credentials/**`, `*.pem`, `*.key`, plus
   `Bash` denies for `sudo`, destructive `rm -rf`/`rm -fr`, and `cat` of the same paths.
4. **Context monitoring:** Operation-count heuristics (`[Op X/80]` tagging) removed in favor
   of the real `/context` command; `/tokens` (never a real command) removed from all docs.
5. **Failure logging:** `FAILURE_LEDGER.md` now append-only via `grep`-dedupe (no full-file
   Read); test-fixture entries purged; `pre-compact.sh` now enforces its own `MAX_SIZE` by
   rotating out the oldest records.

## Operational Constraints
- **Agent discipline:** the framework still relies on the agent following `CLAUDE.md` and
  running `/context`; nothing here is a hard runtime guarantee beyond `permissions.deny`.
- **Outstanding verification:** the new hooks and `paths:` frontmatter have not been
  exercised in a live Claude Code session from this repository — see the 2026-09-18 audit's
  recommendation R01/R02/R04 verification steps before treating them as proven.

## Future Automation Opportunities
- Migrate `FAILURE_LEDGER.md` updates to a `PostToolUse` failure-matching hook, once the
  `SessionStart`/`PreCompact` hooks above are confirmed to fire in a live session.

---
**Implementation Date:** 2026-04-25 (original) / 2026-09-18 (remediation)  
**Stability Score:** Unmeasured — prior "100% (Manual Validation)" figure was not backed by
a reproducible test; see `docs/framework/PATH_A_VALIDATION.md` for the historical note.
