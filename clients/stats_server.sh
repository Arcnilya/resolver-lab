#!/bin/bash

# flags (from queries)
cut -d ',' -f4 $1 | sort | uniq -c | sort -nr
# flags (from resolvers)
cut -d ',' -f2,4 $1 | sort | uniq | cut -d ',' -f2 | sort | uniq -c | sort -nr



# subnet
sort $1 | cut -d ',' -f5 | sort | uniq -c | sort -nr

# edns: version
sort $1 | cut -d ',' -f7 | sort | uniq -c | sort -nr
# edns: flags 
sort $1 | cut -d ',' -f8 | sort | uniq -c | sort -nr
# edns: udp 
sort $1 | cut -d ',' -f9 | sort | uniq -c | sort -nr


