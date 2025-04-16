# Integration testing for DB Schema Version Mismatch behavior

Sets up a containerized environment with the `EventDB` and `catalyst-gateway` services running.

Integration tests are run in this environment that probe the behavior of the `catalyst-gateway` service in situations
where the DB schema version changes during execution, and creates a mismatch with the version that gateway service expects.

## Running Locally

* Spin up `scylla-node` and `event-db` databases

```shell
cd ..
docker compose up scylla-node event-db --detach
```

* Running a `catatalyst gateway`

```shell
cd ../..
cargo b --release
export EVENT_DB_URL="postgres://catalyst-event-dev:CHANGE_ME@localhost:5432/CatalystEventDev"
export CHAIN_NETWORK="Preprod"
export SIGNED_DOC_SK="0x6455585b5dcc565c8975bc136e215d6d4dd96540620f37783c564da3cb3686dd"
./target/release/cat-gateway run
```

* Also you need to compile a [`mk_singed_doc` cli tool](https://github.com/input-output-hk/catalyst-libs/tree/main/rust/signed_doc)
  (version `r20250416-00`),
which is used for building and signing Catalyst Signed Document objects.
And copy this binary under this directory `api_tests`.

```shell
git clone https://github.com/input-output-hk/catalyst-libs.git
cd catalyst-libs/rust
cargo b --release -p catalyst-signed-doc
cp ./target/release/mk_singed_doc <path>/api_tests
```

* Running tests

```shell
export EVENT_DB_TEST_URL="postgres://catalyst-event-dev:CHANGE_ME@localhost/CatalystEventDev"
export CAT_GATEWAY_TEST_URL="http://127.0.0.1:3030"
poetry run pytest -s -m preprod_indexing
```
