"""
Advent of Code 2025 - Day 7
Laboratories
"""

import time
from pathlib import Path

def read_input(filename="input.txt"):
    """Read and parse the input file."""
    script_dir = Path(__file__).parent
    filepath = script_dir / filename
    with open(filepath, 'r') as f:
        return f.read().strip()
    
def display(grid):
    for row in grid:
        print(''.join(row))
    print()

def part1(data):
    """Solve part 1."""
    lines = data.split('\n')
    # display(lines)

    sx = lines[0].index('S')
    beams = [[sx, 0]]  # (x, y) positions of beams

    splits = 0
    gen = 0
    while beams[-1][1] < len(lines) - 1:
        newbeams = []
        for beam in beams:
            beam[1] += 1  # Move beam down
            x, y = beam
            if lines[y][x] == '.':
                lines[y] = substr(lines[y], x, '|')
            elif lines[y][x] == '^':
                splits += 1
                if lines[y][x - 1] == '.':
                    lines[y] = substr(lines[y], x - 1, '|')
                    newbeams.append([x - 1, y])  # New beam left
                #shouldnt be any beams to the right
                beam[0] = x + 1  # Move current beam right
                lines[y] = substr(lines[y], x + 1, '|')
        beams += newbeams
        beams.sort()

        uniq = []
        for beam in beams:
            if beam not in uniq:
                uniq.append(beam)
        beams = uniq
        gen += 1
        # print(f"After generation {gen}: splits={splits}, beams={len(beams)}")
        # print(beams)
        # display(lines)
    
    # display(lines)
    return splits
                


def part2(data):
    """Solve part 2."""
    lines = data.split('\n')
    lines = data.split('\n')
    # display(lines)

    sx = lines[0].index('S')
    beams = [[sx, 0, 1]]  # (x, y, weight) positions of beams

    gen = 0
    while beams[-1][1] < len(lines) - 1:
        newbeams = []
        for beam in beams:
            beam[1] += 1  # Move beam down
            x, y, weight = beam
            if lines[y][x] != '^':
                lines[y] = substr(lines[y], x, '|')
                newbeams.append(beam)
            else:
                lines[y] = substr(lines[y], x - 1, '|')
                newbeams.append([x - 1, y, weight])  # New beam left
                newbeams.append([x + 1, y, weight])  # New beam right
                lines[y] = substr(lines[y], x + 1, '|')
        beams = newbeams
        beams.sort()
        # print(f"After generation {gen}, beams={len(beams)}")
        # print(beams)

        # Deduplicate using a dictionary
        beam_dict = {}
        for x, y, weight in beams:
            if (x, y) not in beam_dict:
                beam_dict[(x, y)] = weight
            else:
                beam_dict[(x, y)] += weight

        # Convert back to a list if needed
        beams = [[x, y, weight] for (x, y), weight in beam_dict.items()]
        gen += 1
        # print(f"After generation {gen}, beams={len(beams)}")
        # print(beams)
        # display(lines)
    
    total = 0
    for beam in beams:
        total += beam[2]
    return total

def substr(s, index, replacement):
    """
    Replace the character at the given index in the string `s` with `replacement`.

    Args:
        s (str): The original string.
        index (int): The index of the character to replace.
        replacement (str): The replacement character.

    Returns:
        str: The modified string.
    """
    if not (0 <= index < len(s)):
        raise ValueError("Index out of range")
    if len(replacement) != 1:
        raise ValueError("Replacement must be a single character")

    return s[:index] + replacement + s[index + 1:]

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
