FROM ubuntu
ARG VERSION=1.17.1
WORKDIR /root
RUN apt update && apt upgrade -y
RUN apt install -y build-essential libssl-dev libexpat1-dev bison wget flex
RUN wget https://nlnetlabs.nl/downloads/unbound/unbound-${VERSION}.tar.gz
RUN tar -xzf unbound-${VERSION}.tar.gz
WORKDIR /root/unbound-${VERSION}
RUN ./configure && make && make install
RUN useradd unbound
ARG CONF=default
COPY ${CONF}.conf unbound.conf
CMD unbound -d -v -c unbound.conf
