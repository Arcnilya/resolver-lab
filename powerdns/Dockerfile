FROM ubuntu
ARG VERSION=4.8.4
ARG QMIN=relaxed
WORKDIR /root
RUN apt update && apt upgrade -y
RUN apt-get install -y libboost-dev libboost-filesystem-dev libboost-serialization-dev \
   libboost-system-dev libboost-thread-dev libboost-context-dev \
   libboost-test-dev libssl-dev libboost-test-dev g++ make pkg-config \
   libluajit-5.1-dev wget
#RUN apt install -y build-essential libssl-dev libexpat1-dev bison flex wget 
RUN apt install -y net-tools iproute2 iputils-ping
RUN wget https://downloads.powerdns.com/releases/pdns-recursor-${VERSION}.tar.bz2
RUN tar xf pdns-recursor-${VERSION}.tar.bz2
WORKDIR /root/pdns-recursor-${VERSION}
RUN ./configure
RUN make
RUN make install
#todo
RUN mkdir config
RUN mkdir /var/run/pdns-recursor
COPY ${QMIN}.conf config/recursor.conf 
CMD pdns_recursor --config-dir=config
