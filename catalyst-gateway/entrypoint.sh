#!/usr/bin/env bash

if [[ -n "${DEBUG_SLEEP}" ]]; then
    echo "Sleeping for ${DEBUG_SLEEP} seconds..."
    sleep "${DEBUG_SLEEP}"
fi

args+=()
args+=("run" "--log-level" "debug")

echo "Starting gateway node..."
"/app/cat-gateway" "${args[@]}"
exit_code=$?

if [[ $exit_code -ne 0 && -n "${DEBUG_SLEEP_ERR}" ]]; then
    echo "Process exited with code $exit_code. Sleeping for ${DEBUG_SLEEP_ERR} seconds..."
    sleep "${DEBUG_SLEEP_ERR}"
fi

exit $exit_code
