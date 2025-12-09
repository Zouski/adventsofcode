"""
Advent of Code 2025 - Day 9
Movie Theater - Compression Approach
"""

import time
from pathlib import Path
from itertools import combinations

def read_input(filename="input.txt"):
    """Read and parse the input file."""
    script_dir = Path(__file__).parent
    filepath = script_dir / filename
    with open(filepath, 'r') as f:
        return f.read().strip()

def flood_fill(matrix, x, y, fill_value=0):
    """Scanline flood fill - much faster than 4-neighbor approach."""
    rows, cols = len(matrix), len(matrix[0])
    target_value = matrix[y][x]

    if target_value == fill_value:
        return

    stack = [(x, y)]

    while stack:
        x, y = stack.pop()

        if matrix[y][x] != target_value:
            continue

        # Fill entire horizontal line
        left = x
        while left > 0 and matrix[y][left - 1] == target_value:
            left -= 1

        right = x
        while right < cols - 1 and matrix[y][right + 1] == target_value:
            right += 1

        # Mark entire segment
        for i in range(left, right + 1):
            matrix[y][i] = fill_value

        # Add adjacent rows to stack
        if y > 0:
            for i in range(left, right + 1):
                if matrix[y - 1][i] == target_value:
                    stack.append((i, y - 1))

        if y < rows - 1:
            for i in range(left, right + 1):
                if matrix[y + 1][i] == target_value:
                    stack.append((i, y + 1))

def print_matrix_with_gradient(matrix, prefix, rectangle_coords=None, corner_coords=None):
    """Print the matrix (1s and 0s) with colors representing prefix sum gradient.
    
    Args:
        matrix: The filled/unfilled matrix
        prefix: The prefix sum matrix
        rectangle_coords: Optional tuple of (x_min, x_max, y_min, y_max) in compressed space to highlight with 2s
        corner_coords: Optional set of (x, y) tuples for corner positions to mark as 3s
    """
    max_val = prefix[-1][-1]
    
    RESET = '\033[0m'
    
    # If rectangle coords provided, mark the rectangle with 2s
    display_matrix = [row[:] for row in matrix]  # Copy matrix
    if rectangle_coords:
        x_min, x_max, y_min, y_max = rectangle_coords
        for y in range(y_min, y_max + 1):
            for x in range(x_min, x_max + 1):
                display_matrix[y][x] = 2
    
    # Mark corners with 3s
    if corner_coords:
        for x, y in corner_coords:
            display_matrix[y][x] = 3
    
    for y in range(len(display_matrix)):
        colored_row = ''
        for x in range(len(display_matrix[y])):
            cell_val = display_matrix[y][x]
            
            # Always print 2s as white
            if cell_val == 2:
                r, g, b = 255, 255, 255
            # Always print 3s as blue
            elif cell_val == 3:
                r, g, b = 0, 0, 255
            else:
                # Use prefix sum value for 0s and 1s
                val = prefix[y+1][x+1]
                if max_val == 0:
                    r, g, b = 255, 255, 255
                else:
                    # Gradient: 0,0,0 → 255,0,0 → 255,255,0 → 0,255,0 → 0,255,255 → 0,0,255 → 255,0,255 → 255,255,255
                    ratio = val / max_val  # 0 to 1
                    if ratio < 1/8:  # black to red
                        r = int(255 * (ratio / (1/8)))
                        g = 0
                        b = 0
                    elif ratio < 2/8:  # red to yellow
                        r = 255
                        g = int(255 * ((ratio - 1/8) / (1/8)))
                        b = 0
                    elif ratio < 3/8:  # yellow to green
                        r = int(255 * (1 - (ratio - 2/8) / (1/8)))
                        g = 255
                        b = 0
                    elif ratio < 4/8:  # green to cyan
                        r = 0
                        g = 255
                        b = int(255 * ((ratio - 3/8) / (1/8)))
                    elif ratio < 5/8:  # cyan to blue
                        r = 0
                        g = int(255 * (1 - (ratio - 4/8) / (1/8)))
                        b = 255
                    elif ratio < 6/8:  # blue to magenta
                        r = int(255 * ((ratio - 5/8) / (1/8)))
                        g = 0
                        b = 255
                    elif ratio < 7/8:  # magenta to white
                        r = 255
                        g = int(255 * ((ratio - 6/8) / (1/8)))
                        b = 255
                    else:  # white
                        r = 255
                        g = 255
                        b = 255
            # Print the actual cell value (1 or 0 or 2 or 3) with the color
            cell_char = str(display_matrix[y][x])
            colored_row += f"\033[38;2;{r};{g};{b}m{cell_char}{RESET}"
        print(colored_row)
    print()

def part1(data):
    """Solve part 1."""
    lines = data.split('\n')
    coords = [tuple(map(int, line.split(','))) for line in lines]
    
    largest = 0
    for a, b in combinations(coords, 2):
        ax, ay = a
        bx, by = b
        area = (abs(ax - bx) + 1) * (abs(ay - by) + 1)
        largest = max(largest, area)
    
    return largest, coords

def build_prefix_sum(matrix, width, height):
    """Build prefix sum matrix for fast rectangle queries."""
    prefix = [[0 for _ in range(width + 1)] for _ in range(height + 1)]
    for y in range(1, height + 1):
        for x in range(1, width + 1):
            prefix[y][x] = matrix[y-1][x-1] + prefix[y-1][x] + prefix[y][x-1] - prefix[y-1][x-1]
    return prefix

def check_prefix_sum(prefix, x_min, x_max, y_min, y_max):
    """Check if rectangle interior is all 0s using prefix sum."""
    rect_sum = prefix[y_max+1][x_max+1] - prefix[y_min][x_max+1] - prefix[y_max+1][x_min] + prefix[y_min][x_min]
    return rect_sum == 0

def check_rectangle_edges(matrix, x_min, x_max, y_min, y_max):
    """Check if rectangle has any 1s on its four edges. Returns False if valid (no 1s found)."""
    # Check top edge
    for x in range(x_min, x_max + 1):
        if matrix[y_min][x] == 1:
            return True
    
    # Check bottom edge
    for x in range(x_min, x_max + 1):
        if matrix[y_max][x] == 1:
            return True
    
    # Check left edge
    for y in range(y_min, y_max + 1):
        if matrix[y][x_min] == 1:
            return True
    
    # Check right edge
    for y in range(y_min, y_max + 1):
        if matrix[y][x_max] == 1:
            return True
    
    return False

def check_area_against_largest(x1_real, y1_real, x2_real, y2_real, largest):
    """Calculate area and check if it's larger than current best."""
    area = (abs(x2_real - x1_real) + 1) * (abs(y2_real - y1_real) + 1)
    return area, area > largest

def part2(coords):
    """Solve part 2 using compression and prefix sum approach."""
    # Extract all unique X and Y values, sorted
    x_base = sorted(set(x for x, y in coords))
    y_base = sorted(set(y for x, y in coords))
    
    # Add in-between values (x and x+1 for each x)
    x_values = sorted(set(val for x in x_base for val in [x, x + 1]))
    y_values = sorted(set(val for y in y_base for val in [y, y + 1]))
    
    # Create mapping from actual coordinates to indices
    x_to_idx = {x: i for i, x in enumerate(x_values)}
    y_to_idx = {y: i for i, y in enumerate(y_values)}
    
    # Convert coordinates to compressed indices
    compressed_coords = [(x_to_idx[x], y_to_idx[y]) for x, y in coords]
    
    # Create matrix of 1s
    width = len(x_values)
    height = len(y_values)
    matrix = [[1 for _ in range(width)] for _ in range(height)]
    
    # Mark corners as 0 and draw edges between consecutive corners
    for i, (x1, y1) in enumerate(compressed_coords):
        x2, y2 = compressed_coords[(i + 1) % len(compressed_coords)]
        
        # Mark corner as 0
        matrix[y1][x1] = 0
        
        # Draw line from (x1, y1) to (x2, y2)
        if x1 == x2:
            # Vertical line
            for y in range(min(y1, y2), max(y1, y2) + 1):
                matrix[y][x1] = 0
        else:
            # Horizontal line
            for x in range(min(x1, x2), max(x1, x2) + 1):
                matrix[y1][x] = 0
    
    # Flood fill interior
    for i, row in enumerate(matrix[1:-1], start=1):
        found = False
        for j in range(1, len(row) - 1):
            if row[j] == 0 and row[j + 1] == 0:
                break
            if row[j] == 0 and row[j + 1] == 1:
                flood_fill(matrix, j + 1, i)
                found = True
                break
        if found:
            break
    
    # Create prefix sum matrix
    prefix = build_prefix_sum(matrix, width, height)
    
    # Find largest rectangle with prefix sum of 0 (all interior cells)
    largest_p2 = 0
    best_coords_p2 = None
    best_compressed_coords = None
    
    for (x1_c, y1_c), (x2_c, y2_c) in combinations(compressed_coords, 2):
        # Normalize rectangle
        x_min, x_max = min(x1_c, x2_c), max(x1_c, x2_c)
        y_min, y_max = min(y1_c, y2_c), max(y1_c, y2_c)
        
        # Calculate area using original coordinates FIRST (cheap check)
        x1_real = x_values[x_min]
        y1_real = y_values[y_min]
        x2_real = x_values[x_max]
        y2_real = y_values[y_max]
        
        area, is_larger = check_area_against_largest(x1_real, y1_real, x2_real, y2_real, largest_p2)
        
        # Skip expensive prefix sum check if area isn't better
        if not is_larger:
            continue
        
        # Query prefix sum for rectangle
        if check_prefix_sum(prefix, x_min, x_max, y_min, y_max):
            largest_p2 = area
            best_coords_p2 = ((x1_real, y1_real), (x2_real, y2_real))
            best_compressed_coords = (x_min, x_max, y_min, y_max)
    
    return largest_p2, best_coords_p2

if __name__ == "__main__":
    # Read input
    data = read_input()

    # Solve part 1
    t1s = time.perf_counter()
    answer1, coords = part1(data)
    t1e = time.perf_counter()
    print(f"Part 1: {answer1} (time: {(t1e - t1s) * 1000:.3f} ms)")

    # Solve part 2
    t2s = time.perf_counter()
    answer2, best_coords = part2(coords)
    t2e = time.perf_counter()
    
    print(f"Part 2: {answer2} (time: {(t2e - t2s) * 1000:.3f} ms)")
    # if best_coords:
    #     print(f"  Best rectangle coords: {best_coords[0]} to {best_coords[1]}")
