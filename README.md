# os-history-diff

A Bash script for students to compare their command history against their teachers'. This tool helps identify commands used by teachers but not by the student, facilitating learning and exploration of new command-line tools and techniques.

## Features

- Compares student's command history with teachers' history files
- Provides a list of commands used by teachers but not by the student
- Optional full history diff to show complete command usage

## Setup

### 1. Bash History Configuration

To ensure a comprehensive history, add the following lines to your `.bashrc` file:

```bash
HISTSIZE=-1
HISTFILESIZE=-1
```

This configuration allows for unlimited history size.

### 2. Script Installation

1. Clone this repository or download the `history-diff.sh` script.
2. Make the script executable:
   ```
   chmod +x history-diff.sh
   ```

## Usage

The script must be sourced to work correctly. There are two ways to run it:

1. For command diff only:
   ```
   source history-diff.sh
   ```
   or
   ```
   . history-diff.sh
   ```

2. For full history diff:
   ```
   source history-diff.sh full
   ```
   or
   ```
   . history-diff.sh full
   ```

## Output

The script provides two types of output:

1. **Command Diff**: A list of commands used by teachers but not by you.
2. **Full History Diff** (optional): Complete commands used by teachers but not by you, including arguments and options.

## How It Works

1. The script reads teacher history files from `/public/ucebnove/historia/`.
2. It then compares this history with your personal Bash history.
3. The diff is calculated and displayed, showing commands or full history entries that appear in the teachers' history but not in yours.
