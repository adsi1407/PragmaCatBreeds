# Environment Setup Scripts

Scripts for initial development environment configuration and dependency installation.

## 📁 Available Scripts

### `setup.sh` (Linux/macOS/WSL)
Comprehensive development environment setup and initialization.

## 🎯 Features

### Development Environment Setup
- **Flutter SDK verification**: Ensures Flutter is properly installed and accessible
- **Dependency installation**: Installs all project and module dependencies
- **Clean initialization**: Performs flutter clean and fresh dependency resolution
- **Module configuration**: Sets up domain and infrastructure modules
- **Development readiness**: Prepares complete development environment

## 🚀 Usage

### Initial Environment Setup
```bash
# Linux/macOS/WSL - Complete environment setup
./scripts/environment/setup.sh

# This will:
# 1. Verify Flutter installation and version
# 2. Clean any previous builds
# 3. Install main app dependencies
# 4. Install domain module dependencies
# 5. Install infrastructure module dependencies
# 6. Verify successful setup
# 7. Provide next steps guidance
```

## 📋 What Gets Configured

### Flutter Environment
- **Flutter SDK**: Verification and version check
- **Project dependencies**: Main application dependencies via `flutter pub get`
- **Domain module**: Module-specific dependencies and setup
- **Infrastructure module**: External service integration dependencies
- **Clean state**: Removes build artifacts for fresh start

### Development Tools
- **Test environment**: Prepares testing framework
- **Coverage tools**: Sets up coverage generation capabilities
- **Module architecture**: Configures Clean Architecture modules
- **Development workflow**: Readiness for coding and testing

## 🔧 Prerequisites

### System Requirements
- **Flutter SDK**: Installed and in system PATH
- **Git**: For version control operations (automatic in most setups)
- **Internet connection**: Required for dependency downloads
- **Sufficient disk space**: For dependencies and build tools

### Platform-Specific Notes
- **Linux**: Usually works out of the box
- **macOS**: May require Xcode command line tools
- **WSL**: Works well with Flutter installed in WSL environment

## ✅ Verification Steps

The script verifies:
1. **Flutter accessibility**: `flutter --version` succeeds
2. **Dependency resolution**: All `pub get` commands succeed
3. **Module integrity**: Domain and infrastructure modules are properly configured
4. **Environment readiness**: All tools are available for development

## 🔄 When to Run

Run this script when:
- **First time setup**: New development machine or fresh clone
- **After major updates**: Flutter SDK updates or major dependency changes
- **Clean environment needed**: Starting fresh after issues
- **New team member**: Onboarding new developers
- **CI/CD setup**: Preparing automated build environments

## 🛠️ Troubleshooting

### Common Issues
1. **Flutter not found**: Ensure Flutter is in your PATH
2. **Permission denied**: Make script executable with `chmod +x scripts/environment/setup.sh`
3. **Network issues**: Check internet connection for dependency downloads
4. **Disk space**: Ensure sufficient space for dependencies

### Success Indicators
- ✅ Flutter version displays correctly
- ✅ All `pub get` commands complete successfully
- ✅ No error messages during module setup
- ✅ Final success message with next steps

## 🎯 Next Steps After Setup

After successful environment setup:
1. Run tests: `./scripts/testing/test_coverage.sh`
2. Start development: Begin coding in your preferred IDE
3. Set up SonarCloud: `./scripts/sonar/setup_sonarcloud.sh` (if needed)
4. Performance testing: `./scripts/performance/performance_test.sh` (optional)