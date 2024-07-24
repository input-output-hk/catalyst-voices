# use with https://github.com/casey/just
#

# cspell: words prereqs, commitlog

default:
    @just --list --unsorted

# Format the rust code
code_format:
    cd catalyst-gateway && cargo +nightly fmtfix

# Start the development cluster - linux/windows x86_64
run-cat-gateway: code_format
    cd catalyst-gateway && cargo build -r 
    ./catalyst-gateway/target/release/cat-gateway run
