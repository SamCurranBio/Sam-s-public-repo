#!/bin/bash

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "run as backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi



# [TASK 1]
targetDirectory=$1
destinationDirectory=$2


# [TASK 2]
echo targetDirectory 
echo destinationDirectory

# [TASK 3]
currentTS=$(date +%s)

# [TASK 4]
backupFileName="backup-$currentTS.tar.gz"
#echo $backupFileName
# We're going to:
  # 1: Go into the target directory
  # 2: Create the backup file
  # 3: Move the backup file to the destination directory

# To make things easier, we will define some useful variables...

# [TASK 5]
origAbsPath=$(pwd)

# [TASK 6]
cd $destinationDirectory

destDirAbsPath=$(pwd)
#echo $destDirAbsPath
# [TASK 7]
cd ..
cd $targetDirectory

# [TASK 8]
yesterdayTS=$(($currentTS - 24 * 60 * 60))
#echo $yesterdayTS


# [TASK 9]
declare -a toBackup #establishes an array

for file in $(ls)
do
  #echo "$file"
  file_modified_date=$(date -r $file +%s)
  #echo $file_modified_date
  # [TASK 10]
  if (($file_modified_date > $yesterdayTS))
  then
    echo "$file was modified in the last 24hr"
    # [TASK 11]
    toBackup+=($file)
  fi
done

# [TASK 12]

echo "toBackup has ${#toBackup[@]} elements:"

tar -czvf $backupFileName ${toBackup[@]}


# [TASK 13]
mv ./$backupFileName ../$destinationDirectory

# Congratulations! You completed the final project for this course!
