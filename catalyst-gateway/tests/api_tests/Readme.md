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

### Get binary for building and signing Catalyst Signed Document objects

* compile a [`mk_singed_doc` cli tool](https://github.com/input-output-hk/catalyst-libs/tree/r20250416-00/rust/signed_doc)
  (version tag `r20250416-00`)
* Copy this binary under this directory `api_tests`

```shell
git clone https://github.com/input-output-hk/catalyst-libs.git
cd catalyst-libs/rust
git checkout r20250416-00
cargo b --release -p catalyst-signed-doc
cp ./target/release/mk_singed_doc <path>/api_tests
```

### Running tests

* First install [`poetry` link](https://github.com/python-poetry/poetry)
* Install dependencies (from 'api_tests' directory):

```shell
poetry install
```

* Get the `cardano-asset-preprod.json` file from the
   [catalyst-voices2 repository](https://github.com/input-output-hk/catalyst-storage/blob/main/cardano-asset-preprod.json)
* Copy this file to directory `api_tests`
* Set up env variables:

```shell
export CAT_GATEWAY_INTERNAL_API_KEY="123"
export ASSETS_DATA_PATH="cardano-asset-preprod.json"
export CAT_GATEWAY_TEST_URL="http://127.0.0.1:3030"
export EVENT_DB_TEST_URL="postgres://catalyst-event-dev:CHANGE_ME@localhost/CatalystEventDev"
```

* Run the tests, by specifying one of the markers:

  * ci (marks tests to be run in ci),
  * nightly (marks tests to be run nightly),
  * preprod_indexing (marks test which requires indexing of the cardano preprod network),
  * health_endpoint (marks tests with requires a proxy for testing)

```shell
poetry run pytest -s -m <marker>
```
