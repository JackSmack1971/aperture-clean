# Deprecated Components — Native Alignment Migration

This file tracks APERTURE-CLEAN components superseded by Claude Code native features during Phase 1 refactor (2026-04-25).

---

## Manual Rule-Loading Protocol
**Deprecated:** 2026-04-25  
**Reason:** Superseded by native path-scoped rule injection (`.claude/rules/*.md` with glob matchers)  
**Migration Path:** Remove explicit "Read CLAUDE.md + rule files" steps from agent protocol. Native runtime automatically injects matching rules when files in scope are accessed.  
**Rollback Procedure:** Restore lines 19-24 of `CLAUDE.md` ("Domain Skills Index") and instruct agent to manually read rules on directory entry.

---

## Manual Token-Counting Heuristics
**Deprecated:** 2026-04-25  
**Reason:** Superseded by native `/context` and `/cost` commands providing exact BPE telemetry  
**Migration Path:** Replace all "4 characters ≈ 1 token" estimation logic with `/context` command invocations.  
**Rollback Procedure:** Restore ROADMAP.md "Aperture Score" v1.x heuristic calculations.

---

## PreToolUse Lifecycle Hooks
**Deprecated:** 2026-04-25  
**Reason:** Confirmed unsupported in current Claude Code runtime (PoC Task 3 validation)  
**Migration Path:** Migrate all "hard blocking" security constraints to native `permissions` array in `settings.json`.  
**Rollback Procedure:** Not applicable (feature never operational).
