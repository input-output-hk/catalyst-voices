"""Test the `catalyst-gateway` service when a DB schema mismatch occurs."""
from loguru import logger

from schema_mismatch import call_api_url, fetch_schema_version, change_version

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
