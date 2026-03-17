# Self-Service Onboarding

How teams onboard a new app into the platform.

## As of March 2026

---

## Golden Path

### 1. Create App Structure

```
platform/apps/my-app/
├── base/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── kustomization.yaml
└── overlays/
    ├── dev/
    │   └── kustomization.yaml
    ├── stage/
    │   └── kustomization.yaml
    └── prod/
        └── kustomization.yaml
```

### 2. Base Manifests

- `deployment.yaml`: Deployment with placeholders for replicas, image, resources
- `service.yaml`: Service definition
- `kustomization.yaml`: References resources

### 3. Overlays

- **dev**: Lower replicas, debug flags, optional resource limits
- **stage**: Mirrors prod config; full resource limits
- **prod**: Production replicas, image digest, strict limits

### 4. Argo CD Application

Add Application (or use ApplicationSet) in `platform/argo/applications/` pointing to the app path and overlay.

### 5. Observability Onboarding

Submit dashboard request in `observability/dashboard-requests/` or use Easy Button config. See `observability/Application-Observability-Onboarding-Guide.md`.

## Where Things Go

| Item | Location |
|------|----------|
| App base manifests | `platform/apps/<app>/base/` |
| Environment overlays | `platform/apps/<app>/overlays/<env>/` |
| Argo CD Application | `platform/argo/applications/` |
| Policy exceptions | Document in PR; platform team approves |
| Dashboard request | `observability/dashboard-requests/` |

## How Overlays Work

Kustomize overlays patch the base:

```yaml
# overlays/prod/kustomization.yaml
resources:
  - ../../base
patches:
  - patch: |-
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: my-app
      spec:
        replicas: 3
        template:
          spec:
            containers:
              - name: my-app
                image: my-registry/my-app@sha256:...
```

## How Promotion Works

1. Merge to main → Hydrator hydrates → pushes to env branches
2. GitOps Promoter manages promotion (dev → stage → prod)
3. Production requires manual approval

See [PROMOTION-WORKFLOW.md](PROMOTION-WORKFLOW.md).

## How Policy Validation Happens

1. PR opened → CI runs `scripts/validate.sh`
2. Policy engine (or placeholder) checks manifests
3. PR cannot merge until green
4. Platform team reviews for exceptions

See [POLICY-ENFORCEMENT.md](POLICY-ENFORCEMENT.md).

## Templates

`platform/self-service/templates/` provides starter templates for new apps. Copy and customize.
