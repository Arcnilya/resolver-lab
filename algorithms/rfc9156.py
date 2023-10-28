#!/usr/bin/env python3

import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--qlen','-q', type=int, default=24,
        help="Query length total")
parser.add_argument('--cache','-c', type=int, default=0,
        help="Query length in cache")
parser.add_argument('--max', type=int, default=10,
        help="MAX_MINIMISE_COUNT")
parser.add_argument('--min', type=int, default=4,
        help="MINIMISE_ONE_LAB")
parser.add_argument('--ns', action="store_true",
        help="Use NS RR")
args = parser.parse_args()

if args.min > args.max:
    exit("--min cannot be bigger than --max")
if args.cache >= args.qlen:
    exit("--cache must be smaller than --qlen")

labels = ["l"+str(l) for l in range(3,args.qlen+1)][::-1] + ["fpdns", "se"]

wip = []
for _ in range(args.cache):
    wip.append(labels.pop())

# distribution of labels after singles
dist = [0] * (args.max - args.min)
for l in range(args.qlen - (args.min + args.cache)):
    dist[l%len(dist)] += 1 
dist = dist[::-1]

signature = []
for i in range(min(args.max, args.qlen)):
    if i < args.min or args.qlen < args.max:
        wip.append(labels.pop())
    else:
        for _ in range(dist[i-args.min]):
            wip.append(labels.pop())

    rr = "NS" if args.ns and labels else "A"
    signature.append(str(len(wip))+rr)
    print("Sending query: "+".".join(wip[::-1]))

print("Final signature: "+"-".join(signature))
