"""
Advent of Code 2024 - Day 2
Red-Nosed Reports
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
    # print(lines)

    result = 0
    for line in lines: #'7 6 4 2 1'
        numbers = list(map(int, line.split()))
        # print(numbers)

        valid = True
        min, max = 1, 3
        sign = 1
        for i in range(len(numbers) - 1):
            if i == 0:
                if numbers[i] < numbers[i+1]:
                    sign = -1

            # print(f"checking {numbers[i]} and {numbers[i+1]} with min {min} and max {max}, resulting in {numbers[i] - numbers[i+1]}")
            if not (min <= abs(numbers[i] - numbers[i+1]) <= max and sign * (numbers[i] - numbers[i+1]) > 0):
                valid = False
                # print(f"invalid: not min {min} <= {numbers[i]} - {numbers[i+1]}:{numbers[i] - numbers[i+1]} <= {max} is False, sign check(sign {sign}) {sign * (numbers[i] - numbers[i+1])} > 0 is False")
                break

        if valid:
            result += 1
    
    return result


def part2(data):
    """Solve part 2."""
    lines = data.split('\n')
    # print(lines)

    result = 0
    for line in lines: #'7 6 4 2 1'
        numbers = list(map(int, line.split()))
        # print(numbers)

        valid = True
        min, max = 1, 3
        sign = 1
        for i in range(len(numbers) - 1):
            if i == 0:
                if numbers[i] < numbers[i+1]:
                    sign = -1

            # print(f"checking {numbers[i]} and {numbers[i+1]} with min {min} and max {max}, resulting in {numbers[i] - numbers[i+1]}")
            if not (min <= abs(numbers[i] - numbers[i+1]) <= max and sign * (numbers[i] - numbers[i+1]) > 0):
                valid = False
                # print(f"invalid: not min {min} <= {numbers[i]} - {numbers[i+1]}:{numbers[i] - numbers[i+1]} <= {max} is False, sign check(sign {sign}) {sign * (numbers[i] - numbers[i+1])} > 0 is False")
                break

        if valid:
            result += 1
            # print(f"counting valid without changes: {numbers}")
            continue


        # FINE you dont like that list, try all the lists minus one element
        list_of_lists = []
        for j in range(len(numbers)):
            new_list = numbers[:j] + numbers[j+1:]
            list_of_lists.append(new_list)

        for numbers2 in list_of_lists:
            valid = True
            sign = 1
            for i in range(len(numbers2) - 1):
                if i == 0:
                    if numbers2[i] < numbers2[i+1]:
                        sign = -1

                # print(f"checking {numbers2[i]} and {numbers2[i+1]} with min {min} and max {max}, resulting in {numbers2[i] - numbers2[i+1]}")
                if not (min <= abs(numbers2[i] - numbers2[i+1]) <= max and sign * (numbers2[i] - numbers2[i+1]) > 0):
                    valid = False
                    # print(f"invalid: not min {min} <= {numbers2[i]} - {numbers2[i+1]}:{numbers2[i] - numbers2[i+1]} <= {max} is False, sign check(sign {sign}) {sign * (numbers2[i] - numbers2[i+1])} > 0 is False")
                    break
            if valid == True:
                break

        if valid:
            # print(f"counting valid with one removal: {numbers2}")
            result += 1
        
        
            
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
