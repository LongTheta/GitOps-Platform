# M5.1 – Manifest Hydrator

Configure Argo CD Source Hydrator to automate hydration and commits to dedicated Git branches from DRY configs.

## Key Result

≥50% of customer applications using automated hydration to dedicated branches; hydration <5 minutes from config change to commit.

## Deliverables

- Branching workflow assessment and documentation
- Argo CD manifest hydrator configuration
- Automated manifest hydration from DRY configs (Helm/Kustomize/CMP)
- Branch commit automation

## Requirements (from GitOps-Practices)

| ID | Requirement |
|----|-------------|
| TR-M51-2 | Configure Argo CD Source Hydrator with `hydrator.enabled: "true"` and Commit Server |
| TR-M51-3 | Render DRY configs into hydrated manifests and push to dedicated Git branches |
| TR-M51-4 | Use non-root hydration output paths (Argo CD v3.2+) |
| TR-M51-5 | Include `hydrator.metadata` JSON (`{"drySha": "<commit SHA>"}`) for GitOps Promoter contract |
| TR-M51-6 | Store git push credentials in `argocd-push` namespace with `argocd.argoproj.io/secret-type: repository-push` |

## Structure

```
manifest-hydrator/
├── README.md
├── config/           # Argo CD hydrator config, Application examples
└── examples/         # Sample DRY configs and hydrated output
```

## Configuration

1. Enable hydrator: `hydrator.enabled: "true"` in Argo CD
2. Configure Commit Server for git push
3. Create repository-push Secret in `argocd-push` namespace
4. Define `sourceHydrator` in Application spec with `drySource` and `hydrateTo`

## References

- [Argo CD Manifest Hydrator proposal](https://argo-cd.readthedocs.io/en/stable/proposals/manifest-hydrator/)
- [Argo CD Commit Server](https://argo-cd.readthedocs.io/en/stable/proposals/manifest-hydrator/commit-server/)
- [ApplicationSet](https://argo-cd.readthedocs.io/en/stable/user-guide/application-set/)
