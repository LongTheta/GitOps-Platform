# Promotion

Promotion workflow definitions and examples.

## Overview

Promotion is managed by **GitOps Promoter**. Configuration is in `../../gitops-promoter/config/`.

## Flow

1. **dev** → auto-merge; fast iteration
2. **stage** → auto-merge; pre-production validation
3. **prod** → manual approval required

## Examples

See `examples/` for promotion flow walkthrough.

## Integration

- **Manifest Hydrator**: Produces hydrated manifests; pushes to env branches
- **GitOps Promoter**: `gitops-promoter/config/promotion-strategy.yaml`
- **Argo CD**: Syncs from promoted branches
