from api_tests.endpoints.v1 import health
from loguru import logger

def is_live():
    resp = health.live
    assert resp.status_code == 204, f"Service is expected to be live: {resp.status_code} - {resp.text}"
    logger.info("cat-gateway service is LIVE.")

def is_ready():
    resp = health.ready
    assert resp.status_code == 204, f"Service is expected to be ready: {resp.status_code} - {resp.text}"
    logger.info("cat-gateway service is READY.")


def is_not_ready():
    resp = health.ready
    assert resp.status_code == 503, f"Service is expected to be unready: {resp.status_code} - {resp.text}"
    logger.info("cat-gateway service is NOT READY.")
