# Operating Model

How teams use the GitOps platform repository day to day.

## As of March 2026

---

## Roles

| Role | Responsibility |
|------|----------------|
| **Platform team** | Maintains platform structure, policies, promotion workflows, observability |
| **Application team** | Adds app manifests, uses overlays, requests promotion |
| **SRE / Ops** | Monitors drift, handles incidents, approves production promotions |

## Day-to-Day Workflows

### Adding a New Application

1. Create app in `platform/apps/<app-name>/` with base + overlays
2. Add Argo CD Application (or use ApplicationSet) in `platform/argo/applications/`
3. Submit PR; policy checks run; platform team reviews
4. Merge → syncs to dev; promotion to stage/prod follows workflow

See [SELF-SERVICE.md](SELF-SERVICE.md) for detailed onboarding.

### Promoting to Production

1. App is synced and healthy in stage
2. Create promotion request (PR or GitOps Promoter workflow)
3. Policy checks pass
4. SRE/Ops approves
5. Merge or GitOps Promoter promotes to prod

See [PROMOTION-WORKFLOW.md](PROMOTION-WORKFLOW.md).

### Responding to Drift

1. Observability dashboards show drift (manual changes, out-of-sync)
2. Platform team investigates; either fixes in Git and syncs, or documents exception
3. Manual overrides are visible in audit trail

### Policy Violations

1. PR fails policy check (e.g., missing resource limits, insecure config)
2. Developer remediates per feedback
3. Re-run checks; merge when green

See [POLICY-ENFORCEMENT.md](POLICY-ENFORCEMENT.md).

## Golden Path

The platform provides a **golden path** for applications:

- Use base + overlay pattern (Kustomize)
- Store config in Git
- Use immutable image digests in prod
- Enable observability onboarding
- Follow promotion workflow

Deviations require platform team approval and documentation.

## Change Cadence

- **Platform changes**: PR → review → merge → Argo sync
- **App changes**: PR → policy check → review → merge → sync to dev → promote
- **Emergency**: Document in runbook; platform team can apply manually with post-hoc Git commit
