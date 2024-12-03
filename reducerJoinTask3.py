#!/usr/bin/env python3
import sys

currTaxi = None
currCompanyID = None
tripCount = 0

for line in sys.stdin:
    line = line.strip()
    taxi, value = line.split('\t')
    
    # Check if this is a new taxi
    if taxi != currTaxi:
        if currTaxi is not None and currCompanyID is not None:
            # Output the result for the previous taxi
            print(f"{currCompanyID}\t{tripCount}")
        
        # Reset for the new taxi
        currTaxi = taxi
        tripCount = 0  # Reset trip count
        currCompanyID = None
        
    # Process the value based on its prefix
    if value.startswith('C-'):
        currCompanyID = value[2:]  # Extract company ID without prefix
    elif value.startswith('T-'):
        tripCount += int(value[2:])  # Sum the trip count, convert '1' to integer

# Don't forget to output the last taxi's count
if currTaxi is not None and currCompanyID is not None:
    print(f"{currCompanyID}\t{tripCount}")