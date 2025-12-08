"""
Advent of Code 2025 - Day 8
Playground
"""

import time
from pathlib import Path
from itertools import combinations
from collections import Counter

debug = False

parent = sizes = distances = points = []

def read_input(filename="inputE.txt"):
    """Read and parse the input file."""
    script_dir = Path(__file__).parent
    filepath = script_dir / filename
    with open(filepath, 'r') as f:
        return f.read().strip()
    
def sqdist(a, b):
    """Calculate squared distance between two points a and b in 3D space."""
    return sum((x - y) ** 2 for x, y in zip(a, b))

def print_set_size_occurrences(sets):
    """
    Takes a list of sets and prints the occurrence of each size of set,
    starting with the largest size.
    """
    # Count the sizes of the sets
    sizes = [len(s) for s in sets]

    # Count occurrences of each size
    size_counts = Counter(sizes)

    # Sort by size in descending order
    sorted_size_counts = sorted(size_counts.items(), key=lambda x: x[0], reverse=True)

    # Print the results in a dense format
    print(", ".join(f"{size}:{count}" for size, count in sorted_size_counts))

def find(p):
    """Find the root of the set containing point p."""
    while p != parent[p]:
        p = parent[p]
    return p

def union(a, b):
    """Union the sets containing points a and b."""
    a, b = find(a), find(b)
    if a == b:
        return 0
    parent[b] = a
    size[a] += size[b]
    return size[a]



def part1(data):
    """Solve part 1."""
    global parent, size, distances, points
    
    lines = data.split('\n')

    points = []
    for i, line in enumerate(lines):
        point = tuple(map(int, line.split(','))) + (i,)
        points.append(point)

    distances = [(sqdist(p1[:3], p2[:3]), p1[3], p2[3]) for p1, p2 in combinations(points, 2)]
    distances.sort()

    iterations = 10 if debug else 1000
    parent = list(range(len(points)))
    size = [1] * len(points)

    for _, a, b in distances[:iterations]:
        union(a, b)

    sizes = [size[i] for i in range(len(points)) if i == parent[i]]
    sizes.sort()
    return sizes[-1] * sizes[-2] * sizes[-3]

def part2(data):
    """Solve part 2."""
    global parent, size, distances, points

    lines = data.split('\n')
    
    a = b = 0
    for _, a, b in distances:
        if union(a, b) == len(parent):
            break

    return points[a][0] * points[b][0]


if __name__ == "__main__":
    # Read input
    filename = "inputE.txt" if debug else "input.txt"
    data = read_input(filename)
    
    # Solve part 1
    t1s = time.perf_counter()
    answer1 = part1(data)
    t1e = time.perf_counter()
    print(f"Part 1: {answer1} (time: {(t1e - t1s) * 1000:.3f} ms)")
    
    # Solve part 2
    t2s = time.perf_counter()
    answer2 = part2(data)
    t2e = time.perf_counter()
    print(f"Part 2: {answer2} (time: {(t2e - t2s) * 1000:.3f} ms)")
