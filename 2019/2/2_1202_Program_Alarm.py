"""
Advent of Code 2019 - Day 2
1202 Program Alarm
"""

import time
from pathlib import Path

def read_input(filename="input.txt"):
    """Read and parse the input file."""
    script_dir = Path(__file__).parent
    filepath = script_dir / filename
    with open(filepath, 'r') as f:
        return f.read().strip()
    
def combine(a, b, op): 
    if op == 1: 
        return a + b 
    elif op == 2: 
        return a * b 
    else: 
        raise ValueError(f"Unknown operation {op}")

def part1(data):
    """Solve part 1."""
    lines = data.split(',')
    nums = [int(s) for s in lines]
    #print(nums)
    result = 0
    p = 0
    nums[1] = 12
    nums[2] = 2

    while(True):
        if nums[p] == 99:
            break
        nums[nums[p + 3]] = combine(nums[nums[p + 1]], nums[nums[p + 2]], nums[p])
        p += 4
        #print(nums)

    #print(nums)
    return nums[0]

def part2(data):
    """Solve part 2."""
    lines = data.split(',')
    nums_original = [int(s) for s in lines]
    #print(nums)
    solved = False
    for x in range(100):
        for y in range(100):
            nums = nums_original.copy()
            p = 0
            nums[1] = x
            nums[2] = y
            
            while(True):
                if nums[p] == 99:
                    break
                nums[nums[p + 3]] = combine(nums[nums[p + 1]], nums[nums[p + 2]], nums[p])
                p += 4
                #print(nums)

            #print(nums)
            if nums[0] == 19690720:
                solved = 100 * x + y
            if solved != False:
                break
        if solved != False:
            break
    
    return solved
    

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
