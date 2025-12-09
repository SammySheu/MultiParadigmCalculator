# Multi-Paradigm Problem Solving: Statistics Calculator

## Overview

This project implements a statistics calculator that computes **mean**, **median**, and **mode** for a list of integers. The solution is implemented in three different programming languages, each demonstrating a distinct programming paradigm:

| Language | Paradigm | Key Concepts |
|----------|----------|--------------|
| **C** | Procedural | Functions, arrays, manual memory management |
| **OCaml** | Functional | Immutable data, higher-order functions, recursion |
| **Python** | Object-Oriented | Classes, encapsulation, inheritance |

## Project Structure

```
MultiParadigmProblemSolving/
├── README.md                      # This file
├── C/
│   └── statistics.c               # Procedural C implementation
├── OCaml/
│   └── statistics.ml              # Functional OCaml implementation
└── Python/
    └── statistics_calculator.py   # Object-oriented Python implementation
```

## Statistical Calculations

All three implementations compute the following statistics:

- **Mean**: The arithmetic average of all integers in the list
  - Formula: `sum(values) / count(values)`
  
- **Median**: The middle value when the list is sorted
  - For odd-length lists: the middle element
  - For even-length lists: the average of the two middle elements
  
- **Mode**: The most frequently occurring integer(s)
  - Supports multimodal data (multiple modes with the same frequency)

---

## Dependencies and Requirements

### C Implementation
- **Compiler**: GCC (GNU Compiler Collection) or Clang
- **Standard Library**: Standard C library (stdlib.h, stdio.h, string.h)
- **Version**: C99 or later

**Installation (macOS):**
```bash
# GCC/Clang is included with Xcode Command Line Tools
xcode-select --install
```

**Installation (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install build-essential
```

### OCaml Implementation
- **Compiler**: OCaml compiler (ocamlc or ocamlopt)
- **Version**: OCaml 4.08 or later recommended
- **No external dependencies** - uses only standard library

**Installation (macOS):**
```bash
brew install ocaml
```

**Installation (Ubuntu/Debian):**
```bash
sudo apt-get install ocaml
```

### Python Implementation
- **Interpreter**: Python 3.7 or later
- **No external dependencies** - uses only standard library modules:
  - `typing` (type hints)
  - `collections` (Counter class)
  - `dataclasses` (data class decorator)

**Installation:**
Python 3 is typically pre-installed on macOS and most Linux distributions.
```bash
# Check your Python version
python3 --version
```

---

## How to Run

### C Implementation (Procedural)

```bash
# Navigate to the C directory
cd C/

# Compile the program
gcc -o statistics statistics.c -Wall -Wextra

# Run the compiled executable
./statistics
```

### OCaml Implementation (Functional)

```bash
# Navigate to the OCaml directory
cd OCaml/

# Compile and run (bytecode)
ocamlc -o statistics statistics.ml
./statistics

# OR run directly without compilation
ocaml statistics.ml
```

### Python Implementation (Object-Oriented)

```bash
# Navigate to the Python directory
cd Python/

# Run the program
python3 statistics.py
```
