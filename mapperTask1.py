#!/usr/bin/env python3
import sys

# Dictionary to hold combined statistics for each taxi and trip type.
tripData = {}

def emitTripStats(taxiID, tripType, count, maxFare, minFare, sumFare):
    """
    Function to output the combined statistics for each taxi and trip type.
    Arguments:
    taxiID : String - Identifier for the taxi.
    tripType : String - Categorized type of trip ('long', 'medium', 'short').
    count : Integer - Total number of trips.
    maxFare : Float - Maximum fare recorded for the trip type.
    minFare : Float - Minimum fare recorded for the trip type.
    sumFare : Float - Sum of all fares for the trip type.
    """
    print(f"{taxiID}\t{tripType}\t{count}\t{maxFare}\t{minFare}\t{sumFare}") # Emit key-value pair format suitable for Hadoop processing.

# Main loop to process each line of input from standard input.
for line in sys.stdin:
    # Parse the line to extract trip data, assuming CSV format.
    tripID, taxiID, fare, dist, _, _, _, _ = line.strip().split(',')  # Ignore irrelevant fields by assigning them to _
    
    # Convert fare and distance from string to float for numerical operations.
    fare = float(fare)
    dist = float(dist)
    
    # Determine the trip type based on distance.
    if dist >= 200:
        tripType = 'long'
    elif dist >= 100:
        tripType = 'medium'
    else:
        tripType = 'short'
    
    # Create a composite key based on taxi ID and trip type.
    key = (taxiID, tripType)
    
    # If the key is not in the dictionary, initialize the statistics.
    if key not in tripData:
        try:
            tripData[key] = {
                'count': 0,
                'maxFare': float('-inf'),
                'minFare': float('inf'),
                'sumFare': 0
            }
        except ValueError:
            continue  # Skip line if there is any error in initialization.
    
    # Update the statistics for this taxi and trip type.
    tripData[key]['count'] += 1
    tripData[key]['maxFare'] = max(tripData[key]['maxFare'], fare)
    tripData[key]['minFare'] = min(tripData[key]['minFare'], fare)
    tripData[key]['sumFare'] += fare

# Emit the statistics for each taxi and trip type after processing all lines.
for (taxiID, tripType), stats in tripData.items():
    emitTripStats(taxiID, tripType, stats['count'], stats['maxFare'], stats['minFare'], stats['sumFare'])
