"""
Advent of Code 2025 - Day 10
Factory
"""

import time
from pathlib import Path
from pulp import LpProblem, LpVariable, LpMinimize, lpSum, LpStatus, value, PULP_CBC_CMD

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
        all = line.split()
        light = int(all[0][1:-1][::-1].replace('.', '0').replace('#', '1'),2)
        buttons = [list(map(int,mask.replace('(', '').replace(')', '').split(','))) for mask in all[1:-1]]

        masks = []
        for button in buttons:
            state = 0
            for bit in button:
                state |= 1 << bit
            masks.append(state)


        # print(bin(light), [bin(mask) for mask in masks])

        #bfs state ^ mask until = light
        states = set([0])
        turns = 0
        old_states = set([])
        while light not in states:
            turns += 1
            new_states = set()
            for state in states:
                for mask in masks:
                    new_states.add(state ^ mask)
            old_states.update(states)
            states = new_states - old_states
            # print(f"After {turns} turns: {len(states)} states")
        
        # print(f"Found light {bin(light)} in {turns} turns")
        result += turns
    return result
            
            
                
        

def part2(data):
    """Solve part 2."""
    lines = data.split('\n')
    
    result = 0
    for line in lines:
        
        all = line.split()
        buttons = [list(map(int,mask.replace('(', '').replace(')', '').split(','))) for mask in all[1:-1]]
        joltage = list(map(int,all[-1].replace('{', '').replace('}', '').split(',')))

        matrices = []
        for button in buttons:
            matrix = [0] * (len(joltage))
            for num in button:
                matrix[num] = 1
            matrices.append(matrix)

        # Define the problem
        problem = LpProblem("Minimize_Button_Presses", LpMinimize)

        # Create integer variables for each button
        variables = [LpVariable(f"button_{i}", lowBound=0, cat="Integer") for i in range(len(matrices))]

        # Add constraints: each position must match the target
        for i in range(len(joltage)):
            problem += lpSum(variables[j] * matrices[j][i] for j in range(len(matrices))) == joltage[i], f"position_{i}"

            # a * [1,1,0,1] +
            # b * [0,1,1,0] +
            # c * [1,0,1,1] == [4,3,3,4]

        # Objective: minimize total button presses
        problem += lpSum(variables), "total_presses"

        # Solve with silent output
        problem.solve(PULP_CBC_CMD(msg=0))

        # Collect the result
        if value(problem.objective) is not None:
            result += int(value(problem.objective))
    
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
