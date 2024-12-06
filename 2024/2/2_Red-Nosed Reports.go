package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

var (
	debug = true
	file  = "2.txt"
)

func puts(a ...interface{}) (int, error) {
	if debug {
		return fmt.Println(a...)
	}
	return 0, nil
}

func putsy(a ...interface{}) (int, error) {
	return fmt.Println(a...)
}

func safe(report []int) bool {
	distance := 3
	ldistance := 1

	if report[0] == report[1] {
		return false
	} else if report[0] < report[1] {
		distance = -1
		ldistance = -3
	}

	last := report[0] + distance
	for _, next := range report {
		if (last - next) > distance {
			return false
		} else if (last - next) < ldistance {
			return false
		}
		last = next
	}

	return true
}

func safedown(report []int) bool {
	distance := 3
	ldistance := 1
	errors := 0

	last := 0
	for i, next := range report {
		if i == 0 {
			last = next
			continue
		}
		if (last - next) > distance {
			if errors > 0 {
				return false
			} else {
				errors += 1
				continue
			}
		} else if (last - next) < ldistance {
			if errors > 0 {
				return false
			} else {
				errors += 1
				continue
			}
		}
		last = next
	}

	return true
}

func safeup(report []int) bool {
	distance := -1
	ldistance := -3
	errors := 0

	last := 0
	for i, next := range report {
		if i == 0 {
			last = next
			continue
		}

		if (last - next) > distance {
			if errors > 0 {
				return false
			} else {
				errors += 1
				continue
			}
		} else if (last - next) < ldistance {
			if errors > 0 {
				return false
			} else {
				errors += 1
				continue
			}
		}
		last = next
	}

	return true
}

func main() {
	data, _ := os.ReadFile(file)

	content := string(data)

	puts(content)

	lines := strings.Split(content, "\n")
	puts(lines)

	var reports = [][]int{}
	for _, line := range lines {
		chars := strings.Split(line, " ")
		var nums = []int{}
		for _, char := range chars {
			num, _ := strconv.Atoi(char)
			nums = append(nums, num)
		}
		reports = append(reports, nums)
	}

	puts(reports)

	safes := 0
	for i, report := range reports {
		puts("Report", i, "is", safe(report))

		if safe(report) {
			safes += 1
		}

	}
	putsy(safes)

	safes2 := 0
	for i, report := range reports {
		boool := safeup(report) || safedown(report)
		if !boool {
			for j := range report {
				subset := make([]int, len(report)-1)
				copy(subset, report[:j])
				copy(subset[j:], report[j+1:])
				if safe(subset) {
					boool = true
					break
				}
			}
		}
		puts("Report", i, report, "is", boool, "            ", safeup(report), safedown(report), safe(report[1:]))

		if boool {
			safes2 += 1
		}

	}
	putsy(safes2)

}
