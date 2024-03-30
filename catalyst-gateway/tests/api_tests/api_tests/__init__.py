"""Utilities for testing schema mismatch behavior."""

from loguru import logger
import requests

DB_URL = "postgres://catalyst-event-dev:CHANGE_ME@localhost/CatalystEventDev"
DEFAULT_TIMEOUT = 10
CAT_GATEWAY_HOST = "127.0.0.1"
CAT_GATEWAY_PORT = 3030


def cat_gateway_endpoint_url(endpoint: str):
    return f"http://{CAT_GATEWAY_HOST}:{CAT_GATEWAY_PORT}/{endpoint}"


def check_is_live():
    resp = requests.get(cat_gateway_endpoint_url("api/health/live"))
    assert resp.status_code == 204
    logger.info("cat-gateway service is LIVE.")


def check_is_ready():
    resp = requests.get(cat_gateway_endpoint_url("api/health/ready"))
    assert resp.status_code == 204
    logger.info("cat-gateway service is READY.")


def check_is_not_ready():
    resp = requests.get(cat_gateway_endpoint_url("api/health/ready"))
    assert resp.status_code == 503
    logger.info("cat-gateway service is NOT READY.")


def get_sync_state(network: str):
    resp = requests.get(
        cat_gateway_endpoint_url(f"api/cardano/sync_state?network={network}")
    )
    assert resp.status_code == 200 or resp.status_code == 404
    if resp.status_code == 200:
        return resp.json()
