# Skill: Validate Subagent Return
<!-- APERTURE-CLEAN Skill | Payload Enforcement -->

Ensures that subagent return contracts are strictly followed to prevent context pollution in the orchestrator session.

## Operational Workflow

### Step 1: Payload Inspection
- Capture the subagent return payload.
- Measure the character count of the payload.

### Step 2: Token Estimation (Heuristic)
- Apply the heuristic: **1 token ≈ 4 characters**.
- Example: A 2000-character payload is estimated at 500 tokens.

### Step 3: Contract Validation
- Compare the estimate against the limit defined in the `SUBAGENT.md` contract (default: **500 tokens**).
- **Hard Stop**: If the payload exceeds the limit, block the ingestion and throw an error.

## Error Handling
- Return the error: `BLOCK: Subagent payload exceeds 500-token limit (Estimated: {N} tokens). Please compress and re-return.`
- Prohibit raw file content returns unless explicitly authorized in the contract.
