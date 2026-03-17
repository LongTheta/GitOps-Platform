#!/usr/bin/env bash
# demo-screenshot.sh - Run the platform demo flow for capturing platform-demo.png
# Output: Promotion workflow, policy enforcement, Argo CD sync (when cluster available)
# Save screenshot to docs/images/platform-demo.png
# As of March 2026

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

echo ""
echo "╔══════════════════════════════════════════════════════════════════════╗"
echo "║  GitOps Platform Demo — Promotion, Policy, Argo CD                  ║"
echo "╚══════════════════════════════════════════════════════════════════════╝"
echo ""

echo "━━━ 1. Policy Enforcement ━━━"
echo ""
"$SCRIPT_DIR/policy-check.sh" 2>&1 || true
echo ""

echo "━━━ 2. Promotion Workflow (dev → stage) ━━━"
echo ""
"$SCRIPT_DIR/promote.sh" dev stage 2>&1 || true
echo ""

echo "━━━ 3. Promotion Strategy (prod = manual approval) ━━━"
echo ""
if [ -f "gitops-promoter/config/promotion-strategy.yaml" ]; then
  cat gitops-promoter/config/promotion-strategy.yaml
else
  echo "  (promotion-strategy.yaml not found)"
fi
echo ""

echo "━━━ 4. Argo CD Sync ━━━"
echo ""
if command -v argocd >/dev/null 2>&1; then
  echo "  Argo CD CLI detected. Run: argocd app list"
  argocd app list 2>/dev/null || echo "  (No Argo CD server or cluster — deploy platform to see sync)"
else
  echo "  To capture Argo CD sync: deploy platform (kubectl apply -f platform/argo/)"
  echo "  then: argocd app list  or  open Argo CD UI"
fi
echo ""

echo "╔══════════════════════════════════════════════════════════════════════╗"
echo "║  Screenshot this terminal → docs/images/platform-demo.png            ║"
echo "╚══════════════════════════════════════════════════════════════════════╝"
echo ""
