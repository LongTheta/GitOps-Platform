# Easy Button Architecture Overview

High-level architecture for the Observability Easy Button framework.

## As of March 2026

Compatible with Grafana 11.x, Grafana Alloy, Prometheus 2.x, Argo CD 2.x.

---

## Conceptual Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        APPLICATION TEAM                                     │
│  Provides: onboarding config (YAML/JSON) + optional dashboard request       │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                     EASY BUTTON FRAMEWORK                                    │
│  • Validates config against schema                                           │
│  • Generates scrape configs, dashboards, alerts                              │
│  • Applies consistent labels                                                 │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                    ┌─────────────────┼─────────────────┐
                    ▼                 ▼                 ▼
┌──────────────────────┐ ┌──────────────────────┐ ┌──────────────────────┐
│  Grafana Alloy /      │ │  Grafana             │ │  Alertmanager /       │
│  Prometheus           │ │  Dashboards           │ │  Notification         │
│  • Scrape targets     │ │  • Provisioned from   │ │  • Rules from         │
│  • Service discovery  │ │    Git                │ │    templates          │
└──────────────────────┘ └──────────────────────┘ └──────────────────────┘
                    │                 │                 │
                    └─────────────────┼─────────────────┘
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                     GITOPS (Argo CD / Flux)                                  │
│  Git as source of truth; declarative sync; audit trail                       │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Components

| Component | Responsibility |
|-----------|----------------|
| **Onboarding config** | Minimal YAML/JSON from app teams; validated against `onboarding-schema.json` |
| **Schema validator** | Ensures config conforms before generation |
| **Generator** | Produces Alloy config, dashboard JSON, alert rules from templates |
| **Templates** | Reusable dashboard and alert templates with parameter substitution |
| **Provisioning** | Grafana reads dashboards from `dashboards/`; Alloy reads scrape configs from generated files |
| **GitOps controller** | Argo CD or Flux syncs config from Git to cluster |

## Label Structure

All generated configs use a consistent label set:

| Label | Source | Example |
|-------|--------|---------|
| `app` | From `application.name` | `my-app` |
| `namespace` | From `application.namespace` | `my-namespace` |
| `team` | From `application.team` | `platform-team` |
| `environment` | From `application.environment` | `prod` |
| `cluster` | Placeholder or discovery | `prod-cluster-1` |

**Assumption**: Scrape configs and dashboards use these labels for filtering and grouping.

## Data Flow

1. **Input**: Team commits onboarding config to `configs/` or `dashboard-requests/`
2. **Validation**: CI or manual validation against schema
3. **Generation**: Generator produces Alloy config, dashboard JSON, alert YAML
4. **Review**: MR/PR review; no direct edits to generated files without updating templates
5. **Deploy**: GitOps syncs to cluster; Grafana/Alloy pick up changes

## Integration Points

| System | Integration |
|--------|-------------|
| **CI/CD** | Pipeline validates schema, optionally runs generator |
| **Argo CD** | Syncs dashboard JSON, Alloy config, alert rules |
| **Grafana** | Provisioning from `dashboards/`; datasource from Prometheus/Alloy |
| **Prometheus/Alloy** | Scrapes targets; labels flow to Grafana |

## Assumptions

- Prometheus scrape configs are managed by Grafana Alloy (or equivalent)
- Grafana provisioning is configured to read dashboards from a Git-backed path
- Argo CD (or Flux) manages deployment of observability config
- Application services expose `/metrics` (or configurable path) in Prometheus format
- Logs are collected via Alloy/Loki or equivalent; format is configurable
