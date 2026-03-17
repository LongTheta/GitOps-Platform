# AI Generation Standards

Standards for AI-assisted generation of dashboards and observability config.

## As of March 2026

---

## 1. Normalize Before Generation

AI **shall** normalize natural language or unstructured requests to the schema before generating artifacts:

- Map "I need a dashboard for my-app" → `{ application: my-app, namespace: ..., template: service-overview }`
- Use `dashboard-request.schema.json` as the target structure
- Do not generate from raw text without schema alignment

---

## 2. Use Templates

- **Do** use templates from `dashboards/templates/`
- **Do not** invent panel layouts from scratch
- If no template fits, recommend a new template; do not generate ad-hoc layouts

---

## 3. Label Output

AI-generated output **shall** be labeled:

| Label | Meaning |
|-------|---------|
| `draft` | Initial generation; requires human review |
| `review-required` | Ready for MR but not yet merged |
| `assumptions-documented` | Assumptions are explicitly listed |

---

## 4. List Assumptions and Missing Data

When generating, AI **shall**:

- List assumptions (e.g., "Assumed metrics path is /metrics")
- List missing data (e.g., "Namespace not specified; used placeholder")
- Surface inferred values (e.g., "Inferred template from app type")

---

## 5. GitOps-Aligned

- Generated JSON **shall** be committed to the repo
- Changes **shall** be incremental (one app, one dashboard per change when practical)
- Output **shall** be auditable (no ephemeral generation; persist to Git)

---

## 6. Compliance Language

When mapping to controls, use:

- "supports", "aligns with", "enables evidence for"
- **Never** "satisfies", "certified", "FedRAMP compliant" unless verified

---

## 7. Version Notes

Include in generated docs or comments:

- Product version (e.g., Grafana 11.x)
- Date (e.g., March 2026)
- Schema version (e.g., observability.platform.io/v1)
