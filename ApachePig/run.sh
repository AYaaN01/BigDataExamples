#!/bin/bash

# Define the HDFS input directory
HDFS_INPUT_DIR="/input"

# Define the local directory where your CSV files are stored
LOCAL_DATA_DIR="./"

# Define the names of the CSV files
FILES=("noc_region.csv" "person_region.csv" "person.csv" "competitor_event.csv" "medal.csv")

# Create the input directory on HDFS if it doesn't already exist
hdfs dfs -mkdir -p $HDFS_INPUT_DIR

# Upload each file to HDFS
for FILE in "${FILES[@]}"
do
  echo "Uploading $FILE to HDFS..."
  hdfs dfs -put -f $LOCAL_DATA_DIR/$FILE $HDFS_INPUT_DIR/
done

echo "All files uploaded successfully to HDFS $HDFS_INPUT_DIR."

