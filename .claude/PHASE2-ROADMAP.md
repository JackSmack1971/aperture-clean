# Phase 2: ADS Automation & Intelligent Ledger Curation

**Goal:** Automate rule quality enforcement and enhance failure pattern learning through persistent ledger analysis.

---

## Objectives

### 1. ADS CI/CD Integration
**Current State:** `ads-lint.sh` exists but requires manual invocation.  
**Target State:** Automated ADS scoring on every commit via pre-commit hooks or CI pipeline.

**Implementation Tasks:**
- [ ] Create `.git/hooks/pre-commit` script that runs `ads-lint.sh` on modified `.claude/rules/*.md` files
- [ ] Add CI workflow (GitHub Actions / GitLab CI) that fails builds if any rule scores <7.0
- [ ] Generate ADS trend reports (score history over time) and commit to `/metrics/ads-history.json`
- [ ] Add ADS badge to README.md showing current mean score

**Success Criteria:**
- Developers cannot commit rule files with scores <7.0 without explicit override
- ADS score trends visible in repository metrics

---

### 2. Pareto Ledger Curation
**Current State:** `FAILURE_LEDGER.md` accumulates entries but lacks automatic pruning/prioritization.  
**Target State:** Intelligent curation that surfaces high-impact failure patterns for systemic fixes.

**Implementation Tasks:**
- [ ] Enhance `pre-compact.sh` to calculate "Pareto Rank" (frequency × severity)
- [ ] Add weekly cron job (or PostSession hook) that:
  - Aggregates ledger entries by pattern similarity (fuzzy matching)
  - Ranks patterns by recurrence count (80/20 rule: top 20% of patterns cause 80% of failures)
  - Archives low-frequency entries to `FAILURE_LEDGER.archive.md`
  - Generates `SYSTEMIC_FAILURES.md` with top 10 patterns and suggested fixes
- [ ] Integrate ledger analysis into monthly "Framework Health" reports

**Success Criteria:**
- Ledger size stabilizes at <100 entries (automatic archival)
- Systemic failures document guides proactive rule refinement

---

### 3. Native Hook Discovery & Documentation
**Current State:** PreToolUse hooks confirmed unsupported; unclear what other lifecycle events exist.  
**Target State:** Complete mapping of supported Claude Code hooks with examples.

**Implementation Tasks:**
- [ ] Audit official Claude Code documentation for all lifecycle hook types
- [ ] Test each hook type (SessionStart, SessionEnd, PostToolUse, etc.) with minimal scripts
- [ ] Document supported hooks in `CLAUDE.md` with usage examples
- [ ] Evaluate if PostToolUse can enable "real-time ADS scoring" (flag low-quality rule modifications immediately)

**Success Criteria:**
- Complete hook reference table in CLAUDE.md
- At least 2 additional hooks operationalized beyond pre-compact

---

### 4. Runtime Validation Checklist
**Blockers from Phase 1:** Two integration tests require live Claude Code session validation.

**Manual Test Checklist:**
- [ ] **Permission Enforcement:** Attempt to `Read .env` → Verify native engine blocks with settings.json message
- [ ] **Permission Enforcement:** Attempt to `Bash sudo ls` → Verify native engine blocks
- [ ] **Path-Scoped Injection:** Navigate to `/api` directory → Verify `api.md` rules appear in context without manual read
- [ ] **Failure Ledger:** Trigger 3 different error types → Verify all appear in ledger with correct schema
- [ ] **State Freeze Protocol:** Execute Hard Reset per STATE-FREEZE.md → Verify HANDOVER.md preserves state

**Completion Criteria:**
- All 5 manual tests pass in production environment
- Results documented in Phase 2 completion report

---

## Dependencies & Risks

### External Dependencies
- Claude Code runtime version (hook support may vary)
- Git hooks compatibility with developer workflows
- CI/CD pipeline access (GitHub Actions / GitLab)

### Risk Mitigation
- **Hook incompatibility:** Fallback to prompt-based enforcement if native hooks unavailable
- **CI overhead:** Use incremental ADS linting (only modified files) to minimize build time
- **Ledger bloat:** Implement hard 100KB size limit with automatic archival rotation

---

## Success Metrics

| Metric | Target | Measurement |
|---|---|---|
| Mean ADS Score | ≥ 8.5 | Automated via CI |
| Ledger Size | <100 entries | Weekly automated check |
| Systemic Failure Resolution Rate | 80% within 30 days | Monthly report |
| Hook Operationalization | ≥ 3 hooks active | Configuration audit |
| Runtime Test Pass Rate | 100% (5/5) | Manual validation |

---

**Estimated Timeline:** 2-3 weeks  
**Approval Gate:** Phase 2 Completion Report with runtime validation evidence
