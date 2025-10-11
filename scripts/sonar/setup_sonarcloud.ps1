# SonarCloud Setup Script for Windows
# This script helps you configure SonarCloud integration

Write-Host "Setting up SonarCloud for Pragma Cat Breeds..." -ForegroundColor Green

# Check if sonar-project.properties exists
if (-not (Test-Path "sonar-project.properties")) {
    Write-Host "ERROR: sonar-project.properties not found!" -ForegroundColor Red
    Write-Host "Please make sure you're running this from the project root."
    exit 1
}

Write-Host "Found sonar-project.properties" -ForegroundColor Green

# Check if GitHub workflow exists
if (-not (Test-Path ".github/workflows/sonarcloud.yml")) {
    Write-Host "ERROR: SonarCloud workflow not found!" -ForegroundColor Red
    Write-Host "Please make sure .github/workflows/sonarcloud.yml exists."
    exit 1
}

Write-Host "Found SonarCloud workflow" -ForegroundColor Green

# Generate coverage to test setup
Write-Host "Running tests with coverage..." -ForegroundColor Yellow
flutter clean
flutter pub get

# Get dependencies for modules
Set-Location "module/domain"
flutter pub get
Set-Location "../.."

Set-Location "module/infrastructure" 
flutter pub get
Set-Location "../.."

# Run tests with coverage
flutter test --coverage

if (Test-Path "coverage/lcov.info") {
    Write-Host "Coverage generated successfully" -ForegroundColor Green
    Write-Host "Coverage file: coverage/lcov.info" -ForegroundColor Cyan
} else {
    Write-Host "WARNING: No coverage file generated" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Blue
Write-Host "1. Go to https://sonarcloud.io"
Write-Host "2. Sign in with your GitHub account"
Write-Host "3. Import repository: adsi1407/PragmaCatBreeds"
Write-Host "4. Get your SONAR_TOKEN from SonarCloud"
Write-Host "5. Add SONAR_TOKEN to GitHub Secrets:"
Write-Host "   - Go to: GitHub repo -> Settings -> Secrets and variables -> Actions"
Write-Host "   - Add new secret: SONAR_TOKEN = [your_token]"
Write-Host "6. Push to main branch to trigger first analysis"
Write-Host ""
Write-Host "Documentation: docs/SONARCLOUD_SETUP.md" -ForegroundColor Cyan
Write-Host "Setup complete! SonarCloud will now monitor your technical debt." -ForegroundColor Green