# Discovery Phase Walkthrough: Path B Implementation

This document serves as the execution guide for the Aperture-Clean implementation. It maps discovery phase outcomes to downstream architectural consequences and provides recovery procedures for anticipated edge cases.

## Decision Tree: T0.0 → T0 → T0.5 → Final State

| Task | Outcome | Diagnostic Signal | Next Action | Fallback Triggered? | Final Architecture |
|:---|:---|:---|:---|:---|:---|
| **T0.0** | ✅ SUCCESS | `hooks.json` contains `"hooks"` key | → Proceed to T0 | No | [Continue Path B] |
| **T0.0** | ❌ FAIL | `hooks.json` missing or malformed | → Execute T0.0-FALLBACK | Yes | **Path A (Manual)** |
| **T0** | ✅ SUCCESS | `hook-env.log` contains `TOOL_SUCCESS=false` + `TOOL_ERROR=...` | → Proceed to T2 (auto failure logging) | No | Path B (hooks) |
| **T0** | ⚠️ PARTIAL | `hook-env.log` shows stdin data but no env vars | → T0-VARIANT (parse stdin) | Modified | Path B (stdin parsing) |
| **T0** | ❌ FAIL | `hook-env.log` empty or hook never triggered | → Execute T0-FALLBACK | Yes | **Path A (Manual)** |
| **T0.5** | ✅ MODEL 1 | Manual `/load-rules` command works | → T1 with manual invocation model | No | Path B (manual skill) |
| **T0.5** | ✅ MODEL 2 | PreToolUse hook triggers skill successfully | → T1 with hook invocation model | No | Path B (auto skill) |
| **T0.5** | ✅ MODEL 3 | `auto_load` flag executes skill on file ops | → T1 with auto_load model | No | Path B (auto skill) |
| **T0.5** | ❌ ALL FAIL | No model successfully loads rule file | → Execute T0.5-FALLBACK | Yes | **Path A (CLAUDE.md instructions)** |

---

## Edge Case Matrix

### T0 Edge Cases
1. **Hook triggers but outputs nothing**
   - **Diagnostic**: `hook-env.log` file exists but is empty (0 bytes).
   - **Likely cause**: Hook script lacks execute permissions.
   - **Recovery**: `chmod +x .claude/hooks/test-hook.sh` → Re-test.
   
2. **Hook outputs env vars but no failure signal**
   - **Diagnostic**: `hook-env.log` shows `PATH=...`, `HOME=...` but no `TOOL_*` vars.
   - **Likely cause**: Claude Code uses different variable names or stdin payload.
   - **Recovery**: Check stdin content → T0-VARIANT (parse JSON from stdin).

3. **Hook never executes**
   - **Diagnostic**: No `hook-env.log` file created after tool operations.
   - **Likely cause**: Hook system disabled or `hooks.json` syntax error.
   - **Recovery**: → T0-FALLBACK (Path A).

### T0.5 Edge Cases
1. **Model 1 works but skill reads wrong rule file**
   - **Diagnostic**: Skill executes but loads `api.md` when given `/db/schema.sql`.
   - **Likely cause**: Path-matching logic bug.
   - **Recovery**: Fix pattern in T1 implementation, re-test.

2. **Model 2: Hook triggers but skill command not found**
   - **Diagnostic**: Hook executes, shell returns `command not found: claude-skill-invoke`.
   - **Likely cause**: Skills must be sourced/executed differently.
   - **Recovery**: Research skill execution protocol → Fallback to Model 1 or 3.

3. **Model 3: auto_load flag accepted but skill never runs**
   - **Diagnostic**: No errors, but skill doesn't execute on file operations.
   - **Likely cause**: `auto_load` is not implemented in Claude Code (aspirational feature).
   - **Recovery**: → Use Model 1 (manual) or Model 2 (hook) if available.

### Rollback Edge Cases
1. **T1 fails mid-implementation (skill file corrupted)**
   - **Diagnostic**: Syntax error in `.claude/skills/load-rules/SKILL.md`.
   - **Recovery**: `git checkout .claude/skills/load-rules/` → Start T1 from clean state.

2. **T2 creates hook but breaks existing hooks**
   - **Diagnostic**: Other hooks stop working after `post-tool-failure.sh` added.
   - **Recovery**: `git diff .claude/hooks/hooks.json` → Revert malformed JSON → Re-add hook correctly.

3. **Full rollback required (abandon Path B entirely)**
   - **Trigger**: Both T0 and T0.5 fail, 2+ hours spent.
   - **Recovery**: Execute complete Path A implementation (30 min).

---

## Final Architecture Decision

1. **Full Path B**: Both T0 and T0.5 succeed. Result: **Automated hooks + Automated skills**. Highest fidelity.
2. **Hybrid Path B/A**: T0 fails but T0.5 succeeds. Result: **Manual failure logging + Automated rule loading**.
3. **Full Path A**: Both fail. Result: **Manual workflows with CLAUDE.md instructions**. Baseline compatibility.

---

## Time Estimates for Branch Paths

**Baseline Timings:**
- T0.0: 10m
- T0 (Discovery): 45m
- T0-FALLBACK: 15m
- T0.5 (Experiment): 105m
- T0.5-FALLBACK: 30m
- T1 (Manual Model): 45m
- T1 (Hook Model): 60m
- T2 (Auto Hook): 60m
- T3a/T3b (Total): 40m
- T4 (Validation): 30m

### Path Scenarios:

**Path: T0 ✅ → T0.5 ✅ (Full Path B)**
- Time: 10m (T0.0) + 45m (T0) + 105m (T0.5) + 60m (T1) + 60m (T2) + 40m (T3) + 30m (T4) = **350m (5h 50m)**

**Path: T0 ❌ → T0-FALLBACK → T0.5 ✅ (Hybrid Path B/A)**
- Time: 10m (T0.0) + 45m (T0) + 15m (T0-FALLBACK) + 105m (T0.5) + 45m (T1) + 20m (T3a) + 30m (T4) = **270m (4h 30m)**

**Path: T0 ❌ → T0-FALLBACK → T0.5 ❌ → T0.5-FALLBACK (Full Path A)**
- Time: 10m (T0.0) + 45m (T0) + 15m (T0-FALLBACK) + 105m (T0.5) + 30m (T0.5-FALLBACK) + 20m (T3a) = **225m (3h 45m)**
