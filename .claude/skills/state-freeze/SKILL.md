# State Freeze Skill
<!-- Trigger: Invoke when context is saturated (>80%) or loops detected -->

## Quick Reference
- Emergency Protocol: `.claude/templates/STATE-FREEZE.md`
- Reset sequence: Generate `HANDOVER.md` -> `/clear`

## State Freeze Template
```markdown
# STATE FREEZE: [Session ID]
- **Current Objective**: [Summary]
- **Failed Paths**: [List of 3+ abandoned approaches]
- **Hard Blockers**: [What stopped progress]
- **Extraction Protocol**: Read HANDOVER.md and resume with [Minimal Context]
```
