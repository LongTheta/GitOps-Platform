# Promotion Workflow

How applications and artifacts progress from dev → stage → prod.

## As of March 2026

---

## Overview

```
  dev (auto)          stage (auto)         prod (manual approval)
     │                     │                        │
     ▼                     ▼                        ▼
  environment/         environment/            environment/
  development          staging                 production
     │                     │                        │
     └─────────────────────┴────────────────────────┘
                          │
                    GitOps Promoter
                    (PromotionStrategy)
```

## Environments

| Environment | Branch | Auto-merge | Approval |
|-------------|--------|-----------|----------|
| development | environment/development | Yes | None |
| staging | environment/staging | Yes | None |
| production | environment/production | No | Yes (SRE/Ops) |

## What Gets Promoted

- **Manifests**: Hydrated Kubernetes manifests (Deployment, Service, ConfigMap, etc.)
- **Artifacts**: Container images (by digest in prod)
- **Config**: Environment-specific config (replicas, resources, feature flags)

## Promotion Flow (Detail)

### 1. Development

- Developer commits to `apps/<app>/overlays/dev/` or base
- Manifest Hydrator hydrates and pushes to `environment/development-next`
- GitOps Promoter merges to `environment/development` (autoMerge: true)
- Argo CD syncs to dev cluster

### 2. Staging

- Promotion from dev to stage: staging branch receives promoted manifests
- GitOps Promoter merges to `environment/staging` (autoMerge: true)
- Argo CD syncs to stage cluster
- Policy checks run; staging is a pre-production gate

### 3. Production

- Promotion from stage to prod requires **manual approval**
- GitOps Promoter: `autoMerge: false` for production
- SRE/Ops approves PR or merge in GitOps Promoter UI
- Argo CD syncs to prod cluster

## Immutable Artifact Expectations

- **Dev/Stage**: Image tags allowed; faster iteration
- **Prod**: Use image digests (e.g., `my-registry/my-app@sha256:...`) for immutability and traceability

## Approval Gates

- **Policy**: PR must pass policy checks (resource limits, security, etc.)
- **Promotion**: Production promotion requires human approval
- **Sync**: Argo CD sync can be manual for prod in critical scenarios

## Configuration

Promotion strategy is defined in `gitops-promoter/config/promotion-strategy.yaml`:

```yaml
environments:
  - name: development
    branch: environment/development
    autoMerge: true
  - name: staging
    branch: environment/staging
    autoMerge: true
  - name: production
    branch: environment/production
    autoMerge: false  # Manual approval
```

## Integration

- **Manifest Hydrator**: Produces hydrated manifests; pushes to env branches
- **GitOps Promoter**: Manages promotion between branches
- **Argo CD**: Syncs from promoted branches to clusters
