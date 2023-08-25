#!/bin/bash

# number of egress resolvers
sort $1 | cut -d ',' -f1 | uniq -c | sort -nr # | head -n 20

sort $1 | cut -d ',' -f5 | sort | uniq -c | sort -nr # | head -n 20
