FROM ubuntu
ARG VERSION=1.17.1
WORKDIR /root
RUN apt update && apt upgrade -y
RUN apt install -y build-essential libssl-dev libexpat1-dev bison flex wget 
#RUN apt-get update && apt-get upgrade -y
#RUN apt-get install curl vim net-tools tmux dnsutils -y
RUN wget https://nlnetlabs.nl/downloads/unbound/unbound-${VERSION}.tar.gz
RUN tar -xzf unbound-${VERSION}.tar.gz
WORKDIR /root/unbound-${VERSION}
RUN ./configure && make && make install
RUN useradd unbound
ARG QMIN=relaxed
COPY ${QMIN}.conf unbound.conf
CMD unbound -d -v -c unbound.conf
