# Infra Rules — Path-Scoped Context
<!-- Injected ONLY when agent reads/edits files under /infra -->
<!-- CRITICAL: Highest security surface. No secret values ever in context. Cache-compatible. -->
<!-- Target: ≤50 lines. Deep detail lives in pointer docs below. -->

## IaC Standards
- Pointer: `infra/docs/architecture-diagram.md` — canonical topology (regions, VPCs, services)
- Pointer: `infra/docs/module-registry.md` — approved Terraform/Pulumi/CDK modules and versions
- [ ] TODO: Define IaC tool (Terraform / Pulumi / AWS CDK / Crossplane)
- [ ] TODO: Define state backend and locking strategy (S3+DynamoDB / Terraform Cloud / GCS)
- [ ] TODO: Define module versioning pin policy — no floating `latest` references in production

## Secrets Management
- **NEVER** hardcode secrets, tokens, or credentials in any IaC file
- **NEVER** read actual secret values into context — use placeholder convention: `{{SECRET_NAME}}`
- [ ] TODO: Define secrets manager (AWS Secrets Manager / Vault / GCP Secret Manager / Doppler)
- [ ] TODO: Define secret rotation policy and TTL per secret class (DB creds / API keys / certs)
- [ ] TODO: Define injection mechanism: env injection at container start / sidecar / init container

## Environment Topology
- [ ] TODO: Define environment names and promotion path: `dev → staging → prod`
- [ ] TODO: Define environment parity requirements (prod-like staging = YES/NO)
- [ ] TODO: Define blast radius isolation: separate AWS accounts / GCP projects per environment?

## Change Management
- [ ] TODO: Define plan/apply gate: all `terraform plan` output reviewed before `apply`
- [ ] TODO: Define drift detection schedule and alerting target
- [ ] TODO: Enforce: destructive resource changes require explicit `lifecycle { prevent_destroy }` override

## Context Engineering Notes
- Do NOT read full Terraform state files — token cost is catastrophic; use `terraform show -json` targeted output
- Do NOT load entire module registry — query specific module by name only
- Infra reads are HIGH token risk → always delegate to subagent; return resource diff summary only
- If agent encounters a live credential in any file: STOP, do not read further, alert user immediately

## Populated By
- Platform / DevOps lead on project onboarding
- Last reviewed: [ TODO: date ]
