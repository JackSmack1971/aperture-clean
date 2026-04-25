# Infra Rules Skill
<!-- Trigger: Invoke when reading/editing files under /infra/** or *.tf -->

## Quick Reference
- Terraform: `infra/terraform/`
- K8s: `infra/k8s/`
- IAM: `infra/iam/`

## Key Constraints
- **NEVER** modify production infra without human confirmation
- **NEVER** read Terraform state files directly (too large); use `terraform show` summary
- Every infra change REQUIRES a cost estimate note

## Full Rules
See: `.claude/rules/infra.md`
