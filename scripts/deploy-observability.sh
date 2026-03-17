#!/usr/bin/env bash
# deploy-observability.sh - Deploy observability config (Grafana dashboards, etc.)
# Requires: kubectl, kustomize. Grafana must be installed.
# As of March 2026

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

NAMESPACE="${OBSERVABILITY_NAMESPACE:-observability}"
GRAFANA_NAMESPACE="${GRAFANA_NAMESPACE:-grafana}"

echo "==> Deploying observability config"
echo "    Namespace: $NAMESPACE"
echo "    Grafana namespace: $GRAFANA_NAMESPACE"
echo ""

# Create namespace if needed
kubectl create namespace "$NAMESPACE" 2>/dev/null || true

# Create ConfigMap with dashboard JSON for Grafana provisioning
# Grafana can read from ConfigMap-mounted dashboards
echo "==> Creating dashboard ConfigMaps..."

kubectl create namespace "$GRAFANA_NAMESPACE" 2>/dev/null || true

for dashboard in observability/dashboards/deployment-intelligence/*.json; do
  if [ -f "$dashboard" ]; then
    name=$(basename "$dashboard" .json | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    kubectl create configmap "dashboard-$name" \
      --from-file="$(basename "$dashboard")=$dashboard" \
      --namespace "$GRAFANA_NAMESPACE" \
      --dry-run=client -o yaml | kubectl apply -f -
  fi
done

echo ""
echo "==> Next steps:"
echo "  1. Configure Grafana provisioning to read from ConfigMaps or mounted path"
echo "  2. See observability/dashboards/provisioning/dashboards.yaml"
echo "  3. Point Grafana GF_PATHS_PROVISIONING to the provisioning config"
echo "  4. Ensure Prometheus is scraping Argo CD metrics for deployment-intelligence dashboards"
echo ""
