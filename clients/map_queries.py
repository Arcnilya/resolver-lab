#!/usr/bin/env python3

import os
import argparse


def read_file(fname):
    with open(fname, "r") as fp:
        return fp.read().splitlines()


parser = argparse.ArgumentParser(description="Mapping client and server queries based on nonce. It uses the output of one-to-many.py -> json2csv.sh and ddnsserver.py")
parser.add_argument('--client', '-c', required=True, help="Client query csv file")
parser.add_argument('--server', '-s', required=True, help="Server query csv file")

args = parser.parse_args()

if not os.path.exists(args.client):
    exit(f"File {args.client} not found")
if not os.path.exists(args.server):
    exit(f"File {args.server} not found")

client_queries = read_file(args.client)
server_queries = read_file(args.server)

# Process server queries
d = {}
for s_query in server_queries:
    if s_query:
        q = s_query.split(',')
        if q[0] not in d:           # new nonce
            d[q[0]] = {}
        if q[1] not in d[q[0]]:     # new resolver
            d[q[0]][q[1]] = q[2]
        else:                       # both exists
            d[q[0]][q[1]] += "-"+q[2]


for nonce in d:
    for resolver in d[nonce]:
        for c_query in client_queries:
            if nonce in c_query:
                c = c_query.replace('"','').split(',')
                print(nonce, c[1], "->",
                        resolver, d[nonce][resolver])





