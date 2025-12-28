#!/bin/bash
# setup-swarm.sh - Initialize Docker Swarm and create overlay network

set -e

echo "=== NeoFeeder Swarm Setup ==="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker first."
    exit 1
fi

# Initialize Swarm if not already active
if docker info 2>/dev/null | grep -q "Swarm: active"; then
    echo "✓ Docker Swarm is already active"
else
    echo "Initializing Docker Swarm..."
    docker swarm init
    echo "✓ Docker Swarm initialized"
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "1. Build image for each instance:"
echo "   .swarm/build-image.sh stiembo"
echo "   .swarm/build-image.sh iikplmn"
echo ""
echo "2. Deploy stacks with different ports:"
echo "   .swarm/deploy.sh stiembo 8100 3003"
echo "   .swarm/deploy.sh iikplmn 8200 3103"
