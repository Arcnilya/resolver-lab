FROM ubuntu
ARG VERSION=1.17.1
ENV CONFIG=default
WORKDIR /root
RUN apt update && apt upgrade -y && apt install -y \
    build-essential \
    libssl-dev \
    libexpat1-dev \
    bison \
    flex \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*
RUN update-ca-certificates
ADD https://nlnetlabs.nl/downloads/unbound/unbound-${VERSION}.tar.gz ./
RUN tar -xzf unbound-${VERSION}.tar.gz
WORKDIR /root/unbound-${VERSION}
RUN ./configure && make && make install
RUN useradd unbound
COPY configs configs
COPY bootup.sh bootup.sh
CMD ./bootup.sh
