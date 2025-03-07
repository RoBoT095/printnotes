#!/bin/bash

# Exit if a command has a non zero status
set -e

# Change dir to project root
cd ../

# Build linux binaries 
flutter build linux --release || { echo "Flutter build failed"; exit 1; }

# Build AppImage from recipe
appimage-builder --recipe AppImageBuilder.yml || { echo "AppImage build failed"; exit 1; }


# Check if outputs folder exists, create only if it doesn't
if [ ! -d "outputs" ]; then
    echo "Creating outputs directory..."
    mkdir -p outputs/
fi

# Copy AppImage to outputs folder
cp AppDir/usr/bin/printnotes-x86_64.AppImage outputs/ || { echo "Failed to copy AppImage"; exit 1; }


# Check if zsync file exists before removing it
if [ -f "printnotes-x86_64.AppImage.zsync" ]; then
    echo "Removing zsync file..."
    rm printnotes-x86_64.AppImage.zsync
fi

echo "AppImage has been successfully built and saved as 'outputs/printnotes-x86_64.AppImage'"