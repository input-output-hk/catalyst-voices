# Catalyst Data Gateway

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

### Local development

For the rust code `x86_64-unknown-linux-musl` target has been specified inside `.cargo/config.toml` file,
which means that in most cases it will be a cross compilation to this target.
On some platforms this can cause some issues,
so for local development as a temporary workaround specify your native target as follows:

```sh
CARGO_BUILD_TARGET=<your-native-target> cargo build/test/clippy
```
