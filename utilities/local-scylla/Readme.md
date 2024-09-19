# Local Scylla Cluster

This is a setup for a local Scylla cluster using Docker for local testing and development.

## Prerequisites

* [Just](https://github.com/casey/just)
* [Docker](https://www.docker.com/)

## Cluster Architecture

The Cluster is based Scylla published docker images.

The Cluster is 4 nodes, consisting of 2 cores each, and 1GB of ram.
They are exposed on ports 9042-9045.

## Starting the Scylla Cluster

```sh
just 

## Getting Cluster Status and Metrics

### Setup hosts on Windows

On Windows, you need to set up the hosts before starting the cluster  
From the Windows terminal to open the hosts file:  

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

1. Download DBeaver (Community Edition)
2. Download Cassandra JDBC jar files: <http://www.dbschema.com/cassandra-jdbc-driver.html>
   (Downloading and Testing the Driver Binaries section have links to binary and source)
3. extract Cassandra JDBC zip
4. run DBeaver
5. go to Database > Driver Manager
6. click New
7. Fill in details as follows:
   * Driver Name: `Cassandra` (or whatever you want it to say)
   * Driver Type: `Generic`
   * Class Name: `com.dbschema.CassandraJdbcDriver`
   * URL Template: `jdbc:cassandra://{host}[:{port}][/{database}]`
   * Default Port: `9042`
   * Embedded: `no`
   * Category:
   * Description: `Cassandra` (or whatever you want it to say)
8. click Add File and add all the jars in the Cassandra JDBC zip file.
9. click Find Class to make sure the Class Name is found okay
10. click OK
11. Create New Connection, selecting the database driver you just added
