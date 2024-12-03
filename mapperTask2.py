#!/usr/bin/env python

import sys
from math import sqrt

def euclidean(p1, p2): # calculate euclidean distance
    """
    Compute the Euclidean distance between two points.
    p1, p2: tuples - Represent coordinates (x, y) of two points.
    Returns: float - The Euclidean distance between the points.
    """
    return sqrt((p1[0] - p2[0])**2 + (p1[1] - p2[1])**2)

def getMedoids(filepath):
    """
    Read medoids coordinates from a given file.
    filepath: str - The path to the file containing medoids.
    Returns: list of tuples - Each tuple represents coordinates of a medoid.
    """
    medoids = []
    with open(filepath, 'r') as file:
        for line in file:
            line = line.strip()
            if line:
                coords = line.split()
                medoids.append((float(coords[0]), float(coords[1])))
    return medoids

def createClusters(medoids):
    """
    Assign each input data point to the nearest medoid based on Euclidean distance.
    medoids: list of tuples - Contains the coordinates of all medoids.
    """
    for line in sys.stdin:
        line = line.strip()
        parts = line.split(',')
        try:
            # Extracting the dropoff_x and dropoff_y coordinates
            dropoff_x = float(parts[6])
            dropoff_y = float(parts[7])
        except ValueError:
            continue  # Ignore lines that cannot be parsed

        min_dist = float('inf')
        index = -1

        # Find the nearest medoid
        for i, medoid in enumerate(medoids):
            dist = euclidean((dropoff_x, dropoff_y), medoid)
            if dist < min_dist:
                min_dist = dist
                index = i

        if index != -1:  # Check if a closest medoid was found
            # Output the index of the medoid and the coordinates
            print(f"{index}\t{dropoff_x},{dropoff_y}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise RuntimeError("Please provide the path to the initialization file")
    medoids = getMedoids(sys.argv[1])
    createClusters(medoids)
