#!/bin/bash
if [ $# -eq 0 ]; then
    echo "Missing version argument"
elif [ "$1" == "9.14.0" ]; then 
    docker build -t bind-$1:resolver-lab --build-arg VERSION=$1 --build-arg EXT=gz .
else
    docker build -t bind-$1:resolver-lab --build-arg VERSION=$1 .
fi
