#!/bin/bash

# Enhanced Test Coverage Script for SonarCloud Integration
# Generates modular coverage reports matching SonarCloud configuration

set -e

echo "🧪 Generating modular test coverage for SonarCloud..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Coverage thresholds (matching SonarCloud config)
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
rm -rf module/domain/coverage/
rm -rf module/infrastructure/coverage/
find . -name "*.lcov*" -delete

# Install dependencies
echo -e "${BLUE}📦 Installing dependencies...${NC}"
flutter pub get

# Install dependencies for modules
echo -e "${BLUE}📦 Installing module dependencies...${NC}"
cd module/domain && flutter pub get && cd ../..
cd module/infrastructure && flutter pub get && cd ../..

# Create coverage directories
mkdir -p coverage

# Run main app tests with coverage
echo -e "${BLUE}🧪 Running main app tests with coverage...${NC}"
flutter test --coverage

# Run domain module tests
echo -e "${BLUE}🧪 Running domain module tests...${NC}"
cd module/domain
flutter test --coverage
cd ../..

# Run infrastructure module tests
echo -e "${BLUE}🧪 Running infrastructure module tests...${NC}"
cd module/infrastructure
flutter test --coverage
cd ../..

# Generate presentation-specific coverage (BLoC vs Widgets)
echo -e "${BLUE}🧪 Generating presentation-specific coverage...${NC}"

# BLoC coverage
if [ -d "test/presentation" ]; then
    echo -e "${YELLOW}  📊 Generating BLoC coverage...${NC}"
    flutter test test/presentation/ --coverage --coverage-path=coverage/presentation-bloc.lcov 2>/dev/null || {
        echo -e "${YELLOW}  ⚠️ No BLoC tests found, creating empty coverage file${NC}"
        touch coverage/presentation-bloc.lcov
    }
fi

# Check if lcov is available for advanced processing
if command -v lcov &> /dev/null; then
    echo -e "${BLUE}📊 Processing coverage with lcov for SonarCloud...${NC}"
    
    # Process main coverage
    if [ -f "coverage/lcov.info" ]; then
        echo -e "${YELLOW}  🔄 Processing main coverage...${NC}"
        lcov --remove coverage/lcov.info \
            '**/generated/**' \
            '**/l10n/**' \
            '**/test/**' \
            '**/build/**' \
            '**/.dart_tool/**' \
            '**/*.g.dart' \
            '**/*.freezed.dart' \
            '**/*.config.dart' \
            'lib/main.dart' \
            -o coverage/lcov_filtered.info
    fi
    
    # Process domain coverage
    if [ -f "module/domain/coverage/lcov.info" ]; then
        echo -e "${YELLOW}  🔄 Processing domain coverage...${NC}"
        lcov --remove module/domain/coverage/lcov.info \
            '**/test/**' \
            '**/*.g.dart' \
            '**/*.freezed.dart' \
            -o module/domain/coverage/lcov_filtered.info
    fi
    
    # Process infrastructure coverage
    if [ -f "module/infrastructure/coverage/lcov.info" ]; then
        echo -e "${YELLOW}  🔄 Processing infrastructure coverage...${NC}"
        lcov --remove module/infrastructure/coverage/lcov.info \
            '**/test/**' \
            '**/*.g.dart' \
            '**/*.freezed.dart' \
            -o module/infrastructure/coverage/lcov_filtered.info
    fi
    
    # Create combined coverage for overall metrics
    echo -e "${YELLOW}  🔄 Creating combined coverage...${NC}"
    lcov --add-tracefile coverage/lcov.info \
         --add-tracefile module/domain/coverage/lcov.info \
         --add-tracefile module/infrastructure/coverage/lcov.info \
         --output-file coverage/combined.lcov 2>/dev/null || true
    
    # Generate HTML reports for each module
    echo -e "${BLUE}📊 Generating HTML reports...${NC}"
    
    # Main app report
    if [ -f "coverage/lcov_filtered.info" ]; then
        genhtml coverage/lcov_filtered.info -o coverage/html/main --title "Main App Coverage"
    fi
    
    # Domain report
    if [ -f "module/domain/coverage/lcov_filtered.info" ]; then
        genhtml module/domain/coverage/lcov_filtered.info -o coverage/html/domain --title "Domain Layer Coverage"
    fi
    
    # Infrastructure report
    if [ -f "module/infrastructure/coverage/lcov_filtered.info" ]; then
        genhtml module/infrastructure/coverage/lcov_filtered.info -o coverage/html/infrastructure --title "Infrastructure Layer Coverage"
    fi
    
    echo -e "${GREEN}✅ HTML coverage reports generated in coverage/html/[module]/index.html${NC}"
    
else
    echo -e "${YELLOW}⚠️  lcov not found. Install lcov for detailed processing:${NC}"
    echo -e "${YELLOW}   - macOS: brew install lcov${NC}"
    echo -e "${YELLOW}   - Ubuntu: sudo apt-get install lcov${NC}"
fi

# Generate coverage summary by module
echo -e "${BLUE}📊 Coverage Summary by Module:${NC}"

# Function to calculate coverage percentage
calculate_coverage() {
    local file=$1
    local module_name=$2
    
    if [ -f "$file" ]; then
        local total_lines=$(grep -c "^LF:" "$file" 2>/dev/null || echo "0")
        local covered_lines=$(grep "^LH:" "$file" 2>/dev/null | awk -F: '{sum += $2} END {print sum+0}')
        
        if [ "$total_lines" -gt 0 ] && [ "$covered_lines" -gt 0 ]; then
            local percentage=$(awk "BEGIN {printf \"%.2f\", ($covered_lines/$total_lines)*100}")
            echo -e "${BLUE}  📈 $module_name: $percentage% ($covered_lines/$total_lines lines)${NC}"
            
            # Check against thresholds
            case $module_name in
                "Domain")
                    if (( $(echo "$percentage >= $COVERAGE_DOMAIN_MIN" | bc -l 2>/dev/null || echo "0") )); then
                        echo -e "${GREEN}    ✅ Meets threshold (≥${COVERAGE_DOMAIN_MIN}%)${NC}"
                    else
                        echo -e "${RED}    ❌ Below threshold (≥${COVERAGE_DOMAIN_MIN}%)${NC}"
                    fi
                    ;;
                "Infrastructure")
                    if (( $(echo "$percentage >= $COVERAGE_INFRA_MIN" | bc -l 2>/dev/null || echo "0") )); then
                        echo -e "${GREEN}    ✅ Meets threshold (≥${COVERAGE_INFRA_MIN}%)${NC}"
                    else
                        echo -e "${RED}    ❌ Below threshold (≥${COVERAGE_INFRA_MIN}%)${NC}"
                    fi
                    ;;
            esac
        else
            echo -e "${YELLOW}  📈 $module_name: No coverage data${NC}"
        fi
    else
        echo -e "${YELLOW}  📈 $module_name: Coverage file not found${NC}"
    fi
}

# Calculate coverage for each module
calculate_coverage "coverage/lcov.info" "Main App"
calculate_coverage "module/domain/coverage/lcov.info" "Domain"
calculate_coverage "module/infrastructure/coverage/lcov.info" "Infrastructure"

# SonarCloud compatibility check
echo -e "${BLUE}🔍 SonarCloud Compatibility Check:${NC}"

# Check if all required coverage files exist for SonarCloud
required_files=(
    "coverage/lcov.info"
    "module/domain/coverage/lcov.info"
    "module/infrastructure/coverage/lcov.info"
)

all_files_exist=true
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}  ✅ $file${NC}"
    else
        echo -e "${RED}  ❌ $file${NC}"
        all_files_exist=false
    fi
done

if [ "$all_files_exist" = true ]; then
    echo -e "${GREEN}🎉 All coverage files ready for SonarCloud analysis!${NC}"
    echo -e "${BLUE}📋 Next steps:${NC}"
    echo -e "${BLUE}  1. Commit and push changes${NC}"
    echo -e "${BLUE}  2. SonarCloud will analyze modular coverage automatically${NC}"
    echo -e "${BLUE}  3. Check results at: https://sonarcloud.io/project/overview?id=adsi1407_PragmaCatBreeds${NC}"
else
    echo -e "${YELLOW}⚠️  Some coverage files missing. SonarCloud will use available data.${NC}"
fi

# Final summary
echo -e "${BLUE}📁 Generated Files Structure:${NC}"
find . -name "*.lcov*" -o -name "lcov.info" | sort | head -10

echo -e "${GREEN}✅ Modular coverage generation completed!${NC}"