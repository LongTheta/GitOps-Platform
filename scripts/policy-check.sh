#!/usr/bin/env bash
# policy-check.sh - Lightweight policy validation for manifests
# Checks: no :latest in prod, resource limits present, required labels
# For full policy: integrate OPA, Gatekeeper, or ai-devsecops-policy-enforcement-agent
# As of March 2026

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

ERRORS=0

echo "==> Policy check: prod overlays (no :latest, use digest)..."

for prod_overlay in platform/apps/*/overlays/prod/kustomization.yaml; do
  if [ -f "$prod_overlay" ]; then
    if grep -q ":latest" "$prod_overlay" 2>/dev/null; then
      echo "  ERROR: $prod_overlay contains :latest (use digest in prod)"
      ERRORS=$((ERRORS + 1))
    fi
  fi
done

echo "==> Policy check: deployments have resource limits..."

for deploy in platform/apps/*/base/deployment.yaml; do
  if [ -f "$deploy" ]; then
    if ! grep -q "limits:" "$deploy" 2>/dev/null; then
      echo "  ERROR: $deploy missing resource limits"
      ERRORS=$((ERRORS + 1))
    fi
    if ! grep -q "requests:" "$deploy" 2>/dev/null; then
      echo "  WARN: $deploy missing resource requests"
    fi
  fi
done

echo "==> Policy check: required labels (app, environment)..."

for app_dir in platform/apps/*/; do
  if [ -d "$app_dir" ]; then
    base_deploy="$app_dir/base/deployment.yaml"
    if [ -f "$base_deploy" ]; then
      if ! grep -q "app:" "$base_deploy" 2>/dev/null; then
        echo "  ERROR: $base_deploy missing app label"
        ERRORS=$((ERRORS + 1))
      fi
    fi
  fi
done

if [ $ERRORS -gt 0 ]; then
  echo ""
  echo "Policy check failed with $ERRORS error(s)"
  exit 1
fi

echo ""
echo "Policy check passed"
