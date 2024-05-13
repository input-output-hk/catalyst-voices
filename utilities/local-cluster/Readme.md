# Local Cluster

Integration Tests and local testing will require a running local cluster.
To eliminate variability and simplify local deployment, we have standardized the local cluster around:

* [VirtualBox](https://www.virtualbox.org/)
* [Vagrant](https://developer.hashicorp.com/vagrant/install?product_intent=vagrant)

These tools allow us to define VMs that are consistent and provide a uniform Kubernetes environment
for local testing.

## Cluster Architecture

The Cluster is based on [K3s](https://k3s.io/), which is a lightweight version of Kubernetes.

We set up 1 server node which hosts the control-plane and is the master node.
Configured with:

* 2 Cores
* 2 GB of RAM

It has 3 Internal nodes, configured as:

* 4 Cores
* 4 GB of RAM

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
