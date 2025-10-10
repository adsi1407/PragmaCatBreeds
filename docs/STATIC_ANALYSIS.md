# Static Analysis Strategy

## Overview

This project uses a comprehensive static analysis strategy to maintain code quality and consistency across the codebase.

## Tools and Configuration

### 1. Flutter Analyze + Very Good Analysis

**Primary tool:** `flutter analyze` with `very_good_analysis` package
- **Configuration:** `analysis_options.yaml`
- **Coverage:** Complete Dart/Flutter codebase analysis
- **Integration:** Automated in CI pipeline

### 2. Analysis Rules Categories

#### Code Quality & Complexity
- `avoid_classes_with_only_static_members` - Promotes proper OOP design
- `avoid_function_literals_in_foreach_calls` - Encourages readable code
- `prefer_const_constructors` - Performance optimization
- `prefer_final_locals` - Immutability best practices

#### Method & Class Constraints
- `avoid_returning_this` - Prevents builder pattern abuse
- `cascade_invocations` - Encourages fluent interfaces

#### Performance & Best Practices
- `avoid_slow_async_io` - Prevents blocking operations
- `avoid_dynamic_calls` - Type safety enforcement
- `unnecessary_await_in_return` - Performance optimization

#### Readability & Formatting
- `lines_longer_than_80_chars` - Code readability
- `eol_at_end_of_file` - File formatting consistency
- `sort_constructors_first` - Code organization

#### Type Safety
- `cast_nullable_to_non_nullable` - Null safety enforcement
- `omit_local_variable_types` - Type inference usage

#### Code Organization
- `directives_ordering` - Import organization
- `sort_pub_dependencies` - Dependency management

## CI Pipeline Integration

### Static Analysis Steps

1. **Flutter Analyze**
   ```bash
   flutter analyze 2>&1 | Out-File -FilePath analyze_output.txt -Encoding utf8
   ```

2. **Error Filtering**
   ```bash
   dart run tool/ci/analyze_check.dart analyze_output.txt
   ```
   - Only **errors** fail the CI
   - **Warnings** and **info** are logged but don't block deployment

### Failure Policy

- **❌ Errors:** CI fails immediately
- **⚠️ Warnings:** Logged, CI continues
- **ℹ️ Info:** Logged, CI continues

## Local Development

### Running Analysis Locally

```bash
# Run full analysis
flutter analyze

# Run analysis on specific directory
flutter analyze lib/

# Run with different verbosity
flutter analyze --verbose
```

### IDE Integration

The analysis rules are automatically picked up by:
- **VS Code** with Dart/Flutter extensions
- **Android Studio** with Flutter plugin
- **IntelliJ IDEA** with Dart plugin

### Suppressing Rules

When needed, rules can be suppressed:

```dart
// Single line suppression
final result = someMethod(); // ignore: prefer_final_locals

// File-level suppression
// ignore_for_file: prefer_const_constructors

// Multi-line suppression
// ignore: lines_longer_than_80_chars
final veryLongVariableName = someVeryLongMethodNameThatExceedsTheLimit();
```

## Rule Customization

### Enabling Additional Rules

Add to `analysis_options.yaml`:
```yaml
linter:
  rules:
    new_rule_name: true
```

### Disabling Existing Rules

```yaml
linter:
  rules:
    existing_rule_name: false
```

### Project-Specific Exceptions

Some rules are disabled due to project constraints:
- `public_member_api_docs: false` - High volume in existing codebase
- `avoid_print: false` - Allowed in CI scripts and tools

## Migration from dart_code_metrics

**Previous tool:** `dart_code_metrics` (deprecated)
**Current approach:** Enhanced `flutter analyze` with comprehensive rules

### Benefits of New Approach

✅ **Native Flutter support** - No third-party dependencies
✅ **Active maintenance** - Part of official Dart toolchain  
✅ **IDE integration** - Built-in support across editors
✅ **Performance** - Faster analysis and CI execution
✅ **Consistency** - Same rules in development and CI

### Migrated Metrics

| dart_code_metrics Feature | New Implementation |
|---------------------------|-------------------|
| Cyclomatic complexity | `flutter analyze` built-in rules |
| Method length limits | `lines_longer_than_80_chars` + manual review |
| Parameter count | Code review process |
| Class complexity | `avoid_classes_with_only_static_members` |
| Code duplication | Manual review + `very_good_analysis` rules |

## Quality Gates

### Pre-commit Hooks (Recommended)

```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: flutter-analyze
        name: Flutter Analyze
        entry: flutter analyze
        language: system
        pass_filenames: false
```

### CI Quality Thresholds

- **Zero errors** - Required for merge
- **Warnings review** - Manual approval for high counts
- **Info messages** - Informational only

## Troubleshooting

### Common Issues

1. **UTF-8 encoding errors in CI**
   - Solution: Use `Out-File -Encoding utf8` in PowerShell

2. **Rule conflicts with existing code**
   - Solution: Gradual migration with targeted suppressions

3. **Performance impact**
   - Solution: Analysis runs only on changed files in development

### Getting Help

- **Dart Linter Rules:** https://dart.dev/tools/linter-rules
- **Very Good Analysis:** https://pub.dev/packages/very_good_analysis
- **Project Issues:** Create GitHub issue with `analysis` label

---

**Last updated:** October 2025
**Maintained by:** Development Team