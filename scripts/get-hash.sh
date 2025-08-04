#!/bin/bash

# Define the output directory and hash file
OUTPUT_DIR="../outputs"
HASH_FILE="../outputs/app_hashes.txt"

# Check if the outputs directory exists
if [ ! -d "$OUTPUT_DIR" ]; then
  echo "Error: Directory '$OUTPUT_DIR' does not exist."
  exit 1
fi

# Remove previous hash file if it exists
if [ -f "$HASH_FILE" ]; then
  rm "$HASH_FILE"
fi

# Remove all .sha1 files in the outputs directory
find "$OUTPUT_DIR" -type f -name "*.sha1" -exec rm -f {} +

# Count how many files need processing
file_count=$(find "$OUTPUT_DIR" -type f | wc -l)
echo "Generating SHA1 hashes for $file_count files in $OUTPUT_DIR folder"

# Process each file in the directory
find "$OUTPUT_DIR" -type f | sort | while read -r file; do
  # Get just the filename without the path
  filename=$(basename "$file")
  
  # Calculate SHA1 hash
  hash=$(sha1sum "$file" | awk '{print $1}')
  
  # Append to hash file with the desired format
  echo "- **$filename:** $hash" >> "$HASH_FILE"
  
  echo "Processed: $filename"
done

echo "Complete! SHA1 hashes have been saved to $HASH_FILE"