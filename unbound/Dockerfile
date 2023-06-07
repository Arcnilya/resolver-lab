FROM ubuntu
ARG VERSION=latest
WORKDIR /root
RUN apt update && apt upgrade -y
RUN apt install -y build-essential libssl-dev libexpat1-dev bison flex wget 
RUN wget https://nlnetlabs.nl/downloads/unbound/unbound-${VERSION}.tar.gz
RUN tar -xzf unbound-${VERSION}.tar.gz
WORKDIR /root/unbound-${VERSION}
RUN ./configure
RUN make
RUN make install
RUN useradd unbound
ARG QMIN=relaxed
COPY ${QMIN}.conf unbound.conf
CMD unbound -d -v -c unbound.conf
