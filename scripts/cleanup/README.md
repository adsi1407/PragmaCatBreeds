# Cleanup Scripts

Scripts for cleaning **truly unnecessary files** from your Flutter project. These scripts complement `flutter clean` by removing temporary files, logs, and other artifacts that aren't handled by Flutter's built-in cleanup.

## 🎯 What These Scripts Clean

### ✅ Files That ARE Cleaned:
- **Temporary files**: `*.tmp`, `*.temp`, `*.cache`, `*.pid`
- **Log files**: `*.log`, `debug.log`, `error.log`, `crash.log`
- **Backup files**: `*.bak`, `*.backup`, `*.orig`
- **OS files**: `.DS_Store`, `Thumbs.db`, `desktop.ini`
- **Editor swap files**: `*.swp`, `*.swo`, `*~`
- **IDE temporary files**: workspace caches, browsing databases
- **Analysis output**: `analyze_output.txt`

### ❌ Files That ARE NOT Cleaned:
- **Build artifacts**: Use `flutter clean` instead
- **Generated files**: `*.g.dart`, `*.freezed.dart`, `*.mocks.dart` (needed for development)
- **Lock files**: `pubspec.lock` (needed for dependency consistency)
- **Coverage reports**: `coverage/` (useful for analysis)
- **IDE settings**: `.vscode/settings.json`, `.idea/` configs (user preferences)

## 📁 Available Scripts

### 1. `clean_project_working.ps1` (Windows PowerShell) ⭐ Recommended
PowerShell script with colored output and comprehensive pattern matching.

### 2. `clean_project_simple.bat` (Windows Command Prompt)
Simple batch script for basic cleanup operations.

### 3. `clean_project.sh` (Linux/macOS/WSL)
Bash script with full feature set including interactive mode and detailed reporting.

## 🚀 Usage Examples

### Basic Usage
```bash
# Linux/macOS/WSL
./scripts/cleanup/clean_project.sh

# Windows PowerShell (Recommended)
.\scripts\cleanup\clean_project_working.ps1

# Windows Command Prompt
scripts\cleanup\clean_project_simple.bat
```

### Advanced Options

#### Dry Run (Recommended first run)
```bash
# Bash
./scripts/cleanup/clean_project.sh --dry-run

# PowerShell
.\scripts\cleanup\clean_project_working.ps1 -DryRun

# Batch
scripts\cleanup\clean_project_simple.bat --dry-run
```

#### Verbose Output
```bash
# Bash
./scripts/cleanup/clean_project.sh --verbose

# PowerShell
.\scripts\cleanup\clean_project_working.ps1 -Verbose

# Batch
scripts\cleanup\clean_project_simple.bat --verbose
```

#### Interactive Mode (Ask before each category)
```bash
# Bash
./scripts/cleanup/clean_project.sh --interactive
```

## 🔧 Script Details

### PowerShell Scripts
- **Prerequisites**: PowerShell 5.1+ (Windows) or PowerShell Core (cross-platform)
- **Execution Policy**: May require `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
- **Features**: Colored output, comprehensive error handling, detailed reporting

### Bash Scripts
- **Prerequisites**: Bash 4.0+, standard Unix utilities
- **Features**: Interactive mode, comprehensive categorization, size reporting

### Batch Scripts
- **Prerequisites**: Windows Command Prompt
- **Features**: Simple operation, wide compatibility, basic pattern matching

## 🛡️ Safety Features

- **Dry run mode**: Preview what would be deleted
- **Verbose output**: See exactly what's being processed
- **Error handling**: Graceful handling of permission issues
- **Selective cleaning**: Only removes truly unnecessary files

## 🔄 Integration

These scripts can be run:
- **Before commits**: Clean up development artifacts
- **Periodically**: Maintain clean workspace
- **In CI/CD**: As part of cleanup pipeline (with caution)
- **After development sessions**: Remove temporary files

## 🎛️ Customization

To add new patterns:
1. Edit the `$patternsToRemove` array (PowerShell) or `PATTERNS` array (Bash)
2. Test with `--dry-run` first
3. Ensure patterns are specific enough to avoid false positives
4. Document the purpose of new patterns