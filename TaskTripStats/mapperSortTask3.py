#!/usr/bin/env python3
import sys

for line in sys.stdin:
    company, trips = line.strip().split('\t')
    print(f"{int(trips)}\t{company}") #emit <key,value> pair key = tripcount for each company, value = company 