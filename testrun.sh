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
ping_func fpdns.lab
ping_func oldqmin.lab
ping_func newqmin.lab
ping_func polar.lab
echo ""
# dig
dname="kau.se"
dig_func "unbound"  $dname "A"
dig_func "bind"     $dname "A"
dig_func "knot"     $dname "A"
dig_func "powerdns" $dname "A"
echo ""
prefix="l24.l23.l22.l21.l20.l19.l18.l17.l16.l15.l14.l13.l12.l11.l10.l9.l8.l7.l6.l5.l4"
dname="fpdns.auth"
dig_func "unbound"  "$prefix.unbound.$dname" "A"
dig_func "bind"     "$prefix.bind.$dname" "A"
dig_func "knot"     "$prefix.knot.$dname" "A"
dig_func "powerdns" "$prefix.powerdns.$dname" "A"
echo ""
dname="oldqmin.lab"
dig_func "unbound" "a.unbound.$dname" "TXT"
dig_func "bind" "a.bind.$dname" "TXT"
dig_func "knot" "a.knot.$dname" "TXT"
dig_func "powerdns" "a.powerdns.$dname" "TXT"
echo ""
dname="newqmin.lab"
dig_func "unbound" "a.unbound.$dname" "TXT"
dig_func "bind" "a.bind.$dname" "TXT"
dig_func "knot" "a.knot.$dname" "TXT"
dig_func "powerdns" "a.powerdns.$dname" "TXT"
echo ""
dname="polar.lab"
dig_func "unbound" "alwaysunbound.$dname" "A"
dig_func "bind" "alwaysbind.$dname" "A"
dig_func "knot" "alwaysknot.$dname" "A"
dig_func "powerdns" "alwayspowerdns.$dname" "A"
