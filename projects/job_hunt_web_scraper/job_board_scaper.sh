#!/bin/bash

# File paths
WEBPAGES_FILE="webpages.txt"
PHRASES_FILE="phrases.txt"
RESULTS_DIR="results"
OUTPUT_FILE="${RESULTS_DIR}/$(date +'%Y%m%d_%H%M%S')_results.tsv"

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
mkdir -p "$RESULTS_DIR"
> "$OUTPUT_FILE"

# Loop through each webpage in the list
echo "Querying webpages from $WEBPAGES_FILE." 

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

######################--------this part does the comparing between queryies  ############------

# Directory containing results files
OUTPUT_FILE="${RESULTS_DIR}/$(date +'%Y%m%d_%H%M%S')_new_results.tsv"

# Function to get most- and second-most recent TSV files by creation date


get_files() {
    echo "Comparing most and second-most recent TSV files by creation date in $RESULTS_DIR"
    local files=() # set empty array called files

    # Populate the array with filenames sorted by modification time
    while IFS= read -r file; do
        files+=("$file")
    done < <(ls -t "$RESULTS_DIR"/*.tsv 2>/dev/null)

    # Print all items in the array (for debugging)
    #for file in "${files[@]}"; do
    #    echo "$file"
    #done
    
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
#comm -23 <(sort "$most_recent_file") <(sort "$second_most_recent_file") 

# Run comm command to find differences
comm_output=$(comm -23 <(sort "$most_recent_file") <(sort "$second_most_recent_file"))

# Check if there are differences
if [ -n "$comm_output" ]; then
    echo "Wow, new jobs potentially found! Go get 'em tiger. Adding to $OUTPUT_FILE:"
    echo "$comm_output" >> $OUTPUT_FILE
else
    echo "No new queries found between $most_recent_file and $second_most_recent_file. Sorry bud, try tomorrow."
fi






