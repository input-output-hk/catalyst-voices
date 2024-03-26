"""Test the `catalyst-gateway` service when a DB schema mismatch occurs."""

from loguru import logger
import asyncio
import asyncpg

from api_tests import DB_URL, call_api_url

GET_VERSION_QUERY = "SELECT MAX(version) FROM refinery_schema_history"
UPDATE_QUERY = "UPDATE refinery_schema_history SET version=$1 WHERE version=$2"


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


def check_is_live():
    resp = call_api_url("GET", "/api/health/live")
    assert resp.status == 204
    logger.info("cat-gateway service is LIVE.")


def check_is_ready():
    resp = call_api_url("GET", "/api/health/ready")
    assert resp.status == 204
    logger.info("cat-gateway service is READY.")


def check_is_not_ready():
    resp = call_api_url("GET", "/api/health/ready")
    assert resp.status == 503
    logger.info("cat-gateway service is NOT READY.")


def test_schema_version_mismatch_changes_cat_gateway_behavior():
    # Check that the `live` endpoint is OK
    check_is_live()

    # Check that the `ready` endpoint is OK
    check_is_ready()

    # Fetch current schema version from DB
    initial_version = fetch_schema_version()
    logger.info(f"cat-gateway schema version is: {initial_version}.")
    changed_version = initial_version + 1

    # Change version to a new value
    change_version(initial_version, changed_version)
    logger.info("Changed schema version in DB")

    # Fetch current schema version from DB
    current_version = fetch_schema_version()
    assert current_version == changed_version
    logger.info(f"cat-gateway schema version is: {changed_version}.")

    # Check that the `live` endpoint is OK
    check_is_live()

    # Check that the `ready` endpoint is NOT OK
    check_is_not_ready()

    # Change version back
    change_version(changed_version, initial_version)
    logger.info("Changed schema version back to original in DB")

    # Fetch current schema version from DB
    current_version = fetch_schema_version()
    assert current_version == initial_version
    logger.info(f"cat-gateway schema version is: {changed_version}.")

    # Check that the `ready` endpoint is OK
    check_is_ready()
