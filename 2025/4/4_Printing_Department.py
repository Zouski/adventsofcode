"""
Advent of Code 2025 - Day 4
Printing Department
"""

import time
from pathlib import Path
import numpy as np
from scipy.ndimage import convolve

def read_input(filename="input.txt"):
    """Read and parse the input file."""
    script_dir = Path(__file__).parent
    filepath = script_dir / filename
    with open(filepath, 'r') as f:
        return f.read().strip()

def part1(data):
    lines = data.split('\n')
    grid = np.array([[1 if c == '@' else 0 for c in line] for line in lines])
    
    # Pad grid with zeros
    padded = np.pad(grid, 1, constant_values=0)
    
    count = 0
    rows, cols = grid.shape
    for i in range(rows):
        for j in range(cols):
            if grid[i, j] == 1:  # If it's a @
                # Extract 3x3 (padded coords are +1)
                neighbors = padded[i:i+3, j:j+3]
                neighbor_sum = neighbors.sum() - 1  # Subtract center
                if neighbor_sum < 4: 
                    count += 1
    
    return count
    

def part2(data):
    """Solve part 2."""
    lines = data.split('\n')
    grid = np.array([[1 if c == '@' else 0 for c in line] for line in lines])
    
    total_removed = 0
    
    while True:
        # Make a copy to track removals
        new_grid = grid.copy()
        
        # Pad current grid
        padded = np.pad(grid, 1, constant_values=0)
        
        rows, cols = grid.shape
        for i in range(rows):
            for j in range(cols):
                if grid[i, j] == 1:  # If it's a @
                    # Extract 3x3 (padded coords are +1)
                    neighbors = padded[i:i+3, j:j+3]
                    neighbor_sum = neighbors.sum() - 1  # Subtract center
                    if neighbor_sum < 4:
                        new_grid[i, j] = 0  # Remove it
                        total_removed += 1
        
        # If nothing changed, we're done
        if np.array_equal(grid, new_grid):
            break
        
        grid = new_grid
    
    return total_removed


def part2_convolution(data):
    """Solve part 2 using convolution (faster)."""
    lines = data.split('\n')
    grid = np.array([[1 if c == '@' else 0 for c in line] for line in lines])
    
    # Convolution kernel to count neighbors (including diagonals)
    kernel = np.ones((3, 3), dtype=int)
    kernel[1, 1] = 0  # Don't count center cell
    
    total_removed = 0
    
    while True:
        # Count neighbors for all cells
        neighbor_counts = convolve(grid, kernel, mode='constant', cval=0)
        
        # Find @s (grid == 1) with < 4 neighbors
        to_remove = (grid == 1) & (neighbor_counts < 4)
        
        # If nothing to remove, we're done
        if not np.any(to_remove):
            break
        
        # Count and remove
        total_removed += np.sum(to_remove)
        grid[to_remove] = 0
    
    return total_removed

if __name__ == "__main__":
    # Read input
    data = read_input()
    
    # Solve part 1
    t1s = time.perf_counter()
    answer1 = part1(data)
    t1e = time.perf_counter()
    print(f"Part 1: {answer1} (time: {(t1e - t1s) * 1000:.3f} ms)")
    
    # Solve part 2 (loop method)
    t2s = time.perf_counter()
    answer2 = part2(data)
    t2e = time.perf_counter()
    print(f"Part 2: {answer2} (time: {(t2e - t2s) * 1000:.3f} ms)")
    
    # Solve part 2 (convolution method)
    t2cs = time.perf_counter()
    answer2c = part2_convolution(data)
    t2ce = time.perf_counter()
    print(f"Part 2 (conv): {answer2c} (time: {(t2ce - t2cs) * 1000:.3f} ms)")
