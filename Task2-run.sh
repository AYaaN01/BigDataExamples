#!/bin/bash

# Define file paths
INPUT_PATH=/Input/Trips.txt
OUTPUT_PATH=/Output/Task2
INIT_FILE="initialization.txt"
MEDOIDS_FILE="medoids.txt"
NEW_MEDOIDS_FILE="new_medoids.txt"
MAPPER_PY="mapperTask2.py"
REDUCER_PY="reducerTask2.py"
CONVERGENCE_PY="checkConvergTask2.py"

# Read the number of iterations from the first line of the initialization file
max_iterations=$(head -n1 $INIT_FILE)

# Initialize the current iteration
current_iteration=1

# Extract initial medoids (skip the first line which contains the number of iterations)
tail -n +2 $INIT_FILE > $MEDOIDS_FILE

# Main loop for K-Medoids clustering
while [ $current_iteration -le $max_iterations ]
do
    echo "Iteration $current_iteration of $max_iterations"

    # Run Hadoop MapReduce job
    hadoop jar ./hadoop-streaming-3.1.4.jar \
        -D stream.num.map.output.key.fields=1 \
        -D mapred.text.key.partitioner.options=-k1,1 \
        -D mapred.reduce.tasks=3 \
        -files $MEDOIDS_FILE,$MAPPER_PY,$REDUCER_PY \
        -input $INPUT_PATH \
        -output $OUTPUT_PATH \
        -mapper "python3 ./$MAPPER_PY $MEDOIDS_FILE" \
        -reducer "python3 ./$REDUCER_PY" \
        -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner 

    # Copy the output medoids from HDFS to the local filesystem
    hadoop fs -getmerge $OUTPUT_PATH/part-* $NEW_MEDOIDS_FILE

    # Check for convergence using the Python script
    if [ $current_iteration -gt 1 ]; then
        converged=$(python $CONVERGENCE_PY $MEDOIDS_FILE $NEW_MEDOIDS_FILE)
        if [ "$converged" -eq 1 ]; then
            echo "Convergence reached."
            break
        fi
    fi

    # Prepare medoids for the next iteration
    mv $NEW_MEDOIDS_FILE $MEDOIDS_FILE

    # Increment the iteration counter
    current_iteration=$((current_iteration + 1))

    # Remove existing output directory if not the last iteration
    if [ $current_iteration -le $max_iterations ]; then
        hadoop fs -rm -r -f $OUTPUT_PATH
    fi
done

# Clean up
rm $NEW_MEDOIDS_FILE
rm $MEDOIDS_FILE

echo "K-Medoids clustering completed."
