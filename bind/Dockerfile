FROM ubuntu
ARG VERSION=9.18.15
ARG EXT=xz
ENV CONFIG=default
WORKDIR /root
RUN apt update && apt upgrade -y
RUN apt install -y \
    build-essential \
    libssl-dev \
    libuv1-dev \
    perl \
    libcap-dev \
    pkg-config \
    python3 \
    python3-pip \
    python3-ply
RUN apt install -y liburcu-dev
RUN rm -rf /var/lib/apt/lists/*
#RUN pip3 install ply
ADD https://downloads.isc.org/isc/bind9/${VERSION}/bind-${VERSION}.tar.${EXT} ./
RUN tar -xf bind-${VERSION}.tar.${EXT}
RUN chown 1000:1000 bind-${VERSION}
RUN chmod 777 bind-${VERSION}


WORKDIR /root/bind-${VERSION}
# Todo: enable doh
RUN ./configure --disable-doh --without-python 
RUN make 
RUN make install
RUN ldconfig
COPY configs configs
COPY bootup.sh bootup.sh
CMD ./bootup.sh
#CMD sleep infinity
