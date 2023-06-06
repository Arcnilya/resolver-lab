FROM ubuntu
ARG VERSION=latest
ARG QMIN=relaxed
WORKDIR /root
RUN apt update && apt upgrade -y
RUN apt install -y build-essential libssl-dev libexpat1-dev bison flex wget 
#RUN apt install -y net-tools iproute2 iputils-ping
RUN wget https://nlnetlabs.nl/downloads/unbound/unbound-${VERSION}.tar.gz
RUN tar xzf unbound-${VERSION}.tar.gz
WORKDIR /root/unbound-${VERSION}
RUN ./configure
RUN make
RUN make install
RUN useradd unbound
COPY ${QMIN}.conf unbound.conf
CMD unbound -d -v -c unbound.conf
