package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"strings"
)

var (
	version = "1.0.0"
)

func main() {
	envFile := flag.String("f", ".env", "Path to the .env file")
	showVersion := flag.Bool("v", false, "Show version")
	flag.Parse()

	if *showVersion {
		fmt.Println(version)
		return
	}

	args := flag.Args()
	if len(args) < 1 {
		fmt.Println("Please specify the command to run")
		os.Exit(1)
	}

	err := loadAndSetEnv(*envFile)
	if err != nil {
		fmt.Printf("Error setting environment variables: %s\n", err)
		os.Exit(1)
	}

	runCommand(args)
}

func loadAndSetEnv(filepath string) error {
	file, err := os.Open(filepath)
	if err != nil {
		return err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		if key, value, ok := parseLine(line); ok {
			if needsEval(value) {
				value, err = evalValue(value)
				if err != nil {
					return err
				}
			}
			os.Setenv(key, value)
		}
	}

	return scanner.Err()
}

// parseLine parses a line of the .env file
func parseLine(line string) (key, value string, ok bool) {
	parts := strings.SplitN(line, "=", 2)
	if len(parts) != 2 {
		return "", "", false
	}
	return strings.TrimSpace(parts[0]), strings.TrimSpace(parts[1]), true
}

// needsEval checks if a value needs to be evaluated
func needsEval(value string) bool {
	return strings.HasPrefix(value, "`") || strings.HasPrefix(value, "$(")
}

// evalValue evaluates a value with bash command
func evalValue(value string) (string, error) {
	cmd := exec.Command("bash", "-c", "echo "+value)
	output, err := cmd.Output()
	return strings.TrimSpace(string(output)), err
}

func runCommand(commandArgs []string) {
	cmd := exec.Command(commandArgs[0], commandArgs[1:]...)
	cmd.Env = os.Environ()

	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err := cmd.Run()
	if err != nil {
		fmt.Printf("Error running command: %s\n", err)
		os.Exit(1)
	}
}
