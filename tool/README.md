# Tool Utilities

This directory contains **Dart utilities** for programmatic analysis and validation. These tools are primarily used by CI/CD pipelines but can also be called by development scripts.

## 📁 Directory Structure

### [`ci/`](ci/)
Dart utilities for automated quality checks and analysis.

**Purpose**: Provide programmatic validation tools using Dart's ecosystem for precise analysis.

## 🎯 Key Characteristics

| Aspect | `tool/` | `scripts/` |
|--------|---------|------------|
| **Language** | Dart | Shell/PowerShell/Batch |
| **Purpose** | Programmatic analysis | Workflow automation |
| **Complexity** | Complex logic, precise analysis | Simple operations, orchestration |
| **Integration** | Called by scripts or CI | Direct user execution |
| **Dependencies** | Dart SDK, pub packages | System utilities |
| **Output** | Structured data, exit codes | Human-readable output |

## 🔧 Available Tools

### CI Analysis Tools (`ci/`)
- **`analyze_check.dart`**: Code analysis validation with precise error filtering
- **`check_coverage.dart`**: Coverage validation with configurable thresholds
- **`check_bloc_coverage.dart`**: BLoC pattern specific coverage analysis
- **`check_pages_coverage.dart`**: Page/screen coverage validation
- **`check_widgets_coverage.dart`**: Widget coverage analysis

## 🚀 Usage

### Direct Usage (CI/CD)
```yaml
# GitHub Actions
- name: Check coverage
  run: dart run tool/ci/check_coverage.dart coverage.lcov 85
```

### Called by Scripts (Development)
```bash
# From scripts/testing/test_coverage.sh
dart run tool/ci/check_coverage.dart "$lcov_file" "$min_threshold"
```

## 🏗️ Architecture Integration

These tools provide **precise analysis** that respects Clean Architecture:
- **Domain validation**: Business logic coverage with strict thresholds
- **Infrastructure validation**: External service integration analysis  
- **Presentation validation**: UI component coverage with layer-specific rules

## 🛠️ Development Guidelines

When creating new tools:
1. **Use Dart** for complex analysis requiring precise logic
2. **Provide clear exit codes** (0 = success, non-zero = failure)
3. **Output structured data** when possible (JSON, CSV)
4. **Handle edge cases** gracefully with meaningful error messages
5. **Document expected inputs** and output formats

For simple workflow automation, use [`scripts/`](../scripts/) instead.