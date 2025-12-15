#!/usr/bin/env bash

set -euo pipefail

RETRY_DELAY=${RETRY_DELAY:-5}

if [ -z "${ENVIRONMENT:-}" ]; then
    echo "ENVIRONMENT is not set"
    exit 1
fi

if [ -z "${CAT_GATEWAY_ADMIN_PRIVATE_KEY:-}" ]; then
    echo "CAT_GATEWAY_ADMIN_PRIVATE_KEY is not set"
    exit 1
fi

echo ">>> Running: uv run setup_fund.py ${ENVIRONMENT}"

set +e
attempt=1
while true; do
    echo ">>> Attempt $attempt"

    if uv run setup_fund.py "${ENVIRONMENT}"; then
        echo ">>> Command succeeded on attempt $attempt"
        exit 0
    else
        echo ">>> Command failed on attempt $attempt"

        echo ">>> Waiting ${RETRY_DELAY} seconds before retry..."
        sleep "${RETRY_DELAY}"
        attempt=$((attempt + 1))
    fi
done