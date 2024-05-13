#!/bin/bash
# display_project_structure.sh v1.0.1
# Created by Nathaniel Evry for https://github.com/NathanielEvry/ai-shellscripts
# Displays the directory structure and file contents for a given project path
# NEW: excluding dotfiles
# Usage: display_project_structure.sh ~/myproject

CODEPATH="$1"

# Print directory structure
echo "Directory Structure of $CODEPATH:"
echo "\`\`\`"
# Print tree output excluding hidden files
tree -aI '.*|*/.*' "$CODEPATH"
echo "\`\`\`"
echo

# Loop through all files, excluding dotfiles
find "$CODEPATH" \
    -type f \
    -not \
    -path '*/.*' \
    -exec sh \
    -c 'echo "File Contents of $1:"; echo "\`\`\`"; cat "$1"; echo "\`\`\`"; echo' _ {} \;


