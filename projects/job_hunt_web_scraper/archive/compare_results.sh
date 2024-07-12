#!/bin/bash

# Directory containing results files
RESULTS_DIR="results"


# Function to get the second most recent file
get_second_most_recent_file() {
    local files=()
    while IFS= read -r -d '' file; do
        files+=("$file")
    done < <(find "$RESULTS_DIR" -maxdepth 1 -type f -name "*.tsv" 2>/dev/null | sort -znr | tail -n +2)
    if [ ${#files[@]} -gt 0 ]; then
        echo "${files[0]}"
#    else
#        echo "Error: No '.tsv' files found in '$RESULTS_DIR'."
#        exit 1
	fi
}

# Get the two most recent files
most_recent_file=$(find "$RESULTS_DIR" -maxdepth 1 -type f -name "*.tsv" 2>/dev/null | sort -znr | head -n 1)
second_most_recent_file=$(get_second_most_recent_file)

# Debug: Print files found
#echo "Files found:"
#ls -l "$RESULTS_DIR"

#debugging each file find 
#if [ -z "$most_recent_file" ]; then
#	echo "Error: missing most recent file"
#	exit 1
#fi
#
#if [ -z "$second_most_recent_file" ]; then
#	echo "Error: missing SECOND most recent file"
#	exit 1
#fi
	
# Check if files were found
#if [ -z "$most_recent_file" ] || [ -z "$second_most_recent_file" ]; then
#    echo "Error: Could not find two most recent results files."
#    exit 1
#fi

echo "Most recent file: $most_recent_file"
echo "Second most recent file: $second_most_recent_file"

# Compare the files
echo "Comparing $most_recent_file with $second_most_recent_file:"
diff "$most_recent_file" "$second_most_recent_file" > $RESULTS_DIR/new_positions.txt

