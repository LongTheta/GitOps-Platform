# Platform demo and observability screenshots

Add these files for full README impact:

- **platform-demo.png** — Promotion workflow, policy enforcement, Argo CD
- **observability-dashboard.png** — Deployment timeline, drift, DORA metrics

Until added, README image links will show as placeholders.

---

## Capturing platform-demo.png

1. **Run the demo script** (from repo root):
   ```bash
   ./scripts/demo-screenshot.sh
   ```

2. **Screenshot the terminal** — The output shows:
   - Policy enforcement (policy-check failures)
   - Promotion workflow (dev → stage blocked)
   - Promotion strategy (prod = manual approval)
   - Argo CD sync (if Argo CD is running)

3. **Save as** `docs/images/platform-demo.png`

4. **Optional**: For Argo CD UI in the screenshot, deploy the platform first:
   ```bash
   kubectl apply -f platform/argo/
   # Then open Argo CD UI and capture app sync status
   ```
