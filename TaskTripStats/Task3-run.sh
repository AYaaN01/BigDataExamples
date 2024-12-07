#!/bin/bash

# Define input and output paths
INPUT_PATH=/Input
OUTPUT_PATH=/Output/Task3

# Concatenate Taxis.txt and Trips.txt locally and upload the combined file to HDFS
hadoop fs -cat $INPUT_PATH/Taxis.txt $INPUT_PATH/Trips.txt | hdfs dfs -put - $INPUT_PATH/taxiTripDataset.txt
cat Taxis.txt Trips.txt > taxiTripDataset.txt
hadoop fs -put -f taxiTripDataset.txt $INPUT_PATH/taxiTripDataset.txt

# Remove existing output directory if any
hadoop fs -rm -r -f $OUTPUT_PATH

# Run Hadoop streaming job for Join Operation
hadoop jar ./hadoop-streaming-3.1.4.jar \
    -D stream.num.map.output.key.fields=2 \
    -D mapred.text.key.partitioner.options=-k1,1 \
    -D mapred.reduce.tasks=3 \
    -file ./mapperJoinTask3.py \
    -mapper "python3 ./mapperJoinTask3.py" \
    -file ./reducerJoinTask3.py \
    -reducer "python3 ./reducerJoinTask3.py" \
    -input $INPUT_PATH/taxiTripDataset.txt \
    -output $OUTPUT_PATH \
    -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner 

# merging the outputs and adding temp join output in input
hadoop fs -getmerge $OUTPUT_PATH/part* joinedData.txt
hadoop fs -put -f joinedData.txt $INPUT_PATH/joinedData.txt

# Remove the existing output directory 
hadoop fs -rm -r -f $OUTPUT_PATH

# Removing merged data
rm taxiTripDataset.txt
hadoop fs -rm -r $INPUT_PATH/taxiTripDataset.txt

# Run Hadoop streaming job for Count operation
hadoop jar ./hadoop-streaming-3.1.4.jar \
    -D stream.num.map.output.key.fields=1 \
    -D mapred.text.key.partitioner.options=-k1,1n \
    -D mapred.reduce.tasks=3 \
    -file ./mapperCountTask3.py \
    -mapper "python3 ./mapperCountTask3.py" \
    -file ./reducerCountTask3.py \
    -reducer "python3 ./reducerCountTask3.py" \
    -input $INPUT_PATH/joinedData.txt \
    -output $OUTPUT_PATH \
    -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner 

# merging the outputs and adding temp count output in input
hadoop fs -getmerge $OUTPUT_PATH/part* countData.txt
hadoop fs -put -f countData.txt $INPUT_PATH/countData.txt

# Remove existing output directory 
hadoop fs -rm -r -f $OUTPUT_PATH

# Removing joint data
rm joinedData.txt
hadoop fs -rm -r $INPUT_PATH/joinedData.txt

# Run Hadoop streaming job for Task sorting
hadoop jar ./hadoop-streaming-3.1.4.jar \
    -D mapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator \
    -D stream.num.map.output.key.fields=1 \
    -D mapred.text.key.partitioner.options=-k1,1 \
    -D mapred.text.key.comparator.options='-k1,1n' \
    -D mapred.reduce.tasks=1 \
    -file ./mapperSortTask3.py \
    -mapper "python3 ./mapperSortTask3.py" \
    -file ./reducerSortTask3.py \
    -reducer "python3 ./reducerSortTask3.py" \
    -input $INPUT_PATH/countData.txt \
    -output $OUTPUT_PATH \
    -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner 

# Removing count data
rm countData.txt
hadoop fs -rm -r $INPUT_PATH/countData.txt