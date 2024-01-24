FROM ubuntu
ARG VERSION=1.8.0
ENV CONFIG=default
WORKDIR /root
RUN apt update && apt upgrade -y && apt install -y \
    build-essential \
    libexpat1-dev \
    bison \
    flex \
    && rm -rf /var/lib/apt/lists/*
# Install OpenSSL 1.1.1
ADD https://www.openssl.org/source/old/1.1.1/openssl-1.1.1.tar.gz ./
RUN tar -xzf openssl-1.1.1.tar.gz
WORKDIR /root/openssl-1.1.1
RUN ./config && make && make install
WORKDIR /root
# Install Unbound <1.12
ADD https://nlnetlabs.nl/downloads/unbound/unbound-${VERSION}.tar.gz ./
RUN tar -xzf unbound-${VERSION}.tar.gz
WORKDIR /root/unbound-${VERSION}
RUN ./configure && make && make install
RUN useradd unbound
COPY configs configs
COPY bootup.sh bootup.sh
CMD ./bootup.sh
