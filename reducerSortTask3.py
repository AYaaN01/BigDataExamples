#!/usr/bin/env python3
import sys

for line in sys.stdin:
    trips, company = line.strip().split('\t')
    print(f"{company}\t{trips}") # print output