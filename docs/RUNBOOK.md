# Runbook

Emergency procedures and manual override process.

## As of March 2026

---

## Emergency: Production Incident

### 1. Assess severity

- **P1**: Production down, data loss risk
- **P2**: Degraded, major feature broken
- **P3**: Minor, workaround available

### 2. Rollback (if needed)

**Option A: Argo CD rollback**

```bash
# List app history
argocd app history <app-name>

# Rollback to previous revision
argocd app rollback <app-name> <revision>
```

**Option B: Git revert**

```bash
git revert <bad-commit> --no-edit
git push origin master
# Argo CD syncs the revert
```

### 3. Manual override (emergency only)

If GitOps flow is blocked and immediate fix is required:

1. **Document** in incident ticket: what, why, who approved
2. **Apply** change manually: `kubectl apply -f ...` or `kubectl edit`
3. **Commit** the fix to Git **within 24 hours** for audit trail
4. **Post-incident**: Review why GitOps was bypassed; improve process

### 4. Post-incident

- Update runbook if needed
- Document in observability (manual override count)
- Review policy: should this have been caught?

---

## Manual Override Process

| Step | Action |
|------|--------|
| 1 | Get approval from platform lead or SRE |
| 2 | Apply change via kubectl |
| 3 | Verify change is correct |
| 4 | Commit equivalent config to Git within 24h |
| 5 | Document in incident/change log |

---

## Drift Detection

If observability shows drift (manual changes, out-of-sync):

1. **Identify** which resource is drifted
2. **Decide**: Revert to Git (recommended) or commit the manual change
3. **If reverting**: `argocd app sync --force` or fix in Git and sync
4. **If keeping**: Commit the change to Git; update platform manifests

---

## Promotion Blocked

If promotion to production is stuck:

1. **Check** GitOps Promoter logs: `kubectl logs -n gitops-promoter -l app=gitops-promoter`
2. **Check** Argo CD sync status: `argocd app get <app-name>`
3. **Check** policy: Did policy check fail? Fix in PR and re-run
4. **Check** approval: Is manual approval required? Approve in GitOps Promoter UI or merge PR

---

## Argo CD Not Syncing

1. **Check** Application status: `argocd app get <app-name>`
2. **Check** repo access: Can Argo CD reach the Git repo?
3. **Check** credentials: Secret valid? Token expired?
4. **Hard refresh**: `argocd app get <app-name> --refresh`

---

## Grafana / Observability Down

1. **Check** Grafana pods: `kubectl get pods -n grafana`
2. **Check** Prometheus: Is it scraping? `kubectl port-forward -n monitoring svc/prometheus 9090:9090` then check targets
3. **Restore** dashboards from Git: `observability/dashboards/` is source of truth

---

## Contacts

| Role | Responsibility |
|------|----------------|
| Platform team | Platform config, promotion, policy |
| SRE | Production approval, incidents |
| App team | App-specific rollback, config |

---

## Compliance Note

Manual overrides are visible in audit logs. Document all overrides for NIST AU-2, AU-6 evidence.
