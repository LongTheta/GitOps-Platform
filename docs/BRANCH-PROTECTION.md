# Branch Protection

Require validation to pass before merge.

## As of March 2026

---

## GitHub

1. **Settings** → **Branches** → **Add rule** (or edit existing)
2. **Branch name pattern**: `master` or `main`
3. **Enable**:
   - Require a pull request before merging
   - Require status checks to pass before merging
   - **Status checks**: Require `validate` (from `.github/workflows/validate.yml`)
   - Require branches to be up to date before merging
4. **Optional**: Require review from code owners, restrict who can push

## GitLab

1. **Settings** → **Repository** → **Protected branches**
2. **Protect** `master` or `main`
3. **Allowed to merge**: Maintainers (or your role)
4. **Allowed to push**: No one (force merge via MR only)
5. **Settings** → **CI/CD** → **Pipeline**:
   - Add `.gitlab-ci.yml` that runs `scripts/validate.sh` and `scripts/policy-check.sh`
   - Require pipeline to succeed before merge (Settings → Merge requests)

### Example `.gitlab-ci.yml`

```yaml
validate:
  stage: test
  image: alpine/k8s:1.28.2
  script:
    - apk add --no-cache bash
    - chmod +x scripts/*.sh
    - ./scripts/validate.sh
    - ./scripts/policy-check.sh
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
```

## Required Checks

| Check | Script | Purpose |
|-------|--------|---------|
| Structure + kustomize | `validate.sh` | Platform structure, manifest builds |
| Policy | `policy-check.sh` | No :latest in prod, resource limits, labels |

## Merge Request Settings

- Require pipeline success
- Require at least one approval (optional for small teams)
- Require up-to-date branch
