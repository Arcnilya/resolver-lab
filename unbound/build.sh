#!/bin/bash
if [ $# -eq 0 ]; then
    echo "Missing version argument"
elif [ "$1" == "1.8.0" ]; then 
    docker build -t resolver-lab/unbound-$1 --build-arg VERSION=$1 -f 1.8.0.Dockerfile .
else
    docker build -t resolver-lab/unbound-$1 --build-arg VERSION=$1 .
fi
