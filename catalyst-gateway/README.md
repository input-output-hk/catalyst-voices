# Catalyst Data Gateway

* [Catalyst Data Gateway](#catalyst-data-gateway)
    * [Code Organization](#code-organization)
        * [`./bin`](#bin)
        * [`./event-db`](#event-db)
    * [Build and Run](#build-and-run)
        * [Docker images](#docker-images)
            * [Build](#build)
            * [Run](#run)
        * [Rust binary](#rust-binary)
            * [Build](#build-1)
            * [Run](#run-1)

The Catalyst Data Gateway is the backend of the Catalyst Voices hosted stack.

It provides the backend data infrastructure to the catalyst central databases.
In future it will also act as a gateway from Centralized catalyst infrastructure to decentralized infrastructure.

## Code Organization

### `./bin`

This is the main Catalyst Gateway Application.

### `./event-db`

Defines the Postgres Catalyst Event Database that the Catalyst gateway uses for running Catalyst Events.
This is DB definition and data only, the actual db interface code is located at `./bin/src/event-db`.

## Build and Run

There are several options how you can build this service,
as a Rust binary from the Rust code explicitly,
or you can build a docker image and run everything with the `docker-compose`.

### Docker images

To build and run docker images follow these steps:

#### Build

* Build `cat-gateway`:

```sh
earthly ./catalyst-gateway+docker
```

* Build `event-db`:

```sh
earthly ./catalyst-gateway/event-db+docker
```

#### Run

```sh
docker compose -f ./catalyst-gateway/docker-compose.yml up cat-gateway
```

### Rust binary

To build and run `cat-gateway` natively,
as a first step it will be needed to anyway build and run `event-db` and `index-db` as docker containers

#### Build

* Build `cat-gateway`:

```sh
cd catalyst-gateway
cargo b --release
```

* Build `event-db`:

```sh
earthly ./catalyst-gateway/event-db+docker
```

#### Run

* Run `event-db` and `index-db`:

```sh
docker compose -f ./catalyst-gateway/docker-compose.yml up event-db index-db
```

* Run `cat-gateway`:

```sh
export SIGNED_DOC_SK="0x6455585b5dcc565c8975bc136e215d6d4dd96540620f37783c564da3cb3686dd"
export CHAIN_NETWORK="Preprod"
export INTERNAL_API_KEY="123"
export EVENT_DB_URL="postgres://catalyst-event-dev:CHANGE_ME@localhost:5432/CatalystEventDev"
./catalyst-gateway/target/release/cat-gateway run
```

To enable optional telemetry, the following environment variables must be added:

```sh
export OTEL_EXPORTER_OTLP_ENDPOINT=http://jaeger:4317
export OTEL_SERVICE_NAME=cat-gateway
export TELEMETRY_ENABLED=true
```
