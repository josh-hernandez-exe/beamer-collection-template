#!/bin/bash

#************************************************************
# build-all.sh
# Build all presentations and documents in the workspace
#
# Usage:
#   ./scripts/build-all.sh [--texfiles FILE1.tex,FILE2.tex,...]
#
# Examples:
#   ./scripts/build-all.sh
#   ./scripts/build-all.sh --texfiles "lecture.tex,handout.tex"
#
# The script searches for main.tex (or specified filenames) in:
#   - presentations/*/
#   - documents/*/
#
# Each project is compiled using the build.sh script.
#************************************************************

set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
BUILD_SCRIPT="${SCRIPT_DIR}/build.sh"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_error() {
    echo -e "${RED}✗ $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

print_header() {
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
}

print_usage() {
    echo "Usage: $0 [--texfiles FILE1.tex,FILE2.tex,...]"
    echo ""
    echo "Options:"
    echo "  --texfiles FILE1.tex,FILE2.tex"
    echo "                       Build specified .tex files instead of main.tex"
    echo "                       (comma-separated, no spaces)"
    echo ""
    echo "Examples:"
    echo "  $0                    # Build all main.tex files"
    echo "  $0 --texfiles lecture.tex,handout.tex"
    echo ""
}

display_path() {
    local absolute_path="$1"

    if [[ "$absolute_path" == "$REPO_ROOT"/* ]]; then
        printf '%s\n' "${absolute_path#$REPO_ROOT/}"
    else
        printf '%s\n' "$absolute_path"
    fi
}

# Default tex files to build
TEXFILES=("main.tex")

# Parse arguments
if [ $# -ge 2 ]; then
    if [ "$1" = "--texfiles" ]; then
        # Split comma-separated list into array
        IFS=',' read -ra TEXFILES <<< "$2"
    else
        print_error "Unknown option: $1"
        print_usage
        exit 1
    fi
fi

print_header "Building All Projects"

SUCCESS_COUNT=0
FAIL_COUNT=0
TOTAL_COUNT=0

# Function to build a project
build_project() {
    local project_dir="$1"
    local texfile="$2"
    local display_project_dir

    if [ ! -f "$project_dir/$texfile" ]; then
        return 0
    fi

    TOTAL_COUNT=$((TOTAL_COUNT + 1))
    display_project_dir="$(display_path "$project_dir")"
    print_info "Building: $display_project_dir/$texfile"

    if bash "$BUILD_SCRIPT" "$project_dir" --texfile "$texfile"; then
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

# Search presentations and documents directories
for texfile in "${TEXFILES[@]}"; do
    texfile=$(echo "$texfile" | xargs)  # Trim whitespace
    print_info "Looking for $texfile..."

    # Find all presentation directories (not nested)
    if [ -d "$REPO_ROOT/presentations" ]; then
        for dir in "$REPO_ROOT"/presentations/*/; do
            if [ ! -d "$dir" ]; then
                continue
            fi
            # Skip non-project directories
            if [[ "$dir" != *"themes"* ]] && [[ "$dir" != *"common"* ]]; then
                dir="${dir%/}"  # Remove trailing slash
                build_project "$dir" "$texfile"
            fi
        done
    fi

    # Find all document directories (not nested)
    if [ -d "$REPO_ROOT/documents" ]; then
        for dir in "$REPO_ROOT"/documents/*/; do
            if [ ! -d "$dir" ]; then
                continue
            fi
            # Skip non-project directories
            if [[ "$dir" != *"themes"* ]] && [[ "$dir" != *"common"* ]]; then
                dir="${dir%/}"  # Remove trailing slash
                build_project "$dir" "$texfile"
            fi
        done
    fi
done

print_header "Build Summary"
print_success "$SUCCESS_COUNT succeeded"
if [ $FAIL_COUNT -gt 0 ]; then
    print_error "$FAIL_COUNT failed"
fi
echo "Total: $TOTAL_COUNT projects"

if [ $FAIL_COUNT -eq 0 ] && [ $TOTAL_COUNT -gt 0 ]; then
    print_success "All builds completed successfully!"
    exit 0
else
    exit 1
fi
