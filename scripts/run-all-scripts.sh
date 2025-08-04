#!/bin/bash

# Run all the scripts in one go

# Exit if a command has a non zero status
set -e

# Get all the apk files
sh ./docker-build.sh

# Get appimage
sh ./appimage-build.sh

# Output SHA1 hash of apps into .txt file
sh ./get-hash.sh

echo "All Scripts have ran Successfully!"