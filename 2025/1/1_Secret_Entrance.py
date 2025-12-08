"""
Advent of Code 2025 - Day 1
Secret Entrance
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

    state = 50
    zeros = 0
    for line in lines:
        num = int(line[1:])
        
        
        if line[0] == 'R':
            state += num
        elif line[0] == 'L':
            state -= num

        #print(num, state % 100)
        if state % 100 == 0:
            zeros += 1

    result = zeros
    
    return result

def part2(data):
    """Solve part 2."""
    lines = data.split('\n')
    
    state = 50
    zeros = 0
    for line in lines:
        num = int(line[1:])
        zeros += num // 100
        num %= 100
        #print(state % 100, line)
        if line[0] == 'R': 
            if state % 100 + num > 100 and state % 100 != 0:
                zeros += 1
            state += num
        elif line[0] == 'L':
            if state % 100 - num < 0 and state % 100 != 0:
                zeros += 1
            state -= num
        if state % 100 == 0:
            zeros += 1


    result = zeros
    
    return result

if __name__ == "__main__":
    # Read input
    data = read_input()
    
    # Solve part 1
    t1_start = time.perf_counter()
    answer1 = part1(data)
    t1_end = time.perf_counter()
    print(f"Part 1: {answer1} (time: {(t1_end - t1_start) * 1000:.3f} ms)")
    
    # Solve part 2
    t2_start = time.perf_counter()
    answer2 = part2(data)
    t2_end = time.perf_counter()
    print(f"Part 2: {answer2} (time: {(t2_end - t2_start) * 1000:.3f} ms)")
