FROM ubuntu
ARG VERSION=3.0.0
ENV CONFIG=3.0.0
WORKDIR /root
RUN apt update && apt upgrade -y && apt-get install -y \
    pkg-config \
    libknot-dev \
    libuv1-dev \
    libcmocka-dev \
    libluajit-5.1-dev \
    git \
    bsdmainutils \
    g++ \
    && apt-get install -y \
    libtool \
    autoconf \
    automake \
    make \
    pkg-config \
    liburcu-dev \
    libgnutls28-dev \
    libedit-dev \
    liblmdb-dev \
    && rm -rf /var/lib/apt/lists/*
# Installl libknot
#RUN git clone https://gitlab.nic.cz/knot/knot-dns.git
ADD https://secure.nic.cz/files/knot-dns/knot-2.7.1.tar.xz ./
RUN tar -xf knot-2.7.1.tar.xz
WORKDIR /root/knot-2.7.1
RUN ./configure && make && make install
RUN ldconfig
# Install knot resolver
WORKDIR /root
ADD https://secure.nic.cz/files/knot-resolver/knot-resolver-${VERSION}.tar.xz ./
RUN tar -xf knot-resolver-${VERSION}.tar.xz
WORKDIR /root/knot-resolver-${VERSION}
RUN make info
RUN make LDFLAGS="-Wl,-rpath=/usr/local/lib" PREFIX="/usr/local"
RUN make install PREFIX="/usr/local"
COPY configs configs
COPY bootup.sh bootup.sh
CMD ./bootup.sh
