## 🏗️ APERTURE Phase 1: Core Infrastructure

### Overview
Establishes the foundational layer of the APERTURE-CLEAN context engineering framework for Claude Code CLI. This PR implements the Five Laws, WISC protocol, and token discipline infrastructure.

### Type of Change
- [x] New feature (non-breaking)
- [ ] Breaking change
- [ ] Bug fix
- [x] Documentation

### Changes

#### Root Files
| File | Lines | Purpose |
|------|-------|---------|
| `CLAUDE.md` | 42 | Root law document, cache-optimized static prefix |
| `.claudeignore` | 87 | Token cost exclusions (deps, logs, secrets) |
| `FAILURE_LEDGER.md` | 0 | Placeholder for Pareto-curated failure records |

#### Configuration
- **settings.json**: Model config, permissions (deny/ask patterns), tool whitelist
- **Context thresholds**: 38% (compact), 95% (auto-compact)
- **Permissions**: Denies destructive ops, asks for package installs

#### Directory Scaffold
```
.claude/
├── hooks/          # Session lifecycle triggers
├── snapshots/      # Volatile state (git-ignored)
├── templates/      # State management templates
├── rules/          # Full domain rule files
└── skills/         # Quick-reference skill cards
```

### Framework Principles Codified

**Five Laws**:
1. Context window = finite resource → optimize signal-to-noise
2. Static before dynamic → enable prompt caching
3. Filesystem = truth, memory = volatile → write early, write often
4. Path-scoped activation → load rules on-demand
5. Manual compaction at 38% → never exceed 43.2% collapse cliff

**WISC Protocol**:
- **W**rite: Progress to disk every 3-5 turns
- **I**solate: Heavy reads → subagents (≤500 token returns)
- **S**elect: AST + targeted reads (never full files)
- **C**ompress: `/compact` at 38% saturation

### Token Economics
- **CLAUDE.md**: 42/100 lines (58% buffer for future updates)
- **.claudeignore**: Blocks catastrophic costs (node_modules/, *.lock)
- **Total Phase 1 size**: ~15 KB on disk

### Verification

**Pre-merge Checklist**:
- [ ] CLAUDE.md line count ≤100
- [ ] settings.json validates (`jq . .claude/settings.json`)
- [ ] .gitignore includes APERTURE entries
- [ ] Directory structure complete (5 subdirs)
- [ ] No secrets in committed files

**Test Commands**:
```bash
# Verify line count
wc -l CLAUDE.md  # Should output ≤100

# Validate JSON
jq . .claude/settings.json

# Check directory structure
tree .claude/ -L 1

# Verify .claudeignore patterns
grep -E "(node_modules|\.lock|\.env)" .claudeignore
```

### Dependencies
- **Requires**: Git repository initialization
- **Blocks**: Phase 2 (Skills Architecture) — directory scaffold required

### Deployment Notes
- First-time setup requires reading `CLAUDE.md` session checklist
- `.claude/snapshots/` is git-ignored (volatile state storage)
- `settings.local.json` (if created) overrides team settings (personal config)

### References
- Source: `APERTURE_MASTER_IMPLEMENTATION_PROMPT.md` Phase 1
- Framework: `IMPLEMENTATION_ROADMAP.md`
- Protocol: `PATH-SCOPED_CONTEXT.md` (Five Laws)

---
**Estimated Review Time**: 10 minutes  
**Lines Changed**: +~500 (all additions)  
**Risk Level**: Low (foundational infrastructure, no runtime impact yet)
