# Platform Consumers

How this GitOps platform governs external application repositories.

## As of March 2026

---

## Why App Repos Are Separate

Application repositories (e.g. `demo-github-argo-insecure-app`) live **outside** this platform repo. They:

- Own application code, Dockerfiles, and base manifests
- Define CI/CD pipelines (build, test, artifact publish)
- Are developed and versioned independently

This platform repo **does not** duplicate app code. It:

- References app manifests via metadata (`source.yaml`)
- Applies environment-specific overlays (dev, stage, prod)
- Governs promotion and policy
- Deploys via Argo CD

**Separation benefits**: App teams iterate freely; platform enforces policy and promotion at the gate.

---

## How This Platform Consumes External Repos

### 1. Source Metadata

Each governed app has `platform/apps/<app>/source.yaml`:

```yaml
app_name: demo-github-argo-insecure-app
source_repo: LongTheta/demo-github-argo-insecure-app
source_url: https://github.com/LongTheta/demo-github-argo-insecure-app
source_branch: master
source_path: k8s
managed_by: gitops-platform
environments: [dev, stage, prod]
promotion_model: dev → stage → prod (prod requires manual approval)
```

This makes the relationship explicit and auditable.

### 2. Base + Overlays

- **base/** — Manifests derived from the app repo (e.g. `k8s/`). Platform may snapshot or reference.
- **overlays/** — Environment-specific patches: namespace, replicas, image tag, resource limits.

| Environment | Overlay | Policy |
|-------------|---------|--------|
| dev | `overlays/dev` | Validation |
| stage | `overlays/stage` | Policy must pass |
| prod | `overlays/prod` | Pinned image, limits, approval |

### 3. Argo CD Applications

`platform/argo/applications/` defines Argo CD Applications that point to platform overlay paths:

- `demo-github-argo-insecure-app-dev.yaml`
- `demo-github-argo-insecure-app-stage.yaml`
- `demo-github-argo-insecure-app-prod.yaml`

Argo CD syncs from **this platform repo**, not directly from app repos. The platform is the source of truth for what gets deployed.

---

## Policy Validation and Promotion

1. **App repo changes** → PR opened (in app repo or platform repo)
2. **Policy enforcement** → `scripts/policy-check.sh` runs in CI
3. **Promotion** → GitOps Promoter or `scripts/promote.sh` gates dev→stage→prod
4. **Deployment** → Argo CD syncs platform overlays to clusters

Policy blocks promotion when:

- Unpinned images (`:latest`)
- Missing resource limits
- Missing approvals (prod)

---

## How Demo Repos Prove the Platform

| Demo Repo | Purpose |
|-----------|---------|
| demo-github-argo-insecure-app | Intentionally weak manifests; policy blocks until fixed |
| demo-gitlab-argo-insecure-app | Same pattern for GitLab-hosted apps |

Running `./scripts/policy-check.sh` and `./scripts/promote.sh dev stage` demonstrates:

- Policy enforcement works
- Promotion is gated
- Platform produces actionable feedback

---

## Operating Model Summary

| Role | Responsibility |
|------|----------------|
| **App teams** | Build, test, publish artifacts; maintain app manifests |
| **Platform** | Govern promotion, enforce policy, deploy via Argo CD |
| **AI agent** | Optional PR validation and remediation (integration point) |

This is a **control plane** — it governs external application repositories, applies promotion and policy workflows, and deploys workloads through Argo CD across environments.
