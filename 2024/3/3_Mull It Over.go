package main

import (
	"fmt"
	"os"
	"regexp"
	"sort"
	"strconv"
)

var (
	debug = false
	file  = "3.txt"
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

func main() {
	data, _ := os.ReadFile(file)
	content := string(data)
	puts(content)

	regex, _ := regexp.Compile(`mul\((\d{1,3}),(\d{1,3})\)`)
	dos, _ := regexp.Compile(`do\(\)`)
	donts, _ := regexp.Compile(`don't\(\)`)

	matches := regex.FindAllStringSubmatch(content, -1)

	sum := 0

	for _, match := range matches {
		x, _ := strconv.Atoi(match[1])
		y, _ := strconv.Atoi(match[2])
		sum += x * y
	}

	putsy(sum)

	puts(regex.FindAllStringSubmatch(content, -1))
	puts(regex.FindAllStringIndex(content, -1))
	match_indexs := regex.FindAllStringIndex(content, -1)

	puts(content)
	do_indexs := dos.FindAllStringIndex(content, -1)
	dont_indexs := donts.FindAllStringIndex(content, -1)

	puts(match_indexs)
	puts(do_indexs)
	puts(dont_indexs)

	line := make(map[int]int)
	keys := []int{}

	addLambda := func(m map[int]int) {
		for key, value := range m {
			line[key] = value
			keys = append(keys, key)
		}
	}

	addLambda(map_from_match(match_indexs, 0))
	addLambda(map_from_match(do_indexs, -1))
	addLambda(map_from_match(dont_indexs, -2))

	sort.Ints(keys)

	puts(line)
	puts(keys)

	do := true

	sum2 := 0

	for _, key := range keys {
		if line[key] == -1 {
			do = true
			continue
		} else if line[key] == -2 {
			do = false
		} else {
			if do {
				x, _ := strconv.Atoi(matches[line[key]][1])
				y, _ := strconv.Atoi(matches[line[key]][2])
				sum2 += x * y
			}
		}
	}

	putsy(sum2)

}

func map_from_match(matches [][]int, word int) map[int]int {
	var line = make(map[int]int)
	for i, match := range matches {
		x := word
		if word == 0 {
			x = i
		}
		line[match[0]] = x
	}
	return line
}
