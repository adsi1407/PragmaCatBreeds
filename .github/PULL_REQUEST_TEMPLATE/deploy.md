
## Deploy / Deployment PR

Use this template when the PR is responsible for deployment changes (CI, infra, environment config) or manual deployment steps.

Required (must be completed)
--------------------------------
- [ ] I ran the static analyzer and fixed high-severity issues (`flutter analyze`).
- [ ] I ran the project/unit tests locally and they pass.
- [ ] I ran the coverage helper (if applicable) and ensured module thresholds are met:
	- Domain >= 90%
	- Infrastructure >= 60%
	- Presentation >= 50%
- [ ] I ran `flutter format` on modified files.
- [ ] I updated or added tests for any new behavior (unit, bloc, widget as appropriate).
- [ ] I followed the test organization guidelines: [Domain](../../module/domain/test/TEST_ORGANIZATION.md) | [Infrastructure](../../module/infrastructure/test/TEST_ORGANIZATION.md).
- [ ] I added or updated documentation if public APIs, architecture, or behaviors changed (README/Architecture/[CHANGELOG](../../CHANGELOG.md)).

Deploy-specific checklist
------------------------
- [ ] I documented the deployment steps and required secrets/permissions.
- [ ] I validated the CI pipeline changes in a staging environment.
- [ ] I included rollback instructions.
- [ ] I verified secrets are stored in GitHub Actions or a secret manager (do NOT include secrets in the PR).

Recommended (strongly suggested)
--------------------------------
- [ ] If network behavior changed, I verified `Dio` interceptors and cache configuration in DI wiring.
- [ ] If UI changed, I added a golden or widget test and attached screenshots for visual review.

Developer commands (examples)
-----------------------------
Run analyzer:

```powershell
flutter pub get
flutter analyze
```

Run tests & generate coverage (Windows helper):

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
.\tool\scripts\run_tests_windows.ps1
```

Format changed files:

```powershell
flutter format .
```

Checklist for reviewers
-----------------------
- [ ] The PR description is clear and the title follows repo conventions.
- [ ] Changes are small, focused, and test-covered.
- [ ] CI is green (analyzer + tests + coverage checks).
- [ ] No sensitive data or secrets were added.

Notes
- Coordinate with the DevOps or release owner before merging.

Deployment metadata (fill before merging)
----------------------------------------
- Environment: staging | production (specify target environment)
- Required approvers: @org/devops, @team-release (list users or teams that must approve)
- Runbook / Run steps (link): https://example.com/runbooks/my-deploy-runbook

Post-deploy validation (quick checks)
------------------------------------
- [ ] Verify health endpoint(s) return 200 (e.g., `curl -f https://app.example.com/health`).
- [ ] Smoke test key API routes or UI flows (list them here).
- [ ] Confirm logs/monitoring show no new critical errors for 10 minutes.

Rollback plan (template)
------------------------
Document the rollback steps you would run if the deploy fails. Example rollback commands (adapt to your infra):

```bash
# Kubernetes example
kubectl rollout undo deployment/my-app -n production

# Or revert to previous release tag and redeploy
git checkout <previous-release-tag>
./scripts/deploy.sh production
```

Notes
- Coordinate with the DevOps or release owner before merging.
