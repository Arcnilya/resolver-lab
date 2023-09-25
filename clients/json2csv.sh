#!/bin/bash
# sudo apt-get install jq -y
jq -r '.[] | [.time, .status, .nonce, .resolver, .flags, .answer] | @csv' $1 | tr -d '"'
