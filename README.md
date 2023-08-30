# Resolver Lab

The Resolver Lab is a comprehensive platform that offers a controlled testing
environment where various DNS resolver implementations can be thoroughly
assessed and compared. At its core, the lab features dockerized resolver
containers for testing with variables for changing versions and configurations.
The Resolver Lab includes an authoritative name server for a custom top-level
domain, a suite of authoritative second-level domain name servers, and a
versatile client script for structured query testing. These components
collectively facilitate the analysis of resolver behavior under diverse
scenarios in an isolated environment entirely under the user's control.
Interacting with the resolvers and observing queries at the authoritative name
servers reveal valuable insights into resolver behavior and potential
vulnerabilities.

## Components
### Resolver Containers
The heart of the Resolver Lab is its collection of Dockerfiles, each tailored
to build a distinct open-source DNS resolver:
- [Unbound](https://nlnetlabs.nl/projects/unbound/about/) (/unbound)
- [Bind](https://www.isc.org/download/#BIND) (/bind)
- [Knot](https://www.knot-resolver.cz/) (/knot)
- [PowerDNS](https://www.powerdns.com/powerdns-recursor) (/powerdns)

By containerizing these resolvers, you can easily spin up stable instances for
testing. The directories also contain configuration files ending in .conf which
can be referenced in the .env file.

### Authoritative Name Server Containers
The lab includes an authoritative name server configured for the custom
top-level domain ".auth". This name server facilitates testing scenarios by
responding to queries for domains under the ".auth" domain.  Each of the four
resolvers have been configured to use this local authoritative name server when
looking up a domain ending with ".auth".  This is particularly useful for
observing resolver behavior when interacting with authoritative sources.  To
comprehensively analyze the behavior of recursive resolvers, the Resolver Lab
incorporates three name servers under the ".auth" zone:
- fpdns.auth (/fpdns.auth)
- oldqmin.auth (/qmin.auth)
- newqmin.auth (/qmin.auth)

These name servers are designed to interact with the resolvers and log queries
for analysis. This data serves as a valuable resource for assessing resolver
behaviour and potential vulnerabilities.

### Client Scripts
The client scripts bundled with the lab allows structured queries to be sent to 
a defined list of resolvers. The lab currently have the following scripts:
- one-to-many.py, takes a domain name and a list of resolvers

## How to run
Make sure that you have [docker/-compose](https://docs.docker.com/engine/install/) 
as well as [dig](https://linux.die.net/man/1/dig) or equivalent.
```sh
sudo docker compose up -d
dig @10.0.53.1 www.example.com +short
dig @10.0.53.1 a.b.newqmin.auth TXT +short
sudo docker compose down
```

You can also run the following to use host names in /etc/hosts:
```sh
sudo sh -c 'cat hosts >> /etc/hosts'
sudo docker compose up -d
dig @unbound.resolver www.example.com +short
dig @powerdns.resolver www.example.com +short
dig @bind.resolver www.example.com +short
dig @knot.resolver www.example.com +short
sudo docker compose down
```

### Testing with Different Versions
The Resolver Lab offers the flexibility to test different versions and
configurations of the resolvers. By modifying the contents of the environment
file (.env), you can build the resolver container to run specific versions and
configurations, facilitating direct comparisons between implementations.

```
UNBOUND_DFILE=default.Dockerfile #1.8.0.Dockerfile 
UNBOUND_VER=1.17.1 #1.8.0
UNBOUND_CONF=default # default/forward/qmin-off/-relaxed/-strict

BIND_DFILE=default.Dockerfile
BIND_VER=9.18.15 #9.13.3
BIND_CONF=default # default/forward/qmin-off/-relaxed/-strict
BIND_EXT=xz #gz

KNOT_DFILE=default.Dockerfile #3.0.0.Dockerfile
KNOT_VER=5.6.0 #3.0.0
KNOT_CONF=relaxed # default/forward/3.0.0

POWERDNS_DFILE=default.Dockerfile
POWERDNS_VER=4.8.4 #4.4.0
POWERDNS_CONF=forward # default/forward/qmin-off/-relaxed
```
