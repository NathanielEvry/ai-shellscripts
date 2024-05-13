#!/usr/bin/env bash

# ai-dad-joke-rater.sh v1.0.0
# Created by Nathaniel Evry for https://github.com/NathanielEvry/ai-shellscripts
# simplistic example of AI calling AI with forced-subshells.

# IDK what could YOU do with sub-shell ai??  - x.com/NathanielEvry
prompt_1='Please write me a list of your 3 worst one-line dad jokes!'
prompt_2='Hey, could you rate this terrible dad joke for me? '
prompt_2+='Please respond with a single sentence and a 1-5 ranking 😊 : '

ai "$prompt_1" | while read -r line;do # Prompt ai, run a loop for-each line
	echo "cur: $line" # For humans!
	ai "$prompt_2  $line" # Initiate a new prompt for each line from ai #1
done
