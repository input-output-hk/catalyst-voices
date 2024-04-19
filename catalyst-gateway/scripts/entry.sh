#!/bin/bash

# ---------------------------------------------------------------
# Entrypoint script for cat-gateway container
# ---------------------------------------------------------------
#
# This script serves as the entrypoint for the cat-gateway service container. 
#
# It expects the following environment variables to be set except where noted:
#
# DB_URL - URL for the EventDB.
# CAT_ADDRESS - Address to bind the cat-gateway service to.
# LOG_LEVEL - Log level for the cat-gateway service.
# DEBUG_SLEEP - If set, the script will sleep for the specified number of seconds (optional)
# ---------------------------------------------------------------


check_env_vars() {
    local env_vars=("$@")

    # Iterate over the array and check if each variable is set
    for var in "${env_vars[@]}"; do
        if [ -z "${!var}" ]; then
            echo ">>> Error: $var is required and not set."
            exit 1
        fi
    done
}

debug_sleep() {
    if [ -n "${DEBUG_SLEEP:-}" ]; then
        echo "DEBUG_SLEEP is set. Sleeping for ${DEBUG_SLEEP} seconds..."
        sleep "${DEBUG_SLEEP}"
    fi
}

echo ">>> Starting entrypoint script..."

# Check if all required environment variables are set
REQUIRED_ENV=(
    "DB_URL"
    "CAT_ADDRESS"
    "LOG_LEVEL"
)
check_env_vars "${REQUIRED_ENV[@]}"

# Sleep if DEBUG_SLEEP is set
debug_sleep

# Define the command to be executed
ARGS=$*
CMD="./cat-gateway run --address $CAT_ADDRESS --database-url $DB_URL --log-level $LOG_LEVEL $ARGS"
echo ">>> Executing command: $CMD"

# Wait for DEBUG_SLEEP seconds if the DEBUG_SLEEP environment variable is set
if [ -n "${DEBUG_SLEEP:-}" ]; then
  echo "DEBUG_SLEEP is set to $DEBUG_SLEEP. Sleeping..."
  sleep "$DEBUG_SLEEP"
fi

# Expand the command with arguments and capture the exit code
set +e
eval "$CMD"
EXIT_CODE=$?
set -e

# If the exit code is 0, the executable returned successfully
if [ $EXIT_CODE -ne 0 ]; then
  echo "Error: cat-gateway returned with exit code $EXIT_CODE"
  exit 1
fi