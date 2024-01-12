FROM ubuntu
ENV VERSION=old
WORKDIR /root
RUN apt update && apt upgrade -y
RUN apt install wget tar iproute2 -y
RUN apt-get update && apt-get upgrade -y
RUN apt-get install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev -y
RUN wget https://www.python.org/ftp/python/3.8.3/Python-3.8.3.tgz
RUN tar -xf Python-3.8.3.tgz
WORKDIR Python-3.8.3
RUN ./configure --enable-optimizations
RUN make install
RUN python3 -m pip install dnslib
COPY new new
COPY old old
COPY bootup.sh bootup.sh
CMD ./bootup.sh
