#!/bin/bash

# Clean Project Script - Remove unnecessary files from Flutter project
# Removes build artifacts, temporary files, cache, and other unnecessary files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
DRY_RUN=false
VERBOSE=false
INTERACTIVE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run|-d)
            DRY_RUN=true
            shift
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --interactive|-i)
            INTERACTIVE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --dry-run, -d     Show what would be deleted without actually deleting"
            echo "  --verbose, -v     Show detailed output"
            echo "  --interactive, -i Ask before deleting each category"
            echo "  --help, -h        Show this help message"
            echo ""
            echo "Categories cleaned:"
            echo "  • Build artifacts (build/, .dart_tool/)"
            echo "  • Coverage reports (coverage/)"
            echo "  • Generated files (*.g.dart, *.freezed.dart)"
            echo "  • IDE files (.vscode/, .idea/)"
            echo "  • OS files (.DS_Store, Thumbs.db)"
            echo "  • Log files (*.log)"
            echo "  • Temporary files (*.tmp, *.temp)"
            exit 0
            ;;
        *)
            echo "Unknown option $1"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}🧹 Flutter Project Cleanup Script${NC}"
echo -e "${BLUE}===================================${NC}"

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}🔍 DRY RUN MODE - No files will be deleted${NC}"
fi

# Function to ask for confirmation
ask_confirmation() {
    local message=$1
    if [ "$INTERACTIVE" = true ]; then
        echo -e "${CYAN}$message (y/N): ${NC}"
        read -r response
        case "$response" in
            [yY][eE][sS]|[yY]) 
                return 0
                ;;
            *)
                return 1
                ;;
        esac
    fi
    return 0
}

# Function to remove files/directories
remove_items() {
    local description=$1
    shift
    local items=("$@")
    local found_items=()
    
    # Find existing items
    for item in "${items[@]}"; do
        if [ -e "$item" ] || [ -L "$item" ]; then
            found_items+=("$item")
        fi
    done
    
    if [ ${#found_items[@]} -eq 0 ]; then
        if [ "$VERBOSE" = true ]; then
            echo -e "${YELLOW}  ⚪ $description - No items found${NC}"
        fi
        return 0
    fi
    
    echo -e "${BLUE}📁 $description${NC}"
    
    if ask_confirmation "Remove $description?"; then
        for item in "${found_items[@]}"; do
            if [ "$VERBOSE" = true ] || [ "$DRY_RUN" = true ]; then
                echo -e "${CYAN}    📄 $item${NC}"
            fi
            
            if [ "$DRY_RUN" = false ]; then
                if [ -d "$item" ]; then
                    rm -rf "$item"
                else
                    rm -f "$item"
                fi
            fi
        done
        
        if [ "$DRY_RUN" = false ]; then
            echo -e "${GREEN}  ✅ Removed ${#found_items[@]} items${NC}"
        else
            echo -e "${YELLOW}  📋 Would remove ${#found_items[@]} items${NC}"
        fi
    else
        echo -e "${YELLOW}  ⏭️  Skipped $description${NC}"
    fi
}

# Function to remove files by pattern
remove_by_pattern() {
    local description=$1
    local pattern=$2
    local found_files=()
    
    # Find files matching pattern
    while IFS= read -r -d '' file; do
        found_files+=("$file")
    done < <(find . -name "$pattern" -type f -print0 2>/dev/null)
    
    if [ ${#found_files[@]} -eq 0 ]; then
        if [ "$VERBOSE" = true ]; then
            echo -e "${YELLOW}  ⚪ $description - No files found${NC}"
        fi
        return 0
    fi
    
    echo -e "${BLUE}🔍 $description${NC}"
    
    if ask_confirmation "Remove $description?"; then
        for file in "${found_files[@]}"; do
            if [ "$VERBOSE" = true ] || [ "$DRY_RUN" = true ]; then
                echo -e "${CYAN}    📄 $file${NC}"
            fi
            
            if [ "$DRY_RUN" = false ]; then
                rm -f "$file"
            fi
        done
        
        if [ "$DRY_RUN" = false ]; then
            echo -e "${GREEN}  ✅ Removed ${#found_files[@]} files${NC}"
        else
            echo -e "${YELLOW}  📋 Would remove ${#found_files[@]} files${NC}"
        fi
    else
        echo -e "${YELLOW}  ⏭️  Skipped $description${NC}"
    fi
}

# Function to clean specific directories recursively
clean_recursive_pattern() {
    local description=$1
    local pattern=$2
    local found_items=()
    
    # Find items matching pattern recursively
    while IFS= read -r -d '' item; do
        found_items+=("$item")
    done < <(find . -name "$pattern" -print0 2>/dev/null)
    
    if [ ${#found_items[@]} -eq 0 ]; then
        if [ "$VERBOSE" = true ]; then
            echo -e "${YELLOW}  ⚪ $description - No items found${NC}"
        fi
        return 0
    fi
    
    echo -e "${BLUE}🔍 $description${NC}"
    
    if ask_confirmation "Remove $description?"; then
        for item in "${found_items[@]}"; do
            if [ "$VERBOSE" = true ] || [ "$DRY_RUN" = true ]; then
                echo -e "${CYAN}    📁 $item${NC}"
            fi
            
            if [ "$DRY_RUN" = false ]; then
                if [ -d "$item" ]; then
                    rm -rf "$item"
                else
                    rm -f "$item"
                fi
            fi
        done
        
        if [ "$DRY_RUN" = false ]; then
            echo -e "${GREEN}  ✅ Removed ${#found_items[@]} items${NC}"
        else
            echo -e "${YELLOW}  📋 Would remove ${#found_items[@]} items${NC}"
        fi
    else
        echo -e "${YELLOW}  ⏭️  Skipped $description${NC}"
    fi
}

echo ""
echo -e "${CYAN}Starting cleanup...${NC}"
echo ""

# 1. Build artifacts and cache
remove_items "Build directories" \
    "build" \
    ".dart_tool" \
    "module/domain/build" \
    "module/domain/.dart_tool" \
    "module/infrastructure/build" \
    "module/infrastructure/.dart_tool"

# 2. Coverage reports
remove_items "Coverage reports" \
    "coverage" \
    "module/domain/coverage" \
    "module/infrastructure/coverage"

# 3. Generated files
remove_by_pattern "Generated Dart files (*.g.dart)" "*.g.dart"
remove_by_pattern "Freezed files (*.freezed.dart)" "*.freezed.dart"
remove_by_pattern "Config files (*.config.dart)" "*.config.dart"

# 4. IDE configuration files
remove_items "IDE configuration files" \
    ".vscode/settings.json" \
    ".idea"

# 5. OS-specific files
remove_by_pattern "macOS DS_Store files" ".DS_Store"
remove_by_pattern "Windows Thumbs.db files" "Thumbs.db"
remove_by_pattern "Windows desktop.ini files" "desktop.ini"

# 6. Log files
remove_by_pattern "Log files" "*.log"

# 7. Temporary files
remove_by_pattern "Temporary files (.tmp)" "*.tmp"
remove_by_pattern "Temporary files (.temp)" "*.temp"
remove_by_pattern "Backup files (.bak)" "*.bak"

# 8. Platform-specific build artifacts
clean_recursive_pattern "iOS build artifacts" "ios/build"
clean_recursive_pattern "Android build artifacts" "android/build"
clean_recursive_pattern "Web build artifacts" "web/build"
clean_recursive_pattern "Windows build artifacts" "windows/build"
clean_recursive_pattern "Linux build artifacts" "linux/build"
clean_recursive_pattern "macOS build artifacts" "macos/build"

# 9. Pub cache issues (local overrides)
remove_items "Pub dependency overrides" \
    "pubspec_overrides.yaml" \
    "module/domain/pubspec_overrides.yaml" \
    "module/infrastructure/pubspec_overrides.yaml"

# 10. Flutter specific temporary files
clean_recursive_pattern "Flutter tool cache" ".flutter-plugins"
clean_recursive_pattern "Flutter plugins old" ".flutter-plugins-dependencies"

# 11. Test related temporary files
remove_by_pattern "Test coverage temp files" "*.lcov.info"
remove_by_pattern "Test report files" "test-results.xml"

# Summary
echo ""
echo -e "${GREEN}🎉 Cleanup completed!${NC}"

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}📋 This was a dry run. No files were actually deleted.${NC}"
    echo -e "${CYAN}💡 Run without --dry-run to actually delete the files.${NC}"
else
    echo -e "${GREEN}✅ Project cleaned successfully!${NC}"
fi

# Recommendations
echo ""
echo -e "${BLUE}💡 Recommendations:${NC}"
echo -e "${CYAN}  • Run 'flutter clean' after this script${NC}"
echo -e "${CYAN}  • Run 'flutter pub get' to restore dependencies${NC}"
echo -e "${CYAN}  • Consider adding more patterns to .gitignore${NC}"
echo -e "${CYAN}  • Run this script before committing large changes${NC}"

# Show current directory size (if du is available)
if command -v du &> /dev/null; then
    echo ""
    echo -e "${BLUE}📊 Current project size:${NC}"
    PROJECT_SIZE=$(du -sh . 2>/dev/null | cut -f1)
    echo -e "${CYAN}  Total: $PROJECT_SIZE${NC}"
fi