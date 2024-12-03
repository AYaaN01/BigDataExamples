#!/usr/bin/env python3
import sys

# Initialize the variables for holding the current key and trip statistics.
currKey = None
tripTypeStats = {
    'count': 0,
    'maxFare': float('-inf'),  # Use -infinity as the initial max fare for comparison.
    'minFare': float('inf'),   # Use infinity as the initial min fare for comparison.
    'sumFare': 0
}

def emitandcount(key, stats):
    """
    Emit the results if there are any trips counted.
    Arguments:
    key : str - Composite key of taxiID and tripType.
    stats : dict - values containing count, maxFare, minFare, and sumFare.
    """
    if stats['count'] > 0:
        avgFare = stats['sumFare'] / stats['count']  # Calculate average fare.
        print(f"{key}\t{stats['count']}\t{stats['maxFare']:.2f}\t{stats['minFare']:.2f}\t{avgFare:.2f}")

# Process each line of input from standard input.
for line in sys.stdin:
    # Split the line into components.
    taxiID, tripType, count, maxFare, minFare, sumFare = line.strip().split('\t')
    
    # Convert count, maxFare, minFare, and sumFare to appropriate types.
    count = int(count)
    maxFare = float(maxFare)
    minFare = float(minFare)
    sumFare = float(sumFare)
    
    # Create a composite key from taxiID and tripType.
    key = f"{taxiID}\t{tripType}"
    
    # Check if the current line's key matches the current key being processed.
    if key == currKey:
        # If it matches, update the trip statistics with data from this line.
        tripTypeStats['count'] += count
        tripTypeStats['maxFare'] = max(tripTypeStats['maxFare'], maxFare)
        tripTypeStats['minFare'] = min(tripTypeStats['minFare'], minFare)
        tripTypeStats['sumFare'] += sumFare
    else:
        # If it does not match, emit results for the previous key and start new statistics.
        if currKey:
            emitandcount(currKey, tripTypeStats)
        currKey = key
        tripTypeStats = {
            'count': count,
            'maxFare': maxFare,
            'minFare': minFare,
            'sumFare': sumFare
        }

# After the loop, emit results for the last processed key.
if currKey:
    emitandcount(currKey, tripTypeStats)
