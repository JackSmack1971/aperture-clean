# Aperture Setup Guide
<!-- APERTURE-CLEAN v3.2.0 | Setup -->

This guide covers the prerequisites, configuration, and verification of your Aperture context engineering environment.

## 1. Prerequisites
Before installing, ensure your environment has the following tools:
- **Git**: For repository tracking and status extraction.
- **Bash 4.0+**: Required for bootstrap and hook scripts.
- **jq**: Optional, but recommended for JSON validation.

## 2. Installation
The framework is deployed via the idempotent bootstrap script. To verify the installation state without making changes, run:
```bash
bash scripts/bootstrap-claude-framework.sh --dry-run
```

## 3. Configuration
Personalize your environment by creating `.claude/settings.local.json`. This file is git-ignored and used for machine-specific overrides.

Example `settings.local.json`:
```json
{
  "model": "claude-opus-4-6",
  "extended_thinking": { "effort": "high" }
}
```

## 4. First Session Checklist
- [ ] Run `/tokens` to establish a context baseline.
- [ ] Review `FAILURE_LEDGER.md` for known pitfalls in this repo.
- [ ] Ensure `.claudeignore` is active (prevents `node_modules` ingestion).
- [ ] Use the WISC protocol: **W**rite, **I**solate, **S**elect, **C**ompress.

## 5. Directory Structure Overview
- `.claude/rules/`: Path-scoped domain governance.
- `.claude/templates/`: Handover, Subagent, and Compaction templates.
- `.claude/hooks/`: Session lifecycle automation.

## 6. Troubleshooting
- **Rules not loading?** Ensure your path matches the trigger in `CLAUDE.md`.
- **Context saturation high?** Execute the Compaction Protocol at 38%.
- **Git errors in pre-compact?** Ensure you are at the repository root.

## Agent-Specific Guides
- **Claude Code CLI**: See [CLAUDE.md](../CLAUDE.md)
- **Google Antigravity IDE**: See [Antigravity Guide](antigravity-guide.md)
