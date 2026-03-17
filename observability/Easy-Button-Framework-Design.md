# Easy Button Framework Design

Detailed design for the Observability Easy Button framework.

## As of March 2026

---

## 1. Input Contract

### 1.1 Onboarding Configuration

Teams provide a single file conforming to `schemas/onboarding-schema.json`:

```yaml
apiVersion: observability.platform.io/v1
kind: ObservabilityOnboarding
metadata:
  name: <app-name>
  namespace: <app-namespace>
spec:
  application:
    name: string
    namespace: string
    service: string
    team: string
    environment: string  # e.g., dev, staging, prod
  metrics:
    enabled: boolean
    path: string        # default: /metrics
    port: integer
  logs:
    enabled: boolean
    format: string      # e.g., json, logfmt
  dashboards:
    enabled: boolean
    template_set: string  # e.g., service-overview, golden-signals
  alerts:
    enabled: boolean
    notification_channels: array
```

**API version**: `observability.platform.io/v1` — generic, no organization-specific domain.

### 1.2 Dashboard Request (Optional)

For custom dashboards, teams provide `dashboard-requests/<name>.yaml` conforming to `dashboard-request.schema.json`:

- `application`, `namespace`, `template`, `panels` (optional overrides)

---

## 2. Output Artifacts

| Artifact | Location | Format |
|----------|----------|--------|
| Alloy scrape config | `configs/alloy/<app>-scrape.yaml` | Alloy/Prometheus config |
| Dashboard JSON | `dashboards/generated/<app>-<template>.json` | Grafana dashboard JSON |
| Alert rules | `alerts/<app>-alerts.yaml` | Prometheus alert rules |

---

## 3. Template System

### 3.1 Dashboard Templates

Templates live in `dashboards/templates/`:

- `service-overview` — Request rate, error rate, latency, saturation
- `golden-signals` — RED (rate, errors, duration) or USE (utilization, saturation, errors)

Templates use placeholders:

- `{{.application}}`, `{{.namespace}}`, `{{.team}}`, `{{.environment}}`
- `{{.metrics_path}}`, `{{.metrics_port}}`

### 3.2 Alert Templates

Alert templates define:

- Condition (e.g., error rate > threshold)
- Labels (app, namespace, team, severity)
- Annotations (summary, runbook link)

Teams specify `notification_channels`; platform maps to Alertmanager config.

---

## 4. Scrape Configuration Generation

**Source**: Prometheus scrape config documentation; Alloy compatibility.

Generated Alloy config snippet (conceptual):

```yaml
prometheus.scrape "my_app" {
  targets = discovery.kubernetes.pods.targets
  forward_to = [prometheus.remote_write.receiver]
  scrape_interval = "30s"
  metrics_path = "/metrics"
  relabel_configs = [
    { source_labels = ["__meta_kubernetes_pod_label_app"]; target_label = "app"; regex = "my-app" }
    # ... consistent labels
  ]
}
```

**Assumption**: Service discovery uses Kubernetes pod labels or static config; exact syntax depends on Alloy version.

---

## 5. Label Consistency

All outputs use:

| Label | Required | Description |
|-------|----------|-------------|
| `app` | Yes | Application name |
| `namespace` | Yes | Kubernetes namespace |
| `team` | Yes | Owning team |
| `environment` | Yes | dev, staging, prod |
| `cluster` | Optional | Cluster identifier (e.g., prod-cluster-1) |

Dashboards filter by these labels; alerts include them for routing.

---

## 6. Workflow

1. **Request** — Team creates onboarding config or dashboard request
2. **Validate** — Schema validation (CI or manual)
3. **Generate** — Generator produces artifacts from templates
4. **Review** — MR/PR; human review of generated output
5. **Deploy** — GitOps syncs to cluster

---

## 7. Risks and Mitigations

| Risk | Mitigation |
|------|-------------|
| Template drift | Version templates; document changes |
| Schema evolution | Use versioned schema; support multiple API versions |
| Over-generation | Limit template sets; document what each produces |
| Misconfigured scrape | Validate port/path; test in staging first |

---

## 8. Compliance Impact

This design **supports** continuous monitoring (NIST SP 800-137) by:

- Providing consistent telemetry collection
- Enabling audit trail via Git
- Aligning with SI-4 (system monitoring) evidence needs

It does **not** satisfy controls by itself; evidence collection and assessment are separate processes.
