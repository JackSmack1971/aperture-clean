# Security Rules — Path-Scoped Context
<!-- APERTURE-CLEAN v1.0 | Injected when agent reads /security/** or auth/crypto files -->
<!-- Static content only. Cache-compatible. Target: ≤55 lines. -->

<!-- ═══ HARD STOPS — READ FIRST ═══════════════════════════════ -->
RESTRICTED: env_file_read | assert NOT read_path MATCHES [".env*", "secrets/**", "credentials/**"]
RESTRICTED: credential_output | assert NOT output_contains_credential
  validation_key: placeholder_only | expected_format: "{{SECRET_NAME}}"
RESTRICTED: secret_commit | assert NOT git_stage_contains_credential
  required: pre_commit_hook_active == true
<!-- ══════════════════════════════════════════════════════════ -->

## SAST & Vulnerability Scanning
- Pointer: `docs/security-policy.md` — threat model, approved scanning tools, escalation path
- Pointer: `security/findings/README.md` — active CVE tracking register
- [ ] TODO: Define SAST tool (Semgrep / CodeQL / Snyk Code / Checkmarx / Bandit)
- [ ] TODO: Define DAST tool for integration environment (OWASP ZAP / Burp Suite)
- [ ] TODO: Define scan trigger: every PR + nightly full scan on main
- [ ] TODO: SARIF output path: `security-scan-results/` — in `.claudeignore`, REQUIRED: jq filtering

## Severity Response Protocol
- [ ] TODO: CRITICAL → block merge immediately; page security lead; remediate before any deployment
- [ ] TODO: HIGH     → block merge; tracked in `security/findings/`; SLO: ≤7 days
- [ ] TODO: MEDIUM   → non-blocking; tracked; SLO: ≤30 days
- [ ] TODO: LOW      → tracked in backlog; reviewed quarterly
- [ ] TODO: Define CVSS score thresholds mapping to above severity labels

## Cryptography Standards
- [ ] TODO: Define approved hash algorithms: SHA-256 minimum; REQUIRED: assert NOT [MD5, SHA-1]
- [ ] TODO: Define approved encryption: AES-256-GCM; REQUIRED: assert NOT [DES, 3DES, RC4]
- [ ] TODO: Define key length minimums: RSA ≥ 2048-bit; EC ≥ P-256
- [ ] TODO: Enforce: no custom crypto implementations — use audited libraries only
- [ ] TODO: Define approved TLS minimum: TLS 1.2; REQUIRED: assert NOT [TLS 1.0, 1.1]

## Input Validation Invariants
- [ ] TODO: All external inputs validated at system boundary — never trust downstream
- [ ] TODO: Define sanitization library per language/framework
- [ ] TODO: Enforce: parameterized queries only — no string interpolation into SQL/NoSQL
- [ ] TODO: Enforce: file upload validation — type, size, content scanning before storage

## Secrets Policy
- [ ] TODO: Confirm secret scanning enabled on repo (GitHub secret scanning / GitLeaks)

## Context Engineering Notes
- Do NOT read raw SARIF files — dense XML/JSON; run `jq` query for HIGH+CRITICAL only
- Do NOT read full CVE register — query specific CVE ID only
- Scan result analysis → subagent filters findings; returns HIGH/CRITICAL list only
- If agent encounters a live credential in ANY file: **STOP. Do not read further. Alert user.**
- Crypto implementation reads → fetch targeted function node only, never full library wrapper

## Populated By
- Security lead / AppSec engineer on project onboarding
- Last reviewed: [ TODO: date ]
