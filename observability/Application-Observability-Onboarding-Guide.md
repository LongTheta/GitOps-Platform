# Application Observability Onboarding Guide

Guide for application teams onboarding to the Observability Easy Button framework.

## As of March 2026

---

## Who This Is For

Application developers and SREs who want to add observability (metrics, dashboards, alerts) to their services without learning Prometheus, Alloy, or Grafana internals.

---

## What You Need to Provide

| Field | Description | Example |
|-------|-------------|---------|
| `application.name` | Your app name | `my-app` |
| `application.namespace` | Kubernetes namespace | `my-namespace` |
| `application.service` | Service name (for discovery) | `my-app-service` |
| `application.team` | Your team identifier | `platform-team` |
| `application.environment` | Environment | `dev`, `staging`, or `prod` |
| `metrics.path` | Metrics endpoint path | `/metrics` |
| `metrics.port` | Port exposing metrics | `8080` |
| `logs.format` | Log format | `json` or `logfmt` |
| `dashboards.template_set` | Dashboard template | `service-overview` or `golden-signals` |

---

## What the Platform Provides

- **Scrape configuration** — Prometheus/Alloy will scrape your metrics endpoint
- **Dashboard** — Pre-built dashboard from templates
- **Alert rules** — Standard alerts (e.g., high error rate, latency)
- **Consistent labels** — All telemetry tagged with app, namespace, team, environment

---

## Prerequisites

1. **Metrics endpoint** — Your app exposes Prometheus-format metrics at a configurable path (default: `/metrics`)
2. **Port** — Metrics are reachable on the specified port (typically same as app port or a dedicated metrics port)
3. **Service in Kubernetes** — Service and pods exist; discovery uses standard labels

---

## Quick Start

### 1. Create Your Config

Copy the template and fill in your values:

```yaml
apiVersion: observability.platform.io/v1
kind: ObservabilityOnboarding
metadata:
  name: my-app
  namespace: my-namespace
spec:
  application:
    name: my-app
    namespace: my-namespace
    service: my-app-service
    team: my-team
    environment: prod
  metrics:
    enabled: true
    path: /metrics
    port: 8080
  logs:
    enabled: true
    format: json
  dashboards:
    enabled: true
    template_set: service-overview
  alerts:
    enabled: true
    notification_channels: []
```

### 2. Submit

- Commit to the observability repo (per your org's process), or
- Open an MR with the config, or
- Use the dashboard request workflow if you only need a dashboard

### 3. Wait for Sync

After merge, GitOps syncs the config. Dashboards and metrics typically appear within minutes.

---

## Template Sets

| Template | Description |
|----------|-------------|
| `service-overview` | Request rate, error rate, latency, saturation |
| `golden-signals` | RED (rate, errors, duration) or USE metrics |

Choose based on your app type (request-driven vs. resource-focused).

---

## Customization

- **Metrics path**: If your app uses a different path (e.g., `/v1/metrics`), set `metrics.path`
- **Log format**: Use `json` for structured logs; `logfmt` for logfmt
- **Notification channels**: Add channel names to `notification_channels` for alert routing

---

## FAQ

**Q: Do I need to run Prometheus or Alloy myself?**  
A: No. The platform manages scraping. You only expose the metrics endpoint.

**Q: Can I add custom panels?**  
A: Use the dashboard request workflow with optional `panels` overrides, or request a new template.

**Q: What if my app doesn't expose Prometheus metrics?**  
A: You'll need to add an exporter or instrument your app. The framework assumes Prometheus-format metrics.

**Q: How do I get alerts?**  
A: Set `alerts.enabled: true` and configure `notification_channels`. The platform generates standard alert rules from templates.
