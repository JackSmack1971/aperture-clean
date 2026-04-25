# Infra Rules — Path-Scoped Context
<!-- APERTURE-CLEAN v1.0 | Injected ONLY when agent reads/edits /infra/** -->
<!-- Static content only. Cache-compatible. Target: ≤55 lines. -->

<!-- ═══ HARD STOPS — READ FIRST ═══════════════════════════════ -->
RESTRICTED: iac_secret | assert NOT git_stage_contains(raw_credential)
  REQUIRED: secret_manager_reference | expected: AWS/GCP/Vault/Doppler
RESTRICTED: state_file_read | assert NOT read_path MATCHES ["*.tfstate", "*.tfplan"]
  REQUIRED: bash_query_only | example: "terraform show -json"
<!-- ══════════════════════════════════════════════════════════ -->

## IaC Standards
- Pointer: `infra/docs/architecture-diagram.md` — canonical topology
- Pointer: `infra/docs/module-registry.md` — approved IaC modules and versions
- [ ] TODO: Define IaC tool (Terraform / Pulumi / AWS CDK / Crossplane)
- [ ] TODO: Define state backend and locking strategy
- [ ] TODO: Define module versioning pin policy

## Secrets Management
- [ ] TODO: Define secrets manager (AWS Secrets Manager / Vault / GCP Secret Manager / Doppler)
- [ ] TODO: Define secret rotation policy and TTL per secret class
- [ ] TODO: Define injection mechanism: env injection / sidecar / init container

## Environment Topology
- [ ] TODO: Define environment names and promotion path: `dev → staging → prod`
- [ ] TODO: Define environment parity requirements
- [ ] TODO: Define blast radius isolation: separate accounts/projects per environment?

## Change Management
- [ ] TODO: Define plan/apply gate: all plan output reviewed before apply
- [ ] TODO: Define drift detection schedule and alerting target
- [ ] TODO: Enforce: destructive resource changes require explicit override

## Context Engineering Notes
- Do NOT read full Terraform state files — use `terraform show -json` targeted output
- Do NOT load entire module registry — query specific module by name only
- Infra reads are HIGH token risk → delegate to subagent; return resource diff summary only
- If agent encounters a live credential: STOP, do not read further, alert user immediately

## Populated By
- Platform / DevOps lead on project onboarding
- Last reviewed: [ TODO: date ]
