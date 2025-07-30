# Running integration tests

All current setup of running different kinds of integration tests are packed as a docker images.
So to run any of the corresponding tests runner it could be done using already set `docker-compose.yml` file.

As a first step to prepare all required docker images run:

```shell
earthly +prepare-all-images
```

## API tests

```shell
docker compose up api-tests-runner --abort-on-container-exit --exit-code-from api-tests-runner
```

## Schemathesis

```shell
docker compose up schemathesis-runner --abort-on-container-exit --exit-code-from schemathesis-runner
```

## Postgres and Scylla tests

```shell
docker compose up postgres-scylla-runner --abort-on-container-exit --exit-code-from postgres-scylla-runner
```
