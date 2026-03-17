# M5.2 – GitOps Promoter

**Epic:** M5.2 | **Quarter:** Q2 2026

Deploy GitOps Promoter to enable automated promotions across environments (staging → production) with checks and approvals.

## Key Result

Full coverage of environment promotions via GitOps Promoter with Argo CD sync integration; production requires manual approval.

## Deliverables

- GitOps Promoter deployment
- Automated environment promotion workflows (DRY → staging → production)
- Integration with Argo CD syncs
- Approval and check mechanisms (ArgoCDCommitStatus)

## Requirements (from GitOps-Practices)

| ID | Requirement |
|----|-------------|
| TR-M52-1 | Deploy GitOps Promoter (v0.24.0+) with Argo CD hydrator integration |
| TR-M52-2 | Automate PR creation from staging branches (`-next`) to live environment branches |
| TR-M52-4 | Configure ScmProvider (GitHub/GitLab), GitRepository, PromotionStrategy, ArgoCDCommitStatus |
| TR-M52-5 | Production autoMerge SHALL be false (manual approval required) |
| TR-M52-7 | Gate promotions via Argo CD application health (ArgoCDCommitStatus) |

## Structure

```
gitops-promoter/
├── README.md
├── config/           # PromotionStrategy, ScmProvider, GitRepository, ArgoCDCommitStatus
└── examples/         # Sample promotion flows
```

## Promotion Flow

1. Argo CD Hydrator pushes hydrated manifests to `environment/<env>-next`
2. GitOps Promoter opens PR from `-next` → `environment/<env>`
3. ArgoCDCommitStatus gates based on application health
4. Production: autoMerge false → manual approval required

## References

- [GitOps Promoter Overview](https://argo-gitops-promoter.readthedocs.io/en/latest/)
- [Argo CD Apps Tutorial](https://gitops-promoter.readthedocs.io/en/latest/tutorial-argocd-apps/)
