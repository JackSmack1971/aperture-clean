# Skill: Pre-Compact (WISC Compress)
<!-- APERTURE-CLEAN Skill | Manual Hook -->

Use this skill BEFORE executing the `/compact` command to ensure critical architectural decisions and working state are preserved.

## Operational Workflow

### Step 1: Extraction
- Read all open TODO items: `grep -rn "\[ \] TODO"`
- Identify modified files: `git status -s`
- Confirm current working directory: `pwd`

### Step 2: Snapshot Generation
Generate a timestamped snapshot in `.claude/snapshots/pre-compact-{timestamp}.md`.
Include:
- Summary of current task and blockers.
- List of modified files from Step 1.
- Open TODOs extracted.

### Step 3: Compaction Command
Output the explicit copy-paste command for the user:
`/compact preserve: [architectural decisions, active file paths, blockers]`

## Success Criteria
- Snapshot file is persisted to the `snapshots` directory.
- Context is ready for a clean compression.
