#!/bin/bash
# echo_discord.sh
# A dead-simple "take the message, and put it on discord" webhook wrapper. 

msgText="${1:-"Default text"}"
webhook_url="${2:-'https://discord.com/api/webhooks/123123/123123'}"  # Default webhook URL if not provided (go get your own!)
body=$(jq -nc --arg content "$msgText" '{"content": $content}')
curl -H 'Content-type: application/json' --data "$body" --url "$webhook_url"
