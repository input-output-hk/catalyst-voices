# Integration testing

Sets up a containerized environment with the `event-db` and `scylla-node` services running.

Integration tests are run in this environment that probes the behavior of the `catalyst-gateway` service in situations
where the DB schema version changes during execution, and creates a mismatch with the version that gateway service expects.

## Running Locally

### Spin up `scylla-node` and `event-db` databases as containers

```shell
cd ..
earthly ../../event-db+build
docker compose up scylla-node event-db --detach
```

### Run `catalyst gateway`

```shell
cd ..
cargo b --release
export EVENT_DB_URL="postgres://catalyst-event-dev:CHANGE_ME@localhost:5432/CatalystEventDev"
export CHAIN_NETWORK="Preprod"
export SIGNED_DOC_SK="0x6455585b5dcc565c8975bc136e215d6d4dd96540620f37783c564da3cb3686dd"
./target/release/cat-gateway run
```


### Running tests

* First install [`uv`](https://github.com/astral-sh/uv)
* Install dependencies (from 'api_tests' directory):

```shell
uv sync
```

* Get the `cardano-asset-preprod.json` file from the
   [catalyst-voices2 repository](https://github.com/input-output-hk/catalyst-storage/blob/main/cardano-asset-preprod.json)
* Copy this file to directory `api_tests`
* Set up env variables:

```shell
export CAT_GATEWAY_INTERNAL_API_KEY="123"
export ASSETS_DATA_PATH="cardano-asset-preprod.json"
export CAT_GATEWAY_TEST_URL="http://127.0.0.1:3030"
```

* Run the tests, by specifying one of the markers:

    * ci (marks tests to be run in ci),
    * nightly (marks tests to be run nightly),
    * preprod_indexing (marks test which requires indexing of the cardano preprod network),
    * health_endpoint (marks tests for health endpoint)
    * health_with_proxy_endpoint (marks tests for health endpoint which requires a proxy for testing)

```shell
uv run pytest -s -m <marker>
```

Additional steps for tests requiring proxy:

* build and run haproxy

```shell
    earthly +package-haproxy
    docker compose up haproxy --detach
```

* set cat-gateway DB urls to point to haproxy and start it

```shell
    EVENT_DB_URL=postgres://catalyst-event-dev:CHANGE_ME@haproxy:18080/CatalystEventDev
    CASSANDRA_PERSISTENT_URL=haproxy:18090
    CASSANDRA_VOLATILE_URL=haproxy:18090
```
