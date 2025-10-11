# Development Scripts

Scripts designed for **local development workflow** and developer productivity. These scripts are primarily used by developers on their local machines for day-to-day development tasks.

## 📁 Directory Structure

### 🧹 [`cleanup/`](cleanup/)
Scripts for cleaning temporary and unnecessary files from the project.
- **Usage**: Local development maintenance
- **Purpose**: Remove logs, temporary files, backup files, OS artifacts
- **Note**: Does NOT remove build artifacts (use `flutter clean`)

### ⚙️ [`environment/`](environment/)
Scripts for development environment setup and configuration.
- **Usage**: Initial setup, onboarding new developers
- **Purpose**: Environment setup, dependency installation

### ⚡ [`performance/`](performance/)
Scripts for performance testing and benchmarking.
- **Usage**: Local performance analysis and optimization
- **Purpose**: Performance testing, profiling, optimization insights

### 🔗 [`api/`](api/)
API-related scripts and utilities.
- **Usage**: Local API testing and development
- **Purpose**: API endpoint testing, documentation generation

## 🎯 Primary Use Cases

### For Developers
- **Daily workflow**: Cleanup, testing, environment management
- **Debugging**: Performance analysis, API testing
- **Maintenance**: Project cleanup, dependency management
- **Setup**: Initial environment configuration

### Development Workflow Integration
- **IDE integration**: Can be called from IDEs or terminals
- **Local testing**: Pre-commit validation and testing
- **Environment management**: Setup and maintenance scripts
- **Productivity tools**: Automation for repetitive tasks

## 🚀 Quick Start Examples

```bash
# Environment setup (first time)
./scripts/dev/environment/setup.sh

# Clean project files
.\scripts\dev\cleanup\clean_project_working.ps1 -DryRun

# Performance analysis
./scripts/dev/performance/performance_test.sh

# API testing
dart run scripts/dev/api/test_endpoints.dart
```

## 🛠️ Platform Support

- **Linux/macOS/WSL**: Full support with Bash scripts
- **Windows**: PowerShell and Batch script alternatives
- **Cross-platform**: Dart scripts work everywhere

## 🔄 Relationship with CI Scripts

These development scripts complement CI scripts but serve different purposes:
- **dev/**: Local developer workflow and productivity
- **ci/**: Automated validation and analysis (see [../ci/](../ci/))

Some scripts may be similar but optimized for different contexts:
- dev scripts prioritize developer experience and detailed output
- CI scripts prioritize automation and precise exit codes