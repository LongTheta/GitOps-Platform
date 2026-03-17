# Deployment Monitoring (Observability)

Deployment traceability, Grafana dashboards, and the Easy Button framework for application observability onboarding. Supports NIST SP 800-137, AU-2, AU-6, SI-4, CA-7.

## Overview

Provides visibility into the GitOps platform:
- **Deployment Timeline** — Commit → pipeline → Argo sync → promotion
- **Pipeline Health** — CI/CD success rate, lead time
- **GitOps Integrity** — Drift, manual sync, bypass detection
- **Cluster Health** — Pod restarts, node readiness
- **Promotion Governance** — Promotion path, approval state
- **Supply Chain / Artifact Lineage** — Image digest, SBOM
- **Executive Compliance / Audit** — Audit trail, control evidence

## Easy Button Framework

Application teams provide a simple config; platform handles telemetry, dashboards, alerts.

```yaml
apiVersion: observability.platform.io/v1
kind: ObservabilityOnboarding
spec:
  application:
    name: my-app
    namespace: my-namespace
    service: my-app-service
    team: platform-team
    environment: prod
  metrics:
    enabled: true
    path: /metrics
    port: 8080
  dashboards:
    enabled: true
    template_set: service-overview
```

## Structure

```
observability/
├── README.md
├── dashboards/           # Deployment Intelligence + generated + templates
├── dashboard-requests/   # Request schema, templates, examples
├── generators/           # generate-dashboard-from-request.py
├── schemas/              # onboarding-schema.json
├── docs/                 # Easy-Button-Workflow, AI-Generation-Standards, Compliance-Mapping
├── Easy-Button-Architecture-Overview.md
├── Easy-Button-Framework-Design.md
├── Onboarding-Workflow-Guide.md
├── Application-Observability-Onboarding-Guide.md
├── Observability-Onboarding-Contract.md
└── GitOps-Deployment-Intelligence-Platform-Design.md
```

## Quick Start

```bash
# Generate dashboard from request
python generators/generate-dashboard-from-request.py dashboard-requests/example-app-overview.yaml
```

## Requirements (TR-DM)

| ID | Requirement |
|----|-------------|
| TR-DM-1 | Deployment traceability (GitLab → Argo CD → environment) |
| TR-DM-2 | Promotion history visibility |
| TR-DM-3 | Pipeline approval and artifact lineage visibility |
| TR-DM-4 | Grafana + Argo pipeline visibility for NIST SP 800-137 |
| TR-DM-5 | AU-2, AU-6, AU-12, SI-4 audit and monitoring |
