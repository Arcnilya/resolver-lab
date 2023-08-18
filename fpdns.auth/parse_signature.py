#!/usr/bin/env python3

import sys
import os
import json

def read_file(fname):
    with open(fname, "r") as fp:
        return fp.read().splitlines()


if len(sys.argv) < 2:
    exit("Missing input parameter")
if not os.path.exists(sys.argv[1]):
    exit("File does not exits")

queries = read_file(sys.argv[1])
d = {}
for query in queries:
    if query:
        q = query.split(',')
        if q[0] not in d:           # new nonce
            d[q[0]] = {}
        if q[1] not in d[q[0]]:     # new resolver
            d[q[0]][q[1]] = q[2]
        else:                       # both exist
            d[q[0]][q[1]] += "-"+q[2]

print(json.dumps(d, indent=4))

