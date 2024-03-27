"""Utilities for testing schema mismatch behavior."""

from loguru import logger
import http.client

DB_URL = "postgres://catalyst-event-dev:CHANGE_ME@localhost/CatalystEventDev"
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
