FROM ubuntu
WORKDIR /root
RUN apt update && apt upgrade -y
RUN apt install wget tar -y
RUN apt-get update && apt-get upgrade -y
RUN apt-get install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev -y
RUN wget https://www.python.org/ftp/python/3.8.3/Python-3.8.3.tgz
RUN tar -xf Python-3.8.3.tgz
WORKDIR Python-3.8.3
RUN ./configure --enable-optimizations
RUN make install
RUN python3 -m pip install dnslib
COPY ddnsserver.py ddnsserver.py
CMD ["python3", "ddnsserver.py"]
