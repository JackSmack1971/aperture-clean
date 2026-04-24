# Antigravity Deployment Guide — Aperture Framework
<!-- APERTURE-CLEAN v1.0 | Antigravity Chronicle -->

## 1. Antigravity IDE Capabilities
Google Antigravity provides an agentic environment optimized for large-scale codebase modifications. Key features used in this deployment:
- **Artifacts**: For structured reports and walkthroughs.
- **Planning Mode**: For milestone-gated technical strategy.
- **Multiturn Execution**: Handling complex sequences (Phases 1-6) with persistent state.
- **Shell Tooling**: Direct bash/powershell interaction for verification.

## 2. Deployment Chronicle (Phase 1-6)
- **Phase 0: Context Onboarding**: Codebase exploration and map generation.
- **Phase 1: Foundation**: CLAUDE.md, .claudeignore, and directory scaffolding.
- **Phase 2: Skills**: 18 SKILL.md files (13 domain, 5 operational).
- **Phase 3: Hooks**: hooks.json and pre-compact.sh automation.
- **Phase 4: Templates**: HANDOVER, FAILURE_LEDGER, SUBAGENT, COMPACTION.
- **Phase 5: Documentation**: setup.md and QUICK-REF.md.
- **Phase 6: Verification**: End-to-end integrity audit and PR organization.

## 3. Issues & Solutions
1. **CRLF Line Endings**: Windows host caused `verify_phase6.sh` to fail with `\r` errors. 
   - *Solution*: `sed -i 's/\r$//' verify_phase6.sh` in the deployment workflow.
2. **Ghost .gitkeep Files**: Placeholders used for scaffolding remained after file population, bloating file counts.
   - *Solution*: Automated cleanup step added to Phase 6 verification.
3. **Sequential Merging**: Dependency order (1->2->3) required careful branch management.
   - *Solution*: Manual sequential merges to `main` with verification gates.
4. **Context Saturation**: Session reached 38% saturation at Phase 4.
   - *Solution*: Triggered `COMPACTION.md` protocol to reset context before final phases.
5. **PR Documentation**: Need for reviewable chunks in a large deployment.
   - *Solution*: Atomic feature branches and `.github/pull_requests/` markdown generators.

## 4. Prompt Engineering Patterns
- **Milestone Gating**: "STOP HERE. Report status" commands to prevent agent drift.
- **XML Context Wrapping**: Using `<context>`, `<task>`, and `<success_criteria>` for deterministic execution.
- **Inline Verification**: Embedding bash scripts directly in the prompt to verify work immediately.
- **Success Criteria**: Explicitly defining 🟢/🔴 status markers for automated audits.

## 5. Workflow Integration
Aperture integrates with Antigravity via:
- **Planning Mode**: Alignment between `implementation_plan.md` and Aperture phases.
- **Task Tracking**: `task.md` synchronization with Aperture checklists.
- **WISC Protocol**: Leveraging Antigravity's multi-file edit capabilities for "Isolate" and "Select" steps.

## 6. Gemini-Specific Optimizations
Aperture's `CLAUDE.md` static prefix (≤100 lines) is optimized for Gemini's prompt caching, ensuring low-latency session resumes.

## 7. Cross-Agent Compatibility
While built for Claude Code, Aperture on Antigravity establishes a common protocol (WISC) that allows a session to start in the CLI and be resumed in the IDE via `HANDOVER.md`.

## 8. First Session Checklist (Antigravity)
- [ ] Read `GEMINI.md` (Aperture-aware IDE law).
- [ ] Check `docs/antigravity-guide.md` for historical context.
- [ ] Run `bash verify_phase6.sh` to confirm environment integrity.

## 9. Known Issues & Workarounds
- **Windows CRLF**: Always use `sed` or `git config --global core.autocrlf input` on Windows hosts.
- **PowerShell Escaping**: Prefer writing bash scripts to `.sh` files rather than complex `bash -c` strings.

## 10. Success Metrics
- **Files Created**: 51
- **Deployment Time**: ~25 minutes
- **Pass Rate**: 100% verification
- **Saturation Management**: 38% compaction enforced successfully.

## Appendix A: Command Reference
- `bash verify_phase6.sh`: Full integrity audit.
- `bash .claude/hooks/pre-compact.sh`: Compaction command generator.

## Appendix B: Prompt Chain Reference
The deployment was driven by a 6-phase prompt chain using XML task blocks, available in the conversation logs.
