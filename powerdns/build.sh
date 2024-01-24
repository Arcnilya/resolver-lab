#!/bin/bash
if [ $# -eq 0 ]; then
    echo "Missing version argument"
else
    docker build -t resolver-lab/powerdns-$1 --build-arg VERSION=$1 .
fi
