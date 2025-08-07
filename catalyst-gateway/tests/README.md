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

## Rust integration tests (a rust unit tests, which requires `event-db` or `index-db` instances)

```shell
docker compose up rust-tests-runner --abort-on-container-exit --exit-code-from rust-tests-runner
```

### NOTE

After running `rust-tests-runner` better always clean the state (with `docker compose down`),
these tests could it mess up with the random data.
