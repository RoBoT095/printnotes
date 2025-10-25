#!/bin/bash

# Run all the scripts in one go

# Exit if a command has a non zero status
set -e

# Generate file with library licenses
cd ../
dart run dart_pubspec_licenses:generate
cd scripts/

# Get all the apk files
sh ./docker-build.sh

# Get appimage
sh ./appimage-build.sh

# TODO: Add a separate script for this
# Get deb
cd ../
sh fastforge package --platform linux --targets deb
cd scripts/

# Output SHA1 hash of apps into .txt file
sh ./get-hash.sh

echo "All Scripts have ran Successfully!"