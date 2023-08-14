FROM ubuntu
ARG VERSION=5.6.0
WORKDIR /root
RUN apt update && apt upgrade -y
RUN apt install -y build-essential libssl-dev meson libuv1-dev luajit libluajit-5.1-dev wget git
# Installl libknot
RUN git clone https://gitlab.nic.cz/knot/knot-dns.git
RUN apt-get install -y libtool autoconf automake make pkg-config \
    liburcu-dev libgnutls28-dev libedit-dev liblmdb-dev
WORKDIR /root/knot-dns
RUN autoreconf -if
RUN ./configure && make && make install
RUN ldconfig
# Install knot resolver
WORKDIR /root
RUN wget https://secure.nic.cz/files/knot-resolver/knot-resolver-${VERSION}.tar.xz
RUN tar -xf knot-resolver-${VERSION}.tar.xz
WORKDIR /root/knot-resolver-${VERSION}
RUN meson setup build_dir --prefix=/tmp/kr --default-library=static
RUN ninja -C build_dir
RUN ninja install -C build_dir
ARG QMIN=relaxed
COPY ${QMIN}.conf knot.conf
CMD /tmp/kr/sbin/kresd -nv -c knot.conf
