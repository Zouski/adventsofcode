"""
Advent of Code 2025 - Day 5
Cafeteria
"""

import time
from pathlib import Path
import bisect

def read_input(filename="input.txt"):
    """Read and parse the input file."""
    script_dir = Path(__file__).parent
    filepath = script_dir / filename
    with open(filepath, 'r') as f:
        return f.read().strip()

def part1(data):
    """Solve part 1."""
    lines = data.split('\n\n')
    range_lines = lines[0].split('\n')
    value_lines = lines[1].split('\n')
    
    # Parse ranges
    ranges = []
    for line in range_lines:
        start, end = map(int, line.split('-'))
        ranges.append((start, end))
    
    # Sort and merge overlapping ranges
    ranges.sort()
    merged = []
    for start, end in ranges:
        if merged and start <= merged[-1][1] + 1:
            # Overlaps or adjacent, merge
            merged[-1] = (merged[-1][0], max(merged[-1][1], end))
        else:
            # No overlap, add new range
            merged.append((start, end))
    
    # Check each value
    count = 0
    starts = [r[0] for r in merged]
    for val in map(int, value_lines):
        idx = bisect.bisect_right(starts, val) - 1
        if idx >= 0 and val <= merged[idx][1]:
            count += 1
    
    return count

def part2(data):
    """Solve part 2."""
    lines = data.split('\n\n')
    range_lines = lines[0].split('\n')
    value_lines = lines[1].split('\n')
    
    # Parse ranges
    ranges = []
    for line in range_lines:
        start, end = map(int, line.split('-'))
        ranges.append((start, end))
    
    # Sort and merge overlapping ranges
    ranges.sort()
    merged = []
    for start, end in ranges:
        if merged and start <= merged[-1][1] + 1:
            # Overlaps or adjacent, merge
            merged[-1] = (merged[-1][0], max(merged[-1][1], end))
        else:
            # No overlap, add new range
            merged.append((start, end))

    sum = 0
    for start, end in merged:
        sum += end - start + 1

    return sum

if __name__ == "__main__":
    # Read input
    data = read_input()
    
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
