FROM ubuntu
ENV VERSION=old
RUN apt update && apt upgrade -y && apt install -y \
    tar \
    iproute2
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libreadline-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /root
ADD https://www.python.org/ftp/python/3.8.3/Python-3.8.3.tgz ./
RUN tar -xf Python-3.8.3.tgz
WORKDIR /root/Python-3.8.3
RUN ./configure --enable-optimizations && make install
RUN python3 -m pip install dnslib
COPY new new
COPY old old
COPY bootup.sh bootup.sh
CMD ./bootup.sh
