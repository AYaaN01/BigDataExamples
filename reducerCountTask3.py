#!/usr/bin/env python3
import sys

companyTrips = {}  # Dictionary to hold trip counts per company

for line in sys.stdin:
    company, trips = line.strip().split('\t')
    if company in companyTrips:
        companyTrips[company] += int(trips)
    else:
        companyTrips[company] = int(trips)

for company, totalTrips in companyTrips.items():
    print(f"{company}\t{totalTrips}")