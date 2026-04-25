## 📋 APERTURE Phase 4: State Management Templates

### Overview
Implements 8 standardized templates for session continuity, failure tracking, and agent delegation. Templates are empty structures to be populated at usage time.

### Type of Change
- [x] New feature (non-breaking)
- [ ] Breaking change
- [ ] Bug fix
- [x] Documentation

### Template Inventory

#### Core Templates (Specified)

**1. HANDOVER.md** — Session State Snapshot
**Purpose**: Machine-readable state for `/clear` transitions (>80% saturation emergency)

**Structure**:
```markdown
# HANDOVER — Session State Snapshot
**Generated:** [timestamp]
**Context Saturation:** [%]

## Modified Files
- [file paths with change type]

## Open Tasks
- [current work in progress]

## Next Step
[single, clear action for resuming agent]

## Blockers
[impediments or questions]

## Machine State (JSON)
{
  "modified_files": [],
  "next_step": "",
  "context_snapshot": ""
}
```

**Usage**: Copy to root when context >80%, populate with current state, execute `/clear`, resume with "Read HANDOVER.md and continue"

---

**2. FAILURE_LEDGER.md** — Pareto-Curated Failure Record
**Purpose**: Document failed approaches to prevent repetition

**Entry Format**:
```markdown
### [YYYY-MM-DD] [Brief Description]
**Approach:** [what was tried]
**Failure Mode:** [why it failed]
**Root Cause:** [underlying issue]
**Status:** [FAILED / ABANDONED / RESOLVED]
```

**Usage**: Before implementing solutions, agent reads ledger to check if approach already failed. Add entry immediately after confirmed failure.

---

**3. SUBAGENT.md** — Delegation Contract
**Purpose**: Define subagent scope, tools, and return format

**Structure**:
```markdown
# SUBAGENT DELEGATION CONTRACT

## Scope
[single, focused objective]

## Authorized Tools
[explicit tool whitelist — least privilege]

## Return Contract
- Format: [JSON/Markdown/Summary]
- Token Limit: ≤500 tokens
- Required Fields: [specify]

## Constraints
- [boundaries and prohibited actions]
```

**Usage**: Before spawning subagent with `/agents`, copy template, fill contract, attach to delegation command.

---

**4. COMPACTION.md** — Pre-Compact Checklist
**Purpose**: Deterministic workflow for context compaction

**Checklist**:
```markdown
# PRE-COMPACT CHECKLIST

## Step 1: Extract State
- [ ] Run `.claude/hooks/pre-compact.sh`
- [ ] Review preservation items

## Step 2: Execute Compaction
- [ ] Paste generated `/compact preserve:` command
- [ ] Verify context reduction

## Step 3: Post-Compact Validation
- [ ] Check /tokens (should be <20%)
- [ ] Verify preserved items still accessible
```

**Usage**: Reference when context reaches 38% saturation. Follow checklist to avoid lossy compaction.

---

#### Additional Templates (4 extras)

1. **MVCS-DEBUGGING.md**: Context template for bug investigation (300-600 tokens).
2. **MVCS-REFACTOR.md**: Context template for major refactoring (600-1000 tokens).
3. **MVCS-SYNTHESIS.md**: Context template for new feature development (500-800 tokens).
4. **STATE-FREEZE.md**: Emergency handover protocol for >80% saturation.

---

### Token Economics

**Template Cost**: 0 tokens until copied and populated
**HANDOVER.md**: ~200-400 tokens when filled (saves 160K+ tokens by enabling /clear)
**FAILURE_LEDGER.md**: ~50-150 tokens per entry (saves hours of re-attempting failed approaches)
**SUBAGENT.md**: ~100-200 tokens per delegation (enforces ≤500 token return contract)

**Workflow Efficiency**:
- Templates provide deterministic structure
- Reduces cognitive load (no "how should I format this?" decisions)
- Machine-readable JSON blocks enable automation

### Verification

**Pre-merge Checklist**:
- [ ] All 8 templates present in `.claude/templates/`
- [ ] HANDOVER.md contains JSON block
- [ ] FAILURE_LEDGER.md has example entry format
- [ ] SUBAGENT.md has return contract section
- [ ] COMPACTION.md has 3-step checklist
- [ ] Additional 4 templates documented in PR description

**Test Commands**:
```bash
# Count templates
ls -1 .claude/templates/*.md | wc -l  # Should output: 8

# Verify HANDOVER.md structure
grep -q "Machine State (JSON)" .claude/templates/HANDOVER.md && echo "✅ JSON block present"

# Verify FAILURE_LEDGER.md format
grep -q "Approach:" .claude/templates/FAILURE_LEDGER.md && echo "✅ Entry format present"

# List all templates
ls -1 .claude/templates/
```

### Dependencies
- **Requires**: Phase 1 (.claude/templates/ directory), Phase 3 (pre-compact.sh referenced in COMPACTION.md)
- **Blocks**: None (Phase 5 can proceed independently)

### Usage Examples

#### Example 1: Emergency Context Reset (>80%)
```bash
# Context saturated to 85% — quality degrading
cp .claude/templates/HANDOVER.md ./HANDOVER.md

# Fill with current state
# Modified files: [list]
# Next step: [specific action]
# Machine state JSON: [parse from current context]

# Execute reset
/clear

# Resume in new session
# "Read HANDOVER.md and continue implementing [task]"
```

#### Example 2: Subagent Delegation
```bash
# Need to analyze 50 test files (would bloat context)
cp .claude/templates/SUBAGENT.md ./analyze_tests_subagent.md

# Fill contract:
# Scope: Analyze all test files in /tests/ for coverage gaps
# Tools: Read, Grep, LS
# Return: JSON summary ≤500 tokens with {total_tests, uncovered_functions[]}

# Delegate
/agents create --contract analyze_tests_subagent.md
```

### References
- Source: `APERTURE_MASTER_IMPLEMENTATION_PROMPT.md` Phase 4
- Framework: Five Laws (Law III: Filesystem = truth)
- Protocol: State Freeze workflow (>80% emergency)

---
**Estimated Review Time**: 10 minutes  
**Lines Changed**: +~600 (8 template files)  
**Risk Level**: Low (documentation templates, no runtime code)
