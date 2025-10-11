@echo off
setlocal enabledelayedexpansion

REM Clean Project Script - Simplified Batch version for Windows
REM Remove only truly unnecessary files from project

set "DRY_RUN=false"
set "VERBOSE=false"

REM Parse command line arguments
:parse_args
if "%1"=="--dry-run" (
    set "DRY_RUN=true"
    shift
    goto parse_args
)
if "%1"=="-d" (
    set "DRY_RUN=true"
    shift
    goto parse_args
)
if "%1"=="--verbose" (
    set "VERBOSE=true"
    shift
    goto parse_args
)
if "%1"=="-v" (
    set "VERBOSE=true"
    shift
    goto parse_args
)
if "%1"=="--help" (
    echo Usage: clean_project_simple.bat [OPTIONS]
    echo.
    echo Options:
    echo   --dry-run, -d     Show what would be deleted without actually deleting
    echo   --verbose, -v     Show detailed output
    echo   --help, -h        Show this help message
    echo.
    echo This script only removes truly unnecessary files:
    echo   • Temporary files (*.tmp, *.temp, *.cache)
    echo   • Log files (*.log)
    echo   • Backup files (*.bak, *.backup, *.orig)
    echo   • OS files (.DS_Store, Thumbs.db, desktop.ini)
    echo   • Editor swap files (*.swp, *.swo, *~)
    echo.
    echo Use 'flutter clean' to remove build artifacts
    goto :eof
)
if "%1"=="-h" goto help
if not "%1"=="" (
    echo Unknown option: %1
    goto :eof
)

if "%DRY_RUN%"=="true" (
    echo === DRY RUN MODE - No files will be deleted ===
    echo.
)

echo === Project Cleanup Script ===
echo This script only removes truly unnecessary files
echo.

set "total_count=0"

REM Patterns for truly unnecessary files
set patterns=*.log debug.log error.log crash.log *.tmp *.temp *.cache *.pid *.bak *.backup *.orig .DS_Store Thumbs.db desktop.ini *.swp *.swo analyze_output.txt

echo Searching for unnecessary files...
echo.

for %%p in (%patterns%) do (
    for /r . %%f in (%%p) do (
        set /a total_count+=1
        if "%VERBOSE%"=="true" (
            echo   Found: %%f
        )
        if "%DRY_RUN%"=="false" (
            if "%VERBOSE%"=="true" (
                echo   Removing: %%f
            )
            del "%%f" 2>nul
        )
    )
)

echo.
if "%total_count%"=="0" (
    echo No unnecessary files found.
) else (
    if "%DRY_RUN%"=="true" (
        echo Would remove !total_count! unnecessary files
    ) else (
        echo Removed !total_count! unnecessary files
    )
)

echo.
echo === Cleanup completed ===
echo.
echo Recommendations:
echo   • This script only removes truly unnecessary files
echo   • Use 'flutter clean' to remove build artifacts
echo   • Use 'flutter pub get' if you need to restore dependencies
echo   • Generated files (.g.dart, .mocks.dart) are preserved
echo   • Run this script periodically to clean temporary files

pause