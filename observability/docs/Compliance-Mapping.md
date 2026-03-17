# Compliance Mapping

Mapping of the Observability Easy Button framework to NIST controls. This project **supports** and **aligns with** these controls; it does not satisfy or certify compliance.

## As of March 2026

---

## Control Mapping

| Control | Description | Framework Support | Evidence Collection |
|---------|-------------|-------------------|---------------------|
| **NIST SP 800-137** | Continuous monitoring | Consistent telemetry, dashboards, Git-based config | Collect dashboard exports, Git history, sync logs |
| **AU-2** | Auditable events | Git commits, Argo CD sync events | Git log, `argocd_app_sync_total` metrics |
| **AU-6** | Audit review, analysis | Deployment Intelligence dashboards | Executive Compliance / Audit dashboard exports |
| **SI-4** | System monitoring | Metrics, dashboards, alert rules | Scrape configs, dashboard JSON, alert rule files |
| **CA-7** | Continuous monitoring | Full observability pipeline | End-to-end evidence: config → metrics → dashboards |

---

## Language Guidance

- **Use**: "supports", "aligns with", "enables evidence for", "maps to"
- **Avoid**: "satisfies", "implements", "certified", "FedRAMP compliant" (unless verified by assessor)

---

## Evidence Collection Recommendations

1. **Git history** — Retain commit history for onboarding config and generated artifacts
2. **Dashboard exports** — Periodic export of Deployment Intelligence dashboards for audit
3. **Argo CD metrics** — Retain Prometheus data for `argocd_app_*` metrics per retention policy
4. **Provisioning config** — Document Grafana provisioning path and sync mechanism

---

## Assumptions

- Argo CD (or equivalent) is deployed and metrics are scraped
- Grafana is configured with appropriate RBAC for compliance review
- Evidence retention aligns with organizational policy
