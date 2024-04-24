#!/bin/bash

# Prompt user for image file
read -p "Enter the path to the image file: " image_file

# Check if the image file exists
if [ ! -f "$image_file" ]; then
    echo "Error: Image file not found."
    exit 1
fi

# Generate histogram of the image
histogram=$(convert "$image_file" -format %c -depth 8 histogram:info:-)

# Extract counts for all hex codes
all_counts=$(echo "$histogram" | awk '{print $1}')

# Print counts for all hex codes
echo "Counts for all hex codes in the image:"
echo "$all_counts"
