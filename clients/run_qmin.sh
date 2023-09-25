#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
fi
qmin="$1qmin"
./one-to-many.py -r resolvers.txt --nonce -q $qmin.auth -p a.b --save logs/$qmin.json --offset 0000000 --rr TXT
echo "Converting json to csv..."
./json2csv.sh logs/$qmin.json > logs/$qmin.csv
cat logs/$qmin.csv

