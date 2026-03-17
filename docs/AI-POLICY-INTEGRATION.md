# AI-Assisted Policy Enforcement Integration

How this repo integrates with AI policy enforcement (e.g., ai-devsecops-policy-enforcement-agent).

## As of March 2026

---

## Integration Points

### 1. PR Validation

- **When**: On every PR to the platform repo
- **Where**: CI (`.github/workflows/validate.yml`) or external agent
- **How**: Agent reviews changed manifests; comments with remediation suggestions
- **Example**: "Deployment X missing resource limits. Add resources.requests/limits."

### 2. Policy Checks on Promotion

- **When**: Before promotion to production
- **Where**: Pre-merge hook, GitOps Promoter approval step, or CI
- **How**: Agent evaluates manifests against `platform/policies/` expectations
- **Example**: "Production overlay uses image tag. Use digest for immutability."

### 3. Remediation During Review

- **When**: PR open or updated
- **How**: Agent suggests patches or auto-fix where safe
- **Example**: Agent adds `resources.limits` to Deployment via suggested patch

## This Repo's Role

- **Defines** where policy checks run (PR, promotion gate)
- **Documents** expected policies (`platform/policies/`)
- **Provides** examples (insecure vs secure in `examples/`)
- **Does not** implement the agent; integration is pluggable

## Optional Integration

The AI policy agent is **optional**. The platform works with:

- OPA / Gatekeeper / Kyverno (traditional policy engines)
- AI agent (ai-devsecops-policy-enforcement-agent or similar)
- Manual review only

## Adding the Agent

1. Configure agent to watch this repo (webhook or polling)
2. Agent runs on PR events; comments on violations
3. Add agent as required check in branch protection
4. Optionally: agent blocks merge until green

No code changes to this repo required; agent operates externally.
