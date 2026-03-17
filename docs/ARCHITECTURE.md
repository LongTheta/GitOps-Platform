# Platform Architecture

High-level architecture of the GitOps platform repository.

## As of March 2026

---

## Overview

This repository is the **source of truth** for the GitOps platform. It defines:

- Environment separation (dev, stage, prod)
- Application and infrastructure manifests
- Promotion workflows
- Policy enforcement integration points
- Observability and reporting

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         GITOPS PLATFORM REPO                                 │
│  Single source of truth; Git as the system of record                         │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
        ┌─────────────────────────────┼─────────────────────────────┐
        ▼                             ▼                             ▼
┌───────────────┐           ┌──────────────────┐           ┌──────────────────┐
│  Environments │           │  Promotion       │           │  Policy Engine    │
│  dev / stage  │           │  dev→stage→prod │           │  (integration     │
│  prod         │           │  approvals       │           │   point)         │
└───────────────┘           └──────────────────┘           └──────────────────┘
        │                             │                             │
        └─────────────────────────────┼─────────────────────────────┘
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  Argo CD / GitOps Promoter / Manifest Hydrator                               │
│  Sync from Git; promotion gates; DRY → hydrated manifests                    │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  Kubernetes Clusters (dev-cluster, stage-cluster, prod-cluster)              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Repository Layout

| Path | Purpose |
|------|---------|
| `platform/environments/` | Environment-specific kustomizations (dev, stage, prod) |
| `platform/apps/` | Application definitions with base + overlays |
| `platform/infrastructure/` | Platform infrastructure (namespaces, RBAC, etc.) |
| `platform/argo/` | Argo CD projects, applications, application sets |
| `platform/policies/` | Policy packs and enforcement integration points |
| `platform/promotion/` | Promotion workflow definitions and examples |
| `platform/self-service/` | Templates and onboarding for new apps |
| `manifest-hydrator/` | Argo CD Source Hydrator config (DRY → hydrated) |
| `gitops-promoter/` | Promotion strategy (dev→stage→prod) |
| `observability/` | Dashboards, metrics, alerts, Easy Button |
| `scripts/` | validate, promote, bootstrap |
| `examples/` | insecure, secure, promotion-flow |

## Key Components

### Environment Separation

- **dev**: Fast iteration; auto-sync; relaxed policy
- **stage**: Staging; mirrors prod config; policy checks enabled
- **prod**: Manual approval; strict policy; immutable artifacts

### Promotion Flow

1. DRY config in `apps/<app>/base` or overlays
2. Manifest Hydrator hydrates → pushes to `environment/<env>-next`
3. GitOps Promoter manages promotion with approvals
4. Production requires manual merge/approval

### Policy Integration

- Policy checks can block promotion (PR validation, pre-merge)
- Integration point for `ai-devsecops-policy-enforcement-agent` or OPA/Gatekeeper
- Policy packs in `platform/policies/`

### Observability

- Deployment frequency, lead time, change failure rate
- Drift detection, manual override visibility
- Dashboards in `observability/dashboards/`

## Assumptions

- Argo CD 2.x/3.x is the GitOps controller
- GitOps Promoter is installed for promotion workflows
- Manifest Hydrator is enabled for DRY → hydrated flow
- Prometheus/Grafana available for observability
- Policy engine (OPA, Gatekeeper, or AI agent) can be integrated via PR checks or admission
