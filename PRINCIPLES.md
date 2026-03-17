# Design Principles

This document defines the principles and standards used when designing, documenting, and implementing the Observability Easy Button framework.

## 1. Prefer Official Sources

When documenting or implementing features, prioritize:

1. **Official documentation** — Grafana, Prometheus, Alloy, Kubernetes, Argo CD
2. **Community tutorials** — Well-maintained, versioned community guides
3. **Example implementations** — Reference implementations from upstream projects
4. **Inference** — Last resort; clearly label as inferred and document assumptions

Always cite the source type when referencing external information.

## 2. Label Source Types

When referencing external content, use these labels:

| Label | Meaning |
|-------|---------|
| Official documentation | From vendor or project maintainer |
| Community tutorial | Third-party guide, may lag official docs |
| Example implementation | Working code from upstream or community |
| Inference | Derived from context; assumptions documented |

## 3. Version Awareness

Include version context in documentation:

- **Product versions**: "As of Grafana 11.x", "As of Prometheus 2.47"
- **Date context**: "As of March 2026"
- **API versions**: "observability.platform.io/v1"

When behavior may change across versions, note the tested or expected version range.

## 4. Surface Assumptions

Call out assumptions explicitly:

- **Example**: "Assumes Prometheus scrape configs are managed by Alloy."
- **Example**: "Assumes Argo CD Application resources exist for each monitored app."
- **Example**: "Assumes Grafana provisioning is configured to read from Git-backed dashboards."

Use an "Assumptions" section in design docs when relevant.

## 5. Avoid Unsupported Compliance Claims

Use precise language for compliance and certification:

| Use | Avoid |
|-----|-------|
| "supports" | "satisfies" |
| "aligns with" | "certified" |
| "enables evidence for" | "FedRAMP compliant" |
| "maps to control X" | "implements control X" (unless verified) |

**Never** claim "FedRAMP compliant" or "certified" unless you have verified documentation from an authorized assessor.

## 6. Standard AI Output Format

When AI or automation generates documentation or code, use this structure:

1. **Official docs** — Links or citations to authoritative sources
2. **Examples** — Working, minimal examples
3. **Version notes** — Product and date context
4. **Architecture implications** — How the change affects the system
5. **Risks** — Known limitations or failure modes
6. **Recommended implementation** — Preferred approach with rationale
7. **Compliance impact** — How the change supports or aligns with controls (if applicable)

## 7. GitOps-First

- Configuration lives in Git
- Dashboards are JSON files in the repository
- Provisioning is declarative (e.g., Grafana provisioning, Argo CD)
- Changes are auditable via Git history

## 8. Placeholder Naming

Use generic placeholders in examples and documentation:

- **Clusters**: `prod-cluster-1`, `staging-cluster-1`, `cluster-name`
- **Domains**: `example.com`, `platform.example.com`
- **Projects**: `my-platform`, `my-app`
- **Namespaces**: `my-namespace`, `app-namespace`

Avoid organization-specific identifiers, internal URLs, or project-specific ticket references.
