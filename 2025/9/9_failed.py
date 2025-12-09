"""
Advent of Code 2025 - Day 9 - Code of shame
Movie Theater
"""

def flood_fill(matrix, x, y, fill_value=0):
    """Flood fill the inside of a shape starting from (x, y)."""
    rows, cols = len(matrix), len(matrix[0])
    target_value = matrix[x][y]  # The value to replace (e.g., 1)

    # If the starting point is already the border, return
    if target_value == fill_value:
        return

    # Use a stack for iterative flood fill
    stack = [(x, y)]
    while stack:
        cx, cy = stack.pop()

        # Fill the current cell
        matrix[cx][cy] = fill_value

        # Check all 4 neighbors (up, down, left, right)
        for nx, ny in [(cx-1, cy), (cx+1, cy), (cx, cy-1), (cx, cy+1)]:
            if 0 <= nx < rows and 0 <= ny < cols and matrix[nx][ny] == target_value:
                stack.append((nx, ny))

def build_prefix_sum(matrix):
    """Build a prefix sum matrix."""
    rows, cols = len(matrix), len(matrix[0])
    prefix = [[0] * cols for _ in range(rows)]

    for r in range(rows):
        for c in range(cols):
            prefix[r][c] = matrix[r][c]
            if r > 0:
                prefix[r][c] += prefix[r-1][c]
            if c > 0:
                prefix[r][c] += prefix[r][c-1]
            if r > 0 and c > 0:
                prefix[r][c] -= prefix[r-1][c-1]
    return prefix

def submatrix_sum(prefix, r1, c1, r2, c2):
    """Calculate the sum of a sub-matrix using the prefix sum matrix."""
    total = prefix[r2][c2]
    total -= prefix[r1-1][c2]
    total -= prefix[r2][c1-1]
    total += prefix[r1-1][c1-1]
    return total


def part2(coords):
    """Solve part 2."""
    # print(coords)

    xmax, ymax = 0, 0
    for x, y in coords:
        xmax = max(xmax, x)
        ymax = max(ymax, y)

    print(len(coords), "coordinates found.")
    print(f"Matrix size: {xmax+1} x {ymax+1}")
    # Build a matrix of 1s with dimensions (xmax+1) x (ymax+1)
    matrix = [[1 for _ in range(ymax + 1)] for _ in range(xmax + 1)]

    print("Drawing shape...")
    for i, coord in enumerate(coords):
        x1, y1 = coord
        x2, y2 = coords[i + 1] if i + 1 < len(coords) else coords[0]
        for x in range(min(x1, x2), max(x1, x2) + 1):
            for y in range(min(y1, y2), max(y1, y2) + 1):
                matrix[x][y] = 0


    # print_matrix(matrix)

    print("Performing flood fill...")
    for i, row in enumerate(matrix[1:-1], start=1):
        found = False
        for j in range(1, len(row) - 1):
            if row[j] == 0 and row[j + 1] == 0:
                break
            if row[j] == 0 and row[j + 1] == 1:
                # print(f"Found at {i}, {j}")
                flood_fill(matrix, i, j + 1)
                found = True
                break
        if found:
            break

    print_matrix(matrix)
    prefix = build_prefix_sum(matrix)
    # print_matrix(prefix)

    print("Calculating largest rectangle...")
    largest = 0
    for a, b in list(combinations(coords, 2)):
        ax, ay = a
        bx, by = b
        if submatrix_sum(prefix, min(ax, bx), min(ay, by), max(ax, bx), max(ay, by)) == 0:
            area = (abs(ax - bx) + 1) * (abs(ay - by) + 1)
            largest = max(largest, area)

    return largest