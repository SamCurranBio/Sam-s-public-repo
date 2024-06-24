#!/bin/bash

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <unique_identifier>"
    exit 1
fi

# Retrieve the unique identifier from the command-line argument
UNIQUE_IDENTIFIER=$1

# Use the unique identifier to create a folder
mkdir "$UNIQUE_IDENTIFIER"

echo "Folder '$UNIQUE_IDENTIFIER' created successfully."
