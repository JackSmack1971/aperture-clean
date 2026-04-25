# Implementation Plan v2.1: Path B (Skill-Based Automation)

Achieve framework alignment through verified hook discovery, custom path-matching logic, and an experimentally-validated invocation model.

## User Review Required

> [!IMPORTANT]
> This plan prioritizes **Validation and Discovery (T0.0-T0.5.1)** before any production file modifications. Fallback paths (Path A) are pre-defined for every discovery failure.

---

## Phase 0: Validation & Discovery

### T0.0: Hook System Validation
**Objective:** Confirm the hook system is enabled and reachable.
- **Action:** 
  ```bash
  if ! grep -q '"hooks"' .claude/hooks/hooks.json 2>/dev/null; then
    echo "BLOCKER: Hook system may not be enabled"
    exit 1
  fi
  ```
- **Success Criteria:** JSON exists and contains the "hooks" key.
- **Time:** 10m

### T0: Hook Payload Discovery
**Objective:** Determine exactly what data is available to `PostToolUse` hooks.
- **Action:** 
  1. Create `.claude/hooks/test-hook.sh`: `env | sort > .claude/snapshots/hook-env.log; echo "STDIN: $(cat)" >> .claude/snapshots/hook-env.log`.
  2. Register in `hooks.json` under `PostToolUse`.
  3. Trigger a tool error (e.g., `bash -c "exit 1"`) and a success (e.g., `ls`).
- **Success Criteria:** `hook-env.log` contains definitive signals for tool success/failure and error text.
- **Fallback (T0-FALLBACK):** Manual failure logging. Update `CLAUDE.md` to instruct the agent to manually append to `FAILURE_LEDGER.md` after tool errors.
- **Time:** 45m

### T0.5: Invocation Model Experimentation
**Objective:** Determine the most reliable way to trigger domain rule loading.
- **Experiments:**
  1. **Manual**: Can the agent be reliably instructed to call a skill by path?
  2. **PreToolUse Hook**: Can a hook script trigger a skill or force the agent to read a rule file?
  3. **Skill auto_load**: Does `settings.json` support an `auto_load` property for skills based on directory entry?
- **T0.5.1 (Skill-Call Research)**: Test if `.claude/hooks/test-skill-call.sh` can execute `claude-skill-invoke load-rules /api/test.ts` or equivalent.
- **Success Criteria:** Identify one functional method that loads `.claude/rules/api.md` when entering `/api`.
- **Fallback (T0.5-FALLBACK):** Manual rule-loading. Update `CLAUDE.md` with explicit `read_file` instructions for all 13 domains. The `load-rules` skill will be kept as a **manual command only** fallback.
- **Time:** 105m

---

## Phase 1: Implementation

### T1: Build load-rules Skill (from scratch)
**Objective:** Build the rule-loading logic to bridge the "Native Alignment" gap.
- **Logic:** Path pattern matching, deduplication (check context for existing rules), and explicit `read_file` invocation.
- **Time:** 60m

### T2: Implement post-tool-failure.sh (Conditional)
**Objective:** Automate `FAILURE_LEDGER.md` updates.
- **Action:** Implementation based on T0 discovery findings.
- **Time:** 60m

---

## Phase 2: Documentation & Cleanup

### T3a: Baseline CLAUDE.md Update
**Objective:** Standardize session hygiene and budget laws.
- **Content:** Tool-count heuristic (50 ops/80 ops), WISC protocol enforcement, State Freeze protocol.
- **Time:** 20m

### T3b: Automation Layer Update
**Objective:** Integrate verified skills and hooks.
- **Trigger:** Only if T0 or T0.5 discovery succeeds.
- **Content:** Skill-based entry instructions, hook-failure notifications.
- **Time:** 20m

### T4: Integration Testing
**Objective:** Final end-to-end validation.
- **Tests:** Force a tool failure; transition to `/db`.
- **Time:** 30m

---

## Rollback Procedure

**After Discovery (T0/T0.5):**
- Delete `.claude/hooks/test-hook.sh`
- Remove test hook registration from `hooks.json`
- Delete `.claude/snapshots/hook-env.log`
- Delete test skill files in `.claude/skills/test-*`

**After Partial Implementation (T1/T2):**
1. `git diff .claude/` to identify changes.
2. `git checkout .claude/` to revert.
3. Re-run `bootstrap-claude-framework.sh` if directory integrity is compromised.
4. Fall back to **T0/T0.5-FALLBACK** (Manual workflows).

---

## Revised Time Estimates Summary

| Phase | Tasks | Est. Time |
|:---|:---|:---|
| 0 | T0.0, T0, T0.5, T0.5.1 | 160m |
| 1 | T1, T2 | 120m |
| 2 | T3a, T3b, T4 | 70m |
| **Total** | | **350m (~5.8 hours)** |
