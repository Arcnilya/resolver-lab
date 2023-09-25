#!/bin/bash
./one-to-many.py -r resolvers.txt --nonce -q fpdns.auth -p qlabels --save logs/fpdns.json --offset 0000000
echo "Converting json to csv..."
./json2csv.sh logs/fpdns.json > logs/fpdns.csv
cat logs/fpdns.csv

