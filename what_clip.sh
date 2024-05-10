#!/bin/bash

# Usage: ./what_clip.sh max_tokens webhook_url
# Grabs the content of your clipboard, wraps it and asks AI "hey, what's this?" Results are sent to Discord.

max_tokens="$1"


clipboard_content=$(wl-paste --primary)
nowstring=$(date +"%Y-%m-%d %H:%M:%S")  # Assuming you want the current timestamp in a civilized format

# Construct the prompt for the AI model
prompt="hi there! I'm going to ask you about some text on my clipboard that "
prompt+="I'm highlighting! Here's some contexts for you ::$nowstring::"
prompt+="About this upcoming clipboard data, the sources will be incredibly "
prompt+="varied. I don't usually have an 'expectation' of outcome. "
prompt+="Most of the time, I just need a vibe check"
prompt+="Your response will be sent via webhook directly to me in Discord"
prompt+=", so you can keep that in mind for formatting! ::$clipboard_content::"

response=$(ai.sh -m "$max_tokens" "$prompt")

# Check if the response is shorter than the chunk size
if [[ $length -le $chunk_size ]]; then
    echo_discord "$response"
    echo "Exiting, message sent."
else
    num_pages=$((length / chunk_size + (length % chunk_size > 0 ? 1 : 0)))
    for ((i=0; i<num_pages; i++)); do
        echo "Working on page $i of $num_pages..."
        start=$((i * chunk_size))
        end=$((start + chunk_size))
        page_content="${response:start:chunk_size}"
        page_number=$((i + 1))

        # Append the page number to the chunk
        page_content+=" (page $page_number of $num_pages)"

        # Send the modified page content
        echo_discord "$page_content"
    done
fi
