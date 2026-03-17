#!/usr/bin/env bash
# promote.sh - Promotion workflow helper (placeholder)
# Actual promotion is managed by GitOps Promoter.
# This script documents the flow and can trigger checks.
# As of March 2026

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

usage() {
  echo "Usage: $0 [check|dry-run|<from> <to>]"
  echo ""
  echo "  check         - Verify promotion config (PromotionStrategy, branches)"
  echo "  dry-run       - Dry-run kustomize for target env (requires ENV=dev|stage|prod)"
  echo "  <from> <to>   - Simulate promotion (e.g. dev stage, stage prod)"
  echo ""
  echo "Promotion is managed by GitOps Promoter. See gitops-promoter/config/"
  exit 1
}

cmd="${1:-}"
case "$cmd" in
  dev|stage|prod)
    FROM="$cmd"
    TO="${2:-}"
    if [ -z "$TO" ] || [[ ! "$TO" =~ ^(dev|stage|prod)$ ]]; then
      echo "Usage: $0 $FROM <to>   (to = dev|stage|prod)"
      exit 1
    fi
    echo "==> Simulating promotion: $FROM → $TO"
    # Run policy check; promotion blocks on failure
    if ! "$SCRIPT_DIR/policy-check.sh" >/dev/null 2>&1; then
      echo ""
      echo "❌ Promotion Blocked"
      echo "Reason:"
      echo "- Policy failure"
      echo "- Approval missing"
      echo ""
      echo "Fix policy violations, obtain approval, then retry."
      exit 1
    fi
    # Prod requires manual approval
    if [ "$TO" = "prod" ]; then
      echo ""
      echo "❌ Promotion Blocked"
      echo "Reason:"
      echo "- Approval missing (production requires manual approval)"
      echo ""
      exit 1
    fi
    echo "  OK: Promotion path $FROM → $TO validated"
    if command -v kustomize >/dev/null 2>&1; then
      kustomize build "platform/environments/$TO" >/dev/null 2>&1 && echo "  OK: Kustomize build succeeds for $TO" || true
    fi
    ;;
  check)
    echo "==> Checking promotion configuration..."
    if [ -f "gitops-promoter/config/promotion-strategy.yaml" ]; then
      echo "  OK: promotion-strategy.yaml exists"
      grep -q "autoMerge: false" gitops-promoter/config/promotion-strategy.yaml && \
        echo "  OK: Production has autoMerge: false (manual approval)" || \
        echo "  WARN: Production may not require manual approval"
    else
      echo "  ERROR: promotion-strategy.yaml not found"
      exit 1
    fi
    ;;
  dry-run)
    ENV="${ENV:-}"
    if [ -z "$ENV" ] || [[ ! "$ENV" =~ ^(dev|stage|prod)$ ]]; then
      echo "ERROR: Set ENV=dev|stage|prod for dry-run"
      exit 1
    fi
    echo "==> Dry-run kustomize for $ENV..."
    if command -v kustomize >/dev/null 2>&1; then
      kustomize build "platform/environments/$ENV"
    elif command -v kubectl >/dev/null 2>&1; then
      kubectl kustomize "platform/environments/$ENV"
    else
      echo "ERROR: kustomize or kubectl required"
      exit 1
    fi
    ;;
  *)
    usage
    ;;
esac
