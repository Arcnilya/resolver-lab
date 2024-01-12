#!/bin/bash
if [ $# -eq 0 ]; then
    echo "Missing version argument"
else
    docker build -t powerdns-$1:resolver-lab --build-arg VERSION=$1 .
fi
