# Deprecated Components — Native Alignment Migration

This file tracks APERTURE-CLEAN components superseded by Claude Code native features.
Updated 2026-09-18 after a context-engineering audit found the 2026-04-25 entries below
described intent that the shipped files did not actually implement — see `CHANGELOG.md`
`[Unreleased]` for what changed.

---

## Manual Rule-Loading Protocol
**Deprecated:** 2026-04-25 (claimed) → **actually implemented:** 2026-09-18  
**Reason:** Superseded by native path-scoped rule injection (`.claude/rules/*.md` with `paths:`
frontmatter). The 2026-04-25 entry declared this superseded, but none of the 13 rule files
had `paths:` frontmatter until the 2026-09-18 audit remediation — until then they loaded
unconditionally at launch like `CLAUDE.md`, and the "Domain Rule Index (Manual Load)"
section in `CLAUDE.md` was the only thing actually doing path-based dispatch (manually).  
**Migration Path:** Done — all 13 rules now carry `paths:` frontmatter; the manual-load
section has been removed from `CLAUDE.md` in favor of a plain reference table.  
**Known residual gap:** loading triggers on Read, not on Write of a brand-new file in an
untouched domain (open upstream issue) — see `CLAUDE.md` § Domain Rules.  
**Rollback Procedure:** Re-add an explicit "Read the matching rule file before editing"
instruction to `CLAUDE.md` if native loading proves unreliable in practice.

---

## Manual Token-Counting Heuristics
**Deprecated:** 2026-04-25 (claimed) → **actually implemented:** 2026-09-18  
**Reason:** Superseded by the native `/context` command. The prior `CLAUDE.md` still said
"`/tokens` and hooks are unavailable" while other files told the agent to run `/tokens`
(a command that does not exist) — both were wrong; `/context` is the real command.  
**Migration Path:** Done — `CLAUDE.md` and `QUICK-REF.md` now reference `/context` only.
The operation-count heuristic (`[Op X/80]` tagging, 50/80 op thresholds) has been removed
entirely rather than kept as a fallback — untested whether a model can self-count
operations reliably, and redundant now that `/context` is documented as real.  
**Rollback Procedure:** Restore the op-count scheme from git history (pre-2026-09-18) if
`/context` proves unavailable in a given runtime.

---

## PreToolUse Lifecycle Hooks
**Deprecated:** 2026-04-25 (claimed) → **corrected:** 2026-09-18  
**Reason:** The shipped `.claude/hooks/hooks.json` (`{"hooks": [{"trigger": ..., "action": ...}]}`)
was never the documented settings.json hooks schema (an object keyed by event name, e.g.
`SessionStart`, `PreToolUse`, `PreCompact`, with matcher groups). "Confirmed unsupported"
was a misdiagnosis of a non-conformant implementation, not a genuine runtime limitation.  
**Migration Path:** Done — hooks are now registered inline in `.claude/settings.json` →
`hooks` in the documented shape: `SessionStart` (session banner) and `PreCompact`
(runs `.claude/hooks/pre-compact.sh`). The standalone `hooks.json` file and the live-only
debug hook (`pre-tool-use.sh`, which wrote every tool input to an un-ignored log file) were
deleted. Hard-blocking security constraints remain in `permissions.deny`, not hooks.  
**Outstanding:** live verification that these hooks actually fire (trigger each event in a
throwaway session) has not been performed — see the 2026-09-18 audit, recommendation R04.  
**Rollback Procedure:** Not applicable (the prior hooks.json was never functional to roll back to).
