"""
Advent of Code 2025 - Day 6
Trash Compactor
"""

import time
from pathlib import Path
import numpy as np

def read_input(filename="input.txt"):
    """Read and parse the input file."""
    script_dir = Path(__file__).parent
    filepath = script_dir / filename
    with open(filepath, 'r') as f:
        return f.read().rstrip('\n')

def part1(data):
    """Solve part 1."""
    lines = [line.split() for line in data.split('\n')]
    numlines = [list(map(int, line)) for line in lines[:-1]]
    ops = lines[-1] #ops = * or +

    total = 0
    for i, op in enumerate(ops):
        if op == '*':
            itotal = 1
            for n in range(len(numlines)):
                itotal *= numlines[n][i]
        elif op == '+':
            itotal = 0
            for n in range(len(numlines)):
                itotal += numlines[n][i]
        total += itotal

    return total

def build(arr):
    num = 0
    for char in arr:
        if char == ' ':
            continue
        num = num * 10 + int(char)
    return num

def prod(arr):
    result = 1
    for num in arr:
        result *= num
    return result

def part2(data):
    lines = data.split('\n')
    ops = lines[-1].split()[::-1]
    numsquare = [list(line) for line in lines[:-1]]
    rotated = np.rot90(numsquare)
    nums = [build(num) for num in rotated]

    numgroups = []
    numgroup = []
    for num in nums:
        if num == 0:
            if numgroup:
                numgroups.append(numgroup)
                numgroup = []
        else:
            numgroup.append(num)
    numgroups.append(numgroup)

    total = 0
    # print(ops)
    # print(numgroups)
    for op, numgroup in zip(ops, numgroups):
        itotal = 0
        if op == '*':
            itotal = prod(numgroup)
        elif op == '+':
            itotal = sum(numgroup)
        # print(op, numgroup, itotal)
        total += itotal
    
    return total

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
