#!/usr/bin/env python3
import sys

for line in sys.stdin:
    line = line.strip()
    parts = line.split(',')
    
    if len(parts) == 4:  # Data from Taxis.txt: Taxi#, company, model, year
        taxiID = parts[0]
        companyID = parts[1]
        print(f"{taxiID}\tC-{companyID}")  # Emit Taxi# and prefixed company ID
    elif len(parts) == 8:  # Data from Trips.txt: Trip#, Taxi#, fare, distance, pickup_x, pickup_y, dropoff_x, dropoff_y
        taxiID = parts[1]
        print(f"{taxiID}\tT-1")  # Emit Taxi# and prefixed trip count