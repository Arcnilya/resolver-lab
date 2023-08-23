#!/bin/bash

dig_func() {
    result=$(dig @$1.resolver $2 $3 +short | awk '{print $1}')
    if [ "$result" == "$4" ]; then
        echo -e "[SUCCESS]: $1 -> $2 $3 = $result"
    else
        echo -e "[FAIL]:    $1 -> $2 $3 = $result"
    fi
}

ping_func() {
    response=$(ping $1 -c 1 | grep "bytes from")
    if [ ! -z "$response" -a "$response" != " " ]; then
        echo "[UP]:   $1"
    else
        echo "[DOWN]: $1"
    fi
}

# ping
ping_func unbound.resolver
ping_func bind.resolver
ping_func knot.resolver
ping_func powerdns.resolver
ping_func fpdns.auth
ping_func oldqmintest.auth
ping_func newqmintest.auth

# dig
dname="kau.se"
dig_func "unbound"  $dname "A" "193.10.226.38"
dig_func "bind"     $dname "A" "193.10.226.38"
dig_func "knot"     $dname "A" "193.10.226.38"
dig_func "powerdns" $dname "A" "193.10.226.38"

prefix="l10.l9.l8.l7.l6.l5.l4"
dname="fpdns.auth"
dig_func "unbound"  "$prefix.1-unbound.$dname"  "A" "10.0.53.6"
dig_func "bind"     "$prefix.2-bind.$dname"     "A" "10.0.53.6"
dig_func "knot"     "$prefix.3-knot.$dname"     "A" "10.0.53.6"
dig_func "powerdns" "$prefix.4-powerdns.$dname" "A" "10.0.53.6"

dname="a.b.oldqmin.auth"
dig_func "unbound" $dname "TXT" '"HOORAY'
dig_func "bind" $dname "TXT" '"NO'
dig_func "knot" $dname "TXT" '"HOORAY'
dig_func "powerdns" $dname "TXT" '"HOORAY'

dname="a.b.newqmin.auth"
dig_func "unbound" $dname "TXT" '"HOORAY'
dig_func "bind" $dname "TXT" '"HOORAY'
dig_func "knot" $dname "TXT" '"HOORAY'
dig_func "powerdns" $dname "TXT" '"HOORAY'
