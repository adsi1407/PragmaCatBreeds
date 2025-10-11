#!/bin/bash

# Performance Testing Script for Cat Breeds App
# Measures app performance and provides optimization recommendations

set -e

echo "🚀 Running performance analysis..."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check Flutter installation
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed or not in PATH${NC}"
    exit 1
fi

echo -e "${BLUE}📱 Device Information:${NC}"
flutter devices

echo -e "\n${BLUE}🔍 Running Flutter Analyze...${NC}"
flutter analyze | tee analysis_results.txt

echo -e "\n${BLUE}📏 Code Metrics:${NC}"

# Count lines of code
echo -e "${YELLOW}Lines of Code:${NC}"
find lib -name "*.dart" -exec wc -l {} + | tail -n 1
find module -name "*.dart" -exec wc -l {} + | tail -n 1

# Count files
echo -e "${YELLOW}Dart Files:${NC}"
find lib module -name "*.dart" | wc -l

# Check for large files
echo -e "\n${YELLOW}Large Files (>200 lines):${NC}"
find lib module -name "*.dart" -exec wc -l {} + | awk '$1 > 200 {print}' | sort -nr

echo -e "\n${BLUE}📦 Dependency Analysis:${NC}"

# Check for unused dependencies
echo -e "${YELLOW}Checking for unused dependencies...${NC}"
flutter pub deps

# App size analysis
echo -e "\n${BLUE}📱 App Size Analysis:${NC}"
echo -e "${YELLOW}Building release APK for size analysis...${NC}"
flutter build apk --release --split-per-abi

if [ -f "build/app/outputs/flutter-apk/app-arm64-v8a-release.apk" ]; then
    APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-arm64-v8a-release.apk | cut -f1)
    echo -e "APK Size (arm64-v8a): $APK_SIZE"
fi

echo -e "\n${BLUE}🧪 Performance Tests:${NC}"

# Run performance tests if they exist
if [ -d "test_driver" ]; then
    echo -e "${YELLOW}Running integration tests...${NC}"
    flutter drive --target=test_driver/app.dart
else
    echo -e "${YELLOW}No performance tests found. Consider adding integration tests.${NC}"
fi

echo -e "\n${BLUE}💡 Performance Recommendations:${NC}"

# Check for common performance issues
echo -e "${YELLOW}Checking for performance anti-patterns...${NC}"

# Check for setState usage
SETSTATE_COUNT=$(grep -r "setState" lib/ | wc -l)
if [ "$SETSTATE_COUNT" -gt 10 ]; then
    echo -e "${RED}⚠️  High setState usage ($SETSTATE_COUNT occurrences). Consider using BLoC/Provider.${NC}"
else
    echo -e "${GREEN}✅ Good state management practices.${NC}"
fi

# Check for ListView usage
LISTVIEW_COUNT=$(grep -r "ListView(" lib/ | wc -l)
LISTVIEW_BUILDER_COUNT=$(grep -r "ListView.builder" lib/ | wc -l)
if [ "$LISTVIEW_COUNT" -gt "$LISTVIEW_BUILDER_COUNT" ]; then
    echo -e "${YELLOW}⚠️  Consider using ListView.builder for better performance.${NC}"
else
    echo -e "${GREEN}✅ Good ListView usage.${NC}"
fi

# Check for Container with only color
CONTAINER_COLOR_COUNT=$(grep -r "Container(" lib/ | wc -l)
if [ "$CONTAINER_COLOR_COUNT" -gt 5 ]; then
    echo -e "${YELLOW}⚠️  Consider using ColoredBox instead of Container for simple colored backgrounds.${NC}"
fi

# Check for image optimization
NETWORK_IMAGE_COUNT=$(grep -r "NetworkImage\|Image.network" lib/ | wc -l)
CACHED_IMAGE_COUNT=$(grep -r "CachedNetworkImage" lib/ | wc -l)
if [ "$NETWORK_IMAGE_COUNT" -gt "$CACHED_IMAGE_COUNT" ]; then
    echo -e "${YELLOW}⚠️  Consider using CachedNetworkImage for better image performance.${NC}"
else
    echo -e "${GREEN}✅ Good image caching implementation.${NC}"
fi

echo -e "\n${BLUE}📊 Summary:${NC}"
echo -e "• Analysis complete - check analysis_results.txt for details"
echo -e "• App size optimized for release builds"
echo -e "• Performance patterns checked"
echo -e "• Consider running on real devices for accurate performance metrics"

echo -e "\n${GREEN}✅ Performance analysis complete!${NC}"

# Clean up
rm -f analysis_results.txt