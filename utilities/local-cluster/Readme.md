# Local Cluster

Integration Tests and local testing will require a running local cluster.
To eliminate variability and simplify local deployment, we have standardized the local cluster around:

* [VirtualBox](https://www.virtualbox.org/)
* [Vagrant](https://developer.hashicorp.com/vagrant/install?product_intent=vagrant)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)
* [helm](https://helm.sh/docs/intro/install/)

These tools allow us to define VMs that are consistent and provide a uniform Kubernetes environment
for local testing.

## Cluster Architecture

The Cluster is based on [K3s](https://k3s.io/), which is a lightweight version of Kubernetes.

We set up 1 server node which hosts the control-plane and is the master node.
Configured with:

* 4 Cores
* 5 GB of RAM

It has 3 Internal nodes, configured as:

* 4 Cores
* 4 GB of RAM

## Default Services

### Container Registry

### Traefik

### Grafana/Prometheus/Loki

## Interacting with the cluster

### Start the cluster

```sh
earthly +start-cluster
```

### Stop the cluster

```sh
earthly +stop-cluster
```

### Test if the cluster is visible locally

```sh
earthly +test-cluster
```

### Test if the cluster is visible inside Earthly docker containers

```sh
earthly +test-inside-earthly
```

## Debugging the cluster

### SSH into a running VM

To SSH into a VM running the cluster, use `vagrant`:

```sh
vagrant ssh server
```

```sh
vagrant ssh agent1
```

etc.

### Debug the local registry

The local registry is running inside docker, on the `server` VM.
First ssh into the VM.

To display the registry service logs:

```sh
docker logs registry
```
