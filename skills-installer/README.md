# Skills Installer

Provisions Cursor/Agent Skills to code-server for low-side and high-side environments. Configures Git for clone/push operations.

## Overview

| Component | Purpose |
|-----------|---------|
| **Skills-installer** | Copies skill folders to `.cursor/skills/`; runs setup-binaries and setup-git |
| **ConfigMap** | Non-sensitive config: baseDomain, GITLAB_URL, GIT_USER_NAME, GIT_USER_EMAIL |
| **Secret** | GITLAB_TOKEN (PAT); store separately from ConfigMap |
| **setup-git** | Configures Git from env vars |

## Requirements (from GitOps-Practices)

| ID | Requirement |
|----|-------------|
| TR-SK-1 | Provision skill folders to `.cursor/skills/` or `.agents/skills/` |
| TR-SK-2 | Support low-side (clone from GitLab) and high-side (pre-synced copy) |
| TR-SK-3 | Inject ConfigMap as env vars |
| TR-SK-4 | Inject Secret separately from ConfigMap |
| TR-SK-5 | Provide setup-git script |
| TR-SK-8 | Separate ConfigMaps/Secrets for low/high side; never reuse low-side creds on high side |

## Structure

```
skills-installer/
├── README.md
├── config/           # ConfigMap and Secret templates
├── scripts/          # setup-git, setup-binaries
└── manifests/        # Kubernetes Deployment for code-server with Skills
```

## ConfigMap (low-side example)

| Key | Value |
|-----|-------|
| baseDomain | example.com |
| GITLAB_URL | https://gitlab.example.com |
| GIT_USER_NAME | code-server |
| GIT_USER_EMAIL | codeserver@example.com |

## Secret

| Key | Value |
|-----|-------|
| GITLAB_TOKEN | glpat-… (GitLab PAT; scopes: read_repository, write_repository, read_api) |

## Usage

```bash
# Configure Git from env vars
./scripts/setup-git.sh

# Provision Skills (if cloning from GitLab)
./scripts/setup-skills.sh
```
