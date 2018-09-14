# Overview

Sample Kubernetes config to set up a Consul cluster, using vSphere storage.

# Usage

Create the cluster with

```
kubectl apply -f consul-server.yaml
```

and expose externally with

```
kubectl apply -f consul-proxy.yaml
```

# Agent usage in pods

When using the agent in a pod, you should include a container spec similiar to the following:

```
- name: consul
  image: topaztechnology/consul:1.0.6
  ports:
  - name: http
    containerPort: 8500
  - name: consuldns
    containerPort: 8600
  env:
  - name: CONSUL_TYPE
    value: agent
  volumeMounts:
    - name: consul-data
      mountPath: /consul/data
```
