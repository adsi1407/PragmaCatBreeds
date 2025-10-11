# Project Scripts

Scripts organized by **usage pattern** for the Flutter Cat Breeds project. This structure separates development-focused scripts from CI/CD automation scripts for better workflow alignment.

## 📁 Directory Structure

### 🔨 [`dev/`](dev/) - Development Scripts
Scripts designed for **local development workflows** and developer productivity.
- **Purpose**: Developer tools, interactive scripts, detailed feedback
- **Usage**: Local development, debugging, optimization
- **Subdirectories**: [`cleanup/`](dev/cleanup/), [`environment/`](dev/environment/), [`performance/`](dev/performance/), [`api/`](dev/api/)

### � [`ci/`](ci/) - CI/CD Scripts  
Scripts designed for **automated CI/CD workflows** and continuous integration.
- **Purpose**: Automation, quality gates, validation
- **Usage**: GitHub Actions, CI pipelines, automated testing
- **Subdirectories**: [`sonar/`](ci/sonar/), [`testing/`](ci/testing/), [`validation/`](ci/validation/)

## 🚀 Quick Start

### Development Workflow
```bash
# Cleanup project (development)
.\scripts\dev\cleanup\clean_project_working.ps1 -DryRun  # PowerShell (recommended)
scripts\dev\cleanup\clean_project_simple.bat --dry-run   # Batch
./scripts/dev/cleanup/clean_project.sh --dry-run         # Bash

# Setup environment
./scripts/dev/environment/setup_development.sh           # Development setup

# Performance testing
./scripts/dev/performance/benchmark_app.sh               # Local benchmarking

# API testing
./scripts/dev/api/test_endpoints.sh                      # API validation
```

### CI/CD Usage
```bash
# SonarCloud integration
./scripts/ci/sonar/setup_sonarcloud.sh                   # CI setup

# Coverage validation (automated)
dart run scripts/ci/validation/check_coverage.dart coverage.lcov 90

# Test execution (CI-optimized)
./scripts/ci/testing/test_coverage.sh                    # CI testing
```

## 🎯 Usage Pattern Differences

### Development Scripts (`dev/`)
- **Interactive feedback**: Detailed output and progress indicators
- **Developer experience**: Helpful messages and error explanations  
- **Flexibility**: Multiple options and configurations
- **Local optimization**: Optimized for local development workflows

### CI/CD Scripts (`ci/`)
- **Automation focus**: Minimal output, clear exit codes
- **Reliability**: Consistent behavior across environments
- **Precision**: Exact success/failure indicators
- **Integration**: Designed for GitHub Actions and CI systems

## 🏗️ Architecture Integration

These scripts respect the Clean Architecture principles:
- **Domain scripts**: Focus on business logic testing (90% coverage threshold)
- **Infrastructure scripts**: Handle external integrations (60% coverage threshold)  
- **Presentation scripts**: UI/UX testing and validation (50% BLoC, 40% widgets coverage)

For more details, see [ARCHITECTURE.md](../ARCHITECTURE.md).
.\scripts\sonar\setup_sonarcloud.ps1                 # PowerShell
./scripts/sonar/setup_sonarcloud.sh                  # Bash
./scripts/sonar/sonar_coverage.sh                    # Bash

# Environment Setup
./scripts/environment/setup.sh                       # Bash
```

## �️ Maintenance

When adding new scripts:

1. **Choose appropriate category**: `dev/` for development tools, `ci/` for automation
2. **Follow naming conventions**: verb_noun.extension (e.g., `clean_project.ps1`, `check_coverage.dart`)
3. **Include help/usage information**: Clear documentation and help flags
4. **Update relevant README**: Document in subdirectory README and main README if significant
5. **Test on target platforms**: Verify cross-platform compatibility where applicable

### Script Guidelines

#### Development Scripts (`dev/`)
- Provide rich feedback and progress indicators
- Include detailed help and error messages
- Support interactive flags (dry-run, verbose, etc.)
- Optimize for developer productivity

#### CI Scripts (`ci/`)
- Focus on reliable automation
- Provide clear exit codes for CI systems  
- Minimize output unless debugging
- Ensure consistent behavior across environments

## 🏗️ Architecture Integration

These scripts respect the Clean Architecture principles:
- **Domain scripts**: Focus on business logic testing
- **Infrastructure scripts**: Handle external integrations
- **Presentation scripts**: UI/UX testing and validation

For more details, see [ARCHITECTURE.md](../ARCHITECTURE.md).

## � Related Documentation

- **[Development Scripts](dev/)**: Interactive tools for local development
- **[CI/CD Scripts](ci/)**: Automation tools for continuous integration  
- **[Architecture Guide](../ARCHITECTURE.md)**: Clean Architecture implementation details
- **[Security Documentation](../security/)**: Security scanning and validation processes

## 🚀 Usage Examples

### Development Workflow Examples
```bash
# Cleanup project (choose your platform)
.\scripts\dev\cleanup\clean_project_working.ps1 -DryRun  # PowerShell (recommended)
scripts\dev\cleanup\clean_project_simple.bat --dry-run   # Batch
./scripts/dev/cleanup/clean_project.sh --dry-run         # Bash

# Environment setup
./scripts/dev/environment/setup_development.sh           # Development setup

# Performance testing  
./scripts/dev/performance/benchmark_app.sh               # Local benchmarking
```

### CI/CD Automation Examples
```bash
# Coverage validation
dart run scripts/ci/validation/check_coverage.dart coverage.lcov 90

# SonarCloud integration
./scripts/ci/sonar/setup_sonarcloud.sh                   # CI setup

# Test execution (CI-optimized)
./scripts/ci/testing/test_coverage.sh                    # CI testing
```

### Advanced Options

#### Development Script Options
```bash
# Bash (dev cleanup)
./scripts/dev/cleanup/clean_project.sh --dry-run --verbose --interactive

# PowerShell (dev cleanup)
.\scripts\dev\cleanup\clean_project_working.ps1 -DryRun -Verbose -Interactive
```

#### CI Script Options  
```bash
# Coverage validation with specific thresholds
dart run scripts/ci/validation/check_coverage.dart coverage.lcov 90
dart run scripts/ci/validation/check_bloc_coverage.dart coverage.lcov 50

# Automated testing with CI optimization
./scripts/ci/testing/test_coverage.sh --ci-mode
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