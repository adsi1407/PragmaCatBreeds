
## Feature / Nueva funcionalidad

Use this template when opening a PR that adds a new feature.

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
- [ ] If adding test doubles, I followed the appropriate Test Organization Principles:
  - [Domain Test Organization](../../module/domain/test/TEST_ORGANIZATION.md) for business logic tests
  - [Infrastructure Test Organization](../../module/infrastructure/test/TEST_ORGANIZATION.md) for technical component tests
- [ ] I added or updated documentation if public APIs, architecture, or behaviors changed (README/Architecture/[CHANGELOG](../../CHANGELOG.md)).

Feature-specific checklist
-------------------------
- [ ] I described the feature and why it's needed.
- [ ] I updated `README.md` / `Architecture.md` if the feature affects architecture or setup.
- [ ] I added unit/bloc/widget tests that cover the behavior.
- [ ] I considered backward compatibility and added migration notes if needed.

Recommended (strongly suggested)
--------------------------------
- [ ] If network behavior changed, I verified `Dio` interceptors and cache configuration in DI wiring.
- [ ] If UI changed, I added a golden or widget test and attached screenshots for visual review.
- [ ] If DB schema changed, I updated Drift migrations and DAO tests.

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

Testing notes
- Run analyzer and tests locally.
