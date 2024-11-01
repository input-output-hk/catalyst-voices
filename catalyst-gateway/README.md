# Catalyst Data Gateway

* [Catalyst Data Gateway](#catalyst-data-gateway)
  * [Code Organization](#code-organization)
    * [`./bin`](#bin)
    * [`./crates`](#crates)
    * [`./event-db`](#event-db)
  * [Build and Run](#build-and-run)
    * [Docker images](#docker-images)
    * [Rust binary](#rust-binary)

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
as a Rust binary from the Rust code explicitly,
or you can build a docker image and run everything with the `docker-compose`.

### Docker images

To build and run docker images follow these steps:

1. Run `earthly +package` to build a cat-gateway docker image.
2. Run `earthly ./event-db+build` to build an event-db docker image.
3. Run `docker-compose up cat-gateway` to spin up cat-gateway with event-db from already built images.

Note that every time when you are building an image it obsoletes an old image but does not remove it,
so don't forget to clean up dangling images of the event-db and cat-gateway in your docker environment.

### Rust binary

To build and run a Rust binary follow these steps:

1. Run `cargo build -p cat-gateway --release`
  to compile a release version of the cat-gateway
2. Run `earthly ./event-db+build` to build an event-db docker image
3. If you need to have a `preprod-snapshot` unarchive snapshot data to the `/tmp/preprod/` dir.
  You can download `preprod-snapshot` from this
  [resource](https://mithril.network/explorer/?aggregator=https%3A%2F%2Faggregator.release-preprod.api.mithril.network%2Faggregator).
4. Run

    ```sh
      ./target/release/cat-gateway run \
      --address "127.0.0.1:3030" \
      --database-url=postgres://catalyst-event-dev:CHANGE_ME@localhost/CatalystEventDev \
      --log-level=debug \
      --log-format=compact \
      --metrics-address "127.0.0.1:3032"
    ```
