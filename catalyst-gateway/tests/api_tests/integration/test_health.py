import time
import pytest
import os

from utils import health
from scripts import panic_requests

LIVE_THRESHOLD = int(os.getenv("SERVICE_LIVE_COUNTER_THRESHOLD"))
LIVE_TIMEOUT = int(os.getenv("SERVICE_LIVE_TIMEOUT_INTERVAL"))

@pytest.mark.health_endpoint
@pytest.mark.asyncio
async def test_live_endpoint_panic_under_threshold_with_reset():
    health.is_ready() #assertion
    health.is_live() #assertion
    await panic_requests.hit_panic_endpoint(LIVE_THRESHOLD)
    health.is_live() #assertion
    #wait for panic counter reset
    time.sleep(LIVE_TIMEOUT + 1)
    await panic_requests.hit_panic_endpoint(LIVE_THRESHOLD)
    health.is_live() #assertion

@pytest.mark.health_endpoint
@pytest.mark.asyncio
async def test_live_endpoint_panic_threshold_exceeded():
    health.is_ready() #assertion
    health.is_live() #assertion
    await panic_requests.hit_panic_endpoint(LIVE_THRESHOLD)
    time.sleep(LIVE_TIMEOUT/2)
    await panic_requests.hit_panic_endpoint(1)
    health.is_ready() #assertion
    health.is_not_live() #assertion
