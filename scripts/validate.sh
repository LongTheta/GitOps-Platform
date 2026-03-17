#!/usr/bin/env bash
# validate.sh - Validate platform manifests and structure
# Run in CI or locally before merge
# As of March 2026

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

ERRORS=0

echo "==> Validating platform structure..."
if [ ! -d "platform" ]; then
  echo "ERROR: platform/ directory missing"
  ERRORS=$((ERRORS + 1))
fi

if [ ! -d "platform/environments" ]; then
  echo "ERROR: platform/environments/ missing"
  ERRORS=$((ERRORS + 1))
fi

if [ ! -d "platform/apps" ]; then
  echo "ERROR: platform/apps/ missing"
  ERRORS=$((ERRORS + 1))
fi

# Prefer kustomize, fallback to kubectl kustomize
KUSTOMIZE_CMD=""
if command -v kustomize >/dev/null 2>&1; then
  KUSTOMIZE_CMD="kustomize build"
elif command -v kubectl >/dev/null 2>&1; then
  KUSTOMIZE_CMD="kubectl kustomize"
fi

echo "==> Validating kustomize builds..."
if [ -z "$KUSTOMIZE_CMD" ]; then
  echo "  SKIP: kustomize/kubectl not found"
else
  for env in dev stage prod; do
    if [ -d "platform/environments/$env" ]; then
      if eval "$KUSTOMIZE_CMD platform/environments/$env" > /dev/null 2>&1; then
        echo "  OK: platform/environments/$env"
      else
        echo "  ERROR: platform/environments/$env kustomize build failed"
        ERRORS=$((ERRORS + 1))
      fi
    fi
  done

  for app_dir in platform/apps/*/; do
    if [ -d "$app_dir" ]; then
      app=$(basename "$app_dir")
      for overlay in dev stage prod; do
        if [ -d "$app_dir/overlays/$overlay" ]; then
          if eval "$KUSTOMIZE_CMD $app_dir/overlays/$overlay" > /dev/null 2>&1; then
            echo "  OK: platform/apps/$app/overlays/$overlay"
          else
            echo "  ERROR: platform/apps/$app/overlays/$overlay kustomize build failed"
            ERRORS=$((ERRORS + 1))
          fi
        fi
      done
    fi
  done
fi

echo "==> Policy placeholder check..."
if [ ! -d "platform/policies" ]; then
  echo "  WARN: platform/policies/ missing"
fi

if [ $ERRORS -gt 0 ]; then
  echo ""
  echo "Validation failed with $ERRORS error(s)"
  exit 1
fi

echo ""
echo "Validation passed"
