FROM ubuntu
ARG VERSION=3.0.0
WORKDIR /root
RUN apt update && apt upgrade -y
RUN apt-get install -y pkg-config libknot-dev libuv1-dev libcmocka-dev libluajit-5.1-dev git wget bsdmainutils g++
# Installl libknot
#RUN git clone https://gitlab.nic.cz/knot/knot-dns.git
RUN apt-get install -y libtool autoconf automake make pkg-config \
    liburcu-dev libgnutls28-dev libedit-dev liblmdb-dev
RUN wget https://secure.nic.cz/files/knot-dns/knot-2.7.1.tar.xz
RUN tar -xf knot-2.7.1.tar.xz
WORKDIR /root/knot-2.7.1
#RUN autoreconf -if
RUN ./configure && make && make install
RUN ldconfig
# Install knot resolver
WORKDIR /root
RUN wget https://secure.nic.cz/files/knot-resolver/knot-resolver-${VERSION}.tar.xz
RUN tar -xf knot-resolver-${VERSION}.tar.xz
WORKDIR /root/knot-resolver-${VERSION}
#RUN git init
#RUN git submodule update --init --recursive
RUN make info
RUN make LDFLAGS="-Wl,-rpath=/usr/local/lib" PREFIX="/usr/local"
RUN make install PREFIX="/usr/local"
#RUN meson setup build_dir --prefix=/tmp/kr --default-library=static
#RUN ninja -C build_dir
#RUN ninja install -C build_dir
ARG CONF=3.0.0
COPY ${CONF}.conf knot.conf
CMD kresd -c knot.conf
#-v -c knot.conf
