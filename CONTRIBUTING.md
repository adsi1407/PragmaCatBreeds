# Contributing and local CI helpers

This document explains how to run the project locally, run tests, and reproduce the CI steps on a Windows machine using the included PowerShell helpers.

Prerequisites
-------------
- Flutter SDK (stable channel) installed and available on PATH
- Android SDK (or Xcode for macOS/iOS) if you plan to run platform-specific builds
- PowerShell (Windows) — the helper scripts are PowerShell scripts

Quick commands
--------------
From the repo root:

PowerShell:

```powershell
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run analyzer
flutter analyze
```

Run tests and coverage (helper)
--------------------------------
Use the Windows helper to run tests per module and generate coverage files with the same names the CI expects.

From the repo root (PowerShell):

```powershell
# Make the script executable in current session
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

# Run all modules tests (domain, infrastructure, presentation blocs and widgets)
.\tool\scripts\run_tests_windows.ps1 -Module all

# Run a single module, e.g. domain
.\tool\scripts\run_tests_windows.ps1 -Module domain

# Run only presentation widgets (run widget tests and produce coverage-presentation-widgets.lcov)
.\tool\scripts\run_tests_windows.ps1 -Module presentation-widgets
```

What the helper script does
--------------------------
- Runs `flutter pub get` in the target module (where applicable)
- Runs `flutter test --coverage` for the module's test folders
- Moves generated `coverage/lcov.info` to the repository root with names matching CI artifacts:
  - `coverage-domain.lcov`
  - `coverage-infra.lcov`
  - `coverage-presentation-bloc.lcov`
  - `coverage-presentation-widgets.lcov`

When tests fail the script will continue (it mirrors CI behavior) but you should inspect output and the generated coverage files.

Local CI notes
--------------
- CI thresholds are in `.github/workflows/ci.yml` as environment variables. You can inspect or update them in that file.
- The helper scripts aim to mimic the CI test/coverage step on Windows and avoid shell glob expansion issues.

Melos and CI
------------
This repository includes `melos.yaml` and local Melos helpers for developer convenience. Note that the default CI workflow does not call Melos; instead the CI workflow runs the test, analyze and coverage steps directly. The CI may cache Melos-related directories (for example `.melos` and `.dart_tool/melos`) but caching alone does not execute Melos.

If you want CI to invoke Melos scripts (so local and CI behavior are identical), update the workflow to call `dart run melos run <script>` as appropriate.

If you want, I can add a script to combine lcov files or upload them to a coverage service.
