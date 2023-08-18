#!/bin/bash
jq -r '.[] | [.status, .resolver, .nonce, .answer] | @csv' $1
