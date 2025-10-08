# Contributing Guide

This document explains how to contribute to the project. For basic installation and running the app, see [README_EN.md](README_EN.md) or [README_ES.md](README_ES.md).

## Development Prerequisites
----------------------------
**Beyond basic Flutter setup**, contributors need:
- Git for version control
- PowerShell (for Windows-specific development scripts)
- IDE with Flutter support (VS Code recommended)
- Understanding of Clean Architecture principles

## Development Environment Setup
-------------------------------
1. **Follow basic installation** from [README_EN.md](README_EN.md#installation)

2. **Additional development tools:**
   ```bash
   # Enable development scripts
   chmod +x scripts/*.sh  # Linux/macOS
   
   # Set PowerShell execution policy (Windows)
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
   ```

3. **Verify development setup:**
   ```bash
   flutter doctor
   flutter analyze
   flutter test
   dart format --output=none --set-exit-if-changed .
   ```

4. **Optional: Setup IDE extensions**
   - Flutter extension
   - Dart extension  
   - GitLens (for better git integration)

## Pull Request Process
----------------------
Choose the appropriate PR template when creating a PR:

- **Feature**: [feature.md](.github/PULL_REQUEST_TEMPLATE/feature.md) - For new features
- **Bug Fix**: [bugfix.md](.github/PULL_REQUEST_TEMPLATE/bugfix.md) - For bug fixes  
- **Deploy**: [deploy.md](.github/PULL_REQUEST_TEMPLATE/deploy.md) - For deployment changes
- **Release**: [release.md](.github/PULL_REQUEST_TEMPLATE/release.md) - For releases

When creating a PR, GitHub will prompt you to select the appropriate template. Each template includes a comprehensive checklist covering tests, code quality, coverage requirements, and architecture compliance.

## Development Tools and Scripts
-------------------------------

### Windows-specific Tools
- `tool/scripts/run_tests_windows.ps1` - Run tests per module with coverage
- `tool/ci/check_coverage.dart` - Coverage validation
- `tool/ci/analyze_check.dart` - Code analysis validation

## Testing and Coverage
----------------------

### Running Tests Locally

**Quick commands:**
```bash
flutter test                    # Run all tests
flutter test --coverage        # Run tests with coverage
flutter analyze                # Code analysis
dart format .                   # Format code
```

### Windows Helper Script
Use the PowerShell helper to run tests per module and generate coverage files matching CI expectations:

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

## Coding Standards
------------------
- Follow [Dart/Flutter style guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add documentation for public APIs
- Follow Clean Architecture layer boundaries
- Write tests for new functionality
- Maintain minimum 80% code coverage

## Commit Message Format
-----------------------
Use [Conventional Commits](https://www.conventionalcommits.org/) format:

```
type(scope): description

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(search): add debouncing to cat breed search
fix(cache): resolve memory leak in image caching
docs(readme): update installation instructions
```

## Architecture Guidelines
--------------------------
Follow Clean Architecture principles:

- **Domain Layer**: Pure business logic, no external dependencies
- **Infrastructure Layer**: External integrations (API, cache, database)
- **Presentation Layer**: UI logic and state management

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed guidelines.

## CI and Local Development Notes
--------------
- CI thresholds are in `.github/workflows/ci.yml` as environment variables. You can inspect or update them in that file.
- The helper scripts aim to mimic the CI test/coverage step on Windows and avoid shell glob expansion issues.

Melos and CI
------------
This repository includes `melos.yaml` and local Melos helpers for developer convenience. Note that the default CI workflow does not call Melos; instead the CI workflow runs the test, analyze and coverage steps directly. The CI may cache Melos-related directories (for example `.melos` and `.dart_tool/melos`) but caching alone does not execute Melos.

If you want CI to invoke Melos scripts (so local and CI behavior are identical), update the workflow to call `dart run melos run <script>` as appropriate.

If you want, I can add a script to combine lcov files or upload them to a coverage service.
