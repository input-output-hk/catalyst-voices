# Catalyst Data Gateway

* [Catalyst Data Gateway](#catalyst-data-gateway)
  * [Code Organization](#code-organization)
    * [`./bin`](#bin)
    * [`./crates`](#crates)
    * [`./event-db`](#event-db)

The Catalyst Data Gateway is the backend of the Catalyst Voices hosted stack.

It provides the backend data infrastructure to the catalyst central databases.
In future it will also act as a gateway from Centralized catalyst infrastructure to decentralized infrastructure.

## Code Organization

### `./bin`

This is the main Catalyst Gateway Application.

### `./crates`

These are fully re-usable generalized `rust` crates that the Catalyst Gateway uses and are developed with it.
They are also able to be used stand-alone in other projects and can be published separately.

### `./event-db`

Defines the Postgres Catalyst Event Database that the Catalyst gateway uses for running Catalyst Events.
This is DB definition and data only, the actual db interface code is located at `./bin/src/event-db`.

## Build and Run

There are several options how you can build this service,
as a native binary from the Rust code explicitly,
or you can build a docker image and run everything with the `docker-compose`.

### Native binary

To build a native binary run

```sh
cargo build -p cat-gateway --release
```

and to run the service (but of course before running you need to spin up event-db [README.md](./event-db/Readme.md#starting-a-local-test-db-with-docker-and-earthly))

```sh
cat-gateway run \
--address "127.0.0.1:3030" \
--database-url=postgres://catalyst-event-dev:CHANGE_ME@localhost/CatalystEventDev \
--log-level=debug \
--log-format=compact \
--metrics-address "127.0.0.1:3032"
```

### Docker images

To build docker image of cat-gateway you can just run the following

```sh
earthly +package-cat-gateway
```

To build a cat-gateway with preprod snapshot data run

```sh
earthly +package-cat-gateway-with-preprod-snapshot
```