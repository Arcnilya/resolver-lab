#!/bin/bash
if [ $# -eq 0 ]; then
    echo "Missing version argument"
elif [ "$1" == "3.0.0" ]; then 
    docker build -t knot-$1:resolver-lab --build-arg VERSION=$1 -f 3.0.0.Dockerfile .
else
    docker build -t knot-$1:resolver-lab --build-arg VERSION=$1 .
fi
