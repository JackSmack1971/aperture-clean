# Path A Implementation Validation: Manual Governance Stress-Test

This document validates the enforceability and discoverability of the manual Aperture-Clean protocols in the absence of lifecycle hook automation.

## Validation 1: Rule-Loading Discoverability
**Challenge:** Can the agent unambiguously identify which of the 13 rule files to read based on the user's request?

| User Request | Target Files | Required Rule(s) | Trigger Pattern |
|:---|:---|:---|:---|
| "Add auth middleware to Express routes" | `/api/routes/auth.ts` | `api.md` | Path: `/api/**` |
| "Create migration for users table" | `/db/migrations/003.sql` | `db.md` + `migrations.md` | Path: `/db/migrations/**` |
| "Fix failing test for checkout" | `/tests/checkout.spec.ts` | `testing.md` | Ext: `*.spec.ts` |
| "Update GitHub Actions workflow" | `/.github/workflows/main.yml`| `ci.md` | Path: `/.github/**` |
| "Add Redis cache layer" | `/infra/redis.ts`, `package.json` | `infra.md` + `dependencies.md`| Multi-file (Path + Lockfile) |
| "Implement PII scrubbing for logs" | `/logging/scrubbers.ts` | `logging.md` | Path: `/logging/**` |
| "Define SLOs for latency" | `/monitoring/alerts.yaml` | `monitoring.md` | Path: `/monitoring/**` |
| "Audit codebase for CVEs" | `package.json`, `npm audit` | `security.md` + `dependencies.md`| Multi-domain (Security + Deps) |
| "Refactor frontend component" | `/frontend/components/App.tsx`| `frontend.md` | Path: `/frontend/**` |
| "Fix typo in README.md" | `README.md` | *None* | Root markdown file |

**Finding:** 9/10 requests map unambiguously. Multi-domain operations require explicit "Read both X and Y" instructions in `CLAUDE.md`.

---

## Validation 2: Failure Logging Friction Test
**Challenge:** Is manual logging to `FAILURE_LEDGER.md` too high-friction for consistent compliance?

| Scenario | Agent's Workflow | Overhead | Tool Ops | Likelihood of Forgetting |
|:---|:---|:---|:---|:---|
| **1. Permission Denied** | Recognizes "deny" rule -> Appends to Ledger | ~20s | 1 (Write) | Low (Impactful event) |
| **2. Bash Failure** | Recognizes lint error -> Check Ledger -> Append | ~45s | 2 (Read+Write)| Medium (Frequent/Annoying) |
| **3. Constraint Violation**| Blocked from reading .lock -> Append | ~20s | 1 (Write) | Medium (Passive failure) |
| **4. Tool Error** | Edit fails due to syntax -> Append | ~30s | 1 (Write) | Medium (Frustration-driven) |
| **5. User Correction** | User says "No, don't use X" -> Append | ~60s | 2 (Read+Write)| High (Implicit failure) |

**Finding:** Average overhead is ~35s and 1.4 ops per failure. **Verdict: Acceptable**, provided failure events are treated as "Stop and Record" checkpoints.

---

## Validation 3: Context Management Enforcement
**Challenge:** Can the agent self-monitor context saturation without `/tokens` or automated counters?

### Failure Modes & Enforcement
1. **Forget to Count**: Agent loses track after 30 ops.
   - **Enforcement**: Include "Current Op Count" in all Write tool descriptions (e.g., `[Op 51/80] Updating auth middleware`).
2. **Threshold Blindness**: Agent hits 50 ops but continues.
   - **Enforcement**: Mandatory "Context Checkpoint" entry in the response body every 10 ops.
3. **Premature Handover**: Agent triggers at 60 ops due to estimation error.
   - **Enforcement**: Use `ls -R` size or file count as a proxy for "mental weight" in `CLAUDE.md`.

**Attention Overhead:** Agent must think about context ~15% of the time.

---

## Validation 4: CLAUDE.md Structural Audit
**Challenge:** Will the agent reliably follow a 100-line document containing 4+ protocols?

### Section Analysis
- **Core Constraints (1-15)**: High consistency. Negative rules (NEVER) are highly effective.
- **Rule Mapping (16-45)**: Medium consistency. Table format is easy to scan.
- **Context Management (46-60)**: **HIGH RISK**. Likely to be forgotten during "flow" state.
- **Failure Logging (61-75)**: **HIGH RISK**. Likely to be skipped when a task is urgent.
- **Templates (76-100)**: High consistency (accessed on-demand).

### Redundancy & Effectiveness Plan
1. **QUICK-REF.md**: Create a <20 line "Active Session" reference for frequent consultation.
2. **Template Integration**: Embed threshold and logging reminders directly into `HANDOVER.md` and `SUBAGENT.md`.
3. **Deny-Rule Reminders**: Add a brief comment to each `permissions` entry in `settings.json` pointing to `FAILURE_LEDGER.md`.

**Effective Attention Budget:** ~75 lines. Anything beyond this should be moved to specialized documentation or templates.

---

## Final Recommendation: Path A Adjusted

**Status: READY FOR IMPLEMENTATION**

**Adjustments for T3a:**
1. **Implement `QUICK-REF.md`** as a permanent, high-visibility reference.
2. **Inject Thresholds** into the subagent briefing template (`SUBAGENT.md`).
3. **Explicitly include Multi-Domain instructions** (e.g., "If file touches DB and API, Read both rules") in the `CLAUDE.md` header.
