# Local Cluster

* [Local Cluster](#local-cluster)
  * [Requirements](#requirements)
  * [Cluster Architecture](#cluster-architecture)
  * [Default Services](#default-services)
    * [Scylla DB](#scylla-db)
  * [Deploying the Cluster](#deploying-the-cluster)
    * [Setup hosts on Windows](#setup-hosts-on-windows)
    * [Startup](#startup)
      * [Linux/Windows](#linuxwindows)
      * [macOS](#macos)
    * [Getting Basic Cluster details](#getting-basic-cluster-details)
    * [Suspending the Cluster](#suspending-the-cluster)
    * [Resuming a suspended the Cluster](#resuming-a-suspended-the-cluster)
    * [Stopping the Cluster](#stopping-the-cluster)
  * [Catalyst Voices Services](#catalyst-voices-services)
    * [Deploying Catalyst Voices Frontend and Backend Services](#deploying-catalyst-voices-frontend-and-backend-services)
    * [Deploying Catalyst Voices Documentation Service](#deploying-catalyst-voices-documentation-service)
  * [Debugging the cluster](#debugging-the-cluster)
    * [SSH into a running VM](#ssh-into-a-running-vm)
  * [Local UI to access ScyllaDB](#local-ui-to-access-scylladb)
  * [Troubleshooting](#troubleshooting)
    * [Issues with Vagrant configurations](#issues-with-vagrant-configurations)
    * [Issues with running command with just](#issues-with-running-command-with-just)
    * [Vagrant cannot forward the specified ports on a VM](#vagrant-cannot-forward-the-specified-ports-on-a-vm)

## Requirements

Integration Tests and local testing will require a running local cluster.
To eliminate variability and simplify local deployment, we have standardized the local cluster around:

* [VirtualBox](https://www.virtualbox.org/) for Linux or [Parallels](https://www.parallels.com/) for macOS
* [Vagrant](https://developer.hashicorp.com/vagrant/install?product_intent=vagrant)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)
* [helm](https://helm.sh/docs/intro/install/)
* [just](https://github.com/casey/just)


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

These services are installed by default and provide the basic management and monitoring of the cluster.

* [Container Registry API](http://registry.cluster.test/v2/)
  * [HTTPS](https://registry.cluster.test/v2/)
  * [192.168.58.10:5000](http://192.168.58.10:5000)
* [Container Registry Web UI](http://registry-ui.cluster.test/)
  * Note: HTTPS not supported currently for this UI.
* [Traefik Ingress Dashboard](http://traefik.cluster.test/)
  * [HTTPS](https://traefik.cluster.test/)
  * [192.168.58.10:3000](http://192.168.58.10:3000)
* [Grafana Dashboard](http://grafana.cluster.test/)
  * [HTTPS](https://grafana.cluster.test/)
* [Prometheus Dashboard](http://prometheus.cluster.test/)
  * [HTTPS](https://prometheus.cluster.test/)
* [Alert manager UI](http://alert-manager.cluster.test/)
  * [HTTPS](https://alert-manager.cluster.test/)

### Scylla DB

This service is provisioned globally for use by services in the cluster.
It does not have a UI outside any Grafana dashboards that are installed.

For testing purposes, the ScyllaDB is accessible on the Cluster IP Address: `192.168.58.10`.

## Deploying the Cluster

### Setup hosts on Windows

On Windows you need to setup the hosts before starting the cluster
From Windows terminal open the hosts file:

```sh
notepad %SystemRoot%\System32\drivers\etc\hosts
```

and copy the hosts from `./shared/extra.hosts` into the Windows host file

### Startup

#### Linux/Windows

From the root of the repo:

```sh
just start-cluster
```

#### macOS

From the root of the repo:

```sh
just start-cluster-aarch64-macos
```

### Getting Basic Cluster details

From the root of the repo:

```sh
just show-cluster
```

Note the report is **VERY** Wide.
Best viewed with a small terminal font.

### Suspending the Cluster

The cluster can be suspended to save local system resources, without tearing it down.

```sh
just suspend-cluster
```

### Resuming a suspended the Cluster

The suspended cluster can then be resumed with:

```sh
just resume-cluster
```

### Stopping the Cluster

```sh
just stop-cluster
```

## Catalyst Voices Services

These services are not deployed by default.

* [Catalyst Voices Frontend](http://voices.cluster.test/)
  * [HTTPS](https://voices.cluster.test/)
* [Catalyst Voices Backend](http://voices.cluster.test/api/)
  * [HTTPS](https://voices.cluster.test/api/)
* [Catalyst Voices Documentation](http://docs.voices.cluster.test/)
  * [HTTPS](https://docs.voices.cluster.test/)

### Deploying Catalyst Voices Frontend and Backend Services

TODO.

### Deploying Catalyst Voices Documentation Service

From the root of the repo:

 1. Make sure the documentation is built, and its container pushed to the container repo:

  ```sh
  earthly --push ./docs+local
  ```
<!-- markdownlint-disable-next-line ol-prefix -->
2. Deploy the Documentation Service:

  ```sh
  earthly ./utilities/local-cluster+deploy-docs
  ```

<!-- markdownlint-disable-next-line ol-prefix -->
3. Stop the Documentation Service:

  ```sh
  earthly ./utilities/local-cluster+stop-docs
  ```

## Debugging the cluster

### SSH into a running VM

To SSH into a VM running the cluster, use `vagrant`:

```sh
vagrant ssh control
```

```sh
vagrant ssh agent86
```

```sh
vagrant ssh agent99
```

## Local UI to access ScyllaDB

Found (and tested) description how to connect using only open-source via DBeaver:

1. Download dbeaver (Community Edition) [dbeaver](https://dbeaver.io/download)
2. Download cassandra jdbc jar files: [cassandra-jdbc-drive](http://www.dbschema.com/cassandra-jdbc-driver.html)
   (Downloading and Testing the Driver Binaries section have links to binary and source)
3. Extract Cassandra JDBC zip
4. Run DBeaver
5. Go to `Database` > `Driver Manager`
6. Click `New`
7. Fill in details as follows:
   * Driver Name: `Cassandra` (or whatever you want it to say)
   * Driver Type: `Generic`
   * Class Name: `com.dbschema.CassandraJdbcDriver`
   * URL Template: `jdbc:cassandra://{host}[:{port}][/{database}]`
   * Default Port: `9042`
   * Embedded: `no`
   * Category:
   * Description: `Cassandra` (or whatever you want it to say)
8. Click Add File and add all the jars in the Cassandra JDBC zip file.
9. Click Find Class to make sure the Class Name is found okay.
10. Click `OK`.
11. Create `New Connection`, selecting the database driver you just added.

## Troubleshooting

### Issues with Vagrant configurations

If you encounter any weird issues with the Vagrant, you can try the following:

```sh
rm -rf .vagrant
```
and then restart the cluster.

### Issues with running command with just

If you encounter any issues with running the commands with `just`,
you can try running the commands directly.

Instead of:

```sh
just stop-cluster
```

run:

```sh
vagrant destroy -f
```
For more see [justfile](./justfile)

### Vagrant cannot forward the specified ports on a VM

1. Check if Port 6443 is in Use:

```sh
sudo lsof -i :6443
```
You can see the output like this:

```sh
COMMAND     PID    USER   FD   TYPE             DEVICE SIZE/OFF NODE NAME
qemu-syst 42886 username   19u  IPv4 0x9af1245915ca3e76      0t0  TCP *:sun-sr-https (LISTEN)
```

The process qemu-syst (which stands for qemu-system), with PID 42886, is listening on port 6443.
This means that a QEMU virtual machine is currently running and using port 6443 on your host machine.

Since you’re using the QEMU provider with Vagrant, it’s likely that an existing VM is still running and occupying port 6443.
This is preventing your new Vagrant VM from forwarding port 6443, resulting in the error

2. List all running Vagrant VMs to see if any are currently active:

```sh
vagrant global-status
```

This command will list all Vagrant environments on your system. Look for any VMs that are in the running state.

```sh
id       name    provider   state   directory
--------------------------------------------------------------------------------------
abcd123  control qemu       running /path/to/your/project
abcd456  other qemu       running /another/project
```
3.  Halt or Destroy the Existing VM

If you find that a VM is running that you no longer need, you can halt or destroy it.

**To halt the VM:**

```sh
vagrant halt <id>
```

**To destroy the VM:**

```sh
vagrant destroy <id>
```

Replace <id> with the ID of the VM from the vagrant global-status output.
For example: `vagrant halt abcd123`

4. Kill the QEMU Process Manually (If Necessary)

If the VM is not managed by Vagrant, or if it did not shut down properly,
you may need to kill the QEMU process manually.

```sh
kill 42886
```

Replace 42886 with the PID from your lsof output.

5. Confirm the Process is Terminated:

```sh
sudo lsof -i :6443
```
This should return no output, indicating that no process is listening on port 6443.

6. Retry bringing up the Vagrant VM.
