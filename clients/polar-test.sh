#!/bin/bash

resolvers=(
    unbound.resolver  # 10.0.53.1
    bind.resolver     # 10.0.53.2
    knot.resolver     # 10.0.53.3
    powerdns.resolver # 10.0.53.4
)

done=(
    "always.ttl69.polar.lab A"
    "always.newid.polar.lab A"
    "manytxt.2.30.polar.lab TXT"
    "loop.polar.lab A"
    "afuzz2.200.polar.lab A"
    "customtype.2.polar.lab NS"
    "customtype.2.polar.lab A"
    "customtype.1.polar.lab NS"
)

queries=(
    "always.polar.lab A"
)

for query in "${queries[@]}"; do
    for resolver in "${resolvers[@]}"; do
        dig @$resolver $query | grep "status\|polar"; echo ""
    done
done
