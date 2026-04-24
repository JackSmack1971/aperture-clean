# Skill: Context Meter (Token Tracking)
<!-- APERTURE-CLEAN Skill | Manual Telemetry -->

Provides manual context saturation tracking to bridge the lack of automatic token metrics in Claude Code.

## Operational Workflow

### Step 1: Operation Tracking
- Track every major tool call in the session scratchpad or `TodoWrite`.
- **Read Operation**: 1 file read ≈ 1 unit.
- **Delegation Operation**: 1 subagent spawn ≈ 2 units.
- **Edit Operation**: 1 file write ≈ 0.5 units.

### Step 2: Saturation Calculation
- Use units as a proxy for context growth.
- Baseline the session at the start of every `/clear` or fresh load.

### Step 3: Threshold Alerts
- **38.0% (Compaction)**: Trigger a manual alert to run the `pre-compact` skill.
- **43.2% (Reasoning Cliff)**: Trigger a **HARD STOP** for immediate session compaction or reset.

## Alerts
- "⚠️ WARNING: Context saturation approaching 38% (Stability Plateau). Recommend compaction."
- "🚨 DANGER: Context saturation reaching 43.2%. Sigmoid collapse imminent. Execute State Freeze."
