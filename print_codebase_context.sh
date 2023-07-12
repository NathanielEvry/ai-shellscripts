#!/bin/bash

# Prints the directory structure and contents of all files recursively
# in the provided path. Useful for providing overall project context and
# code snippets to AI assistants in a single request.
# - Directory structure with hidden files shown
# - Contents of each file, labeled by filename
# - Formatted as code blocks to avoid need for escaping quotes

CODEPATH="$1"

# Print directory structure
echo "Directory Structure ($CODEPATH):"
echo
echo "\`\`\`"
# Print tree output with hidden files shown
tree -a "$CODEPATH"
echo "\`\`\`"

echo

# Loop through all files recursively
for file in $(find "$CODEPATH" -type f -not -path '*.git*'); do

    # Print filename
    echo "File Contents of $file:"
    echo "\`\`\`"

    # Print file contents
    # Use heredoc to avoid escaping quotes
    cat <<EOF
$(cat "$file")
EOF

    echo
    echo "\`\`\`"
    echo

done

# print_codebase_context ~/myproject
