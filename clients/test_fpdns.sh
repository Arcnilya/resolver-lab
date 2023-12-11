#!/bin/bash
labels="l24.l23.l22.l21.l20.l19.l18.l17.l16.l15.l14.l13.l12.l11.l10.l9.l8.l7.l6.l5.l4"
#./one-to-many.py -r resolvers.txt -q auth --save logs/fpdns.json
./one-to-many.py -r resolvers.txt --nonce "no-cache" -q fpdns.auth -p $labels --save logs/fpdns.json --offset 0000000
./one-to-many.py -r resolvers.txt --nonce "cache" -q fpdns.auth -p $labels --save logs/fpdns.json --offset 0000000
#./one-to-many.py -r resolvers.txt --nonce "unbound" -q fpdns.se -p $labels --save logs/fpdns.json --offset 0000000
echo "Converting json to csv..."
./json2csv.sh logs/fpdns.json > logs/fpdns.csv
cat logs/fpdns.csv

