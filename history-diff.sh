#!/bin/bash

# Check if the script is being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This script must be sourced to work correctly."
    echo "Please run it using 'source history-diff.sh' or '. history-diff.sh'"
    exit 1
fi

# Function to show usage instructions
show_usage() {
    echo "Usage: source history-diff.sh [full]"
    echo "  full: Optional argument to show full history diff"
}

# Check for the 'full' argument
show_full=false
if [[ "$1" == "full" ]]; then
    show_full=true
elif [[ -n "$1" ]]; then
    show_usage
    return 1
fi

# Extract and process teacher's command history
teacher_history=$(cat /public/ucebnove/historia/*{grezo,vojtko}*.history | sed -n 's/^[[:space:]]*\([0-9].*\)/\1/p' | cut -d " " -f3- | sort | uniq )
teacher_cmds=$(cat /public/ucebnove/historia/*{grezo,vojtko}*.history | sed -n 's/^[[:space:]]*\([0-9].*\)/\1/p' | cut -d " " -f3- | sort | uniq | cut -d " " -f1 | uniq |  grep -Ev '(=|/|~|\.|-)' | grep -v '[$*]' | grep -v '^.$' | grep -v '\\' | sort)

# Extract and process user's command history
my_history=$(fc -l -1000000 | sed -n 's/^[[:space:]]*\([0-9].*\)/\1/p' | cut -d " " -f2- | sort | uniq)
my_cmds=$(fc -l -1000000 | sed -n 's/^[[:space:]]*\([0-9].*\)/\1/p' | cut -d " " -f2- | sort | uniq | cut -d " " -f1 | uniq |  grep -Ev '(=|/|~|\.|-)' | grep -v '[$*]' | grep -v '^.$' | grep -v '\\' | sort)

# Find commands used by teachers but not by the user
diff_cmds=$(comm -23 <(echo "$teacher_cmds" | sort) <(echo "$my_cmds" | sort))

# Display commands used by teachers but not by the user
echo "Commands used by teachers but not by you:"
echo "$diff_cmds" | while read -r cmd; do
man "$cmd" > isCommandInMan 2>/dev/null
type "$cmd" > isCommandInType 2>/dev/null
if grep -q "builtin" isCommandInType; then
        echo "$cmd"
elif [[ -s isCommandInMan ]]; then
	echo "$cmd"
fi
done

# If 'full' argument is provided, show full command history diff
if $show_full; then
    # Find full commands used by teachers but not by the user
    diff_history=$(comm -23 <(echo "$teacher_history" | sort) <(echo "$my_history" | sort))

    echo "Full Comimands used by teacher but not by you:"
    echo "$diff_history"

    # Extract and display unique commands from the full history diff
    echo "Commands used from full commands:"
    diff_history_cmds=$(echo "$diff_history" | cut -d " " -f1 | sort | uniq | paste -sd ", " -)
    echo "Commands used: $diff_history_cmds"
fi
