# Example Outputs

Platform produces these artifacts. Proof of deterministic, executable behavior.

| Output | Source | Purpose |
|--------|--------|---------|
| `validate-success.txt` | `scripts/validate.sh` | Structure + kustomize build validation |
| `policy-check-failure.txt` | `scripts/policy-check.sh` | Policy violation (blocks merge/promotion) |
| `promotion-blocked.txt` | GitOps Promoter / policy gate | Promotion blocked; actionable reasons |

## Drift Report (Observability)

Example drift detection output:

```
Drift detected: deployment/example-app in namespace prod
  Git:    image=example.com/app@sha256:abc123
  Cluster: image=example.com/app@sha256:def456
  Action: Sync from Git or document exception
```
