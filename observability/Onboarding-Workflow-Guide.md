# Onboarding Workflow Guide

Step-by-step guide for onboarding applications to the Observability Easy Button framework.

## As of March 2026

---

## Overview

The onboarding workflow has five stages:

1. **Request** — Create configuration or dashboard request
2. **Validate** — Ensure schema compliance
3. **Generate** — Produce artifacts from templates
4. **Review** — MR/PR review
5. **Deploy** — GitOps sync

---

## Stage 1: Request

### Option A: Full Application Onboarding

Create an onboarding configuration file. Use the template in `schemas/` or copy from `dashboard-requests/templates/dashboard-request-template.yaml` for structure reference.

**Location**: `configs/onboarding/<app-name>.yaml` or equivalent per your repo layout.

**Example**:

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
    team: platform-team
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

### Option B: Dashboard Request Only

If the app is already onboarded and you only need a new dashboard:

**Location**: `dashboard-requests/<name>.yaml`

**Example**:

```yaml
application: my-app
namespace: my-namespace
template: service-overview
panels: []
```

### Option C: MR Template

Some workflows use a Merge Request template with structured fields. Those fields are parsed and normalized into a dashboard request before generation.

### Option D: IDE / AI

Natural language requests can be converted to a normalized spec (e.g., via AI) and then passed to the generator. See [AI-Generation-Standards.md](docs/AI-Generation-Standards.md).

---

## Stage 2: Validate

Validate the configuration against the schema:

```bash
# Using a JSON schema validator (example with Python)
python -c "
import json
import jsonschema
with open('schemas/onboarding-schema.json') as f:
    schema = json.load(f)
with open('configs/onboarding/my-app.yaml') as f:
    import yaml
    config = yaml.safe_load(f)
jsonschema.validate(config, schema)
print('Valid')
"
```

For dashboard requests:

```bash
python generators/generate-dashboard-from-request.py --validate dashboard-requests/my-app-overview.yaml
```

**CI integration**: Add validation as a pipeline step before merge.

---

## Stage 3: Generate

Run the generator:

```bash
# Full onboarding
python generators/generate-dashboard-from-request.py configs/onboarding/my-app.yaml

# Dashboard request only
python generators/generate-dashboard-from-request.py dashboard-requests/my-app-overview.yaml
```

**Output**:

- `dashboards/generated/my-app-service-overview.json`
- Optional: Alloy config, alert rules (if generator supports)

---

## Stage 4: Review

1. Open an MR/PR with the onboarding config and generated artifacts
2. Reviewers verify:
   - Config matches schema
   - Generated dashboard uses correct labels
   - No hardcoded values that should be parameterized
3. Approve and merge

---

## Stage 5: Deploy

1. GitOps controller (Argo CD / Flux) detects the merge
2. Syncs dashboard JSON to Grafana (via provisioning)
3. Syncs Alloy config if applicable
4. Dashboards and metrics become available

---

## Checklist

- [ ] Onboarding config or dashboard request created
- [ ] Schema validation passes
- [ ] Generator produces expected artifacts
- [ ] MR/PR opened and reviewed
- [ ] Merged; GitOps sync confirmed

---

## Troubleshooting

| Issue | Action |
|-------|--------|
| Schema validation fails | Check required fields; compare to `onboarding-schema.json` |
| Generator produces empty dashboard | Verify template exists; check template placeholders |
| Dashboard not appearing in Grafana | Verify provisioning path; check Grafana logs |
| Metrics not scraping | Verify Alloy config; check service discovery and port |
