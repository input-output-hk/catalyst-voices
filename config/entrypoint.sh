#!/usr/bin/env bash

set -euo pipefail

MAX_RETRIES=${MAX_RETRIES:-3}
RETRY_DELAY=${RETRY_DELAY:-5}

if [ -z "${ENVIRONMENT:-}" ]; then
    echo "ENVIRONMENT is not set"
    exit 1
fi

if [ -z "${API_KEY:-}" ]; then
    echo "API_KEY is not set"
    exit 1
fi

echo ">>> Running: uv run python set_config.py ${ENVIRONMENT}"

set +e
attempt=1
while [ $attempt -le "${MAX_RETRIES}" ]; do
    echo ">>> Attempt $attempt of ${MAX_RETRIES}"

    if uv run python set_config.py "${ENVIRONMENT}"; then
        echo ">>> Command succeeded on attempt $attempt"
        exit 0
    else
        echo ">>> Command failed on attempt $attempt"

        if [ $attempt -eq "${MAX_RETRIES}" ]; then
            echo ">>> All ${MAX_RETRIES} attempts failed. Exiting with error code."
            exit 1
        fi

        echo ">>> Waiting ${RETRY_DELAY} seconds before retry..."
        sleep "${RETRY_DELAY}"
        attempt=$((attempt + 1))
    fi
done