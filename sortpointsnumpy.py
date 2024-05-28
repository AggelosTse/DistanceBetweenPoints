import sys
import time
from math import sqrt

import numpy as np


def read_file(file_name):
    """opens the file and adds point's values from the file in a tuple"""
    try:
        with open(file_name, "r") as file:
            filecontent = []
            for line in file:
                # Assuming each line contains three values separated by whitespace
                values = line.strip().split()
                if len(values) == 3:
                    filecontent.append(
                        (float(values[0]), float(values[1]), float(values[2]))
                    )
                else:
                    print(f"Ignoring malformed line: {line}")
        points_array = np.array(filecontent)
        return points_array

    except FileNotFoundError:
        print("File not found.")


def calculatedistances(points):
    """for every point in the tuple,
    it calculates the distance from (0,0,0) and adds it in a list"""
    distancesList = []
    for point in points:
        distance = sqrt((0 - point[0]) ** 2 + (0 - point[1]) ** 2 + (0 - point[2]) ** 2)
        distancesList.append(distance)
        distance_array = np.array(distancesList)
    return distance_array


def quicksort(dist, points, low, high):
    """Sorts the distances list first (using quicksort),
    and sorts the points list after depending on the distances list."""
    if low < high:
        pivot = partition(dist, points, low, high)
        quicksort(dist, points, low, pivot)
        quicksort(dist, points, pivot + 1, high)


def partition(dist, points, low, high):
    """Sorts the lists"""
    pivot = dist[(low + high) // 2]
    i = low - 1
    j = high + 1
    while True:
        i += 1
        while dist[i] < pivot:
            i += 1
        j -= 1
        while dist[j] > pivot:
            j -= 1
        if i >= j:
            return j
        # Swap elements at i and j
        dist[i], dist[j] = dist[j], dist[i]
        points[i], points[j] = points[j], points[i]


def pointslistsort(points, distances):
    """Calls the quicksort function with the first and the last index of a list"""
    quicksort(distances, points, 0, len(distances) - 1)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <file_name>")
    else:
        start_time = time.time()

        file_name = sys.argv[1]
        points = read_file(
            file_name
        )  # creates a tuple with every point there is in the file
        distances = calculatedistances(
            points
        )  # list that has all the distances between every point in points list and point (0,0,0)
        pointslistsort(points, distances)
        print("Sorted Points:", points)
        end_time = time.time()
        print(f"Compilation Time: {end_time - start_time}")
