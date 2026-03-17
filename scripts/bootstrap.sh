#!/usr/bin/env bash
# bootstrap.sh - Bootstrap platform components (placeholder)
# Run after cloning repo to validate and prepare local environment.
# As of March 2026

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

echo "==> GitOps Platform Bootstrap"
echo ""

# Check prerequisites
echo "Checking prerequisites..."
command -v kubectl >/dev/null 2>&1 || { echo "kubectl not found"; exit 1; }
command -v kustomize >/dev/null 2>&1 || { echo "kustomize not found (install or use kubectl kustomize)"; exit 1; }
echo "  OK: kubectl, kustomize"
echo ""

# Run validation
echo "Running validation..."
"$SCRIPT_DIR/validate.sh" || exit 1
"$SCRIPT_DIR/policy-check.sh" || exit 1
echo ""

# Summary
echo "Bootstrap complete. Next steps:"
echo "  1. Configure Argo CD (see manifest-hydrator/, gitops-promoter/)"
echo "  2. Apply platform/argo/ and platform/policies/"
echo "  3. Deploy observability (see observability/README.md)"
echo "  4. Onboard apps (see docs/SELF-SERVICE.md)"
echo ""
