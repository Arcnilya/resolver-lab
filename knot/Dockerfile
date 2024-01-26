FROM ubuntu
ARG VERSION=5.6.0
ENV CONFIG=default
WORKDIR /root
RUN apt update && apt upgrade -y && apt install -y \
    build-essential \
    libssl-dev \
    meson \
    libuv1-dev \
    luajit \
    libluajit-5.1-dev \
    git \
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
RUN git clone https://gitlab.nic.cz/knot/knot-dns.git 
WORKDIR /root/knot-dns
RUN git checkout 3.3
RUN autoreconf -if
RUN ./configure && make && make install
RUN ldconfig
# Install knot resolver
WORKDIR /root
ADD https://secure.nic.cz/files/knot-resolver/knot-resolver-${VERSION}.tar.xz ./
RUN tar -xf knot-resolver-${VERSION}.tar.xz
WORKDIR /root/knot-resolver-${VERSION}
RUN meson setup build_dir --prefix=/usr/local --default-library=static
RUN ninja -C build_dir
RUN ninja install -C build_dir
COPY configs configs
COPY bootup.sh bootup.sh
CMD ./bootup.sh
