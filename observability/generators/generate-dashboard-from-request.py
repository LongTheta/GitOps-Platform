#!/usr/bin/env python3
"""
Generate Grafana dashboard JSON from an onboarding config or dashboard request.

Usage:
  python generate-dashboard-from-request.py <config-or-request.yaml>
  python generate-dashboard-from-request.py --validate <request.yaml>

Output: dashboards/generated/<app>-<template>.json

As of March 2026. Compatible with Grafana 11.x dashboard format.
"""

import argparse
import json
import os
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    print("Error: PyYAML required. Install with: pip install pyyaml")
    sys.exit(1)

# Resolve paths relative to repo root (parent of generators/)
REPO_ROOT = Path(__file__).resolve().parent.parent
SCHEMA_PATH = REPO_ROOT / "schemas" / "onboarding-schema.json"
DASHBOARD_REQUEST_SCHEMA = REPO_ROOT / "dashboard-requests" / "schemas" / "dashboard-request.schema.json"
TEMPLATES_DIR = REPO_ROOT / "dashboards" / "templates"
OUTPUT_DIR = REPO_ROOT / "dashboards" / "generated"


def load_yaml(path: Path) -> dict:
    """Load YAML file."""
    with open(path, encoding="utf-8") as f:
        return yaml.safe_load(f)


def load_json(path: Path) -> dict:
    """Load JSON file."""
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def extract_request_from_config(config: dict) -> dict:
    """Extract dashboard request fields from onboarding config."""
    spec = config.get("spec", {})
    app = spec.get("application", {})
    dashboards = spec.get("dashboards", {})
    return {
        "application": app.get("name"),
        "namespace": app.get("namespace"),
        "template": dashboards.get("template_set", "service-overview"),
        "panels": [],
        "team": app.get("team"),
        "environment": app.get("environment"),
    }


def load_template(template_name: str) -> dict:
    """Load dashboard template JSON. Falls back to minimal template if not found."""
    template_path = TEMPLATES_DIR / f"{template_name}.json"
    if template_path.exists():
        return load_json(template_path)
    # Minimal Grafana dashboard template
    return {
        "annotations": {"list": []},
        "editable": True,
        "fiscalYearStartMonth": 0,
        "graphTooltip": 0,
        "id": None,
        "links": [],
        "liveNow": False,
        "panels": [],
        "refresh": "30s",
        "schemaVersion": 38,
        "style": "dark",
        "tags": [],
        "templating": {"list": []},
        "time": {"from": "now-1h", "to": "now"},
        "timepicker": {},
        "timezone": "",
        "title": "{{.application}} - {{.template}}",
        "uid": "{{.application}}-{{.template}}",
        "version": 1,
    }


def apply_placeholders(obj, context: dict):
    """Recursively replace {{.key}} placeholders in strings."""
    if isinstance(obj, dict):
        return {k: apply_placeholders(v, context) for k, v in obj.items()}
    if isinstance(obj, list):
        return [apply_placeholders(v, context) for v in obj]
    if isinstance(obj, str):
        for key, val in context.items():
            obj = obj.replace("{{." + key + "}}", str(val))
        return obj
    return obj


def generate_dashboard(request: dict) -> dict:
    """Generate dashboard JSON from request."""
    template = load_template(request["template"])
    context = {
        "application": request["application"],
        "namespace": request["namespace"],
        "template": request["template"],
        "team": request.get("team", "unknown"),
        "environment": request.get("environment", "prod"),
    }
    dashboard = apply_placeholders(template, context)
    dashboard["title"] = f"{request['application']} - {request['template']}"
    dashboard["uid"] = f"{request['application']}-{request['template']}".replace("_", "-")
    if request.get("panels"):
        dashboard["panels"] = request["panels"]
    return dashboard


def validate_request(request: dict) -> bool:
    """Basic validation of request fields."""
    if not request.get("application"):
        print("Error: 'application' is required")
        return False
    if not request.get("namespace"):
        print("Error: 'namespace' is required")
        return False
    if not request.get("template"):
        print("Error: 'template' is required")
        return False
    if request.get("template") not in ("service-overview", "golden-signals"):
        print("Error: 'template' must be 'service-overview' or 'golden-signals'")
        return False
    return True


def main():
    parser = argparse.ArgumentParser(description="Generate dashboard from onboarding config or request")
    parser.add_argument("input", nargs="?", help="Path to YAML config or dashboard request")
    parser.add_argument("--validate", action="store_true", help="Only validate; do not generate")
    parser.add_argument("-o", "--output", help="Output path (default: dashboards/generated/<app>-<template>.json)")
    args = parser.parse_args()

    if not args.input:
        parser.print_help()
        sys.exit(1)

    input_path = Path(args.input)
    if not input_path.exists():
        print(f"Error: File not found: {input_path}")
        sys.exit(1)

    config = load_yaml(input_path)

    # Determine if onboarding config or dashboard request
    if config.get("kind") == "ObservabilityOnboarding":
        request = extract_request_from_config(config)
    else:
        request = config

    if not validate_request(request):
        sys.exit(1)

    if args.validate:
        print("Validation passed.")
        sys.exit(0)

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    dashboard = generate_dashboard(request)
    output_path = Path(args.output) if args.output else OUTPUT_DIR / f"{request['application']}-{request['template']}.json"
    output_path.parent.mkdir(parents=True, exist_ok=True)

    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(dashboard, f, indent=2)

    print(f"Generated: {output_path}")


if __name__ == "__main__":
    main()
