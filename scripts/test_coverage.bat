@echo off
REM Test Coverage Script for Cat Breeds App (Windows)
REM Generates detailed test coverage report

echo 🧪 Generating test coverage report...

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

echo ✅ Coverage report generation complete!
echo 📊 Check coverage\lcov.info for detailed coverage data
echo 💡 Tips:
echo    - Add more unit tests to improve coverage
echo    - Focus on business logic in the domain layer
echo    - Test edge cases and error scenarios
echo    - Install lcov for HTML reports: https://github.com/linux-test-project/lcov