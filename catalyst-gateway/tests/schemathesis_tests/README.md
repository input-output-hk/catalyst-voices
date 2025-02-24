# Schemathesis local run

To locally run schemathesis against the locally running `cat-gateway` follow next steps:

1. Build `event-db` running

    ```shell
    earthly ./catalyst-gateway/event-db+build
    ```

2. Spin out `event-db` and scylla node running

    ```shell
    docker-compose -f ./catalyst-gateway/tests/docker-compose.yml up event-db scylla-node --detach
    ```

3. Compile and run `cat-gateway` also specifying necessary evn vars

    ```shell
    cd catalyst-gateway
    cargo b
    export EVENT_DB_URL="postgres://catalyst-event-dev:CHANGE_ME@localhost:5432/CatalystEventDev"
    export RBAC_OFF=True
    export CHAIN_NETWORK="Preprod"
    ./target/debug/cat-gateway run
    ```

4. Build a schemathesis docker image

    ```shell
    earthly ./catalyst-gateway/tests/schemathesis_tests+package-schemathesis \
    --api_spec="http://host.docker.internal:3030/docs/cat-gateway.json" \
    --wait_for_schema=500 \
    --max_response_time=5000 \
    --hypothesis_max_examples=10
    ```

5. Run schemathesis docker container

    ```shell
    docker run --name st schemathesis:latest
    ```

6. To get the schemathesis logs run

    ```shell
    docker cp st:/results/cassette.yaml cassette.yaml
    ```
