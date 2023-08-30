# Debugging Tools

Add the following lines to the Dockerfile:

```
RUN apt-get update && apt-get upgrade -y
RUN apt-get install curl vim net-tools tmux dnsutils -y
```
