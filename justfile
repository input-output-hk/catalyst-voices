# use with https://github.com/casey/just
#

# cspell: words prereqs, commitlog

default:
    @just --list --unsorted


# Fix and Check Markdown files
check-markdown:
    earthly +markdown-check-fix

# Check Spelling
check-spelling:
    earthly +clean-spelling-list
    earthly +check-spelling

# Pre Push Checks - intended to be run by a git pre-push hook.
pre-push: check-markdown check-spelling
    just catalyst-gateway/pre-push
    just catalyst_voices/pre-push
    earthly ./catalyst_voices+code-generator --platform=linux/amd64 --save_locally=true

# Run cat-gateway natively on preprod
run-cat-gateway: 
    just catalyst-gateway/run-cat-gateway

# Run cat-gateway natively on mainnet
run-cat-gateway-mainnet: 
    just catalyst-gateway/run-cat-gateway-mainnet
