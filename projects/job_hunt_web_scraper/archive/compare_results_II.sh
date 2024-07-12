#!/bin/bash

# Directory containing results files
RESULTS_DIR="results"
OUTPUT_FILE="${RESULTS_DIR}/$(date +'%Y%m%d_%H%M%S')_new_results.tsv"

# Function to get the second most recent file
get_files() {
    local files=() # set empty array called files

    # Populate the array with filenames sorted by modification time
    while IFS= read -r file; do
        files+=("$file")
    done < <(ls -t "$RESULTS_DIR"/*.tsv 2>/dev/null)

    # Print all items in the array (for debugging)
    for file in "${files[@]}"; do
        echo "$file"
    done
    
    most_recent_file=${files[0]}
    second_most_recent_file=${files[1]}


    # If there are at least 2 files, print the second most recent one
    if [ ${#files[@]} -gt 1 ]; then
    	echo "most recent file: $most_recent_file"
        echo "Second most recent file: $second_most_recent_file"
    else
        echo "Error: Not enough files in '$RESULTS_DIR'."
        exit 1
    fi
    
    

}

# Call the function
get_files
comm -23 <(sort "$most_recent_file") <(sort "$second_most_recent_file") >> $OUTPUT_FILE 



