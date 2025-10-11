# Installation & Configuration Scripts

Scripts for setting up the development environment and configuring external tools for the Flutter Cat Breeds project.

## 📁 Available Scripts

### `setup_sonarcloud.ps1` (Windows PowerShell)
PowerShell script for SonarCloud setup and configuration.

### `setup_sonarcloud.sh` (Linux/macOS/WSL)
Bash script for SonarCloud setup and configuration.

### `setup.sh` (Linux/macOS/WSL)
General project setup script.

## 🎯 Features

- **SonarCloud Integration**: Automated SonarCloud project setup
- **Environment Configuration**: Development environment preparation
- **Multi-platform Support**: Scripts for different operating systems
- **Automated Setup**: Minimal manual intervention required

## 🚀 Usage

### SonarCloud Setup
```bash
# Windows PowerShell
.\scripts\install\setup_sonarcloud.ps1

# Linux/macOS/WSL
./scripts/install/setup_sonarcloud.sh
```

### General Setup
```bash
# Linux/macOS/WSL
./scripts/install/setup.sh
```

## ⚙️ Prerequisites

### For SonarCloud Setup:
- SonarCloud account and organization
- Project token (generated from SonarCloud)
- Git repository properly configured

### For General Setup:
- Flutter SDK installed
- Git configured
- Platform-specific dependencies

## 🔧 What Gets Configured

### SonarCloud Setup:
- Project binding configuration
- Coverage thresholds per module
- Quality gate settings
- Integration with CI/CD pipeline

### General Setup:
- Development dependencies
- Git hooks (if applicable)
- IDE configurations
- Build tool setup

## 🛠️ Customization

Scripts support environment variables and configuration files for:
- Organization keys
- Project tokens
- Custom thresholds
- Platform-specific settings

Check individual script help for detailed options.