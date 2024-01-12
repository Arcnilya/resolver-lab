FROM ubuntu
ARG VERSION=9.18.15
ENV CONFIG=default
WORKDIR /root
RUN apt update
RUN apt upgrade -y
#RUN apt install -y software-properties-common
#RUN rm -rf /var/lib/apt/lists/*
#RUN add-apt-repository ppa:deadsnakes/ppa
#RUN apt install -y python3.7
RUN apt install -y build-essential libssl-dev libuv1-dev perl libcap-dev pkg-config wget python3 python3-pip
ARG EXT=xz
RUN wget https://downloads.isc.org/isc/bind9/${VERSION}/bind-${VERSION}.tar.${EXT}
RUN tar -xf bind-${VERSION}.tar.${EXT}
RUN chown 1000:1000 bind-${VERSION}
RUN chmod 777 bind-${VERSION}
WORKDIR /root/bind-${VERSION}
RUN pip3 install ply
RUN ./configure --disable-doh && make && make install
COPY configs configs
COPY bootup.sh bootup.sh
RUN ldconfig
CMD ./bootup.sh
