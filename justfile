# use with https://github.com/casey/just
#

# cspell: words prereqs, commitlog

default:
    @just --list --unsorted

# Format the rust code
code_format:
    cd catalyst-gateway && cargo +nightly fmtfix

# Run cat-gateway natively on preprod
run-cat-gateway: code_format
    cd catalyst-gateway && cargo update && cargo build -r
    CHAIN_FOLLOWER_SYNC_TASKS="1" \
    RUST_LOG="info" \
    CHAIN_NETWORK="Preprod" \
    EVENT_DB_URL="postgres://catalyst-event-dev:CHANGE_ME@localhost/CatalystEventDev" \
    API_HOST_NAMES="http://localhost:3030" \
    ./catalyst-gateway/target/release/cat-gateway run --log-level debug

# Run cat-gateway natively on mainnet
run-cat-gateway-mainnet: code_format
    cd catalyst-gateway && cargo update && cargo build -r
    CHAIN_FOLLOWER_SYNC_TASKS="1" \
    RUST_LOG="error,cat-gateway=debug,cardano_chain_follower=debug,mithril-client=debug" \
    ./catalyst-gateway/target/release/cat-gateway run --log-level debug
