# Phase 2 Onboarding Brief: ADS Automation & Ledger Curation

**Prerequisites:** Phase 1 runtime validation complete (5/5 tests passing)  
**Timeline Estimate:** 2-3 weeks  
**Complexity:** Medium (scripting + CI integration, no core architecture changes)

---

## What You're Inheriting

Phase 1 delivered:
- ✅ Functional `ads-lint.sh` CLI tool (JSON output, batch mode)
- ✅ Functional `pre-compact.sh` hook (extracts failures to ledger)
- ✅ Native permissions enforcement (5 rules in `settings.json`)
- ✅ Hybrid security model (hard + soft constraints documented)

**Your job:** Automate quality enforcement and ledger intelligence.

---

## Phase 2 Objectives (From PHASE2-ROADMAP.md)

### 1. ADS CI/CD Integration
**Goal:** Prevent low-quality rules from being committed.

**Starting Point:**
- Existing tool: `scripts/ads-lint.sh` (fully functional)
- Output format: JSON array with `file`, `score`, `rating`, `recommendations`

**Implementation Hints:**
```bash
# Pre-commit hook pseudocode
modified_rules=$(git diff --cached --name-only | grep '.claude/rules/.*\.md')
for rule in $modified_rules; do
  score=$(bash scripts/ads-lint.sh "$rule" | jq '.score')
  if (( $(echo "$score < 7.0" | bc -l) )); then
    echo "BLOCKED: $rule scored $score (minimum 7.0)"
    exit 1
  fi
done
```

### 2. Pareto Ledger Curation
**Goal:** Surface high-impact systemic failures for proactive fixes.

**Starting Point:**
- Existing ledger schema in `FAILURE_LEDGER.md`
- Current deduplication logic (checks Type + Pattern + Context)

**Implementation Hints:**
```bash
# Pareto ranking formula
pareto_score = recurrence_count × severity_weight
# Where severity_weight: CRITICAL=5, MAJOR=3, MINOR=1
```

### 3. Native Hook Discovery
**Goal:** Map all supported Claude Code lifecycle hooks.

**Starting Point:**
- Confirmed working: `pre_compact`
- Confirmed non-functional: `pre_tool_use` (PoC Task 3 validation)

**Implementation Hints:**
- Create minimal test scripts for each hook type
- Register in `settings.json` one at a time
- Document negative results in `DEPRECATED.md`

### 4. Runtime Validation Completion
**Goal:** 100% pass rate on Phase 1 integration tests.

**Starting Point:**
- Checklist has 5 tests in `.claude/RUNTIME-VALIDATION-CHECKLIST.md`

---

## Success Criteria
- ✅ Developers cannot commit rule files scoring <7.0 without override
- ✅ Ledger auto-curates weekly (size stable at <100 entries)
- ✅ At least 3 lifecycle hooks documented and operational
- ✅ Runtime validation shows 100% (5/5) pass rate

---

## Dependencies & Access Required
- **Repository Access:** Write access to `.git/hooks/` and CI pipeline config.
- **External Tools:** `jq` (JSON parsing), `bc` (arithmetic), `Cron` (curation).
- **Risk Mitigation:** All automation must be non-blocking.

---

## File Locations Reference
| Component | Path | Purpose |
|---|---|---|
| ADS Tool | `scripts/ads-lint.sh` | CLI for rule quality scoring |
| Pre-Compact Hook | `.claude/hooks/pre-compact.sh` | Failure extraction before compaction |
| Ledger Storage | `FAILURE_LEDGER.md` | Persistent failure log |
| Phase 2 Roadmap | `.claude/PHASE2-ROADMAP.md` | Detailed implementation plan |
| Runtime Checklist | `.claude/RUNTIME-VALIDATION-CHECKLIST.md` | Manual test protocol |

---

## Quick Start
1. **Read Phase 1 Walkthrough:** Understand what changed and why.
2. **Verify Prerequisites:** Run runtime validation checklist.
3. **Start with Objective 1:** ADS CI/CD (lowest risk, highest immediate value).

**Contact & Escalation:** Architecture Questions (Reference `.claude/PHASE1-WALKTHROUGH.md`).
