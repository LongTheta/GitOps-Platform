# GitOps Platform

An enterprise-style GitOps platform repository with environment separation, promotion workflows, policy enforcement integration points, observability scaffolding, and a clear self-service operating model.

## What This Repo Is

This repository is the **source of truth** for the GitOps platform. It defines:

- **Environment separation** — dev, stage, prod with distinct config and approval gates
- **Promotion workflows** — dev → stage → prod with manual approval for production
- **Policy enforcement** — integration points for OPA, Gatekeeper, or AI policy agents
- **Observability** — deployment traceability, DORA metrics, compliance dashboards
- **Self-service** — golden path for onboarding new applications

## Why It Exists

To provide a **platform operating model**—not just bootstrap code—that teams can use day to day. Promotion-aware, policy-aware, observable, contributor-friendly, and extensible for regulated environments.

## Repository Structure

```
gitops-platform/
├── README.md
├── PRINCIPLES.md
├── docs/                    # Platform operating model
│   ├── ARCHITECTURE.md
│   ├── OPERATING-MODEL.md
│   ├── PROMOTION-WORKFLOW.md
│   ├── POLICY-ENFORCEMENT.md
│   ├── OBSERVABILITY.md
│   ├── SELF-SERVICE.md
│   ├── DEMO-FLOW.md
│   └── AI-POLICY-INTEGRATION.md
├── platform/
│   ├── environments/       # dev, stage, prod kustomizations
│   ├── apps/               # Applications with base + overlays
│   │   └── example-app/
│   ├── argo/               # Argo CD projects, applications
│   ├── policies/           # Policy packs (integration points)
│   ├── promotion/          # Promotion workflow docs
│   └── self-service/       # Templates, onboarding
├── manifest-hydrator/       # Argo CD Source Hydrator (DRY → hydrated)
├── gitops-promoter/        # Promotion strategy (dev→stage→prod)
├── ai-recommendations-tab/  # Argo CD UI extension + MCP backend
├── automation-achievement/ # KPI validation scripts
├── skills-installer/       # Code-server + Skills provisioning
├── observability/          # Dashboards, Easy Button, generators
├── scripts/                # validate.sh, promote.sh, bootstrap.sh
├── examples/               # insecure, secure, promotion-flow
└── .github/workflows/      # validate.yml
```

## How Environments Work

| Environment | Purpose | Approval |
|-------------|---------|----------|
| **dev** | Fast iteration | Auto |
| **stage** | Pre-production validation | Auto |
| **prod** | Production | Manual |

See [docs/PROMOTION-WORKFLOW.md](docs/PROMOTION-WORKFLOW.md).

## How Promotion Works

1. Merge to main → Manifest Hydrator hydrates → pushes to env branches
2. GitOps Promoter manages promotion (dev → stage → prod)
3. Production requires manual approval (`autoMerge: false`)

See [docs/PROMOTION-WORKFLOW.md](docs/PROMOTION-WORKFLOW.md).

## Where Policies Fit

- **platform/policies/** — Policy packs (org-baseline, promotion-policy, fedramp-moderate)
- **PR validation** — CI runs `scripts/validate.sh`; policy engine can block merge
- **Promotion gate** — Policy checks before prod promotion

See [docs/POLICY-ENFORCEMENT.md](docs/POLICY-ENFORCEMENT.md).

## Where Observability Fits

- **observability/dashboards/** — Deployment timeline, pipeline health, GitOps integrity, etc.
- **Easy Button** — App teams submit minimal config; platform generates dashboards
- **DORA metrics** — Deployment frequency, lead time, change failure rate, MTTR

See [docs/OBSERVABILITY.md](docs/OBSERVABILITY.md).

## How to Onboard an App

1. Copy template from `platform/self-service/templates/app-template/`
2. Add base + overlays (dev, stage, prod)
3. Add Argo CD Application in `platform/argo/applications/`
4. Submit PR → policy check → merge → promotion follows workflow

See [docs/SELF-SERVICE.md](docs/SELF-SERVICE.md).

## Quick Start

```bash
# Validate platform structure and manifests
./scripts/validate.sh
./scripts/policy-check.sh

# Bootstrap (validate + policy check + summary)
./scripts/bootstrap.sh

# Deploy components
kubectl apply -f manifest-hydrator/config/
kubectl apply -f gitops-promoter/config/   # See gitops-promoter/config/README.md for setup
kubectl apply -f platform/argo/

# Deploy observability (Grafana dashboards)
./scripts/deploy-observability.sh
```

## AI Integration

This repo can integrate with `ai-devsecops-policy-enforcement-agent` or similar for PR validation, policy checks on promotion, and remediation comments. Integration is optional; see [docs/AI-POLICY-INTEGRATION.md](docs/AI-POLICY-INTEGRATION.md).

## Documentation

| Doc | Purpose |
|-----|---------|
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | High-level platform architecture |
| [OPERATING-MODEL.md](docs/OPERATING-MODEL.md) | Day-to-day workflows |
| [PROMOTION-WORKFLOW.md](docs/PROMOTION-WORKFLOW.md) | Promotion between environments |
| [POLICY-ENFORCEMENT.md](docs/POLICY-ENFORCEMENT.md) | Policy checks and blocking |
| [OBSERVABILITY.md](docs/OBSERVABILITY.md) | Metrics and dashboards |
| [SELF-SERVICE.md](docs/SELF-SERVICE.md) | App onboarding |
| [DEMO-FLOW.md](docs/DEMO-FLOW.md) | 3–5 minute demo |
| [AI-POLICY-INTEGRATION.md](docs/AI-POLICY-INTEGRATION.md) | AI policy agent integration |
| [BRANCH-PROTECTION.md](docs/BRANCH-PROTECTION.md) | Require validation before merge |
| [RUNBOOK.md](docs/RUNBOOK.md) | Emergency procedures, manual override |

## Federal DevSecOps Alignment

Aligns with GitOps capabilities: CI/CD orchestration, config as code, security scanning, promotion governance, observability, identity/secrets, policy as code. Maps to NIST SP 800-137, AU-2, AU-6, SI-4, CA-7. Per [PRINCIPLES.md](PRINCIPLES.md): use "aligns with," not "certified."

## Version

As of March 2026. Argo CD 2.x/3.x, Grafana 11.x, GitOps Promoter v0.24+.
