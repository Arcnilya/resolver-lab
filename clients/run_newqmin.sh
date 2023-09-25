#!/bin/bash
./one-to-many.py -r resolvers.txt --nonce -q newqmin.auth -p a.b --save newqmin.json --offset 0000000 --rr TXT
echo "Converting json to csv..."
./json2csv.sh newqmin.json > newqmin.csv
cat newqmin.csv

