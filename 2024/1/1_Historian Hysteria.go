package main

import (
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

// because I'm used to ruby
func puts(a ...interface{}) (int, error) {
	return fmt.Println(a...)
}

func main() {
	data, _ := os.ReadFile("1.txt")

	content := string(data)

	lines := strings.Split(content, "\n")

	var one []int
	var two []int

	for _, line := range lines {
		pair := strings.Split(line, "   ")
		x, _ := strconv.Atoi(pair[0])
		y, _ := strconv.Atoi(pair[1])
		one = append(one, x)
		two = append(two, y)
	}
	sort.Ints(one)
	sort.Ints(two)

	sum := 0

	for i := range one {
		diff := one[i] - two[i]
		if diff < 0 {
			diff = -diff
		}
		sum += diff
	}

	puts(sum)

	sum2 := 0
	for _, x := range one {
		for _, y := range two {
			if x == y {
				sum2 += x
			}
		}
	}

	puts(sum2)
}
