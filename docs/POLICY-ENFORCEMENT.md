# Policy Enforcement

Where policy checks fit and how they can block promotion.

## As of March 2026

---

## Overview

Policy enforcement ensures that only compliant configurations reach production. Checks can run at:

1. **PR validation** (before merge)
2. **Promotion gate** (before promotion to prod)
3. **Admission** (at cluster apply time)

## Integration Points

### 1. PR Validation (Recommended)

- **When**: On every PR to the platform repo
- **Where**: CI pipeline (e.g., `.github/workflows/validate.yml`)
- **How**: Run `validate.sh`, policy checks, or external policy engine
- **Effect**: PR cannot merge until checks pass

### 2. Promotion Gate

- **When**: Before GitOps Promoter merges to production branch
- **Where**: GitOps Promoter approval workflow, or pre-merge hook
- **How**: Policy engine validates promoted manifests
- **Effect**: Promotion blocked if policy fails

### 3. Admission Control

- **When**: At apply time (Kubernetes admission)
- **Where**: OPA Gatekeeper, Kyverno, or custom admission webhook
- **How**: Validate resources against policies
- **Effect**: Reject non-compliant resources

## Policy Packs (Placeholders)

Located in `platform/policies/`:

| Pack | Purpose |
|------|---------|
| `org-baseline.yaml` | Org-wide baseline (resource limits, labels, etc.) |
| `promotion-policy.yaml` | Promotion-specific rules (e.g., digest in prod) |
| `fedramp-moderate.yaml` | FedRAMP Moderate alignment (placeholder) |

These are **integration points**. Actual policy logic lives in your policy engine (OPA, Gatekeeper, Kyverno, or AI agent).

## AI-Assisted Policy Enforcement

This repo can integrate with `ai-devsecops-policy-enforcement-agent` or similar:

- **PR validation**: Agent reviews PR; comments with remediation suggestions
- **Policy checks**: Agent evaluates manifests against policy pack
- **Remediation**: Agent can suggest patches or auto-fix where safe

Integration is **optional**. The repo defines where checks run; the agent plugs in as the policy engine.

## Blocking Promotion

Promotion to production can be blocked by:

1. **CI failure**: PR checks fail → no merge → no promotion
2. **Manual approval**: GitOps Promoter requires human approval for prod
3. **Policy failure**: Policy engine rejects manifests → promotion fails
4. **Admission rejection**: Cluster admission rejects non-compliant resources

## Compliance Language

Per [PRINCIPLES.md](../PRINCIPLES.md): Use "aligns with" or "supports" for compliance. Do not claim "FedRAMP compliant" or "certified" without verified documentation.
