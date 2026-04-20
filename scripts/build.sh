#!/bin/bash

#************************************************************
# build.sh
# Build a single LaTeX presentation or document
#
# Usage:
#   ./scripts/build.sh <project-path> [--texfile FILENAME.tex]
#
# Examples:
#   ./scripts/build.sh presentations/university-demo
#   ./scripts/build.sh presentations/my-project --texfile lecture.tex
#   ./scripts/build.sh documents/university-demo
#   ./scripts/build.sh documents/my-document --texfile handout.tex
#
# The script compiles the specified LaTeX file using latexmk.
# Output is placed in the project's out/ directory.
#************************************************************

set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

print_usage() {
    echo "Usage: $0 <project-path> [--texfile FILENAME.tex]"
    echo ""
    echo "Options:"
    echo "  --texfile FILENAME.tex   Build a specific .tex file (default: main.tex)"
    echo ""
    echo "Examples:"
    echo "  $0 presentations/university-demo"
    echo "  $0 presentations/my-project --texfile lecture.tex"
    echo "  $0 documents/university-demo --texfile report.tex"
    echo ""
}

resolve_project_path() {
    local input_path="$1"

    if [[ "$input_path" = /* ]]; then
        printf '%s\n' "$input_path"
        return 0
    fi

    if [ -d "$REPO_ROOT/$input_path" ]; then
        printf '%s\n' "$REPO_ROOT/$input_path"
        return 0
    fi

    if [ -d "$input_path" ]; then
        printf '%s\n' "$(cd -- "$input_path" && pwd -P)"
        return 0
    fi

    return 1
}

display_path() {
    local absolute_path="$1"

    if [[ "$absolute_path" == "$REPO_ROOT"/* ]]; then
        printf '%s\n' "${absolute_path#$REPO_ROOT/}"
    else
        printf '%s\n' "$absolute_path"
    fi
}

# Parse arguments
if [ $# -lt 1 ]; then
    print_error "Missing project path"
    print_usage
    exit 1
fi

PROJECT_INPUT_PATH="$1"
TEXFILE="main.tex"

# Check for --texfile option
if [ $# -ge 3 ]; then
    if [ "$2" = "--texfile" ]; then
        TEXFILE="$3"
    fi
fi

PROJECT_PATH="$(resolve_project_path "$PROJECT_INPUT_PATH")" || {
    print_error "Project directory not found: $PROJECT_INPUT_PATH"
    exit 1
}

DISPLAY_PROJECT_PATH="$(display_path "$PROJECT_PATH")"

# Check if tex file exists
if [ ! -f "$PROJECT_PATH/$TEXFILE" ]; then
    print_error "LaTeX file not found: $DISPLAY_PROJECT_PATH/$TEXFILE"
    exit 1
fi

# Create out directory if it doesn't exist
mkdir -p "$PROJECT_PATH/out"

print_info "Building: $DISPLAY_PROJECT_PATH/$TEXFILE"

# Build using latexmk
cd "$PROJECT_PATH"

if latexmk -pdf -cd -quiet -outdir=out "$TEXFILE"; then
    PDF_NAME="${TEXFILE%.tex}.pdf"
    print_success "Build complete: $DISPLAY_PROJECT_PATH/out/$PDF_NAME"
else
    print_error "Build failed for $DISPLAY_PROJECT_PATH/$TEXFILE"
    exit 1
fi

cd - > /dev/null
