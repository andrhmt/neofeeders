#!/bin/bash
# deploy.sh - Deploy a NeoFeeder stack
# Usage: ./deploy.sh <instance-name> <web-port> <webservice-port>
# Example: ./deploy.sh stiembo 8100 3003

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTANCE_NAME="${1}"
APP_PORT="${2}"
WS_PORT="${3}"

if [ -z "${INSTANCE_NAME}" ] || [ -z "${APP_PORT}" ] || [ -z "${WS_PORT}" ]; then
    echo "Usage: ./deploy.sh <instance-name> <web-port> <ws-port>"
    echo ""
    echo "Examples:"
    echo "  ./deploy.sh stiembo 8100 3003"
    echo "  ./deploy.sh iikplmn 8200 3103"
    exit 1
fi

ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
INSTANCE_DIR="${ROOT_DIR}/${INSTANCE_NAME}"
IMAGE_NAME="neofeeder-${INSTANCE_NAME}:latest"
STACK_NAME="neofeeder-${INSTANCE_NAME}"

if [ ! -d "${INSTANCE_DIR}" ]; then
    echo "Error: Instance directory not found: ${INSTANCE_DIR}"
    exit 1
fi

# Check if image exists
if ! docker image inspect "${IMAGE_NAME}" > /dev/null 2>&1; then
    echo "Error: Image not found: ${IMAGE_NAME}"
    echo "Please build the image first: .swarm/build-image.sh ${INSTANCE_NAME}"
    exit 1
fi

# Create required directories
mkdir -p "${INSTANCE_DIR}/logs/postgresql"
mkdir -p "${INSTANCE_DIR}/logs/supervisor"
mkdir -p "${INSTANCE_DIR}/prefill_pddikti"

# Copy pg_hba.conf if not exists
if [ ! -f "${INSTANCE_DIR}/pg_hba.conf" ]; then
    cp "${SCRIPT_DIR}/pg_hba.conf" "${INSTANCE_DIR}/pg_hba.conf"
fi

echo "=== Deploying NeoFeeder Stack ==="
echo "Stack Name: ${STACK_NAME}"
echo "Instance: ${INSTANCE_NAME}"
echo "Web Port: ${APP_PORT}"
echo "Webservice Port: ${WS_PORT}"
echo "Image: ${IMAGE_NAME}"
echo ""

# Deploy the stack
APP_PATH_HOST="${INSTANCE_DIR}" \
APP_IMAGE="${IMAGE_NAME}" \
APP_PORT="${APP_PORT}" \
WS_PORT="${WS_PORT}" \
docker stack deploy -c "${SCRIPT_DIR}/swarm.yml" "${STACK_NAME}"

echo ""
echo "✓ Stack deployed: ${STACK_NAME}"
echo ""
echo "Check status with:"
echo "  docker stack ls"
echo "  docker stack services ${STACK_NAME}"
echo "  docker stack ps ${STACK_NAME}"
echo ""
echo "Access the application at:"
echo "  Web UI: http://localhost:${APP_PORT}"
echo "  WebSocket: ws://localhost:${WS_PORT}"
echo ""
echo "To remove this stack:"
echo "  docker stack rm ${STACK_NAME}"
