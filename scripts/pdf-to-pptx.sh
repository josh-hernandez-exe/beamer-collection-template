#!/bin/bash

#************************************************************
# pdf-to-pptx.sh
# Convert PDF presentations to PowerPoint format
#
# Usage:
#   ./scripts/pdf-to-pptx.sh <pdf-file> [output-file.pptx]
#   ./scripts/pdf-to-pptx.sh presentations/my-project/out/main.pdf
#   ./scripts/pdf-to-pptx.sh presentations/my-project/out/main.pdf out/my-presentation.pptx
#
# Requirements:
#   - python3 with pdf2image and python-pptx (recommended)
#   - OR libreoffice (limited support)
#
# Note: PDF to PPTX conversion is not directly supported by most tools.
# Use Python libraries for reliable conversion.
#************************************************************

set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
print_error() {
    echo -e "${RED}Error: $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

print_usage() {
    echo "Usage: $0 <pdf-file> [output-file.pptx]"
    echo ""
    echo "Examples:"
    echo "  $0 presentations/university-demo/out/main.pdf"
    echo "  $0 presentations/my-project/out/main.pdf out/my-presentation.pptx"
    echo ""
    exit 1
}

resolve_path() {
    local input_path="$1"

    if [[ "$input_path" = /* ]]; then
        printf '%s\n' "$input_path"
        return 0
    fi

    if [ -e "$REPO_ROOT/$input_path" ]; then
        printf '%s\n' "$REPO_ROOT/$input_path"
        return 0
    fi

    printf '%s\n' "$input_path"
}

display_path() {
    local absolute_path="$1"

    if [[ "$absolute_path" == "$REPO_ROOT"/* ]]; then
        printf '%s\n' "${absolute_path#$REPO_ROOT/}"
    else
        printf '%s\n' "$absolute_path"
    fi
}

# Check arguments
if [ $# -lt 1 ]; then
    print_error "Missing PDF file argument"
    print_usage
fi

PDF_FILE="$(resolve_path "$1")"

# Check if PDF exists
if [ ! -f "$PDF_FILE" ]; then
    print_error "PDF file not found: $PDF_FILE"
    exit 1
fi

# Determine output filename
if [ -z "$2" ]; then
    # Default: same name as PDF but with .pptx extension
    PPTX_FILE="${PDF_FILE%.*}.pptx"
else
    PPTX_FILE="$(resolve_path "$2")"
fi

# Ensure output directory exists
mkdir -p "$(dirname "$PPTX_FILE")"

print_info "Converting: $(display_path "$PDF_FILE") → $(display_path "$PPTX_FILE")"

# Method 1: Try Python with pdf2image and python-pptx
if command -v python3 &> /dev/null; then
    if python3 -c "import pdf2image, pptx" 2>/dev/null; then
        print_info "Using Python (pdf2image + python-pptx) for conversion..."

        # Create a temporary Python script for conversion
        TEMP_SCRIPT=$(mktemp --suffix=.py)
        trap "rm -f $TEMP_SCRIPT" EXIT

        cat > "$TEMP_SCRIPT" << 'PYEOF'
import sys, os, tempfile
from pdf2image import convert_from_path
from pptx import Presentation
from pptx.util import Inches

try:
    pdf_file, pptx_file = sys.argv[1], sys.argv[2]
    images = convert_from_path(pdf_file)
    prs = Presentation()
    prs.slide_width = Inches(10)
    prs.slide_height = Inches(7.5)

    with tempfile.TemporaryDirectory() as tmpdir:
        for idx, image in enumerate(images):
            slide = prs.slides.add_slide(prs.slide_layouts[6])
            image_path = os.path.join(tmpdir, f'page_{idx}.png')
            image.save(image_path, 'PNG')
            pic = slide.shapes.add_picture(image_path, Inches(0), Inches(0),
                                          width=prs.slide_width, height=prs.slide_height)

    prs.save(pptx_file)
    print(f"Conversion complete: {pptx_file}", file=sys.stderr)
except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)
PYEOF

        if python3 "$TEMP_SCRIPT" "$PDF_FILE" "$PPTX_FILE" 2>&1; then
            print_success "Conversion complete: $(display_path "$PPTX_FILE")"
            exit 0
        else
            print_error "Python conversion failed"
        fi
    fi
fi

# No conversion tool available
print_error "PDF to PPTX conversion requires Python libraries"
echo ""
echo "Install the required packages:"
echo "  pip install pdf2image python-pptx pillow"
echo "  sudo apt-get install poppler-utils"
echo ""
echo "Or use alternatives:"
echo "  - Online converter: https://cloudconvert.com/"
echo "  - Export directly to PPTX from your presentation tool"
echo "  - Use modern PowerPoint (can import PDF files)"
echo ""

exit 1
