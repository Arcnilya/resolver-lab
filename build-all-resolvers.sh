#!/bin/bash
./unbound/build.sh 1.8.0
./unbound/build.sh 1.17.1
./unbound/egress_build.sh
./bind/build.sh 9.18.15
./bind/build.sh 9.14.0
./knot/build.sh 5.6.0
./knot/build.sh 3.0.0
./powerdns/build.sh 4.8.4
./powerdns/build.sh 4.4.0

