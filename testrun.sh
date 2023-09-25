#!/bin/bash

dig_func() {
    result=$(dig @$1.resolver $2 $3 +short | awk '{print $1}')
    echo -e "$1 -> $2 $3 = $result"
}

ping_func() {
    response=$(ping $1 -c 1 | grep "bytes from")
    if [ ! -z "$response" -a "$response" != " " ]; then
        echo "$1 is up"
    else
        echo "$1 is down"
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
dig_func "unbound"  $dname "A"
dig_func "bind"     $dname "A"
dig_func "knot"     $dname "A"
dig_func "powerdns" $dname "A"

prefix="l10.l9.l8.l7.l6.l5.l4"
dname="fpdns.auth"
dig_func "unbound"  "$prefix.unbound.$dname"
dig_func "bind"     "$prefix.bind.$dname"
dig_func "knot"     "$prefix.knot.$dname"
dig_func "powerdns" "$prefix.powerdns.$dname"

dname="oldqmin.auth"
dig_func "unbound" "a.unbound.$dname" "TXT"
dig_func "bind" "a.bind.$dname" "TXT"
dig_func "knot" "a.knot.$dname" "TXT"
dig_func "powerdns" "a.powerdns.$dname" "TXT"

dname="newqmin.auth"
dig_func "unbound" "a.unbound.$dname" "TXT"
dig_func "bind" "a.bind.$dname" "TXT"
dig_func "knot" "a.knot.$dname" "TXT"
dig_func "powerdns" "a.powerdns.$dname" "TXT"
