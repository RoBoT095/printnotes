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

# Build linux binaries 
flutter build linux --release || { echo "Flutter build failed"; exit 1; }

# Build AppImage from recipe
appimage-builder --recipe AppImageBuilder.yml || { echo "AppImage build failed"; exit 1; }


# Check if outputs folder exists, create only if it doesn't
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Creating output directory..."
    mkdir -p $OUTPUT_DIR
fi

# Copy AppImage to outputs folder
cp AppDir/usr/bin/printnotes-x86_64.AppImage $OUTPUT_DIR || { echo "Failed to copy AppImage"; exit 1; }


# Check if zsync file exists before removing it
if [ -f "printnotes-x86_64.AppImage.zsync" ]; then
    echo "Removing zsync file..."
    rm printnotes-x86_64.AppImage.zsync
fi

echo "AppImage has been successfully built and saved as '$OUTPUT_DIR/printnotes-x86_64.AppImage'"