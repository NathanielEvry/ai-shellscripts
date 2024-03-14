#!/bin/bash

# Prints the directory structure and contents of all files recursively
# in the provided path. Useful for providing overall project context and
# code snippets to AI assistants in a single request.
# - Directory structure with hidden files shown
# - Contents of each file, labeled by filename
# - Formatted as code blocks to avoid need for escaping quotes
# Handy, mostly perfect function for quickly allowing a text paste-dump to a llm. 
# TODO - Desperately needs to respect .gitignore

_cat-for-ai() {
    # Loop over all arguments
    for argval in "$@"; do
        # Check if the argval is a directory
        if [ -d "$argval" ]; then
            # print the structure of directories
            echo "Directory Structure:"
            echo
            echo "\`\`\`"
            tree -a "$argval"
            echo "\`\`\`"
            echo

            # cats all the local files, names them, and quotes them using proper-ish syntax
            for file in $(find "$argval" -type f -not -path '*.git*'); do
                echo "\`\`\`$file:"
                cat "$file"
                echo
                echo "\`\`\`"
                echo
            done
        # Check if the path is a file
        elif [ -f "$argval" ]; then
			echo
            echo "\`\`\`$argval:"
            cat "$argval"
            echo
            echo "\`\`\`"
            echo
        else
            echo "$argval is not a valid file or directory"
        fi
    done
}

# print_codebase_context ~/myproject
