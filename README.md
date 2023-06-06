# Resolver Lab

This repository is a collection of DNS resolvers running in docker containers
orchastrated by docker compose.

Currently the lab only consists of Unbound 1.17.1 running on 10.0.53.1

## How to run
Make sure that you have [docker/-compose](https://docs.docker.com/engine/install/) as well as [dig](https://linux.die.net/man/1/dig) or equivalent.
```sh
sudo docker compose up -d
dig @10.0.53.1 www.example.com +short
sudo docker compose down
```

## Todo
- Bind9:latest
- Knot-Resolver:latest
- PowerDNS:latest
- QNAME Minimization configs
- Older versions of resolvers
- Recursive resolver for forwarding
