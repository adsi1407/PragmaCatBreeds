#!/bin/bash

# SonarCloud Setup Script for Pragma Cat Breeds
# This script helps you configure SonarCloud integration

set -e

echo "🚀 Setting up SonarCloud for Pragma Cat Breeds..."

# Check if sonar-project.properties exists
if [ ! -f "sonar-project.properties" ]; then
    echo "❌ sonar-project.properties not found!"
    echo "Please make sure you're running this from the project root."
    exit 1
fi

echo "✅ Found sonar-project.properties"

# Check if GitHub workflow exists
if [ ! -f ".github/workflows/sonarcloud.yml" ]; then
    echo "❌ SonarCloud workflow not found!"
    echo "Please make sure .github/workflows/sonarcloud.yml exists."
    exit 1
fi

echo "✅ Found SonarCloud workflow"

# Generate coverage to test setup
echo "📊 Running tests with coverage..."
flutter clean
flutter pub get

# Get dependencies for modules
cd module/domain && flutter pub get && cd ../..
cd module/infrastructure && flutter pub get && cd ../..

# Run tests with coverage
flutter test --coverage

if [ -f "coverage/lcov.info" ]; then
    echo "✅ Coverage generated successfully"
    echo "📁 Coverage file: coverage/lcov.info"
else
    echo "⚠️  No coverage file generated"
fi

echo ""
echo "🎯 Next Steps:"
echo "1. Go to https://sonarcloud.io"
echo "2. Sign in with your GitHub account"
echo "3. Import repository: adsi1407/PragmaCatBreeds"
echo "4. Get your SONAR_TOKEN from SonarCloud"
echo "5. Add SONAR_TOKEN to GitHub Secrets:"
echo "   - Go to: GitHub repo → Settings → Secrets and variables → Actions"
echo "   - Add new secret: SONAR_TOKEN = [your_token]"
echo "6. Push to main branch to trigger first analysis"
echo ""
echo "📚 Documentation: docs/SONARCLOUD_SETUP.md"
echo "✨ Setup complete! SonarCloud will now monitor your technical debt."