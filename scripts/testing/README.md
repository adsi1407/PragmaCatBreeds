# Testing Scripts

Scripts for running tests and generating coverage reports for development workflow and general CI integration.

## 📁 Available Scripts

### `test_coverage.sh` (Linux/macOS/WSL)
Comprehensive test coverage script for development workflow.

### `test_coverage.bat` (Windows)
Windows batch version of coverage testing.

### `run_tests_windows.ps1` (Windows PowerShell)
Windows-specific test execution script.

## 🎯 Features

- **Modular coverage**: Separate coverage for Domain, Infrastructure, and Presentation layers
- **Development workflow**: Optimized for local development and debugging
- **Multi-platform support**: Scripts for different operating systems
- **Clean Architecture respect**: Follows the project's architectural boundaries
- **CI compatibility**: Compatible with general CI/CD pipelines

## 🚀 Usage

### Basic Coverage
```bash
# Linux/macOS/WSL
./scripts/testing/test_coverage.sh

# Windows
scripts\testing\test_coverage.bat

# Windows PowerShell
.\scripts\testing\run_tests_windows.ps1
```

## 📊 Coverage Thresholds

The scripts support the project's coverage requirements:
- **Domain Module**: 90% coverage target
- **Infrastructure Module**: 60% coverage target  
- **Presentation BLoC**: 50% coverage target
- **Presentation Widgets**: 40% coverage target

## 🔧 Integration

These scripts work with:
- **GitHub Actions**: General CI/CD pipeline integration
- **Local development**: Developer workflow
- **Coverage tools**: Integration with `tool/ci/` Dart utilities
- **IDEs**: Compatible with most Flutter development environments

For SonarCloud-specific coverage and analysis, see [../sonar/](../sonar/).