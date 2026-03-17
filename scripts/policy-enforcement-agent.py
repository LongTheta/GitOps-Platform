#!/usr/bin/env python3
"""
AI DevSecOps Policy Enforcement Agent

Validates platform manifests against policy packs (org-baseline, promotion-policy).
Run locally or in CI. Outputs pass/fail with remediation suggestions.

Usage:
  python scripts/policy-enforcement-agent.py
  python scripts/policy-enforcement-agent.py --path platform/apps/example-app

As of March 2026.
"""

import argparse
import os
import sys
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description="Policy enforcement agent")
    parser.add_argument("--path", default="platform", help="Path to validate")
    parser.add_argument("--strict", action="store_true", help="Treat warnings as errors")
    args = parser.parse_args()

    repo_root = Path(__file__).resolve().parent.parent
    os.chdir(repo_root)

    errors = []
    warnings = []

    apps_path = Path(args.path) / "apps" if (Path(args.path) / "apps").exists() else Path(args.path)
    if not apps_path.exists():
        apps_path = Path("platform/apps")

    print("==> AI DevSecOps Policy Enforcement Agent")
    print(f"    Path: {apps_path}")
    print()

    # Rule: no :latest in prod
    print("==> Rule: no-latest-in-prod (production must use digest)")
    for prod_file in repo_root.glob("platform/apps/*/overlays/prod/kustomization.yaml"):
        content = prod_file.read_text(errors="replace")
        if ":latest" in content:
            errors.append(f"  ERROR: {prod_file} contains :latest")
            print(f"  ERROR: {prod_file} contains :latest")
            print("    Remediation: Use image digest, e.g. image@sha256:...")
        else:
            print(f"  OK: {prod_file}")

    # Rule: resource limits
    print()
    print("==> Rule: resource-limits (all containers must have limits)")
    for deploy in repo_root.glob("platform/apps/*/base/deployment.yaml"):
        content = deploy.read_text(errors="replace")
        if "limits:" not in content:
            errors.append(f"  ERROR: {deploy} missing resource limits")
            print(f"  ERROR: {deploy} missing resource limits")
            print("    Remediation: Add resources.limits to each container")
        elif "requests:" not in content:
            warnings.append(f"  WARN: {deploy} missing resource requests")
            print(f"  WARN: {deploy} missing resource requests")
        else:
            print(f"  OK: {deploy}")

    # Rule: required labels
    print()
    print("==> Rule: required-labels (app label required)")
    for deploy in repo_root.glob("platform/apps/*/base/deployment.yaml"):
        content = deploy.read_text(errors="replace")
        if "app:" not in content:
            errors.append(f"  ERROR: {deploy} missing app label")
            print(f"  ERROR: {deploy} missing app label")
        else:
            print(f"  OK: {deploy}")

    # Summary
    print()
    if errors:
        print(f"Policy enforcement FAILED: {len(errors)} error(s)")
        if args.strict and warnings:
            print(f"Warnings (strict mode): {len(warnings)}")
        sys.exit(1)
    elif warnings and args.strict:
        print(f"Policy enforcement FAILED (strict): {len(warnings)} warning(s)")
        sys.exit(1)
    else:
        print("Policy enforcement PASSED")
        if warnings:
            print(f"  ({len(warnings)} warning(s) - use --strict to fail on warnings)")
        sys.exit(0)


if __name__ == "__main__":
    main()
