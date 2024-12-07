#!/usr/bin/env python
import sys

def read_medoids(filename):
    """Read medoids from a file and return them as a list of tuples."""
    medoids = []
    with open(filename, 'r') as file:
        # Directly read all lines assuming they are all valid medoid coordinates
        for line in file:
            line = line.strip()
            if line:
                coords = line.split()
                medoids.append((float(coords[0]), float(coords[1])))
    return medoids

def has_converged(old_medoids, new_medoids):
    """Check if two sets of medoids are the same, indicating convergence."""
    return set(old_medoids) == set(new_medoids)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: checkConvergTask2.py <old_medoids_file> <new_medoids_file>")
        sys.exit(1)

    old_medoids = read_medoids(sys.argv[1])
    new_medoids = read_medoids(sys.argv[2])
    
    if has_converged(old_medoids, new_medoids):
        print(1)  # Converged
    else:
        print(0)  # Not converged
