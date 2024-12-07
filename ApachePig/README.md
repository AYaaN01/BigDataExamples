# README - BDP Assignment 2

## Overview

This guide details the procedures for executing various PIG jobs on AWS EMR. It assumes that you have already configured and started an AWS EMR cluster and have access to the Hadoop environment.

## Preliminary Steps

### Transferring Files

To transfer the necessary files from your desktop to the AWS EMR jumphost and subsequently to localhost:

1. **Zip the Required Files** on your desktop.
2. **Transfer the Zip File** to the AWS EMR jumphost.
3. **Unzip and Move** the contents to localhost within the AWS EMR environment.

## Files Required on localhost

### Python Files

- `task2udf.py`

### Pig Files

- `task1.pig`
- `task2-1.pig`
- `task2-2.pig`

### CSV Files

- `competitor_event.csv`
- `medal.csv`
- `noc_region.csv`
- `person_region.csv`
- `person.csv`

## Setup on EMR

### Creating Input Directory and Uploading Files

Ensure that the `/input` directory is created and that csv files are uploaded to HDFS:

```bash
hadoop fs -mkdir /input

HDFS_INPUT_DIR="/input"
LOCAL_DATA_DIR="./"
FILES=("noc_region.csv" "person_region.csv" "person.csv" "competitor_event.csv" "medal.csv")

hdfs dfs -mkdir -p $HDFS_INPUT_DIR

for FILE in "${FILES[@]}"
do
  echo "Uploading $FILE to HDFS..."
  hdfs dfs -put -f $LOCAL_DATA_DIR/$FILE $HDFS_INPUT_DIR/
done

echo "All files uploaded successfully to HDFS $HDFS_INPUT_DIR."
```

## Running the Tasks

### Task 1

- **Execute**: `pig -x mapreduce task1.pig`
- **Output Path**: `/output/task1`

### Task 2.1

- **Execute**: `pig -x mapreduce task2-1.pig`
- **Output Path**: `/output/task2-1`

### Task 2.2

- **Execute**: `pig -x mapreduce task2-2.pig`
- **Output Path**: `/output/task2-2`

## Support

For any issues with execution or further instructions, please contact [s3977494@student.rmit.edu.au.](mailto:s3977494@student.rmit.edu.au.)
