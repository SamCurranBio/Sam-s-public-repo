#!/bin/bash

# File paths
WEBPAGES_FILE="webpages.txt"
PHRASES_FILE="phrases.txt"
OUTPUT_DIR="results"
OUTPUT_FILE="${OUTPUT_DIR}/$(date +'%Y%m%d_%H%M%S')_results.tsv"

# Function to count occurrences of a phrase in webpage content
count_occurrences() {
    local url="$1"
    local phrase="$2"
    local content=$(curl -s "$url")
    local count=$(echo "$content" | grep -o -i "$phrase" | wc -l)
    if [ "$count" -gt 0 ]; then
        echo -e "$url\t$phrase\t$count"
    fi
}

# Clear output directory or create if not exists
mkdir -p "$OUTPUT_DIR"
> "$OUTPUT_FILE"

# Loop through each webpage in the list
while IFS= read -r url; do
    echo "Processing $url ..."
    
    # Loop through each phrase in the list
    while IFS= read -r phrase; do
        # Count occurrences of the phrase and append to output file if count > 0
        result=$(count_occurrences "$url" "$phrase")
        if [ -n "$result" ]; then
            echo "$result" >> "$OUTPUT_FILE"
        fi
    done < "$PHRASES_FILE"

    echo "---------------------------------------------"
done < "$WEBPAGES_FILE"

echo "Results saved to $OUTPUT_FILE"

