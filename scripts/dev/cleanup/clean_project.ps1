# Clean Project Script - PowerShell version
# Remove unnecessary files from Flutter project

param(
    [switch]$DryRun,
    [switch]$Verbose,
    [switch]$Interactive,
    [switch]$Help
)

if ($Help) {
    Write-Host "Usage: .\clean_project.ps1 [OPTIONS]

Options:
  -DryRun       Show what would be deleted without actually deleting
  -Verbose      Show detailed output
  -Interactive  Ask before deleting each category
  -Help         Show this help message

Categories cleaned:
  • Build artifacts (build/, .dart_tool/)
  • Coverage reports (coverage/)
  • Generated files (*.g.dart, *.freezed.dart)
  • IDE files (.vscode/, .idea/)
  • OS files (.DS_Store, Thumbs.db)
  • Log files (*.log)
  • Temporary files (*.tmp, *.temp)"
    exit 0
}

# Colors for PowerShell
$Colors = @{
    Red = "Red"
    Green = "Green" 
    Blue = "Blue"
    Yellow = "Yellow"
    Cyan = "Cyan"
    White = "White"
}

Write-Host "🧹 Flutter Project Cleanup Script" -ForegroundColor $Colors.Blue
Write-Host "=================================" -ForegroundColor $Colors.Blue

if ($DryRun) {
    Write-Host "🔍 DRY RUN MODE - No files will be deleted" -ForegroundColor $Colors.Yellow
}

# Function to ask for confirmation
function Ask-Confirmation {
    param([string]$Message)
    
    if ($Interactive) {
        $response = Read-Host "$Message (y/N)"
        return $response -match '^[yY]([eE][sS])?$'
    }
    return $true
}

# Function to remove items safely
function Remove-Items {
    param(
        [string]$Description,
        [string[]]$Items
    )
    
    $foundItems = @()
    foreach ($item in $Items) {
        if (Test-Path $item) {
            $foundItems += $item
        }
    }
    
    if ($foundItems.Count -eq 0) {
        if ($Verbose) {
            Write-Host "  ⚪ $Description - No items found" -ForegroundColor $Colors.Yellow
        }
        return
    }
    
    Write-Host "📁 $Description" -ForegroundColor $Colors.Blue
    
    if (Ask-Confirmation "Remove $Description?") {
        foreach ($item in $foundItems) {
            if ($Verbose -or $DryRun) {
                Write-Host "    📄 $item" -ForegroundColor $Colors.Cyan
            }
            
            if (-not $DryRun) {
                if (Test-Path $item -PathType Container) {
                    Remove-Item $item -Recurse -Force -ErrorAction SilentlyContinue
                } else {
                    Remove-Item $item -Force -ErrorAction SilentlyContinue
                }
            }
        }
        
        if (-not $DryRun) {
            Write-Host "  ✅ Removed $($foundItems.Count) items" -ForegroundColor $Colors.Green
        } else {
            Write-Host "  📋 Would remove $($foundItems.Count) items" -ForegroundColor $Colors.Yellow
        }
    } else {
        Write-Host "  ⏭️  Skipped $Description" -ForegroundColor $Colors.Yellow
    }
}

# Function to remove files by pattern
function Remove-ByPattern {
    param(
        [string]$Description,
        [string]$Pattern
    )
    
    $foundFiles = @()
    try {
        $foundFiles = Get-ChildItem -Path . -Filter $Pattern -Recurse -File -ErrorAction SilentlyContinue
    } catch {
        # Ignore errors for patterns that don't match
    }
    
    if ($foundFiles.Count -eq 0) {
        if ($Verbose) {
            Write-Host "  ⚪ $Description - No files found" -ForegroundColor $Colors.Yellow
        }
        return
    }
    
    Write-Host "🔍 $Description" -ForegroundColor $Colors.Blue
    
    if (Ask-Confirmation "Remove $Description?") {
        foreach ($file in $foundFiles) {
            if ($Verbose -or $DryRun) {
                Write-Host "    📄 $($file.FullName)" -ForegroundColor $Colors.Cyan
            }
            
            if (-not $DryRun) {
                Remove-Item $file.FullName -Force -ErrorAction SilentlyContinue
            }
        }
        
        if (-not $DryRun) {
            Write-Host "  ✅ Removed $($foundFiles.Count) files" -ForegroundColor $Colors.Green
        } else {
            Write-Host "  📋 Would remove $($foundFiles.Count) files" -ForegroundColor $Colors.Yellow
        }
    } else {
        Write-Host "  ⏭️  Skipped $Description" -ForegroundColor $Colors.Yellow
    }
}

Write-Host ""
Write-Host "Starting cleanup..." -ForegroundColor $Colors.Cyan
Write-Host ""

# 1. Build artifacts and cache
Remove-Items "Build directories" @(
    "build",
    ".dart_tool",
    "module\domain\build",
    "module\domain\.dart_tool",
    "module\infrastructure\build",
    "module\infrastructure\.dart_tool"
)

# 2. Coverage reports
Remove-Items "Coverage reports" @(
    "coverage",
    "module\domain\coverage",
    "module\infrastructure\coverage"
)

# 3. Generated files
Remove-ByPattern "Generated Dart files (*.g.dart)" "*.g.dart"
Remove-ByPattern "Freezed files (*.freezed.dart)" "*.freezed.dart"
Remove-ByPattern "Config files (*.config.dart)" "*.config.dart"

# 4. IDE configuration files
Remove-Items "IDE configuration files" @(
    ".vscode\settings.json",
    ".idea"
)

# 5. OS-specific files
Remove-ByPattern "macOS DS_Store files" ".DS_Store"
Remove-ByPattern "Windows Thumbs.db files" "Thumbs.db"
Remove-ByPattern "Windows desktop.ini files" "desktop.ini"

# 6. Log files
Remove-ByPattern "Log files" "*.log"

# 7. Temporary files
Remove-ByPattern "Temporary files (.tmp)" "*.tmp"
Remove-ByPattern "Temporary files (.temp)" "*.temp"
Remove-ByPattern "Backup files (.bak)" "*.bak"

# 8. Platform-specific build artifacts
Remove-Items "Platform build artifacts" @(
    "ios\build",
    "android\build",
    "web\build",
    "windows\build",
    "linux\build",
    "macos\build"
)

# 9. Pub cache issues
Remove-Items "Pub dependency overrides" @(
    "pubspec_overrides.yaml",
    "module\domain\pubspec_overrides.yaml",
    "module\infrastructure\pubspec_overrides.yaml"
)

# 10. Flutter specific temporary files
Remove-ByPattern "Flutter plugins cache" ".flutter-plugins"
Remove-ByPattern "Flutter plugins dependencies" ".flutter-plugins-dependencies"

# 11. Test related temporary files
Remove-ByPattern "Test coverage temp files" "*.lcov.info"
Remove-ByPattern "Test report files" "test-results.xml"

# Summary
Write-Host ""
Write-Host "🎉 Cleanup completed!" -ForegroundColor $Colors.Green

if ($DryRun) {
    Write-Host "📋 This was a dry run. No files were actually deleted." -ForegroundColor $Colors.Yellow
    Write-Host "💡 Run without -DryRun to actually delete the files." -ForegroundColor $Colors.Cyan
} else {
    Write-Host "✅ Project cleaned successfully!" -ForegroundColor $Colors.Green
}

# Recommendations
Write-Host ""
Write-Host "💡 Recommendations:" -ForegroundColor $Colors.Blue
Write-Host "  • Run 'flutter clean' after this script" -ForegroundColor $Colors.Cyan
Write-Host "  • Run 'flutter pub get' to restore dependencies" -ForegroundColor $Colors.Cyan
Write-Host "  • Consider adding more patterns to .gitignore" -ForegroundColor $Colors.Cyan
Write-Host "  • Run this script before committing large changes" -ForegroundColor $Colors.Cyan

# Show current directory size
try {
    $size = (Get-ChildItem -Path . -Recurse -File | Measure-Object -Property Length -Sum).Sum
    $sizeFormatted = if ($size -gt 1GB) {
        "{0:N2} GB" -f ($size / 1GB)
    } elseif ($size -gt 1MB) {
        "{0:N2} MB" -f ($size / 1MB)
    } elseif ($size -gt 1KB) {
        "{0:N2} KB" -f ($size / 1KB)
    } else {
        "$size bytes"
    }
    
    Write-Host ""
    Write-Host "📊 Current project size:" -ForegroundColor $Colors.Blue
    Write-Host "  Total: $sizeFormatted" -ForegroundColor $Colors.Cyan
} catch {
    # Ignore errors calculating size
}