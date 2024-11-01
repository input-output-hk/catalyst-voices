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
    earthly ./catalyst_voices+code-generator --platform=linux/amd64 --save_locally=true

# Run cat-gateway natively on preprod
run-cat-gateway: 
    just catalyst-gateway/run-cat-gateway

# Run cat-gateway natively on mainnet
run-cat-gateway-mainnet: 
    just catalyst-gateway/run-cat-gateway-mainnet

# Live rebuilds and deploys the documentation locally.
preview-docs:
    #
    # Documentation get deployed to localhost:8280.
    #
    # Currently live rebuild is naive, it just re-runs the earthly docs build every 10 seconds.
    # However, as earthly should cache most things on the first run, subsequent runs should only rebuild
    # the parts that have changed.
    # Deploys a nginx service using docker to port 8123, where a local version of the docs can be viewed.
    #
    # This target should be used by anyone updating code that will end up in the documentation to ensure
    # it looks correct.  It is faster than using github actions to check for you.
    #
    # Tasks which will update the documentation (non-exhaustive):
    #
    # 1. Editing markdown files under docs/
    # 2. Adding new markdown files under docs/
    # 3. Updating rust code (rust docs are embedding in the documentation)
    # 4. Updating Catalyst-Gateway OpenAPI endpoints (Published in the documentation)
    just utilities/docs-preview/preview-docs