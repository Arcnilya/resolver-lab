FROM ubuntu
ARG VERSION=4.8.4
ENV CONFIG=default
WORKDIR /root
RUN apt update && apt upgrade -y && apt-get install -y \
    libboost-filesystem-dev \
    libboost-serialization-dev \
    libboost-system-dev \
    libboost-thread-dev \
    libboost-context-dev \
    libboost-test-dev \
    libssl-dev \
    libboost-test-dev \
    g++ \
    make \
    pkg-config \
    libluajit-5.1-dev \
    libboost-dev \
    cargo \
    && rm -rf /var/lib/apt/lists/*
ADD https://downloads.powerdns.com/releases/pdns-recursor-${VERSION}.tar.bz2 ./
RUN tar -xf pdns-recursor-${VERSION}.tar.bz2
WORKDIR /root/pdns-recursor-${VERSION}
RUN ./configure && make -k -d && make install
RUN mkdir /var/run/pdns-recursor
COPY disable-dnssec.lua disable-dnssec.lua
COPY configs configs
COPY bootup.sh bootup.sh
CMD ./bootup.sh
