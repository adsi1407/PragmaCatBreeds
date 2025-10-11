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
  -Help         Show this help message"
    exit 0
}

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

function Ask-Confirmation {
    param([string]$Message)
    if ($Interactive) {
        $response = Read-Host "$Message (y/N)"
        return $response -match '^[yY]([eE][sS])?$'
    }
    return $true
}

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
    }
}

function Remove-ByPattern {
    param(
        [string]$Description,
        [string]$Pattern
    )
    
    $foundFiles = @()
    try {
        $foundFiles = Get-ChildItem -Path . -Filter $Pattern -Recurse -File -ErrorAction SilentlyContinue
    } catch {
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
Remove-ByPattern "Generated Dart files" "*.g.dart"
Remove-ByPattern "Freezed files" "*.freezed.dart"
Remove-ByPattern "Config files" "*.config.dart"

# 4. IDE files
Remove-Items "IDE files" @(".idea")
if (Test-Path ".vscode\settings.json") {
    Remove-Items "VS Code settings" @(".vscode\settings.json")
}

# 5. OS files
Remove-ByPattern "DS_Store files" ".DS_Store"
Remove-ByPattern "Thumbs.db files" "Thumbs.db"
Remove-ByPattern "Desktop.ini files" "desktop.ini"

# 6. Log and temp files
Remove-ByPattern "Log files" "*.log"
Remove-ByPattern "Temp files" "*.tmp"
Remove-ByPattern "Backup files" "*.bak"

# Summary
Write-Host ""
Write-Host "🎉 Cleanup completed!" -ForegroundColor $Colors.Green

if ($DryRun) {
    Write-Host "📋 This was a dry run." -ForegroundColor $Colors.Yellow
} else {
    Write-Host "✅ Project cleaned!" -ForegroundColor $Colors.Green
}

Write-Host ""
Write-Host "💡 Next steps:" -ForegroundColor $Colors.Blue
Write-Host "  • Run 'flutter clean'" -ForegroundColor $Colors.Cyan
Write-Host "  • Run 'flutter pub get'" -ForegroundColor $Colors.Cyan