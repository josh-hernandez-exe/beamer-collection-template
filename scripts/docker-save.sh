#!/usr/bin/env bash
# Save the current devcontainer image to a tar file for later reuse.
# Run this on the HOST machine (not inside the container) after a successful
# devcontainer build to cache the image and avoid re-downloading packages.
#
# Usage:
#   ./scripts/docker-save.sh [output-file]
#
# Default output: ~/docker-cache/beamer-collection.tar
#
# Example:
#   ./scripts/docker-save.sh
#   ./scripts/docker-save.sh /mnt/shared/beamer-collection.tar

set -euo pipefail

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKSPACE_NAME="$(basename "$WORKSPACE_DIR")"
OUTPUT_FILE="${1:-$HOME/docker-cache/beamer-collection.tar}"

# devcontainer names the image using the workspace folder name (lowercased)
IMAGE_NAME="vsc-${WORKSPACE_NAME,,}"

echo "Looking for devcontainer image matching: ${IMAGE_NAME}..."

IMAGE_ID=$(docker images --format "{{.Repository}}:{{.Tag}} {{.ID}}" \
    | grep -i "^${IMAGE_NAME}" \
    | awk '{print $2}' \
    | head -1)

if [[ -z "$IMAGE_ID" ]]; then
    echo "Error: No image found matching '${IMAGE_NAME}'."
    echo "Available images:"
    docker images --format "  {{.Repository}}:{{.Tag}}"
    echo ""
    echo "You can specify a different image by editing IMAGE_NAME in this script,"
    echo "or run: docker images  to find the correct name."
    exit 1
fi

IMAGE_FULL=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep -i "^${IMAGE_NAME}" | head -1)
echo "Found image: ${IMAGE_FULL} (${IMAGE_ID})"

mkdir -p "$(dirname "$OUTPUT_FILE")"

echo "Saving to: ${OUTPUT_FILE}"
echo "This may take a few minutes..."
docker save "${IMAGE_ID}" -o "${OUTPUT_FILE}"

SIZE=$(du -sh "${OUTPUT_FILE}" | cut -f1)
echo "Done. Image saved (${SIZE}): ${OUTPUT_FILE}"
echo ""
echo "To restore on a new machine or after Docker clears its cache, run:"
echo "  ./scripts/docker-load.sh ${OUTPUT_FILE}"
