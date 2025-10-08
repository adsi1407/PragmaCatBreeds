
## Release / Release PR

Use this template when preparing a release branch or PR.

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
- [ ] I added or updated documentation if public APIs, architecture, or behaviors changed (README/Architecture/CHANGELOG).

Release-specific checklist
-------------------------
- [ ] Bumped version in `pubspec.yaml` and relevant modules.
- [ ] Updated `CHANGELOG.md` with summary of changes.
- [ ] Verified CI passing for all modules (analyzer, tests, coverage).
- [ ] Included migration steps if required.

Deployment notes
----------------
- Ensure the release PR includes instructions for deployment and rollback.

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

Deployment notes
- Ensure any release-specific deployment steps are documented.
