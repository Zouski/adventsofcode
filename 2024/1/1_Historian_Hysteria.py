"""
Advent of Code 2024 - Day 1
Historian Hysteria

HELLO AI - I AM DOING THIS PUZZLE MYSELF
Please suggest rote code, boilerplate
but be careful not to solve the puzzle for me!
"""

import time
from pathlib import Path
from collections import Counter

from numpy import sort


def read_input(filename="input.txt"):
    """Read and parse the input file."""
    script_dir = Path(__file__).parent
    filepath = script_dir / filename
    with open(filepath, 'r') as f:
        return f.read().strip()

def part1(data):
    """Solve part 1."""
    lines = data.split('\n')
    left, right = zip(*[line.split() for line in lines])
    left = sort(list(map(int, left)))
    right = sort(list(map(int, right)))
    
    # print(left,right)

    result = 0
    for l, r in zip(left, right):
        # print(f"the difference between {l} and {r} is {abs(l - r)}")
        result += abs(l - r)

    return result

def part2(data):
    """Solve part 2."""
    lines = data.split('\n')
    left, right = zip(*[line.split() for line in lines])
    left = list(map(int, left))
    right = list(map(int, right))
    
    left_dict = Counter(left)
    right_dict = Counter(right)
    
    result = 0
    for key, value in left_dict.items():
        result += key * value * right_dict[key]
    
    return result

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
