#!/usr/bin/env python3
"""
Advent of Code Daily Problem Puller
Automatically fetches the daily problem, input data, and creates a solution file.
"""

import os
import sys
import requests
from datetime import datetime
from pathlib import Path

# Configuration
AOC_YEAR = 2025
BASE_URL = f"https://adventofcode.com/{AOC_YEAR}"
SESSION_COOKIE_FILE = ".aoc_session"

def get_session_cookie():
    """Read the session cookie from file."""
    cookie_path = Path(__file__).parent / SESSION_COOKIE_FILE
    if not cookie_path.exists():
        print(f"Error: Session cookie file '{SESSION_COOKIE_FILE}' not found!")
        print("\nTo get your session cookie:")
        print("1. Log in to https://adventofcode.com")
        print("2. Open browser DevTools (F12)")
        print("3. Go to Application/Storage -> Cookies")
        print("4. Copy the value of the 'session' cookie")
        print(f"5. Save it in a file named '{SESSION_COOKIE_FILE}' in this directory")
        sys.exit(1)
    
    with open(cookie_path, 'r') as f:
        return f.read().strip()

def fetch_problem_input(day, session):
    """Fetch the input data for a specific day."""
    url = f"{BASE_URL}/day/{day}/input"
    headers = {"Cookie": f"session={session}"}
    
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.text
    else:
        print(f"Error fetching input: HTTP {response.status_code}")
        print(response.text)
        return None

def fetch_problem_html(day, session):
    """Fetch the problem HTML for a specific day."""
    url = f"{BASE_URL}/day/{day}"
    headers = {"Cookie": f"session={session}"}
    
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.text
    elif response.status_code == 404:
        return "404"
    else:
        print(f"Error fetching problem: HTTP {response.status_code}")
        return None

def extract_example_input(html_content):
    """Extract the first <pre><code> block as example input."""
    import re
    match = re.search(r'<pre><code>(.*?)</code></pre>', html_content, re.DOTALL)
    if match:
        return match.group(1).strip()
    return None

def extract_problem_name(html_content):
    """Extract the problem name from HTML content."""
    import re
    match = re.search(r'<h2>--- Day \d+: (.+?) ---</h2>', html_content)
    if match:
        return match.group(1)
    return ""

def create_solution_file(day, problem_name=""):
    """Create a Python solution file from template."""
    year_dir = Path(__file__).parent / str(AOC_YEAR)
    day_dir = year_dir / str(day)
    day_dir.mkdir(parents=True, exist_ok=True)
    
    # Create the solution file
    if problem_name:
        solution_file = day_dir / f"{day}_{problem_name.replace(' ', '_')}.py"
    else:
        solution_file = day_dir / f"{day}_solution.py"
    
    if solution_file.exists():
        print(f"Solution file already exists: {solution_file} (skipping)")
        return solution_file
    
    template = f'''"""
Advent of Code {AOC_YEAR} - Day {day}
{problem_name}
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
    lines = data.split('\\n')
    
    # TODO: Implement solution
    result = 0
    
    return result

def part2(data):
    """Solve part 2."""
    lines = data.split('\\n')
    
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
    print(f"Part 1: {{answer1}} (time: {{(t1e - t1s) * 1000:.3f}} ms)")
    
    # Solve part 2
    t2s = time.perf_counter()
    answer2 = part2(data)
    t2e = time.perf_counter()
    print(f"Part 2: {{answer2}} (time: {{(t2e - t2s) * 1000:.3f}} ms)")
'''
    
    with open(solution_file, 'w') as f:
        f.write(template)
    
    print(f"Created solution file: {solution_file}")
    return solution_file

def save_input_data(day, input_data):
    """Save the input data to a file."""
    year_dir = Path(__file__).parent / str(AOC_YEAR)
    day_dir = year_dir / str(day)
    day_dir.mkdir(parents=True, exist_ok=True)
    
    input_file = day_dir / "input.txt"
    if input_file.exists():
        print(f"Input file already exists: {input_file} (skipping)")
        return input_file
    
    with open(input_file, 'w') as f:
        f.write(input_data)
    
    print(f"Saved input data: {input_file}")
    return input_file

def save_example_input(day, example_data):
    """Save the example input data to a file."""
    year_dir = Path(__file__).parent / str(AOC_YEAR)
    day_dir = year_dir / str(day)
    day_dir.mkdir(parents=True, exist_ok=True)
    
    input_file = day_dir / "inputE.txt"
    if input_file.exists():
        print(f"Example file already exists: {input_file} (skipping)")
        return input_file
    
    with open(input_file, 'w') as f:
        f.write(example_data)
    
    print(f"Saved example input: {input_file}")
    return input_file

def fetch_day(day, session):
    """Fetch and setup a single day. Returns (solution_file, success)."""
    # Fetch problem HTML for example
    print("\nFetching problem page...")
    problem_html = fetch_problem_html(day, session)
    problem_name = ""
    
    if problem_html == "404":
        print(f"Day {day} not available yet (404)")
        return None, False
    elif problem_html:
        problem_name = extract_problem_name(problem_html)
        if problem_name:
            print(f"Problem: {problem_name}")
        
        example_input = extract_example_input(problem_html)
        if example_input:
            save_example_input(day, example_input)
        else:
            print("No example input found in <pre><code> tags")
    else:
        print("Failed to fetch problem page")
        return None, False
    
    # Fetch input data
    print("\nFetching input data...")
    input_data = fetch_problem_input(day, session)
    if input_data:
        save_input_data(day, input_data)
    else:
        print("Failed to fetch input data")
    
    # Create solution file
    print("\nCreating solution file...")
    solution_file = create_solution_file(day, problem_name)
    return solution_file, True

def main():
    """Main function to pull daily AOC problem."""
    global AOC_YEAR, BASE_URL
    
    # Determine which day(s) to fetch
    if len(sys.argv) > 1:
        arg = sys.argv[1]
        # Check if it's a 4-digit year
        if len(arg) == 4 and arg.isdigit():
            year = int(arg)
            if year < 2015 or year > datetime.now().year:
                print(f"Invalid year: {year}. AOC started in 2015.")
                sys.exit(1)
            
            # Check if a specific day is provided (year day)
            if len(sys.argv) > 2:
                day = int(sys.argv[2])
                print(f"Fetching Advent of Code {year} - Day {day}")
                print("=" * 50)
                
                # Get session cookie
                session = get_session_cookie()
                
                # Temporarily change AOC_YEAR
                AOC_YEAR = year
                BASE_URL = f"https://adventofcode.com/{AOC_YEAR}"
                
                # Fetch single day
                solution_file, success = fetch_day(day, session)
                
                if success:
                    print("\n" + "=" * 50)
                    print("✓ Setup complete!")
                    print(f"\nStart coding: {solution_file}")
                else:
                    print("\n" + "=" * 50)
                    print("✗ Failed to fetch day")
                return
            
            print(f"Fetching all 25 days for Advent of Code {year}")
            print("=" * 50)
            
            # Get session cookie
            session = get_session_cookie()
            
            # Temporarily change AOC_YEAR
            AOC_YEAR = year
            BASE_URL = f"https://adventofcode.com/{AOC_YEAR}"
            
            # Fetch all days until we hit a 404
            days_fetched = 0
            for day in range(1, 26):
                print(f"\n{'='*50}")
                print(f"Day {day}")
                print('='*50)
                try:
                    solution_file, success = fetch_day(day, session)
                    if not success:
                        print(f"\nStopping at day {day} (not available)")
                        break
                    days_fetched += 1
                except Exception as e:
                    print(f"Error fetching day {day}: {e}")
                    continue
            
            print("\n" + "=" * 50)
            print(f"✓ Setup complete for {days_fetched} days of {year}!")
            return
        else:
            day = int(arg)
    else:
        # Default to current day in December
        now = datetime.now()
        if now.month == 12 and now.day <= 25:
            day = now.day
        else:
            print("Please specify a day or year: python aoc_puller.py <day|year> [day]")
            sys.exit(1)
    
    print(f"Fetching Advent of Code {AOC_YEAR} - Day {day}")
    print("=" * 50)
    
    # Get session cookie
    session = get_session_cookie()
    
    # Fetch single day
    solution_file, success = fetch_day(day, session)
    
    if success:
        print("\n" + "=" * 50)
        print("✓ Setup complete!")
        print(f"\nStart coding: {solution_file}")
    else:
        print("\n" + "=" * 50)
        print("✗ Failed to fetch day")

if __name__ == "__main__":
    main()
