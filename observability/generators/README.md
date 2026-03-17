# Dashboard Generators

Tools for generating Grafana dashboards from onboarding configs or dashboard requests.

## generate-dashboard-from-request.py

Generates Grafana dashboard JSON from:
- An onboarding config (`ObservabilityOnboarding` YAML)
- A dashboard request YAML

### Usage

```bash
# From dashboard request (run from observability/ or use full path)
python generate-dashboard-from-request.py dashboard-requests/example-app-overview.yaml

# From project root
python observability/generators/generate-dashboard-from-request.py observability/dashboard-requests/example-app-overview.yaml

# From onboarding config (extracts dashboard section)
python generate-dashboard-from-request.py configs/onboarding/my-app.yaml

# Validate only (no generation)
python generate-dashboard-from-request.py --validate dashboard-requests/example-app-overview.yaml

# Custom output path
python generate-dashboard-from-request.py dashboard-requests/example-app-overview.yaml -o dashboards/generated/custom.json
```

### Output

- Default: `dashboards/generated/<application>-<template>.json`
- Uses templates from `dashboards/templates/<template>.json`
- Falls back to minimal template if template file does not exist

### Dependencies

- Python 3.7+
- PyYAML: `pip install pyyaml`

### Workflow

1. Request → Validate (schema) → Generate (from template) → Review (MR) → Deploy (GitOps)
