#!/bin/sh

# ---------------------------------------------------------------
# Check if endpoint returns expected status code
# ---------------------------------------------------------------
#
# It expects the following environment variables to be set:
#
# URL - Endpoint's URL.
# STATUS - Expected return code.
# MAX_RETRIES - Max retries.
# SLEEP_SECONDS - Wait between retries in seconds.
# ---------------------------------------------------------------

URL="$1"
STATUS="$2"
MAX_RETRIES="$3"
SLEEP_SECONDS="$4"

COUNT=0
echo "Waiting for 204 from $URL for $((MAX_RETRIES*SLEEP_SECONDS)) seconds..."

until [ $COUNT -ge $MAX_RETRIES ]; do
  ACTUAL_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
  echo "Attempt $((COUNT+1)): HTTP $ACTUAL_STATUS"

  if [ "$ACTUAL_STATUS" -eq $STATUS ]; then
    echo "✅ Received $STATUS"
    exit 0
  fi

  COUNT=$((COUNT+1))
  sleep $SLEEP_SECONDS
done

echo "❌ Did not receive $STATUS after $MAX_RETRIES attempts"
exit 1
