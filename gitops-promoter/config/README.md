# GitOps Promoter Configuration

## Setup

1. **Set the Git repository URL** — Edit `git-repository.yaml`:
   ```yaml
   spec:
     url: https://gitlab.com/your-org/gitops-platform.git  # or your repo
     branch: main  # or master
   ```

2. **Create GitLab credentials** — Create Secret `gitlab-credentials` in namespace `gitops-promoter`:
   ```bash
   kubectl create secret generic gitlab-credentials \
     --namespace gitops-promoter \
     --from-literal=token=YOUR_GITLAB_TOKEN
   ```

3. **Create Git repo credentials** — Create Secret `gitops-repo-credentials` for clone:
   ```bash
   kubectl create secret generic gitops-repo-credentials \
     --namespace gitops-promoter \
     --from-literal=username=git \
     --from-literal=password=YOUR_TOKEN
   ```

4. **Apply configs** (in order):
   ```bash
   kubectl apply -f git-repository.yaml
   kubectl apply -f scm-provider-gitlab.example.yaml  # rename to scm-provider-gitlab.yaml after editing
   kubectl apply -f promotion-strategy.yaml
   ```

5. **Update ScmProvider** — Edit `scm-provider-gitlab.example.yaml`:
   - Set `baseUrl` to your GitLab URL (e.g., `https://gitlab.com`)
   - Ensure credentials secret exists

## Environment Branches

Promotion creates/uses these branches:

- `environment/development` (dev)
- `environment/staging` (stage)
- `environment/production` (prod)

Ensure these branches exist or GitOps Promoter will create them on first promotion.
