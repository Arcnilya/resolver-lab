#!/bin/bash

# rcodes
sort $1 | cut -d ',' -f1 | tr -d '"' | uniq -c | sort -nr

# only resolver IP addresses
#grep NOERROR $1 | cut -d ',' -f2 | tr -d '"'

# answers
grep NOERROR $1 | cut -d ',' -f4 | sort | uniq -c | sort -nr
