#!/bin/bash
# display_project_structure.sh v2.0.0
# Created by Nathaniel Evry for https://github.com/NathanielEvry/ai-shellscripts
# Displays the directory structure and file contents for a given project path
# Skips by default: dotfiles, .git dirs, gitignored files, and binary files
# Usage: display_project_structure.sh [--include-binaries] [--exclude=PATTERN[,PATTERN...]] PATH [PATH...]

set -euo pipefail

# --- Defaults ---
include_binaries=0
exclude_patterns=()
paths=()

# --- Parse args ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        --include-binaries)
            include_binaries=1
            shift
            ;;
        --exclude=*)
            IFS=',' read -ra pats <<< "${1#*=}"
            exclude_patterns+=("${pats[@]}")
            shift
            ;;
        --exclude)
            IFS=',' read -ra pats <<< "$2"
            exclude_patterns+=("${pats[@]}")
            shift 2
            ;;
        -h|--help)
            echo "Usage: $(basename "$0") [OPTIONS] PATH [PATH...]"
            echo ""
            echo "Options:"
            echo "  --include-binaries      Include binary files in output"
            echo "  --exclude=PATTERN       Comma-separated list of filename patterns to skip"
            echo "  -h, --help              Show this help message"
            exit 0
            ;;
        -*)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
        *)
            paths+=("$1")
            shift
            ;;
    esac
done

if [[ ${#paths[@]} -eq 0 ]]; then
    echo "Error: No path provided." >&2
    echo "Usage: $(basename "$0") [OPTIONS] PATH [PATH...]" >&2
    exit 1
fi

# --- Helpers ---
is_binary() {
    local file="$1"
    file --mime-encoding "$file" 2>/dev/null | grep -q "binary"
}

should_skip_file() {
    local file="$1"
    local filename
    filename=$(basename "$file")

    # Skip .git directory contents
    [[ "$file" == */.git/* ]] && return 0

    # Skip dotfiles / hidden files
    [[ "$filename" == .* ]] && return 0

    # Check git ignored files (only if inside a git repo)
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        if git check-ignore -q "$file" 2>/dev/null; then
            return 0
        fi
    fi

    # Check user exclude patterns
    for pattern in "${exclude_patterns[@]}"; do
        [[ "$filename" == $pattern ]] && return 0
    done

    # Skip binary files by default
    if [[ "$include_binaries" -eq 0 ]] && is_binary "$file"; then
        return 0
    fi

    return 1
}

# --- Main ---
echo ":::::"

for argval in "${paths[@]}"; do
    if [[ ! -e "$argval" ]]; then
        echo "Error: $argval is not a valid file or directory" >&2
        continue
    fi

    if [[ -d "$argval" ]]; then
        # Directory processing
        echo "Directory Structure:"
        echo
        echo "\`\`\`"
        # Exclude hidden files from tree output
        tree -aI '.*' "$argval"
        echo "\`\`\`"
        echo

        # Process files
        while IFS= read -r -d '' file; do
            if ! should_skip_file "$file"; then
                echo "\`\`\`$file:"
                cat "$file"
                echo
                echo "\`\`\`"
                echo
            fi
        done < <(find "$argval" -type f -not -path '*/.*' -print0)

    elif [[ -f "$argval" ]]; then
        # Single file processing
        if ! should_skip_file "$argval"; then
            echo "\`\`\`$argval:"
            cat "$argval"
            echo
            echo "\`\`\`"
            echo
        fi
    fi
done

echo ":::::"
