# Project Scripts

This directory contains organized development scripts for the Flutter Cat Breeds project. Scripts are organized by purpose to improve maintainability and discoverability.

## 📁 Directory Structure

### 🧹 [`cleanup/`](cleanup/)
Scripts for cleaning temporary and unnecessary files from the project.
- **Purpose**: Remove logs, temporary files, backup files, OS artifacts
- **Note**: Does NOT remove build artifacts (use `flutter clean`)
- **Platforms**: Windows (PowerShell, Batch), Linux/macOS (Bash)

### 🧪 [`testing/`](testing/)
Scripts for running tests and generating coverage reports.
- **Purpose**: Test execution, coverage generation, SonarCloud integration
- **Platforms**: Cross-platform with platform-specific optimizations

### ⚙️ [`setup/`](setup/)
Scripts for project setup and environment configuration.
- **Purpose**: SonarCloud setup, project initialization
- **Platforms**: Multiple platforms supported

### ⚡ [`performance/`](performance/)
Scripts for performance testing and benchmarking.
- **Purpose**: Performance analysis and optimization testing

### 🔗 [`api/`](api/)
API-related scripts and utilities.
- **Purpose**: API testing, documentation generation

## 🚀 Quick Start

Choose the appropriate script for your platform and needs:

```bash
# Cleanup (choose your platform)
.\scripts\cleanup\clean_project_working.ps1 -DryRun  # PowerShell (recommended)
scripts\cleanup\clean_project_simple.bat --dry-run   # Batch
./scripts/cleanup/clean_project.sh --dry-run         # Bash

# Testing
.\scripts\testing\test_coverage.ps1                  # PowerShell
./scripts/testing/test_coverage.sh                   # Bash

# Setup
.\scripts\setup\setup_sonarcloud.ps1                 # PowerShell
./scripts/setup/setup_sonarcloud.sh                  # Bash
```

## 📋 Script Categories

### File Management
- **cleanup/**: Remove unnecessary files safely
- **tool/ci/**: Dart utilities for CI/CD pipelines

### Testing & Quality
- **testing/**: Coverage reports and test execution
- **tool/ci/**: Coverage validation utilities

### Development Setup
- **setup/**: Environment configuration and tool setup

### Performance & Monitoring
- **performance/**: Performance testing and benchmarking

## �️ Maintenance

Each subdirectory contains its own README with specific usage instructions and platform requirements. When adding new scripts:

1. Choose the appropriate category
2. Follow naming conventions (verb_noun.extension)
3. Include help/usage information
4. Update the relevant subdirectory README
5. Test on target platforms

## 🏗️ Architecture Integration

These scripts respect the Clean Architecture principles:
- **Domain scripts**: Focus on business logic testing
- **Infrastructure scripts**: Handle external integrations
- **Presentation scripts**: UI/UX testing and validation

For more details, see [ARCHITECTURE.md](../ARCHITECTURE.md).

## 🚀 Usage Examples

### Basic Usage
```bash
# Linux/macOS/WSL
./scripts/clean_project.sh

# Windows PowerShell (Recommended)
.\scripts\clean_project_working.ps1

# Windows Command Prompt
scripts\clean_project_simple.bat
```

### Advanced Options

#### Dry Run (See what would be deleted)
```bash
# Bash
./scripts/clean_project.sh --dry-run

# PowerShell
.\scripts\clean_project.ps1 -DryRun

# Batch
scripts\clean_project_simple.bat --dry-run
```

#### Verbose Output
```bash
# Bash
./scripts/clean_project.sh --verbose

# PowerShell
.\scripts\clean_project_working.ps1 -Verbose

# Batch
scripts\clean_project_simple.bat --verbose
```

#### Interactive Mode (Ask before each category)
```bash
# Bash
./scripts/clean_project.sh --interactive

# PowerShell
.\scripts\clean_project.ps1 -Interactive
```

#### Combined Options
```bash
# Bash
./scripts/clean_project.sh --dry-run --verbose --interactive

# PowerShell
.\scripts\clean_project.ps1 -DryRun -Verbose -Interactive
```

## 🧹 What Gets Cleaned

### Build Artifacts
- `build/` - Main build directory
- `.dart_tool/` - Dart tool cache
- `module/*/build/` - Module build directories
- `module/*/.dart_tool/` - Module dart tool caches

### Coverage Reports
- `coverage/` - Main coverage reports
- `module/*/coverage/` - Module coverage reports
- `*.lcov.info` - Temporary coverage files

### Generated Files
- `*.g.dart` - Generated Dart files (json_annotation, etc.)
- `*.freezed.dart` - Freezed generated files
- `*.config.dart` - Configuration generated files

### IDE Files
- `.vscode/settings.json` - VS Code workspace settings
- `.idea/` - IntelliJ IDEA project files

### OS-Specific Files
- `.DS_Store` - macOS Finder metadata
- `Thumbs.db` - Windows thumbnail cache
- `desktop.ini` - Windows folder customization

### Temporary Files
- `*.log` - Log files
- `*.tmp` - Temporary files
- `*.temp` - Temp files
- `*.bak` - Backup files

### Platform Build Artifacts
- `ios/build/` - iOS build artifacts
- `android/build/` - Android build artifacts
- `web/build/` - Web build artifacts
- `windows/build/` - Windows build artifacts
- `linux/build/` - Linux build artifacts
- `macos/build/` - macOS build artifacts

### Pub Dependencies
- `pubspec_overrides.yaml` - Dependency overrides (main and modules)

### Flutter Cache
- `.flutter-plugins` - Flutter plugins cache
- `.flutter-plugins-dependencies` - Flutter plugins dependencies

## ⚠️ Important Notes

### What's NOT Cleaned
These scripts are conservative and **do not** remove:
- Source code files (`.dart` files that aren't generated)
- Configuration files (`pubspec.yaml`, `analysis_options.yaml`)
- Git files (`.git/`, `.gitignore`)
- Documentation files (`README.md`, `docs/`)
- Asset files (`assets/`, `fonts/`)
- Important IDE configs (`.vscode/launch.json`, `.vscode/tasks.json`)

### Safety Features
- **Dry run mode**: See what would be deleted without actually deleting
- **Interactive mode**: Confirm each category before deletion
- **Error handling**: Scripts continue even if some files can't be deleted
- **Verbose logging**: See exactly what's being processed

## 🔧 After Running Cleanup

After running any cleanup script, you should:

1. **Run Flutter clean**:
   ```bash
   flutter clean
   ```

2. **Restore dependencies**:
   ```bash
   flutter pub get
   cd module/domain && flutter pub get
   cd ../infrastructure && flutter pub get
   ```

3. **Rebuild if needed**:
   ```bash
   flutter build apk --debug  # or your preferred build command
   ```

## 🎯 Best Practices

### When to Use
- Before committing large changes
- When switching between branches with different dependencies
- When storage space is limited
- Before archiving or sharing the project
- When experiencing build issues that might be cache-related

### Automation
You can add these scripts to your development workflow:

```bash
# Example pre-commit hook
#!/bin/bash
./scripts/clean_project.sh --dry-run
if [ $? -eq 0 ]; then
    echo "✅ Project is clean"
else
    echo "⚠️ Consider running cleanup script"
fi
```

### CI/CD Integration
```yaml
# Example GitHub Action step
- name: Clean project before build
  run: |
    chmod +x scripts/clean_project.sh
    ./scripts/clean_project.sh
    flutter clean
    flutter pub get
```

## 🐛 Troubleshooting

### Permission Issues (Linux/macOS)
```bash
chmod +x scripts/clean_project.sh
```

### PowerShell Execution Policy (Windows)
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Files Still Present After Cleanup
Some files might be:
- Currently in use by an IDE or process
- Protected by file system permissions
- Symbolic links (handled specially by scripts)

### Script Errors
- Check that you're running from the project root directory
- Ensure you have necessary permissions to delete files
- Try running with `--verbose` to see detailed error messages

## 📊 Monitoring Results

The scripts provide feedback on:
- Number of files/directories removed
- Total size freed (where supported)
- Any errors encountered
- Recommendations for next steps

Example output:
```
🧹 Flutter Project Cleanup Script
=================================
📁 Build directories
  ✅ Removed 3 items
📊 Coverage reports  
  ✅ Removed 2 items
🔍 Generated Dart files (*.g.dart)
  ✅ Removed 15 files
...
🎉 Cleanup completed!
✅ Project cleaned successfully!

💡 Recommendations:
  • Run 'flutter clean' after this script
  • Run 'flutter pub get' to restore dependencies
  
📊 Current project size: 45.2 MB
```