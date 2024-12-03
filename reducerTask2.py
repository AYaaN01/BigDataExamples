#!/usr/bin/env python

import sys
from math import sqrt

def euclidean(p1, p2):
    """
    Calculate the Euclidean distance between two points.
    Arguments:
    p1, p2: tuples - Coordinates of the two points (x, y).
    Returns:
    float - The Euclidean distance between the two points.
    """
    return sqrt((p1[0] - p2[0])**2 + (p1[1] - p2[1])**2)

def findNewMedoid(points):
    """
    Determine the point that minimizes the total distance to all other points in the set.
    Arguments:
    points: list of tuples - List of points within the cluster.
    Returns:
    tuple - The coordinates of the new medoid.
    """
    minCost = float('inf')
    bestMedoid = None
    for i in range(len(points)):
        candidateMedoid = points[i]
        totalCost = sum(euclidean(candidateMedoid, point) for point in points)
        if totalCost < minCost:
            minCost = totalCost
            bestMedoid = candidateMedoid
    return bestMedoid

def processCluster(points):
    """
    Process each cluster by finding the optimal medoid and printing its coordinates.
    Arguments:
    points: list of tuples - Coordinates of all points in the current cluster.
    """
    newMedoid = findNewMedoid(points)
    if newMedoid:
        print(f"{newMedoid[0]}\t{newMedoid[1]}")

if __name__ == "__main__":
    currMedoidIndex = None
    points = []

    # Process each line of input, which represents a point in a cluster.
    for line in sys.stdin:
        line = line.strip()
        medoidIndex, coords = line.split('\t')
        x, y = map(float, coords.split(','))

        # If the current line belongs to the same cluster as previous lines,
        # add it to the list of points for that cluster.
        if currMedoidIndex == medoidIndex:
            points.append((x, y))
        else:
            # If the cluster changes, process the accumulated points to find the new medoid,
            # then start a new list for the new cluster.
            if points:
                processCluster(points)
            currMedoidIndex = medoidIndex
            points = [(x, y)]

    # Process the final set of points if any remain.
    if points:
        processCluster(points)
