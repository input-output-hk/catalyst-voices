"""Utilities for testing schema mismatch behavior."""

import http.client

DB_URL = "postgres://catalyst-event-dev:CHANGE_ME@event-db/CatalystEventDev"
DEFAULT_TIMEOUT = 10
CAT_GATEWAY_HOST = "127.0.0.1"
CAT_GATEWAY_PORT = 3030


def call_api_url(method: str, endpoint: str):
    client = http.client.HTTPConnection(
        CAT_GATEWAY_HOST, CAT_GATEWAY_PORT, timeout=DEFAULT_TIMEOUT
    )
    client.request(method, endpoint)
    resp = client.getresponse()
    client.close()
    return resp
