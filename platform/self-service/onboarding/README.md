# Onboarding

How to onboard a new application. See [docs/SELF-SERVICE.md](../../../docs/SELF-SERVICE.md).

## Quick Steps

1. Copy `../templates/app-template/` to `platform/apps/<your-app>/`
2. Replace `<APP_NAME>` with your app name
3. Create overlays for dev, stage, prod
4. Add Argo CD Application in `platform/argo/applications/`
5. Submit PR; policy checks run
