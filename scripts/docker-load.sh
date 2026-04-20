#!/usr/bin/env bash
# Load a previously saved devcontainer image into Docker's cache.
# Run this on the HOST machine BEFORE rebuilding the container in VS Code.
# Docker will find the image in its cache and skip re-downloading packages.
#
# Usage:
#   ./scripts/docker-load.sh [input-file]
#
# Default input: ~/docker-cache/beamer-collection.tar
#
# Example:
#   ./scripts/docker-load.sh
#   ./scripts/docker-load.sh /mnt/shared/beamer-collection.tar

set -euo pipefail

INPUT_FILE="${1:-$HOME/docker-cache/beamer-collection.tar}"

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: File not found: ${INPUT_FILE}"
    echo ""
    echo "Run docker-save.sh first to create the cache file:"
    echo "  ./scripts/docker-save.sh"
    exit 1
fi

SIZE=$(du -sh "$INPUT_FILE" | cut -f1)
echo "Loading Docker image from: ${INPUT_FILE} (${SIZE})"
echo "This may take a minute..."

docker load -i "${INPUT_FILE}"

echo ""
echo "Done. The image is now in Docker's local cache."
echo "You can now rebuild the devcontainer in VS Code and it will use the cached image."
echo "(Cmd/Ctrl+Shift+P → 'Dev Containers: Rebuild Container')"
