"""Utilities for testing schema mismatch behavior."""

import asyncio
import asyncpg
import http.client

DB_URL = "postgres://catalyst-event-dev:CHANGE_ME@event-db/CatalystEventDev"
DEFAULT_TIMEOUT: int = 10
HOST = "gateway"
PORT = 3030

def call_api_url(method, endpoint, *args, **kwargs):
    client = http.client.HTTPConnection(HOST, PORT, timeout=DEFAULT_TIMEOUT)
    client.request(method, endpoint)
    resp = client.getresponse()
    client.close()
    return resp

