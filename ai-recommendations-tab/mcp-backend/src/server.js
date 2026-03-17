/**
 * MCP Backend for AI Recommendations
 *
 * Receives requests from Argo CD Proxy Extension with headers:
 * - Argocd-Application-Name (format: namespace:app-name)
 * - Argocd-Project-Name
 *
 * Returns app health, optimization, and fix recommendations.
 * Designed for extension via real MCP/LLM integration.
 */

const express = require('express');
const app = express();
const PORT = process.env.PORT || 8080;

app.use(express.json());

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Recommendations endpoint - called via /extensions/ai-recommendations/recommendations
app.get('/recommendations', (req, res) => {
  const appNameHeader = req.get('Argocd-Application-Name') || '';
  const projectName = req.get('Argocd-Project-Name') || 'default';

  const [namespace, appName] = appNameHeader.includes(':')
    ? appNameHeader.split(':')
    : ['argocd', appNameHeader || 'unknown'];

  const recommendations = generateRecommendations(appName, projectName, namespace);
  res.json({ recommendations });
});

function generateRecommendations(appName, projectName, namespace) {
  // Generate contextual recommendations based on app metadata.
  // In production, this would call MCP tools, LLM, or cluster APIs.
  const recommendations = [];

  // Health recommendations
  recommendations.push({
    type: 'health',
    severity: 'info',
    title: 'Sync status check',
    description: `Verify application "${appName}" is synced with the desired state. Consider enabling auto-sync for faster deployments.`,
    action: 'Check sync status in the application details view.',
  });

  recommendations.push({
    type: 'health',
    severity: 'info',
    title: 'Resource health',
    description: 'Ensure all deployed resources (Deployments, StatefulSets, etc.) are healthy and running.',
    action: 'Review the resource tree for any degraded or missing resources.',
  });

  // Optimization recommendations
  recommendations.push({
    type: 'optimization',
    severity: 'info',
    title: 'Image tag strategy',
    description: 'Consider using digest-based image references for immutable deployments and better traceability.',
    action: 'Update image references from tags to digests in your manifests.',
  });

  recommendations.push({
    type: 'optimization',
    severity: 'info',
    title: 'Resource limits',
    description: `Review CPU and memory limits for workloads in project "${projectName}". Proper limits improve cluster stability.`,
    action: 'Add or tune resource requests/limits in Deployment specs.',
  });

  // Fix recommendations (contextual based on app name)
  if (appName.toLowerCase().includes('prod') || appName.toLowerCase().includes('production')) {
    recommendations.push({
      type: 'fix',
      severity: 'warning',
      title: 'Production safeguards',
      description: 'Ensure sync options (e.g., Prune, Self-Heal) are configured appropriately for production.',
      action: 'Review Application spec.syncPolicy and consider manual sync for critical changes.',
    });
  }

  recommendations.push({
    type: 'fix',
    severity: 'info',
    title: 'Helm value validation',
    description: 'If using Helm, validate that values files are committed to Git and follow GitOps practices.',
    action: 'Store Helm values in the same repo as the Application manifest.',
  });

  return recommendations;
}

app.listen(PORT, () => {
  console.log(`AI Recommendations MCP backend listening on port ${PORT}`);
});
