# README - BDP Assignment 3

## Overview

This guide details the procedures for executing the jar file in AWS EMR platform. It assumes that you have already configured and started an AWS EMR cluster and have access to the Hadoop environment.

## Preliminary Steps

### Transferring Files

To transfer the necessary files from your desktop to the AWS EMR jumphost and subsequently to localhost:

1. **Transfer this Zip File** to the AWS EMR jumphost.
2. **Unzip and Move** the contents to localhost within the AWS EMR environment.

## Files Required on localhost

### Jar Files

- `ScalaSparkStreaming.jar`

## Setup on EMR

### Creating Input Directory and Uploading Files

Ensure that the `/input` and `/output` directory is created :

```bash
hadoop fs -mkdir /input
hadoop fs -mkdir /output
```

## Running the Jar file for all the Tasks

To run the streaming app run the following line in the cluster master node.

```bash
spark-submit --class org.example.StreamingApp ScalaSparkStreaming.jar hdfs:///input hdfs:///output
```

Login HUE or you can use the terminal to upload files into the `/input` directory

```bash
hadoop fs -put ./<file_name>.txt /input
```

## Support

For any issues with execution or further instructions, please contact [s3977494@student.rmit.edu.au.](mailto:s3977494@student.rmit.edu.au.)
