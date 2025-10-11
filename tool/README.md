# Tool Utilities

This directory contains Dart utilities and tools specifically designed for CI/CD pipelines and automated analysis.

## 📁 Directory Structure

### [`ci/`](ci/)
Dart utilities for Continuous Integration and automated quality checks.

**Purpose**: Provide programmatic access to analysis and validation tools using Dart's ecosystem.

## 🎯 Key Differences from `scripts/`

| Aspect | `tool/` | `scripts/` |
|--------|---------|------------|
| **Language** | Dart | Shell/PowerShell/Batch |
| **Purpose** | CI/CD automation | Development workflow |
| **Integration** | GitHub Actions, CI systems | Local development |
| **Complexity** | Complex analysis logic | Simple operations |
| **Dependencies** | Dart SDK, pub packages | System utilities |

## 🔧 Available Tools

### CI Analysis Tools (`ci/`)
- **`analyze_check.dart`**: Code analysis validation
- **`check_coverage.dart`**: Overall coverage validation
- **`check_bloc_coverage.dart`**: BLoC pattern coverage analysis
- **`check_pages_coverage.dart`**: Page/screen coverage validation
- **`check_widgets_coverage.dart`**: Widget coverage analysis

## 🚀 Usage

These tools are primarily used in CI/CD pipelines:

```yaml
# Example GitHub Actions usage
- name: Check coverage
  run: dart run tool/ci/check_coverage.dart
```

## 🏗️ Architecture Integration

These tools respect Clean Architecture boundaries:
- **Domain validation**: Business logic coverage requirements
- **Infrastructure validation**: External service integration checks
- **Presentation validation**: UI component coverage analysis

## 🛠️ Development

When adding new tools:
1. Use Dart for complex logic and integrations
2. Focus on CI/CD automation scenarios
3. Provide clear exit codes for pipeline integration
4. Document expected inputs and outputs
5. Consider cross-platform compatibility

For development workflow scripts, use [`scripts/`](../scripts/) instead.