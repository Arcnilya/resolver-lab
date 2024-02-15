#!/bin/bash

resolvers=(
    unbound.resolver  # 10.0.53.1
    bind.resolver     # 10.0.53.2
    knot.resolver     # 10.0.53.3
    powerdns.resolver # 10.0.53.4
)

polar=(
    "always.polar.lab A"
    "always.ttl69.polar.lab A"
    "always.newid.polar.lab A"
    "manytxt.2.30.polar.lab TXT"
    "loop.polar.lab A"
    "afuzz2.200.polar.lab A"
    "customtype.2.polar.lab NS"
    "customtype.2.polar.lab A"
    "customtype.1.polar.lab NS"
)

# https://coredns.io/plugins/chaos/
chaos=(
    "CHAOS version.bind TXT"
    "CHAOS authors.bind TXT"
    "CHAOS hostname.bind TXT"
    "CHAOS version.server TXT"
    "CHAOS id.server TXT"
)

for query in "${chaos[@]}"; do
    for resolver in "${resolvers[@]}"; do
        #dig @$resolver $query | grep "status\|polar"; echo ""
        dig @$resolver $query | grep "status\|TXT"; echo ""
    done
done
