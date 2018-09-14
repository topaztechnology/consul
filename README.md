# Supported tags and respective `Dockerfile` links
* `latest` [(Dockerfile)](https://github.com/topaztechnology/consul/blob/master/Dockerfile) - the latest release
* `1.0.6` [(Dockerfile)](https://github.com/topaztechnology/consul/blob/master/Dockerfile) - release based on Consul 1.0.6

# Overview

A Consul image built on the Alpine base image, using Joyent's [Containerpilot](https://www.joyent.com/containerpilot) to manage job scheduling.

It is designed to be used either standalone, in a docker-compose stack, or in a Kubernetes StatefulSet.

It can also run in server or agent mode.

# How to use this image

```
docker run --name consul --hostname consul -e 'CONSUL_TYPE=server' -p 8500:8500 -p 8600:8600 -v consul-data:/consul/data topaztechnology/consul:latest
```

# Environment variables

* **CONSUL_TYPE** : either `server` or `agent`. The agent will look for a host called `consul`, which could be a container in a docker-compose stack, or a Kubernetes service.
