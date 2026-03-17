# M5.3 – AI Recommendations Tab

Custom Argo CD UI extension for an "AI Recommendations" tab, pulling real-time suggestions from MCP agents on app health, optimizations, and fixes.

## Key Result

AI tab available in Argo CD application views; real-time MCP recommendations; ≥70% utilization target.

## Deliverables

- Custom Argo CD UI plugin/extension
- "AI Recommendations" tab in Argo CD application views
- Integration with MCP backend for real-time suggestions
- Proxy Extension to reach MCP backend (auth, RBAC)

## Requirements (from GitOps-Practices)

| ID | Requirement |
|----|-------------|
| TR-M53-1 | Provide custom Argo CD UI extension for "AI Recommendations" tab |
| TR-M53-2 | Display in Argo CD application views (registerAppViewExtension or registerResourceExtension) |
| TR-M53-3 | Integrate with MCP backend for real-time suggestions |
| TR-M53-5 | Use Argo CD Proxy Extension; enforce auth, authorization, RBAC |
| TR-M53-7 | Pass mandatory headers: Argocd-Application-Name, Argocd-Project-Name |

## Structure

```
ai-recommendations-tab/
├── README.md
├── config/                    # Argo CD and Kubernetes configs
│   ├── argocd-proxy-extension.yaml
│   └── mcp-backend-deployment.yaml
├── extension/                 # Argo CD UI extension (React/JavaScript)
│   ├── package.json
│   ├── webpack.config.js
│   └── src/index.js
└── mcp-backend/               # MCP backend server
    ├── package.json
    ├── Dockerfile
    └── src/server.js
```

## Quick Start

### 1. Build the extension

```bash
cd extension && npm install && npm run build
```

Copy `extension/dist/extension.js` to Argo CD server's `/tmp/extensions/ai-recommendations/extension.js`.

### 2. Run the MCP backend (local dev)

```bash
cd mcp-backend && npm install && npm start
```

### 3. Deploy to Kubernetes

```bash
# Build backend image (for kind: kind load docker-image ai-recommendations-backend:0.1)
cd mcp-backend && docker build -t ai-recommendations-backend:0.1 .

# Deploy backend and configure proxy
kubectl apply -f config/mcp-backend-deployment.yaml
kubectl apply -f config/argocd-proxy-extension.yaml
```

### 4. Configure Argo CD base path (if used)

If Argo CD uses a base path (e.g. `/argocd`), the extension derives it from the current URL. No extra config needed.

## Architecture

```
Argo CD UI → Proxy Extension → MCP Backend
                ↓
         Argocd-Application-Name (namespace:app-name)
         Argocd-Project-Name
         (auth headers)
```

## References

- [Argo CD UI Extensions](https://argo-cd.readthedocs.io/en/stable/developer-guide/extensions/ui-extensions/)
- [Proxy Extensions](https://argo-cd.readthedocs.io/en/stable/developer-guide/extensions/proxy-extensions/)
- [argocd-extension-metrics](https://github.com/argoproj-labs/argocd-extension-metrics)
- [MCP Specification](https://modelcontextprotocol.io/specification/2025-06-18/basic)
