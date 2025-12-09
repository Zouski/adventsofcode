"""
Advent of Code 2025 - Day 9
Movie Theater
"""

import time
from pathlib import Path
from itertools import combinations
import cProfile
import pstats
from io import StringIO
import bisect

def read_input(filename="input.txt"):
    """Read and parse the input file."""
    script_dir = Path(__file__).parent
    filepath = script_dir / filename
    with open(filepath, 'r') as f:
        return f.read().strip()

def part1(data):
    """Solve part 1."""
    lines = data.split('\n')
    coords = [tuple(map(int, line.split(','))) for line in lines]
    
    largest = 0
    for a, b in combinations(coords, 2):
        ax, ay = a
        bx, by = b
        area = (abs(ax - bx) + 1) * (abs(ay - by) + 1)
        largest = max(largest, area)
    
    return largest, coords

def is_valid_rectangle(rect, hedges, vedges, hedge_py_values, vedge_px_values, longest_hedge, longest_vedge):
    """Check if rectangle is valid (no edges cross through it).
    
    Uses binary search to only check relevant edges based on their singular coordinate.
    hedge_py_values and vedge_px_values are sorted lists for binary search.
    Checks longest edges first for early exit.
    """
    x1, y1, x2, y2 = rect

    # Check longest horizontal edge first
    px1, px2, py = longest_hedge
    if y1 < py < y2 and px1 < x2 <= px2:
        return False
    if y1 < py < y2 and px1 <= x1 < px2:
        return False
    
    # Check longest vertical edge first
    py1, py2, px = longest_vedge
    if x1 < px < x2 and py1 < y2 <= py2:
        return False
    if x1 < px < x2 and py1 <= y1 < py2:
        return False

    # For horizontal edges, find those with py in range (y1, y2)
    # Binary search for first edge with py > y1, check while py < y2
    hedge_start = bisect.bisect_right(hedge_py_values, y1)
    hedge_end = bisect.bisect_left(hedge_py_values, y2)

    for i in range(hedge_start, hedge_end):
        px1, px2, py = hedges[i]
        if px1 < x2 <= px2 or px1 <= x1 < px2:
            return False
        
    # For vertical edges, find those with px in range (x1, x2)
    # Binary search for first edge with px > x1, check while px < x2
    vedge_start = bisect.bisect_right(vedge_px_values, x1)
    vedge_end = bisect.bisect_left(vedge_px_values, x2)
        
    for i in range(vedge_start, vedge_end):
        py1, py2, px = vedges[i]
        if py1 < y2 <= py2 or py1 <= y1 < py2:
            return False
    
    return True

def part2(coords):
    """Solve part 2 by checking for the largest rectangle inside the shape."""
    
    # Build edges from consecutive coordinates, normalized by min/max
    hedges = []
    vedges = []
    for i, (x1, y1) in enumerate(coords):
        x2, y2 = coords[(i + 1) % len(coords)]
        if x1 == x2:
            # Vertical edge: store as (min_y, max_y, x)
            vedges.append((min(y1, y2), max(y1, y2), x1))
        else:
            # Horizontal edge: store as (min_x, max_x, y)
            hedges.append((min(x1, x2), max(x1, x2), y1))
    
    # Find longest edges to check first
    longest_hedge_idx = max(range(len(hedges)), key=lambda i: hedges[i][1] - hedges[i][0])
    longest_vedge_idx = max(range(len(vedges)), key=lambda i: vedges[i][1] - vedges[i][0])
    
    longest_hedge = hedges[longest_hedge_idx]
    longest_vedge = vedges[longest_vedge_idx]
    
    # Sort edges by their singular coordinate for binary search
    # hedges sorted by y value (third element)
    hedges_sorted = sorted(enumerate(hedges), key=lambda item: item[1][2])
    hedges = [h for _, h in hedges_sorted]
    hedge_py_values = [h[2] for h in hedges]
    
    # vedges sorted by x value (third element)
    vedges_sorted = sorted(enumerate(vedges), key=lambda item: item[1][2])
    vedges = [v for _, v in vedges_sorted]
    vedge_px_values = [v[2] for v in vedges]
    
    largest = 0
    best_coords = None
    for a, b in combinations(coords, 2):
        x1, y1 = a
        x2, y2 = b

        # Check area first (cheap) before expensive intersection checks
        area = (abs(x2 - x1) + 1) * (abs(y2 - y1) + 1)
        if area <= largest:
            continue
        
        # Build normalized rectangle
        rect = (min(x1, x2), min(y1, y2), max(x1, x2), max(y1, y2))
        
        if is_valid_rectangle(rect, hedges, vedges, hedge_py_values, vedge_px_values, longest_hedge, longest_vedge):
            largest = area
            best_coords = (a, b)
    
    return largest, best_coords

if __name__ == "__main__":
    # Read input
    data = read_input()

    # Solve part 1
    t1s = time.perf_counter()
    answer1, coords = part1(data)
    t1e = time.perf_counter()
    print(f"Part 1: {answer1} (time: {(t1e - t1s) * 1000:.3f} ms)")

    # Solve part 2
    t1s = time.perf_counter()
    answer2, best_coords = part2(coords)
    t1e = time.perf_counter()
    print(f"Part 2: {answer2} (time: {(t1e - t1s) * 1000:.3f} ms)")
    # if best_coords:
    #     print(f"  Best rectangle coords: {best_coords[0]} to {best_coords[1]}")
    