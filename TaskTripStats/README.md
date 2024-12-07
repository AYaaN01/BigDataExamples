# README - BDP Assignment 1

## Overview

This guide details the procedures for executing various Hadoop jobs on AWS EMR. It assumes that you have already configured and started an AWS EMR cluster and have access to the Hadoop environment.

## Preliminary Steps

### Transferring Files

To transfer the necessary files from your desktop to the AWS EMR jumphost and subsequently to localhost:

1. **Zip the Required Files** on your desktop.
2. **Transfer the Zip File** to the AWS EMR jumphost.
3. **Unzip and Move** the contents to localhost within the AWS EMR environment.

## Files Required on localhost

### Python Files

- `checkConvergTask2.py`
- `mapperCountTask3.py`
- `mapperJoinTask3.py`
- `mapperSortTask3.py`
- `mapperTask1.py`
- `mapperTask2.py`
- `reducerCountTask3.py`
- `reducerJoinTask3.py`
- `reducerSortTask3.py`
- `reducerTask1.py`
- `reducerTask2.py`

### Bash Files

- `Task1-run.sh`
- `Task2-run.sh`
- `Task3-run.sh`

### Text Files

- `Taxis.txt`
- `Trips.txt`
- `initialization.txt`

### JAR File

- `hadoop-streaming-3.1.4.jar`

## Setup on EMR

### Creating Input Directory and Uploading Files

Ensure that the `/Input` directory is created and that `Taxis.txt` and `Trips.txt` are uploaded to HDFS:

```bash
hadoop fs -mkdir /Input
hadoop fs -put Taxis.txt /Input
hadoop fs -put Trips.txt /Input
```

### Permission Setup

Grant execution permissions to all shell script files:

```bash
chmod +x *.sh
```

## Running the Tasks

### Task 1

- **Execute**: `./Task1-run.sh`
- **Output Path**: `/Output/Task1`

### Task 2

- **Execute**: `./Task2-run.sh`
- **Output Path**: `/Output/Task2`

### Task 3

- **Execute**: `./Task3-run.sh`
- **Output Path**: `/Output/Task3`

## Support

For any issues with execution or further instructions, please contact [s3977494@student.rmit.edu.au.](mailto:s3977494@student.rmit.edu.au.)
