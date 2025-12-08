"""
Advent of Code 2019 - Day 3
Crossed Wires
"""

import time
from pathlib import Path
from collections import defaultdict


def read_input(filename="input.txt"):
    """Read and parse the input file."""
    script_dir = Path(__file__).parent
    filepath = script_dir / filename
    with open(filepath, 'r') as f:
        return f.read().strip()

def fill_grid(grid, coord, op, num):
    count = int(op[1:])
    dir = op[0]

    for _ in range(count):
        x, y = coord
        match dir:
            case 'U':
                y += 1
            case 'R':
                x += 1
            case 'D':
                y -= 1
            case 'L':
                x -= 1
        coord = (x, y)
        if grid[coord] != num:
            grid[coord] += num
    return coord


def part1(data):
    """Solve part 1."""
    lines = data.split('\n')
    grid = defaultdict(int)

    for i, line in enumerate(lines):
        coord = (0,0)
        for op in line.split(','):
            coord = fill_grid(grid, coord, op, i + 1)

    threes = {coord: val for coord, val in grid.items() if val > 2}

    closest = min(abs(coord[0]) + abs(coord[1]) for coord, _ in threes.items())
    return closest



def part2(data):
    """Solve part 2."""
    lines = data.split('\n')
    
    # TODO: Implement solution
    result = 0
    
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
