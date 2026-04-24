# APERTURE QUICK REFERENCE
<!-- Goal: Keep context < 38% | Limit: 50 lines -->

## Token Thresholds
| Limit | Action | Outcome |
|:---|:---|:---|
| 38.0% | `/compact` | Stability Plateau |
| 43.2% | **CLI CLIFF** | Reasoning Collapse |
| 80.0% | `HANDOVER` | Hard Reset Required |

## Domain Skills Index
| Domain | Path | Rule File |
|:---|:---|:---|
| API | `/api/**` | `api.md` |
| DB | `/db/**` | `db.md` |
| Infra | `/infra/**` | `infra.md` |
| Security | `/sec/**` | `security.md` |
| Testing | `*.test.*` | `testing.md` |

## WISC Protocol
- **Write**: Continuous state persistence to disk.
- **Isolate**: Delegate heavy tasks to subagents.
- **Select**: Targeted node/range reads only.
- **Compress**: Compaction at 38% / Clear at 80%.

## Compaction Protocol (2-Step)
1. Run `.claude/hooks/pre-compact.sh` to extract state.
2. Execute generated `/compact preserve: [...]` command.

## State Freeze Protocol
1. Detect cliff (43.2%) or loop.
2. Generate `HANDOVER.md` state snapshot.
3. Run `/clear` and resume in fresh session.

## CLI Commands
- `/tokens` : Check current saturation.
- `/compact` : Manual memory pruning.
- `/clear` : Flush session context.
- `/agents` : View active skill triggers.
