#!/bin/bash
# build-image.sh - Build Docker image for a NeoFeeder instance
# Usage: ./build-image.sh <instance-name>
# Example: ./build-image.sh stiembo

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTANCE_NAME="${1}"

if [ -z "${INSTANCE_NAME}" ]; then
    echo "Usage: ./build-image.sh <instance-name>"
    echo "Example: ./build-image.sh stiembo"
    exit 1
fi

ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
INSTANCE_DIR="${ROOT_DIR}/${INSTANCE_NAME}"

if [ ! -d "${INSTANCE_DIR}" ]; then
    echo "Error: Instance directory not found: ${INSTANCE_DIR}"
    exit 1
fi

if [ ! -d "${INSTANCE_DIR}/app" ]; then
    echo "Error: app directory not found in ${INSTANCE_DIR}"
    exit 1
fi

IMAGE_NAME="neofeeder-${INSTANCE_NAME}:latest"

echo "=== Building NeoFeeder Image ==="
echo "Instance: ${INSTANCE_NAME}"
echo "Source: ${INSTANCE_DIR}"
echo "Image: ${IMAGE_NAME}"
echo ""

# Build the image
docker build \
    -t "${IMAGE_NAME}" \
    -f "${SCRIPT_DIR}/DockerfileSwarm" \
    "${INSTANCE_DIR}"

echo ""
echo "✓ Image built successfully: ${IMAGE_NAME}"
echo ""
echo "To deploy this instance:"
echo "  .swarm/deploy.sh ${INSTANCE_NAME} <web-port> <ws-port>"
echo ""
echo "Example:"
echo "  .swarm/deploy.sh ${INSTANCE_NAME} 8100 3003"
