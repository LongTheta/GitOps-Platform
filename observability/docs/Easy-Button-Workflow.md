# Easy Button Workflow

End-to-end workflow for the Observability Easy Button framework.

## As of March 2026

---

## Flow Diagram

```
Request → Validate → Generate → Review → Deploy
   │          │          │          │         │
   │          │          │          │         └─ GitOps syncs to cluster
   │          │          │          └─ MR/PR review
   │          │          └─ Generator produces dashboard JSON
   │          └─ Schema validation
   └─ Config or dashboard request (YAML)
```

---

## Request Channels

| Channel | Input | Normalization |
|---------|-------|---------------|
| Repo request file | `dashboard-requests/<name>.yaml` | Conforms to schema |
| MR template | Structured fields in MR | Parsed into request YAML |
| IDE / AI | Natural language | AI normalizes to schema |

---

## Validate

- **Onboarding config**: Validate against `schemas/onboarding-schema.json`
- **Dashboard request**: Validate against `dashboard-request.schema.json`
- **CI**: Add validation step to pipeline before merge

---

## Generate

- **Tool**: `generators/generate-dashboard-from-request.py`
- **Input**: Valid config or request
- **Output**: `dashboards/generated/<app>-<template>.json`
- **Templates**: `dashboards/templates/<template>.json`

---

## Review

- Open MR with config + generated artifacts
- Reviewers check: schema compliance, label correctness, no hardcoded values
- Merge to main

---

## Deploy

- GitOps controller (Argo CD / Flux) syncs repo
- Grafana provisioning reads `dashboards/` path
- Dashboards appear in Grafana

---

## Incremental and Auditable

- Each change is a Git commit
- History provides audit trail
- No manual provisioning; all changes flow through Git
