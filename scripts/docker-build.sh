#!/bin/bash

# Build the docker image
docker build -t flutter-builder ../.

#  Create a container
docker create --name printnotes-build flutter-builder

# Copy the APKs out from container to host machines build dir
docker cp printnotes-build:/app/output ../outputs

# Remove the container
docker rm printnotes-build

echo "APKs have been successfully built and saved to 'outputs/'"