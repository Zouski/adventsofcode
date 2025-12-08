"""
Advent of Code 2025 - Day 3
Lobby
"""

import time
from pathlib import Path

def read_input(filename="input.txt"):
    """Read and parse the input file."""
    script_dir = Path(__file__).parent
    filepath = script_dir / filename
    with open(filepath, 'r') as f:
        return f.read().strip()

def part1(data):
    """Solve part 1."""
    lines = data.split('\n')
    sum = 0
    for batt in lines:
        left = max(batt[0:-1])
        right = max(batt[batt.find(left)+1:])
        isum = int(left) * 10 + int(right)
        #print(batt, isum)
        sum += isum

    return sum

def part2(data):
    batteries = data.split('\n')
    sum = 0
    DIGITS = 12
    for batt in batteries:
        jolt = ""
        newbatt = batt
        for i in range(DIGITS):
            inverse = DIGITS - 1 - i
            possible = newbatt[0:-inverse] if inverse > 0 else newbatt
            left = max(possible)
            newbatt = newbatt[newbatt.find(left)+1:]
            jolt += left
        sum += int(jolt)
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
