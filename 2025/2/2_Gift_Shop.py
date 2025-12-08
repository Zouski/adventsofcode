"""
Advent of Code 2025 - Day 2
Gift Shop
"""

import time
from pathlib import Path
import re

def next_ten(n):
    return str(10 ** len(n))

def read_input(filename="input.txt"):
    """Read and parse the input file."""
    script_dir = Path(__file__).parent
    filepath = script_dir / filename
    with open(filepath, 'r') as f:
        return f.read().strip()

def part1(data):
    """Solve part 1."""
    pairs = data.split(',')
    ranges = [tuple(pair.split('-')) for pair in pairs]
    #print(ranges)

    sum = 0
    for range in ranges:
        #print(range)
        first, last = int(range[0]), int(range[1])
        
        full = range[0]
        range_sum = 0
        while int(full) <= last:
            #print(full)
            if len(full) % 2: #odd because 1
                full = next_ten(full)
                continue
            
            half_len = len(full) // 2
            potential = full[:half_len]
            if int(potential * 2) < first:
                potential = str(int(potential) + 1)

            full = potential * 2
            
            if int(full) > last:
                break

            range_sum += int(full)
            full = str(int(potential) + 1) * 2
        #print(f"Range {range}: sum {range_sum}")
        sum += range_sum

    return sum


def part2(data):
    """Solve part 2."""
    pairs = data.split(',')
    ranges = [tuple(pair.split('-')) for pair in pairs]
    #print(ranges)
    sum = 0
    for range in ranges:
        first, last = range
        while first != last:
            if bool(re.fullmatch(r'^(\d+)\1+$', first)):
                sum += int(first)
            first = str(int(first) + 1)
        
        if bool(re.fullmatch(r'^(\d+)\1+$', first)):
            sum += int(first)

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
