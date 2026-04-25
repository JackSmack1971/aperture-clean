# Runtime Validation Checklist — Phase 1 Integration

**Purpose:** Validate native feature integrations that cannot be tested outside live Claude Code sessions.

**Status:** ⏸️ PENDING (Execute during first post-merge session)

---

## Test 1: Permission Enforcement (Credential Files)

**Objective:** Verify that `settings.json` permissions block access to sensitive files.

**Steps:**
1. Attempt to execute: `Read .env`  
2. Observe agent response

**Expected Behavior:**
- ❌ Tool execution blocked by native engine  
- 📋 Error message displayed: "Security policy: Credential files are immutable (CLAUDE.md Security Invariants)"  
- ✅ No file content appears in context

**Actual Result:** [ PASS / FAIL / N/A ]  
**Evidence:** [ Screenshot / Transcript excerpt ]

---

## Test 2: Permission Enforcement (Destructive Commands)

**Objective:** Verify Bash command blocking for `sudo` and `rm -rf /`.

**Steps:**
1. Attempt to execute: `Bash sudo ls /root`  
2. Attempt to execute: `Bash rm -rf /tmp/test`

**Expected Behavior:**
- ❌ Both commands blocked by native engine  
- 📋 Error message: "Security policy: Destructive system commands blocked"  
- ✅ No command execution occurs

**Actual Result:** [ PASS / FAIL / N/A ]  
**Evidence:** [ Transcript excerpt ]

---

## Test 3: Path-Scoped Rule Injection

**Objective:** Verify that rules from `.claude/rules/*.md` automatically inject when relevant files are accessed.

**Steps:**
1. Navigate to a directory with scoped rules (e.g., `/api`)  
2. Execute: `Read api/routes.ts`  
3. Check agent context for presence of `api.md` rules

**Expected Behavior:**
- ✅ Agent references constraints from `api.md` without manual Read command  
- 📋 Context window includes relevant rule sections (verify via `/context` command)

**Actual Result:** [ PASS / FAIL / N/A ]  
**Evidence:** [ Context window screenshot or /context output ]

---

## Test 4: Failure Ledger Auto-Population

**Objective:** Verify that `pre-compact.sh` extracts failures during auto-compaction.

**Steps:**
1. Trigger 3 tool errors: Read non-existent file, invalid Bash command, permission denial  
2. Manually trigger compaction (if auto-compact threshold not reached): `[ Execute compact command ]`  
3. Check `FAILURE_LEDGER.md` for new entries

**Expected Behavior:**
- ✅ Three new ledger entries appear with correct schema (Timestamp, Type, Pattern, Context, Severity)  
- ✅ Deduplication works (running same error twice only increments Recurrence counter)

**Actual Result:** [ PASS / FAIL / N/A ]  
**Evidence:** [ FAILURE_LEDGER.md diff ]

---

## Test 5: State Freeze Protocol

**Objective:** Verify that Hard Reset procedure preserves session state via HANDOVER.md.

**Steps:**
1. Execute 10-15 turns of complex reasoning task  
2. Follow STATE-FREEZE.md procedure:
   - Step 1: Extract state to HANDOVER.md  
   - Step 2: Verify extraction quality  
   - Step 3: Execute `/clear` (context wipe)  
   - Step 4: Restore from HANDOVER.md  
3. Verify agent can resume task using only HANDOVER.md content

**Expected Behavior:**
- ✅ HANDOVER.md contains sufficient state (goals, constraints, progress, blockers)  
- ✅ Post-restore agent demonstrates continuity (no repeated questions, maintains context)

**Actual Result:** [ PASS / FAIL / N/A ]  
**Evidence:** [ HANDOVER.md sample + post-restore transcript ]

---

## Completion Criteria

- [ ] All 5 tests executed  
- [ ] At least 4/5 tests pass (80% threshold)  
- [ ] Any failures documented with root cause analysis  
- [ ] Results appended to Phase 2 Completion Report

**Assigned To:** [ Developer / QA ]  
**Target Completion:** [ Within 7 days of merge ]
