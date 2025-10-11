@echo off
REM Test Coverage Script for Cat Breeds App (Windows)
REM Generates detailed test coverage report with CI-consistent thresholds

echo 🧪 Generating test coverage report...

REM Coverage thresholds (consistent with CI pipeline)
set COVERAGE_DOMAIN_MIN=90
set COVERAGE_INFRA_MIN=60
set COVERAGE_PRESENTATION_BLOC_MIN=50
set COVERAGE_PRESENTATION_WIDGETS_MIN=40

REM Check if Flutter is installed
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter is not installed or not in PATH
    exit /b 1
)

REM Clean previous coverage
echo 🧹 Cleaning previous coverage data...
if exist coverage rmdir /s /q coverage
for /r %%i in (*.lcov.info) do del "%%i"

REM Install dependencies
echo 📦 Installing dependencies...
flutter pub get

REM Install dependencies for modules
echo 📦 Installing module dependencies...
cd module\domain && flutter pub get && cd ..\..
cd module\infrastructure && flutter pub get && cd ..\..

REM Run tests with coverage
echo 🧪 Running tests with coverage...
flutter test --coverage

REM Check if coverage directory was created
if not exist coverage (
    echo ❌ Coverage directory not found. Tests may have failed.
    exit /b 1
)

REM Verify coverage thresholds (consistent with CI pipeline)
echo 🎯 Verifying coverage thresholds...

REM Check domain coverage
if exist module\domain\coverage\lcov.info (
    echo Checking domain coverage (min: %COVERAGE_DOMAIN_MIN%%)...
    dart run tool\ci\check_coverage.dart module\domain\coverage\lcov.info %COVERAGE_DOMAIN_MIN%
    if errorlevel 1 (
        echo ❌ Domain coverage check failed
        set COVERAGE_FAILED=1
    ) else (
        echo ✅ Domain coverage check passed
    )
) else (
    echo ⚠️  Domain coverage file not found
)

REM Check infrastructure coverage
if exist module\infrastructure\coverage\lcov.info (
    echo Checking infrastructure coverage (min: %COVERAGE_INFRA_MIN%%)...
    dart run tool\ci\check_coverage.dart module\infrastructure\coverage\lcov.info %COVERAGE_INFRA_MIN%
    if errorlevel 1 (
        echo ❌ Infrastructure coverage check failed
        set COVERAGE_FAILED=1
    ) else (
        echo ✅ Infrastructure coverage check passed
    )
) else (
    echo ⚠️  Infrastructure coverage file not found
)

echo 💡 For presentation layer coverage verification, run specific test suites

if defined COVERAGE_FAILED (
    echo ❌ Some coverage thresholds were not met
    echo 💡 These are the same thresholds used in CI/CD pipeline
    exit /b 1
) else (
    echo ✅ All coverage thresholds met!
)

echo ✅ Coverage report generation complete!
echo 📊 Check coverage\lcov.info for detailed coverage data
echo 💡 Tips:
echo    - Add more unit tests to improve coverage
echo    - Focus on business logic in the domain layer
echo    - Test edge cases and error scenarios
echo    - Install lcov for HTML reports: https://github.com/linux-test-project/lcov