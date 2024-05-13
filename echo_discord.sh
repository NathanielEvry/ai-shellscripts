#!/bin/bash

# echo_discord.sh v1.0.2
# Created by Nathaniel Evry for https://github.com/NathanielEvry/ai-shellscripts
# A simple script to send messages to a Discord channel via a webhook.
# Usage:
#   Basic: ./echo_discord 'this is just a test'
#   With variables: some_text=$(find .); ./echo_discord "advanced $some_text"
#   With pipes: cat 'anyfile.txt' | ./echo_discord

# Dependencies: jq, curl
if ! command -v jq &> /dev/null || ! command -v curl &> /dev/null; then
    echo "Error: jq and curl are required for this script to run."
    exit 1
fi

# Read from pipe if present, otherwise from command argument
if [ -p /dev/stdin ]; then
    read -d '' -r msgText
else
    msgText="${1:-"Default text"}"
fi

# Default webhook URL (replace with your own)
webhook_url="${2:-'https://discord.com/api/webhooks/123123/123123'}"

# Prepare the JSON payload
body=$(jq -nc --arg content "$msgText" '{"content": $content}')

# Send the message using curl
response=$(curl -H 'Content-type: application/json' --data "$body" --url "$webhook_url" -s -o /dev/null -w "%{http_code}")

# Check response status
if [ "$response" -eq 204 ]; then
    echo "Message sent successfully."
else
    echo "Failed to send message: HTTP status $response."
fi
