# GitOps Deployment Intelligence Platform Design

Design for the seven platform dashboards provisioned via GitOps, using Argo CD Prometheus metrics.

## As of March 2026

**Source**: Argo CD official metrics documentation. Compatible with Argo CD 2.x, Grafana 11.x.

---

## 1. Primary Metrics (15 Argo CD Prometheus Metrics)

The platform dashboards use these native Argo CD Application Controller metrics:

| # | Metric | Type | Purpose |
|---|--------|------|---------|
| 1 | `argocd_app_info` | gauge | App state (sync_status, health_status) |
| 2 | `argocd_app_condition` | gauge | Application conditions |
| 3 | `argocd_app_k8s_request_total` | counter | K8s requests during reconciliation |
| 4 | `argocd_app_orphaned_resources_count` | gauge | Orphaned resources per app |
| 5 | `argocd_app_reconcile` | histogram | Reconciliation performance |
| 6 | `argocd_app_sync_total` | counter | Sync history (phase: Succeeded, Failed, etc.) |
| 7 | `argocd_app_sync_duration_seconds_total` | counter | Sync duration |
| 8 | `argocd_cluster_api_resource_objects` | gauge | K8s resource objects in cache |
| 9 | `argocd_cluster_api_resources` | gauge | Monitored API resources |
| 10 | `argocd_cluster_cache_age_seconds` | gauge | Cluster cache age |
| 11 | `argocd_cluster_connection_status` | gauge | Cluster connection status |
| 12 | `argocd_cluster_events_total` | counter | Processed K8s resource events |
| 13 | `argocd_cluster_info` | gauge | Cluster information |
| 14 | `argocd_redis_request_duration` | histogram | Redis request duration |
| 15 | `argocd_redis_request_total` | counter | Redis requests during reconciliation |

**Labels used**: `name`, `namespace`, `project`, `dest_server`, `health_status`, `sync_status`, `phase`.

---

## 2. Seven Platform Dashboards

| Dashboard | Purpose | Key Metrics |
|-----------|---------|-------------|
| **Deployment Timeline** | Commit → pipeline → Argo sync → promotion | `argocd_app_sync_total`, `argocd_app_reconcile`, `argocd_app_sync_duration_seconds_total` |
| **Pipeline Health** | CI/CD success rate, lead time, queue depth | `argocd_app_sync_total` (by phase), `argocd_app_reconcile` |
| **GitOps Integrity** | Drift, manual sync, bypass detection | `argocd_app_info`, `argocd_app_condition`, `argocd_app_orphaned_resources_count` |
| **Cluster Health** | Pod restarts, node readiness, post-deploy impact | `argocd_cluster_connection_status`, `argocd_cluster_cache_age_seconds`, `argocd_cluster_events_total` |
| **Promotion Governance** | Promotion path, approval state, stuck promotions | `argocd_app_info`, `argocd_app_sync_total`, `argocd_app_condition` |
| **Supply Chain / Artifact Lineage** | Image digest, SBOM, attestation | Placeholder for supply chain metrics; integrates with external sources |
| **Executive Compliance / Audit** | Audit trail, control evidence | `argocd_app_sync_total`, `argocd_app_reconcile`, `argocd_cluster_events_total` |

---

## 3. Dashboard Details

### 3.1 Deployment Timeline

- **Rows**: Sync events over time, reconciliation duration, phase distribution
- **Panels**: Time series of `argocd_app_sync_total`, `argocd_app_sync_duration_seconds_total`; table of recent syncs by app
- **Filters**: `name`, `namespace`, `project`, `cluster`

### 3.2 Pipeline Health

- **Rows**: Success rate (Succeeded vs Failed/Error), lead time (reconcile histogram), queue depth
- **Panels**: Rate of `argocd_app_sync_total` by `phase`; `argocd_app_reconcile` percentiles
- **Filters**: `project`, `dest_server`

### 3.3 GitOps Integrity

- **Rows**: Drift detection, orphaned resources, manual sync indicators
- **Panels**: `argocd_app_info` (sync_status != Synced); `argocd_app_orphaned_resources_count`; `argocd_app_condition`
- **Filters**: `name`, `namespace`, `project`

### 3.4 Cluster Health

- **Rows**: Cluster connection, cache freshness, event throughput
- **Panels**: `argocd_cluster_connection_status`; `argocd_cluster_cache_age_seconds`; `argocd_cluster_events_total` rate
- **Filters**: `dest_server`, `cluster`

### 3.5 Promotion Governance

- **Rows**: Promotion path, approval state, stuck promotions
- **Panels**: `argocd_app_info` by environment; `argocd_app_sync_total` by phase; apps with `argocd_app_condition` (e.g., stuck)
- **Filters**: `project`, `dest_server`, `environment` (if labeled)

### 3.6 Supply Chain / Artifact Lineage

- **Rows**: Image digest, SBOM, attestation status
- **Panels**: Placeholder for Cosign, Grype, or other supply chain metrics; requires integration with external systems
- **Note**: Argo CD metrics do not include image digest; this dashboard integrates with image registry or scanning tools

### 3.7 Executive Compliance / Audit

- **Rows**: Audit trail, control evidence
- **Panels**: `argocd_app_sync_total` (audit of sync events); `argocd_app_reconcile` (performance evidence); `argocd_cluster_events_total` (event volume)
- **Filters**: `project`, `name`, time range

---

## 4. Provisioning

- **Location**: `dashboards/deployment-intelligence/*.json`
- **Grafana provisioning**: Configure datasource and dashboard provider to read from this path
- **GitOps**: Argo CD or Flux syncs the repo; dashboards are provisioned on Grafana startup or reload

---

## 5. Compliance Mapping

| Control | Dashboard | Evidence |
|---------|-----------|----------|
| NIST SP 800-137 | All | Continuous monitoring of deployment state |
| AU-2 | Executive Compliance / Audit | Sync events as auditable events |
| AU-6 | Executive Compliance / Audit | Audit review via dashboard |
| SI-4 | Cluster Health, GitOps Integrity | System monitoring |
| CA-7 | All | Continuous monitoring evidence |

**Language**: These dashboards **support** and **align with** control requirements; they enable evidence collection. They do not **satisfy** or **certify** compliance.

---

## 6. Assumptions

- Argo CD Application Controller metrics are scraped by Prometheus/Alloy
- Grafana datasource is configured for Prometheus
- Cluster placeholder (`prod-cluster-1`, etc.) is used in filters; replace with actual cluster names as needed
- Supply Chain dashboard requires external integrations for SBOM/attestation
