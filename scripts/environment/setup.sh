#!/bin/bash

# Setup Script for Cat Breeds App
# Initializes the development environment

set -e

echo "🚀 Setting up Cat Breeds App development environment..."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check Flutter installation
echo -e "${BLUE}🔍 Checking Flutter installation...${NC}"
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed or not in PATH${NC}"
    echo -e "${YELLOW}Please install Flutter from: https://flutter.dev/docs/get-started/install${NC}"
    exit 1
fi

# Check Flutter version
FLUTTER_VERSION=$(flutter --version | head -n 1 | cut -d ' ' -f 2)
echo -e "${GREEN}✅ Flutter $FLUTTER_VERSION detected${NC}"

# Check Dart version
DART_VERSION=$(dart --version 2>&1 | cut -d ' ' -f 4)
echo -e "${GREEN}✅ Dart $DART_VERSION detected${NC}"

# Flutter doctor
echo -e "\n${BLUE}🏥 Running Flutter doctor...${NC}"
flutter doctor

# Clean and get dependencies
echo -e "\n${BLUE}🧹 Cleaning previous builds...${NC}"
flutter clean

echo -e "\n${BLUE}📦 Installing main app dependencies...${NC}"
flutter pub get

echo -e "\n${BLUE}📦 Installing domain module dependencies...${NC}"
cd module/domain
flutter pub get
cd ../..

echo -e "\n${BLUE}📦 Installing infrastructure module dependencies...${NC}"
cd module/infrastructure
flutter pub get
cd ../..

# Make scripts executable
echo -e "\n${BLUE}🔧 Making scripts executable...${NC}"
chmod +x scripts/*.sh

# Verify setup
echo -e "\n${BLUE}🧪 Running a quick test to verify setup...${NC}"
flutter test test/integration_test.dart --no-sound-null-safety || true

# Check for IDE setup
echo -e "\n${BLUE}💻 IDE Setup Recommendations:${NC}"
if [ -d ".vscode" ]; then
    echo -e "${GREEN}✅ VS Code configuration found${NC}"
else
    echo -e "${YELLOW}💡 Consider adding VS Code configuration for better development experience${NC}"
fi

# Git hooks setup (optional)
if [ -d ".git" ]; then
    echo -e "\n${BLUE}🔗 Setting up Git hooks...${NC}"
    if [ ! -f ".git/hooks/pre-commit" ]; then
        cat > .git/hooks/pre-commit << 'EOF'
#!/bin/sh
# Pre-commit hook for Flutter projects

echo "Running pre-commit checks..."

# Check formatting
if ! dart format --output=none --set-exit-if-changed .; then
    echo "❌ Code is not formatted. Run 'dart format .' to fix."
    exit 1
fi

# Run analyzer
if ! flutter analyze; then
    echo "❌ Flutter analyze found issues. Please fix them before committing."
    exit 1
fi

# Run tests
if ! flutter test; then
    echo "❌ Tests failed. Please fix them before committing."
    exit 1
fi

echo "✅ Pre-commit checks passed!"
EOF
        chmod +x .git/hooks/pre-commit
        echo -e "${GREEN}✅ Git pre-commit hook installed${NC}"
    else
        echo -e "${YELLOW}Git pre-commit hook already exists${NC}"
    fi
fi

echo -e "\n${GREEN}✅ Setup complete!${NC}"
echo -e "\n${BLUE}🎯 Next steps:${NC}"
echo -e "1. Run 'flutter run' to start the app"
echo -e "2. Run 'flutter test' to execute tests"
echo -e "3. Run './scripts/testing/test_coverage.sh' for coverage report"
echo -e "4. Check ARCHITECTURE.md for detailed documentation"
echo -e "\n${BLUE}📚 Available commands:${NC}"
echo -e "• flutter run                    # Run the app"
echo -e "• flutter test                   # Run tests"
echo -e "• flutter analyze                # Code analysis"
echo -e "• dart format .                  # Format code"
echo -e "• ./scripts/testing/test_coverage.sh     # Generate coverage report"
echo -e "• ./scripts/performance_test.sh  # Performance analysis"

echo -e "\n${YELLOW}🔥 Happy coding!${NC}"