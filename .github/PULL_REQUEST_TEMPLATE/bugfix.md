
## Bugfix / Corrección

Use this template when fixing a bug or defect.

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
- [ ] **Golden Tests**: If the fix affects UI components:
  - [ ] Updated golden files with `flutter test --update-goldens` if visual changes are expected
  - [ ] Verified all golden tests pass after the fix
  - [ ] Committed updated golden files if UI changes are intentional
- [ ] I followed the test organization guidelines: [Domain](../../module/domain/test/TEST_ORGANIZATION.md) | [Infrastructure](../../module/infrastructure/test/TEST_ORGANIZATION.md).
- [ ] I added or updated documentation if public APIs, architecture, or behaviors changed (README/Architecture/[CHANGELOG](../../CHANGELOG.md)).

Bugfix-specific checklist
------------------------
- [ ] I reproduced the bug locally and described steps to reproduce.
- [ ] I added or updated tests that fail before the fix and pass after.
- [ ] I verified no regressions in related features.
- [ ] I updated [changelog](../../CHANGELOG.md) or issue references.

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
- Run the failing test case locally and ensure it passes.
