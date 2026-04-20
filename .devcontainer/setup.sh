#!/bin/bash
# Post-container creation setup script

set -e

# Install system dependencies for PDF conversion
echo "Installing system packages..."
sudo apt-get update -qq
sudo apt-get install -y --no-install-recommends poppler-utils
echo "System packages installed."

# Install Python dependencies
if [ -f "requirements.txt" ]; then
    echo "Installing Python dependencies from requirements.txt..."
    pip install -r requirements.txt
else
    echo "requirements.txt not found at workspace root"
fi

# Install Python packages for PDF to PPTX conversion
pip install pdf2image python-pptx pillow

# Install uv package manager (optional, fast Python package installer)
echo "Installing uv package manager..."
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "Container setup complete!"
