# Resolver Lab

This repository is a collection of DNS resolvers running in docker containers
orchastrated by docker compose.

Currently the lab only consists of Unbound running on 10.0.53.1

## How to run
Make sure that you have [docker/-compose](https://docs.docker.com/engine/install/) as well as [dig](https://linux.die.net/man/1/dig) or equivalent.
```sh
sudo docker compose up -d
dig @10.0.53.1 www.example.com +short
dig @10.0.53.1 a.b.qnamemintest.net TXT +short
sudo docker compose down
```

You can also run the following to use host names in /etc/hosts:
```sh
sudo sh -c 'cat hosts >> /etc/hosts'
sudo docker compose up -d
dig @unbound.resolver www.example.com +short
dig @unbound.resolver a.b.qnamemintest.net TXT +short
sudo docker compose down
```

You can change the version of Unbound as well as the QNAME Minimzation setting in the [.env](.env) file
```
UNBOUND_VER=1.17.1
UNBOUND_QMIN=relaxed # off/relaxed/strict
```

## Todo
- PowerDNS
- Bind9
- Knot-Resolver
- Recursive resolver for forwarding
