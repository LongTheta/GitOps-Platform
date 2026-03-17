# Demo Flow

How to demo this repo in 3–5 minutes.

## As of March 2026

---

## 1. What This Repo Is (30 sec)

"This is an enterprise-style GitOps platform repository. It defines environment separation, promotion workflows, policy enforcement integration points, and observability. Everything is in Git—config as code, auditable."

## 2. Structure (60 sec)

- **platform/**: Environments (dev/stage/prod), apps with overlays, policies, promotion
- **manifest-hydrator**: DRY config → hydrated manifests → Git branches
- **gitops-promoter**: Automated promotion with approvals (prod = manual)
- **observability**: Dashboards, Easy Button, deployment traceability
- **ai-recommendations-tab**: Argo CD UI extension for AI-backed recommendations

## 3. Promotion Flow (60 sec)

- Show `gitops-promoter/config/promotion-strategy.yaml`: dev → stage → prod
- Production: `autoMerge: false` — manual approval
- Show `platform/apps/example-app/`: base + overlays for each env
- Explain: merge to main → Hydrator hydrates → Promoter promotes → Argo syncs

## 4. Policy & Observability (60 sec)

- **Policies**: `platform/policies/` — integration points for OPA, Gatekeeper, or AI agent
- **Observability**: `observability/dashboards/` — 7 deployment-intelligence dashboards
- Easy Button: app teams submit minimal config; platform generates dashboards

## 5. Self-Service (30 sec)

- New app: copy template from `platform/self-service/templates/`
- Add base + overlays → Argo Application → PR → policy check → merge
- Promotion follows workflow; prod requires approval

## Key Messages

- **Platform operating model**: Not just bootstrap—day-to-day workflows, promotion, policy
- **Contributor-friendly**: Clear structure, docs, golden path
- **Extensible**: Policy engine, AI agent, observability plug in at defined points
- **Regulated-ready**: NIST alignment, audit trail, compliance language
