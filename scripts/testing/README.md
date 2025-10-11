# Testing Scripts

Scripts for running tests and generating coverage reports across the Flutter Cat Breeds project's modular architecture.

## 📁 Available Scripts

### `test_coverage.sh` (Linux/macOS/WSL)
Comprehensive test coverage script for all modules.

### `test_coverage.bat` (Windows)
Windows batch version of coverage testing.

### `sonar_coverage.sh` (Linux/macOS)
SonarCloud-compatible coverage generation.

## 🎯 Features

- **Modular coverage**: Separate coverage for Domain, Infrastructure, and Presentation layers
- **SonarCloud integration**: Compatible with SonarCloud analysis
- **Multi-platform support**: Scripts for different operating systems
- **Clean Architecture respect**: Follows the project's architectural boundaries

## 🚀 Usage

### Basic Coverage
```bash
# Linux/macOS/WSL
./scripts/testing/test_coverage.sh

# Windows
scripts\testing\test_coverage.bat
```

### SonarCloud Coverage
```bash
# Generate coverage for SonarCloud
./scripts/testing/sonar_coverage.sh
```

## 📊 Coverage Thresholds

The scripts support the project's coverage requirements:
- **Domain Module**: 90% coverage target
- **Infrastructure Module**: 60% coverage target  
- **Presentation BLoC**: 50% coverage target

## 🔧 Integration

These scripts work with:
- **GitHub Actions**: CI/CD pipeline integration
- **SonarCloud**: Quality gate analysis
- **Local development**: Developer workflow
- **Coverage tools**: Integration with `tool/ci/` Dart utilities

For coverage validation utilities, see [../tool/ci/](../../tool/ci/).