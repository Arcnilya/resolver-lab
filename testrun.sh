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

prefix="l20.l19.l18.l17.l16.l15.l14.l13.l12.l11.l10.l9.l8.l7.l6.l5.l4"
dname="fpdns.auth"
dig_func "unbound" "$prefix.1-unbound.$dname" "A"
dig_func "bind" "$prefix.2-bind.$dname" "A"
dig_func "knot" "$prefix.3-knot.$dname" "A"
dig_func "powerdns" "$prefix.4-powerdns.$dname" "A"

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
