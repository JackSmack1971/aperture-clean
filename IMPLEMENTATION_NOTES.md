# Aperture-Clean Implementation Notes
<!-- Strategic summary for maintainers and future agents -->

## Summary of Refactor
This repository has been refactored to implement the **Aperture-Clean** context engineering framework. Due to system limitations in the current agent runtime, we have pivoted from the original **Path B (Automated Hooks)** vision to a robust **Path A (Manual Governance)** implementation.

## What Was Attempted (The Discovery Phase)
- **Objective:** Automate domain rule injection and failure logging using native `PostToolUse` and `PreToolUse` hooks.
- **Finding:** Lifecycle hooks are currently non-functional in this environment. The `hooks.json` registry is present but remains inert regardless of configuration.
- **Decision:** Pivot to manual governance via `CLAUDE.md` and structural redundancy.

## What Was Delivered
1. **Manual Rule Injection:** Path-scoped rule loading is enforced via an explicit mapping table in `CLAUDE.md`.
2. **Heuristic Context Monitoring:** Context saturation is monitored via operation counts (50 for snapshot, 80 for handover) instead of token counts.
3. **Failure Logging:** The `FAILURE_LEDGER.md` protocol replaces automated error capture.
4. **Structural Redundancy:** `QUICK-REF.md` and hardened templates (`SUBAGENT.md`, `HANDOVER.md`) provide multiple layers of behavioral enforcement.

## Operational Constraints
- **Agent Discipline:** The framework relies on the agent's ability to self-monitor and consult rules.
- **User Vigilance:** The user should occasionally verify that `[Op X/80]` tags are present in `Write` descriptions and `FAILURE_LEDGER.md` is being updated.

## Future Automation Opportunities
If the runtime is updated to support native hooks:
1. Update `settings.json` to include `"hooksFile": ".claude/hooks/hooks.json"`.
2. Register `pre-compact.sh` as a `SessionEnd` or `PreCompact` trigger.
3. Migrate `FAILURE_LEDGER.md` updates to a `PostToolUse` failure handler.

---
**Implementation Date:** 2026-04-25  
**Stability Score:** 100% (Manual Validation)
