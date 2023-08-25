FROM ubuntu
ARG VERSION=9.13.3 
#9.18.15
WORKDIR /root
RUN apt update && apt upgrade -y
RUN apt install -y build-essential libssl-dev libuv1-dev perl libcap-dev pkg-config wget 
ARG EXT=gz
#xz
RUN wget https://downloads.isc.org/isc/bind9/${VERSION}/bind-${VERSION}.tar.${EXT}
RUN tar -xf bind-${VERSION}.tar.${EXT}
RUN chown 1000:1000 bind-${VERSION}
RUN chmod 777 bind-${VERSION}
WORKDIR /root/bind-${VERSION}
RUN ./configure --disable-doh && make && make install
ARG CONF=relaxed
COPY ${CONF}.conf named.conf
RUN ldconfig
CMD named -g -c named.conf
