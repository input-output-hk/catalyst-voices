import pytest
from utils import health
from scripts import panic_requests

@pytest.mark.health_endpoint
@pytest.mark.asyncio
async def test_live_endpoint_panic_under_threshold():
    health.is_ready() #assertion
    health.is_live() #assertion
    await panic_requests.hit_panic_endpoint(100)
    health.is_live() #assertion
