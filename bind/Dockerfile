FROM ubuntu
ARG VERSION=9.18.15
WORKDIR /root
RUN apt update && apt upgrade -y
RUN apt install -y build-essential libssl-dev libuv1-dev perl libcap-dev pkg-config wget 
RUN wget https://downloads.isc.org/isc/bind9/${VERSION}/bind-${VERSION}.tar.xz
RUN tar -xf bind-${VERSION}.tar.xz
WORKDIR /root/bind-${VERSION}
RUN ./configure --disable-doh
RUN make
RUN make install
ARG QMIN=relaxed
COPY ${QMIN}.conf named.conf
RUN ldconfig
CMD named -g -c named.conf
