# COMPACTION.md — Pre-Compaction Decision Tree
# Thresholds below are unvalidated heuristics (RT-2). Staging order: RT-5.
# Source: docs/research/LLM_Agent_Context_Management.md (results from other harnesses)
compaction_protocol:
  staging_order:
    1_rule_based_elision:      # deterministic; runs BEFORE any LLM summary
      drop: [bulk tool output already acted on, duplicate reads, passing-test logs]
      keep: [exact error lines, failing assertions, file:line pointers, active diffs]
    2_llm_summary: "/compact preserve: [decisions, blockers, modified files]"
  RESTRICTED: token_level_pruning_of_code_or_config   # breaks syntax and exact identifiers
  REQUIRED: compressed_evidence_preserves_next_action # same next step as the raw observation
  trigger_check:
    IF saturation < 0.38:
      action: CONTINUE
    IF saturation >= 0.38 AND saturation < 0.432:
      action: EXECUTE_COMPACT
      steps:
        - run: .claude/hooks/pre-compact.sh
        - copy_output: "/compact preserve: [paste generated list]"
        - verify: context_pct < 0.20 post-compact
    IF saturation >= 0.432 AND saturation < 0.80:
      action: CRITICAL_COMPACT
      steps:
        - HARD STOP — reasoning cliff entered
        - run: .claude/hooks/pre-compact.sh
        - execute: "/compact preserve: [all active files + decisions]"
        - IF compact_result > 0.50: escalate_to_state_freeze
    IF saturation >= 0.80:
      action: STATE_FREEZE
      steps:
        - write: HANDOVER.md (150-token schema only)
        - execute: /clear
        - resume: "Read HANDOVER.md. Task: {next_step}."

  post_compact_validation:
    assert: context_pct < 0.20
    assert: preserved_items_accessible == true
    assert: no_critical_decisions_lost == true
