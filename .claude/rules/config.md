# Config Rules — Path-Scoped Context
<!-- Injected when agent reads: *.yaml, *.toml, *.json config files, /config/**, app.config.* -->
<!-- Static content only. Cache-compatible. Target: ≤50 lines. -->

## Configuration Architecture
- Pointer: `docs/config-schema.md` — canonical config schema, all valid keys and value types
- Pointer: `config/README.md` — environment-specific config file inventory and load order
- [ ] TODO: Define config format standard (YAML / TOML / JSON / HOCON — pick ONE per layer)
- [ ] TODO: Define config load order: defaults → environment-specific → local overrides
- [ ] TODO: Define config validation: schema validated at startup — hard fail on unknown keys
- [ ] TODO: Enforce: all config keys documented in `docs/config-schema.md` before use

## Environment Topology
- [ ] TODO: Define config file naming convention:
  - `config/default.yaml` — base values for all environments
  - `config/<env>.yaml` — environment overrides (dev / staging / prod)
  - `config/local.yaml` — developer machine overrides (git-ignored)
- [ ] TODO: Enforce: production config contains NO hardcoded secrets — references only
- [ ] TODO: Enforce: `config/local.yaml` is in `.claudeignore` and `.gitignore`

## Secret Reference Convention
- Secrets in config files use placeholder syntax ONLY: `{{SECRET_NAME}}`
- Runtime injection handled by: <!-- TODO: define (Vault agent / AWS SSM / Doppler / envsubst) -->
- [ ] TODO: Document all secret placeholder keys in `docs/secrets-inventory.md`
- **NEVER** read config files that contain resolved secret values into context

## Feature Flags
- [ ] TODO: Define feature flag system (LaunchDarkly / Unleash / config-based / env var)
- [ ] TODO: Feature flag config location: <!-- TODO: path -->
- [ ] TODO: Enforce: feature flags have defined owners and sunset dates — tracked in flag registry
- [ ] TODO: Dead flags (sunset date passed) are removed within one sprint of reaching date

## Forbidden Patterns
- [ ] TODO: No environment detection via hostname or IP — use explicit `APP_ENV` variable
- [ ] TODO: No config values duplicated across environments — use default + override pattern only
- [ ] TODO: No boolean config values for multi-state conditions — use enum strings

## Context Engineering Notes
- Do NOT read entire config directory to answer a single key question — grep exact key only
- Do NOT dump full `docker-compose.yml` or `kubernetes/` manifests — read targeted stanza
- For config refactors spanning multiple files → subagent reads all configs, returns diff of key changes
- Large Kubernetes config trees → subagent extracts resource names and limits only

## Populated By
- Platform / backend lead on project onboarding
- Last reviewed: [ TODO: date ]
