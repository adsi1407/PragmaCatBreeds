#!/bin/bash

# Test Coverage Script for Cat Breeds App
# Generates detailed test coverage report with CI-consistent thresholds

set -e

echo "🧪 Generating test coverage report..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Coverage thresholds (consistent with CI pipeline)
COVERAGE_DOMAIN_MIN=90
COVERAGE_INFRA_MIN=60
COVERAGE_PRESENTATION_BLOC_MIN=50
COVERAGE_PRESENTATION_WIDGETS_MIN=40

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed or not in PATH${NC}"
    exit 1
fi

# Clean previous coverage
echo -e "${BLUE}🧹 Cleaning previous coverage data...${NC}"
rm -rf coverage/
find . -name "*.lcov.info" -delete

# Install dependencies
echo -e "${BLUE}📦 Installing dependencies...${NC}"
flutter pub get

# Install dependencies for modules
echo -e "${BLUE}📦 Installing module dependencies...${NC}"
cd module/domain && flutter pub get && cd ../..
cd module/infrastructure && flutter pub get && cd ../..

# Run tests with coverage
echo -e "${BLUE}🧪 Running tests with coverage...${NC}"
flutter test --coverage

# Check if coverage directory was created
if [ ! -d "coverage" ]; then
    echo -e "${RED}❌ Coverage directory not found. Tests may have failed.${NC}"
    exit 1
fi

# Check if lcov is installed (optional, for better reporting)
if command -v lcov &> /dev/null; then
    echo -e "${BLUE}📊 Generating detailed HTML coverage report...${NC}"
    
    # Filter out generated files and external packages
    lcov --remove coverage/lcov.info \
        '**/generated/**' \
        '**/l10n/**' \
        '**/test/**' \
        '**/build/**' \
        '**/.dart_tool/**' \
        'lib/main.dart' \
        -o coverage/lcov_filtered.info
    
    # Generate HTML report
    genhtml coverage/lcov_filtered.info -o coverage/html
    
    echo -e "${GREEN}✅ HTML coverage report generated in coverage/html/index.html${NC}"
    
    # Extract coverage percentage
    COVERAGE=$(lcov --summary coverage/lcov_filtered.info 2>&1 | grep -o '[0-9.]*%' | tail -1)
    echo -e "${YELLOW}📈 Overall coverage: $COVERAGE${NC}"
    
    # Open coverage report (optional, comment out if not needed)
    if command -v open &> /dev/null; then
        echo -e "${BLUE}🌐 Opening coverage report in browser...${NC}"
        open coverage/html/index.html
    elif command -v xdg-open &> /dev/null; then
        echo -e "${BLUE}🌐 Opening coverage report in browser...${NC}"
        xdg-open coverage/html/index.html
    fi
else
    echo -e "${YELLOW}⚠️  lcov not found. Install lcov for detailed HTML reports:${NC}"
    echo -e "${YELLOW}   - macOS: brew install lcov${NC}"
    echo -e "${YELLOW}   - Ubuntu: sudo apt-get install lcov${NC}"
    echo -e "${YELLOW}   - Windows: Use WSL or install lcov manually${NC}"
fi

# Basic coverage summary using dart tools
echo -e "${BLUE}📊 Coverage Summary:${NC}"
if [ -f "coverage/lcov.info" ]; then
    # Count total lines and covered lines
    TOTAL_LINES=$(grep -c "^LF:" coverage/lcov.info || echo "0")
    COVERED_LINES=$(grep -c "^LH:" coverage/lcov.info || echo "0")
    
    if [ "$TOTAL_LINES" -gt 0 ]; then
        # Use awk for floating point calculation
        PERCENTAGE=$(awk "BEGIN {printf \"%.2f\", ($COVERED_LINES/$TOTAL_LINES)*100}")
        echo -e "Lines covered: $COVERED_LINES/$TOTAL_LINES (${PERCENTAGE}%)"
    fi
    
    # Show file coverage summary
    echo -e "\n${BLUE}📁 File Coverage Summary:${NC}"
    grep -E "^SF:|^LH:|^LF:" coverage/lcov.info | \
    awk '
    /^SF:/ { file = substr($0, 4); gsub(/.*\/lib\//, "lib/", file) }
    /^LH:/ { covered = substr($0, 4) }
    /^LF:/ { 
        total = substr($0, 4)
        if (total > 0) {
            percentage = (covered/total)*100
            printf "%-50s %3d/%3d (%5.1f%%)\n", file, covered, total, percentage
        }
    }'
fi

# Function to check coverage threshold (consistent with CI)
check_coverage_threshold() {
    local lcov_file=$1
    local min_threshold=$2
    local module_name=$3
    
    if [[ -f "$lcov_file" ]]; then
        local result=$(dart run scripts/ci/validation/check_coverage.dart "$lcov_file" "$min_threshold" 2>&1)
        local exit_code=$?
        
        if [[ $exit_code -eq 0 ]]; then
            echo -e "${GREEN}✅ $module_name coverage check passed${NC}"
            echo "   $result"
        else
            echo -e "${RED}❌ $module_name coverage check failed${NC}"
            echo "   $result"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠️  $module_name coverage file not found: $lcov_file${NC}"
    fi
}

# Verify coverage thresholds (consistent with CI pipeline)
echo -e "\n${BLUE}🎯 Verifying coverage thresholds...${NC}"
coverage_failed=false

# Check domain coverage
if ! check_coverage_threshold "module/domain/coverage/lcov.info" "$COVERAGE_DOMAIN_MIN" "Domain"; then
    coverage_failed=true
fi

# Check infrastructure coverage  
if ! check_coverage_threshold "module/infrastructure/coverage/lcov.info" "$COVERAGE_INFRA_MIN" "Infrastructure"; then
    coverage_failed=true
fi

# Note: Presentation layer checks would require running specific test suites
echo -e "${YELLOW}💡 For presentation layer coverage verification, run specific test suites${NC}"

if [[ "$coverage_failed" == "true" ]]; then
    echo -e "\n${RED}❌ Some coverage thresholds were not met${NC}"
    echo -e "${YELLOW}💡 These are the same thresholds used in CI/CD pipeline${NC}"
    exit 1
else
    echo -e "\n${GREEN}✅ All coverage thresholds met!${NC}"
fi

echo -e "\n${GREEN}✅ Coverage report generation complete!${NC}"
echo -e "${BLUE}💡 Tips:${NC}"
echo -e "   - Add more unit tests to improve coverage"
echo -e "   - Focus on business logic in the domain layer"
echo -e "   - Test edge cases and error scenarios"
echo -e "   - Use 'flutter test --coverage --no-sound-null-safety' if needed"