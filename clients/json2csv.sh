#!/bin/bash
# sudo apt-get install jq -y
jq -r '.[] | [.status, .resolver, .nonce, .answer] | @csv' $1
