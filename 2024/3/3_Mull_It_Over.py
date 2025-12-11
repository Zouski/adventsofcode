"""
Advent of Code 2024 - Day 3
Mull It Over
"""

import time
import re
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
    
    result = 0
    for line in lines:
        matches = re.findall(r"mul\(\d{1,3},\d{1,3}\)", line)
        for match in matches:
            numbers = re.search(r"\d{1,3},\d{1,3}", match).group()
            a, b = map(int, numbers.split(','))
            result += a * b

    return result

def part2(data):
    """Solve part 2."""
    lines = data.split('\n')
    
    result = 0
    do = True
    for line in lines:
        matches = re.findall(r"mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)", line)
        for match in matches:
            if match.startswith('mul'):
                numbers = re.search(r"\d{1,3},\d{1,3}", match).group()
                a, b = map(int, numbers.split(','))
                if do:
                    result += a * b
            elif match == "do()":
                do = True
            elif match == "don't()":
                do = False

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
