#!/bin/bash

dig_func() {
    echo -e "$1 -> $2 $3: \t$(dig @$1.resolver $2 $3 +short | awk '{print $1}')"
}

ping_func() {
    ping $1 -c 1 | grep "bytes"
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
dig_func "unbound" $dname "A"
dig_func "bind" $dname "A"
dig_func "knot" $dname "A"
dig_func "powerdns" $dname "A"

dname="a.b.fpdns.auth"
dig_func "unbound" $dname "A"
dig_func "bind" $dname "A"
dig_func "knot" $dname "A"
dig_func "powerdns" $dname "A"

dname="a.b.oldqmin.auth"
dig_func "unbound" $dname "TXT"
dig_func "bind" $dname "TXT"
dig_func "knot" $dname "TXT"
dig_func "powerdns" $dname "TXT"

dname="a.b.newqmin.auth"
dig_func "unbound" $dname "TXT"
dig_func "bind" $dname "TXT"
dig_func "knot" $dname "TXT"
dig_func "powerdns" $dname "TXT"
