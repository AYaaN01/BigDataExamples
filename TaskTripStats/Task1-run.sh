#!/bin/bash

# Define input and output paths
INPUT_PATH=/Input/Trips.txt
OUTPUT_PATH=/Output/Task1

# Clean up output directory to avoid hadoop errors 
hadoop fs -rm -r $OUTPUT_PATH

hadoop jar ./hadoop-streaming-3.1.4.jar \
    -D stream.num.map.output.key.fields=2 \
    -D mapred.text.key.partitioner.options=-k1,1 \
    -D mapred.reduce.tasks=3 \
    -file ./mapperTask1.py \
    -mapper "python3 ./mapperTask1.py" \
    -file ./reducerTask1.py \
    -reducer "python3 ./reducerTask1.py" \
    -input $INPUT_PATH \
    -output $OUTPUT_PATH \
    -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner 