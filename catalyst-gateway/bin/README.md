# Catalyst Gateway binary

Catalyst Gateway binary crate

## Build

```sh
cargo build -p cat-gateway
```

## Run

Before running `cat-gateway` you will need to spin up event-db.
How to do it, you can read this [README.md](
https://github.com/input-output-hk/catalyst-voices/blob/main/catalyst-gateway/event-db/Readme.md#starting-a-local-test-db-with-docker
).
To run with the specific jorm mock state cleanup timeout you can specify `JORM_CLEANUP_TIMEOUT` env var.

Run

```sh
cat-gateway run \
--address "127.0.0.1:3030" \
--database-url=postgres://catalyst-event-dev:CHANGE_ME@localhost/CatalystEventDev \
--log-level=debug \
--log-format=compact \
--metrics-address "127.0.0.1:3032"
```
