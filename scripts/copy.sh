#!/bin/bash

#************************************************************
# copy.sh
# Copy compiled PDFs to dropbox/ folder for distribution
#
# Usage:
#   ./scripts/copy.sh
#
# The script searches for all .tex files in presentations/ and documents/
# and copies the corresponding PDFs from out/ to dropbox/ with naming:
#   presentations/my-project/out/main.pdf → dropbox/my-project-main.pdf
#   documents/report/out/report.pdf → dropbox/report-report.pdf
#
# Only copies if the source file is different from the destination
# (uses cmp -s to preserve file timestamps).
#************************************************************

set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
DISTRIBUTION_DIR="${REPO_ROOT}/dropbox"

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

display_path() {
    local absolute_path="$1"

    if [[ "$absolute_path" == "$REPO_ROOT"/* ]]; then
        printf '%s\n' "${absolute_path#$REPO_ROOT/}"
    else
        printf '%s\n' "$absolute_path"
    fi
}

print_header "Copying PDFs to dropbox/"

# Create dropbox directory if it doesn't exist
mkdir -p "$DISTRIBUTION_DIR"

COPIED_COUNT=0
SKIPPED_COUNT=0
NOTFOUND_COUNT=0

# Function to copy PDF
copy_pdf() {
    local project_dir="$1"
    local project_name=$(basename "$project_dir")
    local texfile="$2"
    local texname="${texfile%.tex}"
    local display_source_pdf
    local display_dest_pdf

    local source_pdf="$project_dir/out/$texname.pdf"
    local dest_pdf="$DISTRIBUTION_DIR/$project_name-$texname.pdf"
    display_source_pdf="$(display_path "$source_pdf")"
    display_dest_pdf="$(display_path "$dest_pdf")"

    # Check if source exists
    if [ ! -f "$source_pdf" ]; then
        print_info "Not found: $display_source_pdf"
        NOTFOUND_COUNT=$((NOTFOUND_COUNT + 1))
        return 1
    fi

    # Check if destination exists and is identical
    if [ -f "$dest_pdf" ]; then
        if cmp -s "$source_pdf" "$dest_pdf"; then
            print_info "Skipped (unchanged): $display_dest_pdf"
            SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
            return 0
        fi
    fi

    # Copy the file
    if cp "$source_pdf" "$dest_pdf"; then
        print_success "Copied: $display_dest_pdf"
        COPIED_COUNT=$((COPIED_COUNT + 1))
    else
        print_error "Failed to copy: $display_source_pdf"
        return 1
    fi
}

# Search for presentations
if [ -d "$REPO_ROOT/presentations" ]; then
    for project_dir in "$REPO_ROOT"/presentations/*/; do
        if [ ! -d "$project_dir" ]; then
            continue
        fi
        # Skip if it's the themes directory
        if [[ "$project_dir" != *"themes"* ]]; then
            project_dir="${project_dir%/}"  # Remove trailing slash

            # Check for main.tex first, then other .tex files
            if [ -f "$project_dir/main.tex" ]; then
                copy_pdf "$project_dir" "main.tex"
            else
                # Find any .tex files in the project root
                for texfile in "$project_dir"/*.tex; do
                    if [ -f "$texfile" ]; then
                        copy_pdf "$project_dir" "$(basename "$texfile")"
                    fi
                done
            fi
        fi
    done
fi

# Search for documents
if [ -d "$REPO_ROOT/documents" ]; then
    for project_dir in "$REPO_ROOT"/documents/*/; do
        if [ ! -d "$project_dir" ]; then
            continue
        fi
        # Skip if it's the themes directory
        if [[ "$project_dir" != *"themes"* ]]; then
            project_dir="${project_dir%/}"  # Remove trailing slash

            # Check for main.tex first, then other .tex files
            if [ -f "$project_dir/main.tex" ]; then
                copy_pdf "$project_dir" "main.tex"
            else
                # Find any .tex files in the project root
                for texfile in "$project_dir"/*.tex; do
                    if [ -f "$texfile" ]; then
                        copy_pdf "$project_dir" "$(basename "$texfile")"
                    fi
                done
            fi
        fi
    done
fi

print_header "Copy Summary"
print_success "$COPIED_COUNT copied"
print_info "$SKIPPED_COUNT skipped (unchanged)"
if [ $NOTFOUND_COUNT -gt 0 ]; then
    print_error "$NOTFOUND_COUNT not found (not built yet)"
fi

if [ $COPIED_COUNT -gt 0 ] || [ $SKIPPED_COUNT -gt 0 ]; then
    print_success "Copy complete!"
    exit 0
else
    print_info "No PDFs to copy. Run ${SCRIPT_DIR}/build-all.sh first."
    exit 1
fi
