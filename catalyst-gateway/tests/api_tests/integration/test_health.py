import time
import pytest
from utils import health
from scripts import panic_requests

@pytest.mark.health_endpoint
@pytest.mark.asyncio
async def test_live_endpoint_panic_under_threshold_with_reset():
    health.is_ready() #assertion
    health.is_live() #assertion
    await panic_requests.hit_panic_endpoint(100)
    health.is_live() #assertion
    #wait for panic counter reset
    time.sleep(30)
    await panic_requests.hit_panic_endpoint(100)
    health.is_live() #assertion

@pytest.mark.health_endpoint
@pytest.mark.asyncio
async def test_live_endpoint_panic_threshold_exceeded():
    health.is_ready() #assertion
    health.is_live() #assertion
    await panic_requests.hit_panic_endpoint(100)
    time.sleep(20)
    await panic_requests.hit_panic_endpoint(1)
    health.is_ready() #assertion
    health.is_not_live() #assertion

