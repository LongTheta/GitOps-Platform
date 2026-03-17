# Observability

What should be measured and why.

## As of March 2026

---

## DORA / DevOps Metrics

| Metric | Target | Purpose |
|--------|--------|---------|
| **Deployment frequency** | Higher is better | How often we ship |
| **Lead time** | Lower is better | Time from commit to production |
| **Change failure rate** | Lower is better | % of deployments causing incidents |
| **MTTR** | Lower is better | Time to recover from failure |

## Platform-Specific Metrics

| Metric | Purpose |
|--------|---------|
| **Sync success rate** | Argo CD sync success vs failure |
| **Drift detection** | Manual changes, out-of-sync resources |
| **Promotion latency** | Time from stage approval to prod deploy |
| **Policy violation rate** | PRs blocked by policy |
| **Manual override count** | Exceptions to GitOps flow |

## Observability Structure

Located in `observability/`:

| Path | Purpose |
|------|---------|
| `dashboards/deployment-intelligence/` | Pre-built dashboards (timeline, pipeline, GitOps integrity, etc.) |
| `dashboards/templates/` | Reusable templates |
| `dashboard-requests/` | Request schema for Easy Button |
| `generators/` | Generate dashboards from requests |
| `schemas/` | Onboarding schema |

## Dashboards (Placeholders / Implemented)

1. **01-deployment-timeline** — Commit → pipeline → sync
2. **02-pipeline-health** — CI/CD success rate, lead time
3. **03-gitops-integrity** — Drift, manual sync, bypass
4. **04-cluster-health** — Pod restarts, node readiness
5. **05-promotion-governance** — Promotion path, approval state
6. **06-supply-chain-artifact-lineage** — Image digest, SBOM
7. **07-executive-compliance-audit** — Audit trail, control evidence

## Easy Button

Application teams provide minimal config; platform generates scrape configs, dashboards, alerts. See `observability/Application-Observability-Onboarding-Guide.md`.

## Compliance Alignment

Maps to NIST SP 800-137, AU-2, AU-6, SI-4, CA-7. See `observability/docs/Compliance-Mapping.md`.
