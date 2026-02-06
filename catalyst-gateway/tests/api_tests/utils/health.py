import time
import requests
from loguru import logger

from api.v1 import health


def is_live(timeout=60):
    resp = poll(health.live(), 204, timeout)
    assert resp.status_code == 204, (
        f"Service is expected to be live: {resp.status_code} - {resp.text}\\n"
        f"{resp.url}"
    )
    logger.info("cat-gateway service is LIVE.")


def is_ready(timeout=60):
    url = health.ready()  # Log/print this!
    print(f"Polling {url} for 60s")  # Or logger.debug
    resp = poll(url, 204, timeout)
    if resp is None:
        raise AssertionError(f"Poll timed out after {timeout}s on {url}. Check service startup/bind.")
    assert resp.status_code == 204, (
        f"Expected 204: {resp.status_code} - {resp.text}\n{resp.url}"
    )
    logger.info("cat-gateway service is READY.")


def is_not_live(timeout=60):
    resp = poll(health.live(), 503, timeout)
    assert resp.status_code == 503, (
        f"Service is not expected to be live: {resp.status_code} - {resp.text}\\n"
        f"{resp.url}"
    )
    logger.info("cat-gateway service is NOT LIVE.")


def is_not_ready(timeout=60):
    resp = poll(health.ready(), 503, timeout)
    assert resp.status_code == 503, (
        f"Service is not expected to be ready: {resp.status_code} - {resp.text}\\n"
        f"{resp.url}"
    )
    logger.info("cat-gateway service is NOT READY.")


def poll(url, expected_response=204, timeout=60, interval=5):
    start_time = time.time()
    response = None

    while True:
        try:
            response = requests.get(url, timeout=10)
            if response.status_code == expected_response:
                return response
        except requests.RequestException:
            pass

        if time.time() - start_time > timeout:
            return response

        time.sleep(interval)
