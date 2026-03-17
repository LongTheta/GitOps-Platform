# Promotion Flow Example

Walkthrough of how an app progresses dev → stage → prod.

## Scenario

App `example-app` with image `example.com/example-app:v1.2.3`.

## Step 1: Dev

- Developer commits to `platform/apps/example-app/overlays/dev/`
- Image: `example.com/example-app:dev` (tag allowed)
- Replicas: 1
- Argo CD syncs; app runs in dev cluster

## Step 2: Stage

- Promotion from dev branch to stage branch
- GitOps Promoter merges (autoMerge: true)
- Image: `example.com/example-app:staging`
- Replicas: 2
- Policy checks run; staging validates before prod

## Step 3: Prod

- Promotion from stage to prod **requires manual approval**
- SRE/Ops approves in GitOps Promoter or via PR merge
- Image: `example.com/example-app@sha256:...` (digest, immutable)
- Replicas: 3
- Argo CD syncs to prod cluster

## Artifacts

| Env | Image | Replicas |
|-----|-------|----------|
| dev | tag (:dev) | 1 |
| stage | tag (:staging) | 2 |
| prod | digest (@sha256:...) | 3 |

## Config Location

- Base: `platform/apps/example-app/base/`
- Overlays: `platform/apps/example-app/overlays/{dev,stage,prod}/`
- Promotion: `gitops-promoter/config/promotion-strategy.yaml`
