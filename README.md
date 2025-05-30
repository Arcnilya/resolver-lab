# Resolver Lab

The Resolver Lab is a comprehensive platform that offers a controlled testing
environment where various DNS resolver implementations can be thoroughly
assessed and compared. At its core, the lab features multiple dockerized resolver
containers. The images of these containers can be built using different versions of
the software. When running the container you can specify which configuration file
the resolver should use.

The Resolver Lab includes an authoritative name server for a pseudo-top-level
domain (.lab) and a suite of authoritative second-level domain name servers.
These components collectively facilitate the analysis of resolver behavior
under various scenarios in an isolated environment entirely under the user's
control. Interacting with the resolvers and observing queries at the
authoritative name servers reveal valuable insights into resolver behavior and
potential vulnerabilities.

## Components
### Docker compose file
The docker-compose.yml specifies a network and 9 services: 4 test resolvers, 1
auxilliary resolver, 1 authoritative TLD name server, and 3 authoritative SLD
name servers. 

### Resolver containers
The heart of the Resolver Lab is its collection of Dockerfiles, each tailored
to build a distinct open-source DNS resolver:
- [Unbound](https://nlnetlabs.nl/projects/unbound/about/) (/unbound) [10.0.53.1]
- [Bind](https://www.isc.org/download/#BIND) (/bind) [10.0.53.2]
- [Knot](https://www.knot-resolver.cz/) (/knot) [10.0.53.3]
- [PowerDNS](https://www.powerdns.com/powerdns-recursor) (/powerdns) [10.0.53.4]

We have added a build.sh script which takes the software and the version as parameters:
```bash
./build.sh unbound 1.23.0
```

By containerizing these resolvers, you can easily spin up stable instances for
testing. Each test resolver has a "configs" directory, containing configuration
files which can be set in *run-time* using environment variables specified in
the docker-compose.yml.

### Authoritative name server containers
The lab includes an authoritative TLD name server configured for the
pseudo-top-level *.lab* zone. This name server facilitates testing scenarios by
responding to queries for domains under the .lab zone.  Each of the four
resolvers have been configured to use this local authoritative TLD name server
when resolving a .lab domain. This is particularly useful for observing
resolver behavior when interacting with authoritative sources.  To
comprehensively analyze the behavior of recursive resolvers, the Resolver Lab
incorporates various authoritative SLD name servers in the .lab zone:
- fpdns.lab (/fpdns.lab)
- oldqmin.lab (/qmin.lab)
- newqmin.lab (/qmin.lab)
- polar.lab (/polar.lab)

These authoritative name servers are designed to interact with the resolvers
and log queries for analysis. This data serves as a valuable resource for
assessing resolver behaviour and potential vulnerabilities.

## How to run
Make sure that you have [docker/-compose](https://docs.docker.com/engine/install/) 
and [dig](https://linux.die.net/man/1/dig) or equivalent installed.
```sh
docker compose up -d
dig @10.0.53.1 www.example.com +short
dig @10.0.53.1 a.b.newqmin.lab TXT +short
docker compose down
```

You can also run the following to use host names in /etc/hosts:
```bash
sudo sh -c 'cat hosts >> /etc/hosts'
docker compose up -d
dig @unbound.resolver www.example.com +short
dig @powerdns.resolver www.example.com +short
dig @bind.resolver www.example.com +short
dig @knot.resolver www.example.com +short
docker compose down
```

When building new images, these are some nice debugging tools to include:
- vim
- net-tools
- tmux
- dnsutils
- iproute2

