## 🎯 APERTURE Phase 2: Skills Architecture

### Overview
Implements 18 skill files (13 domain + 5 operational) for path-scoped context injection. Skills provide zero-cost rules that activate only when manually invoked.

### Type of Change
- [x] New feature (non-breaking)
- [ ] Breaking change
- [ ] Bug fix
- [x] Documentation

### Skills Inventory

#### Domain Skills (13)
Path-scoped rules for specific technical domains:

| Skill | Invoke When | Key Constraints |
|-------|-------------|-----------------|
| `api-rules` | Editing `/api/**`, routes, middleware | JWT auth, rate limiting, contract-first |
| `db-rules` | Editing `/db/**`, schemas, queries | Parameterized queries, 3-phase migrations |
| `security-rules` | SAST fixes, `/security/**`, crypto | CVE SLOs (24h critical), no custom crypto |
| `ci-rules` | Editing `/.github/**`, pipelines | Zero test skips, 2 approvals for main |
| `config-rules` | Editing `*.yaml`, `*.toml`, configs | Env vars not literals, quote special chars |
| `dependencies-rules` | Editing `package.json`, lockfiles | Never commit without lockfile update |
| `docs-rules` | Editing `/docs/**`, `*.md`, ADRs | Breaking changes require docs in same PR |
| `frontend-rules` | Editing `/frontend/**`, components | PascalCase components, single responsibility |
| `infra-rules` | Editing `/infra/**`, IaC files | Terraform state locking, immutable infra |
| `logging-rules` | Adding log statements | Structured JSON, PII redaction, correlation IDs |
| `migrations-rules` | Editing `/migrations/**` | Rollback-safe, idempotent, test on copy |
| `monitoring-rules` | Editing dashboards, alerts | SLO-driven alerts, max 5 alerts per service |
| `testing-rules` | Editing `*.test.*`, `/tests/**` | 70% coverage, no test skips in CI |

#### Operational Skills (5)
Workflow templates for session management:

| Skill | Purpose | Output |
|-------|---------|--------|
| `pre-compact` | Extract state before `/compact` | Generates `/compact preserve:` command |
| `state-freeze` | Emergency handover (>80% saturation) | HANDOVER.md template |
| `mvcs-debugging` | Bug investigation context | 300-600 token debug template |
| `mvcs-synthesis` | New feature context | 500-800 token feature template |
| `mvcs-refactor` | Coupled module changes | 600-1000 token refactor template |

### CLI Adaptation

**Critical Difference from VSCode Extension**:
- Claude Code CLI does **NOT** auto-inject rules on path entry
- Skills must be **manually invoked** before entering domain work
- Example: Before editing API code → run `/api-rules` skill

**Invocation Pattern**:
```
User: "I need to modify the authentication middleware."

Agent Workflow:
1. Invoke: /api-rules
2. Load: .claude/skills/api-rules/SKILL.md
3. Apply: Loaded constraints to task
4. Execute: With domain context active
```

### Token Economics

**Zero-Cost Until Invoked**:
- Skills cost 0 tokens until manually loaded
- Average skill size: ~200 tokens (Quick Reference only)
- Full rules files: 500-1500 tokens (read on-demand)
- 18 skills × 200 tokens = 3,600 tokens **potential**, not **committed**

**Activation Strategy**:
- Load only skills relevant to current task
- Unload via `/compact` when switching domains
- Never load all 18 simultaneously

### Verification

**Pre-merge Checklist**:
- [ ] All 18 SKILL.md files present
- [ ] Each skill has "Invoke when" trigger description
- [ ] Each skill has Quick Reference section
- [ ] Each skill links to full rules file path
- [ ] Operational skills contain template structures

**Test Commands**:
```bash
# Count skills
find .claude/skills -name 'SKILL.md' | wc -l  # Should output: 18

# Verify structure
for skill in .claude/skills/*/SKILL.md; do
  grep -q "Invoke when" "$skill" && echo "✅ $(dirname $skill)" || echo "❌ $(dirname $skill)"
done

# Check file sizes (should be compact)
find .claude/skills -name 'SKILL.md' -exec wc -l {} + | sort -n
```

### Dependencies
- **Requires**: Phase 1 (directory scaffold in `.claude/skills/`)
- **Blocks**: Phase 3 (hooks reference skills)

### Usage Example

**Scenario**: Modifying database schema

```bash
# 1. Invoke skill before work
/db-rules

# 2. Agent loads context
# [Reads .claude/skills/db-rules/SKILL.md]

# 3. Agent applies constraints
# - Never drop columns without 3-phase migration
# - All tables require created_at, updated_at
# - Foreign key constraints required

# 4. Execute task with domain knowledge active
```

### References
- Source: `APERTURE_MASTER_IMPLEMENTATION_PROMPT.md` Phase 2
- Framework: `PATH-SCOPED_CONTEXT.md` (Isolate principle)
- Templates: MVCS patterns from `IMPLEMENTATION_ROADMAP.md`

---
**Estimated Review Time**: 15 minutes  
**Lines Changed**: +~2,000 (all additions, 18 files)  
**Risk Level**: Low (documentation only, zero runtime impact)
