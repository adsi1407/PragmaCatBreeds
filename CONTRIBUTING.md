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

## Development Tools and Scripts 🛠️
----------------------------------

The project provides two categories of scripts:

### Developer Scripts (`scripts/`)
**For manual development work** - user-friendly with visual feedback:

- `setup.sh` - Complete environment setup and verification
- `test_coverage.sh/bat` - Generate coverage reports with HTML output and browser opening
- `performance_test.sh` - Performance testing with detailed metrics

**Usage:**
```bash
./scripts/environment/setup.sh                 # Setup environment
./scripts/test_coverage.sh         # Generate visual coverage reports
```

### Automation Scripts (`tool/`)
**For CI/CD pipelines** - minimal output, structured data:

- `tool/ci/check_coverage.dart` - Programmatic coverage threshold validation
- `tool/ci/analyze_check.dart` - Automated code analysis validation
- `tool/scripts/run_tests_windows.ps1` - Windows-specific test runner

**Usage:**
```bash
dart run tool/ci/check_coverage.dart coverage.lcov 90
dart run tool/ci/analyze_check.dart analyze_output.json
```

### Coverage Consistency
Both script categories enforce **identical coverage thresholds**:

| Layer | Threshold | Rationale |
|-------|-----------|-----------|
| Domain | 90% | Core business logic must be well-tested |
| Infrastructure | 60% | Data layer with external dependencies |
| Presentation BLoC | 50% | State management logic |
| Presentation Widgets | 40% | UI components (Flutter testing complexity) |

## Testing and Coverage
----------------------

> 📋 **Test Organization Guidelines**: Before writing tests, review our test organization principles:
> - [Domain Test Organization](module/domain/test/TEST_ORGANIZATION.md) - Clean Architecture compliance and business logic focus
> - [Infrastructure Test Organization](module/infrastructure/test/TEST_ORGANIZATION.md) - Common Closure Principle and technical component organization

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

**Test Organization**: Apply Clean Architecture and Common Closure Principles to test organization:
- **Domain Tests**: Focus on business logic purity ([Domain Test Organization](module/domain/test/TEST_ORGANIZATION.md))
- **Infrastructure Tests**: Organize by technical change patterns ([Infrastructure Test Organization](module/infrastructure/test/TEST_ORGANIZATION.md))

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

---

# 👀 Code Review Guidelines

This section is specifically for **code reviewers** to ensure consistent and thorough review processes.

## 🎯 Review Checklist

### **1. 🏗️ Architecture & Design**
- [ ] **Clean Architecture compliance**: Domain/Infrastructure/Presentation separation maintained
- [ ] **SOLID principles**: Single responsibility, dependency inversion respected
- [ ] **Dependency injection**: Dependencies properly injected, not hardcoded
- [ ] **Design patterns**: BLoC/Repository/UseCase patterns used appropriately

### **2. 🔍 Code Quality**
- [ ] **Readability**: Code is self-documenting with clear naming
- [ ] **Complexity**: Functions are focused and have single responsibility
- [ ] **Documentation**: Complex logic is adequately documented
- [ ] **Formatting**: Code follows project formatting standards

### **3. 🧪 Testing Requirements**
- [ ] **Coverage thresholds maintained**:
  - Domain Module: ≥90%
  - Infrastructure Module: ≥60%
  - Presentation BLoC: ≥50%
  - Presentation Widgets: ≥40%
- [ ] **Test quality**: Edge cases and error scenarios covered
- [ ] **Test organization**: Follows Clean Architecture principles
- [ ] **Mocks/Fakes**: External dependencies properly mocked

### **4. 🚀 Performance & Resource Management**
- [ ] **Memory management**: Resources properly disposed (dispose() calls)
- [ ] **Build performance**: Changes don't significantly impact build time
- [ ] **Runtime performance**: No obvious performance bottlenecks
- [ ] **Bundle size**: Unnecessary dependencies not introduced

### **5. 🔒 Security Considerations**
- [ ] **Input validation**: User input properly validated
- [ ] **Error handling**: Errors don't expose sensitive information
- [ ] **Credentials**: No hardcoded API keys or sensitive data
- [ ] **Network security**: HTTPS used for external communications

### **6. 📱 UI/UX (when applicable)**
- [ ] **Responsive design**: Works across different screen sizes
- [ ] **Accessibility**: Semantic labels and navigation support
- [ ] **Design system**: Follows established UI patterns
- [ ] **Performance**: UI remains smooth and responsive

## 🚦 Approval Criteria

### ✅ **Approve when:**
- All automated checks pass ✅
- Coverage thresholds met ✅
- Architecture principles followed ✅
- Code quality standards met ✅
- Security considerations addressed ✅

### ❌ **Request changes when:**
- Tests fail or coverage below thresholds ❌
- Architecture violations present ❌
- Security vulnerabilities identified ❌
- Code quality significantly below standards ❌

### 💬 **Comment (non-blocking) for:**
- Minor optimization opportunities
- Suggestions for future refactoring
- Educational feedback
- Recognition of good practices

## 🛠️ Reviewer Tools

### **Local Verification Commands:**
```bash
# Clean environment and test
./scripts/dev/cleanup/clean_project_working.ps1
flutter pub get

# Run comprehensive tests
flutter test --coverage
dart run scripts/ci/validation/check_coverage.dart coverage/lcov.info 85

# Check static analysis
flutter analyze
dart run scripts/ci/validation/analyze_check.dart analyze_output.txt

# Module-specific testing
cd module/domain && flutter test --coverage
cd module/infrastructure && flutter test --coverage
```

### **Coverage Validation:**
```bash
# Check specific module coverage
dart run scripts/ci/validation/check_coverage.dart module/domain/coverage/lcov.info 90
dart run scripts/ci/validation/check_bloc_coverage.dart coverage/lcov.info 50
dart run scripts/ci/validation/check_widgets_coverage.dart coverage/lcov.info 40
```

## 📋 Review Process

1. **Initial Review**: Check PR description and template completion
2. **Automated Checks**: Verify CI passes before detailed review
3. **Code Review**: Apply checklist systematically
4. **Testing**: Run critical tests locally if needed
5. **Feedback**: Provide clear, actionable feedback
6. **Re-review**: Verify requested changes implemented
7. **Approval**: Approve when all criteria met

## 💡 Review Best Practices

### **Effective Feedback:**
- **Be specific**: "Consider using const constructor here for performance"
- **Be constructive**: Suggest solutions, not just problems
- **Share knowledge**: Link to relevant documentation or examples
- **Recognize quality**: Acknowledge well-written code

### **Example Comments:**
```
✅ "Excellent separation of concerns in this repository implementation!"

✅ "Consider using StreamBuilder instead of polling for better performance:
   https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html"

✅ "This test coverage is comprehensive - great edge case handling!"
```

---
