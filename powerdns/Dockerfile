FROM ubuntu
ARG VERSION=4.8.4
ENV CONFIG=default
WORKDIR /root
RUN apt update && apt upgrade -y
RUN apt-get install -y libboost-filesystem-dev libboost-serialization-dev \
   libboost-system-dev libboost-thread-dev libboost-context-dev \
   libboost-test-dev libssl-dev libboost-test-dev g++ make pkg-config \
   libluajit-5.1-dev libboost-dev wget
RUN wget https://downloads.powerdns.com/releases/pdns-recursor-${VERSION}.tar.bz2
RUN tar -xf pdns-recursor-${VERSION}.tar.bz2
WORKDIR /root/pdns-recursor-${VERSION}
RUN ./configure && make -k -d && make install
RUN mkdir /var/run/pdns-recursor
COPY configs configs
COPY disable-dnssec.lua disable-dnssec.lua
COPY bootup.sh bootup.sh
CMD ./bootup.sh
