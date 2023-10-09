#!/usr/bin/env python3

import os
import sys
import json
import datetime
import subprocess
from multiprocessing import Pool
import argparse


def parse_dns(result, query):
    d = dict.fromkeys(['status','flags','edns','answer'])
    d['edns'] = ""
    d['answer'] = ""
    for line in result.splitlines():
        if ">>HEADER<<" in line:
            d['status'] = line.split()[5][:-1]
        if line.startswith(";; flags:"):
            d['flags'] = line.split(';')[2].replace(" flags: ", "")
        if line.startswith("; EDNS:"):
            d['edns'] = line.replace("; EDNS:", "").replace(",",";")
        if line.startswith(query) and "IN" in line:
            d['answer'] = " ".join(line.split()[3:])
    return d


def read_file(fname):
    with open(fname, "r") as fp:
        return fp.read().splitlines()


def resolve(query, resolver, rr):
    try:
        dig_result = subprocess.check_output(['dig', f'@{resolver}', query, rr, '+tries=1']).decode('UTF-8')
        return parse_dns(dig_result, query)
    except subprocess.CalledProcessError as e:
        return {'status':"TIMEOUT",'flags':"",'edns':"",'answer':""}


def build_fqdn(index, args):
    if args.nonce:
        nonce = f"{str(index+args.offset).zfill(8)}-nonce"
        qname = f"{nonce}.{args.qname}"
    else:
        nonce = ""
        qname = args.qname

    if args.prefix:
        if args.prefix == "qlabels":
            qlabels = ".".join(reversed(["l"+str(l) for l in range(4,25)]))
            qname = f"{qlabels}.{qname}"
        else:
            qname = f"{args.prefix}.{qname}"
    return qname, nonce



def probe(index, resolver, args):
    FQDN, nonce = build_fqdn(index, args)
    if args.prefix == "qlabels": 
        print(f"Querying: l24-l4.{FQDN[77:]}@{resolver}")
    else:
        print(f"Querying: {FQDN}@{resolver}")
    d = resolve(FQDN, resolver, args.rr)
    d['resolver'] = resolver
    d['nonce'] = nonce
    d['time'] = datetime.datetime.now().strftime("%H:%M:%S.%f")
    # status,flags,edns,answer,resolver,nonce,time
    return d

parser = argparse.ArgumentParser(description='Client for sending 1 DNS query to multiple resolvers')
parser.add_argument('--resolvers', '-r', required=True, help='File with IPv4 addresses to DNS resolvers.')
parser.add_argument('--threads', '-t', type=int, default=10, help='Number of threads to use (default 10).')
parser.add_argument('--qname', '-q', required=True, help='Domain name to query. (ex. fpdns.se)')
parser.add_argument('--nonce', '-n', action='store_true', help='Wether to use a nonce')
parser.add_argument('--prefix', '-p', help='Subdomain to query (ex. www)')
parser.add_argument('--rr', default='A', help='Resource record to request (default A)')
parser.add_argument('--save', '-s', help='File name to save data to (default None, prints to stdout)')
parser.add_argument('--offset', '-o', type=int, default=0, help='Offset to use in the nonce')

args = parser.parse_args()

if not os.path.exists(args.resolvers):
    exit(f"File {args.resolvers} not found")
resolvers = read_file(args.resolvers)

if args.threads < 1:
    exit(f"Number of threads ({args.threads}) are too few")
p = Pool(args.threads)

results = p.starmap(probe, [(i,r,args) for i,r in enumerate(resolvers)])

if args.save:
    print(f"Saving results to '{args.save}'")
    with open(args.save, "w") as fp:
        json.dump(results, fp)
else:
    print(json.dumps(results, indent=4))
