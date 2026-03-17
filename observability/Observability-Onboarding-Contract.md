# Observability Onboarding Contract

Formal contract between application teams and the platform for observability onboarding.

## As of March 2026

---

## 1. Platform Obligations

The platform **shall**:

| Obligation | Description |
|------------|-------------|
| Accept valid config | Process any config conforming to `onboarding-schema.json` |
| Generate artifacts | Produce dashboard JSON, scrape config, alert rules from templates |
| Apply consistent labels | Use `app`, `namespace`, `team`, `environment` on all outputs |
| Provision via GitOps | Deploy dashboards and config through Git; no manual provisioning |
| Document templates | Provide template descriptions and parameter lists |

---

## 2. Application Team Obligations

Application teams **shall**:

| Obligation | Description |
|------------|-------------|
| Provide valid config | Submit a config that validates against the schema |
| Expose metrics endpoint | Serve Prometheus-format metrics at the specified path and port |
| Use standard labels | Ensure pods/services have labels compatible with discovery (e.g., `app`, `namespace`) |
| Not modify generated files | Request changes via config or template updates; do not edit generated JSON directly |

---

## 3. Schema Contract

The onboarding schema (`schemas/onboarding-schema.json`) defines:

- **Required fields**: `application.name`, `application.namespace`, `application.service`, `application.team`, `application.environment`
- **Optional fields**: `metrics.path` (default: `/metrics`), `logs.format`, `dashboards.template_set`, `alerts.notification_channels`
- **API version**: `observability.platform.io/v1`

Schema changes are versioned; backward compatibility is maintained where possible.

---

## 4. Label Contract

All telemetry (metrics, logs, dashboards) uses:

| Label | Type | Source |
|-------|------|--------|
| `app` | string | `application.name` |
| `namespace` | string | `application.namespace` |
| `team` | string | `application.team` |
| `environment` | string | `application.environment` |
| `cluster` | string | Platform-provided or placeholder |

---

## 5. Template Contract

- **Available templates**: `service-overview`, `golden-signals` (extensible)
- **Placeholders**: Templates support `{{.application}}`, `{{.namespace}}`, `{{.team}}`, `{{.environment}}`, `{{.metrics_path}}`, `{{.metrics_port}}`
- **Template changes**: Documented in release notes; breaking changes require schema version bump

---

## 6. Compliance Mapping

This contract **supports** evidence collection for:

- **NIST SP 800-137** — Continuous monitoring; consistent telemetry structure
- **AU-2** — Auditable events; Git history as audit trail
- **AU-6** — Audit review; dashboards enable review of deployment state
- **SI-4** — System monitoring; metrics and dashboards align with monitoring requirements
- **CA-7** — Continuous monitoring; framework enables ongoing assessment

**Note**: This contract does not satisfy controls; it enables evidence that assessors may use.

---

## 7. Out of Scope

- Custom panel layouts not covered by templates
- Non-Prometheus metrics formats
- Real-time alert routing beyond `notification_channels`
- Organization-specific integrations (e.g., ticketing, Slack)
