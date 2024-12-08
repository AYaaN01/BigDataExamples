# Sample Big Data Processing Tasks

This repository contains sample big data processing tasks executed on **AWS EWR** using the **Hadoop platform**. The tasks are implemented in **Python**, **Apache Pig**, and **Scala**. Each task demonstrates different aspects of big data processing, including batch processing, querying, and streaming data analysis.

## Project Structure

### 1. **TaskTripStats**
- **Type**: MapReduce Task
- **Language**: Python
- **Description**: 
  - Processes taxi trip data to compute key statistics such as:
    - Total number of trips.
    - Maximum, minimum, and average fares for each trip type (long, medium, short).
  - Utilizes **in-mapper combining** to optimize processing.
  - Runs on the Hadoop platform.


### 2. **Apache PIG**
- **Type**: PIG/HIVE Task
- **Language**: Apache Pig
- **Description**: 
  - Executes big data queries on an Olympic Games database.
  - Performs tasks such as:
    - Data aggregation and filtering.
    - Sorting and ranking based on medal counts.
    - Handling missing values and generating clean outputs.
  - Explores Hive-like functionality with Apache Pig for high-level data manipulation.


### 3. **Spark Streaming**
- **Type**: Streaming Task
- **Language**: Scala
- **Description**: 
  - Monitors live streaming of text files in a directory.
  - Implements real-time analytics using Apache Spark Streaming.
  - Handles data ingestion, transformation, and summarization on the fly.
  - Ideal for processing continuously generated data, such as logs or real-time feeds.


## Prerequisites
- **AWS Setup**: Ensure your AWS environment is configured with:
  - EMR (Elastic MapReduce) cluster for running Hadoop and Spark jobs.
  - Necessary IAM roles and permissions for accessing S3, HDFS, etc.
- **Software/Dependencies**:
  - Hadoop 3.1.4
  - Apache Pig
  - Apache Spark (Scala 1.2)
  - Python 3.11
  - Java 8+
  - sbt (Scala Build Tool)


## Setup and Execution

### General Steps:
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/sample-bigdata-tasks.git
   cd sample-bigdata-tasks
2. Upload your datasets to the specified HDFS or S3 location for each file directory.


## Task-Specific Execution:

### TaskTripStats:
- Navigate to the TaskTripStats folder.
- Run the Python MapReduce scripts **Task1-run.sh**, **Task2-run.sh** and **Task3-run.sh** on Hadoop

### Apache PIG:
- Navigate to the TaskTripStats folder.
- First run the bash script **run.sh**
- Run the Python MapReduce scripts **pig -x mapreduce task1.pig**, **pig -x mapreduce task2-1.pig** and **pig -x mapreduce task2-2.pig** on Hadoop

### Spark Streaming:
- Navigate to the SparkStreaming folder.
- Submit the Spark application:
```bash
spark-submit --class org.example.StreamingApp ScalaSparkStreaming.jar hdfs:///input hdfs:///output
```

## License

This repository is licensed under the MIT License and the tasks is based on course material provided by RMIT University, Melbourne for the course big data processing.