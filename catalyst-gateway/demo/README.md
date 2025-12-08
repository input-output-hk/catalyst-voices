# Catalyst Gateway Telemetry Demo

The intention for this demonstration is to show how to enable Telemetry for Catalyst Gateway using the OpenTelemetry.

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
