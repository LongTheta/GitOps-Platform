# Demo Flow

How to demo this repo in 3–5 minutes, aligned to the demo app repositories.

## As of March 2026

---

## 1. What This Repo Is (30 sec)

"This is an enterprise-style GitOps platform repository. It defines environment separation, promotion workflows, policy enforcement integration points, and observability. It **governs external application repos** like demo-github-argo-insecure-app and demo-gitlab-argo-insecure-app. Everything is in Git—config as code, auditable."

---

## 2. Structure (60 sec)

- **platform/**: Environments (dev/stage/prod), apps with overlays, policies, promotion
- **platform/apps/demo-github-argo-insecure-app/**: Source metadata, base, overlays — governed app
- **platform/apps/demo-gitlab-argo-insecure-app/**: Same pattern for GitLab app
- **manifest-hydrator**: DRY config → hydrated manifests → Git branches
- **gitops-promoter**: Automated promotion with approvals (prod = manual)
- **observability**: Dashboards, Easy Button, deployment traceability
- **ai-recommendations-tab**: Argo CD UI extension for AI-backed recommendations

---

## 3. End-to-End Demo Flow (2 min)

1. **App repo changes are proposed** — Developer updates manifests in demo-github-argo-insecure-app (or platform overlay).

2. **Policy enforcement agent reviews** — Run `./scripts/policy-check.sh`. Demo app fails (unpinned image, no limits).

3. **Platform repo references approved app state** — Platform overlays apply env-specific patches. Prod overlay uses digest + limits.

4. **Promotion from dev to stage is simulated** — Run `./scripts/promote.sh dev stage`. Observe: ❌ Promotion Blocked (policy failure).

5. **Argo CD syncs desired state** — When policy passes, Argo CD Applications deploy to dev/stage/prod namespaces.

6. **Observability surfaces deployment/promotion results** — Dashboards show deployment frequency, drift, DORA metrics.

---

## 4. Promotion Flow (60 sec)

- Show `gitops-promoter/config/promotion-strategy.yaml`: dev → stage → prod
- Production: `autoMerge: false` — manual approval
- Show `platform/apps/demo-github-argo-insecure-app/`: base + overlays for each env
- Explain: merge to main → Hydrator hydrates → Promoter promotes → Argo syncs

---

## 5. Policy & Observability (60 sec)

- **Policies**: `platform/policies/` — integration points for OPA, Gatekeeper, or AI agent
- **Observability**: `observability/dashboards/` — deployment-intelligence dashboards
- Easy Button: app teams submit minimal config; platform generates dashboards

---

## 6. Self-Service (30 sec)

- New app: copy template from `platform/self-service/templates/`
- Add base + overlays → Argo Application → PR → policy check → merge
- Promotion follows workflow; prod requires approval

---

## Key Messages

- **Platform operating model**: Not just bootstrap—day-to-day workflows, promotion, policy
- **Governs external repos**: demo-github-argo-insecure-app, demo-gitlab-argo-insecure-app
- **Contributor-friendly**: Clear structure, docs, golden path
- **Extensible**: Policy engine, AI agent, observability plug in at defined points
- **Regulated-ready**: NIST alignment, audit trail, compliance language
