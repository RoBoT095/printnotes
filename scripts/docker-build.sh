#!/bin/bash

# Exit if a command has a non zero status
set -e

# Build the docker image
docker build -t flutter-builder ../. || { echo "Docker build failed"; exit 1; }

#  Create a container
docker create --name printnotes-build flutter-builder || { echo "Docker container creation failed"; exit 1; }

# Check if outputs folder exists, create only if it doesn't
if [ ! -d "outputs" ]; then
    echo "Creating outputs directory..."
    mkdir -p outputs/
fi

# Copy the APKs out from container to host machines build dir
docker cp printnotes-build:/app/output ../outputs || { echo "Failed to copy from container"; exit 1; }

# Remove the container
docker rm printnotes-build || { echo "Failed to remove docker container"; exit 1; }

echo "APKs have been successfully built and saved to 'outputs/'"