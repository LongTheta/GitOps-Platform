# demo-github-argo-insecure-app

Platform-managed application. Source: [LongTheta/demo-github-argo-insecure-app](https://github.com/LongTheta/demo-github-argo-insecure-app)

## What This App Is

An intentionally insecure demo application for policy enforcement. Uses `:latest` image, no resource limits — designed to fail policy checks until fixed.

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

- **Base** — Intentionally weak (no limits, `:latest`) → policy fails
- **Prod overlay** — Adds digest, resource limits → policy passes when promoted
- `scripts/policy-check.sh` blocks promotion until base or overlays are fixed

## Argo CD

Applications: `platform/argo/applications/demo-github-argo-insecure-app-{dev,stage,prod}.yaml`
