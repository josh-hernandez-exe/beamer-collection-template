#!/bin/bash

#************************************************************
# pdf-to-pptx-all.sh
# Convert all built presentation PDFs to PowerPoint format
#
# Usage:
#   ./scripts/pdf-to-pptx-all.sh
#
# The script searches for PDFs in presentations/*/out/ and converts
# each one to a sibling .pptx file using pdf-to-pptx.sh.
#************************************************************

set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
CONVERTER_SCRIPT="${SCRIPT_DIR}/pdf-to-pptx.sh"
DROPBOX_DIR="${REPO_ROOT}/dropbox"

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

print_header "Converting Presentation PDFs to PPTX"

mkdir -p "$DROPBOX_DIR"

SUCCESS_COUNT=0
FAIL_COUNT=0
TOTAL_COUNT=0

if [ ! -d "$REPO_ROOT/presentations" ]; then
    print_error "Presentations directory not found"
    exit 1
fi

for project_dir in "$REPO_ROOT"/presentations/*/; do
    if [ ! -d "$project_dir" ]; then
        continue
    fi

    if [[ "$project_dir" == *"themes"* ]] || [[ "$project_dir" == *"common"* ]]; then
        continue
    fi

    for pdf_file in "${project_dir%/}"/out/*.pdf; do
        if [ ! -f "$pdf_file" ]; then
            continue
        fi

        TOTAL_COUNT=$((TOTAL_COUNT + 1))
        print_info "Converting: $(display_path "$pdf_file")"

        # Derive dropbox output name: project_name-pdfbasename.pptx
        # e.g. presentations/corporate-demo/out/main.pdf → dropbox/corporate-demo-main.pptx
        project_name=$(basename "${project_dir%/}")
        pdf_basename=$(basename "${pdf_file%.*}")
        pptx_out="${DROPBOX_DIR}/${project_name}-${pdf_basename}.pptx"

        if bash "$CONVERTER_SCRIPT" "$pdf_file" "$pptx_out"; then
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        else
            FAIL_COUNT=$((FAIL_COUNT + 1))
        fi
    done
done

print_header "Conversion Summary"
print_success "$SUCCESS_COUNT succeeded"
if [ $FAIL_COUNT -gt 0 ]; then
    print_error "$FAIL_COUNT failed"
fi
echo "Total: $TOTAL_COUNT files"

if [ $TOTAL_COUNT -eq 0 ]; then
    print_info "No presentation PDFs found. Run ${SCRIPT_DIR}/build-all.sh first."
    exit 1
fi

if [ $FAIL_COUNT -eq 0 ]; then
    print_success "All presentation PDFs converted successfully!"
    exit 0
fi

exit 1
