#!/bin/bash

# Define the output directory
OUTPUT_DIR="outputs"

# Exit if a command has a non zero status
set -e

# Check if the current working directory ends with 'scripts'
if [[ "$PWD" == *"scripts" ]]; then
  # Change dir to project root
  cd ../
else
  echo "Error: Script must be run from within the 'scripts/' folder."
  exit 1
fi

# Build the docker image
docker build -t flutter-builder ./. || { echo "Docker build failed"; exit 1; }

#  Create a container
docker create --name printnotes-build flutter-builder || { echo "Docker container creation failed"; exit 1; }

# Check if outputs folder exists, create only if it doesn't
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Creating outputs directory..."
    mkdir -p $OUTPUT_DIR
fi

# Copy the APKs out from container to host machines build dir
docker cp printnotes-build:/app/output/. $OUTPUT_DIR || { echo "Failed to copy from container"; exit 1; }

# Remove the container
docker rm printnotes-build || { echo "Failed to remove docker container"; exit 1; }

echo "APKs have been successfully built and saved to '$OUTPUT_DIR'"