#!/bin/bash
./one-to-many.py -r resolvers.txt --nonce -q fpdns.auth -p qlabels --save client.json --offset 0000000
./json2csv.sh client.json > client.csv

