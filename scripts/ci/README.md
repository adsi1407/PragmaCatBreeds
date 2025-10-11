# CI/CD Scripts

Scripts designed for **Continuous Integration and Continuous Deployment** workflows. These scripts are optimized for automated environments and used in GitHub Actions and other CI/CD systems.

## 📁 Directory Structure

### 🔧 [`sonar/`](sonar/)
SonarCloud integration and specialized analysis scripts.
- **Usage**: Quality gates, code analysis in CI
- **Purpose**: SonarCloud setup, configuration, and optimized coverage generation

### 🧪 [`testing/`](testing/)
Test execution and coverage generation for CI pipelines.
- **Usage**: Automated testing in CI workflows
- **Purpose**: Test execution, coverage validation, CI-optimized reporting

### ✅ [`validation/`](validation/)
Dart utilities for programmatic validation and analysis.
- **Usage**: Precise validation with exit codes for CI
- **Purpose**: Coverage validation, code analysis, threshold checking
- **Language**: Dart (formerly tool/ci/)

## 🎯 Primary Use Cases

### For CI/CD Pipelines
- **Automated testing**: Coverage generation and validation
- **Quality gates**: SonarCloud integration and analysis
- **Code validation**: Static analysis and threshold checking
- **Build validation**: Automated quality checks

### Integration Points
- **GitHub Actions**: Direct integration with workflow files
- **SonarCloud**: Quality analysis and reporting
- **Coverage tools**: Automated threshold validation
- **Build systems**: Integration with build and deploy processes

## 🚀 Usage in CI Workflows

### GitHub Actions Examples
```yaml
# Coverage validation
- name: Check Domain Coverage
  run: dart run scripts/ci/validation/check_coverage.dart coverage.lcov 90

# SonarCloud analysis
- name: Generate SonarCloud Coverage
  run: ./scripts/ci/sonar/sonar_coverage.sh

# Code analysis
- name: Validate Code Analysis
  run: dart run scripts/ci/validation/analyze_check.dart analyze_output.txt
```

### Local CI Testing
```bash
# Test SonarCloud integration
./scripts/ci/sonar/setup_sonarcloud.sh

# Run CI-style coverage
./scripts/ci/testing/test_coverage.sh

# Validate coverage thresholds
dart run scripts/ci/validation/check_coverage.dart coverage.lcov 85
```

## 🔧 Script Characteristics

### Optimized for Automation
- **Exit codes**: Precise success/failure indicators
- **Minimal output**: Focused on essential information
- **Error handling**: Graceful failure with clear error messages
- **Reproducibility**: Consistent behavior across environments

### Platform Considerations
- **Linux focus**: Primarily designed for Linux CI runners
- **Cross-platform**: Dart scripts work on all platforms
- **Container friendly**: Compatible with Docker and container environments

## 📊 Coverage and Quality Integration

### Validation Scripts (Dart)
- **check_coverage.dart**: General coverage threshold validation
- **check_bloc_coverage.dart**: BLoC pattern specific validation
- **check_pages_coverage.dart**: Page/screen coverage validation
- **check_widgets_coverage.dart**: Widget coverage validation
- **analyze_check.dart**: Code analysis validation

### Quality Thresholds
- **Domain Module**: 90% coverage requirement
- **Infrastructure Module**: 60% coverage requirement
- **Presentation BLoC**: 50% coverage requirement
- **Presentation Widgets**: 40% coverage requirement

## 🔄 Relationship with Development Scripts

CI scripts complement development scripts with different focuses:
- **ci/**: Automation, precision, CI optimization
- **dev/**: Developer experience, detailed feedback, local workflow (see [../dev/](../dev/))

Both may perform similar tasks but with different priorities:
- CI scripts prioritize automation and reliable exit codes
- Dev scripts prioritize developer experience and detailed output