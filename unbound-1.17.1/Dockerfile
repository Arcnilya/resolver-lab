FROM ubuntu
WORKDIR /root
RUN apt update && apt upgrade -y
RUN apt install -y build-essential libssl-dev libexpat1-dev bison flex wget 
#RUN apt install -y net-tools iproute2 iputils-ping
RUN wget https://nlnetlabs.nl/downloads/unbound/unbound-latest.tar.gz
RUN tar xzf unbound-latest.tar.gz
WORKDIR /root/unbound-1.17.1
RUN ./configure
RUN make
RUN make install
RUN useradd unbound
COPY unbound.conf unbound.conf
CMD unbound -d -v -c unbound.conf
