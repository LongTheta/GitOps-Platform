# demo-gitlab-argo-insecure-app

Platform-managed application. Source: [LongTheta/demo-gitlab-argo-insecure-app](https://gitlab.com/LongTheta/demo-gitlab-argo-insecure-app) (GitLab variant)

## What This App Is

GitLab-hosted variant of the insecure demo app. Same pattern as `demo-github-argo-insecure-app` — policy blocks promotion until manifests are hardened.

## How the Platform References It

- **source.yaml** — Documents repo URL, branch, path, promotion model
- **base/** — Manifests derived from the app repo `k8s/` directory
- **overlays/** — Environment-specific patches (dev, stage, prod)

## Promotion

| Environment | Overlay | Policy Gate |
|-------------|---------|-------------|
| dev | `overlays/dev` | Validation only |
| stage | `overlays/stage` | Policy must pass |
| prod | `overlays/prod` | Pinned image, limits, manual approval |

## Policy Enforcement

- **Base** — Intentionally weak → policy fails
- **Prod overlay** — Adds digest, resource limits → policy passes when promoted
- AI policy agent can plug in for PR validation before merge

## Argo CD

Applications: `platform/argo/applications/demo-gitlab-argo-insecure-app-{dev,stage,prod}.yaml`
