"""Utilities for testing schema mismatch behavior."""

import asyncio
import asyncpg
import http.client

GET_VERSION_QUERY = "SELECT MAX(version) FROM refinery_schema_history"
UPDATE_QUERY = "UPDATE refinery_schema_history SET version=$1 WHERE version=$2"

DB_URL="postgres://catalyst-event-dev:CHANGE_ME@event-db/CatalystEventDev"
DEFAULT_TIMEOUT: int = 10
HOST = "gateway"
PORT = 3030

def call_api_url(method, endpoint, *args, **kwargs):
    client = http.client.HTTPConnection(HOST, PORT, timeout=DEFAULT_TIMEOUT)
    client.request(method, endpoint)
    resp = client.getresponse()
    client.close()
    return resp

def fetch_schema_version():
    async def get_current_version():
        conn = await asyncpg.connect(DB_URL)
        if conn is None:
            raise Exception("no db connection found")

        version = await conn.fetchval(GET_VERSION_QUERY)
        if version is None:
            raise Exception("failed to fetch version from db")
        return version

    return asyncio.run(get_current_version())

def change_version(from_value: int, change_to: int):
    async def change_schema_version():
        conn = await asyncpg.connect(DB_URL)
        if conn is None:
            raise Exception("no db connection found for")

        update = await conn.execute(UPDATE_QUERY, change_to, from_value)
        if update is None:
            raise Exception("failed to fetch version from db")

    return asyncio.run(change_schema_version())
