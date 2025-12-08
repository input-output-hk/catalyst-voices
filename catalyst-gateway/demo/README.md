# Catalyst Gateway Telemetry Demo

The intention for this demonstration is to show how to enable Telemetry for Catalyst Gateway using the OpenTelemetry.

## TLDR

Set the `TELEMETRY_ENABLED` env variable to _any_ value, and telemetry will be enabled.
Remove the env var for simple logging to stdout.

## Steps to run the demo

* Build the docker containers:

```sh
cd catalyst-voices/catalyst-gateway
earthly ./tests+all-images
```

* Start demo docker services

```sh
cd demo
docker compose up
```

This will start all the required services, including Jaeger.
You can look at the Jaeger UI at `http://localhost:16686/`.
