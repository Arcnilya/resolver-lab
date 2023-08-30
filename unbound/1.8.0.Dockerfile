FROM ubuntu
ARG VERSION=1.8.0
WORKDIR /root
RUN apt update && apt upgrade -y
RUN apt install -y build-essential libexpat1-dev bison flex wget 
# Install OpenSSL 1.1.1
RUN wget https://www.openssl.org/source/old/1.1.1/openssl-1.1.1.tar.gz
RUN tar -xzf openssl-1.1.1.tar.gz
WORKDIR /root/openssl-1.1.1
RUN ./config && make && make install
WORKDIR /root
# Install Unbound <1.12
RUN wget https://nlnetlabs.nl/downloads/unbound/unbound-${VERSION}.tar.gz
RUN tar -xzf unbound-${VERSION}.tar.gz
WORKDIR /root/unbound-${VERSION}
RUN ./configure
RUN make
RUN make install
RUN useradd unbound
ARG CONF=default
COPY ${CONF}.conf unbound.conf
COPY root.hints /var/lib/unbound/root.hints
CMD unbound -d -v -c unbound.conf
