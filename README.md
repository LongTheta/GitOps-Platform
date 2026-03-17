# GitOps Platform

An enterprise GitOps platform with enforced promotion workflows, policy-driven controls, and observable deployment pipelines — not just infrastructure as code.

---

## Example Platform Run (Real Workflow)

![Platform Demo](docs/images/platform-demo.png)

*Screenshot: Promotion workflow, policy enforcement, Argo CD sync. Add `docs/images/platform-demo.png` when available.*

### Terminal Output: Promotion Blocked

```
❌ Promotion Blocked: FAILED POLICY CHECK
Environment: stage → prod
Application: example-app

Reasons:
  - Missing approval (production requires manual approval)
  - Policy violation: unpinned image (use digest, not :latest)
  - Drift detected in Argo CD (cluster state differs from Git)

Action: Fix policy violations, obtain approval, resolve drift. Then retry promotion.
```

### What This Proves

- **GitOps promotion enforcement works** — Production is gated; promotion is controlled, not automatic
- **Policy can block production** — Unpinned images, missing limits, and drift block promotion
- **Platform produces actionable outputs** — Clear failure reasons; deterministic behavior
- **System behaves like a real CI/CD control plane** — Validation, policy, promotion, observability are integrated

---

## Platform Workflow (End-to-End)

1. **Developer commits** app config to `platform/apps/<app>/` (base + overlays)
2. **Manifest Hydrator** renders environment-specific manifests; pushes to env branches
3. **Argo CD** syncs desired state from Git to clusters
4. **Policy Enforcement** validates:
   - PRs (before merge)
   - Promotions (before prod)
5. **GitOps Promoter** handles:
   - dev → stage → prod flow
   - Approvals and checks (prod = manual)
6. **Observability** tracks:
   - Deployments (timeline, frequency)
   - Drift (cluster vs Git)
   - Failures (change failure rate, MTTR)
7. **(Optional)** AI Recommendations assist review and remediation in Argo CD UI

---

## Core Platform Components

| Component | Role | Lifecycle Stage |
|-----------|------|-----------------|
| **Manifest Hydrator** | DRY config → hydrated manifests → Git branches | Pre-sync; produces env-specific manifests |
| **GitOps Promoter** | Promotion between environments; approvals | Post-merge; gates stage→prod |
| **Argo CD** | Sync desired state from Git to clusters | Continuous; reconciliation |
| **Policy Enforcement** | Validate PRs, block promotion on violations | PR validation; promotion gate |
| **Observability** | Deployment timeline, drift, DORA metrics | Post-deploy; visibility |
| **AI Recommendations Tab** | App health, optimizations, fixes in Argo CD UI | Review; remediation hints |

These form **one system** — a GitOps control plane with promotion, policy, and visibility.

---

## Promotion Model

Promotion is **controlled**, not automatic. Requirements:

| Requirement | Where Enforced |
|--------------|----------------|
| Successful validation | CI; `validate.sh`, `policy-check.sh` |
| Policy pass | PR gate; promotion gate |
| Approvals | GitOps Promoter (prod `autoMerge: false`) |
| Artifact immutability | Policy (prod must use image digest) |

### Promotion Blocked If

- Policy fails (unpinned image, missing limits, etc.)
- Approval missing (prod requires human approval)
- Drift detected (cluster state ≠ Git)
- Artifact mismatch (digest vs tag in prod)

See [docs/PROMOTION-WORKFLOW.md](docs/PROMOTION-WORKFLOW.md).

---

## Policy Enforcement Examples

### Example Rule: No `:latest` in Production

```yaml
# platform/policies/promotion-policy.yaml
rules:
  - name: immutable-artifact
    description: Production must use image digest
    check: image must match @sha256:...
```

### Example Rule: Resource Limits Required

```yaml
# platform/policies/org-baseline.yaml
rules:
  - name: resource-limits
    description: All containers must have resource limits
    check: deployment.spec.template.spec.containers[].resources.limits
```

### Example Failure Message

```
ERROR: platform/apps/example-app/overlays/prod/kustomization.yaml contains :latest (use digest in prod)
```

### Where Enforcement Happens

| Stage | Mechanism |
|-------|-----------|
| PR validation | `scripts/policy-check.sh` in CI |
| Promotion gate | Policy engine + GitOps Promoter |

**Integration**: [ai-devsecops-policy-enforcement-agent](https://github.com/example/ai-devsecops-policy-enforcement-agent) can plug in for PR validation and remediation comments. Loosely coupled — integration point, not dependency.

---

## Quick Start (2 minutes)

```bash
# Validate platform structure and manifests
./scripts/validate.sh
./scripts/policy-check.sh
```

Inspect `platform/`, `platform/apps/`, `platform/environments/`. See [docs/example-outputs/](docs/example-outputs/) for expected output.

---

## Platform Demo (5 minutes)

```bash
# 1. Validate
./scripts/validate.sh
./scripts/policy-check.sh

# 2. Dry-run promotion (requires kustomize or kubectl)
ENV=prod ./scripts/promote.sh dry-run

# 3. Check promotion config
./scripts/promote.sh check

# 4. Bootstrap (full validation + summary)
./scripts/bootstrap.sh
```

---

## Deployment (Advanced)

```bash
# Deploy platform components
kubectl apply -f manifest-hydrator/config/
kubectl apply -f gitops-promoter/config/   # See gitops-promoter/config/README.md
kubectl apply -f platform/argo/

# Deploy observability (Grafana dashboards)
./scripts/deploy-observability.sh
```

---

## Demo Repositories (Platform Consumers)

These repos run **on** this platform; they demonstrate policy enforcement and promotion:

| Repo | Purpose |
|------|---------|
| [demo-gitlab-argo-insecure-app](https://gitlab.com/example/demo-gitlab-argo-insecure-app) | Insecure app; policy blocks promotion |
| [demo-github-argo-insecure-app](https://github.com/example/demo-github-argo-insecure-app) | Same pattern for GitHub |

*Add your demo repo URLs when available. They show the platform enforcing policy on consumer apps.*

---

## Observability (Deployment Visibility)

![Observability Dashboard](docs/images/observability-dashboard.png)

*Placeholder: Deployment timeline, drift, DORA metrics. Add `docs/images/observability-dashboard.png` when available.*

| Metric | Purpose |
|--------|---------|
| **Deployment frequency** | How often we ship |
| **Lead time** | Commit → production |
| **Change failure rate** | % deployments causing incidents |
| **MTTR** | Time to recover |
| **Drift detection** | Cluster vs Git |
| **Manual overrides** | Exceptions to GitOps flow |

Dashboards: `observability/dashboards/deployment-intelligence/`. See [docs/OBSERVABILITY.md](docs/OBSERVABILITY.md).

---

## Example Outputs

The platform produces these artifacts. Proof of deterministic, executable behavior.

| Output | Source | Example |
|--------|--------|---------|
| Validation results | `validate.sh` | [docs/example-outputs/validate-success.txt](docs/example-outputs/validate-success.txt) |
| Policy failure | `policy-check.sh` | [docs/example-outputs/policy-check-failure.txt](docs/example-outputs/policy-check-failure.txt) |
| Promotion blocked | GitOps Promoter / policy gate | [docs/example-outputs/promotion-blocked.txt](docs/example-outputs/promotion-blocked.txt) |
| Drift report | Observability | See [docs/example-outputs/README.md](docs/example-outputs/README.md) |

---

## Repository Structure

```
gitops-platform/
├── README.md
├── PRINCIPLES.md
├── docs/
│   ├── images/              # platform-demo.png, observability-dashboard.png
│   ├── example-outputs/     # Validation, policy, promotion outputs
│   ├── ARCHITECTURE.md
│   ├── PROMOTION-WORKFLOW.md
│   ├── POLICY-ENFORCEMENT.md
│   └── ...
├── platform/
│   ├── environments/        # dev, stage, prod
│   ├── apps/                # example-app, backend-service
│   ├── argo/                # Projects, Applications
│   ├── policies/            # org-baseline, promotion-policy
│   └── self-service/       # Templates, onboarding
├── manifest-hydrator/       # DRY → hydrated
├── gitops-promoter/         # Promotion strategy
├── ai-recommendations-tab/  # Argo CD UI extension + MCP
├── observability/           # Dashboards, Easy Button
├── scripts/                 # validate, policy-check, promote, bootstrap
├── examples/                # insecure, secure, promotion-flow
└── .github/workflows/       # validate.yml
```

---

## How to Onboard an App

1. Copy template from `platform/self-service/templates/app-template/`
2. Add base + overlays (dev, stage, prod)
3. Add Argo CD Application in `platform/argo/applications/`
4. Submit PR → policy check → merge → promotion follows workflow

See [docs/SELF-SERVICE.md](docs/SELF-SERVICE.md).

---

## Documentation

| Doc | Purpose |
|-----|---------|
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | Platform architecture |
| [PROMOTION-WORKFLOW.md](docs/PROMOTION-WORKFLOW.md) | Promotion between environments |
| [POLICY-ENFORCEMENT.md](docs/POLICY-ENFORCEMENT.md) | Policy checks and blocking |
| [OBSERVABILITY.md](docs/OBSERVABILITY.md) | Metrics and dashboards |
| [SELF-SERVICE.md](docs/SELF-SERVICE.md) | App onboarding |
| [DEMO-FLOW.md](docs/DEMO-FLOW.md) | 3–5 minute demo |
| [AI-POLICY-INTEGRATION.md](docs/AI-POLICY-INTEGRATION.md) | AI policy agent integration |
| [BRANCH-PROTECTION.md](docs/BRANCH-PROTECTION.md) | Require validation before merge |
| [RUNBOOK.md](docs/RUNBOOK.md) | Emergency procedures |

---

## Federal DevSecOps Alignment

Aligns with GitOps capabilities: CI/CD orchestration, config as code, security scanning, promotion governance, observability, identity/secrets, policy as code. Maps to NIST SP 800-137, AU-2, AU-6, SI-4, CA-7. Per [PRINCIPLES.md](PRINCIPLES.md): use "aligns with," not "certified."

---

## Version

As of March 2026. Argo CD 2.x/3.x, Grafana 11.x, GitOps Promoter v0.24+.
