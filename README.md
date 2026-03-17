# GitOps Platform

A GitOps platform implementing Manifest Hydrator, GitOps Promoter, AI Recommendations Tab, Automation Achievement, Skills installer, and Deployment Monitoring. Aligns with GitOps-Practices.

## Overview

This project delivers the core capabilities for advancing GitOps practices through automated branching and AI-enhanced UI customizations:

| Component | Quarter | Deliverable |
|-----------|---------|-------------|
| Manifest Hydrator | Q1 | Argo CD hydrator config; DRY → hydrated manifests → Git branches |
| GitOps Promoter | Q2 | Automated staging→prod promotion with approvals |
| AI Recommendations Tab | Q3 | Argo CD UI extension + MCP backend |
| Automation Achievement | Q4 | KPI validation; ≥90% promotion automation |
| Skills installer | — | Code-server setup; Skills provisioning; Git config |
| Deployment Monitoring | — | Grafana dashboards; deployment traceability; NIST SP 800-137 |

## Repository Structure

```
gitops-platform/
├── README.md
├── PRINCIPLES.md
├── manifest-hydrator/       # Argo CD Source Hydrator
│   ├── README.md
│   ├── config/
│   └── examples/
├── gitops-promoter/         # GitOps Promoter
│   ├── README.md
│   ├── config/
│   └── examples/
├── ai-recommendations-tab/  # Argo CD UI extension + MCP
│   ├── README.md
│   ├── extension/
│   └── mcp-backend/
├── automation-achievement/  # KPI validation
│   ├── README.md
│   └── scripts/
├── skills-installer/        # Code-server + Skills
│   ├── README.md
│   ├── config/
│   └── scripts/
├── observability/           # Deployment Monitoring (Easy Button)
│   ├── dashboards/
│   ├── dashboard-requests/
│   ├── generators/
│   └── schemas/
└── docs/
```

## Quick Start

### Manifest Hydrator
```bash
# Deploy Argo CD with hydrator enabled
kubectl apply -f manifest-hydrator/config/
```

### GitOps Promoter
```bash
# Deploy GitOps Promoter
kubectl apply -f gitops-promoter/config/
```

### AI Recommendations Tab
```bash
# Build and deploy the Argo CD extension
cd ai-recommendations-tab/extension && npm run build
```

### KPI Validation
```bash
# Run promotion success check
python automation-achievement/scripts/validate-kpis.py
```

### Skills Installer
```bash
# Provision Skills to code-server
./skills-installer/scripts/setup-skills.sh
```

### Deployment Monitoring
```bash
# Generate dashboard from request
cd observability && python generators/generate-dashboard-from-request.py dashboard-requests/example-app-overview.yaml
```

## Key Performance Indicators

| KPI | Target |
|-----|--------|
| Promotion success rate | ≥90% without manual intervention |
| Hydration efficiency | <5 minutes from config change to hydrated commit |
| AI tab utilization | ≥70% of Argo CD app views |
| User satisfaction | ≥4/5 from feedback |

## Federal DevSecOps Alignment

Aligns with the seven GitOps capabilities: CI/CD orchestration, GitOps/configuration as code, security scanning, promotion governance, observability, identity/secrets, policy as code. Maps to NIST SP 800-137, AU-2, AU-6, SI-4, CA-7.

## Documentation

- [PRINCIPLES.md](PRINCIPLES.md) — Design principles
- [manifest-hydrator/README.md](manifest-hydrator/README.md)
- [gitops-promoter/README.md](gitops-promoter/README.md)
- [ai-recommendations-tab/README.md](ai-recommendations-tab/README.md)
- [automation-achievement/README.md](automation-achievement/README.md)
- [skills-installer/README.md](skills-installer/README.md)
- [observability/README.md](observability/README.md)

## Version

As of March 2026. Argo CD 2.x/3.x, Grafana 11.x, GitOps Promoter v0.24+.
