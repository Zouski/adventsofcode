# Advent of Code Solutions

My solutions for [Advent of Code](https://adventofcode.com/) challenges.

## 2025 Setup (Python)

### Automated Daily Problem Puller

Use `aoc_puller.py` to automatically fetch the daily problem and input data.

#### Setup

1. Get your Advent of Code session cookie:
   - Log in to https://adventofcode.com
   - Open browser DevTools (F12)
   - Go to Application/Storage → Cookies
   - Copy the value of the `session` cookie

2. Save your session cookie:
   ```bash
   echo "your_session_cookie_here" > .aoc_session
   ```

3. Install required Python packages:
   ```bash
   pip install requests
   ```

#### Usage

Fetch today's problem (if it's December 1-25):
```bash
python aoc_puller.py
```

Fetch a specific day:
```bash
python aoc_puller.py 5
```

This will:
- Create a directory `2025/<day>/`
- Download the input data to `2025/<day>/input.txt`
- Save the problem description to `2025/<day>/problem.html`
- Create a solution template at `2025/<day>/<day>_<problem_name>.py`

#### Run your solution

```bash
cd 2025/<day>
python <day>_<problem_name>.py
```

## Previous Years

- **2020-2023**: Ruby solutions
- **2024**: Go solutions
- **2025**: Python solutions
