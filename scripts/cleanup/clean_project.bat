@echo off
setlocal enabledelayedexpansion

REM Clean Project Script - Batch version for Windows
REM Remove unnecessary files from Flutter project

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
    goto show_help
)
if "%1"=="-h" (
    goto show_help
)
if "%1" neq "" (
    shift
    goto parse_args
)

echo.
echo 🧹 Flutter Project Cleanup Script
echo =================================
echo.

if "%DRY_RUN%"=="true" (
    echo 🔍 DRY RUN MODE - No files will be deleted
    echo.
)

echo Starting cleanup...
echo.

REM Function to clean directories
echo 📁 Cleaning build directories...
call :clean_directory "build" "Build directory"
call :clean_directory ".dart_tool" "Dart tool cache"
call :clean_directory "module\domain\build" "Domain module build"
call :clean_directory "module\domain\.dart_tool" "Domain module dart tool"
call :clean_directory "module\infrastructure\build" "Infrastructure module build"
call :clean_directory "module\infrastructure\.dart_tool" "Infrastructure module dart tool"

echo.
echo 📊 Cleaning coverage reports...
call :clean_directory "coverage" "Coverage reports"
call :clean_directory "module\domain\coverage" "Domain coverage"
call :clean_directory "module\infrastructure\coverage" "Infrastructure coverage"

echo.
echo 🔍 Cleaning generated files...
call :clean_pattern "*.g.dart" "Generated Dart files"
call :clean_pattern "*.freezed.dart" "Freezed files"
call :clean_pattern "*.config.dart" "Config files"

echo.
echo 💻 Cleaning IDE files...
call :clean_directory ".idea" "IntelliJ IDEA files"
if exist ".vscode\settings.json" (
    call :clean_file ".vscode\settings.json" "VS Code settings"
)

echo.
echo 🗂️ Cleaning OS files...
call :clean_pattern ".DS_Store" "macOS DS_Store files"
call :clean_pattern "Thumbs.db" "Windows thumbnail cache"
call :clean_pattern "desktop.ini" "Windows desktop files"

echo.
echo 📝 Cleaning temporary files...
call :clean_pattern "*.log" "Log files"
call :clean_pattern "*.tmp" "Temporary files"
call :clean_pattern "*.temp" "Temp files"
call :clean_pattern "*.bak" "Backup files"

echo.
echo 🏗️ Cleaning platform build artifacts...
call :clean_directory "ios\build" "iOS build"
call :clean_directory "android\build" "Android build"
call :clean_directory "web\build" "Web build"
call :clean_directory "windows\build" "Windows build"
call :clean_directory "linux\build" "Linux build"
call :clean_directory "macos\build" "macOS build"

echo.
echo 📦 Cleaning pub overrides...
call :clean_file "pubspec_overrides.yaml" "Main pubspec overrides"
call :clean_file "module\domain\pubspec_overrides.yaml" "Domain pubspec overrides"
call :clean_file "module\infrastructure\pubspec_overrides.yaml" "Infrastructure pubspec overrides"

echo.
echo 🔧 Cleaning Flutter cache files...
call :clean_pattern ".flutter-plugins" "Flutter plugins cache"
call :clean_pattern ".flutter-plugins-dependencies" "Flutter plugins dependencies"

echo.
echo 🧪 Cleaning test artifacts...
call :clean_pattern "*.lcov.info" "Coverage temp files"
call :clean_pattern "test-results.xml" "Test result files"

echo.
echo 🎉 Cleanup completed!
echo.

if "%DRY_RUN%"=="true" (
    echo 📋 This was a dry run. No files were actually deleted.
    echo 💡 Run without --dry-run to actually delete the files.
) else (
    echo ✅ Project cleaned successfully!
)

echo.
echo 💡 Recommendations:
echo   • Run 'flutter clean' after this script
echo   • Run 'flutter pub get' to restore dependencies
echo   • Consider adding more patterns to .gitignore
echo   • Run this script before committing large changes

goto end

:show_help
echo Usage: %0 [OPTIONS]
echo.
echo Options:
echo   --dry-run, -d     Show what would be deleted without actually deleting
echo   --verbose, -v     Show detailed output
echo   --help, -h        Show this help message
echo.
echo Categories cleaned:
echo   • Build artifacts (build/, .dart_tool/)
echo   • Coverage reports (coverage/)
echo   • Generated files (*.g.dart, *.freezed.dart)
echo   • IDE files (.vscode/, .idea/)
echo   • OS files (.DS_Store, Thumbs.db)
echo   • Log files (*.log)
echo   • Temporary files (*.tmp, *.temp)
goto end

:clean_directory
if exist "%~1" (
    if "%VERBOSE%"=="true" (
        echo   📄 %~1
    )
    if "%DRY_RUN%"=="false" (
        rmdir /s /q "%~1" 2>nul
        if not exist "%~1" (
            echo   ✅ Removed %~2
        )
    ) else (
        echo   📋 Would remove %~2
    )
) else (
    if "%VERBOSE%"=="true" (
        echo   ⚪ %~2 - Not found
    )
)
goto :eof

:clean_file
if exist "%~1" (
    if "%VERBOSE%"=="true" (
        echo   📄 %~1
    )
    if "%DRY_RUN%"=="false" (
        del /q "%~1" 2>nul
        if not exist "%~1" (
            echo   ✅ Removed %~2
        )
    ) else (
        echo   📋 Would remove %~2
    )
) else (
    if "%VERBOSE%"=="true" (
        echo   ⚪ %~2 - Not found
    )
)
goto :eof

:clean_pattern
set "found_files=0"
for /r %%f in (%~1) do (
    set /a found_files+=1
    if "%VERBOSE%"=="true" (
        echo   📄 %%f
    )
    if "%DRY_RUN%"=="false" (
        del /q "%%f" 2>nul
    )
)

if !found_files! gtr 0 (
    if "%DRY_RUN%"=="false" (
        echo   ✅ Removed !found_files! %~2
    ) else (
        echo   📋 Would remove !found_files! %~2
    )
) else (
    if "%VERBOSE%"=="true" (
        echo   ⚪ %~2 - No files found
    )
)
goto :eof

:end
pause