#!/bin/bash

# Check if keyword and output folder name are provided as arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <keyword> <output_folder>"
    exit 1
fi

# Assign the first argument to the keyword variable
keyword=$1
output_folder=$2
destination_path=~/work/morales_lab/$output_folder

# Print the input keyword and output folder name
echo "Keyword: $keyword"
echo "destination path is $destination_path"



#checking the folder doesn't exist already
if [ -d "$destination_path" ]; then
	echo "Folder '$output_folder' already exists, please resolve before continuing"
	exit 1
else
	echo "Making folders"
fi

#make an output directory for the files 
mkdir -p ~/work/morales_lab/$output_folder
mkdir -p ~/work/morales_lab/$output_folder/raw_reads
mkdir -p ~/work/morales_lab/$output_folder/trimmomatic
mkdir -p ~/work/morales_lab/$output_folder/spades
mkdir -p ~/work/morales_lab/$output_folder/augustus
mkdir -p ~/work/morales_lab/$output_folder/busco


read -p "Directories created. Do you want to continue running pipelines? y/n": confirm
if [[ $confirm == "n" ]]; then
	echo "Operation aborted."
else
	echo "Continuing with grouping and extracting files."

fi

