package main

import (
	"fmt"
	"os"
)

var (
	debug = true
	file  = "4e.txt"
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
}
