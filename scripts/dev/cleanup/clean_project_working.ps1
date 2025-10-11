# Project Cleanup Script - PowerShell Version 3.0
# Description: Removes build artifacts, temporary files, and other unnecessary project files
# Usage: .\clean_project_working.ps1 [-DryRun] [-Verbose]
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

Write-Host "=== Project Cleanup Script ===" -ForegroundColor Green

if ($DryRun) {
    Write-Host "=== DRY RUN MODE - No files will be deleted ===" -ForegroundColor Yellow
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
                    Write-Host "  Found: $($file.FullName)" -ForegroundColor Cyan
                }
            }
        }
    } catch {
        # Silently continue if pattern doesn't match anything
    }
}

Write-Host "Found $totalCount files to remove" -ForegroundColor Yellow

if ($DryRun) {
    Write-Host "This was a dry run. No files were actually deleted." -ForegroundColor Yellow
    Write-Host "Run without -DryRun to actually delete the files." -ForegroundColor Cyan
} else {
    $removedCount = 0
    foreach ($file in $filesToRemove) {
        try {
            Remove-Item -Path $file.FullName -Force -Recurse
            $removedCount++
            if ($Verbose) {
                Write-Host "  Removed: $($file.FullName)" -ForegroundColor Green
            }
        } catch {
            Write-Host "  Failed to remove: $($file.FullName) - $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    Write-Host "Removed $removedCount files" -ForegroundColor Green
}

Write-Host "=== Cleanup completed ===" -ForegroundColor Green
Write-Host ""
Write-Host "Recommendations:" -ForegroundColor Cyan
Write-Host "  • This script only removes truly unnecessary files" -ForegroundColor Cyan
Write-Host "  • Use 'flutter clean' to remove build artifacts" -ForegroundColor Cyan
Write-Host "  • Use 'flutter pub get' if you need to restore dependencies" -ForegroundColor Cyan
Write-Host "  • Generated files (.g.dart, .mocks.dart) are preserved" -ForegroundColor Cyan
Write-Host "  • Run this script periodically to clean temporary files" -ForegroundColor Cyan