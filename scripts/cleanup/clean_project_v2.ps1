# Project Cleanup Script - PowerShell Version 2.0
# Description: Removes build artifacts, temporary files, and other unnecessary project files
# Usage: .\clean_project_v2.ps1 [-DryRun] [-Verbose]
param(
    [switch]$DryRun,
    [switch]$Verbose
)

# Patterns for files to remove - Only truly unnecessary files
$patternsToRemove = @(
    # Temporary OS files
    "**\.DS_Store",
    "**\Thumbs.db",
    "**\desktop.ini",
    "**\*.swp",
    "**\*.swo",
    "**\*~",
    
    # IDE temporary files (not settings)
    "**\.vscode\.browse.VC.db*",
    "**\.vscode\ipch\**\*",
    "**\.idea\workspace.xml",
    "**\.idea\tasks.xml",
    "**\.idea\usage.statistics.xml",
    "**\.idea\shelf\**\*",
    
    # Log files and debug output
    "**\*.log",
    "**\debug.log",
    "**\error.log",
    "**\crash.log",
    "**\analyze_output.txt",
    
    # Temporary files
    "**\*.tmp",
    "**\*.temp",
    "**\*.cache",
    "**\*.pid",
    
    # Backup files
    "**\*.bak",
    "**\*.backup",
    "**\*.orig",
    
    # Package manager cache (not lock files)
    "**\.pub-cache\**\*",
    "**\node_modules\.cache\**\*"
)

# Function to write colored output
function Write-ColorOutput($ForegroundColor) {
    param (
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [string]$Message
    )
    if ($Host.UI.RawUI.ForegroundColor) {
        $originalColor = $Host.UI.RawUI.ForegroundColor
        $Host.UI.RawUI.ForegroundColor = $ForegroundColor
        Write-Output $Message
        $Host.UI.RawUI.ForegroundColor = $originalColor
    } else {
        Write-Output $Message
    }
}

Write-ColorOutput Green "=== Project Cleanup Script ==="

if ($DryRun) {
    Write-ColorOutput Yellow "=== DRY RUN MODE - No files will be deleted ==="
}

$totalCount = 0
$filesToRemove = @()

foreach ($pattern in $patternsToRemove) {
    try {
        $files = Get-ChildItem -Path $pattern -Recurse -Force -ErrorAction SilentlyContinue
        if ($files) {
            $filesToRemove += $files
            $totalCount += $files.Count
            
            if ($Verbose) {
                foreach ($file in $files) {
                    Write-ColorOutput Cyan "  Found: $($file.FullName)"
                }
            }
        }
    } catch {
        # Silently continue if pattern doesn't match anything
    }
}

Write-ColorOutput Yellow "Found $totalCount files to remove"

if ($DryRun) {
    Write-ColorOutput Yellow "This was a dry run. No files were actually deleted."
    Write-ColorOutput Cyan "Run without -DryRun to actually delete the files."
} else {
    $removedCount = 0
    foreach ($file in $filesToRemove) {
        try {
            Remove-Item -Path $file.FullName -Force -Recurse
            $removedCount++
            if ($Verbose) {
                Write-ColorOutput Green "  Removed: $($file.FullName)"
            }
        } catch {
            Write-ColorOutput Red "  Failed to remove: $($file.FullName) - $($_.Exception.Message)"
        }
    }
    Write-ColorOutput Green "Removed $removedCount files"
}

Write-ColorOutput Green "=== Cleanup completed ==="
Write-ColorOutput Cyan ""
Write-ColorOutput Cyan "Recommendations:"
Write-ColorOutput Cyan "  • This script only removes truly unnecessary files"
Write-ColorOutput Cyan "  • Use 'flutter clean' to remove build artifacts"
Write-ColorOutput Cyan "  • Use 'flutter pub get' if you need to restore dependencies"
Write-ColorOutput Cyan "  • Generated files (.g.dart, .mocks.dart) are preserved"
Write-ColorOutput Cyan "  • Run this script periodically to clean temporary files"