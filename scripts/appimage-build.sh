#!/bin/bash

# Change dir to project root
cd ../

# Build linux binaries 
# flutter build linux --release

# Build AppImage from recipe
appimage-builder --recipe AppImageBuilder.yml


# Create and copy AppImage to output folder
mkdir -p outputs/
cp AppDir/usr/bin/printnotes-x86_64.AppImage outputs/

# Delete zsync file
rm printnotes-x86_64.AppImage.zsync

echo "AppImage has been successfully built and saved as 'outputs/printnotes-x86_64.AppImage'"